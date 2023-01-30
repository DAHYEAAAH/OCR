import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../model/message_model.dart';
import '../../views/chats/notification_message_card.dart';
import '../../views/chats/receiver_message_card.dart';
import '../../views/chats/sender_message_card.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../controllers/chat_controller.dart';
import '../../controllers/login_controller.dart';
import '../../model/chat_model.dart';
import 'package:get/get.dart' hide Response;
import '../../model/user_model.dart';
import 'invite_chat_view.dart';

class ChatRoomView extends StatefulWidget {
  ChatRoomView({Key? key, required this.chatModel}) : super(key: key);
  final ChatModel chatModel;

  @override
  _ChatRoomViewState createState() => _ChatRoomViewState();
}

class _ChatRoomViewState extends State<ChatRoomView> {
  FocusNode focusNode = FocusNode();
  RxList<MessageModel> messages = <MessageModel>[].obs;
  LoginController loginController = Get.find();
  ChatController chatController = Get.find();
  bool _searchBoolean = false;

  int imageQuality = 75;
  double maxHeight = 1000;
  double maxWidth = 1000;
  List<User> currentRoomUsers = [];

  var emojiListShowing = false.obs;
  var emojiPutShowing = false.obs;
  var emojiImage = ''.obs;
  var emojiList = [
    'emoji/que_estrus_chk.png',
    'emoji/que_estrus.png',
    'emoji/que_jab.png',
    'emoji/que_pregnamt.png',
    'emoji/que_ready1.png',
    'emoji/que_vaccine.png',
    'emoji/que_what.png',
    'emoji/ans_no.png',
    'emoji/ans_no1.png',
    'emoji/ans_notyet.png',
    'emoji/ans_ok1.png',
    'emoji/sta_estrus_chk.png',
    'emoji/sta_estrus0.png',
    'emoji/sta_pregnant1.png',
    'emoji/sta_ready.png',
  ];

  @override
  void initState() {
    super.initState();
    chatController.groupTextField = TextEditingController(text: widget.chatModel.roomName);
    messages = chatController.currentRoomMessages;

    for(var email in widget.chatModel.roomUserList!) {
      if(email != chatController.myData.value.email) {
        User? person = chatController.users.firstWhereOrNull((element) => element.email == email);
        if(person != null)
          currentRoomUsers.add(person);
      }
    }
    Future.delayed(
      Duration(),
          () => SystemChannels.textInput.invokeMethod('TextInput.hide'),
    );
    chatController.currentRoomId.value = widget.chatModel.roomId!;
  }

  @override
  void dispose() {
    chatController.currentRoomId.value = '';
    super.dispose();
  }

