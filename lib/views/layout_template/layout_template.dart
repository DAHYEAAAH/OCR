import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../locator.dart';
import '../../routing/route_names.dart';
import '../../routing/router.dart';
import '../../services/navigation_service.dart';
import '../../widgets/centered_view/centered_view.dart';
import '../../widgets/navigation_bar/navigation_bar.dart';
import '../../widgets/navigation_drawer/navigation_drawer.dart' as prefix;

class LayoutTemplate extends StatelessWidget {
  const LayoutTemplate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) => Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // DrawerItem('', 'assets/logontext.png', HomeRoute),
              // Image.asset('assets/logontext.png',width: 200,height: 40,),
              TextButton(
                onPressed: () {
                  locator<NavigationService>().navigateTo(HomeRoute);
                },
                child: Image.asset('assets/logontext.png',width: 200,height: 40,),
              ),
            ],
          ),
        ),
        drawer: sizingInformation.deviceScreenType == DeviceScreenType.mobile
            ? NavigationDrawer(children: [],)
            : null,
        backgroundColor: Colors.white,
        body: CenteredView(
          child: Column(
            children: <Widget>[
              CustomNavigationBar(),
              Expanded(
                child: Navigator(
                  key: locator<NavigationService>().navigatorKey,
                  onGenerateRoute: generateRoute,
                  initialRoute: HomeRoute,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
