import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:last_ocr/functions/functions.dart';

var mating_week = new List<double>.filled(5,0);
late String mating_goal = "";
var sevrer_week = new List<double>.filled(5,0);
late String sevrer_goal = "";
var totalbaby_week = new List<double>.filled(5,0);
late String totalbaby_goal = "";
var feedbaby_week = new List<double>.filled(5,0);
late String feedbaby_goal = "";


class PregnantOwnerGraphPage extends StatefulWidget {
  static const routeName = '/pregnant-owner-graph-page';

  final List<double> list_sow_cross ;
  final List<double> list_sow_sevrer ;
  final List<double> list_sow_totalbaby ;
  final List<double> list_sow_feedbaby ;
  final List<String> goal ; //년도,월,총산,포유,이유,교배 순
  const PregnantOwnerGraphPage(this.list_sow_cross,this.list_sow_sevrer,this.list_sow_totalbaby,this.list_sow_feedbaby,this.goal);

  @override
  PregnantOwnerGraphPageState createState() => PregnantOwnerGraphPageState();
}
var thisyear = DateTime
    .now()
    .year;
var thismonth = DateTime
    .now()
    .month;
class PregnantOwnerGraphPageState extends State<PregnantOwnerGraphPage> {

  List li = [];

  changeMonth() async {
    li.clear();

    var now = DateTime(2022, thismonth, 1); //선택한 달의 1일을 기준날짜로 잡음

    var firstSunday = DateTime(
        now.year, now.month, now.day - (now.weekday - 0)); //기준날짜가 속한 주의 일요일을 구함

    if (firstSunday.day > now
        .day) { // 찾아낸 일요일이 이전달일경우 +7일을 함 (ex)10.1일이 속한 일요일 9월25일 =(변경)=> 10월 2일)
      firstSunday = firstSunday.add(const Duration(days: 7));
    }

    var sunday = firstSunday;
    List templist = []; // [시작날짜,끝날짜]를 저장하기 위한 임시 리스트
    templist.add(DateFormat('yyyy-MM-dd').format(
        sunday.add(const Duration(days: -6)))); //시작날짜계산법 : 일요일날짜-6
    templist.add(DateFormat('yyyy-MM-dd').format(sunday)); // 끝날짜
    li.add(templist); // [시작날짜,끝날짜] 형태로 리스트에 추가

    while (true) {
      List templist = [];
      var nextsunday = sunday.add(
          const Duration(days: 7)); // 다음주 일요일 계산법 : 일요일+7
      if (nextsunday.day <
          sunday.day) { // 다음주 일요일이 다음달에 속할 경우 리스트에 추가하지 않고 반복문을 종료시킴.
        break;
      }
      templist.add(DateFormat('yyyy-MM-dd').format(
          nextsunday.add(const Duration(days: -6)))); // 시작날짜계산법 : 다음주일요일-6
      templist.add(DateFormat('yyyy-MM-dd').format(nextsunday)); // 끝날짜
      li.add(templist); // [시작날짜, 끝날짜] 형태로 리스트에 추가
      sunday = nextsunday; // 그 다음주를 계산하기 위해 sunday를 nextsunday로 변경
    }
    print(li);
  }

