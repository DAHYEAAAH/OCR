import 'package:flutter/material.dart';
import 'package:get_rx/get_rx.dart';
import 'package:last_ocr/entities/Ocr_pregnant.dart';
import 'package:last_ocr/functions/functions.dart';
import 'package:last_ocr/page/pregnant_list_page.dart';
import 'package:last_ocr/page/maternity_list_page.dart';
import 'package:last_ocr/page/maternity_graph_page.dart';
import 'package:last_ocr/page/maternity_page.dart';
import 'package:last_ocr/page/pregnant_graph_page.dart';
import 'package:last_ocr/page/pregnant_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}
class MyHomePage extends StatefulWidget {

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyAppState extends State<MyApp> {

  var pregnants = <Ocr_pregnant>[].obs;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("임신사")
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                    children: <Widget>[
                      OutlinedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                                // builder: (context) => PregnantPage([],"")));
                                builder: (context) => PregnantPage([],"")));
                                // builder:(context)=> LargeFileMain()));
                            },
                          child: const Text('OCR')
                      ),
                      OutlinedButton(
                          onPressed: ()async{
                            //화면전환
                            //서버로부터 값 받아오기
                            List<dynamic> list = await pregnant_getocr();
                            print("pregnant get ocr->");
                            print(list);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => PregnantListPage(list)));
                          },
                          child: const Text('기록')
                      ),
                      OutlinedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) =>  PregnantGraphPage()));
                          },
                          child: const Text('그래프')
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("분만사")
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      OutlinedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => MaternityPage([],"")));
                          },
                          child: const Text('OCR')
                      ),
                      OutlinedButton(
                          onPressed: () async{
                            List<dynamic> list = await maternity_getocr();
                            print("maternity get ocr->");
                            print(list);
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => MaternityListPage(list)));
                          },
                          child: const Text('기록')
                      ),
                      OutlinedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => MaternityGraphPage()));
                          },
                          child: const Text('그래프')
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      OutlinedButton(
                          onPressed: () {
                            delete_pregnant();
                          },
                          child: const Text('삭제')
                      ),
                    ],
                  ),
                ]
            )
        )
    );
  }
}