  void FlutterDialog(BuildContext context) {
    Future.delayed(
        const Duration(seconds: 0),
            () => showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                title: Column(
                  children: <Widget>[
                    Text("그룹 이름 변경", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  ],
                ),
                //
                content: TextFormField(
                  controller: chatController.groupTextField,
                  keyboardType: TextInputType.text,
                ),
                actions: <Widget>[
                  Center(
                    child: TextButton(
                      child: Text("확인", style: TextStyle(fontSize: 15),),
                      onPressed: () {
                        chatController.renameRoom(widget.chatModel.roomId);
                        // widget.chatModel.roomName = groupTextField.text;
                        // setState(() {
                        // });
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              );
            }));
  }

  void LeaveChatRoom(BuildContext context) {
    Future.delayed(
        const Duration(seconds: 0),
            () => showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                title: Column(
                  children: <Widget>[
                    Text("채팅방 나가기", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  ],
                ),
                //
                content: Text(
                    "나가기를 하면 대화내용이 모두 삭제되고\n채팅 목록에서도 삭제됩니다.",
                    style: TextStyle(fontSize: 13, color: Colors.black54)),
                actions: <Widget>[
                  TextButton(
                    child: Text("취소", style: TextStyle(fontSize: 14, color: Colors.blueAccent),),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  TextButton(
                    child: Text("나가기", style: TextStyle(fontSize: 14, color: Colors.blueAccent),),
                    onPressed: () {
                      Navigator.pop(context);
                      chatController.dropoutRoom(widget.chatModel.roomId);
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            }));
  }

  Widget _searchTextField() {
    return TextField(
        textInputAction: TextInputAction.search, //Specify the action button on the keyboard
        decoration: InputDecoration( //Style of TextField
          enabledBorder: UnderlineInputBorder( //Default TextField border
              borderSide: BorderSide(color: Colors.white)
          ),
          focusedBorder: UnderlineInputBorder( //Borders when a TextField is in focus
              borderSide: BorderSide(color: Colors.white)
          ),
          hintText: '대화 내용 검색', //Text that is displayed when nothing is entered.
          hintStyle: TextStyle( //Style of hintText
            color: Colors.black54,
            fontSize: 14,
          ),
        ),
        onChanged: (String val) {
          // 채팅방 검색 대기
          // print('val');
          if (val.isNotEmpty) {
            // searchMessages.value = messages
            //     .where((message) =>
            //     message.chat!.toLowerCase().contains(val.toLowerCase()))
            //     .toList();
            // setState(() {
            //   chatController.filterSearchMessage(messages, val);
            // });
          } else {
            // messages.assignAll(widget.chatModel.messages!);
          }
        }
    );
  }


  void emojiTap(String emoji) {
    emojiPutShowing.value = true;
    emojiImage.value = emoji;
  }

  void emojiDoubleTap() {
    chatController.sendEmoji(roomId: widget.chatModel.roomId, chatType: 'emoji', emoji: emojiImage.value);
    emojiPutShowing.value = false;
    emojiImage.value = '';
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Stack(
      children: [
        Scaffold(
          backgroundColor: Color(0xFF9bbbd4),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: AppBar(
              backgroundColor: Color(0xFFecedf2),
              // backgroundColor: Colors.transparent,
              leadingWidth: 70,
              titleSpacing: 0,
              leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back,
                  size: 24,
                ),
              ),
              title: !_searchBoolean ?  // 검색창, 제목 구분
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width - 170,
                    child: Text(
                      chatController.currentRoomName.value == '-' ?
                      currentRoomUsers.map((element) => element.name).toList().join(', ') : chatController.currentRoomName.value,
                      maxLines:1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54
                      ),
                    ),
                  ),
                  // SizedBox(width: 5),
                  // Text(
                  //   widget.chatModel.roomUserList!.length > 2 ? widget.chatModel.roomUserList!.length.toString() : '',
                  //   style: TextStyle(
                  //       fontSize: 15,
                  //       color: Colors.black38
                  //   ),
                  // ),
                ],
              ) : _searchTextField(),
              actions: [
                !_searchBoolean ? IconButton(icon: Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        _searchBoolean = true;
                      });
                    }) :
                IconButton(icon: Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _searchBoolean = false;
                      });
                    }),
                PopupMenuButton<String>(
                  padding: EdgeInsets.only(right: 20),
                  onSelected: (value) {
                    print(value);
                  },
                  icon: Icon(Icons.menu),
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(
                        child: Row(
                          children: [
                            Icon(Icons.add, size: 20,),
                            SizedBox(width: 3,),
                            Text("대화 상대 초대"),
                          ],
                        ),
                        onTap: () => Future(
                              () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => InviteChatView(currentChatUsers: widget.chatModel.roomUserList, roomId: widget.chatModel.roomId)),
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        child: Row(
                          children: [
                            Icon(Icons.settings, size: 20,),
                            SizedBox(width: 3,),
                            Text("그룹 이름 설정"),
                          ],
                        ),
                        onTap: () {
                          FlutterDialog(context);
                        },
                      ),
                      PopupMenuItem(
                        child: Row(
                          children: [
                            Icon(Icons.exit_to_app, size: 20,),
                            SizedBox(width: 3,),
                            Text("채팅방 나가기"),
                          ],
                        ),
                        onTap: () {
                          LeaveChatRoom(context);
                        },
                      ),
                      PopupMenuDivider(),
                      PopupMenuItem(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.group, size: 20,),
                                SizedBox(width: 3,),
                                Text("대화상대"),
                                SizedBox(width: 5,),
                                Text(
                                  widget.chatModel.roomUserList!.length.toString(),
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black38
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Column(
                              children: userList(),
                            ),
                          ],
                        ),
                      ),
                    ];
                  },
                ),
              ],
            ),
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    shrinkWrap: true,
                    controller: chatController.scrollController,
                    itemCount: messages.length + 1,
                    itemBuilder: (context, index) {
                      int newIndex = messages.length - index;

                      if (index == 0) {
                        return Container(
                          height: 20,
                        );
                      }

                      // if(messages[newIndex].chatType == 'notification') {
                      //   return NotificationMessageCard(
                      //     message: messages[newIndex].chat,
                      //   );
                      // }

                      bool isSameDate = true;
                      final String dateString = messages[newIndex].createdAt!;
                      final DateTime date = DateTime.parse(dateString);
                      final message = messages[newIndex];

                      if (newIndex == 0) {
                        isSameDate = false;
                      } else {
                        final String prevDateString = messages[newIndex - 1].createdAt!;
                        final DateTime prevDate = DateTime.parse(prevDateString);
                        isSameDate = date.isSameDate(prevDate);
                      }

                      if(message.chatType == 'notification') {
                        return NotificationMessageCard(
                          message: message.chat, isDate: false,
                        );
                      }

                      if (!(isSameDate)) {
                        if (message.senderId == loginController.myInfo.value.email) {
                          return Column(
                            children: [
                              NotificationMessageCard(
                                  message: DateFormat('yyyy년 M월 d일 E요일', 'ko_KR').format(DateTime.parse(message.createdAt!)), isDate: true),
                              SenderMessageCard(
                                name: message.senderId!,
                                message: message.chat,
                                chatType: message.chatType,
                                time: DateFormat('aa hh:mm', 'ko_KR').format(DateTime.parse(message.createdAt!)),
                              ),
                            ],
                          );
                        } else {
                          return
                            Column(
                              children: [
                                NotificationMessageCard(
                                  message: DateFormat('yyyy년 M월 d일 E요일', 'ko_KR').format(DateTime.parse( message.createdAt!)), isDate: true,
                                ),
                                ReceiverMessageCard(
                                  name: currentRoomUsers.where((user) => user.email == message.senderId)
                                      .first.name,
                                  message: message.chat,
                                  chatType: message.chatType,
                                  avatar: currentRoomUsers.where((user) => user.email == message.senderId)
                                      .first.avatar,
                                  time: DateFormat('aa hh:mm', 'ko_KR').format(DateTime.parse( message.createdAt!)),
                                ),
                              ],
                            );
                        }
                      } else {
                        // 알림 메시지 아직 DB처리 안되어 있음
                        if ( message.senderId == loginController.myInfo.value.email) {
                          return SenderMessageCard(
                            name: message.senderId!,
                            message: message.chat,
                            chatType: message.chatType,
                            time: DateFormat('aa hh:mm', 'ko_KR').format(DateTime.parse( message.createdAt!)),
                          );
                        } else {
                          return
                            ReceiverMessageCard(
                              name: currentRoomUsers.where((user) => user.email == message.senderId)
                                  .first.name,
                              message: message.chat,
                              chatType: message.chatType,
                              avatar: currentRoomUsers.where((user) => user.email == message.senderId)
                                  .first.avatar,
                              time: DateFormat('aa hh:mm', 'ko_KR').format(DateTime.parse( message.createdAt!)),
                            );
                        }
                      }
                    },
                  ),
                ),
                // const Spacer(),
                Offstage(
                  offstage: !emojiPutShowing.value,
                  child: Container(
                    height: 50,
                    color: Colors.black.withOpacity(0.3),
                    child: Row(
                      children: [
                        Expanded(
                          child: Center(
                              child: emojiImage.value != '' ? Image.asset(emojiImage.value) : SizedBox()
                            // Text(emojiImage.value,
                            //   style: TextStyle(fontSize: 100),
                            // ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: Icon(Icons.close),
                            color: Colors.white,
                            iconSize: 20,
                            onPressed: () {
                              emojiImage.value = '';
                              emojiPutShowing.value = false;
                            },
                          ),
                        ),
                      ],
                    ),),
                ),
                Container(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 50,
                          color: Color(0xFFecedf2),
                          child: TextFormField(
                            autofocus: true,
                            controller: chatController.messageTextField,
                            focusNode: focusNode,
                            textAlignVertical: TextAlignVertical.center,
                            keyboardType: TextInputType.multiline,
                            maxLines: 2,
                            minLines: 1,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "",
                              hintStyle: TextStyle(color: Colors.grey),
                              prefixIcon: IconButton(
                                icon: Icon(Icons.add,
                                    color: Colors.black54),
                                onPressed: () {
                                  showModalBottomSheet(
                                      backgroundColor:
                                      Colors.transparent,
                                      context: context,
                                      builder: (builder) =>
                                          bottomSheet());
                                },
                              ),
                              suffixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.photo_outlined,
                                        color: Colors.black54),
                                    onPressed: () async {
                                      var photo = await ImagePicker().pickImage(
                                          maxWidth: maxWidth,
                                          maxHeight: maxHeight,
                                          imageQuality: imageQuality,
                                          source: ImageSource.gallery);
                                      if (kIsWeb) {
                                        if (photo != null) {
                                          Uint8List bytes = await photo.readAsBytes();
                                          chatController.sendImage(roomId: widget.chatModel.roomId, chatType: 'image', image: bytes);
                                        }
                                      } else {
                                        if (photo != null) {
                                          File imageFile = File(photo.path);
                                          Uint8List bytes = await imageFile.readAsBytes();
                                          chatController.sendImage(roomId: widget.chatModel.roomId, chatType: 'image', image: bytes);
                                        }
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.emoji_emotions_outlined,
                                        color: Colors.black54
                                    ),
                                    onPressed: () {
                                      emojiListShowing.value = !emojiListShowing.value;
                                      // Fluttertoast.showToast(
                                      //     msg: "이모티콘 준비중입니다.",
                                      //     gravity: ToastGravity.BOTTOM,
                                      //     fontSize: 16.0
                                      // );
                                    },
                                  ),
                                ],
                              ),
                              contentPadding: EdgeInsets.all(0),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 50,
                        color: Color(0xFF556677),
                        child: IconButton(
                            icon: Icon(
                              Icons.send,
                              color: Colors.white,
                            ),
                            onPressed: () async {
                              await chatController.sendMessage(roomId: widget.chatModel.roomId, chatType: "text");
                              if(emojiImage.value != '') {
                                emojiDoubleTap();
                              }
                            }
                        ),
                      ),
                    ],
                  ),
                ),
                Offstage(
                    offstage: !emojiListShowing.value,
                    child: Container(
                      padding: EdgeInsets.all(15.0),
                      color: Colors.white,
                      height: 240,
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 11, // 1개의 행에 항목을 7개씩
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ),
                        itemCount: emojiList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            child: InkWell(
                              child: Image.asset(emojiList[index], width: 50, height: 50,),
                              onTap: () => emojiTap(emojiList[index]),
                              onDoubleTap: () => emojiDoubleTap(),
                            ),

                          );
                        },
                      ),)
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  List<Widget> userList() {
    List<Widget> list = <Widget>[];
    List<User> allRoomUsers = [];
    allRoomUsers.addAll(currentRoomUsers);
    allRoomUsers.add(chatController.myData.value);
    for(int i=0; i<allRoomUsers.length; i++) {
      list.add(
          Container(
            width: 150,
            margin: EdgeInsets.all(5),
            child: Row(
                children:
                [
                  CircleAvatar(
                      backgroundColor: Color(0xFF9bbbd4),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: allRoomUsers[i].avatar != null && allRoomUsers[i].avatar != '' ?
                        Image.network(
                          allRoomUsers[i].avatar!,
                          fit: BoxFit.fill,
                          width: 100,
                          height: 100,
                        ) : Icon(
                          Icons.person,
                          size: 35,
                          color: Colors.white70,
                        ),
                      )),
                  SizedBox(width: 10,),
                  Text("${allRoomUsers[i].name}", style: const TextStyle(fontSize: 14)),
                ]
            ),
          )
      );
    }
    return list;
  }


  Widget bottomSheet() {
    return Container(
      height: 278,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: const EdgeInsets.all(18.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(
                      Icons.insert_drive_file, Colors.indigo, "파일", "file"),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.camera_alt, Colors.pink, "카메라", "camera"),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.insert_photo, Colors.purple, "앨범", "album"),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(Icons.headset, Colors.orange, "뮤직", "music"),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.location_pin, Colors.teal, "지도", "map"),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.person, Colors.blue, "연락처", "contact"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget iconCreation(IconData icons, Color color, String text, String event) {
    return InkWell(
      onTap: () async {
        switch (event) {
          case 'album':
            var photo = await ImagePicker().pickImage(
                maxWidth: maxWidth,
                maxHeight: maxHeight,
                imageQuality: imageQuality,
                source: ImageSource.gallery);
            if (kIsWeb) {
              if (photo != null) {
                Uint8List bytes = await photo.readAsBytes();
                chatController.sendImage(roomId: widget.chatModel.roomId, chatType: 'image', image: bytes);
              }
            } else {
              if (photo != null) {
                File imageFile = File(photo.path);
                Uint8List bytes = await imageFile.readAsBytes();
                chatController.sendImage(roomId: widget.chatModel.roomId, chatType: 'image', image: bytes);
              }
            }
            Navigator.pop(context);
            break;
          case 'camera':
            var camera = await ImagePicker().pickImage(
                maxWidth: maxWidth,
                maxHeight: maxHeight,
                imageQuality: imageQuality,
                source: ImageSource.camera);
            if (kIsWeb) {
              if (camera != null) {
                Uint8List bytes = await camera.readAsBytes();
                chatController.sendImage(roomId: widget.chatModel.roomId, chatType: 'image', image: bytes);
              }
            } else {
              if (camera != null) {
                File imageFile = File(camera.path);
                Uint8List bytes = await imageFile.readAsBytes();
                chatController.sendImage(roomId: widget.chatModel.roomId, chatType: 'image', image: bytes);
              }
            }
            Navigator.pop(context);
            break;
          case 'file':
            Fluttertoast.showToast(
                msg: "준비중입니다.",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 3,
                fontSize: 16.0
            );
            break;
          case 'music':
            Fluttertoast.showToast(
                msg: "준비중입니다.",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 3,
                fontSize: 16.0
            );
            break;
          case 'map':
            Fluttertoast.showToast(
                msg: "준비중입니다.",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 3,
                fontSize: 16.0
            );
            break;
          case 'contact':
            Fluttertoast.showToast(
                msg: "준비중입니다.",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 3,
                fontSize: 16.0
            );
            break;

        }},
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color,
            child: Icon(
              icons,
              // semanticLabel: "Help",
              size: 29,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              // fontWeight: FontWeight.w100,
            ),
          )
        ],
      ),
    );
  }
}

// 날짜 포맷
const String dateFormatter = 'MMMM dd, y';

extension DateHelper on DateTime {

  String formatDate() {
    final formatter = DateFormat(dateFormatter);
    return formatter.format(this);
  }
  bool isSameDate(DateTime other) {
    return this.year == other.year &&
        this.month == other.month &&
        this.day == other.day;
  }

  int getDifferenceInDaysWithNow() {
    final now = DateTime.now();
    return now.difference(this).inDays;
  }
}