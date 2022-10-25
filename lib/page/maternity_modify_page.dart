import 'package:flutter/material.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:last_ocr/functions/functions.dart';

import 'maternity_list_page.dart';

late int ocr_seq;
late String sow_no;
late int sow_hang;
late String sow_birth;
late String sow_buy;
late String sow_expectdate;
late String sow_givebirth;
late String sow_totalbaby;
late String sow_feedbaby;
late String sow_babyweight;
late String sow_sevrerdate;
late String sow_sevrerqty;
late String sow_sevrerweight;
late String vaccine1;
late String vaccine2;
late String vaccine3;
late String vaccine4;
late String memo;

late String filename;

class MaternityModifyPage extends StatefulWidget{
  static const routeName = '/OcrMaternityPage';

  // const MaternityPage({Key? key, this.title}) : super(key: key);
  final List listfromserver_mat_mo;
  final String Imagefromserver_pre;
  const MaternityModifyPage(this.listfromserver_mat_mo, this.Imagefromserver_pre);

  @override
  MaternityModifyPageState createState() => MaternityModifyPageState();
}

class MaternityModifyPageState extends State<MaternityModifyPage>{

  late String sowID1;
  late String sowID2;

  late String birth_year;
  late String birth_month;
  late String birth_day;

  late String adoption_year;
  late String adoption_month;
  late String adoption_day;

  late String expect_year;
  late String expect_month;
  late String expect_day;

  late String teen_month;
  late String teen_day;

  late String givebirth_month;
  late String givebirth_day;

  late String totalbaby;

  late String feedbaby;

  late String weight;

  late String totalteen;

