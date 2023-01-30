import 'message_model.dart';

class ChatModel {
  String? roomId;
  String? roomName;
  String? roomLatestChat;
  String? roomLatestChatDate;
  int? countUnread;
  List<dynamic>? roomUserList = [];
  List<MessageModel>? messages = [];
  bool? isEnterRoom;

  ChatModel({
    this.roomId,
    this.roomName,
    this.roomLatestChat,
    this.roomLatestChatDate,
    this.countUnread,
    this.roomUserList,
    this.messages,
    this.isEnterRoom,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
    roomId: json["roomId"],
    roomName: json["roomName"],
    roomLatestChat: json["roomLatestChat"],
    roomLatestChatDate: json["roomLatestChatDate"],
    countUnread: json["countUnread"],
    roomUserList: json["roomUserList"],
    messages: [],
    isEnterRoom: false,
  );

  Map<String, dynamic> toJson() {
    return {
      "roomId": roomId,
      "roomName": roomName,
      "roomLatestChat": roomLatestChat,
      "roomLatestChatDate": roomLatestChatDate,
      "roomUserList": roomUserList,
      "countUnread": countUnread,
    };
  }
}



// 채팅방 더미 데이터
// List<ChatModel> chatModels = [
  // ChatModel(
  //     id: 1,
  //     roomName: "",
  //     messages : [
  //       messageModels.elementAt(0),
  //       messageModels.elementAt(1),
  //       messageModels.elementAt(2),
  //     ],
  //     participants: [
  //       userModels.elementAt(0),
  //       userModels.elementAt(1),
  //       loginController.myInfo.value
  //     ]
  // ),
  // ChatModel(
  //     id: 2,
  //     roomName: "",
  //     messages : [
  //       messageModels.elementAt(3),
  //     ],
  //     participants: [
  //       userModels.elementAt(2),
  //       loginController.myInfo.value
  //     ]
  // ),
  // ChatModel(
  //     id: 3,
  //     roomName: "",
  //     messages : [
  //       messageModels.elementAt(4),
  //     ],
  //     participants: [
  //       userModels.elementAt(3),
  //       loginController.myInfo.value
  //     ]
  // ),
  // ChatModel(
  //     id: 4,
  //     roomName: "페이큐브",
  //     messages : [
  //       messageModels.elementAt(5),
  //     ],
  //     participants: [
  //       userModels.elementAt(4),
  //       loginController.myInfo.value
  //     ]
  // ),
// ];