import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../functions/functions.dart';
import '../functions/functions.dart';
import 'pregnant_list_page.dart';

// 서버에서 받을 값 변수 선언
late int ocr_seq;
late String sow_no;
late String sow_birth;
late String sow_buy;
late String sow_estrus;
late String sow_cross;
late String boar_fir;
late String boar_sec;
late String checkdate;
late String expectdate;
late String vaccine1;
late String vaccine2;
late String vaccine3;
late String vaccine4;
late String memo;
late String filename;


class PregnantPage extends StatefulWidget{
  static const routeName = '/OcrPregnantPage';

  // 서버에서 넘어오는 값을 저장할 listfromserver_pre를 list로 선언
  // final List listfromserver_pre;
  // PregnantPage호출 시 리스트 입력 받음
  String imagePath;
  String companyCode;
  PregnantPage(this.imagePath, this.companyCode);

  // final String? title;

  @override
  PregnantPageState createState() => PregnantPageState();
}

class PregnantPageState extends State<PregnantPage>{

  // 서버에서 받은 값 저장하는 변수
  late String sowID1;
  late String sowID2;

  late String birth_year;
  late String birth_month;
  late String birth_day;

  late String adoption_year;
  late String adoption_month;
  late String adoption_day;

  late String hormone_year;
  late String hormone_month;
  late String hormone_day;

  late String mate_month;
  late String mate_day;

  late String boar1ID1;
  late String boar1ID2;

  late String boar2ID1;
  late String boar2ID2;

  late String check_month;
  late String check_day;

  late String expect_month;
  late String expect_day;

