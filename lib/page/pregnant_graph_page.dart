import 'dart:io';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../functions/functions.dart';


var mating_week = new List<double>.filled(5,0);
late double mating_goal = 0;
var sevrer_week = new List<double>.filled(5,0);
late double sevrer_goal = 0;
var totalbaby_week = new List<double>.filled(5,0);
late double totalbaby_goal = 0;
var feedbaby_week = new List<double>.filled(5,0);
late double feedbaby_goal = 0;

class PregnantGraphPage extends StatefulWidget {
  static const routeName = '/pregnant-graph-page';

  // const PregnantGraphPage({Key? key, this.title}) : super(key: key);
  final List<double> list_sow_cross ;
  final List<double> list_sow_sevrer ;
  final List<double> list_sow_totalbaby ;
  final List<double> list_sow_feedbaby ;
  final List<double> goal ; //년도,월,총산,포유,이유,교배 순
  const PregnantGraphPage(this.list_sow_cross,this.list_sow_sevrer,this.list_sow_totalbaby,this.list_sow_feedbaby,this.goal);
  // final String? title;

  @override
  PregnantGraphPageState createState() => PregnantGraphPageState();
}

class PregnantGraphPageState extends State<PregnantGraphPage> {
  var thisyear = DateTime.now().year;   // 년도
  var thismonth = DateTime.now().month; // 월
  List li=[];
  changeMonth() async{
    li.clear();
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
    var targetdata= await ocrTargetSelectedRow(thisyear.toString(), thismonth.toString().padLeft(2, "0").toString());
    var maternitydata= await send_date_maternity(li);
    setState(() {
      for(int i=0; i<li.length; i++){
        if(pregnantdata[i]['sow_cross']==null){
          mating_week[i]=0;
        }else{
          mating_week[i] = pregnantdata[i]['sow_cross'];
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
        if(maternitydata[i]['feedbaby']==null){
          feedbaby_week[i]=0;
        }else{
          feedbaby_week[i] = maternitydata[i]['feedbaby'];
        }
      }
      if(targetdata==null){
        mating_goal=0;
        sevrer_goal=0;
        totalbaby_goal=0;
        feedbaby_goal=0;
      }else {
        mating_goal = double.parse(targetdata[5]);
        sevrer_goal = double.parse(targetdata[4]);
        totalbaby_goal = double.parse(targetdata[2]);
        feedbaby_goal = double.parse(targetdata[3]);
      }
    });
    print(mating_goal);print(sevrer_goal);print(totalbaby_goal);print(feedbaby_goal);

  }


  void increase_month(){ // 다음달 넘기기 버튼 누를때
    setState(() {
      thismonth++;
      if(thismonth>12) { // 다음년도로 넘어가기
        thismonth = 1;
        thisyear++;
      }
    });
  }
  void decrease_month(){  // 이전달 넘기기 버튼 누를때
    setState(() {
      thismonth--;
      if(thismonth<1) { // 이전년도로 넘어가기
        thismonth = 12;
        thisyear--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print("buildddd--------");
    if(widget.goal[0]==thisyear&&widget.goal[1]==thismonth) {
      mating_week = widget.list_sow_cross;
      mating_goal = widget.goal[5];
      sevrer_week = widget.list_sow_sevrer;
      sevrer_goal = widget.goal[4];
      totalbaby_week = widget.list_sow_totalbaby;
      totalbaby_goal = widget.goal[2];
      feedbaby_week = widget.list_sow_feedbaby;
      feedbaby_goal = widget.goal[3];
      print(mating_goal);print(sevrer_goal);print(totalbaby_goal);print(feedbaby_goal);
      print(mating_week);print(sevrer_week);print(totalbaby_week);print(feedbaby_week);

    }
    return Scaffold(
      appBar: AppBar(
          title: Text("임신사 그래프")
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(10, 20, 10, 50),
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget> [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () async { decrease_month(); changeMonth();}, icon: Icon(Icons.navigate_before)
                  ),
                  Text('$thisyear'.toString()+"년 "+'$thismonth'.toString()+"월",style: TextStyle(fontSize: 25),),

                  IconButton(
                      onPressed: () { increase_month();changeMonth();}, icon: Icon(Icons.navigate_next)
                  )
                ]
            ),
            Column(
              children: [
                Text("교배",style:TextStyle(fontSize: 20),),
                AspectRatio(aspectRatio: 3/2,
                  child:Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 30, 30),
                    child: LineChart(
                      mainChart_sow_cross(li),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text("이유",style:TextStyle(fontSize: 20),),
                AspectRatio(aspectRatio: 3/2,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 30, 30),
                    child: LineChart(
                      mainChart_sow_sevrer(li),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text("총산자수",style:TextStyle(fontSize: 20),),
                AspectRatio(aspectRatio: 3/2,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 30, 30),
                    child: LineChart(
                      mainChart_total_baby(li),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text("포유",style:TextStyle(fontSize: 20),),
                AspectRatio(aspectRatio: 3/2,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 30, 30),
                    child: LineChart(
                      mainChart_feed_baby(li),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//교배복수**********************
LineChartData mainChart_sow_cross(List li) {
  print("Draww");
  print(li);
  List<Color> gradientColors_values = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  List<Color> gradientColorsAvg = [
    const Color(0xfffa0000),
    const Color(0xffffdd00),
  ];

  double max=40;
  if(mating_goal>40)
    max = mating_goal+10;

  if(li.length==4){
    return LineChartData(

      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 10,
        drawHorizontalLine: true,

        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Color(0xff000000),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Color(0xff000000),
            strokeWidth: 1,
          );
        },
      ),

      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle: const TextStyle(
              color: Color(0xff000000),
              fontWeight: FontWeight.bold,
              fontSize: 16),
          getTitles: (value) {
            // print('bottomTitles $value');
            switch (value.toInt()) {
              case 0:
                return li[0][1].toString().replaceFirst('0', '').split("-").last+"일";
              case 3:
                return li[1][1].toString().split("-").last+"일";
              case 6:
                return li[2][1].toString().split("-").last+"일";
              case 9:
                return li[3][1].toString().split("-").last+"일";
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          interval: 10,
          textStyle: const TextStyle(
            color: Color(0xff000000),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
      // // borderData: FlBorderData(
      // //     show: true,
      // //     border: Border.all(color: const Color(0xff000000), width: 1)),
      minX: 0,
      maxX: 9,
      minY: 0,
      maxY: max,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, mating_week[0]),
            FlSpot(3, mating_week[1]),
            FlSpot(6, mating_week[2]),
            FlSpot(9, mating_week[3]),
          ],

          isCurved: false,
          colors: gradientColors_values,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
          ),
        ),
        LineChartBarData(
          spots: [
            FlSpot(0, mating_goal.toDouble()),
            FlSpot(3, mating_goal.toDouble()),
            FlSpot(6, mating_goal.toDouble()),
            FlSpot(9, mating_goal.toDouble()),
          ],
          isCurved: false,
          colors: gradientColorsAvg,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
          ),
        ),
      ],
    );}
  else{
    return LineChartData(

      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 10,
        drawHorizontalLine: true,

        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Color(0xff000000),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Color(0xff000000),
            strokeWidth: 1,
          );
        },
      ),

      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle: const TextStyle(
              color: Color(0xff000000),
              fontWeight: FontWeight.bold,
              fontSize: 16),
          getTitles: (value) {
            // print('bottomTitles $value');
            switch (value.toInt()) {
              case 0:
                return li[0][1].toString().split("-").last+"일";
              case 3:
                return li[1][1].toString().split("-").last+"일";
              case 6:
                return li[2][1].toString().split("-").last+"일";
              case 9:
                return li[3][1].toString().split("-").last+"일";
              case 12:
                return li[4][1].toString().split("-").last+"일";
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          interval: 10,
          textStyle: const TextStyle(
            color: Color(0xff000000),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),

        ),
      ),
      minX: 0,
      maxX: 12,
      minY: 0,
      maxY: max,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, mating_week[0]),
            FlSpot(3, mating_week[1]),
            FlSpot(6, mating_week[2]),
            FlSpot(9, mating_week[3]),
            FlSpot(12, mating_week[4]),
          ],

          isCurved: false,
          colors: gradientColors_values,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
          ),
        ),
        LineChartBarData(
          spots: [
            FlSpot(0, mating_goal.toDouble()),
            FlSpot(3, mating_goal.toDouble()),
            FlSpot(6, mating_goal.toDouble()),
            FlSpot(9, mating_goal.toDouble()),
            FlSpot(12, mating_goal.toDouble()),
          ],
          isCurved: true,
          colors: gradientColorsAvg,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
          ),
        ),
      ],
    );}
}

