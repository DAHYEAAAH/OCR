import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../functions/functions.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

var mating_week = new List<double>.filled(5,0);
late String mating_goal = "0";
var sevrer_week = new List<double>.filled(5,0);
late String sevrer_goal = "0";
var totalbaby_week = new List<double>.filled(5,0);
late String totalbaby_goal = "0";
var feedbaby_week = new List<double>.filled(5,0);
late String feedbaby_goal = "0";
var goals = List<String>.filled(6, "0");

class GraphPage extends StatefulWidget {
  static const routeName = '/graph-page';
  String companyCode;
  GraphPage({Key? key, required this.companyCode,this.title}) : super(key: key);
  final String? title;

  @override
  GraphPageState createState() => GraphPageState();
}
var thisyear = DateTime.now().year;
var thismonth = DateTime.now().month;


class GraphPageState extends State<GraphPage> {
  late List<_ChartData> mating_data_1;
  late List<_ChartData> mating_data_2;
  late TooltipBehavior _tooltip1;
  late TooltipBehavior _tooltip2;
  late TooltipBehavior _tooltip3;
  late TooltipBehavior _tooltip4;

  @override
  initState(){
    super.initState();
    // TODO;
    preparegraph();
    thisyear = DateTime.now().year;
    thismonth = DateTime.now().month;

    _tooltip1 = TooltipBehavior(enable: true);
    _tooltip2 = TooltipBehavior(enable: true);
    _tooltip3 = TooltipBehavior(enable: true);
    _tooltip4 = TooltipBehavior(enable: true);

    //super.initState();
  }

  List li = [];
  int count = 0;


  preparegraph() async{
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
    var pregnantdata= await send_date_pregnant(widget.companyCode,li);

    var maternitydata= await send_date_maternity(widget.companyCode,li);

    var targetdata= await ocrTargetSelectedRow(widget.companyCode,thisyear.toString(), thismonth.toString().padLeft(2, "0").toString());

    setState(() {
      for(int i=0; i<li.length; i++){
        if(pregnantdata[i]['sow_cross']==null){
          mating_week[i]=0;
        }else{
          mating_week[i] = pregnantdata[i]['sow_cross'].toDouble();
        }
      }
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
  }

  getdata() async {
    var pregnantdata = await send_date_pregnant(widget.companyCode,li);
    var targetdata = await ocrTargetSelectedRow(widget.companyCode,
        thisyear.toString(), thismonth.toString().padLeft(2, "0").toString());
    var maternitydata = await send_date_maternity(widget.companyCode,li);
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

  void get_weeknum(){

  }

  final goal_Controller_cross = TextEditingController();
  final goal_Controller_sevrer = TextEditingController();
  final goal_Controller_total = TextEditingController();
  final goal_Controller_feed = TextEditingController();

  @override
  Widget build(BuildContext context) {

    // print(mating_week[0].toDouble().runtimeType);
    // print(mating_week[0].toDouble());

    changeMonth();


    return Scaffold(
      appBar: AppBar(
          title: Text('$thisyear'.toString()+"년 "+'$thismonth'.toString()+"월 목표 달성(통계)")
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(10, 20, 10, 80),
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () async { decrease_month(); changeMonth();getdata();},
                      icon: Icon(Icons.navigate_before)
                  ),
                  IconButton(
                      onPressed: () { increase_month();changeMonth();getdata();},
                      icon: Icon(Icons.navigate_next)
                  )
                ]
            ),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

                Expanded(
                  //flex: 3,
                  child: Column(
                    children: [
                      Container(
                        width: 350.0,
                        child: mainChart_sow_cross(li, count) ,
                      )
                    ],
                  ),
                ),

                Expanded(
                  //flex: 3,
                  child: Column(
                    children: [
                      Container(
                        width: 350.0,
                        child:  mainChart_feed_baby(li, count) ,)
                    ],
                  ),
                ),

              ],
            ),

            Column(
              children: [
                SizedBox(
                  height: 30.0,
                ),
              ],
            ),


            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                //Size.fromWidth(MediaQuery.of(context).size.width),
                Expanded(

                  child: Column(
                    children: [
                      Container(
                        width: 350.0,
                        child:  mainChart_sow_sevrer(li, count) ,
                      )
                    ],
                  ),
                ),
                Expanded(

                  child: Column(
                    children: [
                      Container(
                        width: 350.0,
                        child:  mainChart_total_baby(li, count) ,
                      )
                    ],
                  ),
                ),
              ],

            ),

            //   SizedBox(height: 50,),
          ],
        ),
      ),
    );
  }



