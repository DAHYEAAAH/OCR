import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../functions/functions.dart';
import 'package:intl/intl.dart';

var mating_week = new List<double>.filled(5,0);
late String mating_goal = "0";
var sevrer_week = new List<double>.filled(5,0);
late String sevrer_goal = "0";
var totalbaby_week = new List<double>.filled(5,0);
late String totalbaby_goal = "0";
var feedbaby_week = new List<double>.filled(5,0);
late String feedbaby_goal = "0";
var goals = List<String>.filled(6, "0");

class OwnerGraphPage extends StatefulWidget {
  static const routeName = '/owner-graph-page';

  const OwnerGraphPage({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  OwnerGraphPageState createState() => OwnerGraphPageState();
}
var thisyear = DateTime.now().year;
var thismonth = DateTime.now().month;
class OwnerGraphPageState extends State<OwnerGraphPage> {
  @override
  initState(){
    super.initState();
    // TODO;
    preparegraph();
    thisyear = DateTime.now().year;
    thismonth = DateTime.now().month;
  }
  List li = [];
  int count = 0;

  preparegraph() async{
    print("preparegraph");
    var thisyear = DateTime.now().year;   // 년도
    var thismonth = DateTime.now().month; // 월

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
    print('pregnantdata');

    var maternitydata= await send_date_maternity(li);
    print('maternitydata');

    var targetdata= await ocrTargetSelectedRow(thisyear.toString(), thismonth.toString().padLeft(2, "0").toString());

    setState(() {
      for(int i=0; i<li.length; i++){
        if(pregnantdata[i]['sow_cross']==null){
          mating_week[i]=0;
        }else{
          mating_week[i] = pregnantdata[i]['sow_cross'].toDouble();
        }
      }
      print(mating_week);

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
      if(targetdata==null){
        goals[0]=now.year.toString();
        goals[1]=now.month.toString();
        goals[2]='0';
        goals[3]='0';
        goals[4]='0';
        goals[5]='0';
        mating_goal='0';
        sevrer_goal='0';
        totalbaby_goal='0';
        feedbaby_goal='0';
        goal_Controller_cross.text = "0";
        goal_Controller_sevrer.text = "0";
        goal_Controller_total.text = "0";
        goal_Controller_feed.text = "0";

      }else {
        goals[0] = targetdata[0];
        goals[1] = targetdata[1];
        goals[2] = targetdata[2];
        goals[3] = targetdata[3];
        goals[4] = targetdata[4];
        goals[5] = targetdata[5];
        print(goals);
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
    li.clear();
    // return [mating_week,sevrer_week,totalbaby_week,feedbaby_week, goals];
  }



  changeMonth() async {
    count = 1;
    li.clear();

    var now = DateTime(thisyear, thismonth, 1); //선택한 달의 1일을 기준날짜로 잡음

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
      if (nextsunday.day < sunday.day) { // 다음주 일요일이 다음달에 속할 경우 리스트에 추가하지 않고 반복문을 종료시킴.
        break;
      }
      templist.add(DateFormat('yyyy-MM-dd').format(
          nextsunday.add(const Duration(days: -6)))); // 시작날짜계산법 : 다음주일요일-6
      templist.add(DateFormat('yyyy-MM-dd').format(nextsunday)); // 끝날짜
      li.add(templist); // [시작날짜, 끝날짜] 형태로 리스트에 추가
      sunday = nextsunday; // 그 다음주를 계산하기 위해 sunday를 nextsunday로 변경
    }
    print(li);

    var firstday = DateTime(int.parse(li[0][1].toString().split("-")[0]),1,1);

    var firstweek = DateTime(firstday.year, firstday.month,firstday.day - (firstday.weekday - 0) ); //기준날짜가 속한 주의 일요일을 구함
    if(firstweek.day>7){ // 찾아낸 일요일이 이전달년일경우 +7일을 함
      firstweek = firstweek.add(const Duration(days: 7));

    }
    while(true){
      if(firstweek.month==int.parse(li[0][1].toString().split("-")[1])&& firstweek.day==int.parse(li[0][1].toString().split("-")[2])){
        break;
      }
      firstweek = firstweek.add(const Duration(days: 7));
      count++;
    }
    print(count);
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
          mating_week[i] = pregnantdata[i]['sow_cross'].toDouble();
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
    return Scaffold(
        appBar: AppBar(
            title: Text("그래프")
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
                        mainChart_sow_cross(li,count),
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
                        mainChart_sow_sevrer(li,count),
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
                        mainChart_total_baby(li,count),
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
                        mainChart_feed_baby(li,count),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20,),
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
                        barrierDismissible: false,
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
                                        onPressed: () {
                                            goal_Controller_cross.text = goals[5].toString();
                                            goal_Controller_sevrer.text = goals[4].toString();
                                            goal_Controller_total.text = goals[2].toString();
                                            goal_Controller_feed.text = goals[3].toString();

                                            Navigator.pop(context, '취소');
                                        }
                                      ),
                                      TextButton(
                                        onPressed: () async{
                                          Navigator.pop(context,"pop");
                                          await ocrTargetInsertUpdate(
                                              thisyear.toString(),
                                              thismonth.toString().padLeft(
                                                  2, "0").toString(), goal_Controller_total.text.toString(), goal_Controller_feed.text.toString(),
                                              goal_Controller_sevrer.text.toString(),
                                              goal_Controller_cross.text.toString());
                                          print("textbutton");
                                          print(thisyear);
                                          print(thismonth);

                                          setState((){
                                            mating_goal = goal_Controller_cross.text.toString();
                                            sevrer_goal = goal_Controller_sevrer.text.toString();
                                            totalbaby_goal = goal_Controller_total.text.toString();
                                            feedbaby_goal = goal_Controller_feed.text.toString();
                                          });

                                          // Navigator.of(context).popUntil((route) => route.isFirst);
                                          // Navigator.push(context, MaterialPageRoute(builder: (context) => OwnerGraphPage()));
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
  LineChartData mainChart_sow_cross(List li, int weeknum) {
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
    if(mating_week[0]>max)
      max = mating_week[0];
    if(mating_week[1]>max)
      max = mating_week[1];
    if(mating_week[2]>max)
      max = mating_week[2];
    if(mating_week[3]>max)
      max = mating_week[3];
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
                  return weeknum.toString()+"주차\n~"+li[0][1].toString().split("-").last+"일";
                case 4:
                  return (weeknum+1).toString()+"주차\n~"+li[1][1].toString().split("-").last+"일";
                case 8:
                  return (weeknum+2).toString()+"주차\n~"+li[2][1].toString().split("-").last+"일";
                case 12:
                  return (weeknum+3).toString()+"주차\n~"+li[3][1].toString().split("-").last+"일";
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
      if(mating_week[4]>max)
        max = mating_week[4];
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
                  return weeknum.toString()+"주차\n~"+li[0][1].toString().split("-").last+"일";
                case 3:
                  return (weeknum+1).toString()+"주차\n~"+li[1][1].toString().split("-").last+"일";
                case 6:
                  return (weeknum+2).toString()+"주차\n~"+li[2][1].toString().split("-").last+"일";
                case 9:
                  return (weeknum+3).toString()+"주차\n~"+li[3][1].toString().split("-").last+"일";
                case 12:
                  return (weeknum+4).toString()+"주차\n~"+li[4][1].toString().split("-").last+"일";
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
  LineChartData mainChart_sow_sevrer(List li, int weeknum) {
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
    if(sevrer_week[0]>max)
      max = sevrer_week[0];
    if(sevrer_week[1]>max)
      max = sevrer_week[1];
    if(sevrer_week[2]>max)
      max = sevrer_week[2];
    if(sevrer_week[3]>max)
      max = sevrer_week[3];
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
                  return (weeknum+0).toString()+"주차\n~"+li[0][1].toString().split("-").last+"일";
                case 4:
                  return (weeknum+1).toString()+"주차\n~"+li[1][1].toString().split("-").last+"일";
                case 8:
                  return (weeknum+2).toString()+"주차\n~"+li[2][1].toString().split("-").last+"일";
                case 12:
                  return (weeknum+3).toString()+"주차\n~"+li[3][1].toString().split("-").last+"일";
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
    else {
      if(sevrer_week[4]>max)
        max = sevrer_week[4];
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
                  return (weeknum + 0).toString() + "주차\n~" + li[0][1]
                      .toString()
                      .split("-")
                      .last + "일";
                case 3:
                  return (weeknum + 1).toString() + "주차\n~" + li[1][1]
                      .toString()
                      .split("-")
                      .last + "일";
                case 6:
                  return (weeknum + 2).toString() + "주차\n~" + li[2][1]
                      .toString()
                      .split("-")
                      .last + "일";
                case 9:
                  return (weeknum + 3).toString() + "주차\n~" + li[3][1]
                      .toString()
                      .split("-")
                      .last + "일";
                case 12:
                  return (weeknum + 4).toString() + "주차\n~" + li[4][1]
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
  }

//총산자수******************
  LineChartData mainChart_total_baby(List li, int weeknum) {
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
    if(totalbaby_week[0]>max)
      max = totalbaby_week[0];
    if(totalbaby_week[1]>max)
      max = totalbaby_week[1];
    if(totalbaby_week[2]>max)
      max = totalbaby_week[2];
    if(totalbaby_week[3]>max)
      max = totalbaby_week[3];
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
                  return (weeknum+0).toString()+"주차\n~"+li[0][1].toString().split("-").last+"일";
                case 4:
                  return (weeknum+1).toString()+"주차\n~"+li[1][1].toString().split("-").last+"일";
                case 8:
                  return (weeknum+2).toString()+"주차\n~"+li[2][1].toString().split("-").last+"일";
                case 12:
                  return (weeknum+3).toString()+"주차\n~"+li[3][1].toString().split("-").last+"일";

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
      if(totalbaby_week[4]>max)
        max = totalbaby_week[4];
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
                  return (weeknum+0).toString()+"주차\n~"+li[0][1].toString().split("-").last+"일";
                case 3:
                  return (weeknum+0).toString()+"주차\n~"+li[1][1].toString().split("-").last+"일";
                case 6:
                  return (weeknum+0).toString()+"주차\n~"+li[2][1].toString().split("-").last+"일";
                case 9:
                  return (weeknum+0).toString()+"주차\n~"+li[3][1].toString().split("-").last+"일";
                case 12:
                  return (weeknum+0).toString()+"주차\n~"+li[4][1].toString().split("-").last+"일";

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
  LineChartData mainChart_feed_baby(List li, int weeknum) {
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
    if(feedbaby_week[0]>max)
      max = feedbaby_week[0];
    if(feedbaby_week[1]>max)
      max = feedbaby_week[1];
    if(feedbaby_week[2]>max)
      max = feedbaby_week[2];
    if(feedbaby_week[3]>max)
      max = feedbaby_week[3];

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
                  return (weeknum+0).toString()+"주차\n~"+li[0][1].toString().split("-").last+"일";
                case 4:
                  return (weeknum+1).toString()+"주차\n~"+li[1][1].toString().split("-").last+"일";
                case 8:
                  return (weeknum+2).toString()+"주차\n~"+li[2][1].toString().split("-").last+"일";
                case 12:
                  return (weeknum+3).toString()+"주차\n~"+li[3][1].toString().split("-").last+"일";

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
      if(feedbaby_week[4]>max)
        max = feedbaby_week[4];
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
                  return (weeknum+0).toString()+"주차\n~"+li[0][1].toString().split("-").last+"일";
                case 3:
                  return (weeknum+1).toString()+"주차\n~"+li[1][1].toString().split("-").last+"일";
                case 6:
                  return (weeknum+2).toString()+"주차\n~"+li[2][1].toString().split("-").last+"일";
                case 9:
                  return (weeknum+3).toString()+"주차\n~"+li[3][1].toString().split("-").last+"일";
                case 12:
                  return (weeknum+4).toString()+"주차\n~"+li[4][1].toString().split("-").last+"일";

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