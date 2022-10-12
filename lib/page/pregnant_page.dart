import 'package:flutter/material.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:last_ocr/overlay/camera_overlay_pregnant.dart';


class PregnantPage extends StatefulWidget{
  static const routeName = '/OcrPregnantPage';

  const PregnantPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  PregnantPageState createState() => PregnantPageState();
}

class PregnantPageState extends State<PregnantPage>{

  File? _image;
  final picker = ImagePicker();

  late String sowID1 ='';
  late String sowID2 ='';
  late String sowID3 ='';
  late String sowID4 ='';
  late String sowID5 ='';

  late String birth_year ='';
  late String birth_month ='';
  late String birth_day ='';

  late String adoption_year ='';
  late String adoption_month ='';
  late String adoption_day ='';

  late String hormone_year ='';
  late String hormone_month ='';
  late String hormone_day ='';

  late String mate_month ='';
  late String mate_day ='';

  late String boar1ID1 ='';
  late String boar1ID2 ='';
  late String boar1ID3 ='';
  late String boar1ID4 ='';
  late String boar1ID5 ='';

  late String boar2ID1 ='';
  late String boar2ID2 ='';
  late String boar2ID3 ='';
  late String boar2ID4 ='';
  late String boar2ID5 ='';

  late String check_month ='';
  late String check_day ='';

  late String expect_month ='';
  late String expect_day ='';

  late String vaccine1 ='';
  late String vaccine2 ='';
  late String vaccine3 ='';
  late String vaccine4 ='';

  late String memo = '';

  late String sowID = '';
  late String title = '';
  late String ocr_seq ='';
  late String sow_no ='';
  late String sow_birth = '';
  late String sow_buy = '';
  late String sow_estrus= '';
  late String sow_cross= '';
  late String boar_fir= '';
  late String boar_sec= '';
  late String checkdate= '';
  late String expectdate= '';
  //late String

  String galleryurl = '';



  Widget showImage() {

    return Container(
        color: const Color(0xffd0cece),
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: MediaQuery
            .of(context)
            .size
            .width,
        child: Center(
            child: Text('No image selected.')));
  }

