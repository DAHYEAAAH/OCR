import 'package:flutter/material.dart';
import '../../routing/route_names.dart';
import '../../widgets/navigation_drawer/drawer_item.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controllers/login_controller.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // sessionGet();
    final loginController = Get.put(LoginController());
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 16),
        ],
      ),
      child: Column(
        children: <Widget>[
          SizedBox(height: 50,),
          DrawerItem(' Home', 'assets/home.png', HomeRoute),
          SizedBox(height: 20,),
          loginController.myInfo.value.email == null ?
          DrawerItem(' Login', 'assets/login.png', LoginRoute):
          DrawerItem(' Logout', 'assets/login.png', LogoutRoute),

          SizedBox(height: 20,),
          DrawerItem(' Register', 'assets/register.png', RegisterRoute),
          if (loginController.myInfo.value.email != null)...[
            SizedBox(height: 20,),
            DrawerItem(' Chat', 'assets/chat.png', ChatRoute),
            SizedBox(height: 20,),
            DrawerItem(' Estrus Pie Chart', 'assets/piechart.png', EstrusPiechartRoute),
            SizedBox(height: 20,),
            DrawerItem(' Estrus Bar Chart', 'assets/barchart.png', EstrusBarchartViewRoute),
            if (loginController.myInfo.value.memlevel! <= 3)...[
              SizedBox(height: 20,),
              DrawerItem(' 임신사 OCR', 'assets/chat.png', OcrPreRoute),
              SizedBox(height: 20,),
              DrawerItem(' 임신사 OCR List', 'assets/chat.png', OcrPreListRoute),
              SizedBox(height: 20,),
              DrawerItem(' 분만사 OCR', 'assets/chat.png', OcrMatRoute),
              SizedBox(height: 20,),
              DrawerItem(' 분만사 OCR List', 'assets/chat.png', OcrMatListRoute),
              SizedBox(height: 20,),
              DrawerItem(' OCR 통계', 'assets/chat.png', OcrGraphRoute),
            ],
          ]else...[
            SizedBox(height: 20,),
          ],
        ],
      ),
    );
  }
}
