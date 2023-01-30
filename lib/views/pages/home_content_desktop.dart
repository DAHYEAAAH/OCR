import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class HomeContentDesktop extends StatefulWidget {
  const HomeContentDesktop({Key? key}) : super(key: key);

  @override
  State<HomeContentDesktop> createState() => _HomeContentDesktopState();
}

class _HomeContentDesktopState extends State<HomeContentDesktop> {
  late List save=[];
  @override
  void initState() {
    super.initState();
    homepage_img();
    // launchersGetList();
  }

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
                      CarouselSlider(
                        options: CarouselOptions(
                            height:300,
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 7),
                            enlargeCenterPage: true
                        ),
                        items: save.map((e) => ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: Image.network("https://www.dfxsoft.com/api/ocrGetImage/launchers/"+e))
                        ).toList()
                      ),
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
  // 이미지명 받아오기
  homepage_img() async {
    final api ="https://www.dfxsoft.com/api/launchersGetList";
    final dio = Dio();
    Response response = await dio.get(api);
    setState(() {
      for(int i = 0 ; i < response.data.length ; i++){
        save.add(response.data[i]);
      }
    });
  }
}