import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../entities/PigsRoom.dart';
import '../entities/PigsRoomThisMonth.dart';
import '../locator.dart';
import '../routing/route_names.dart';
import '../services/navigation_service.dart';
import '../views/pages/pigsroom_selected_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' hide Response;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';


class PigsRoomThisMonth extends StatefulWidget {
  String companyCode;
  PigsRoomThisMonth({Key? key, required this.companyCode}) : super(key: key);

  @override
  State<PigsRoomThisMonth> createState() => _PigsRoomThisMonth();
}

class _PigsRoomThisMonth extends State<PigsRoomThisMonth> {
  var pigsroom = <Pigsroom>[].obs;
  var pigsrooms = <PigsroomThisMonth>[].obs;
  int toMonth=0;

  @override
  void initState() {
    super.initState();
    setToday();   //현재 월 을 뽑아온다
    getPigsRoomThisMonth();  //뽑아온 월 데이터를 가져온다
  }
  @override
  void dispose(){
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          body: Obx(() => ListView(
            children: [
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        SizedBox(height: 20,),
                        Text('돈사 재고현황',style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black54),),
                      ],
                    ),
                    SizedBox(height: 10,),
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: _createDataTable()
                    )
                  ],
                ),
              )

            ],
          ),
          ),
        ));
  }

  DataTable _createDataTable() {
    return DataTable(
      border: TableBorder.all(
        width: 1,
        borderRadius: BorderRadius.circular(5),
      ),
      columns: _createColumns(),
      rows: _createRows(),
      headingTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,

      ),
      headingRowColor: MaterialStateProperty.resolveWith(
              (states) => Colors.grey
      ),
    );
  }

  List<DataColumn> _createColumns() {
    return
      [
        DataColumn(label: Expanded(child: Text( '룸번호', textAlign: TextAlign.center,))),
        DataColumn(label: Expanded(child: Text( '입고', textAlign: TextAlign.center,))),
        DataColumn(label: Expanded(child: Text( '출고', textAlign: TextAlign.center,))),
        DataColumn(label: Expanded(child: Text( '사고', textAlign: TextAlign.center,))),
        DataColumn(label: Expanded(child: Text( '현재고', textAlign: TextAlign.center,))),
        DataColumn(label: Expanded(child: Text( 'Option', textAlign: TextAlign.center,))),
      ];
  }

  List<DataRow> _createRows() {
    List<DataRow> list = <DataRow>[];
    for (int i = 0; i < pigsrooms.length; i++) {
      list.add(
        DataRow(cells: [
          DataCell(
              Center(
                child: Row(
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PigsRoomSelectedView(companyCode:widget.companyCode!,
                            roomNo:pigsrooms[i].roomNo.toString()!)));
                      },
                      child: Text("${pigsrooms[i].roomNo.toString()}"),
                      style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(15))
                          )
                      ),
                    ),
                  ],
                ),
              )
          ),
          DataCell(
            Container(
                width: 100,
                child: TextFormField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  initialValue: '${pigsrooms[i].intoThis}',
                  decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(20.0),
                    ),
                  ),
                  onChanged: (text){
                    pigsrooms[i].intoThis = int.parse(text);
                  },
                )
            ),
          ),
          DataCell(
            Container(
                width: 100,
                child: TextFormField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  initialValue: '${pigsrooms[i].outThis}',
                  decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(20.0),
                    ),
                  ),
                  onChanged: (text){
                    pigsrooms[i].outThis = int.parse(text);
                  },
                )
            ),
          ),
          DataCell(
            Container(
                width: 100,
                child: TextFormField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  initialValue: '${pigsrooms[i].accidentThis}',
                  decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(20.0),
                    ),
                  ),
                  onChanged: (text){
                    pigsrooms[i].accidentThis = int.parse(text);
                  },
                )
            ),
          ),
          DataCell(
            Container(
                width: 100,
                child: TextFormField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  initialValue: '${pigsrooms[i].stock}',
                  decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(20.0),
                    ),
                  ),
                  onChanged: (text){
                    pigsrooms[i].stock = int.parse(text);
                  },
                )
            ),
          ),
          DataCell(
              Container(
                child: Row(
                  children: [

                    InkWell(
                      onTap: () {
                        pigsRoomUpdateDialog(context,pigsrooms[i].roomNo!,pigsrooms[i].intoThis!,pigsrooms[i].outThis!,pigsrooms[i].accidentThis!,pigsrooms[i].stock!);
                      },
                      child: Ink.image(
                        image: AssetImage('assets/wrench.png'),
                        // fit: BoxFit.cover,
                        width: 15,
                        height: 15,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        pigsRoomDeleteDialog(context,pigsrooms[i].roomNo!);
                      },
                      child: Ink.image(
                        image: AssetImage('assets/trash-bin.png'),
                        // fit: BoxFit.cover,
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ],
                ),
              )
          ),
        ]),
      );
    }
    return list;
  }

  Future<void> getPigsRoomThisMonth() async{
    final api ='https://www.gfarmx.com/api/getPigsRoomThisMonth';
    final data = {
      "companyCode":widget.companyCode,
      "toMonth":toMonth,
    };

    final dio = Dio();
    Response response = await dio.post(api,data: data);
    if(response.statusCode == 200) {
      List<dynamic> result = response.data;
      pigsrooms.assignAll(result.map((data) => PigsroomThisMonth.fromJson(data)).toList());
      pigsrooms.refresh();
    }
  }

  Future<dynamic> pigsRoomUpdateDialog(BuildContext context,int roomNo,int intoThis,int outThis,int accidentThis,int stock) async{
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('수정'),
        content: Text('변경된 정보를 수정하시겠습니까?'),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () => {
                    Navigator.pop(context, false),
                    pigsRoomUpdate(roomNo,intoThis,outThis,accidentThis,stock)
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  child: Text('수정')),
              SizedBox(width: 10,),
              ElevatedButton(
                  onPressed: () => {
                    Navigator.pop(context, false),
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PigsRoomThisMonth(companyCode: widget.companyCode)))
                  // locator<NavigationService>().navigateTo(PigsRoomThisMonthRoute)
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    foregroundColor: Colors.black54,
                    primary: Colors.white,
                  ),
                  child: Text('취소')
              ),
            ],
          )

        ],
      ),
    );
  }

  void pigsRoomUpdate (int roomNo,int intoThis,int outThis,int accidentThis,int stock) async {
    final api ='https://www.gfarmx.com/api/pigsRoomUpdate';
    final dio = Dio();
    final data = {
      "roomNo":roomNo,
      "intoThis":intoThis,
      "outThis":outThis,
      "accidentThis":accidentThis,
      "stock":stock,
      "stock":stock,
      "toMonth":toMonth,
      "companyCode":widget.companyCode
    };
    Response response = await dio.post(api,data: data);
    if(response.statusCode == 200) {
      resultToast(response.data);
    }
  }

  Future<dynamic> pigsRoomDeleteDialog(BuildContext context,int roomNo) async{
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(roomNo.toString()+' 삭제'),
        content: Text('선택한 Room을 삭제하시겠습니까?'),

        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () => {
                    Navigator.pop(context, false),
                    pigsRoomDelete(roomNo),
                    locator<NavigationService>().navigateTo(HomeRoute)
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  child: Text('삭제')),
              SizedBox(width: 10,),
              ElevatedButton(
                  onPressed: () => {
                    Navigator.pop(context, false),
                    locator<NavigationService>().navigateTo(HomeRoute)
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    foregroundColor: Colors.black54,
                    primary: Colors.white,
                  ),
                  child: Text('취소')
              ),
            ],
          )
        ],
      ),
    );
  }

  void pigsRoomDelete(int roomNo) async {
    final api ='https://www.gfarmx.com/api/pigsRoomDelete';
    final dio = Dio();
    final data = {
      "roomNo":roomNo
    };
    Response response = await dio.post(api,data: data);
    if(response.statusCode == 200) {
      resultToast(response.data);
    }
  }

  void setToday() {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('MM');
    String strToday = formatter.format(now);

    setState(() {
      toMonth = int.parse(strToday);
    });
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
}