
// import 'dart:html';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

late List<double> array_graph = List.filled(8, 0, growable: true);
var int_list = List<int>.filled(5, 0);


class PregnantGraphPage extends StatefulWidget {
  static const routeName = '/camera-page';

  const PregnantGraphPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  PregnantGraphPageState createState() => PregnantGraphPageState();
}

class PregnantGraphPageState extends State<PregnantGraphPage> {

  //late List<double> array_graph = [10, 20, 30, 40, 0, 40 ,25, 0];

  List<Color> gradientColors = [
    const Color(0xffffffff),
    const Color(0xffffffff),
  ];

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            children: [
              AspectRatio(aspectRatio: 3/2,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10),
                      ),
                      color: Color(0xffffffff)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),

                    // child: LineChart(
                    //   mainChart(),
                    // ),
                  ),
                ),
              )
            ],
          ),
          Column(
            children: [
              AspectRatio(aspectRatio: 3/2,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10),
                      ),
                      color: Color(0xffffffff)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
                    child: LineChart(
                      mainChart1(),
                    ),
                  ),
                ),
              )
            ],
          ),
          Column(
            children: [
              AspectRatio(aspectRatio: 3/2,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10),
                      ),
                      color: Color(0xffffffff)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
                    child: LineChart(
                      mainChart2(),
                    ),
                  ),
                ),
              )
            ],
          ),
          Column(
            children: [
              AspectRatio(aspectRatio: 3/2,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10),
                      ),
                      color: Color(0xffffffff)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
                    child: LineChart(
                      mainChart3(),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

//교배**********************
LineChartData mainChart() {
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
  final oneweek_mate = array_graph[0];
  final  twoweek_mate = array_graph[1];
  final threeweek_mate = array_graph[2];
  final fourweek_mate = array_graph[3];
  final goal_mate = array_graph[4];
  final minvalue_mate = array_graph[5];
  final maxvalue_mate = array_graph[6];
  final middlevalue_mate = array_graph[7];

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
        getTitles: (value) {
          // print('leftTitles $value');
          if (value.toInt() == minvalue_mate) {
            return minvalue_mate.toInt().toString();
          }else if(value.toInt() == maxvalue_mate){
            return maxvalue_mate.toInt().toString();
          }else if(value.toInt() == goal_mate){
            return goal_mate.toInt().toString();
          }else{
            return value.toInt().toString();
          }
          return '';
        },
        reservedSize: 28,
        margin: 12,
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
          FlSpot(0, oneweek_mate),
          FlSpot(3, twoweek_mate),
          FlSpot(6, threeweek_mate),
          FlSpot(9, fourweek_mate),
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
          FlSpot(0, goal_mate),
          FlSpot(3, goal_mate),
          FlSpot(6, goal_mate),
          FlSpot(9, goal_mate),
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


//이유******************
LineChartData mainChart1() {
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
  final oneweek_teen = array_graph[0];
  final  twoweek_teen = array_graph[1];
  final threeweek_teen = array_graph[2];
  final fourweek_teen = array_graph[3];
  final goal_teen = array_graph[4];
  final minvalue_teen = array_graph[5];
  final maxvalue_teen = array_graph[6];
  final middlevalue_teen = array_graph[7];

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
        getTitles: (value) {
          // print('leftTitles $value');
          if (value.toInt() == minvalue_teen) {
            return minvalue_teen.toInt().toString();
          }else if(value.toInt() == maxvalue_teen){
            return maxvalue_teen.toInt().toString();
          }else if(value.toInt() == goal_teen){
            return goal_teen.toInt().toString();
          }else{
            return value.toInt().toString();
          }
          return '';
        },
        reservedSize: 28,
        margin: 12,
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
          FlSpot(0, oneweek_teen),
          FlSpot(3, twoweek_teen),
          FlSpot(6, threeweek_teen),
          FlSpot(9, fourweek_teen),
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
          FlSpot(0, goal_teen),
          FlSpot(3, goal_teen),
          FlSpot(6, goal_teen),
          FlSpot(9, goal_teen),
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

//폐사******************
LineChartData mainChart2() {
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
  final oneweek_die = array_graph[0];
  final  twoweek_die = array_graph[1];
  final threeweek_die = array_graph[2];
  final fourweek_die = array_graph[3];
  final goal_die = array_graph[4];
  final minvalue_die = array_graph[5];
  final maxvalue_die = array_graph[6];


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
        getTitles: (value) {
          // print('leftTitles $value');
          if (value.toInt() == minvalue_die) {
            return minvalue_die.toInt().toString();
          }else if(value.toInt() == maxvalue_die){
            return maxvalue_die.toInt().toString();
          }else if(value.toInt() == goal_die){
            return goal_die.toInt().toString();
          }else{
            return value.toInt().toString();
          }
          return '';
        },
        reservedSize: 28,
        margin: 12,
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
          FlSpot(0, oneweek_die),
          FlSpot(3, twoweek_die),
          FlSpot(6, threeweek_die),
          FlSpot(9, fourweek_die),
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
          FlSpot(0, goal_die),
          FlSpot(3, goal_die),
          FlSpot(6, goal_die),
          FlSpot(9, goal_die),
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

//출하******************
LineChartData mainChart3() {
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
  final oneweek_shipment = array_graph[0];
  final  twoweek_shipment = array_graph[1];
  final threeweek_shipment = array_graph[2];
  final fourweek_shipment = array_graph[3];
  final goal_shipment = array_graph[4];
  final minvalue_shipment = array_graph[5];
  final maxvalue_shipment = array_graph[6];
  final middlevalue_shipment = array_graph[7];

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
        getTitles: (value) {
          // print('leftTitles $value');
          if (value.toInt() == minvalue_shipment) {
            return minvalue_shipment.toInt().toString();
          }else if(value.toInt() == maxvalue_shipment){
            return maxvalue_shipment.toInt().toString();
          }else if(value.toInt() == goal_shipment){
            return goal_shipment.toInt().toString();
          }else{
            return value.toInt().toString();
          }
          return '';
        },
        reservedSize: 28,
        margin: 12,
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
          FlSpot(0, oneweek_shipment),
          FlSpot(3, twoweek_shipment),
          FlSpot(6, threeweek_shipment),
          FlSpot(9, fourweek_shipment),
        ],

        isCurved: true,
        colors: gradientColors_values,
        barWidth: 100,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: true,
        ),
      ),
      LineChartBarData(
        spots: [
          FlSpot(0, goal_shipment),
          FlSpot(3, goal_shipment),
          FlSpot(6, goal_shipment),
          FlSpot(9, goal_shipment),
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
//
// Row(
// children: [
// print(a);
// mainChart();
// array_graph[0] = a[0].toDouble();
// array_graph[1] = a[1].toDouble();
// array_graph[2] = a[2].toDouble();
// array_graph[3] = a[3].toDouble();
// array_graph[4] = a[4].toDouble();
// array_graph[5] = a[5].toDouble();
// array_graph[6] = a[6].toDouble();
// array_graph[7] = a[7].toDouble();
// int_list[0] = a[4].toInt();
// int_list[1] = a[6].toInt();
//
//
// print(array_graph);
// print(int_list);
// ],
// )