//이유두수******************
LineChartData mainChart_sow_sevrer(List li) {
  List<Color> gradientColors_values = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  List<Color> gradientColors_avg = [
    const Color(0xfffa0000),
    const Color(0xffffdd00),
  ];
  double max=300;
  if(sevrer_goal>300)
    max = sevrer_goal+10;
  if(li.length ==4)
    return LineChartData(

      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 100,
        drawHorizontalLine: true,

        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Color(0xff000000),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Color(0xff000000),
            strokeWidth: 1,
          );
        },
      ),

      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle: const TextStyle(
              color: Color(0xff000000),
              fontWeight: FontWeight.bold,
              fontSize: 16),
          getTitles: (value) {
            // print('bottomTitles $value');
            switch (value.toInt()) {
              case 0:
                return li[0][1].toString().split("-").last+"일";
              case 3:
                return li[1][1].toString().split("-").last+"일";
              case 6:
                return li[2][1].toString().split("-").last+"일";
              case 9:
                return li[3][1].toString().split("-").last+"일";
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          interval: 100,
          textStyle: const TextStyle(
            color: Color(0xff000000),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
      minX: 0,
      maxX: 9,
      minY: 0,
      maxY: max,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, sevrer_week[0].toDouble()),
            FlSpot(3, sevrer_week[1].toDouble()),
            FlSpot(6, sevrer_week[2].toDouble()),
            FlSpot(9, sevrer_week[3].toDouble()),
          ],

          isCurved: false,
          colors: gradientColors_values,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
          ),
        ),
        LineChartBarData(
          spots: [
            FlSpot(0, sevrer_goal.toDouble()),
            FlSpot(3, sevrer_goal.toDouble()),
            FlSpot(6, sevrer_goal.toDouble()),
            FlSpot(9, sevrer_goal.toDouble()),
          ],
          isCurved: false,
          colors: gradientColors_avg,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
          ),
        ),
      ],
    );
  else
    return LineChartData(

      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 100,
        drawHorizontalLine: true,

        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Color(0xff000000),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Color(0xff000000),
            strokeWidth: 1,
          );
        },
      ),

      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle: const TextStyle(
              color: Color(0xff000000),
              fontWeight: FontWeight.bold,
              fontSize: 16),
          getTitles: (value) {
            // print('bottomTitles $value');
            switch (value.toInt()) {
              case 0:
                return li[0][1].toString().split("-").last+"일";
              case 3:
                return li[1][1].toString().split("-").last+"일";
              case 6:
                return li[2][1].toString().split("-").last+"일";
              case 9:
                return li[3][1].toString().split("-").last+"일";
              case 12:
                return li[4][1].toString().split("-").last+"일";
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          interval: 100,
          textStyle: const TextStyle(
            color: Color(0xff000000),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
      minX: 0,
      maxX: 12,
      minY: 0,
      maxY: max,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, sevrer_week[0].toDouble()),
            FlSpot(3, sevrer_week[1].toDouble()),
            FlSpot(6, sevrer_week[2].toDouble()),
            FlSpot(9, sevrer_week[3].toDouble()),
            FlSpot(12, sevrer_week[4].toDouble()),
          ],

          isCurved: false,
          colors: gradientColors_values,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
          ),
        ),
        LineChartBarData(
          spots: [
            FlSpot(0, sevrer_goal.toDouble()),
            FlSpot(3, sevrer_goal.toDouble()),
            FlSpot(6, sevrer_goal.toDouble()),
            FlSpot(9, sevrer_goal.toDouble()),
            FlSpot(12, sevrer_goal.toDouble()),
          ],
          isCurved: false,
          colors: gradientColors_avg,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
          ),
        ),
      ],
    );
}