//교배복수**********************
  SfCartesianChart mainChart_sow_cross(List li, int weeknum) {

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

      final List<_ChartData> mating_data_1 = <_ChartData>[
        _ChartData(weeknum.toString()+"주차\n~"+li[0][1].toString().split("-").last+"일", mating_week[0].toDouble(), double.parse(mating_goal)), //이름, 막대그래프, 선그래프값
        _ChartData((weeknum+1).toString()+"주차\n~"+li[1][1].toString().split("-").last+"일", mating_week[1].toDouble(), double.parse(mating_goal)),
        _ChartData((weeknum+2).toString()+"주차\n~"+li[2][1].toString().split("-").last+"일", mating_week[2].toDouble(), double.parse(mating_goal)),
        _ChartData((weeknum+3).toString()+"주차\n~"+li[3][1].toString().split("-").last+"일", mating_week[3].toDouble(), double.parse(mating_goal)),
      ];

      return SfCartesianChart(
          title: ChartTitle(text: '교배복수'),
          primaryXAxis: CategoryAxis(
              labelStyle: TextStyle(
                  fontSize: 10
              )
          ),
          primaryYAxis: NumericAxis(minimum: 0, maximum: max, interval: 5), //그래프 범위
          tooltipBehavior: _tooltip1,
          series: <ChartSeries<_ChartData, String>>[
            ColumnSeries<_ChartData, String>(
                dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  showZeroValue: false,
                ),
                dataSource: mating_data_1,
                xValueMapper: (_ChartData mating_data_1, _) => mating_data_1.x,
                yValueMapper: (_ChartData mating_data_1, _) => mating_data_1.y,
                name: '교배',
                color: Color(0xff23b6e6)), //막대그래프 색
            LineSeries<_ChartData, String>(
                dataSource: mating_data_1,
                xValueMapper: (_ChartData mating_data_1, _) => mating_data_1.x,
                yValueMapper: (_ChartData mating_data_1, _) => mating_data_1.y1,
                name: '목표값',
                color: Color(0xfffa0000)) //선그래프 색
          ]
      );
    }

    else {
      final List<_ChartData> mating_data_2 = <_ChartData>[
        _ChartData(weeknum.toString()+"주차\n~"+li[0][1].toString().split("-").last+"일", mating_week[0].toDouble(), double.parse(mating_goal)), //이름, 막대그래프, 선그래프값
        _ChartData((weeknum+1).toString()+"주차\n~"+li[1][1].toString().split("-").last+"일", mating_week[1].toDouble(), double.parse(mating_goal)),
        _ChartData((weeknum+2).toString()+"주차\n~"+li[2][1].toString().split("-").last+"일", mating_week[2].toDouble(), double.parse(mating_goal)),
        _ChartData((weeknum+3).toString()+"주차\n~"+li[3][1].toString().split("-").last+"일", mating_week[3].toDouble(), double.parse(mating_goal)),
        _ChartData((weeknum+4).toString()+"주차\n~"+li[4][1].toString().split("-").last+"일", mating_week[4].toDouble(), double.parse(mating_goal))
      ];

      if(mating_week[4]>max)
        max = mating_week[4];
      return SfCartesianChart(
          title: ChartTitle(text: '교배복수'),
          primaryXAxis: CategoryAxis(
              labelStyle: TextStyle(
                fontSize: 8,
              )
          ),
          primaryYAxis: NumericAxis(minimum: 0, maximum: max, interval: 5), //그래프 범위
          tooltipBehavior: _tooltip1,
          series: <ChartSeries<_ChartData, String>>[
            ColumnSeries<_ChartData, String>(
                dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  showZeroValue: false,
                ),
                dataSource: mating_data_2,
                xValueMapper: (_ChartData mating_data_2, _) => mating_data_2.x,
                yValueMapper: (_ChartData mating_data_2, _) => mating_data_2.y,
                name: '교배',
                color: Color(0xff23b6e6)), //막대그래프 색
            LineSeries<_ChartData, String>(
                dataSource: mating_data_2,
                xValueMapper: (_ChartData mating_data_2, _) => mating_data_2.x,
                yValueMapper: (_ChartData mating_data_2, _) => mating_data_2.y1,
                name: '목표값',
                color: Color(0xfffa0000)) //선그래프 색
          ]
      );
    }
  }

  //이유두수******************
  SfCartesianChart mainChart_sow_sevrer(List li, int weeknum) {

    double max = 150;
    if (double.parse(sevrer_goal) > 150)
      max = double.parse(sevrer_goal) + 10;
    if(sevrer_week[0]>max)
      max = sevrer_week[0];
    if(sevrer_week[1]>max)
      max = sevrer_week[1];
    if(sevrer_week[2]>max)
      max = sevrer_week[2];
    if(sevrer_week[3]>max)
      max = sevrer_week[3];

    if (li.length == 4) {

      final List<_ChartData> sevrer_data_1 = <_ChartData>[
        _ChartData(weeknum.toString()+"주차\n~"+li[0][1].toString().split("-").last+"일", sevrer_week[0].toDouble(), double.parse(sevrer_goal)), //이름, 막대그래프, 선그래프값
        _ChartData((weeknum+1).toString()+"주차\n~"+li[1][1].toString().split("-").last+"일", sevrer_week[1].toDouble(), double.parse(sevrer_goal)),
        _ChartData((weeknum+2).toString()+"주차\n~"+li[2][1].toString().split("-").last+"일", sevrer_week[2].toDouble(), double.parse(sevrer_goal)),
        _ChartData((weeknum+3).toString()+"주차\n~"+li[3][1].toString().split("-").last+"일", sevrer_week[3].toDouble(), double.parse(sevrer_goal)),
      ];

      return SfCartesianChart(
          title: ChartTitle(text: '이유두수'),
          primaryXAxis: CategoryAxis(
              labelStyle: TextStyle(
                  fontSize: 10
              )
          ),
          primaryYAxis: NumericAxis(minimum: 0, maximum: max, interval: 15), //그래프 범위
          tooltipBehavior: _tooltip2,
          series: <ChartSeries<_ChartData, String>>[
            ColumnSeries<_ChartData, String>(
                dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  showZeroValue: false,
                ),
                dataSource: sevrer_data_1,
                xValueMapper: (_ChartData sevrer_data_1, _) => sevrer_data_1.x,
                yValueMapper: (_ChartData sevrer_data_1, _) => sevrer_data_1.y,
                name: '이유',
                color: Color(0xff23b6e6)), //막대그래프 색
            LineSeries<_ChartData, String>(
                dataSource: sevrer_data_1,
                xValueMapper: (_ChartData sevrer_data_1, _) => sevrer_data_1.x,
                yValueMapper: (_ChartData sevrer_data_1, _) => sevrer_data_1.y1,
                name: '목표값',
                color: Color(0xfffa0000)) //선그래프 색
          ]
      );
    }

    else {
      final List<_ChartData> sevrer_data_2 = <_ChartData>[
        _ChartData(weeknum.toString()+"주차\n~"+li[0][1].toString().split("-").last+"일", sevrer_week[0].toDouble(), double.parse(sevrer_goal)), //이름, 막대그래프, 선그래프값
        _ChartData((weeknum+1).toString()+"주차\n~"+li[1][1].toString().split("-").last+"일", sevrer_week[1].toDouble(), double.parse(sevrer_goal)),
        _ChartData((weeknum+2).toString()+"주차\n~"+li[2][1].toString().split("-").last+"일", sevrer_week[2].toDouble(), double.parse(sevrer_goal)),
        _ChartData((weeknum+3).toString()+"주차\n~"+li[3][1].toString().split("-").last+"일", sevrer_week[3].toDouble(), double.parse(sevrer_goal)),
        _ChartData((weeknum+4).toString()+"주차\n~"+li[4][1].toString().split("-").last+"일", sevrer_week[4].toDouble(), double.parse(sevrer_goal))
      ];

      if(sevrer_week[4] > max)
        max = sevrer_week[4];
      return SfCartesianChart(
          title: ChartTitle(text: '이유두수'),
          primaryXAxis: CategoryAxis(
              labelStyle: TextStyle(
                fontSize: 8,
              )
          ),
          primaryYAxis: NumericAxis(minimum: 0, maximum: max, interval: 15), //그래프 범위
          tooltipBehavior: _tooltip2,
          series: <ChartSeries<_ChartData, String>>[
            ColumnSeries<_ChartData, String>(
                dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  showZeroValue: false,
                ),
                dataSource: sevrer_data_2,
                xValueMapper: (_ChartData sevrer_data_2, _) => sevrer_data_2.x,
                yValueMapper: (_ChartData sevrer_data_2, _) => sevrer_data_2.y,
                name: '이유',
                color: Color(0xff23b6e6)), //막대그래프 색
            LineSeries<_ChartData, String>(
                dataSource: sevrer_data_2,
                xValueMapper: (_ChartData sevrer_data_2, _) => sevrer_data_2.x,
                yValueMapper: (_ChartData sevrer_data_2, _) => sevrer_data_2.y1,
                name: '목표값',
                color: Color(0xfffa0000)) //선그래프 색
          ]
      );
    }
  }


  //총산자수******************
  SfCartesianChart mainChart_total_baby(List li, int weeknum) {

    double max = 150;
    if (double.parse(totalbaby_goal) > 150)
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

      final List<_ChartData> totalbaby_data_1 = <_ChartData>[
        _ChartData(weeknum.toString()+"주차\n~"+li[0][1].toString().split("-").last+"일", totalbaby_week[0].toDouble(), double.parse(totalbaby_goal)), //이름, 막대그래프, 선그래프값
        _ChartData((weeknum+1).toString()+"주차\n~"+li[1][1].toString().split("-").last+"일", totalbaby_week[1].toDouble(), double.parse(totalbaby_goal)),
        _ChartData((weeknum+2).toString()+"주차\n~"+li[2][1].toString().split("-").last+"일", totalbaby_week[2].toDouble(), double.parse(totalbaby_goal)),
        _ChartData((weeknum+3).toString()+"주차\n~"+li[3][1].toString().split("-").last+"일", totalbaby_week[3].toDouble(), double.parse(totalbaby_goal)),
      ];

      return SfCartesianChart(
          title: ChartTitle(text: '총산자수'),
          primaryXAxis: CategoryAxis(
              labelStyle: TextStyle(
                fontSize: 10,
              )
          ),
          primaryYAxis: NumericAxis(minimum: 0, maximum: max, interval: 15), //그래프 범위
          tooltipBehavior: _tooltip3,
          series: <ChartSeries<_ChartData, String>>[
            ColumnSeries<_ChartData, String>(
                dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  showZeroValue: false,
                ),
                dataSource: totalbaby_data_1,
                xValueMapper: (_ChartData totalbaby_data_1, _) => totalbaby_data_1.x,
                yValueMapper: (_ChartData totalbaby_data_1, _) => totalbaby_data_1.y,
                name: '총산자수',
                color: Color(0xff23b6e6)), //막대그래프 색
            LineSeries<_ChartData, String>(
                dataSource: totalbaby_data_1,
                xValueMapper: (_ChartData totalbaby_data_1, _) => totalbaby_data_1.x,
                yValueMapper: (_ChartData totalbaby_data_1, _) => totalbaby_data_1.y1,
                name: '목표값',
                color: Color(0xfffa0000)) //선그래프 색
          ]
      );
    }

    else {
      final List<_ChartData> totalbaby_data_2 = <_ChartData>[
        _ChartData(weeknum.toString()+"주차\n~"+li[0][1].toString().split("-").last+"일", totalbaby_week[0].toDouble(), double.parse(totalbaby_goal)), //이름, 막대그래프, 선그래프값
        _ChartData((weeknum+1).toString()+"주차\n~"+li[1][1].toString().split("-").last+"일", totalbaby_week[1].toDouble(), double.parse(totalbaby_goal)),
        _ChartData((weeknum+2).toString()+"주차\n~"+li[2][1].toString().split("-").last+"일", totalbaby_week[2].toDouble(), double.parse(totalbaby_goal)),
        _ChartData((weeknum+3).toString()+"주차\n~"+li[3][1].toString().split("-").last+"일", totalbaby_week[3].toDouble(), double.parse(totalbaby_goal)),
        _ChartData((weeknum+4).toString()+"주차\n~"+li[4][1].toString().split("-").last+"일", totalbaby_week[4].toDouble(), double.parse(totalbaby_goal))
      ];

      if(totalbaby_week[4] > max)
        max = totalbaby_week[4];
      return SfCartesianChart(
          title: ChartTitle(text: '총산자수'),
          primaryXAxis: CategoryAxis(
              labelStyle: TextStyle(
                fontSize: 8,
              )
          ),
          primaryYAxis: NumericAxis(minimum: 0, maximum: max, interval: 15), //그래프 범위
          tooltipBehavior: _tooltip3,
          series: <ChartSeries<_ChartData, String>>[
            ColumnSeries<_ChartData, String>(
                dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  showZeroValue: false,
                ),
                dataSource: totalbaby_data_2,
                xValueMapper: (_ChartData totalbaby_data_2, _) => totalbaby_data_2.x,
                yValueMapper: (_ChartData totalbaby_data_2, _) => totalbaby_data_2.y,
                name: '총산자수',
                color: Color(0xff23b6e6)), //막대그래프 색
            LineSeries<_ChartData, String>(
                dataSource: totalbaby_data_2,
                xValueMapper: (_ChartData totalbaby_data_2, _) => totalbaby_data_2.x,
                yValueMapper: (_ChartData totalbaby_data_2, _) => totalbaby_data_2.y1,
                name: '목표값',
                color: Color(0xfffa0000)) //선그래프 색
          ]
      );
    }
  }


  //포유개시******************
  SfCartesianChart mainChart_feed_baby(List li, int weeknum) {

    double max = 150;

    if (double.parse(feedbaby_goal) > 150)
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

      final List<_ChartData> feedbaby_data_1 = <_ChartData>[
        _ChartData(weeknum.toString()+"주차\n~"+li[0][1].toString().split("-").last+"일", feedbaby_week[0].toDouble(), double.parse(feedbaby_goal)), //이름, 막대그래프, 선그래프값
        _ChartData((weeknum+1).toString()+"주차\n~"+li[1][1].toString().split("-").last+"일", feedbaby_week[1].toDouble(), double.parse(feedbaby_goal)),
        _ChartData((weeknum+2).toString()+"주차\n~"+li[2][1].toString().split("-").last+"일", feedbaby_week[2].toDouble(), double.parse(feedbaby_goal)),
        _ChartData((weeknum+3).toString()+"주차\n~"+li[3][1].toString().split("-").last+"일", feedbaby_week[3].toDouble(), double.parse(feedbaby_goal)),
      ];

      return SfCartesianChart(
          title: ChartTitle(text: '포유개시'),
          primaryXAxis: CategoryAxis(
              labelStyle: TextStyle(
                fontSize: 10,
              )
          ),
          primaryYAxis: NumericAxis(minimum: 0, maximum: max, interval: 15), //그래프 범위
          tooltipBehavior: _tooltip4,
          series: <ChartSeries<_ChartData, String>>[
            ColumnSeries<_ChartData, String>(
                dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  showZeroValue: false,
                ),
                dataSource: feedbaby_data_1,
                xValueMapper: (_ChartData feedbaby_data_1, _) => feedbaby_data_1.x,
                yValueMapper: (_ChartData feedbaby_data_1, _) => feedbaby_data_1.y,
                name: '포유',
                color: Color(0xff23b6e6)), //막대그래프 색
            LineSeries<_ChartData, String>(
                dataSource: feedbaby_data_1,
                xValueMapper: (_ChartData feedbaby_data_1, _) => feedbaby_data_1.x,
                yValueMapper: (_ChartData feedbaby_data_1, _) => feedbaby_data_1.y1,
                name: '목표값',
                color: Color(0xfffa0000)) //선그래프 색
          ]
      );
    }

    else {
      final List<_ChartData> feedbaby_data_2 = <_ChartData>[
        _ChartData(weeknum.toString()+"주차\n~"+li[0][1].toString().split("-").last+"일", feedbaby_week[0].toDouble(), double.parse(feedbaby_goal)), //이름, 막대그래프, 선그래프값
        _ChartData((weeknum+1).toString()+"주차\n~"+li[1][1].toString().split("-").last+"일", feedbaby_week[1].toDouble(), double.parse(feedbaby_goal)),
        _ChartData((weeknum+2).toString()+"주차\n~"+li[2][1].toString().split("-").last+"일", feedbaby_week[2].toDouble(), double.parse(feedbaby_goal)),
        _ChartData((weeknum+3).toString()+"주차\n~"+li[3][1].toString().split("-").last+"일", feedbaby_week[3].toDouble(), double.parse(feedbaby_goal)),
        _ChartData((weeknum+4).toString()+"주차\n~"+li[4][1].toString().split("-").last+"일", feedbaby_week[4].toDouble(), double.parse(feedbaby_goal))
      ];

      if(feedbaby_week[4] > max)
        max = feedbaby_week[4];
      return SfCartesianChart(
          title: ChartTitle(text: '포유개시'),
          primaryXAxis: CategoryAxis(
              labelStyle: TextStyle(
                fontSize: 8,
              )
          ),
          primaryYAxis: NumericAxis(minimum: 0, maximum: max, interval: 15), //그래프 범위
          tooltipBehavior: _tooltip4,
          series: <ChartSeries<_ChartData, String>>[
            ColumnSeries<_ChartData, String>(
                dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  showZeroValue: false,
                ),
                dataSource: feedbaby_data_2,
                xValueMapper: (_ChartData feedbaby_data_2, _) => feedbaby_data_2.x,
                yValueMapper: (_ChartData feedbaby_data_2, _) => feedbaby_data_2.y,
                name: '포유',
                color: Color(0xff23b6e6)), //막대그래프 색
            LineSeries<_ChartData, String>(
                dataSource: feedbaby_data_2,
                xValueMapper: (_ChartData feedbaby_data_2, _) => feedbaby_data_2.x,
                yValueMapper: (_ChartData feedbaby_data_2, _) => feedbaby_data_2.y1,
                name: '목표값',
                color: Color(0xfffa0000)) //선그래프 색
          ]
      );
    }
  }
}

class _ChartData {
  _ChartData(this.x, this.y, this.y1);
  final String x;
  final double y;
  final double y1;
}