  getdata() async {
    var pregnantdata = await send_date_pregnant(li);
    var targetdata = await ocrTargetSelectedRow(
        thisyear.toString(), thismonth.toString().padLeft(2, "0").toString());
    var maternitydata = await send_date_maternity(li);
    setState(() {
      for (int i = 0; i < li.length; i++) {
        if (pregnantdata[i]['sow_cross'] == null) {
          mating_week[i] = 0;
        } else {
          mating_week[i] = pregnantdata[i]['sow_cross'];
        }
        if (maternitydata[i]['sevrer'] == null) {
          sevrer_week[i] = 0;
        } else {
          sevrer_week[i] = maternitydata[i]['sevrer'];
        }
        if (maternitydata[i]['totalbaby'] == null) {
          totalbaby_week[i] = 0;
        } else {
          totalbaby_week[i] = maternitydata[i]['totalbaby'];
        }
        if (maternitydata[i]['feedbaby'] == null) {
          feedbaby_week[i] = 0;
        } else {
          feedbaby_week[i] = maternitydata[i]['feedbaby'];
        }
      }

      if (targetdata == null) {
        mating_goal = "0";
        sevrer_goal = "0";
        totalbaby_goal = "0";
        feedbaby_goal = "0";
        goal_Controller_cross.text = "0";
        goal_Controller_sevrer.text = "0";
        goal_Controller_total.text = "0";
        goal_Controller_feed.text = "0";
      } else {
        mating_goal = targetdata[5];
        sevrer_goal = targetdata[4];
        totalbaby_goal = targetdata[2];
        feedbaby_goal = targetdata[3];
        goal_Controller_cross.text = targetdata[5];
        goal_Controller_sevrer.text = targetdata[4];
        goal_Controller_total.text = targetdata[2];
        goal_Controller_feed.text = targetdata[3];
      }
    });


  }

  void increase_month() {
    setState(() {
      thismonth++;
      if (thismonth > 12) {
        thismonth = 1;
        thisyear++;
      }
    });
  }

  void decrease_month() {
    setState(() {
      thismonth--;
      if (thismonth < 1) {
        thismonth = 12;
        thisyear--;
      }
    });
  }

