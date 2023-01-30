import 'package:flutter/material.dart';
import '../../views/chats/profile_image.dart';
import '../../widgets/custom_text_field.dart';
import 'package:get/get.dart';
import '../../controllers/chat_controller.dart';
import '../../controllers/login_controller.dart';
import '../../model/user_model.dart';

/*
 * 대화 상대 초대 작업중 (새로운 채팅: 전체 사용자에서 본인 제외, 채팅창 내에서 초대할때는 전체 사용자에서 현재 채팅 참여자 제외
 * currentChatUsers: 현재 채팅방 사용자 (본인 포함)
 * activeUsers: 초대 가능한 사용자
 * searchUsers: 검색된 사용자
 * selectedUsers: 선택한 사용자
 */

class InviteChatView extends StatefulWidget {
  final List<dynamic>? currentChatUsers;
  String? roomId;

  InviteChatView({this.currentChatUsers, this.roomId});

  @override
  State<InviteChatView> createState() => _InviteChatViewState();
}

class _InviteChatViewState extends State<InviteChatView> {
  var searchUsers = <User>[].obs;
  var selectedUsers = <User>[].obs;
  List<User> activeUsers = [];
  LoginController loginController = Get.find();
  ChatController chatController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    activeUsers.addAll(chatController.users);

    // 대화방에 이미 참여중인 사용자 제거
    if(widget.currentChatUsers!.length > 0) {
      widget.currentChatUsers!.forEach((userEmail) {
        activeUsers.removeWhere((item) => item.email == userEmail);
      });
    }

    searchUsers.value = activeUsers;
    print('참여가능 인원 : ${searchUsers.length}');

    return Obx(() => Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,

        titleSpacing: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.arrow_back,
                size: 24,
              ),
            ],
          ),
        ),
        title: Text(
          '대화상대 초대',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: TextButton(
              onPressed: selectedUsers.length > 0 ? () {
                // 기존 대화방에서 사용자 초대
                if(widget.currentChatUsers!.length > 0) {
                  chatController.inviteRoom(widget.roomId, selectedUsers, widget.currentChatUsers);
                // 새로운 채팅 추가
                } else {
                  chatController.createNewChat(selectedUsers);
                }
              } : null,
              child: Row(
                children: [
                  Text(
                    '${selectedUsers.length != 0 ? selectedUsers.length : '' }',
                    style: TextStyle(color: Colors.black),
                  ),
                  Text(' 확인'),
                ],
              ),
            ),
          )
        ],
      ),
      body: SizedBox.expand(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 10,),
              selectedUsers.isEmpty
                  ? SizedBox.shrink() : Container(
                height: 65,
                child: ListView.builder(
                  itemBuilder: (__, idx) =>
                      _selectedUsersListItem(selectedUsers[idx]),
                  itemCount: selectedUsers.length,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 15.0),
                child: CustomTextField(
                  height: 40,
                  hint: '사용자 이름 검색',
                  inputAction: TextInputAction.done,
                  onChanged: (val) {
                    filterSearchResults(val);
                  },
                ),
              ),
              Expanded(child: _buildList(searchUsers))
            ],
          ),
        ),
      ),
    ));
  }

  void filterSearchResults(String query) {
    if (query.isNotEmpty) {
      searchUsers.value = activeUsers
          .where((user) =>
          user.name!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } else {
      searchUsers.value = activeUsers;
    }
  }

  _selectedUsersListItem(User user) => Padding(
    padding: const EdgeInsets.only(right: 8.0),
    child: GestureDetector(
      onTap: () => selectedUsers.remove(user),
      child: Container(
        width: 40,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: CircleAvatar(
                  backgroundColor: Color(0xFF999999),
                  radius: 30,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child:
                    user.avatar != null && user.avatar != '' ?
                    Image.network(
                      user.avatar!,
                      fit: BoxFit.fill,
                      width: 40,
                      height: 40,
                    ) : Icon(
                      Icons.person,
                      size: 35,
                      color: Colors.black,
                    ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: 16,
                  height: 16,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black54),
                  child: Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 12.0,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                user.name!.split(' ').first,
                softWrap: false,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.caption!.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  _listItem(User user) => ListTile(
    leading: ProfileImage(
      imageUrl: user.avatar ?? '',
    ),
    title: Text(
      user.name!,
      style: Theme.of(context).textTheme.caption!.copyWith(
        fontSize: 12.0,
        fontWeight: FontWeight.bold,
      ),
    ),
    trailing: _checkBox(
      size: 20.0,
      isChecked: selectedUsers.any((element) => element.id == user.id),
    ),
  );

  _buildList(List<User> users) => ListView.separated(
      padding: EdgeInsets.only(top: 20, right: 2),
      itemBuilder: (BuildContext context, index) => GestureDetector(
        child: _listItem(users[index]),
        onTap: () {
          if (selectedUsers.any((element) => element.id == users[index].id)) {
            selectedUsers.remove(users[index]);
            return;
          }
          selectedUsers.add(users[index]);
        },
      ),
      separatorBuilder: (_, __) => Divider(
        endIndent: 16.0,
      ),
      itemCount: users.length);

  _checkBox({required double size, required bool isChecked}) => ClipRRect(
    borderRadius: BorderRadius.circular(size / 2),
    child: AnimatedContainer(
      child: Icon(Icons.check, color: Colors.white, size: 14,),
      duration: Duration(microseconds: 500),
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: isChecked ? Colors.amberAccent : Colors.transparent,
        border: Border.all(
          color: isChecked ? Colors.transparent : Colors.grey,
        ),
        borderRadius: BorderRadius.circular(size / 2),
      ),
    ),
  );
}