  late String teenweight;


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
        child: Center( child: widget.Imagefromserver_pre.isEmpty ? Text('No image selected.') : Image.file(File(widget.Imagefromserver_pre))));
  }

  //모돈번호
  final sowID1_Controller = TextEditingController();
  final sowID2_Controller = TextEditingController();

  //출생일
  final birth_year_Controller = TextEditingController();
  final birth_month_Controller = TextEditingController();
  final birth_day_Controller = TextEditingController();

  //구입일
  final adoption_year_Controller = TextEditingController();
  final adoption_month_Controller = TextEditingController();
  final adoption_day_Controller = TextEditingController();

  //분만예정일
  final expect_year_Controller = TextEditingController();
  final expect_month_Controller = TextEditingController();
  final expect_day_Controller = TextEditingController();

  //이유일
  final teen_month_Controller = TextEditingController();
  final teen_day_Controller = TextEditingController();

  //분만일
  final givebirth_month_Controller = TextEditingController();
  final givebirth_day_Controller = TextEditingController();

  //총산자수
  final totalbaby_Controller = TextEditingController();
  final feedbaby_Controller = TextEditingController();
  //생시체중
  final weight_Controller = TextEditingController();

  //이유두수
  final totalteen_Controller = TextEditingController();

  //이유체중

  final teenweight_Controller = TextEditingController();


  final vaccine1_fir_Controller = TextEditingController();
  final vaccine1_sec_Controller = TextEditingController();
  final vaccine2_fir_Controller = TextEditingController();
  final vaccine2_sec_Controller = TextEditingController();
  final vaccine3_fir_Controller = TextEditingController();
  final vaccine3_sec_Controller = TextEditingController();
  final vaccine4_fir_Controller = TextEditingController();
  final vaccine4_sec_Controller = TextEditingController();

  final memo_Controller = TextEditingController();



  @override
  Widget build(BuildContext context) {

    if(widget.listfromserver_mat_mo.isNotEmpty){
      if(sowID1_Controller.text.isEmpty) {
        print("분만사 수정 페이지 : ");
        print(widget.listfromserver_mat_mo);
        sowID1_Controller.text = widget.listfromserver_mat_mo[1].toString().split("-")[0];
        sowID2_Controller.text = widget.listfromserver_mat_mo[1].toString().split("-")[1];

        birth_year_Controller.text = widget.listfromserver_mat_mo[3].toString().split("-")[0];
        birth_month_Controller.text = widget.listfromserver_mat_mo[3].toString().split("-")[1];
        birth_day_Controller.text = widget.listfromserver_mat_mo[3].toString().split("-")[2];

        adoption_year_Controller.text = widget.listfromserver_mat_mo[4].toString().split("-")[0];
        adoption_month_Controller.text = widget.listfromserver_mat_mo[4].toString().split("-")[1];
        adoption_day_Controller.text = widget.listfromserver_mat_mo[4].toString().split("-")[2];

        expect_year_Controller.text = widget.listfromserver_mat_mo[5].toString().split("-")[0];
        expect_month_Controller.text = widget.listfromserver_mat_mo[5].toString().split("-")[1];
        expect_day_Controller.text = widget.listfromserver_mat_mo[5].toString().split("-")[2];

        givebirth_month_Controller.text = widget.listfromserver_mat_mo[6].toString().split("-")[0];
        givebirth_day_Controller.text = widget.listfromserver_mat_mo[6].toString().split("-")[1];

        totalbaby_Controller.text = widget.listfromserver_mat_mo[7].toString();
        feedbaby_Controller.text = widget.listfromserver_mat_mo[8].toString();
        weight_Controller.text = widget.listfromserver_mat_mo[9].toString();

        teen_month_Controller.text = widget.listfromserver_mat_mo[10].toString().split("-")[0];
        teen_day_Controller.text = widget.listfromserver_mat_mo[10].toString().split("-")[1];

        totalteen_Controller.text = widget.listfromserver_mat_mo[11];
        teenweight_Controller.text = widget.listfromserver_mat_mo[12];

        vaccine1_fir_Controller.text = widget.listfromserver_mat_mo[13].toString().split("-")[0];
        vaccine1_sec_Controller.text = widget.listfromserver_mat_mo[13].toString().split("-")[1];
        vaccine2_fir_Controller.text = widget.listfromserver_mat_mo[14].toString().split("-")[0];
        vaccine2_sec_Controller.text = widget.listfromserver_mat_mo[14].toString().split("-")[1];
        vaccine3_fir_Controller.text = widget.listfromserver_mat_mo[15].toString().split("-")[0];
        vaccine3_sec_Controller.text = widget.listfromserver_mat_mo[15].toString().split("-")[1];
        vaccine4_fir_Controller.text = widget.listfromserver_mat_mo[16].toString().split("-")[0];
        vaccine4_sec_Controller.text = widget.listfromserver_mat_mo[16].toString().split("-")[1];

      }
    }
    return Scaffold(
        appBar: AppBar(
          title: Text("분만사"),
        ),
        body: Scrollbar(
              thumbVisibility: true, //always show scrollbar
              thickness: 10, //width of scrollbar
              radius: Radius.circular(20), //corner radius of scrollbar
              scrollbarOrientation: ScrollbarOrientation.right, //which side to show scrollbar
              child: SingleChildScrollView(
                child: Column(
                  children:[
                    Container(
                      margin: const EdgeInsets.only(left: 20,right: 20,top: 20),
                      child: Table(
                        textBaseline: TextBaseline.alphabetic,
                        border: TableBorder.all(),
                        columnWidths: const {0: FractionColumnWidth(.0),1: FractionColumnWidth(.4), 2: FractionColumnWidth(.4), 3: FractionColumnWidth(.1),4: FractionColumnWidth(.1)},
                        children: [
                          TableRow(
                            children: [
                              const TableCell(
                                child: SizedBox(height: 30,),
                              ),
                              Column(children:const[
                                Text('모돈번호',style: TextStyle(fontSize: 20),textAlign: TextAlign.center,)
                              ]),
                              Column(children:[
                                TextField(controller: sowID1_Controller, enabled: false,
                                  decoration: const InputDecoration(hintText: " "),style: TextStyle(fontSize: 20),keyboardType: TextInputType.number,textAlign: TextAlign.center,),
                              ]),
                              Column(children:[
                                Text('-',style: TextStyle(fontSize: 20),textAlign: TextAlign.center,)
                              ], ),
                              Column(children:[
                                TextField(controller: sowID2_Controller, enabled: false,
                                  decoration: const InputDecoration(hintText: " "),style: TextStyle(fontSize: 20),keyboardType: TextInputType.text,textAlign: TextAlign.center,),
                              ]),

                            ],),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20,right: 20),
                      child: Table(
                        border: TableBorder.all(),
                        columnWidths: {0:FractionColumnWidth(0),1: FractionColumnWidth(.15), 2: FractionColumnWidth(.25), 3: FractionColumnWidth(.3),4: FractionColumnWidth(.3)},
                        children: [
                          TableRow( children: [
                            TableCell(
                              child: SizedBox(height: 30,),
                            ),
                            Column(children:[
                              Text('출생일')
                            ]),
                            Column(children:[
                              TextField(controller: birth_year_Controller,
                                decoration: const InputDecoration(hintText: " "),style: TextStyle(fontSize: 20),keyboardType: TextInputType.number,textAlign: TextAlign.center,),
                            ]),
                            Column(children:[
                              TextField(controller: birth_month_Controller,
                                decoration: const InputDecoration(hintText: " "),style: TextStyle(fontSize: 20),keyboardType: TextInputType.number,textAlign: TextAlign.center,),
                            ]),
                            Column(children:[
                              TextField(controller: birth_day_Controller,
                                decoration: const InputDecoration(hintText: " "),style: TextStyle(fontSize: 20),keyboardType: TextInputType.number,textAlign: TextAlign.center,),
                            ]),
                          ],),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20,right: 20),
                      child: Table(
                        border: TableBorder.all(),
                        columnWidths: {0:FractionColumnWidth(0),1: FractionColumnWidth(.15), 2: FractionColumnWidth(.25), 3: FractionColumnWidth(.3),4: FractionColumnWidth(.3)},                  children: [
                        TableRow( children: [
                          TableCell(
                            child: SizedBox(height: 30,),
                          ),
                          Column(children:[
                            Text('구입일')
                          ]),
                          Column(children:[
                            TextField(controller: adoption_year_Controller,
                              decoration: const InputDecoration(hintText: " "),style: TextStyle(fontSize: 20),keyboardType: TextInputType.number,textAlign: TextAlign.center,),
                          ]),
                          Column(children:[
                            TextField(controller: adoption_month_Controller,
                              decoration: const InputDecoration(hintText: " "),style: TextStyle(fontSize: 20),keyboardType: TextInputType.number,textAlign: TextAlign.center,),
                          ]),
                          Column(children:[
                            TextField(controller: adoption_day_Controller,
                              decoration: const InputDecoration(hintText: " "),style: TextStyle(fontSize: 20),keyboardType: TextInputType.number,textAlign: TextAlign.center,),
                          ]),
                        ],),
                      ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20,right: 20),
                      child: Table(
                        border: TableBorder.all(),
                        columnWidths: {0:FractionColumnWidth(0),1: FractionColumnWidth(.15), 2: FractionColumnWidth(.25), 3: FractionColumnWidth(.3),4: FractionColumnWidth(.3)},                  children: [
                        TableRow( children: [
                          TableCell(
                            child: SizedBox(height: 30,),
                          ),
                          Column(children:[
                            Text('분만예정일')
                          ]),
                          Column(children:[
                            TextField(controller: expect_year_Controller,
                              decoration: const InputDecoration(hintText: " "),style: TextStyle(fontSize: 20),keyboardType: TextInputType.number,textAlign: TextAlign.center,),
                          ]),
                          Column(children:[
                            TextField(controller: expect_month_Controller,
                              decoration: const InputDecoration(hintText: " "),style: TextStyle(fontSize: 20),keyboardType: TextInputType.number,textAlign: TextAlign.center,),
                          ]),
                          Column(children:[
                            TextField(controller: expect_day_Controller,
                              decoration: const InputDecoration(hintText: " "),style: TextStyle(fontSize: 20),keyboardType: TextInputType.number,textAlign: TextAlign.center,),
                          ]),
                        ],),
                      ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20,right: 20),
                      child: Table(
                        border: TableBorder.all(),
                        columnWidths: {0:FractionColumnWidth(.0),1: FractionColumnWidth(.15), 2: FractionColumnWidth(.43), 3: FractionColumnWidth(.42)},
                        children: [
                          TableRow( children: [
                            TableCell(
                              child: SizedBox(height: 30,),
                            ),
                            Column(children:[
                              Text('분만일')
                            ]),
                            Column(children:[
                              TextField(controller: givebirth_month_Controller,
                                decoration: const InputDecoration(hintText: " "),style: TextStyle(fontSize: 20),keyboardType: TextInputType.number,textAlign: TextAlign.center,),
                            ]),
                            Column(children:[
                              TextField(controller: givebirth_day_Controller,
                                decoration: const InputDecoration(hintText: " "),style: TextStyle(fontSize: 20),keyboardType: TextInputType.number,textAlign: TextAlign.center,),
                            ]),
                          ],),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20,right: 20),
                      child: Table(
                        border: TableBorder.all(),
                        columnWidths: {0:FractionColumnWidth(.0), 1: FractionColumnWidth(.15), 2: FractionColumnWidth(.175), 3: FractionColumnWidth(.175),4: FractionColumnWidth(.15), 5: FractionColumnWidth(.175), 6: FractionColumnWidth(.175)},
                        children: [
                          TableRow( children: [
                            TableCell(
                              child: SizedBox(height: 30,),
                            ),
                            Column(children:[
                              Text('총산자수', textAlign: TextAlign.center)
                            ]),
                            Column(children:[
                              TextField(controller: totalbaby_Controller,
                                decoration: const InputDecoration(hintText: " "),style: TextStyle(fontSize: 20),keyboardType: TextInputType.number,textAlign: TextAlign.center,),
                            ]),
                            Column(children:[
                              Text('포유개시두수', textAlign: TextAlign.center)
                            ]),
                            Column(children:[
                              TextField(controller: feedbaby_Controller,
                                decoration: const InputDecoration(hintText: " "),style: TextStyle(fontSize: 20),keyboardType: TextInputType.number,textAlign: TextAlign.center,),
                            ]),
                            Column(children:[
                              Text('생시체중(kg)', textAlign: TextAlign.center)
                            ]),
                            Column(children:[
                              TextField(controller: weight_Controller,
                                decoration: const InputDecoration(hintText: " "),style: TextStyle(fontSize: 20),keyboardType: TextInputType.number,textAlign: TextAlign.center,),
                            ]),
                          ],),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20,right: 20),
                      child: Table(
                        border: TableBorder.all(),
                        columnWidths: {0:FractionColumnWidth(.0),1: FractionColumnWidth(.15), 2: FractionColumnWidth(.43), 3: FractionColumnWidth(.42)},
                        children: [
                          TableRow( children: [
                            TableCell(
                              child: SizedBox(height: 30,),
                            ),
                            Column(children:[
                              Text('이유일', textAlign: TextAlign.center)
                            ]),
                            Column(children:[
                              TextField(controller:  teen_month_Controller,
                                decoration: const InputDecoration(hintText: " "),style: TextStyle(fontSize: 20),keyboardType: TextInputType.number,textAlign: TextAlign.center,),
                            ]),
                            Column(children:[
                              TextField(controller: teen_day_Controller,
                                decoration: const InputDecoration(hintText: " "),style: TextStyle(fontSize: 20),keyboardType: TextInputType.number,textAlign: TextAlign.center,),
                            ]),
                          ],),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20,right: 20),
                      child: Table(
                        border: TableBorder.all(),
                        columnWidths: {0: FractionColumnWidth(.0),1: FractionColumnWidth(.15), 2: FractionColumnWidth(.35), 3: FractionColumnWidth(.15),4: FractionColumnWidth(.35)},
                        children: [
                          TableRow( children: [
                            TableCell(
                              child: SizedBox(height: 30,),
                            ),
                            Column(children:[
                              Text('이유두수', textAlign: TextAlign.center)
                            ]),
                            Column(children:[
                              TextField(controller: totalteen_Controller,
                                decoration: const InputDecoration(hintText: " "),style: TextStyle(fontSize: 20),keyboardType: TextInputType.number,textAlign: TextAlign.center,),
                            ]),
                            Column(children:[
                              Text('이유체중(kg)', textAlign: TextAlign.center)
                            ]),
                            Column(children:[
                              TextField(controller: teenweight_Controller,
                                decoration: const InputDecoration(hintText: " "),style: TextStyle(fontSize: 20),keyboardType: TextInputType.number,textAlign: TextAlign.center,),
                            ]),
                          ],),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20,right: 20),
                      child: Table(
                        border: TableBorder.all(),
                        columnWidths: {0:FractionColumnWidth(.0), 1: FractionColumnWidth(.15), 2: FractionColumnWidth(.175), 3: FractionColumnWidth(.175),4: FractionColumnWidth(.15), 5: FractionColumnWidth(.175), 6: FractionColumnWidth(.175)},
                        children: [
                          TableRow( children: [
                            TableCell(
                              child: SizedBox(height: 30,),
                            ),
                            Column(children:[
                              Text('백신1')
                            ]),
                            Column(children:[
                              TextField(controller: vaccine1_fir_Controller,
                                decoration: const InputDecoration(hintText: " "),style: TextStyle(fontSize: 20),keyboardType: TextInputType.number,textAlign: TextAlign.center,),
                            ]),
                            Column(children:[
                              TextField(controller: vaccine1_sec_Controller,
                                decoration: const InputDecoration(hintText: " "),style: TextStyle(fontSize: 20),keyboardType: TextInputType.number,textAlign: TextAlign.center,),
                            ]),
                            Column(children:[
                              Text('백신2')
                            ]),
                            Column(children:[
                              TextField(controller: vaccine2_fir_Controller,
                                decoration: const InputDecoration(hintText: " "),style: TextStyle(fontSize: 20),keyboardType: TextInputType.number,textAlign: TextAlign.center,),
                            ]),
                            Column(children:[
                              TextField(controller: vaccine2_sec_Controller,
                                decoration: const InputDecoration(hintText: " "),style: TextStyle(fontSize: 20),keyboardType: TextInputType.number,textAlign: TextAlign.center,),
                            ]),
                          ],),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20,right: 20),
                      child: Table(
                        border: TableBorder.all(),
                        columnWidths: {0: FractionColumnWidth(.0), 1: FractionColumnWidth(.15), 2: FractionColumnWidth(.175), 3: FractionColumnWidth(.175), 4: FractionColumnWidth(.15), 5: FractionColumnWidth(.175), 6: FractionColumnWidth(.175)},
                        children: [
                          TableRow( children: [
                            TableCell(
                              child: SizedBox(height: 30,),
                            ),
                            Column(children:[
                              Text('백신3')
                            ]),
                            Column(children:[
                              TextField(controller: vaccine3_fir_Controller,
                                decoration: const InputDecoration(hintText: " "),style: TextStyle(fontSize: 20),keyboardType: TextInputType.number,textAlign: TextAlign.center,),
                            ]),
                            Column(children:[
                              TextField(controller: vaccine3_sec_Controller,
                                decoration: const InputDecoration(hintText: " "),style: TextStyle(fontSize: 20),keyboardType: TextInputType.number,textAlign: TextAlign.center,),
                            ]),
                            Column(children:[
                              Text('백신4')
                            ]),
                            Column(children:[
                              TextField(controller: vaccine4_fir_Controller,
                                decoration: const InputDecoration(hintText: " "),style: TextStyle(fontSize: 20),keyboardType: TextInputType.number,textAlign: TextAlign.center,),
                            ]),
                            Column(children:[
                              TextField(controller: vaccine4_sec_Controller,
                                decoration: const InputDecoration(hintText: " "),style: TextStyle(fontSize: 20),keyboardType: TextInputType.number,textAlign: TextAlign.center,),
                            ]),
                          ],),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20,right: 20),
                      child: Table(

                        border: TableBorder.all(),
                        columnWidths: {0: FractionColumnWidth(0),1: FractionColumnWidth(.15), 2: FractionColumnWidth(.85)},
                        children: [
                          TableRow(children: [
                            TableCell(
                              child: SizedBox(height: 100,),
                            ),
                            Column(children:[
                              Text('특이사항')
                            ]),
                            Column(children:[
                              TextField(controller: memo_Controller,
                                decoration: const InputDecoration(hintText: " "),style: TextStyle(fontSize: 20),keyboardType: TextInputType.text,textAlign: TextAlign.center,),
                            ]),
                          ],),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.0), // 위에 여백
                    showImage(),
                    SizedBox(
                      height: 15.0,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          FloatingActionButton(
                            heroTag: 'send_button',
                            child: Icon(Icons.arrow_circle_right_sharp),
                            tooltip: 'send updated ocr',
                            onPressed: () async{
                              sow_no = sowID1_Controller.text + "-" + sowID2_Controller.text;
                              sow_birth = birth_year_Controller.text +"-" + birth_month_Controller.text + "-" + birth_day_Controller.text;
                              sow_buy = adoption_year_Controller.text + "-" +  adoption_month_Controller.text + "-" + adoption_day_Controller.text;
                              sow_expectdate = expect_year_Controller.text + "-" + expect_month_Controller.text + "-" + expect_day_Controller.text;
                              sow_givebirth = givebirth_month_Controller.text + "-" + givebirth_day_Controller.text;
                              sow_totalbaby = totalbaby_Controller.text;
                              sow_feedbaby = feedbaby_Controller.text;
                              sow_babyweight = weight_Controller.text; //생시체중
                              sow_sevrerdate = teen_month_Controller.text +"-"+ teen_day_Controller.text;//이유일
                              sow_sevrerqty   = totalteen_Controller.text;//이유두수
                              sow_sevrerweight = teenweight_Controller.text;//이유체중
                              vaccine1 = vaccine1_fir_Controller.text + "-" + vaccine1_sec_Controller.text;
                              vaccine2 = vaccine2_fir_Controller.text + "-" + vaccine2_sec_Controller.text;
                              vaccine3 = vaccine3_fir_Controller.text + "-" + vaccine3_sec_Controller.text;
                              vaccine4 = vaccine4_fir_Controller.text + "-" + vaccine4_sec_Controller.text;
                              // "ocr_imgpath":'17',
                              memo = memo_Controller.text;
                              ocr_seq = widget.listfromserver_mat_mo[0];
                              sow_hang = widget.listfromserver_mat_mo[2];
                              maternity_update();
                              List<dynamic> list = await maternity_getocr();
                              print("modifypage-maternity_getocr");
                              print(list);
                              Navigator.of(context).popUntil((route) => route.isFirst);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => MaternityListPage(list)));
                            },
                          ),
                        ])
                  ]
                ),
              ),
        )
    );

  }
}

maternity_update() async {
  final api ='https://www.dfxsoft.com/api/ocrmaternityUpdate';
  final data = {
    "ocr_seq": ocr_seq,
    "sow_no": sow_no,
    "sow_hang": sow_hang,
    "sow_birth": sow_birth,
    "sow_buy": sow_buy,
    "sow_expectdate": sow_expectdate,
    "sow_givebirth": sow_givebirth,
    "sow_totalbaby": sow_totalbaby,
    "sow_feedbaby": sow_feedbaby,
    "sow_babyweight": sow_babyweight,
    "sow_sevrerdate": sow_sevrerdate,
    "sow_sevrerqty": sow_sevrerqty,
    "sow_sevrerweight": sow_sevrerweight,
    "vaccine1": vaccine1,
    "vaccine2": vaccine2,
    "vaccine3": vaccine3,
    "vaccine4": vaccine4,
    // "ocr_imgpath":'14',
    "memo": memo,
  };
  final dio = Dio();
  Response response;
  response = await dio.post(api,data: data);
  if(response.statusCode == 200){
    resultToast('Ocr 분만사 update success... \n\n');
  }
}