  // 비동기 처리를 통해 카메라와 갤러리에서 이미지를 가져온다.
  Future getImage(ImageSource imageSource) async {
    final image = await picker.pickImage(source: imageSource);

    final temp = await submit_uploadimg_front(image);
    print("aaaa");
    print(temp);

    setState((){
      _image = File(image!.path); // 가져온 이미지를 _image에 저장
    });
    return temp;
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
    return Scaffold(
        appBar: AppBar(
          title: Text("임신사"),
        ),
        body: SingleChildScrollView(

          child: Column(
            children:[
              Container(
                margin: EdgeInsets.only(left: 20,right: 20,top: 20),
                child: Table(
                  textBaseline: TextBaseline.alphabetic,
                  border: TableBorder.all(),
                  columnWidths: {0: FractionColumnWidth(.0),1: FractionColumnWidth(.4), 2: FractionColumnWidth(.4), 3: FractionColumnWidth(.1),4: FractionColumnWidth(.1)},
                  children: [
                    TableRow(
                      children: [
                        TableCell(
                          child: SizedBox(height: 30,),
                        ),
                        Column(children:[
                          Text('모돈번호',style: TextStyle(fontSize: 20),textAlign: TextAlign.center,)
                        ],
                        ),
                        Column(children:[
                          TextField(controller: sowID1_Controller,
                            decoration: const InputDecoration(hintText: " "),style: TextStyle(fontSize: 20),),
                        ]),
                        Column(children:[
                          Text('-',style: TextStyle(fontSize: 20),textAlign: TextAlign.center,)
                        ], ),
                        Column(children:[
                          TextField(controller: sowID2_Controller,
                            decoration: const InputDecoration(hintText: " "),style: TextStyle(fontSize: 20),),
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
                          decoration: const InputDecoration(hintText: " "),style: TextStyle(fontSize: 20),),
                      ]),
                      Column(children:[
                        TextField(controller: birth_month_Controller,
                          decoration: const InputDecoration(hintText: " "),style: TextStyle(fontSize: 20),),
                      ]),
                      Column(children:[
                        TextField(controller: birth_day_Controller,
                          decoration: const InputDecoration(hintText: " "),style: TextStyle(fontSize: 20),),
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
                        decoration: const InputDecoration(hintText: " "),style: TextStyle(fontSize: 20),),
                    ]),
                    Column(children:[
                      TextField(controller: adoption_month_Controller,
                        decoration: const InputDecoration(hintText: " "),style: TextStyle(fontSize: 20),),
                    ]),
                    Column(children:[
                      TextField(controller: adoption_day_Controller,
                        decoration: const InputDecoration(hintText: " "),style: TextStyle(fontSize: 20),),
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
                      Text('초발정일')
                    ]),
                    Column(children:[
                      TextField(controller: hormone_year_Controller,
                        decoration: const InputDecoration(hintText: " "),style: TextStyle(fontSize: 20),),
                    ]),
                    Column(children:[
                      TextField(controller: hormone_month_Controller,
                        decoration: const InputDecoration(hintText: " "),style: TextStyle(fontSize: 20),),
                    ]),
                    Column(children:[
                      TextField(controller: hormone_day_Controller,
                        decoration: const InputDecoration(hintText: " "),style: TextStyle(fontSize: 20),),
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
                        Text('교배일')
                      ]),
                      Column(children:[
                        TextField(controller: mate_month_Controller,
                          decoration: const InputDecoration(hintText: " "),style: TextStyle(fontSize: 20),),
                      ]),
                      Column(children:[
                        TextField(controller: mate_day_Controller,
                          decoration: const InputDecoration(hintText: " "),style: TextStyle(fontSize: 20),),
                      ]),
                    ],),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20,right: 20),
                child: Table(
                  border: TableBorder.all(),
                  columnWidths: {0:FractionColumnWidth(.0),1: FractionColumnWidth(.15), 2: FractionColumnWidth(.2), 3: FractionColumnWidth(.05),4: FractionColumnWidth(.1),5: FractionColumnWidth(.15), 6: FractionColumnWidth(.2), 7: FractionColumnWidth(.05), 8: FractionColumnWidth(.1)},
                  children: [
                    TableRow( children: [
                      TableCell(
                        child: SizedBox(height: 30,),
                      ),
                      Column(children:[
                        Text('1차 웅돈번호', textAlign: TextAlign.center)
                      ]),
                      Column(children:[
                        TextField(controller: boar1ID1_Controller,
                          decoration: const InputDecoration(hintText: " "),style: TextStyle(fontSize: 20),),
                      ]),
                      Column(children:[
                        Text('-',style: TextStyle(fontSize: 20))
                      ]),
                      Column(children:[
                        TextField(controller: boar1ID2_Controller,
                          decoration: const InputDecoration(hintText: " "),style: TextStyle(fontSize: 20),),
                      ]),
                      Column(children:[
                        Text('2차 웅돈번호', textAlign: TextAlign.center)
                      ]),
                      Column(children:[
                        TextField(controller: boar2ID1_Controller,
                          decoration: const InputDecoration(hintText: " "),style: TextStyle(fontSize: 20),),
                      ]),
                      Column(children:[
                        Text('-',style: TextStyle(fontSize: 20))
                      ]),
                      Column(children:[
                        TextField(controller: boar2ID1_Controller,
                          decoration: const InputDecoration(hintText: " "),style: TextStyle(fontSize: 20),),
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
                        Text('재발 확인일', textAlign: TextAlign.center)
                      ]),
                      Column(children:[
                        TextField(controller: check_month_Controller,
                          decoration: const InputDecoration(hintText: " "),style: TextStyle(fontSize: 20),),
                      ]),
                      Column(children:[
                        TextField(controller: check_day_Controller,
                          decoration: const InputDecoration(hintText: " "),style: TextStyle(fontSize: 20),),
                      ]),
                    ],),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20,right: 20),
                child: Table(
                  border: TableBorder.all(),
                  columnWidths: {0: FractionColumnWidth(.0),1: FractionColumnWidth(.15), 2: FractionColumnWidth(.43), 3: FractionColumnWidth(.42)},
                  children: [
                    TableRow( children: [
                      TableCell(
                        child: SizedBox(height: 30,),
                      ),
                      Column(children:[
                        Text('분만 예정일', textAlign: TextAlign.center)
                      ]),
                      Column(children:[
                        TextField(controller: expect_month_Controller,
                          decoration: const InputDecoration(hintText: " "),style: TextStyle(fontSize: 20),),
                      ]),
                      Column(children:[
                        TextField(controller: expect_day_Controller,
                          decoration: const InputDecoration(hintText: " "),style: TextStyle(fontSize: 20),),
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
                          decoration: const InputDecoration(hintText: " "),style: TextStyle(fontSize: 20),),
                      ]),
                      Column(children:[
                        TextField(controller: vaccine1_sec_Controller,
                          decoration: const InputDecoration(hintText: " "),style: TextStyle(fontSize: 20),),
                      ]),
                      Column(children:[
                        Text('백신2')
                      ]),
                      Column(children:[
                        TextField(controller: vaccine2_fir_Controller,
                          decoration: const InputDecoration(hintText: " "),style: TextStyle(fontSize: 20),),
                      ]),
                      Column(children:[
                        TextField(controller: vaccine2_sec_Controller,
                          decoration: const InputDecoration(hintText: " "),style: TextStyle(fontSize: 20),),
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
                          decoration: const InputDecoration(hintText: " "),style: TextStyle(fontSize: 20),),
                      ]),
                      Column(children:[
                        TextField(controller: vaccine4_sec_Controller,
                          decoration: const InputDecoration(hintText: " "),style: TextStyle(fontSize: 20),),
                      ]),
                      Column(children:[
                        Text('백신4')
                      ]),
                      Column(children:[
                        TextField(controller: vaccine4_fir_Controller,
                          decoration: const InputDecoration(hintText: " "),style: TextStyle(fontSize: 20),),
                      ]),
                      Column(children:[
                        TextField(controller: vaccine4_sec_Controller,
                          decoration: const InputDecoration(hintText: " "),style: TextStyle(fontSize: 20),),
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
                          decoration: const InputDecoration(hintText: " "),style: TextStyle(fontSize: 20),),
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
                      heroTag: 'camera',
                      child: Icon(Icons.add_a_photo),
                      tooltip: 'pick Image',
                      onPressed: ()  {

                        // getImage(ImageSource.camera);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CameraOverlayPregnant()));
                        // print("open camera");

                      },
                    ),
                    FloatingActionButton(
                      heroTag: 'gallery_button',
                      child: Icon(Icons.wallpaper),
                      tooltip: 'pick Iamge',
                      onPressed: () async{

                        ImagePicker picker = ImagePicker();
                        // galleryurl = (await picker.getImage(source: ImageSource.gallery)) as String;
                        //galleryurl = (await ImagePicker().pickImage(source: ImageSource.gallery)) as String;
                        galleryurl = await getImage(ImageSource.gallery);
                        // galleryurl = (await ImagePicker.pickImage(source: ImageSource.gallery)) as String;
                        // print("갤러리 누름");
                        print(galleryurl);
                        // getImage(ImageSource.gallery);


                      },
                    ),
                    FloatingActionButton(
                      heroTag: 'send_button',
                      child: Icon(Icons.arrow_circle_right_sharp),
                      tooltip: 'pick Iamge',
                      onPressed: () async{
                        //_showToast(context);
                        sowID = sowID1_Controller.text + "," + sowID2_Controller.text;
                        ocr_seq = sowID1_Controller.text + "," + sowID2_Controller.text;
                        sow_no = sowID1_Controller.text + "," + sowID2_Controller.text;
                        sow_birth = birth_year_Controller.text +"," + birth_month_Controller.text + "," + birth_day_Controller.text;
                        sow_buy = adoption_year_Controller.text + "," +  adoption_month_Controller.text + "," + adoption_day_Controller.text;
                        sow_estrus = hormone_year_Controller.text + "," + hormone_month_Controller.text + "," + hormone_day_Controller.text;
                        sow_cross =  mate_month_Controller.text + "," +mate_day_Controller.text;
                        boar_fir = boar1ID1_Controller.text + "," + boar1ID2_Controller.text;
                        boar_sec = boar2ID1_Controller.text + ","+boar2ID2_Controller.text;
                        checkdate = check_month_Controller.text + "," + check_day_Controller.text;
                        expectdate = expect_month_Controller.text+ "," + expect_day_Controller.text;
                        vaccine1 = vaccine1_fir_Controller.text + "," + vaccine1_sec_Controller.text;
                        vaccine2 = vaccine2_fir_Controller.text + "," + vaccine2_sec_Controller.text;
                        vaccine3 = vaccine3_fir_Controller.text + "," + vaccine3_sec_Controller.text;
                        vaccine4 = vaccine4_fir_Controller.text + "," + vaccine4_sec_Controller.text;
                        // "ocr_imgpath":'17',
                        memo = memo_Controller.text;


                        sendData(ocr_seq, sow_no, sow_birth, sow_buy, sow_estrus, sow_cross, boar_fir, boar_sec, checkdate, expectdate, vaccine1, vaccine2, vaccine3, vaccine4, memo);

                      },
                    ),
                  ])
            ],
          ),
        )
    );

  }
}

sendData(String? ocr_seq, String? sow_no,String? sow_birth, String? sow_buy, String? sow_estrus, String? sow_cross, String? boar_fir, String? boar_sec,
    String? checkdate, String? expectdate, String? vaccine1, String? vaccine2, String? vaccine3, String? vaccine4, String? memo) async {
  final api ='http://211.107.210.141:3000/api/ocrpregnatUpdate';
  final data = {
    "ocr_seq": ocr_seq,
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
    // "ocr_imgpath":'17',
    "memo":memo,
  };
  final dio = Dio();
  Response response;
  response = await dio.post(api,data: data);
  if(response.statusCode == 200){
    //resultToast('Ocr 임신사 update success... \n\n');
    print('Ocr 임신사 update success... \n\n');
  }
  return 0;
}


// class EmployeeDataSource extends DataGridSource {
//    EmployeeDataSource(List<Employee> employees) {
//    buildDataGridRow(employees);
//    }
//
//    void buildDataGridRow(List<Employee> employeeData) {
//    dataGridRow = employeeData.map<DataGridRow>((employee) {
//    return DataGridRow(cells: [
//    DataGridCell<int>(columnName: 'id', value: employee.id),
//    DataGridCell<String>(columnName: 'name', value: employee.name),
//    DataGridCell<String>(
//    columnName: 'designation', value: employee.designation),
//    const DataGridCell<Widget>(columnName: 'button', value: null),
//    ]);
//    }).toList();
//    }
//
//    List<DataGridRow> dataGridRow = <DataGridRow>[];
//
//    @override
//    List<DataGridRow> get rows => dataGridRow.isEmpty ? [] : dataGridRow;
//
//    @override
//    DataGridRowAdapter? buildRow(DataGridRow row) {
//    return DataGridRowAdapter(
//    cells: row.getCells().map<Widget>((dataGridCell) {
//    return Container(
//    alignment: Alignment.center,
//    child: dataGridCell.columnName == 'button'
//    ? LayoutBuilder(
//    builder: (BuildContext context, BoxConstraints constraints) {
//   return ElevatedButton(
//    onPressed: () {
//    showDialog(
//    context: context,
//   builder: (context) => AlertDialog(
//   content: SizedBox(
//   height: 100,
//   child: Column(
//    mainAxisAlignment:
//    MainAxisAlignment.spaceBetween,
//    children: [
//    Text(
//    'Employee ID: ${row.getCells()[0].value.toString()}'),
//    Text(
//    'Employee Name: ${row.getCells()[1].value.toString()}'),
//    Text(
//    'Employee Designation: ${row.getCells()[2].value.toString()}'),
//    ],
//    ))));
//    },
//    child: const Text('Details'));
//    })
//    : Text(dataGridCell.value.toString()));
//    }).toList());
//    }
// }