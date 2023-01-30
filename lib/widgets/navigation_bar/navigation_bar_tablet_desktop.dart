import 'package:flutter/material.dart';
import '../../controllers/login_controller.dart';
import '../../locator.dart';
import '../../routing/route_names.dart';
import '../../services/navigation_service.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controllers/chat_controller.dart';
import '../../model/user_model.dart';
import 'navbar_item.dart';

class NavigationBarTabletDesktop extends StatelessWidget {
  NavigationBarTabletDesktop({Key? key}) : super(key: key);
  final LoginController loginController = Get.find();
  final ChatController chatController = Get.find();

  @override
  Widget build(BuildContext context) {
    // sessionGet();
    return Container(
        height: 70,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            NavBarItem('assets/home.png','', HomeRoute),
            // NavBarItem('assets/process.png',' Ocr', OcrApiRoute),
            Obx(() {
              return
                loginController.myInfo.value.email == null ?
                NavBarItem('assets/process.png',' Ocr', LoginRoute) :
                PopupMenuButton<String>(
                  tooltip: 'OCR',
                  icon: new Image.asset('assets/process.png'),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      enabled: loginController.myInfo.value.memlevel! <= 3,
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.list_alt),
                          SizedBox(width: 10.0),
                          Text("임신사 OCR 목록"),
                        ],
                      ),
                      value: "1",
                    ),
                    if (loginController.myInfo.value.memlevel! <= 3)
                      PopupMenuItem(
                          height:50,
                          enabled: loginController.myInfo.value.memlevel! <= 3,
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.list_alt_outlined),
                              SizedBox(width: 10.0),
                              Text("분만사 OCR 목록"),
                            ],
                          ),
                          value: "2"
                      ),
                    PopupMenuItem(
                      enabled: loginController.myInfo.value.memlevel! <= 3,
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.auto_graph),
                          SizedBox(width: 10.0),
                          Text("Ocr 통계"),
                        ],
                      ),
                      value: "3",
                    ),
                  ],
                  onSelected: ocrSelectedMenu,
                );
            }),
            // NavBarItem('assets/process.png',' Ocr', OcrApiRoute),
            Obx(() {
              return
                loginController.myInfo.value.email == null ?
                NavBarItem('assets/estrus_30.png',' Estrus', LoginRoute) :
                PopupMenuButton<String>(
                  tooltip: 'Estrus',
                  icon: new Image.asset('assets/estrus_30.png'),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      enabled: loginController.myInfo.value.memlevel! <= 2,
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.pie_chart),
                          SizedBox(width: 10.0),
                          Text("Estrus Pie Chart"),
                        ],
                      ),
                      value: "1",
                    ),
                    if (loginController.myInfo.value.memlevel! <= 2)
                      PopupMenuItem(
                          height:50,
                          enabled: loginController.myInfo.value.memlevel! <= 2,
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.bar_chart),
                              SizedBox(width: 10.0),
                              Text("Estrus Bar Chart"),
                            ],
                          ),
                          value: "2"
                      ),
                  ],
                  onSelected: estrusSelectedMenu,
                );
            }),
            NavBarItem('assets/chat1.png',' Chat', ChatRoute),
            NavBarItem('assets/register.png',' Register', RegisterRoute),
            // 상태 관리 추가
            Obx(() {
              return
                loginController.myInfo.value.email == null ?
                NavBarItem('assets/login.png',' Login', LoginRoute) :
                PopupMenuButton<String>(
                  tooltip: loginController.myInfo.value.name,
                  icon: Icon(Icons.person),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.person),
                          SizedBox(width: 10.0),
                          Text("profile"),
                        ],
                      ),
                      value: "1",
                    ),
                    if (loginController.myInfo.value.memlevel! <= 3)
                      PopupMenuItem(
                          height:50,
                          enabled: loginController.myInfo.value.memlevel! <= 1,
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.people),
                              SizedBox(width: 10.0),
                              Text("Users"),
                            ],
                          ),
                          value: "2"
                      ),
                    PopupMenuItem(
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.logout),
                          SizedBox(width: 10.0),
                          Text("Logout"),
                        ],
                      ),
                      value: "3",
                    ),
                  ],
                  onSelected: selectedMenu,
                );
            }),
          ],
        ),
      );
  }
  Future<void> ocrSelectedMenu(String choice) async {
    if(choice == "1"){
      locator<NavigationService>().navigateTo(OcrPreListRoute);
    }
    if(choice == "2"){
      locator<NavigationService>().navigateTo(OcrMatListRoute);
    }
    if(choice == "3"){
      locator<NavigationService>().navigateTo(OcrGraphRoute);
    }
  }
  Future<void> estrusSelectedMenu(String choice) async {
    if(choice == "1"){
      locator<NavigationService>().navigateTo(EstrusPiechartRoute);
    }
    if(choice == "2"){
      locator<NavigationService>().navigateTo(EstrusBarchartViewRoute);
    }
  }

  Future<void> selectedMenu(String choice) async {
    if(choice == "1"){
      locator<NavigationService>().navigateTo(ProfileUpdateRoute);
    }
    if(choice == "2"){
      locator<NavigationService>().navigateTo(UserListRoute);
    }
    if(choice == "3"){
      LoginController loginController = Get.find();
      loginController.myInfo.value = User();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.clear();
      chatController.clearChatData();
      locator<NavigationService>().navigateTo(HomeRoute);
    }
  }
}