  final goal_Controller_cross = TextEditingController();
  final goal_Controller_sevrer = TextEditingController();
  final goal_Controller_total = TextEditingController();
  final goal_Controller_feed = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print("buildddd--------");
    changeMonth();
    if (double.parse(widget.goal[0]) == thisyear && double.parse(widget.goal[1]) == thismonth) {
      print("new page");
      mating_week = widget.list_sow_cross;
      mating_goal = widget.goal[5];
      sevrer_week = widget.list_sow_sevrer;
      sevrer_goal = widget.goal[4];
      totalbaby_week = widget.list_sow_totalbaby;
      totalbaby_goal = widget.goal[2];
      feedbaby_week = widget.list_sow_feedbaby;
      feedbaby_goal = widget.goal[3];
      print(mating_goal);
      print(sevrer_goal);
      print(totalbaby_goal);
      print(feedbaby_goal);
      print(mating_week);
      print(sevrer_week);
      print(totalbaby_week);
      print(feedbaby_week);

      goal_Controller_cross.text = widget.goal[5].toString();
      goal_Controller_sevrer.text = widget.goal[4].toString();
      goal_Controller_total.text = widget.goal[2].toString();
      goal_Controller_feed.text = widget.goal[3].toString();
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
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () async { decrease_month(); changeMonth();getdata();}, icon: Icon(Icons.navigate_before)
                    ),
                    Text('$thisyear'.toString()+"년 "+'$thismonth'.toString()+"월",style: TextStyle(fontSize: 25),),
                    IconButton(
                        onPressed: () { increase_month();changeMonth();getdata();}, icon: Icon(Icons.navigate_next)
                    )
                  ]
              ),
              Column(
                children: [
                  Text("교배", style: TextStyle(fontSize: 20),),
                  AspectRatio(aspectRatio: 3 / 2,
                    child: Padding(
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
                  Text("이유", style: TextStyle(fontSize: 20),),
                  AspectRatio(aspectRatio: 3 / 2,
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
                  Text("총산자수", style: TextStyle(fontSize: 20),),
                  AspectRatio(aspectRatio: 3 / 2,
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
                  Text("포유", style: TextStyle(fontSize: 20),),
                  AspectRatio(aspectRatio: 3 / 2,
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
        floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [

              FloatingActionButton(
                  heroTag: 'dialog',
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.arrow_forward),
                  onPressed: () async {
                    showDialog(context: context,
                        barrierDismissible: true,
                        builder: (context) {
                          // return Expanded(
                          return AlertDialog(
                              scrollable: true,
                              title: Text("목표값을 설정해주세요"),
                              content:
                              Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(children: <Widget>[
                                      Text(thisyear.toString() + "년 " +
                                          thismonth.toString() + "월")
                                    ]),
                                    Row(children: <Widget>[
                                      Text("교배  "),
                                      SizedBox(width: 10,),
                                      SizedBox(width: 50, child: TextField(
                                        decoration: InputDecoration(
                                          hintText: '',),
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.number,
                                        controller: goal_Controller_cross,

                                      ))
                                    ]),
                                    Row(children: <Widget>[
                                      Text("이유  "),
                                      SizedBox(width: 10,),
                                      SizedBox(width: 50, child: TextField(
                                        decoration: InputDecoration(
                                          hintText: '',),
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.number,
                                        controller: goal_Controller_sevrer,
                                      ))
                                    ]),
                                    Row(children: <Widget>[
                                      Text("총산  "),
                                      SizedBox(width: 10,),
                                      SizedBox(width: 50, child: TextField(
                                        decoration: InputDecoration(
                                          hintText: '',),
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.number,
                                        controller: goal_Controller_total,
                                      ))
                                    ]),
                                    Row(children: <Widget>[
                                      Text("포유  "),
                                      SizedBox(width: 10,),
                                      SizedBox(width: 50, child: TextField(
                                        decoration: InputDecoration(
                                          hintText: '',),
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.number,
                                        controller: goal_Controller_feed,
                                      ))
                                    ]),
                                  ]),
                              actions: <Widget>[
                                ButtonBar(
                                    alignment: MainAxisAlignment.end,
                                    buttonPadding: EdgeInsets.all(8.0),
                                    children: [
                                      TextButton(
                                        child: const Text('취소'),
                                        onPressed: () =>
                                            Navigator.pop(context, '취소'),
                                      ),
                                      TextButton(
                                        onPressed: () async{

                                          await ocrTargetInsertUpate(
                                              thisyear.toString(),
                                              thismonth.toString().padLeft(
                                                  2, "0").toString(), goal_Controller_total.text.toString(), goal_Controller_feed.text.toString(),
                                              goal_Controller_sevrer.text.toString(),
                                              goal_Controller_cross.text.toString());
                                          print("textbutton");
                                          print(thisyear);
                                          print(thismonth);
                                          Navigator.of(context).popUntil((route) => route.isFirst);
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => PregnantOwnerGraphPage(mating_week,sevrer_week, totalbaby_week,feedbaby_week,[thisyear.toString(),thismonth.toString(),goal_Controller_total.text.toString(),goal_Controller_feed.text.toString(),goal_Controller_sevrer.text.toString(),goal_Controller_cross.text.toString()])));
                                        },
                                        child: const Text('전송'),
                                      ),
                                    ]
                                )


                              ]
                          );
                          // child: null,;
                          // )
                        }
                    );
                  }
              ),
            ]
        )
    );
  }


