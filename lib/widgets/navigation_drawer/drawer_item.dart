import 'package:flutter/material.dart';
import '../../widgets/navigation_bar/navbar_item.dart';

class DrawerItem extends StatelessWidget {
  final String title;
  final String imagePath;
  final String navigationPath;
  const DrawerItem(this.title, this.imagePath, this.navigationPath);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, top: 10),
      child: Row(
        children: <Widget>[
          Image.asset(imagePath,width: 5,height: 5,),
          SizedBox(
            width: 30,
          ),
          NavBarItem(imagePath,title, navigationPath)
        ],
      ),
    );
  }
}
