import 'package:flutter/material.dart';
import '../../views/chats/profile_image.dart';
import 'package:intl/intl.dart';

import '../../controllers/chat_controller.dart';
import '../../model/chat_model.dart';
import 'package:get/get.dart' hide Response;

import '../../model/user_model.dart';
import 'chat_room_view.dart';

class ChatListCard extends StatefulWidget {
  const ChatListCard({Key? key, required this.chatModel}) : super(key: key);
  final ChatModel chatModel;

  @override
  State<ChatListCard> createState() => _ChatListCardState();
}

class _ChatListCardState extends State<ChatListCard> {
  Widget getChatImage(RxList<User> currentRoomUsers) {
      switch (currentRoomUsers.length) {
        case 0:
          return SizedBox.shrink();
        case 1:
          return
            ProfileImage(
              imageUrl: currentRoomUsers[0].avatar ?? '',
            );
        case 2:
          return Container(
            width: 50,
            height: 60,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: ProfileImage(
                    imageUrl: currentRoomUsers[0].avatar ?? '',
                    width: 24, height: 24, iconSize: 15,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ProfileImage(
                    imageUrl: currentRoomUsers[1].avatar ?? '',
                    width: 24, height: 24, iconSize: 15,
                  ),
                ),
              ],
            ),
          );
        case 3:
          return Container(
            width: 50,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(0.5),
                      child: ProfileImage(
                        imageUrl: currentRoomUsers[0].avatar ?? '',
                        width: 23, height: 23, iconSize: 15,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(0.5),
                      child: ProfileImage(
                        imageUrl: currentRoomUsers[1].avatar ?? '',
                        width: 23, height: 23, iconSize: 15,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(0.5),
                      child: ProfileImage(
                        imageUrl: currentRoomUsers[2].avatar ?? '',
                        width: 23, height: 23, iconSize: 15,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        default:
          return Container(
            width: 50,
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(0.5),
                      child: ProfileImage(
                        imageUrl: currentRoomUsers[0].avatar ?? '',
                        width: 23, height: 23, iconSize: 15,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(0.5),
                      child: ProfileImage(
                        imageUrl: currentRoomUsers[1].avatar ?? '',
                        width: 23, height: 23, iconSize: 15,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(0.5),
                      child: ProfileImage(
                        imageUrl: currentRoomUsers[2].avatar ?? '',
                        width: 23, height: 23, iconSize: 15,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(0.5),
                      child: ProfileImage(
                        imageUrl: currentRoomUsers[3].avatar ?? '',
                        width: 23, height: 23, iconSize: 15,
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
      }
  }

  String getLatestChat(String? roomLatestChat) {
    String result = '';
    if(roomLatestChat!.length > 500)
      result = '사진을 보냈습니다.';
    else if(roomLatestChat.contains('emoji/'))
      result = '이모티콘을 보냈습니다.';
    else
      result = roomLatestChat;
    return result;
  }
  
  @override
  Widget build(BuildContext context) {
    ChatController chatController = Get.find();
    var currentRoomUsers = <User>[].obs;
    for(var email in widget.chatModel.roomUserList!) {
      if(email != chatController.myData.value.email) {
        User? person = chatController.users.firstWhereOrNull((element) => element.email == email);
        if(person != null)
          currentRoomUsers.add(person);
      }
    }
    return InkWell(
      onTap: () {
        chatController.enterChatRoom(widget.chatModel.roomId);
        print('-- ${widget.chatModel.roomId} ---');
        Get.to(() => ChatRoomView(chatModel: widget.chatModel));
      },
      child: Column(
        children: [
          ListTile(
            leading:
            currentRoomUsers.isEmpty ? SizedBox.shrink() :
            getChatImage(currentRoomUsers),
            title: Row(
              children: [
                Flexible(
                  child: Container(
                    child: Text(
                      widget.chatModel.roomName! == '-' ?
                      currentRoomUsers.map((element) => element.name).toList().join(', ') : widget.chatModel.roomName!,
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 5),
                Container(
                  padding: new EdgeInsets.only(right: 15.0),
                  child: Text(
                    widget.chatModel.roomUserList!.length > 2 ? widget.chatModel.roomUserList!.length.toString() : '',
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey
                    ),
                  ),
                ),
              ],
            ),
            subtitle: Row(
              children: [
                Flexible(
                  child: Container(
                    padding: EdgeInsets.only(top: 4.0, right: 20.0),
                    child: Text(
                      // roomLatestChat 에 채팅 타입이 없어서 길이로 구분
                      getLatestChat(widget.chatModel.roomLatestChat),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: TextStyle(
                        fontSize: 13.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    DateFormat('MM월 dd일 aa h:mm', 'ko_KR').format(DateTime.parse(widget.chatModel.roomLatestChatDate!)),
                    style: TextStyle(fontSize: 12)),
                if (widget.chatModel.countUnread != 0)
                  Container(
                    width: 20,
                    padding: EdgeInsets.symmetric(
                        horizontal: 0.0, vertical: 4.0),
                    decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius:
                        BorderRadius.all(Radius.circular(15.0))),
                    alignment: Alignment.center,
                    child: Text(
                      '${widget.chatModel.countUnread}',
                      style: const TextStyle(
                          fontSize: 10.0, color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 0, left: 0),
            child: Divider(
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}