//총산자수******************
LineChartData mainChart_total_baby(List li) {

  List<Color> gradientColors_values = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  List<Color> gradientColors_avg = [
    const Color(0xfffa0000),
    const Color(0xffffdd00),
  ];

  double max=300;
  if(sevrer_goal>300)
    max = sevrer_goal+10;

  if(li.length==4) {
    return LineChartData(

      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 100,
        drawHorizontalLine: true,

        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Color(0xff000000),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Color(0xff000000),
            strokeWidth: 1,
          );
        },
      ),

      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle: const TextStyle(
              color: Color(0xff000000),
              fontWeight: FontWeight.bold,
              fontSize: 16),
          getTitles: (value) {
            // print('bottomTitles $value');
            switch (value.toInt()) {
              case 0:
                return li[0][1].toString().split("-").last+"일";
              case 3:
                return li[1][1].toString().split("-").last+"일";
              case 6:
                return li[2][1].toString().split("-").last+"일";
              case 9:
                return li[3][1].toString().split("-").last+"일";
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          interval: 100,
          textStyle: const TextStyle(
            color: Color(0xff000000),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
      minX: 0,
      maxX: 9,
      minY: 0,
      maxY: max,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, totalbaby_week[0].toDouble()),
            FlSpot(3, totalbaby_week[1].toDouble()),
            FlSpot(6, totalbaby_week[2].toDouble()),
            FlSpot(9, totalbaby_week[3].toDouble()),
          ],

          isCurved: false,
          colors: gradientColors_values,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
          ),
        ),
        LineChartBarData(
          spots: [
            FlSpot(0, totalbaby_goal.toDouble()),
            FlSpot(3, totalbaby_goal.toDouble()),
            FlSpot(6, totalbaby_goal.toDouble()),
            FlSpot(9, totalbaby_goal.toDouble()),
          ],
          isCurved: false,
          colors: gradientColors_avg,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
          ),
        ),
      ],
    );}
  else{
    return LineChartData(

      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 100,
        drawHorizontalLine: true,

        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Color(0xff000000),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Color(0xff000000),
            strokeWidth: 1,
          );
        },
      ),

      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle: const TextStyle(
              color: Color(0xff000000),
              fontWeight: FontWeight.bold,
              fontSize: 16),
          getTitles: (value) {
            // print('bottomTitles $value');
            switch (value.toInt()) {
              case 0:
                return li[0][1].toString().split("-").last+"일";
              case 3:
                return li[1][1].toString().split("-").last+"일";
              case 6:
                return li[2][1].toString().split("-").last+"일";
              case 9:
                return li[3][1].toString().split("-").last+"일";
              case 12:
                return li[4][1].toString().split("-").last+"일";
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          interval: 100,
          textStyle: const TextStyle(
            color: Color(0xff000000),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),

        ),
      ),
      minX: 0,
      maxX: 12,
      minY: 0,
      maxY: max,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, totalbaby_week[0].toDouble()),
            FlSpot(3, totalbaby_week[1].toDouble()),
            FlSpot(6, totalbaby_week[2].toDouble()),
            FlSpot(9, totalbaby_week[3].toDouble()),
            FlSpot(12, totalbaby_week[4].toDouble()),
          ],

          isCurved: false,
          colors: gradientColors_values,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
          ),
        ),
        LineChartBarData(
          spots: [
            FlSpot(0, totalbaby_goal.toDouble()),
            FlSpot(3, totalbaby_goal.toDouble()),
            FlSpot(6, totalbaby_goal.toDouble()),
            FlSpot(9, totalbaby_goal.toDouble()),
            FlSpot(12, totalbaby_goal.toDouble()),
          ],
          isCurved: true,
          colors: gradientColors_avg,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
          ),
        ),
      ],
    );}

}

