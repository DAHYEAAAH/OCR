import 'dart:io';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../functions/functions.dart';


var mating_week = List<double>.filled(5, 0, growable: true);

late double mating_goal = 0;

late double feedbaby_week1 = 24;
late double feedbaby_week2 = 35;
late double feedbaby_week3 = 29;
late double feedbaby_week4 = 18;
late double feedbaby_goal = 27;

late double mortality_week1 = 11;
late double mortality_week2 = 24;
late double mortality_week3 = 32;
late double mortality_week4 = 37;
late double mortality_goal = 35;

late double shipment_week1 = 14;
late double shipment_week2 = 21;
late double shipment_week3 = 32;
late double shipment_week4 = 29;
late double shipment_goal = 35;

class PregnantGraphPage extends StatefulWidget {
  static const routeName = '/pregnant-graph-page';

  // const PregnantGraphPage({Key? key, this.title}) : super(key: key);
  final List<double> list_sow_cross ;
  final double goal_sow_cross ;
  const PregnantGraphPage(this.list_sow_cross,this.goal_sow_cross);
  // final String? title;

  @override
  PregnantGraphPageState createState() => PregnantGraphPageState();
}

class PregnantGraphPageState extends State<PregnantGraphPage> {
  var thisyear = DateTime.now().year;   // 년도
  var thismonth = DateTime.now().month; // 월
  List li=[];
  changeMonth() async{

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
    for(int i=0; i<li.length; i++){
      if(pregnantdata[i]['sow_cross']==null){
        mating_week[i]=0;
      }else{
        mating_week[i] = pregnantdata[i]['sow_cross'];
      }
    }
    print(mating_week);

    var targetdata= await ocrTargetSelectedRow(thisyear.toString(), thismonth.toString().padLeft(2, "0").toString());
    if(targetdata==null){
      mating_goal=0;
    }else {
      mating_goal = double.parse(targetdata[2]);
    }
    print(mating_goal);

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
    mating_week = widget.list_sow_cross;
    mating_goal = widget.goal_sow_cross;
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
                      onPressed: () async { decrease_month();await changeMonth();}, icon: Icon(Icons.navigate_before)
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

                      mainChart_sow_cross(li.length),
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
                      mainChart_sow_sevrer(),
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
                      mainChart_total_baby(),
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
                      mainChart_feed_baby(),
                    ),
                  ),
                ),
              ],
            ),
            // Stack(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   alignment: Alignment.bottomLeft,
            //   children: [
            //     FloatingActionButton(
            //       child: Icon(Icons.cached_outlined ),
            //       onPressed: () {
            //
            //       },
            //     )
            //   ],
            // )

          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.blue,
            child: Icon(Icons.refresh),
            onPressed: () async {
              setState(() {
                // Navigator.of(context).popUntil((route) => route.isFirst);
                // await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                //     PregnantPage(list, returnfilepath!)),
                // );
              });
            },
          ),
        ],
      ),
    );
  }
}

//교배복수**********************
LineChartData mainChart_sow_cross(int length) {
  print("Draww");
  List<Color> gradientColors_values = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  List<Color> gradientColorsAvg = [
    const Color(0xfffa0000),
    const Color(0xffffdd00),
  ];

  print(mating_week);
  double max=40;
  if(mating_goal>40)
    max = mating_goal+10;


  if(length==4)
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
              return '1주';
            case 3:
              return '2주';
            case 6:
              return '3주';
            case 9:
              return '4주';
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
        // getTitles: (value) {
        //   // print('leftTitles $value');
        //   if (value.toInt() == minvalue_mate) {
        //     return minvalue_mate.toInt().toString();
        //   }else if(value.toInt() == maxvalue_mate){
        //     return maxvalue_mate.toInt().toString();
        //   }else if(value.toInt() == goal_mate){
        //     return goal_mate.toInt().toString();
        //   }else{
        //     return value.toInt().toString();
        //   }
        //   // return '';
        // },
      ),
    ),
    // // borderData: FlBorderData(
    // //     show: true,
    // //     border: Border.all(color: const Color(0xff000000), width: 1)),
    minX: 0,
    maxX: 9,
    minY: 0,
    maxY: 40,
    lineBarsData: [
      LineChartBarData(
        spots: [
          FlSpot(0, mating_week[0]),
          FlSpot(3, mating_week[1]),
          FlSpot(6, mating_week[2]),
          FlSpot(9, mating_week[3]),
        ],

        isCurved: true,
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
        isCurved: true,
        colors: gradientColorsAvg,
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
              return '1주';
            case 3:
              return '2주';
            case 6:
              return '3주';
            case 9:
              return '4주';
            case 12:
              return '5주';
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

        isCurved: true,
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
  );
}