  late List listfromserver_pre=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    prepareList();
  }

  prepareList() async{
    listfromserver_pre = await uploadimg_pregnant(File(widget.imagePath));
    //서버로부터 값 받아오기
    setState(() {
      // print("hey");
    });
  }
  // 서버로부터 받은 이미지를 띄우는 함수
  Widget showImage() {
    return Container(
        margin: EdgeInsets.only(left: 20,right: 20),
        color: Colors.white,
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: MediaQuery
            .of(context)
            .size
            .width*1.414,
        child: Center(
            child: Image.network(domain+"api/ocrGetImage/ocrpreimages/"+listfromserver_pre[0].toString())));
  }

  // 서버에서 받은 값이 수정가능하게 하기위해 TextEditingController로 선언
  final sowID1_Controller = TextEditingController();
  final sowID2_Controller = TextEditingController();

  final birth_year_Controller = TextEditingController();
  final birth_month_Controller = TextEditingController();
  final birth_day_Controller = TextEditingController();

  final adoption_year_Controller = TextEditingController();
  final adoption_month_Controller = TextEditingController();
  final adoption_day_Controller = TextEditingController();

  final hormone_year_Controller = TextEditingController();
  final hormone_month_Controller = TextEditingController();
  final hormone_day_Controller = TextEditingController();

  final mate_month_Controller = TextEditingController();
  final mate_day_Controller = TextEditingController();

  final boar1ID1_Controller = TextEditingController();
  final boar1ID2_Controller = TextEditingController();

  final boar2ID1_Controller = TextEditingController();
  final boar2ID2_Controller = TextEditingController();

  final check_month_Controller = TextEditingController();
  final check_day_Controller = TextEditingController();

  final expect_month_Controller = TextEditingController();
  final expect_day_Controller = TextEditingController();

  final vaccine1_fir_Controller = TextEditingController();
  final vaccine1_sec_Controller = TextEditingController();
  final vaccine2_fir_Controller = TextEditingController();
  final vaccine2_sec_Controller = TextEditingController();
  final vaccine3_fir_Controller = TextEditingController();
  final vaccine3_sec_Controller = TextEditingController();
  final vaccine4_fir_Controller = TextEditingController();
  final vaccine4_sec_Controller = TextEditingController();
  final memo_Controller = TextEditingController();
  final pxController = TextEditingController();

  var flag = 0; // 서버에서 가져온 값을 한번만 표에 넣기 위함
  @override
  Widget build(BuildContext context) {

    // 서버에서 받은 값이 들어있고, 현황판이 빈칸일때만 밑에 코드가 실행
    if(listfromserver_pre.isNotEmpty){
      if (flag==0) {
        flag++;
        // print(widget.listfromserver_pre);

        // 서버로부터 받은 값 매핑
        sowID1_Controller.text = listfromserver_pre[1][0].split("-")[0];
        sowID2_Controller.text = listfromserver_pre[1][0].split("-")[1];

        birth_year_Controller.text = listfromserver_pre[1][1];
        birth_month_Controller.text = listfromserver_pre[1][2];
        birth_day_Controller.text = listfromserver_pre[1][3];

        adoption_year_Controller.text = listfromserver_pre[1][4];
        adoption_month_Controller.text = listfromserver_pre[1][5];
        adoption_day_Controller.text = listfromserver_pre[1][6];

        hormone_year_Controller.text = listfromserver_pre[1][7];
        hormone_month_Controller.text = listfromserver_pre[1][8];
        hormone_day_Controller.text = listfromserver_pre[1][9];

        mate_month_Controller.text = listfromserver_pre[1][10];
        mate_day_Controller.text = listfromserver_pre[1][11];

        boar1ID1_Controller.text = listfromserver_pre[1][12].split("-")[0];
        boar1ID2_Controller.text = listfromserver_pre[1][12].split("-")[1];

        boar2ID1_Controller.text = listfromserver_pre[1][13].split("-")[0];
        boar2ID2_Controller.text = listfromserver_pre[1][13].split("-")[1];

        check_month_Controller.text = listfromserver_pre[1][14];
        check_day_Controller.text = listfromserver_pre[1][15];

        expect_month_Controller.text = listfromserver_pre[1][16];
        expect_day_Controller.text = listfromserver_pre[1][17];

        vaccine1_fir_Controller.text = listfromserver_pre[1][18];
        vaccine1_sec_Controller.text = listfromserver_pre[1][19];
        vaccine2_fir_Controller.text = listfromserver_pre[1][20];
        vaccine2_sec_Controller.text = listfromserver_pre[1][21];
        vaccine3_fir_Controller.text = listfromserver_pre[1][22];
        vaccine3_sec_Controller.text = listfromserver_pre[1][23];
        vaccine4_fir_Controller.text = listfromserver_pre[1][24];
        vaccine4_sec_Controller.text = listfromserver_pre[1][25];

        // memo_Controller.text = widget.listfromserver_pre[0];

        filename = listfromserver_pre[0];
      }
      return Scaffold(
          appBar: AppBar(
            title: Text('임신사'),
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            backgroundColor: Colors.white,
            centerTitle: true,
            leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.grey,), onPressed:(){
              Navigator.of(context).pop();
            }),
          ),
          body: Scrollbar(
            thumbVisibility: true, //always show scrollbar
            thickness: 10, //width of scrollbar
            radius: Radius.circular(20), //corner radius of scrollbar
            scrollbarOrientation: ScrollbarOrientation.right, //which side to show scrollbar
            child: GestureDetector( // 키보드 닫기 이벤트
                onVerticalDragDown: (DragDownDetails details){ FocusScope.of(context).unfocus();},
                onTap: () { FocusManager.instance.primaryFocus?.unfocus(); },
                child: SingleChildScrollView(
                    child: Column(children:<Widget>[
                      Container(
                        margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                        child: Table(
                          textBaseline: TextBaseline.alphabetic, // 글자 크기 맞추기
                          border: TableBorder.all(),
                          columnWidths: const {0: FractionColumnWidth(.0), 1: FractionColumnWidth(.4), 2: FractionColumnWidth(.4), 3: FractionColumnWidth(.1), 4: FractionColumnWidth(.1)},
                          children: [ // 현황판 표 만들기
                            TableRow(
                              children: [
                                const TableCell(
                                  child: SizedBox(height: 30,),
                                ),
                                Column(children: const [
                                  Text('모돈번호', style: TextStyle(fontSize: 20), textAlign: TextAlign.center,)
                                ]),
                                Column(children: [
                                  TextField(controller: sowID1_Controller,
                                    decoration: const InputDecoration(hintText: " "),
                                    style: const TextStyle(fontSize: 20),
                                    keyboardType: TextInputType.number, // 키보드 숫자만 나오게
                                    textAlign: TextAlign.center,),
                                ]),
                                Column(children: const [
                                  Text('-', style: TextStyle(fontSize: 20),
                                    textAlign: TextAlign.center,)
                                ],),
                                Column(children: [
                                  TextField(controller: sowID2_Controller,
                                    decoration: const InputDecoration(hintText: " "),
                                    style: const TextStyle(fontSize: 20),
                                    keyboardType: TextInputType.number, // 키보드 영어자판 나오게
                                    textAlign: TextAlign.center,),
                                ]),

                              ],),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        child: Table(
                          border: TableBorder.all(),
                          columnWidths: const {0: FractionColumnWidth(0), 1: FractionColumnWidth(.15), 2: FractionColumnWidth(.25), 3: FractionColumnWidth(.3), 4: FractionColumnWidth(.3)},
                          children: [
                            TableRow(children: [
                              const TableCell(
                                child: SizedBox(height: 30,),
                              ),
                              Column(children: const [
                                Text('출생일')
                              ]),
                              Column(children: [
                                TextField(controller: birth_year_Controller,
                                  decoration: const InputDecoration(hintText: " "),
                                  style: const TextStyle(fontSize: 20),
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,),
                              ]),
                              Column(children: [
                                TextField(controller: birth_month_Controller,
                                  decoration: const InputDecoration(hintText: " "),
                                  style: const TextStyle(fontSize: 20),
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,),
                              ]),
                              Column(children: [
                                TextField(controller: birth_day_Controller,
                                  decoration: const InputDecoration(hintText: " "),
                                  style: TextStyle(fontSize: 20),
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,),
                              ]),
                            ],),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        child: Table(
                          border: TableBorder.all(),
                          columnWidths: const {
                            0: FractionColumnWidth(0),
                            1: FractionColumnWidth(.15),
                            2: FractionColumnWidth(.25),
                            3: FractionColumnWidth(.3),
                            4: FractionColumnWidth(.3)
                          }, children: [
                          TableRow(children: [
                            const TableCell(
                              child: SizedBox(height: 30,),
                            ),
                            Column(children: const [
                              Text('구입일')
                            ]),
                            Column(children: [
                              TextField(controller: adoption_year_Controller,
                                decoration: const InputDecoration(hintText: " "),
                                style: const TextStyle(fontSize: 20),
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,),
                            ]),
                            Column(children: [
                              TextField(controller: adoption_month_Controller,
                                decoration: const InputDecoration(hintText: " "),
                                style: TextStyle(fontSize: 20),
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,),
                            ]),
                            Column(children: [
                              TextField(controller: adoption_day_Controller,
                                decoration: const InputDecoration(hintText: " "),
                                style: TextStyle(fontSize: 20),
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,),
                            ]),
                          ],),
                        ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        child: Table(
                          border: TableBorder.all(),
                          columnWidths: const {
                            0: FractionColumnWidth(0),
                            1: FractionColumnWidth(.15),
                            2: FractionColumnWidth(.25),
                            3: FractionColumnWidth(.3),
                            4: FractionColumnWidth(.3)
                          }, children: [
                          TableRow(children: [
                            const TableCell(
                              child: SizedBox(height: 30,),
                            ),
                            Column(children: const [
                              Text('초발정일')
                            ]),
                            Column(children: [
                              TextField(controller: hormone_year_Controller,
                                decoration: const InputDecoration(hintText: " "),
                                style: const TextStyle(fontSize: 20),
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,),
                            ]),
                            Column(children: [
                              TextField(controller: hormone_month_Controller,
                                decoration: const InputDecoration(hintText: " "),
                                style: const TextStyle(fontSize: 20),
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,),
                            ]),
                            Column(children: [
                              TextField(controller: hormone_day_Controller,
                                decoration: const InputDecoration(hintText: " "),
                                style: const TextStyle(fontSize: 20),
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,),
                            ]),
                          ],),
                        ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        child: Table(
                          border: TableBorder.all(),
                          columnWidths: const {
                            0: FractionColumnWidth(.0),
                            1: FractionColumnWidth(.15),
                            2: FractionColumnWidth(.43),
                            3: FractionColumnWidth(.42)
                          },
                          children: [
                            TableRow(children: [
                              const TableCell(
                                child: SizedBox(height: 30,),
                              ),
                              Column(children: const [
                                Text('교배일')
                              ]),
                              Column(children: [
                                TextField(controller: mate_month_Controller,
                                  decoration: const InputDecoration(hintText: " "),
                                  style: const TextStyle(fontSize: 20),
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,),
                              ]),
                              Column(children: [
                                TextField(controller: mate_day_Controller,
                                  decoration: const InputDecoration(hintText: " "),
                                  style: const TextStyle(fontSize: 20),
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,),
                              ]),
                            ],),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        child: Table(
                          border: TableBorder.all(),
                          columnWidths: const {
                            0: FractionColumnWidth(.0),
                            1: FractionColumnWidth(.15),
                            2: FractionColumnWidth(.2),
                            3: FractionColumnWidth(.05),
                            4: FractionColumnWidth(.1),
                            5: FractionColumnWidth(.15),
                            6: FractionColumnWidth(.2),
                            7: FractionColumnWidth(.05),
                            8: FractionColumnWidth(.1)
                          },
                          children: [
                            TableRow(children: [
                              const TableCell(
                                child: SizedBox(height: 30,),
                              ),
                              Column(children: const [
                                Text('1차 웅돈번호', textAlign: TextAlign.center)
                              ]),
                              Column(children: [
                                TextField(controller: boar1ID1_Controller,
                                  decoration: const InputDecoration(hintText: " "),
                                  style: TextStyle(fontSize: 20),
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,),
                              ]),
                              Column(children: const [
                                Text('-', style: TextStyle(fontSize: 20))
                              ]),
                              Column(children: [
                                TextField(controller: boar1ID2_Controller,
                                  decoration: const InputDecoration(hintText: " "),
                                  style: const TextStyle(fontSize: 20),
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,),
                              ]),
                              Column(children: const [
                                Text('2차 웅돈번호', textAlign: TextAlign.center)
                              ]),
                              Column(children: [
                                TextField(controller: boar2ID1_Controller,
                                  decoration: const InputDecoration(hintText: " "),
                                  style: const TextStyle(fontSize: 20),
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,),
                              ]),
                              Column(children: const [
                                Text('-', style: TextStyle(fontSize: 20))
                              ]),
                              Column(children: [
                                TextField(controller: boar2ID2_Controller,
                                  decoration: const InputDecoration(hintText: " "),
                                  style: const TextStyle(fontSize: 20),
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,),
                              ]),
                            ],),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        child: Table(
                          border: TableBorder.all(),
                          columnWidths: const {
                            0: FractionColumnWidth(.0),
                            1: FractionColumnWidth(.15),
                            2: FractionColumnWidth(.43),
                            3: FractionColumnWidth(.42)
                          },
                          children: [
                            TableRow(children: [
                              const TableCell(
                                child: SizedBox(height: 30,),
                              ),
                              Column(children: const [
                                Text('재발 확인일', textAlign: TextAlign.center)
                              ]),
                              Column(children: [
                                TextField(controller: check_month_Controller,
                                  decoration: const InputDecoration(hintText: " "),
                                  style: const TextStyle(fontSize: 20),
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,),
                              ]),
                              Column(children: [
                                TextField(controller: check_day_Controller,
                                  decoration: const InputDecoration(hintText: " "),
                                  style: const TextStyle(fontSize: 20),
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,),
                              ]),
                            ],),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        child: Table(
                          border: TableBorder.all(),
                          columnWidths: const {
                            0: FractionColumnWidth(.0),
                            1: FractionColumnWidth(.15),
                            2: FractionColumnWidth(.43),
                            3: FractionColumnWidth(.42)
                          },
                          children: [
                            TableRow(children: [
                              const TableCell(
                                child: SizedBox(height: 30,),
                              ),
                              Column(children: const [
                                Text('분만 예정일', textAlign: TextAlign.center)
                              ]),
                              Column(children: [
                                TextField(controller: expect_month_Controller,
                                  decoration: const InputDecoration(hintText: " "),
                                  style: const TextStyle(fontSize: 20),
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,),
                              ]),
                              Column(children: [
                                TextField(controller: expect_day_Controller,
                                  decoration: const InputDecoration(hintText: " "),
                                  style: const TextStyle(fontSize: 20),
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,),
                              ]),
                            ],),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        child: Table(
                          border: TableBorder.all(),
                          columnWidths: const {
                            0: FractionColumnWidth(.0),
                            1: FractionColumnWidth(.15),
                            2: FractionColumnWidth(.175),
                            3: FractionColumnWidth(.175),
                            4: FractionColumnWidth(.15),
                            5: FractionColumnWidth(.175),
                            6: FractionColumnWidth(.175)
                          },
                          children: [
                            TableRow(children: [
                              const TableCell(
                                child: SizedBox(height: 30,),
                              ),
                              Column(children: const [
                                Text('백신1')
                              ]),
                              Column(children: [
                                TextField(controller: vaccine1_fir_Controller,
                                  decoration: const InputDecoration(hintText: " "),
                                  style: const TextStyle(fontSize: 20),
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,),
                              ]),
                              Column(children: [
                                TextField(controller: vaccine1_sec_Controller,
                                  decoration: const InputDecoration(hintText: " "),
                                  style: TextStyle(fontSize: 20),
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,),
                              ]),
                              Column(children: const [
                                Text('백신2')
                              ]),
                              Column(children: [
                                TextField(controller: vaccine2_fir_Controller,
                                  decoration: const InputDecoration(hintText: " "),
                                  style: const TextStyle(fontSize: 20),
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,),
                              ]),
                              Column(children: [
                                TextField(controller: vaccine2_sec_Controller,
                                  decoration: const InputDecoration(hintText: " "),
                                  style: const TextStyle(fontSize: 20),
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,),
                              ]),
                            ],),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        child: Table(
                          border: TableBorder.all(),
                          columnWidths: const {
                            0: FractionColumnWidth(.0),
                            1: FractionColumnWidth(.15),
                            2: FractionColumnWidth(.175),
                            3: FractionColumnWidth(.175),
                            4: FractionColumnWidth(.15),
                            5: FractionColumnWidth(.175),
                            6: FractionColumnWidth(.175)
                          },
                          children: [
                            TableRow(children: [
                              const TableCell(
                                child: SizedBox(height: 30,),
                              ),
                              Column(children: const [
                                Text('백신3')
                              ]),
                              Column(children: [
                                TextField(controller: vaccine3_fir_Controller,
                                  decoration: const InputDecoration(hintText: " "),
                                  style: const TextStyle(fontSize: 20),
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,),
                              ]),
                              Column(children: [
                                TextField(controller: vaccine3_sec_Controller,
                                  decoration: const InputDecoration(hintText: " "),
                                  style: const TextStyle(fontSize: 20),
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,),
                              ]),
                              Column(children: const [
                                Text('백신4')
                              ]),
                              Column(children: [
                                TextField(controller: vaccine4_fir_Controller,
                                  decoration: const InputDecoration(hintText: " "),
                                  style: const TextStyle(fontSize: 20),
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,),
                              ]),
                              Column(children: [
                                TextField(controller: vaccine4_sec_Controller,
                                  decoration: const InputDecoration(hintText: " "),
                                  style: TextStyle(fontSize: 20),
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,),
                              ]),
                            ],),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        child: Table(

                          border: TableBorder.all(),
                          columnWidths: const {
                            0: FractionColumnWidth(0),
                            1: FractionColumnWidth(.15),
                            2: FractionColumnWidth(.85)
                          },
                          children: [
                            TableRow(children: [
                              const TableCell(
                                child: SizedBox(height: 80,),
                              ),
                              Column(children: const [
                                Text('특이사항')
                              ]),
                              Column(children: [
                                TextField(controller: memo_Controller,
                                  decoration: const InputDecoration(hintText: " "),
                                  style: const TextStyle(fontSize: 20),
                                  keyboardType: TextInputType.text,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                ),
                              ]),
                            ],),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10.0), // 위에 여백
                      showImage(),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            FloatingActionButton(
                              heroTag: 'send_button',
                              tooltip: 'send changed ocr',
                              onPressed: () async { // 서버로 값 보내기 전 매핑
                                sow_no = sowID1_Controller.text + "-" + sowID2_Controller.text;
                                sow_birth = birth_year_Controller.text + "-" + birth_month_Controller.text + "-" + birth_day_Controller.text;
                                sow_buy = adoption_year_Controller.text + "-" + adoption_month_Controller.text + "-" + adoption_day_Controller.text;
                                sow_estrus = hormone_year_Controller.text + "-" + hormone_month_Controller.text + "-" + hormone_day_Controller.text;
                                sow_cross = mate_month_Controller.text + "-" + mate_day_Controller.text;
                                boar_fir = boar1ID1_Controller.text + "-" + boar1ID2_Controller.text;
                                boar_sec = boar2ID1_Controller.text + "-" + boar2ID2_Controller.text;
                                checkdate = check_month_Controller.text + "-" + check_day_Controller.text;
                                expectdate = expect_month_Controller.text + "-" + expect_day_Controller.text;
                                vaccine1 = vaccine1_fir_Controller.text + "-" + vaccine1_sec_Controller.text;
                                vaccine2 = vaccine2_fir_Controller.text + "-" + vaccine2_sec_Controller.text;
                                vaccine3 = vaccine3_fir_Controller.text + "-" + vaccine3_sec_Controller.text;
                                vaccine4 = vaccine4_fir_Controller.text + "-" + vaccine4_sec_Controller.text; // "ocr_imgpath":'17',
                                memo = memo_Controller.text;

                                await pregnant_insert(); // 임신사 사진 전송 api 호출
                                Navigator.of(context).popUntil((route) => route.isFirst); // 처음 화면으로 돌아가기
                                Navigator.push(context, MaterialPageRoute(builder: (context) => PregnantListPage(companyCode: '',))); // PregnantListPage로 넘어가기
                              },
                              child: const Icon(Icons.arrow_circle_right_sharp),
                            ),
                          ]
                      )
                    ])
                )
            ),
          )

      );
    } else{
      return Container(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Colors.black,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator( // 로딩화면 애니메이션
                value: null,
                strokeWidth: 7.0,
                color: Colors.white,
              ),
              SizedBox(height: 20,),
              Text(
                "Loading...",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    decoration: TextDecoration.none
                ),
              ),
            ],
          )
      );
    }
  }
}

//임신사 사진전송 api
pregnant_insert() async {
  final api = domain+'api/ocrpregnantInsert';
  final data = {
    "sow_no": sow_no,
    "sow_birth": sow_birth,
    "sow_buy":sow_buy,
    "sow_estrus":sow_estrus,
    "sow_cross":sow_cross,
    "boar_fir":boar_fir,
    "boar_sec":boar_sec,
    "checkdate":checkdate,
    "expectdate":expectdate,
    "vaccine1":vaccine1,
    "vaccine2":vaccine2,
    "vaccine3":vaccine3,
    "vaccine4":vaccine4,
    "ocr_imgpath": filename,
    "memo":memo,
  };
  print(data);
  final dio = Dio();
  Response response;
  response = await dio.post(api,data: data);
  // print(response);
  if(response.statusCode == 200){
    resultToast('Ocr 임신사 insert success... \n\n');
  }
}