//교배복수**********************
  LineChartData mainChart_sow_cross(List li) {
    print("Draww");
    print(li);
    print(mating_week);
    print(mating_goal);
    List<Color> gradientColors_values = [
      const Color(0xff23b6e6),
      const Color(0xff02d39a),
    ];

    List<Color> gradientColorsAvg = [
      const Color(0xfffa0000),
      const Color(0xffffdd00),
    ];

    double max = 40;
    if (double.parse(mating_goal) > 40)
      max = double.parse(mating_goal) + 10;

    if (li.length == 4) {
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
                fontSize: 15),
            getTitles: (value) {
              // print('bottomTitles $value');
              switch (value.toInt()) {
                case 0:
                  return li[0][1]
                      .toString()
                      .split("-")
                      .last + "일";
                case 4:
                  return li[1][1]
                      .toString()
                      .split("-")
                      .last + "일";
                case 8:
                  return li[2][1]
                      .toString()
                      .split("-")
                      .last + "일";
                case 12:
                  return li[3][1]
                      .toString()
                      .split("-")
                      .last + "일";
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
              fontSize: 12,
            ),
          ),
        ),
        // // borderData: FlBorderData(
        // //     show: true,
        // //     border: Border.all(color: const Color(0xff000000), width: 1)),
        minX: 0,
        maxX: 12,
        minY: 0,
        maxY: max,
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(0, mating_week[0]),
              FlSpot(4, mating_week[1]),
              FlSpot(8, mating_week[2]),
              FlSpot(12, mating_week[3]),
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
              FlSpot(0, double.parse(mating_goal)),
              FlSpot(4, double.parse(mating_goal)),
              FlSpot(8, double.parse(mating_goal)),
              FlSpot(12, double.parse(mating_goal)),
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
      );
    }
    else {
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
                fontSize: 15),
            getTitles: (value) {
              // print('bottomTitles $value');
              switch (value.toInt()) {
                case 0:
                  return li[0][1]
                      .toString()
                      .split("-")
                      .last + "일";
                case 3:
                  return li[1][1]
                      .toString()
                      .split("-")
                      .last + "일";
                case 6:
                  return li[2][1]
                      .toString()
                      .split("-")
                      .last + "일";
                case 9:
                  return li[3][1]
                      .toString()
                      .split("-")
                      .last + "일";
                case 12:
                  return li[4][1]
                      .toString()
                      .split("-")
                      .last + "일";
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
              fontSize: 12,
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
              FlSpot(0, double.parse(mating_goal)),
              FlSpot(3, double.parse(mating_goal)),
              FlSpot(6, double.parse(mating_goal)),
              FlSpot(9, double.parse(mating_goal)),
              FlSpot(12, double.parse(mating_goal)),
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
    double max = 300;
    if (double.parse(sevrer_goal) > 300)
      max = double.parse(sevrer_goal) + 10;
    if (li.length == 4)
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
                fontSize: 15),
            getTitles: (value) {
              // print('bottomTitles $value');
              switch (value.toInt()) {
                case 0:
                  return li[0][1]
                      .toString()
                      .split("-")
                      .last + "일";
                case 4:
                  return li[1][1]
                      .toString()
                      .split("-")
                      .last + "일";
                case 8:
                  return li[2][1]
                      .toString()
                      .split("-")
                      .last + "일";
                case 12:
                  return li[3][1]
                      .toString()
                      .split("-")
                      .last + "일";
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
              fontSize: 12,
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
              FlSpot(4, sevrer_week[1].toDouble()),
              FlSpot(8, sevrer_week[2].toDouble()),
              FlSpot(12, sevrer_week[3].toDouble()),
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
              FlSpot(0, double.parse(sevrer_goal)),
              FlSpot(4, double.parse(sevrer_goal)),
              FlSpot(8, double.parse(sevrer_goal)),
              FlSpot(12, double.parse(sevrer_goal)),
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
                fontSize: 15),
            getTitles: (value) {
              // print('bottomTitles $value');
              switch (value.toInt()) {
                case 0:
                  return li[0][1]
                      .toString()
                      .split("-")
                      .last + "일";
                case 3:
                  return li[1][1]
                      .toString()
                      .split("-")
                      .last + "일";
                case 6:
                  return li[2][1]
                      .toString()
                      .split("-")
                      .last + "일";
                case 9:
                  return li[3][1]
                      .toString()
                      .split("-")
                      .last + "일";
                case 12:
                  return li[4][1]
                      .toString()
                      .split("-")
                      .last + "일";
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
              fontSize: 12,
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
              FlSpot(0, double.parse(sevrer_goal)),
              FlSpot(3, double.parse(sevrer_goal)),
              FlSpot(6, double.parse(sevrer_goal)),
              FlSpot(9, double.parse(sevrer_goal)),
              FlSpot(12, double.parse(sevrer_goal)),
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

    double max = 300;
    if (double.parse(totalbaby_goal) > 300)
      max = double.parse(totalbaby_goal) + 10;

    if (li.length == 4) {
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
                fontSize: 15),
            getTitles: (value) {
              // print('bottomTitles $value');
              switch (value.toInt()) {
                case 0:
                  return li[0][1]
                      .toString()
                      .split("-")
                      .last + "일";
                case 4:
                  return li[1][1]
                      .toString()
                      .split("-")
                      .last + "일";
                case 8:
                  return li[2][1]
                      .toString()
                      .split("-")
                      .last + "일";
                case 12:
                  return li[3][1]
                      .toString()
                      .split("-")
                      .last + "일";
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
              fontSize: 12,
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
              FlSpot(4, totalbaby_week[1].toDouble()),
              FlSpot(8, totalbaby_week[2].toDouble()),
              FlSpot(12, totalbaby_week[3].toDouble()),
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
              FlSpot(0, double.parse(totalbaby_goal)),
              FlSpot(4, double.parse(totalbaby_goal)),
              FlSpot(8, double.parse(totalbaby_goal)),
              FlSpot(12, double.parse(totalbaby_goal)),
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
    else {
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
                fontSize: 15),
            getTitles: (value) {
              // print('bottomTitles $value');
              switch (value.toInt()) {
                case 0:
                  return li[0][1]
                      .toString()
                      .split("-")
                      .last + "일";
                case 3:
                  return li[1][1]
                      .toString()
                      .split("-")
                      .last + "일";
                case 6:
                  return li[2][1]
                      .toString()
                      .split("-")
                      .last + "일";
                case 9:
                  return li[3][1]
                      .toString()
                      .split("-")
                      .last + "일";
                case 12:
                  return li[4][1]
                      .toString()
                      .split("-")
                      .last + "일";
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
              fontSize: 12,
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
              FlSpot(0, double.parse(totalbaby_goal)),
              FlSpot(3, double.parse(totalbaby_goal)),
              FlSpot(6, double.parse(totalbaby_goal)),
              FlSpot(9, double.parse(totalbaby_goal)),
              FlSpot(12, double.parse(totalbaby_goal)),
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

    double max = 400;
    if (double.parse(feedbaby_goal) > 400)
      max = double.parse(feedbaby_goal) + 10;

    if (li.length == 4) {
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
                fontSize: 15),
            getTitles: (value) {
              // print('bottomTitles $value');
              switch (value.toInt()) {
                case 0:
                  return li[0][1]
                      .toString()
                      .split("-")
                      .last + "일";
                case 3:
                  return li[1][1]
                      .toString()
                      .split("-")
                      .last + "일";
                case 8:
                  return li[2][1]
                      .toString()
                      .split("-")
                      .last + "일";
                case 12:
                  return li[3][1]
                      .toString()
                      .split("-")
                      .last + "일";
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
              fontSize: 12,
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
              FlSpot(4, feedbaby_week[1].toDouble()),
              FlSpot(8, feedbaby_week[2].toDouble()),
              FlSpot(12, feedbaby_week[3].toDouble()),
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
              FlSpot(0, double.parse(feedbaby_goal)),
              FlSpot(4, double.parse(feedbaby_goal)),
              FlSpot(8, double.parse(feedbaby_goal)),
              FlSpot(12, double.parse(feedbaby_goal)),
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
    else {
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
                fontSize: 15),
            getTitles: (value) {
              // print('bottomTitles $value');
              switch (value.toInt()) {
                case 0:
                  return li[0][1]
                      .toString()
                      .split("-")
                      .last + "일";
                case 3:
                  return li[1][1]
                      .toString()
                      .split("-")
                      .last + "일";
                case 6:
                  return li[2][1]
                      .toString()
                      .split("-")
                      .last + "일";
                case 9:
                  return li[3][1]
                      .toString()
                      .split("-")
                      .last + "일";
                case 12:
                  return li[4][1]
                      .toString()
                      .split("-")
                      .last + "일";
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
              fontSize: 12,
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
              FlSpot(0, double.parse(feedbaby_goal)),
              FlSpot(3, double.parse(feedbaby_goal)),
              FlSpot(6, double.parse(feedbaby_goal)),
              FlSpot(9, double.parse(feedbaby_goal)),
              FlSpot(12, double.parse(feedbaby_goal)),
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
}