import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';

class HomeContentDesktop extends StatelessWidget {
  HomeContentDesktop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          Expanded(
            child: Center(
                child: SingleChildScrollView (
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      image_slider_carouse,
                      SizedBox(
                        height: 10,
                      ),
                      launchUnderView(),
                    ],
                  ),
                )
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center, // Optional
          mainAxisAlignment: MainAxisAlignment.center, // Change to your own spacing
          children: [
            // Icon(Icons.copyright_outlined),
            Text("Copyright © G Farm & DFX LAB. All Rights Reserved."), //REPLACE WITH ICON
          ],
        ),
      ),
    );
  }

  Widget image_slider_carouse = Container(
    height: 400,width: 700,
    child: Carousel(
      boxFit: BoxFit.fill,
        
      images: [

        AssetImage('launchers/slide-1.png'),
        AssetImage('launchers/slide-2.png'),
        AssetImage('launchers/slide-3.png'),
        // AssetImage('launchers/slide-4.png'),
        // AssetImage('launchers/slide-5.png'),
        // AssetImage('launchers/slide-6.png'),
        // AssetImage('launchers/slide-7.png'),
        // AssetImage('launchers/slide-8.png'),
        // AssetImage('launchers/slide-9.png'),
        // AssetImage('launchers/slide-10.png'),
        // AssetImage('launchers/slide-11.png'),
        // AssetImage('launchers/slide-12.png'),
        // AssetImage('launchers/slide-13.png'),
        // AssetImage('launchers/slide-16.jpeg'),
        // AssetImage('launchers/slide-17.jpeg'),
        // AssetImage('launchers/slide-18.jpeg'),
        // AssetImage('launchers/slide-19.jpeg'),
        // AssetImage('launchers/slide-20.jpeg'),
        // AssetImage('launchers/slide-21.jpeg'),
        // AssetImage('launchers/slide-22.jpeg'),
        // AssetImage('launchers/slide-23.jpeg'),
        // AssetImage('launchers/slide-24.jpeg'),
        // AssetImage('launchers/slide-25.jpeg'),
        // AssetImage('launchers/slide-26.jpeg'),
        // AssetImage('launchers/slide-27.jpeg'),
      ],

      autoplay: true,
      indicatorBgPadding: 10.0,
      dotBgColor: Colors.white,
      dotColor: Colors.red,
      dotIncreasedColor: Colors.indigo,
      dotVerticalPadding: 0.0,
      dotSize: 3.0,
      autoplayDuration: Duration(seconds: 7),
    ),
  );

  Widget launchUnderView() {
    return Container(
        decoration: new BoxDecoration(
        ),
        child:Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              child: Column(
                children: [
                  Card(
                      child: Image.asset('assets/pig_room1.png',width: 200,height: 130,)
                  ),
                  Text('안성농장')
                ],
              ),
            ),
            SizedBox(
              child: Column(
                children: [
                  Card(
                      child: Image.asset('assets/pig_room2.png',width: 200,height: 130,)
                  ),
                  Text('경주농장')
                ],
              ),
            ),
            SizedBox(
              child: Column(
                children: [
                  Card(
                      child: Image.asset('assets/pig_room3.png',width: 200,height: 130,)
                  ),
                  Text('영천농장')
                ],
              ),
            ),
          ],
        )
    );
  }
}