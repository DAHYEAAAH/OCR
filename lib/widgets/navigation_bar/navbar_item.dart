import 'package:flutter/material.dart';
import '../../locator.dart';
import '../../services/navigation_service.dart';
import 'package:responsive_builder/responsive_builder.dart';

class NavBarItem extends StatelessWidget {
  final String imagePath;
  final String title;
  final String navigationPath;
  const NavBarItem(this.imagePath,this.title, this.navigationPath);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        return GestureDetector(
          onTap: () {
            // DON'T EVER USE A SERVICE DIRECTLY IN THE UI TO CHANGE ANY KIND OF STATE
            // SERVICES SHOULD ONLY BE USED FROM A VIEWMODEL
            if(sizingInformation.deviceScreenType == DeviceScreenType.mobile) {
              Navigator.pop(context);
            }
            locator<NavigationService>().navigateTo(navigationPath);
          },
          child: Row(
            children: [
              Image.asset(imagePath,width: 20,height: 20,),
              Text(title)
            ],
          )


        );
      }
    );
  }
}
