import 'package:flutter/material.dart';
import '../../constants/bottom_icon_button.dart';
import '../../constants/round_icon_button.dart';
import '../../model/user_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart' hide Response;
import '../../controllers/chat_controller.dart';

class MyProfile extends StatelessWidget {
  const MyProfile({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  Widget build(BuildContext context) {
    ChatController chatController = Get.find();
    return Container(
      color: Color(0xFF858b92),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Spacer(),
            Container(
              width: 110,
              height: 110,
              child:
              ClipOval(
                child:
                user.avatar != null && user.avatar != '' ?
                Image.network(
                  user.avatar!,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ) : Container(
                  color: Color(0xFF9bbbd4),
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.white70,
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              user.name!,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'intro',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
              maxLines: 1,
            ),
            SizedBox(height: 20),
            Divider(color: Colors.white),
            if (user.email == chatController.myData.value.email)
              _buildMyIcons(context) else _buildFriendIcons(),
          ],
        ),
        appBar: AppBar(
          backgroundColor: Color(0xFF858b92),
          leading: IconButton(
            icon: Icon(
              FontAwesomeIcons.times,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            RoundIconButton(icon: FontAwesomeIcons.gift),
            SizedBox(width: 15),
            RoundIconButton(icon: FontAwesomeIcons.cog),
            SizedBox(width: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMyIcons([BuildContext? context]) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context!).showSnackBar(
                SnackBar(
                  content: Text('나와의 채팅 준비중입니다.'),
                ));
            },
            child: BottomIconButton(
              icon: FontAwesomeIcons.comment,
              text: "나와의 채팅",
            ),
          ),
          SizedBox(
            width: 50,
          ),
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context!).showSnackBar(
                SnackBar(
                  content: Text('프로필 편집 준비중입니다.'),
                ));
            },
            child: BottomIconButton(
              icon: FontAwesomeIcons.pen,
              text: "프로필 편집",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFriendIcons() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              ChatController chatController = Get.find();
              chatController.clickUser(user);
            },
            child: BottomIconButton(
              icon: FontAwesomeIcons.comment,
              text: "1:1채팅",
            ),
          ),
          SizedBox(
            width: 50,
          ),
          GestureDetector(
            child: BottomIconButton(
              icon: FontAwesomeIcons.phone,
              text: "통화하기",
            ),
          ),
        ],
      ),
    );
  }
}
