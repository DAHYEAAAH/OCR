import 'package:flutter/material.dart';
import '../../views/chats/profile_image.dart';
import '../../widgets/custom_text_field.dart';
import 'package:get/get.dart' hide Response;
import 'package:intl/date_symbol_data_local.dart';
import '../../controllers/chat_controller.dart';
import '../../controllers/login_controller.dart';
import '../../model/user_model.dart';
import 'chat_list_card.dart';
import 'my_profile.dart';
import 'invite_chat_view.dart';

class ChatView extends StatefulWidget {
  const ChatView({Key? key}) : super(key: key);

  @override
  ChatViewState createState(){
    return ChatViewState();
  }
}

class ChatViewState extends State<ChatView>{
  final TextEditingController find = TextEditingController();
  LoginController loginController = Get.find();
  ChatController chatController = Get.find();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initializeDateFormatting(Localizations.localeOf(context).languageCode);
  }

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child:
        Obx(() => DefaultTabController(
            length: 2,
            initialIndex: 0,
            child: Column(
              children: [
                TabBar(
                    overlayColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.hovered))
                          return Colors.amberAccent;
                        return null;
                      },
                    ),
                    indicatorColor: Colors.blue[100],labelColor: const Color(0xFF3baee7),
                    tabs: [Tab(text: '채팅'),Tab(text: '친구')]),
                Expanded(
                  child: TabBarView(
                    children: [
                      chatList(),
                      userListTop(),
                    ],
                  ),
                )
              ],
            )
        )),
      ),
    );
  }

  Widget userListTop() {
    return Container(
      child: Obx(() => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          searchFriends(),
          SizedBox(height: 15,),
          // TextButton.icon(
          //     onPressed: () {
          //       ScaffoldMessenger.of(context).showSnackBar(
          //         SnackBar(
          //           content: Text('사용자 추가 준비중입니다.'),
          //         ));
          //     },
          //     icon: Icon(Icons.add, size: 20,),
          //
          //     label: Text(
          //         "새로운 사용자 추가", style: Theme.of(context).textTheme.button)
          // ),
          // SizedBox(height: 20,),
          myProfile(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('친구', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(width: 5,),
              Text('${chatController.users.length}', style: TextStyle(color: Colors.grey)),
            ],
          ),
          Expanded(
              child: ListView.separated(
                  padding: EdgeInsets.only(top: 10,),
                  itemBuilder: (BuildContext context, index) => GestureDetector(
                    child: _listItem(chatController.searchUsers[index]),
                    // onTap: () {
                    //   사용자 리스트에서 채팅방 입장
                    //   selectedUsers.clear();
                    //   selectedUsers.add(chatController.searchUsers[index]);
                    //   chatController.clickUser(selectedUsers);
                    // },
                  ),
                  separatorBuilder: (_, __) => Divider(
                    endIndent: 10.0,
                  ),
                  itemCount: chatController.searchUsers.length
              )
          )
        ],
      ),
      ),
    );
  }

  Widget _listItem(User user) {
    return ListTile(
      leading: Container(
        child: ProfileImage(
          imageUrl: user.avatar ?? '',
        ),
      ),
      title: Text(
        user.name!,
        style: Theme.of(context).textTheme.caption!.copyWith(
          fontSize: 12.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: () {
        Navigator.push(
          context, MaterialPageRoute(
          builder: (context) => MyProfile(user: user),
        ),
        );
      },
    );
  }

  Widget chatList() {
    return Column(
      children: [
        searchChatRoom(),
        SizedBox(height: 15),
        TextButton.icon(
            onPressed: () {
              Get.to(() => InviteChatView(currentChatUsers: []));
            },
            icon: Icon(Icons.add, size: 20,),
            label: Text(
                "새로운 채팅", style: Theme.of(context).textTheme.button)),
        SizedBox(height: 20,),
        Container(
          child:Expanded(
            child: ListView.builder(
              itemCount: chatController.searchChats.length,
              itemBuilder: (context, index) => ChatListCard(
                chatModel: chatController.searchChats[index],
                // messageModel: chatController.searchChats[index].messages!.length > 0 ? chatController.searchChats[index].messages!.last : MessageModel(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget myProfile() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('내 프로필', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          _listItem(chatController.myData.value),
          SizedBox(height: 10,),
          Divider(thickness: 1, color: Color(0xFFEBEBEB),),
          SizedBox(height: 10,),
        ],
      ),
    );
  }

  Widget searchFriends() {
    return Container(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: 15.0),
        child: CustomTextField(
          height: 43,
          hint: '사용자 이름 검색',
          inputAction: TextInputAction.done,
          onChanged: (val) {
            chatController.filterSearchUser(val);
          },
        ),
      ),
    );
  }

  Widget searchChatRoom() {
    return Container(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: 15.0),
        child: CustomTextField(
          height: 43,
          hint: '채팅방 검색 (제목)',
          inputAction: TextInputAction.done,
          onChanged: (val) {
            chatController.filterSearchChat(val);
          },
        ),
      ),
    );
  }

}
