class MessageModel {
  String? id;
  String? roomId;
  dynamic chat;
  String? chatType;       // 'text', 'image', 'notification'
  String? senderId;
  String? createdAt;
  String? updateAt;

  MessageModel({
    this.id,
    this.roomId,
    this.chat,
    this.chatType,
    this.senderId,
    this.createdAt,
    this.updateAt,
  });

  factory MessageModel.fromMap(Map<String, dynamic> json) => MessageModel(
    id: json["_id"] == null ? null : json["_id"],
    roomId: json["roomId"] == null ? null : json["roomId"],
    chat: json["chat"] == null ? null : json["chat"],
    chatType: json["chatType"] == null ? null : json["chatType"],
    senderId: json["senderId"] == null ? null : json["senderId"],
    createdAt: json["createdAt"] == null ? null : json["createdAt"],
    updateAt: json["updateAt"] == null ? null : json["updateAt"],
  );

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
    id: json["_id"],
    roomId: json["roomId"],
    chat: json["chat"],
    chatType: json["chatType"],
    senderId: json["senderId"],
    createdAt: json["createdAt"],
    updateAt: json["updateAt"],
  );

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "roomId": roomId,
      "chat": chat,
      "chatType": chatType,
      "senderId": senderId,
      "createdAt": createdAt,
      "updateAt": updateAt,
    };
  }
}

// 메시지 더미 데이터
// LoginController loginController = Get.find();
// List<MessageModel> messageModels = [
  // MessageModel(
  //     id: 0,
  //     message: "인간에 있음으로써 같지 위하여서. 눈이 찾아다녀도",
  //     sender: userModels.elementAt(0),
  //     createdAt: "6월 20일"
  // ),
  // MessageModel(
  //     id: 1,
  //     message: "청춘은 관현악이며, 뛰노는 이것이다. 청춘 못하다 것은 불러 이상이 열락의 피어나기 있는가? 찾아 충분히 이것이야말로 내려온 눈이 천하를 고행을 있으랴? 뜨고, 불어 영원히 물방아 있는 날카로우나 기관과 곳이 생의 있는가?",
  //     sender: userModels.elementAt(1),
  //     createdAt: "6월 20일"
  // ),
  // MessageModel(
  //     id: 2,
  //     message: "위하여 따뜻한 길을 아름답고 것이다. 끝까지 싸인 지혜는 인류의 천하를 별과 힘있다. 없는 인생을 장식하는 것이 것이다.",
  //     sender: loginController.myInfo.value,
  //     createdAt: "6월 20일"
  // ),
  // MessageModel(
  //     id: 3,
  //     message: "청춘은 관현악이며, 뛰노는 이것이다. 청춘 못하다 것은 불러 이상이 열락의 피어나기 있는가? 찾아 충분히 이것이야말로 내려온 눈이 천하를 고행을 있으랴? 뜨고, 불어 영원히 물방아 있는 날카로우나 기관과 곳이 생의 있는가?",
  //     sender: userModels.elementAt(2),
  //     createdAt: "6월 20일"
  // ),
  // MessageModel(
  //     id: 4,
  //     message: "위하여 따뜻한 길을 아름답고 것이다. 끝까지 싸인 지혜는 인류의 천하를 별과 힘있다. 없는 인생을 장식하는 것이 것이다.",
  //     sender: userModels.elementAt(3),
  //     createdAt: "6월 17일"
  // ),
  // MessageModel(
  //     id: 5,
  //     message: "슬퍼하는 불러 나의 잠, 어머니, 나는 쓸쓸함과 아무 까닭입니다.",
  //     sender: userModels.elementAt(4),
  //     createdAt: "6월 15일"
  // ),
// ];