//이유두수******************
LineChartData mainChart_sow_sevrer() {
  List<Color> gradientColors_values = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  List<Color> gradientColors_avg = [
    const Color(0xfffa0000),
    const Color(0xffffdd00),
  ];

  final oneweek_feedbaby = feedbaby_week1;
  final twoweek_feedbaby = feedbaby_week2;
  final threeweek_feedbaby = feedbaby_week3;
  final fourweek_feedbaby = feedbaby_week4;
  final goal_feedbaby= feedbaby_goal;

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
              return '1주';
            case 3:
              return '2주';
            case 6:
              return '3주';
            case 9:
              return '4주';
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
        // getTitles: (value) {
        //   // print('leftTitles $value');
        //   if (value.toInt() == minvalue_teen) {
        //     return minvalue_teen.toInt().toString();
        //   }else if(value.toInt() == maxvalue_teen){
        //     return maxvalue_teen.toInt().toString();
        //   }else if(value.toInt() == goal_teen){
        //     return goal_teen.toInt().toString();
        //   }else{
        //     return value.toInt().toString();
        //   }
        // },
      ),
    ),
    // // borderData: FlBorderData(
    // //     show: true,
    // //     border: Border.all(color: const Color(0xff000000), width: 1)),
    minX: 0,
    maxX: 9,
    minY: 0,
    maxY: 40,
    lineBarsData: [
      LineChartBarData(
        spots: [
          FlSpot(0, oneweek_feedbaby.toDouble()),
          FlSpot(3, twoweek_feedbaby.toDouble()),
          FlSpot(6, threeweek_feedbaby.toDouble()),
          FlSpot(9, fourweek_feedbaby.toDouble()),
        ],

        isCurved: true,
        colors: gradientColors_values,
        barWidth: 5,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: true,
        ),
      ),
      LineChartBarData(
        spots: [
          FlSpot(0, goal_feedbaby.toDouble()),
          FlSpot(3, goal_feedbaby.toDouble()),
          FlSpot(6, goal_feedbaby.toDouble()),
          FlSpot(9, goal_feedbaby.toDouble()),
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
  );
}

//총산자수******************
LineChartData mainChart_total_baby() {

  List<Color> gradientColors_values = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  List<Color> gradientColors_avg = [
    const Color(0xfffa0000),
    const Color(0xffffdd00),
  ];
  // array_graph = receiveresult_graph();
  print("main 그래프 페이지 값 ");
  // print(array_graph);
  //var oneweek  = array_graph[0] as double;
  final oneweek_mortality = mortality_week1;
  final  twoweek_mortality = mortality_week2;
  final threeweek_mortality = mortality_week3;
  final fourweek_mortality = mortality_week4;
  final goal_die = mortality_goal;


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
              return '1주';
            case 3:
              return '2주';
            case 6:
              return '3주';
            case 9:
              return '4주';
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
        // getTitles: (value) {
        //   // print('leftTitles $value');
        //   if (value.toInt() == minvalue_die) {
        //     return minvalue_die.toInt().toString();
        //   }else if(value.toInt() == maxvalue_die){
        //     return maxvalue_die.toInt().toString();
        //   }else if(value.toInt() == goal_die){
        //     return goal_die.toInt().toString();
        //   }else{
        //     return value.toInt().toString();
        //   }
        //   return '';
        // },

      ),
    ),
    // // borderData: FlBorderData(
    // //     show: true,
    // //     border: Border.all(color: const Color(0xff000000), width: 1)),
    minX: 0,
    maxX: 9,
    minY: 0,
    maxY: 40,
    lineBarsData: [
      LineChartBarData(
        spots: [
          FlSpot(0, oneweek_mortality.toDouble()),
          FlSpot(3, twoweek_mortality.toDouble()),
          FlSpot(6, threeweek_mortality.toDouble()),
          FlSpot(9, fourweek_mortality.toDouble()),
        ],

        isCurved: true,
        colors: gradientColors_values,
        barWidth: 5,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: true,
        ),
      ),
      LineChartBarData(
        spots: [
          FlSpot(0, goal_die.toDouble()),
          FlSpot(3, goal_die.toDouble()),
          FlSpot(6, goal_die.toDouble()),
          FlSpot(9, goal_die.toDouble()),
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
  );
}

//포유개시******************
LineChartData mainChart_feed_baby() {
  List<Color> gradientColors_values = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  List<Color> gradientColors_avg = [
    const Color(0xfffa0000),
    const Color(0xffffdd00),
  ];
  // array_graph = receiveresult_graph();
  print("main 그래프 페이지 값 ");

  // print(array_graph);
  //var oneweek  = array_graph[0] as double;
  final oneweek_shipment = shipment_week1;
  final  twoweek_shipment = shipment_week2;
  final threeweek_shipment = shipment_week3;
  final fourweek_shipment = shipment_week4;
  final goal_shipment = shipment_goal;


  return LineChartData(

    gridData: FlGridData(
      show: true,
      drawVerticalLine: true,
      horizontalInterval: 10,
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
              return '1주';
            case 3:
              return '2주';
            case 6:
              return '3주';
            case 9:
              return '4주';
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
        // getTitles: (value) {
        //   // print('leftTitles $value');
        //   if (value.toInt() == minvalue_die) {
        //     return minvalue_die.toInt().toString();
        //   }else if(value.toInt() == maxvalue_die){
        //     return maxvalue_die.toInt().toString();
        //   }else if(value.toInt() == goal_die){
        //     return goal_die.toInt().toString();
        //   }else{
        //     return value.toInt().toString();
        //   }
        //   return '';
        // },
      ),
    ),
    // // borderData: FlBorderData(
    // //     show: true,
    // //     border: Border.all(color: const Color(0xff000000), width: 1)),
    minX: 0,
    maxX: 9,
    minY: 0,
    maxY: 40,
    lineBarsData: [
      LineChartBarData(
        spots: [
          FlSpot(0, oneweek_shipment.toDouble()),
          FlSpot(3, twoweek_shipment.toDouble()),
          FlSpot(6, threeweek_shipment.toDouble()),
          FlSpot(9, fourweek_shipment.toDouble()),
        ],

        isCurved: true,
        colors: gradientColors_values,
        barWidth: 5,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: true,
        ),
      ),
      LineChartBarData(
        spots: [
          FlSpot(0, goal_shipment.toDouble()),
          FlSpot(3, goal_shipment.toDouble()),
          FlSpot(6, goal_shipment.toDouble()),
          FlSpot(9, goal_shipment.toDouble()),
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
  );
}