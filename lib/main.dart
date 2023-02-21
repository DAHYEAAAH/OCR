import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:last_ocr/functions/functions.dart';
import 'package:last_ocr/page/graph_target_page.dart';
import 'package:last_ocr/page/pregnant_list_page.dart';
import 'package:last_ocr/page/maternity_list_page.dart';
import 'package:last_ocr/page/graph_page.dart';
import 'package:last_ocr/views/VenderList.dart';
import 'package:last_ocr/views/sale_pig_view.dart';
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
  List<String> dropdownList = ['안성', '영천', '경주'];
  String selectedDropdown = '안성';
  String index_of_farm = '0';
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
                      DropdownButton(
                        value: selectedDropdown,
                        items: dropdownList.map((String item) {
                          return DropdownMenuItem<String>(
                            child: Text('$item'),
                            value: item,
                          );
                        }).toList(),
                        onChanged: (dynamic value) {
                          setState(() {
                            selectedDropdown = value;
                            switch(selectedDropdown){
                              case "안성":
                                index_of_farm = '0';
                                break;
                              case "영천":
                                index_of_farm = '1';
                                break;
                              case "경주":
                                index_of_farm = '2';
                                break;
                            }
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height:20,),
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
                          Navigator.push(context, MaterialPageRoute(builder: (context) => CameraOverlayPregnant(companyCode: index_of_farm)));
                          },
                        child: const Text('OCR',),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                        ),
                      ),
                      SizedBox(width:20,),
                      OutlinedButton(
                        onPressed: ()async{
                          // PregnantListPage로 넘어가기
                          Navigator.push(context, MaterialPageRoute(builder: (context) => PregnantListPage(companyCode: index_of_farm,)));
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
                          Navigator.push(context, MaterialPageRoute(builder: (context) => CameraOverlayMaternity(companyCode: index_of_farm)));
                        },
                        child: const Text('OCR'),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                        ),
                      ),
                      SizedBox(width:20,),
                      OutlinedButton(
                        onPressed: () async{
                          // MaternityListPage로 넘어가기
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => MaternityListPage(companyCode: index_of_farm,)));
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
                            Navigator.push(context, MaterialPageRoute(builder: (context) =>  GraphPage(companyCode: index_of_farm,)));
                          },
                          child: const Text('그래프'),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(100, 0, 100, 0),
                          ),
                      ),
                      // SizedBox(width: 70,)
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
                          Navigator.push(context, MaterialPageRoute(builder: (context) => TargetValueView(companyCode: index_of_farm,)));
                          },
                        child: const Text('목표값'),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.fromLTRB(100, 0, 100, 0),
                        ),
                      ),
                      // SizedBox(width: 70,)
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // SizedBox(width: 100,),
                      OutlinedButton(
                        onPressed: () async {
                          // PregnantGraphPage로 넘어가기
                          Navigator.push(context, MaterialPageRoute(builder: (context) => VenderList()));
                        },
                        child: const Text('vender'),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.fromLTRB(100, 0, 100, 0),
                        ),
                      ),
                      // SizedBox(width: 70,)
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // SizedBox(width: 100,),
                      OutlinedButton(
                        onPressed: () async {
                          // PregnantGraphPage로 넘어가기
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SalepigView(companyCode: "0")));
                        },
                        child: const Text('salepig'),
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
