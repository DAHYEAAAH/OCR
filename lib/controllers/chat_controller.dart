import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../model/message_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' hide Response;
import 'package:collection/collection.dart';
import 'package:socket_io_client/socket_io_client.dart';
import '../model/chat_model.dart';
import '../model/user_model.dart';
import '../views/chats/chat_room_view.dart';
import 'login_controller.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatController extends GetxController {

  var users = <User>[].obs;       // 채팅 유저 (본인 제외)
  var searchUsers = <User>[].obs; // 검색 유저
  var chats = <ChatModel>[].obs;
  RxList<ChatModel> searchChats = <ChatModel>[].obs;
  RxList<MessageModel> searchMessages = <MessageModel>[].obs;
  RxList<MessageModel> currentRoomMessages = <MessageModel>[].obs;
  var currentRoomName = ''.obs;
  var currentRoomUsers = <User>[].obs;       // 현재 채팅방 유저
  var currentRoomId = ''.obs;

  TextEditingController messageTextField = TextEditingController();
  TextEditingController groupTextField = TextEditingController();
  ScrollController scrollController = ScrollController();
  late IO.Socket _socket;
  LoginController loginController = Get.find();
  var myData = User().obs;

  String createCode = '';
  bool isCreator = false;
  bool isInviter = false;
  List<bool?> enterRoomList = [];

  @override
  void onInit() {
    super.onInit();
    connectAndListen();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void connectAndListen() {
    _socket = IO.io('wss://15.165.95.128:3000',
        OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .build());
    _socket.onConnect((_) {
      print('connect!!-');
    });

    _socket.onDisconnect((_) => print('disconnect'));

    // 그룹방 관련 이벤트 결과로 해당 사용자에 대한 모든 그룹방 리스트를 보여준다.
    _socket.on('receive_rooms', (data) {
      String event = data['event'];
      String roomId = data['roomId'];
      List<dynamic> result = data['roomsInfo'];
      chats.assignAll(result.map((data) => ChatModel.fromJson(data)).toList());

      // 채팅 리스트 초기화 후 대화 기록이 있는 채탕방만 불러옴
      searchChats.assignAll(chats.where((chat) => chat.roomLatestChat!.isNotEmpty && chat.roomUserList!.length > 1));

      if(enterRoomList.isNotEmpty) {
        searchChats.asMap().forEach((index, f) => f.isEnterRoom = enterRoomList[index]);
      }

      switch (event) {
        case 'get_rooms':
          print('get_rooms -> receive_rooms');
          for(var chat in searchChats) {
            print(chat.isEnterRoom);
            if (chat.isEnterRoom == false) {
              print('chat.isEnterRoom -> ${chat.isEnterRoom}');
              enterChatRoom(chat.roomId);
            }
          }
          break;

        case 'create_room':
          print('create_room -> receive_rooms');
          enterChatRoom(roomId);  // 모든 참여자 대화방에 입장

          // 방을 만든 사람만 채팅룸으로 이동 (receive_success 에서 혼자 받네? 거기로 수정해도 될듯??)
          if(isCreator) {
            if(createCode == 'single_new_chat') {
              Get.to(() => ChatRoomView(chatModel: chats.last));
            } else {
              Get.off(() => ChatRoomView(chatModel: chats.last));
            }
            isCreator = false;
          }
          break;

        case 'dropout_room':
          print('dropout_room -> receive_rooms');
          break;

        case 'invite_room':
          List<dynamic> userList = data['eventParams']['userList'];
          print('invite_room -> receive_rooms');

          List<String> userNameList = [];

          // 사용자 입장 알림
          for(var email in userList) {
            userNameList.add(users.where((element) => element.email == email).first.name!);
          }
          sendNotification(roomId: data['eventParams']['roomId'], chat: '${userNameList.join(', ')} 님이 대화방에 참여 하였습니다.');

          // 채팅방 참여자 목록 업데이트
          for(var email in userList) {
            if(email == myData.value.email) {
              currentRoomUsers.add(myData.value);
            } else {
              User? person = users.firstWhereOrNull((element) => element.email == email);
              currentRoomUsers.add(person!);
            }
          }

          // 초대된 사람 대화방에 입장
          if(userList.contains(myData.value.email)) {
            enterChatRoom(roomId);
          }

          // 초대한 사람 초대창 닫기
          if(isInviter) {
            Get.back();
            isInviter = false;
          }
          break;
      }
    });

    // 대화방의 채팅 히스토리 목록
    _socket.on('receive_previous_chats', (data) {
      print('- receive_previous_chats -');
      var chat = chats.where((element) => element.roomId == data['roomId']).first;
      List<dynamic> result = data['chatList'];

      chat.messages = <MessageModel>[];
      chat.messages!.assignAll(result.map((data) => MessageModel.fromJson(data)).toList());
      currentRoomMessages.assignAll(result.map((data) => MessageModel.fromJson(data)).toList().reversed);
    });

    // 현재 그룹방의 정보
    _socket.on('receive_current_room', (data) {
      print('receive_current_room');
      String event = data['event'];
      dynamic result = data['roomInfo'];
      currentRoomName.value = result['roomName'];

      ChatModel chat = chats.where((element) => element.roomId == result['roomId']).first;

      switch (event) {
        case 'enter_room':
          print('enter_room -> receive_current_room');
          // 해당 채팅룸 enter_room 확인 완료
          chat.isEnterRoom = true;
          break;

        case 'received_chat':
          print('received_chat -> receive_current_room');

          break;

        case 'rename_room':
          print('rename_room -> receive_current_room');
          ChatModel chat = chats.where((element) => element.roomId == result['roomId']).first;
          chat.roomName = result['roomName'];
          searchChats.assignAll(chats.where((chat) => chat.roomLatestChat!.isNotEmpty));  // 채팅 목록 업데이트
          break;

        case 'invite_room':
          print('invite_room -> receive_current_room');
          break;
      }

      // countUnread만 업데이트 함 (roomLatestChat, roomLatestChatDate 정상 작동하면 적용)
      chat.countUnread = result['countUnread'];
      searchChats.assignAll(chats.where((chat) => chat.roomLatestChat!.isNotEmpty));

      if(enterRoomList.isNotEmpty) {
        searchChats.asMap().forEach((index, f) => f.isEnterRoom = enterRoomList[index]);
      }
    });

    _socket.on('receive_success', (data) {
      print('receive_success : $data');
    });

    _socket.on('receive_error', (data) {
      print('receive_error : $data');
    });

    _socket.on('receive_chat', (data) {
      print('- receiveChat -');

      ChatModel chat = chats.where((element) => element.roomId == data['roomId']).first;
      MessageModel messageModel = MessageModel.fromMap(data);
      chat.messages!.add(messageModel);

      chat.roomLatestChat = messageModel.chat;
      chat.roomLatestChatDate = messageModel.createdAt;
      if(messageModel.senderId != myData.value.email) {
        chat.countUnread = chat.countUnread! + 1;
      }

      searchChats.assignAll(chats.where((chat) => chat.roomLatestChat!.isNotEmpty));

      // 현재 입장한 채팅방 업데이트
      if(currentRoomId.value == chat.roomId) {
        currentRoomMessages.add(messageModel);
      }

      // 채팅 받았음을 알림 (보낸 사람과 채팅방에 안에 있는 사람은 자동 처리)
      if(data['senderId'] == myData.value.email || currentRoomId.value == chat.roomId) {
        receivedChat(data['roomId'], data['_id']);
      }
    });

  }

  Future<void> receivedChat(String roomId, String chatId) async {
    print('receivedChat');

    _socket.emit(
        'received_chat', {
      'userId': myData.value.email,
      'roomId': roomId,
      'chatId': chatId,
    });
  }

  Future<void> sendMessage({String? roomId, String? chatType}) async {
    if (messageTextField.text.length > 0) {
      _socket.emit(
          'send_chat', {
        'senderId': myData.value.email,
        'roomId': roomId,
        'chat': messageTextField.text,
        'chatType': chatType,
      });
      messageTextField.clear();
    }
  }

  Future<void> sendImage({String? roomId, String? chatType, Uint8List? image}) async {
    _socket.emit(
        'send_chat', {
      'senderId': myData.value.email,
      'roomId': roomId,
      'chat': base64.encode(image!),
      'chatType': chatType,
    });
  }

  Future<void> sendEmoji({String? roomId, String? chatType, String? emoji}) async {
    _socket.emit(
        'send_chat', {
      'senderId': myData.value.email,
      'roomId': roomId,
      'chat': emoji,
      'chatType': chatType,
    });
  }

  Future<void> sendNotification({String? roomId, String? chat}) async {
    _socket.emit(
        'send_chat', {
      'senderId': 'notification',
      'roomId': roomId,
      'chat': chat,
      'chatType': 'notification',
    });
  }

  void enterChatRoom(String? roomId) {
    print('enterChatRoom : $roomId');
    currentRoomMessages.clear();
    _socket.emit(
        'enter_room', { 'roomId': roomId }
    );
  }

  void getRooms() {
    print('get_rooms : ${myData.value.email}');
    enterRoomList = searchChats.map((element) => element.isEnterRoom).toList();
    print('enterRoomList : ${enterRoomList.length}');
    chats.clear();
    searchChats.clear();
    _socket.emit(
        'get_rooms', {'userId': myData.value.email}
    );
  }

  // 새로운 채팅
  void createNewChat(RxList<User> selectedUsers) {
    List<String?> userList = selectedUsers.map((element) => element.email).toList();
    userList.add(myData.value.email);
    print('사용자 리스트 : ${userList}');

    // 기존에 만들어진 채팅방 있는지 확인 (순서에 관계없이 동일한 사용자 구성인지 체크)
    Function unOrdDeepEq = const DeepCollectionEquality.unordered().equals;
    for (var chat in chats) {
      // 채팅방 있을때: 기존 채팅방으로 이동
      if(unOrdDeepEq(chat.roomUserList, userList)) {
        print('채팅방 있음');
        Fluttertoast.showToast(
            msg: "선택한 사용자로 구성된 채팅방이 이미 있습니다.\n기존 채팅방으로 이동합니다.",
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            fontSize: 16.0
        );
        enterChatRoom(chat.roomId);
        Get.off(() => ChatRoomView(chatModel: chat));
        return;
      }
    };
    // 채팅방 없을때: 새로운 채팅방 생성 (receive_rooms에서 채팅방으로 이동 처리함)
    print('채팅방 없음');
    List<String?> selectedUsersName = selectedUsers.map((element) => element.name).toList();
    selectedUsersName.add(myData.value.name);
    isCreator = true;
    createCode = 'multi_new_chat';
    _socket.emit(
        'create_room', {
      // 'roomName': selectedUsersName.join(', '),
      'roomName': '-',
      'userList': userList
    });
  }

  // 사용자 초대
  void inviteRoom(String? roomId, RxList<User> selectedUsers, List? currentChatUsers) {
    print('invite_room');
    List<String?> userList = selectedUsers.map((element) => element.email).toList();
    currentChatUsers!.forEach((userEmail) {
      userList.add(userEmail);
    });
    print('사용자 리스트 : ${userList}');

    // 기존에 만들어진 채팅방 있는지 확인 (순서에 관계없이 동일한 사용자 구성인지 체크)
    Function unOrdDeepEq = const DeepCollectionEquality.unordered().equals;
    for (var chat in chats) {
      // 채팅방 있을때: 기존 채팅방으로 이동
      if(unOrdDeepEq(chat.roomUserList, userList)) {
        print('채팅방 있음');
        Fluttertoast.showToast(
            msg: "선택한 사용자로 구성된 채팅방이 이미 있습니다.\n기존 채팅방으로 이동합니다.",
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            fontSize: 16.0
        );
        enterChatRoom(chat.roomId);
        Get.off(() => ChatRoomView(chatModel: chat));
        return;
      }
    };
    print(selectedUsers.first.email);
    isInviter = true;
    _socket.emit(
        'invite_room', {
      'userList': selectedUsers.map((element) => element.email).toList(),
      'roomId': roomId,
    });
  }

  // 사용라 리스트에서 사용자 클릭해서 1:1 채팅 (기존 대화방 없으면 새로운 방 생성)
  void clickUser(User selectedUser) {
    List<String?> selectedEmailList = [];
    selectedEmailList.add(selectedUser.email);
    selectedEmailList.add(myData.value.email);
    print('사용자 리스트 : ${selectedEmailList}');

    // 기존에 만들어진 채팅방 있는지 확인 (순서에 관계없이 동일한 사용자 구성인지 체크)
    Function unOrdDeepEq = const DeepCollectionEquality.unordered().equals;
    for (var chat in chats) {
      // 채팅방 있을때: 기존 채팅방으로 이동
      if(unOrdDeepEq(chat.roomUserList, selectedEmailList)) {
        print('채팅방 있음');
        enterChatRoom(chat.roomId);
        Get.to(() => ChatRoomView(chatModel: chat));
        return;
      }
    };
    // 채팅방 없을때: 새로운 채팅방 생성 (receive_rooms에서 채팅방으로 이동 처리함)
    print('채팅방 없음');
    List<String?> selectedNameList = [];
    selectedNameList.add(selectedUser.name);
    selectedNameList.add(myData.value.name);

    isCreator = true;
    createCode = 'single_new_chat';
    _socket.emit(
        'create_room', {
      // 'roomName': selectedNameList.join(', '),
      'roomName': '-',
      'userList': selectedEmailList
    });
  }

  // 대화방 이름 변경
  void renameRoom(String? roomId) {
    print('rename_room');

    _socket.emit(
        'rename_room', {
      'roomId': roomId,
      'roomName': groupTextField.text,
    }
    );
  }

  // 대화방 탈퇴
  void dropoutRoom(String? roomId) {
    _socket.emit(
        'dropout_room', {
      'roomId': roomId,
      'userId': myData.value.email,
    }
    );
    sendNotification(roomId: roomId, chat: '${myData.value.name} 님이 나갔습니다.');
  }

  void filterSearchUser(String query) {
    if (query.isNotEmpty) {
      searchUsers.value = users
          .where((user) =>
          user.name!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } else {
      searchUsers.value = users;
    }
  }

  // 채팅방 검색 (제목)
  void filterSearchChat(String query) {
    if (query.isNotEmpty) {
      searchChats.value = chats
          .where((chat) =>
          chat.roomName!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } else {
      searchChats.value = chats;
    }
  }

  void filterSearchMessage(RxList<MessageModel> messages, String query) {
    searchMessages.value = messages
        .where((message) =>
        message.chat!.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // 채팅, 유저 데이터 초기화 (로그아웃)
  void clearChatData() {
    users.clear();
    searchUsers.clear();
    chats.clear();
    searchChats.clear();
    searchMessages.clear();
    currentRoomMessages.clear();
    enterRoomList.clear();

    loginController.myInfo.value.id = null;
    loginController.myInfo.value.email = null;
    loginController.myInfo.value.name = null;
    loginController.myInfo.value.avatar = null;
    loginController.myInfo.value.memlevel = null;
    loginController.myInfo.value.phone = null;
  }

  Future<void> memberList() async {
    myData.value = loginController.myInfo.value;
    final api ='https://www.dfxsoft.com/api/getUsers';
    final dio = Dio();
    Response response = await dio.get(api);
    if(response.statusCode == 200) {
      List<dynamic> result = response.data;
      users.assignAll(result.map((data) => User.fromJson(data)).toList().where((element) => element.id != myData.value.id));
      searchUsers.assignAll(users);
    }

    // 로컬 서버 테스트
    // final api ='http://192.168.222.9:22070/api/getUsers';
    // final dio = Dio();
    // Response response = await dio.get(api);
    // if(response.statusCode == 200) {
    //   List<dynamic> result = jsonDecode(response.data);
    //   users.assignAll(result.map((data) => User.fromJson(data)).toList().where((element) => element.id != myData.value.id));
    //   searchUsers.assignAll(users);
    // }
  }


// Future<void> findMemberList() async{
//   final api ='http://192.168.0.31:5000/api/getFindUsers';
//   final dio = Dio();
//   final data = {
//     "find": find.text,
//   };
//   Response response = await dio.post(api,data: data);
//   if(response.statusCode == 200) {
//     List<dynamic> result = response.data;
//     print('response length:'+result.length.toString());
//     chatController.users.assignAll(result.map((data) => User.fromJson(data)).toList());
//     chatController.users.refresh();
//   }
// }
}