import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:last_ocr/functions/functions.dart';
import 'package:last_ocr/page/pregnant_list_page.dart';
import 'package:last_ocr/page/maternity_list_page.dart';
import 'package:last_ocr/page/graph_page.dart';
import 'package:last_ocr/page/owner_graph_page.dart';
import 'overlay/camera_overlay_maternity.dart';
import 'overlay/camera_overlay_pregnant.dart';

var mating_week = List<double>.filled(5, 0, growable: true);
var feedbaby_week = List<double>.filled(5, 0, growable: true);
var sevrer_week = List<double>.filled(5, 0, growable: true);
var totalbaby_week = List<double>.filled(5, 0, growable: true);

var goals = List<String>.filled(6, "");

var thisyear = DateTime.now().year;   // 년도
var thismonth = DateTime.now().month; // 월
List li=[];
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
                            Navigator.push(context, MaterialPageRoute(builder: (context) => CameraOverlayPregnant()));
                            },
                          child: const Text('OCR')
                      ),
                      OutlinedButton(
                          onPressed: ()async{
                            //서버로부터 값 받아오기
                            List<dynamic> list = await pregnant_getocr();
                            print("pregnant get ocr->");
                            print(list);
                            // PregnantListPage로 넘어가기
                            Navigator.push(context, MaterialPageRoute(builder: (context) => PregnantListPage(list)));
                          },
                          child: const Text('기록')
                      ),
                      OutlinedButton(
                          onPressed: () async {
                            // PregnantGraphPage로 넘어가기
                            await preparegraph();
                            Navigator.of(context).popUntil((route) => route.isFirst);
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) =>  GraphPage(mating_week,sevrer_week,totalbaby_week,feedbaby_week, goals)));
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
                              Navigator.push(context, MaterialPageRoute(builder: (context) => CameraOverlayMaternity()));
                            },
                          child: const Text('OCR')
                      ),
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
                          child: const Text('기록')
                      ),
                      OutlinedButton(
                          onPressed: () async {
                            // MaternityGraphPage로 넘어가기
                            await preparegraph();
                            Navigator.of(context).popUntil((route) => route.isFirst);
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => OwnerGraphPage(mating_week,sevrer_week,totalbaby_week,feedbaby_week, goals)));
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
  preparegraph() async{

    var now = DateTime(2022,thismonth,1); //선택한 달의 1일을 기준날짜로 잡음

    var firstSunday = DateTime(now.year, now.month, now.day - (now.weekday - 0)); //기준날짜가 속한 주의 일요일을 구함

    if(firstSunday.day>now.day){ // 찾아낸 일요일이 이전달일경우 +7일을 함 (ex)10.1일이 속한 일요일 9월25일 =(변경)=> 10월 2일)
      firstSunday = firstSunday.add(const Duration(days: 7));
    }

    var sunday = firstSunday;
    List templist=[]; // [시작날짜,끝날짜]를 저장하기 위한 임시 리스트
    templist.add(DateFormat('yyyy-MM-dd').format(sunday.add(const Duration(days:-6)))); //시작날짜계산법 : 일요일날짜-6
    templist.add(DateFormat('yyyy-MM-dd').format(sunday)); // 끝날짜
    li.add(templist); // [시작날짜,끝날짜] 형태로 리스트에 추가

    while(true){
      List templist=[];
      var nextsunday = sunday.add(const Duration(days: 7)); // 다음주 일요일 계산법 : 일요일+7
      if(nextsunday.day<sunday.day){ // 다음주 일요일이 다음달에 속할 경우 리스트에 추가하지 않고 반복문을 종료시킴.
        break;
      }
      templist.add(DateFormat('yyyy-MM-dd').format(nextsunday.add(const Duration(days:-6)))); // 시작날짜계산법 : 다음주일요일-6
      templist.add(DateFormat('yyyy-MM-dd').format(nextsunday));  // 끝날짜
      li.add(templist); // [시작날짜, 끝날짜] 형태로 리스트에 추가
      sunday = nextsunday; // 그 다음주를 계산하기 위해 sunday를 nextsunday로 변경
    }
    print(li);

    var pregnantdata= await send_date_pregnant(li);
    print(pregnantdata.length);
    for(int i=0; i<li.length; i++){
      if(pregnantdata[i]['sow_cross']==null){
        mating_week[i]=0;
      }else{
        mating_week[i] = pregnantdata[i]['sow_cross'];
      }
    }
    print(mating_week);

    var maternitydata= await send_date_maternity(li);
    print(maternitydata.length);
    for(int i=0; i<li.length; i++){
      if(maternitydata[i]['feedbaby']==null){
        feedbaby_week[i]=0;
      } else{
        feedbaby_week[i] = maternitydata[i]['feedbaby'];
      }
      if(maternitydata[i]['sevrer']==null){
        sevrer_week[i]=0;
      }else{
        sevrer_week[i] = maternitydata[i]['sevrer'];
      }
      if(maternitydata[i]['totalbaby']==null){
        totalbaby_week[i]=0;
      }else{
        totalbaby_week[i] = maternitydata[i]['totalbaby'];
      }
    }
    var targetdata= await ocrTargetSelectedRow(thisyear.toString(), thismonth.toString().padLeft(2, "0").toString());
    goals[0] = targetdata[0];
    goals[1] = targetdata[1];
    goals[2] = targetdata[2];
    goals[3] = targetdata[3];
    goals[4] = targetdata[4];
    goals[5] = targetdata[5];
    print(goals);
    li.clear();
  }

}
