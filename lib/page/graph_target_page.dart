import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../controllers/StopWatch.dart';
import '../locator.dart';
import '../routing/route_names.dart';
import '../services/navigation_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../functions/functions.dart';

class TargetValueView extends StatefulWidget {
  String companyCode;
  TargetValueView({Key? key, required this.companyCode}) : super(key: key);

  @override
  TargetValueViewState createState(){
    return TargetValueViewState();
  }
}

class TargetValueViewState extends State<TargetValueView>{
  var stopwatch = new StopWatch();
  final _formKey = GlobalKey<FormState>();
  String _sow_cross ='';
  String _sevrer ='';
  String _totalbaby ='';
  String _feedbaby ='';
  final TextEditingController sow_cross = TextEditingController();
  final TextEditingController sevrer = TextEditingController();
  final TextEditingController totalbaby = TextEditingController();
  final TextEditingController feedbaby = TextEditingController();

  bool pickerIsExpanded = false;
  int _pickerYear = DateTime.now().year;

  DateTime _selectedMonth = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    1,
  );

  dynamic _pickerOpen = false;
  void switchPicker() {
    setState(() {
      _pickerOpen ^= true;
    });
  }
  @override
  void initState() {
    switchPicker();
    firstshow();
    super.initState();
  }

  firstshow() async{
    var targetdata= await ocrTargetSelectedRow(widget.companyCode,_pickerYear.toString(), _selectedMonth.month.toString().padLeft(2, "0").toString());
    setState(() {
      if(targetdata==null){
        sow_cross.text = "0";
        sevrer.text = "0";
        totalbaby.text = "0";
        feedbaby.text = "0";

      }else {
        sow_cross.text = targetdata[5];
        sevrer.text = targetdata[4];
        totalbaby.text = targetdata[2];
        feedbaby.text = targetdata[3];
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key:_formKey,
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            width: 1000,
            child: Column(
              children: [
                Container(
                  width: 600,
                  child: Column(
                    children: [
                      SizedBox(height: 30,),
                      SizedBox(
                        //width: double.infinity, height: 70,
                        width: MediaQuery.of(context).size.width, height: 70,
                        child:unitTitle(), //'목표값 입력' 띄움
                      ),
                      Container(
                        //width: double.infinity,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black54,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          // color: const Color(0xf6f6f6f6),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: 10,),
                            Expanded(child: inputContents(), flex:10, ), // textform 모음
                            SizedBox(width: 10,),
                            Expanded(child: inputContentsDeco(), flex:10 ), // G farm 사진
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
      ),
    );
  }

  Widget unitTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(' 목표값 입력',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)
      ],
    );
  }

  Widget inputContents(){
    // Size.fromWidth(MediaQuery.of(context).size.width);
    return Container(
      //width: MediaQuery.of(context).size.width,
      //padding: const EdgeInsets.all(0.0),
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.all(Radius.circular(5)),
        // color: const Color(0xf6ee4485),

      ),
      child: Column(
        children: [
          //SizedBox(height: 50,),
          SizedBox(
            child: buildDateFormat(), //날짜
          ),
          SizedBox(
            child: buildCross(), //교배값
          ),
          SizedBox(height: 10,),
          SizedBox(
            child: buildSevrer(), //이유값
          ),
          SizedBox(height: 10,),
          SizedBox(
            child: buildTotalbaby(), //총산자수
          ),
          SizedBox(height: 10,),
          SizedBox(
            child: buildFeedbaby(), //포유값
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            child: buildLoginBtn(), // 취소 또는 저장 버튼
          ),
          SizedBox(height: 30,)
        ],
      ),
    );
  }

  Widget inputContentsDeco(){ //사진 추가
    return Container(
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.all(Radius.circular(5)),
        color: const Color(0xffffffff), // 사진 배경색 - 흰 색
      ),
      // height: MediaQuery.of(context).size.height / 2,
      // width: MediaQuery.of(context).size.width / 2,
      child: Image.asset('assets/register_right.png'),
    );
  }

  Widget buildDateFormat(){
    return Column(
      children: [
        Material(
          color: Theme.of(context).cardColor,
          child: AnimatedSize(
            curve: Curves.easeInOut,
            duration: Duration(milliseconds: 300),
            child: Container(
              height: _pickerOpen ? null : 0.0,

              //뭔가 여기 width를 설정해야 될거같음

              // width: _pickerOpen ? null : null,
              // width: double.infinity,

              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          setState(() {
                            _pickerYear = _pickerYear - 1;
                            _selectedMonth = DateTime(_pickerYear, _selectedMonth.month, 1);
                          });
                          var targetdata= await ocrTargetSelectedRow(widget.companyCode,_pickerYear.toString(), _selectedMonth.month.toString().padLeft(2, "0").toString());
                          setState(() {
                            if (targetdata == null) {
                              sow_cross.text = "0";
                              sevrer.text = "0";
                              totalbaby.text = "0";
                              feedbaby.text = "0";
                            } else {
                              sow_cross.text = targetdata[5];
                              sevrer.text = targetdata[4];
                              totalbaby.text = targetdata[2];
                              feedbaby.text = targetdata[3];
                            }
                          });
                        },
                        icon: Icon(Icons.navigate_before_rounded), // <, 전
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            _pickerYear.toString(),
                            style: TextStyle(fontWeight: FontWeight.bold), // 년도
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          setState(() {
                            _pickerYear = _pickerYear + 1;
                            _selectedMonth = DateTime(_pickerYear, _selectedMonth.month, 1);
                          });
                          var targetdata= await ocrTargetSelectedRow(widget.companyCode,_pickerYear.toString(), _selectedMonth.month.toString().padLeft(2, "0").toString());
                          setState(() {
                            if (targetdata == null) {
                              sow_cross.text = "0";
                              sevrer.text = "0";
                              totalbaby.text = "0";
                              feedbaby.text = "0";
                            } else {
                              sow_cross.text = targetdata[5];
                              sevrer.text = targetdata[4];
                              totalbaby.text = targetdata[2];
                              feedbaby.text = targetdata[3];
                            }
                          });
                        },
                        icon: Icon(Icons.navigate_next_rounded), // >, 후
                      ),
                    ],
                  ),
                  ...generateMonths(), //월 선택
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Text(
          DateFormat('yyyy / MM').format(_selectedMonth),
          style: TextStyle(color: Colors.black),
        ),
        SizedBox(
          height: 10.0,
        ),
        //yM -> 1/2023
        //yMMMM -> January 2023
        //yMMM  -> Jan 2023
      ],
    );
  }

  Widget buildCross(){
    return Container(
      child: Column(
        children: [
          TextFormField(
            controller: sow_cross,
            decoration: const InputDecoration(
              // suffixIcon: Icon(Icons.star),
              labelText: '교배값 입력',
              contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              // border: InputBorder.none,
              // labelText: 'Label Text',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                borderSide: BorderSide( width:2,color: Colors.black54),
              ),
              filled: true,
              fillColor: Colors.white,

            ),
            keyboardType: TextInputType.text,
            autovalidateMode: AutovalidateMode.always,
            onSaved: (value){
              setState(() {
                _sow_cross = value as String;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please insert cross value.';
              } else {
                return null;
              }
            },
          ),
        ],
      ),
    );
  }

  Widget buildSevrer(){
    return Container(
      child: Column(
        children: [
          TextFormField(
            controller: sevrer,
            decoration: const InputDecoration(
              // suffixIcon: Icon(Icons.star),
              labelText: '이유값 입력',
              contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              // border: InputBorder.none,
              // labelText: 'Label Text',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                borderSide: BorderSide( width:2,color: Colors.black54),
              ),
              filled: true,
              fillColor: Colors.white,

            ),
            keyboardType: TextInputType.text,
            autovalidateMode: AutovalidateMode.always,
            onSaved: (value){
              setState(() {
                _sevrer = value as String;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please insert Sevrer value.';
              } else {
                return null;
              }
            },
          ),
        ],
      ),
    );
  }

  Widget buildTotalbaby(){
    return Container(
      child: Column(
        children: [
          TextFormField(
            controller: totalbaby,
            decoration: const InputDecoration(
              // suffixIcon: Icon(Icons.star),
              labelText: '총산수 입력',
              contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              // border: InputBorder.none,
              // labelText: 'Label Text',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                borderSide: BorderSide( width:2,color: Colors.black54),
              ),
              filled: true,
              fillColor: Colors.white,

            ),
            keyboardType: TextInputType.text,
            autovalidateMode: AutovalidateMode.always,
            onSaved: (value){
              setState(() {
                _totalbaby = value as String;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please insert totalbaby value.';
              } else {
                return null;
              }
            },
          ),
        ],
      ),
    );
  }

  Widget buildFeedbaby(){
    return Container(
      child: Column(
        children: [
          TextFormField(
            controller: feedbaby,

            decoration: const InputDecoration(
              labelText: '포유값 입력',
              contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              // border: InputBorder.none,
              // labelText: 'Label Text',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                borderSide: BorderSide( width:2,color: Colors.black54),
              ),
              filled: true,
              fillColor: Colors.white,

            ),
            keyboardType: TextInputType.text,
            autovalidateMode: AutovalidateMode.always,
            onSaved: (value){
              setState(() {
                _feedbaby = value as String;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please insert Feedbaby value.';
              } else {
                return null;
              }
            },
          ),
        ],
      ),
    );
  }

  Widget buildLoginBtn(){
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            flex: 1,
            child: Container(
              width: 150,
              height: 30,
              child: OutlinedButton(
                  onPressed: () async {
                    locator<NavigationService>().navigateTo(HomeRoute);
                  }, child: Text("취소"),
                  style:OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      )
                  )),

            ),
          ),
          SizedBox(width: 5,),
          Flexible(
            flex: 1,
            child: Container(
              width: 150,
              height: 30,
              child: OutlinedButton(child: Text("저장",style: TextStyle(color: Colors.white),),
                style:OutlinedButton.styleFrom(
                  backgroundColor: const Color(0xf64481ee),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                ),
                onPressed: () async{
                  await ocrTargetInsertUpdate(
                    widget.companyCode,
                      _pickerYear.toString(),
                      _selectedMonth.month.toString().padLeft(
                          2, "0").toString(), totalbaby.text.toString(), feedbaby.text.toString(),
                      sevrer.text.toString(),
                      sow_cross.text.toString());
                  locator<NavigationService>().navigateTo(HomeRoute);
                  // }else{
                  //   return;
                  // }
                },
              ),
            ),
          ),
        ]
    );
  }

  resultToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        fontSize: 16.0
    );
  }

  List<Widget> generateRowOfMonths(from, to) {
    //Size.fromWidth(double.infinity);
    //Size.fromWidth(MediaQuery.of(context).size.width);

    List<Widget> months = [];
    for (int i = from; i <= to; i++) {
      DateTime dateTime = DateTime(_pickerYear, i, 1);
      final backgroundColor = dateTime.isAtSameMomentAs(_selectedMonth)
          ? Theme.of(context).accentColor
          : Colors.transparent;
      months.add(
          AnimatedSwitcher(
            duration: kThemeChangeDuration,
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            // child:Flexible(
            // fit: FlexFit.tight,
            child: TextButton(
              key: ValueKey(backgroundColor),
              onPressed: () async {
                setState(() {
                  _selectedMonth = dateTime;
                });
                var targetdata= await ocrTargetSelectedRow(widget.companyCode,_pickerYear.toString(), _selectedMonth.month.toString().padLeft(2, "0").toString());
                setState(() {
                  if(targetdata==null){
                    sow_cross.text = "0";
                    sevrer.text = "0";
                    totalbaby.text = "0";
                    feedbaby.text = "0";

                  }else {
                    sow_cross.text = targetdata[5];
                    sevrer.text = targetdata[4];
                    totalbaby.text = targetdata[2];
                    feedbaby.text = targetdata[3];
                  }
                });
              },
              style: TextButton.styleFrom(
                backgroundColor: backgroundColor,
                shape: CircleBorder(),
              ),
              child: Text(
                DateFormat('M').format(dateTime),
                style: TextStyle(color: Colors.black),

              ),
            ),
          )

        // ),
      );
    }
    return months;
  }


  List<Widget> generateMonths() {
    return [
      FittedBox(
          fit: BoxFit.fitWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: generateRowOfMonths(1, 6),
          )
      ),
      FittedBox(
          fit: BoxFit.fitWidth,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: generateRowOfMonths(7, 12)
          )
      )
    ];

    // return [
    //   Card(
    //     child: Column(
    //       children: [
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //           children: generateRowOfMonths(1, 6),
    //         ),
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //           children: generateRowOfMonths(7, 12),
    //         )
    //       ],
    //     ),
    //   )
    // ];

  }

}