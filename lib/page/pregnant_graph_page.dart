import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

late List<double> array_graph = List.filled(8, 0, growable: true);
// late List<double> array_graph = [10,20,30,40,30,0,40];
// var int_list = List<int>.filled(5, 0);

class PregnantGraphPage extends StatefulWidget {
  static const routeName = '/camera-page';

  const PregnantGraphPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  PregnantGraphPageState createState() => PregnantGraphPageState();
}

class PregnantGraphPageState extends State<PregnantGraphPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("임신사 Graph Page")
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton.icon(
                  onPressed: () { },
                  icon: Icon(Icons.refresh), label: Text('새로고침')),
              Text("교배",style:TextStyle(fontSize: 20),),
              Column(
                children: [
                  AspectRatio(aspectRatio: 3/2,
                    child:Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 30, 30),
                      child: LineChart(
                        mainChart_sow_cross(),
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
                      padding: EdgeInsets.fromLTRB(20, 10, 30, 30),
                      child: LineChart(
                        mainChart_sow_sevrer(),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text("총산",style:TextStyle(fontSize: 20),),
                  AspectRatio(aspectRatio: 3/2,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 30, 30),
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
                      padding: EdgeInsets.fromLTRB(20, 10, 30, 30),
                      child: LineChart(
                        mainChart_feed_baby(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}

//교배복수**********************
LineChartData mainChart_sow_cross() {
  List<Color> gradientColors_values = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  List<Color> gradientColors_avg = [
    const Color(0xfffa0000),
    const Color(0xffffdd00),
  ];
  print(array_graph);
  print("main 그래프 페이지 값 ");
  print(array_graph);
  final oneweek_mate = array_graph[0];
  final twoweek_mate = array_graph[1];
  final threeweek_mate = array_graph[2];
  final fourweek_mate = array_graph[3];
  final goal_mate = array_graph[4];
  final minvalue_mate = array_graph[5];
  final maxvalue_mate = array_graph[6];
  // final middlevalue_mate = array_graph[7];

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
          // return '';
        },
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
  // final middlevalue_teen = array_graph[7];

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
        },
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
