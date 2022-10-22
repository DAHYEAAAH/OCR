import 'package:flutter/material.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:last_ocr/overlay/camera_overlay_pregnant.dart';
import 'package:last_ocr/page/pregnant_list_page.dart';
import 'package:path_provider/path_provider.dart';
import '../functions/functions.dart';
import 'package:http_parser/http_parser.dart';
import 'package:ntp/ntp.dart';

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

  // const PregnantPage({Key? key, this.title}) : super(key: key);
  final List listfromserver_pre;
  final String Imagefromserver_pre;
  const PregnantPage(this.listfromserver_pre, this.Imagefromserver_pre);

  // final String? title;

  @override
  PregnantPageState createState() => PregnantPageState();
}

class PregnantPageState extends State<PregnantPage>{

  File? _image;
  final picker = ImagePicker();


  late List returnlist = [];

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

  Widget showImage() {

    return Container(
        margin: EdgeInsets.only(left: 20,right: 20),
        color: const Color(0xffd0cece),
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: MediaQuery
            .of(context)
            .size
            .width*1.414,
        child: Center(
            child: widget.Imagefromserver_pre.isEmpty ? Text('No image selected.') : Image.file(File(widget.Imagefromserver_pre))));
  }

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

  @override
  Widget build(BuildContext context) {

    if(widget.listfromserver_pre.isNotEmpty){
      if (sowID1_Controller.text.isEmpty) {
        print(widget.listfromserver_pre);

        sowID1_Controller.text = widget.listfromserver_pre[1][23].split("-")[0];
        sowID2_Controller.text = widget.listfromserver_pre[1][23].split("-")[1];

        birth_year_Controller.text = widget.listfromserver_pre[1][0];
        birth_month_Controller.text = widget.listfromserver_pre[1][1];
        birth_day_Controller.text = widget.listfromserver_pre[1][2];

        adoption_year_Controller.text = widget.listfromserver_pre[1][3];
        adoption_month_Controller.text = widget.listfromserver_pre[1][4];
        adoption_day_Controller.text = widget.listfromserver_pre[1][5];

        hormone_year_Controller.text = widget.listfromserver_pre[1][6];
        hormone_month_Controller.text = widget.listfromserver_pre[1][7];
        hormone_day_Controller.text = widget.listfromserver_pre[1][8];

        mate_month_Controller.text = widget.listfromserver_pre[1][9];
        mate_day_Controller.text = widget.listfromserver_pre[1][10];

        boar1ID1_Controller.text = widget.listfromserver_pre[1][24].split("-")[0];
        boar1ID2_Controller.text = widget.listfromserver_pre[1][24].split("-")[1];

        boar2ID1_Controller.text = widget.listfromserver_pre[1][25].split("-")[0];
        boar2ID2_Controller.text = widget.listfromserver_pre[1][25].split("-")[1];

        check_month_Controller.text = widget.listfromserver_pre[1][11];
        check_day_Controller.text = widget.listfromserver_pre[1][12];

        expect_month_Controller.text = widget.listfromserver_pre[1][13];
        expect_day_Controller.text = widget.listfromserver_pre[1][14];

        vaccine1_fir_Controller.text = widget.listfromserver_pre[1][15];
        vaccine1_sec_Controller.text = widget.listfromserver_pre[1][16];
        vaccine2_fir_Controller.text = widget.listfromserver_pre[1][17];
        vaccine2_sec_Controller.text = widget.listfromserver_pre[1][18];
        vaccine3_fir_Controller.text = widget.listfromserver_pre[1][19];
        vaccine3_sec_Controller.text = widget.listfromserver_pre[1][20];
        vaccine4_fir_Controller.text = widget.listfromserver_pre[1][21];
        vaccine4_sec_Controller.text = widget.listfromserver_pre[1][22];

        // memo_Controller.text = widget.listfromserver_pre[0];

        filename = widget.listfromserver_pre[0];
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("임신사"),
        ),
        body: Scrollbar(
            thumbVisibility: true, //always show scrollbar
            thickness: 10, //width of scrollbar
            radius: Radius.circular(20), //corner radius of scrollbar
            scrollbarOrientation: ScrollbarOrientation.right, //which side to show scrollbar
            child: SingleChildScrollView(
              child: Column(children:<Widget>[
                    Container(
                      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                      child: Table(
                        textBaseline: TextBaseline.alphabetic,
                        border: TableBorder.all(),
                        columnWidths: const {0: FractionColumnWidth(.0), 1: FractionColumnWidth(.4), 2: FractionColumnWidth(.4), 3: FractionColumnWidth(.1), 4: FractionColumnWidth(.1)},
                        children: [
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
                                  keyboardType: TextInputType.number,
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
                                  keyboardType: TextInputType.text,
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
                                keyboardType: TextInputType.text,
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
                                keyboardType: TextInputType.text,
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
                              child: SizedBox(height: 100,),
                            ),
                            Column(children: const [
                              Text('특이사항')
                            ]),
                            Column(children: [
                              TextField(controller: memo_Controller,
                                decoration: const InputDecoration(hintText: " "),
                                style: const TextStyle(fontSize: 20),
                                keyboardType: TextInputType.text,
                                textAlign: TextAlign.center,),
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
                            onPressed: () async {
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

                              await pregnant_insert();
                              List<dynamic> list = await pregnant_getocr();
                              Navigator.of(context).popUntil((route) => route.isFirst);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => PregnantListPage(list)));
                            },
                            child: const Icon(Icons.arrow_circle_right_sharp),
                          ),
                        ]
                    )
              ])
            ),
        )

    );

  }
}

//임신사 사진전송
pregnant_insert() async {
  final api ='http://211.107.210.141:3000/api/ocrpregnatInsert';
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
  print(response);
  if(response.statusCode == 200){
    resultToast('Ocr 임신사 insert success... \n\n');
  }
}