//포유개시******************
LineChartData mainChart_feed_baby(List li) {
  List<Color> gradientColors_values = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  List<Color> gradientColors_avg = [
    const Color(0xfffa0000),
    const Color(0xffffdd00),
  ];

  double max=400;
  if(sevrer_goal>400)
    max = sevrer_goal+10;

  if(li.length==4) {
    return LineChartData(

      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 100,
        drawHorizontalLine: true,

        //가로선
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Color(0xff000000),
            strokeWidth: 1,
          );
        },
        //세로선
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Color(0xff000000),
            strokeWidth: 1,
          );
        },
      ),

      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle: const TextStyle(
              color: Color(0xff000000),
              fontWeight: FontWeight.bold,
              fontSize: 16),
          getTitles: (value) {
            // print('bottomTitles $value');
            switch (value.toInt()) {
              case 0:
                return li[0][1].toString().split("-").last+"일";
              case 3:
                return li[1][1].toString().split("-").last+"일";
              case 6:
                return li[2][1].toString().split("-").last+"일";
              case 9:
                return li[3][1].toString().split("-").last+"일";
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          interval: 100,
          textStyle: const TextStyle(
            color: Color(0xff000000),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
      minX: 0,
      maxX: 9,
      minY: 0,
      maxY: max,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, feedbaby_week[0].toDouble()),
            FlSpot(3, feedbaby_week[1].toDouble()),
            FlSpot(6, feedbaby_week[2].toDouble()),
            FlSpot(9, feedbaby_week[3].toDouble()),
          ],

          isCurved: false,
          colors: gradientColors_values,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
          ),
        ),
        LineChartBarData(
          spots: [
            FlSpot(0, feedbaby_goal.toDouble()),
            FlSpot(3, feedbaby_goal.toDouble()),
            FlSpot(6, feedbaby_goal.toDouble()),
            FlSpot(9, feedbaby_goal.toDouble()),
          ],
          isCurved: false,
          colors: gradientColors_avg,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
          ),
        ),
      ],
    );
  }
  else{
    return LineChartData(

      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 100,
        drawHorizontalLine: true,

        //가로선
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Color(0xff000000),
            strokeWidth: 1,
          );
        },
        //세로선
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Color(0xff000000),
            strokeWidth: 1,
          );
        },
      ),

      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle: const TextStyle(
              color: Color(0xff000000),
              fontWeight: FontWeight.bold,
              fontSize: 16),
          getTitles: (value) {
            // print('bottomTitles $value');
            switch (value.toInt()) {
              case 0:
                return li[0][1].toString().split("-").last+"일";
              case 3:
                return li[1][1].toString().split("-").last+"일";
              case 6:
                return li[2][1].toString().split("-").last+"일";
              case 9:
                return li[3][1].toString().split("-").last+"일";
              case 12:
                return li[4][1].toString().split("-").last+"일";
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          interval: 100,
          textStyle: const TextStyle(
            color: Color(0xff000000),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),

        ),
      ),
      minX: 0,
      maxX: 12,
      minY: 0,
      maxY: max,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, feedbaby_week[0].toDouble()),
            FlSpot(3, feedbaby_week[1].toDouble()),
            FlSpot(6, feedbaby_week[2].toDouble()),
            FlSpot(9, feedbaby_week[3].toDouble()),
            FlSpot(12, feedbaby_week[4].toDouble()),
          ],

          isCurved: false,
          colors: gradientColors_values,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
          ),
        ),
        LineChartBarData(
          spots: [
            FlSpot(0, feedbaby_goal.toDouble()),
            FlSpot(3, feedbaby_goal.toDouble()),
            FlSpot(6, feedbaby_goal.toDouble()),
            FlSpot(9, feedbaby_goal.toDouble()),
            FlSpot(12, feedbaby_goal.toDouble()),
          ],
          isCurved: false,
          colors: gradientColors_avg,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
          ),
        ),
      ],
    );
  }
}