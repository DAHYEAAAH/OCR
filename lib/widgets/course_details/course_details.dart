import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class CourseDetails extends StatelessWidget {
  const CourseDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        var textAlignment =
        sizingInformation.deviceScreenType == DeviceScreenType.desktop
            ? TextAlign.left
            : TextAlign.center;
        double titleSize =
        sizingInformation.deviceScreenType == DeviceScreenType.mobile
            ? 50
            : 80;

        double descriptionSize =
        sizingInformation.deviceScreenType == DeviceScreenType.mobile
            ? 16
            : 21;

        return Container(
          width: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/home_mobile_sim.png'),
            ],
          ),
        );
      },
    );
  }
}
