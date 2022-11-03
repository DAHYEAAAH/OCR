import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:last_ocr/functions/functions.dart';
import 'package:last_ocr/page/pregnant_list_page.dart';
import 'package:last_ocr/page/maternity_list_page.dart';
import 'package:last_ocr/page/graph_page.dart';
import 'package:last_ocr/page/owner_graph_page.dart';
import 'overlay/camera_overlay_maternity.dart';
import 'overlay/camera_overlay_pregnant.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}
class MyHomePage extends StatefulWidget {
  static const routeName = '/mainpage';


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyAppState extends State<MyApp> {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 화면 오른쪽에 뜨는 디버크 표시 지우기
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          padding: EdgeInsets.fromLTRB(50, 100, 50, 100),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("임신사"),
                    ],
                  ),
                  SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(width:20,),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => CameraOverlayPregnant()));
                          },
                        child: const Text('OCR',),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                        ),
                      ),
                      SizedBox(width:20,),
                      OutlinedButton(
                        onPressed: ()async{
                          //서버로부터 값 받아오기
                          List<dynamic> list = await pregnant_getocr();
                          print("pregnant get ocr->");
                          print(list);
                          // PregnantListPage로 넘어가기
                          Navigator.push(context, MaterialPageRoute(builder: (context) => PregnantListPage(list)));
                        },
                        child: const Text('기록'),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                        ),
                      ),
                      SizedBox(width:20,),
                    ],
                  ),
                  SizedBox(height:20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("분만사"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: <Widget>[
                      SizedBox(width:20,),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => CameraOverlayMaternity()));
                        },
                        child: const Text('OCR'),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                        ),
                      ),
                      SizedBox(width:20,),
                      OutlinedButton(
                        onPressed: () async{
                          //서버로부터 값 받아오기
                          List<dynamic> list = await maternity_getocr();
                          print("maternity get ocr->");
                          print(list);
                          // MaternityListPage로 넘어가기
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => MaternityListPage(list)));
                        },
                        child: const Text('기록'),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                        ),
                      ),
                      SizedBox(width:20,),
                    ],
                  ),
                  SizedBox(height: 30,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // SizedBox(width: 100,),
                      OutlinedButton(
                          onPressed: () async {
                            // PregnantGraphPage로 넘어가기
                            List graphdata = await preparegraph();
                            // Navigator.push(context, MaterialPageRoute(
                            //     builder: (context) =>  GraphPage(graphdata[0],graphdata[1],graphdata[2],graphdata[3],graphdata[4])
                            // ));

                            //****사장님 그래프 페이지를 보여줄 경우 위에 GraphPage는 주석후, 아래 주석을 풀어주세요***//
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => OwnerGraphPage(graphdata[0],graphdata[1],graphdata[2],graphdata[3],graphdata[4])
                            ));

                          },
                          child: const Text('그래프'),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(100, 0, 100, 0),
                          ),
                      ),
                      // SizedBox(width: 70,)
                    ],
                  ),
                ]
            )
        )
    );
  }
}
