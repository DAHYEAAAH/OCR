import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class CenteredView extends StatelessWidget {
  final Widget child;
  const CenteredView({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
        builder: (context, sizingInformation) {
          double horizontalSize =
          sizingInformation.deviceScreenType == DeviceScreenType.mobile
              ? 20
              : 70;
        return Container(
          padding: EdgeInsets.symmetric(horizontal: horizontalSize, vertical: 0),
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 1200),
            child: child,
          ),
        );
      }
    );
  }
}
