import 'package:flutter/material.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:last_ocr/overlay/camera_overlay_maternity.dart';


class MaternityPage extends StatefulWidget{
  static const routeName = '/OcrPregnantPage';

  const MaternityPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  MaternityPageState createState() => MaternityPageState();
}

class MaternityPageState extends State<MaternityPage>{

  File? _image;
  final picker = ImagePicker();

  late String sow_no='';
  late String sow_birth='';
  late String sow_buy='';
  late String sow_expectdate='';
  late String sow_givebirth='';
  late String  sow_totalbaby='';
  late String sow_feedbaby='';
  late String sow_babyweight='';
  late String sow_sevrerdate='';
  late String sow_sevrerqty='';
  late String sow_sevrerweight='';
  late String vaccine1 ='';
  late String vaccine2 ='';
  late String vaccine3 ='';
  late String vaccine4 ='';

  late String memo = '';

  late String lastresult ='';
  late String modon = '';
  late String title = '';

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

    final temp = await submit_uploadimg_back(image);
    print("aaaa");
    print(temp);

    setState((){
      _image = File(image!.path); // 가져온 이미지를 _image에 저장
    });
    return temp;
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
    return Scaffold(
        appBar: AppBar(
          title: Text("분만사"),
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
                      Text('분만예정일')
                    ]),
                    Column(children:[
                      TextField(controller: expect_year_Controller,
                        decoration: const InputDecoration(hintText: " "),style: TextStyle(fontSize: 20),),
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
                          decoration: const InputDecoration(hintText: " "),style: TextStyle(fontSize: 20),),
                      ]),
                      Column(children:[
                        TextField(controller: givebirth_day_Controller,
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
                        Text('총산자수', textAlign: TextAlign.center)
                      ]),
                      Column(children:[
                        TextField(controller: totalbaby_Controller,
                          decoration: const InputDecoration(hintText: " "),style: TextStyle(fontSize: 20),),
                      ]),
                      Column(children:[
                        Text('포유개시두수', textAlign: TextAlign.center)
                      ]),
                      Column(children:[
                        TextField(controller: feedbaby_Controller,
                          decoration: const InputDecoration(hintText: " "),style: TextStyle(fontSize: 20),),
                      ]),
                      Column(children:[
                        Text('생시체중(kg)', textAlign: TextAlign.center)
                      ]),
                      Column(children:[
                        TextField(controller: weight_Controller,
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
                        Text('이유일', textAlign: TextAlign.center)
                      ]),
                      Column(children:[
                        TextField(controller:  teen_month_Controller,
                          decoration: const InputDecoration(hintText: " "),style: TextStyle(fontSize: 20),),
                      ]),
                      Column(children:[
                        TextField(controller: teen_day_Controller,
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
                        Text('이유두수', textAlign: TextAlign.center)
                      ]),
                      Column(children:[
                        TextField(controller: totalteen_Controller,
                          decoration: const InputDecoration(hintText: " "),style: TextStyle(fontSize: 20),),
                      ]),
                      Column(children:[
                        Text('이유체중(kg)', textAlign: TextAlign.center)
                      ]),
                      Column(children:[
                        TextField(controller: teenweight_Controller,
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CameraOverlayMaternity()));
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
                        //ocr_seq = sowID1_Controller.text + "," + sowID1_Controller.text;
                        //sowID = sowID1_Controller.text + "," + sowID2_Controller.text;
                        //ocr_seq = sowID1_Controller.text + "," + sowID2_Controller.text;
                        sow_no = sowID1_Controller.text + "," + sowID2_Controller.text;
                        sow_birth = birth_year_Controller.text +"," + birth_month_Controller.text + "," + birth_day_Controller.text;
                        sow_buy = adoption_year_Controller.text + "," +  adoption_month_Controller.text + "," + adoption_day_Controller.text;
                        sow_expectdate = expect_year_Controller.text + "," + expect_month_Controller.text + "," + expect_day_Controller.text;
                        sow_givebirth = givebirth_month_Controller.text + "," + givebirth_day_Controller.text;
                        sow_totalbaby = totalbaby_Controller.text;
                        sow_feedbaby = feedbaby_Controller.text;
                        sow_babyweight = weight_Controller.text; //생시체중
                        sow_sevrerdate = teen_month_Controller.text + teen_day_Controller.text;//이유일
                        sow_sevrerqty   = totalteen_Controller.text;//이유두수
                        sow_sevrerweight = teenweight_Controller.text;//이유체중
                        vaccine1 = vaccine1_fir_Controller.text + "," + vaccine1_sec_Controller.text;
                        vaccine2 = vaccine2_fir_Controller.text + "," + vaccine2_sec_Controller.text;
                        vaccine3 = vaccine3_fir_Controller.text + "," + vaccine3_sec_Controller.text;
                        vaccine4 = vaccine4_fir_Controller.text + "," + vaccine4_sec_Controller.text;
                        // "ocr_imgpath":'17',
                        memo = memo_Controller.text;


                        sendData(sow_no, sow_birth, sow_buy, sow_expectdate, sow_givebirth, sow_totalbaby, sow_feedbaby,
                          sow_babyweight, sow_sevrerdate, sow_sevrerqty, sow_sevrerweight,  vaccine1,  vaccine2,
                             vaccine3,  vaccine4,  memo);

                      },
                    ),
                  ])
            ],
          ),
        )
    );

  }
}

sendData(String? sow_no, String? sow_birth, String? sow_buy, String? sow_expectdate, String? sow_givebirth, String? sow_totalbaby, String? sow_feedbaby,
    String? sow_babyweight, String? sow_sevrerdate, String? sow_sevrerqty, String? sow_sevrerweight,  String? vaccine1, String? vaccine2,
    String? vaccine3, String? vaccine4, String? memo) async {
  final api ='http://211.107.210.141:3000/api/ocrmaternityUpdate';
  final data = {
  "sow_no": sow_no,
  "sow_birth": sow_birth,
  "sow_buy":sow_buy,
  "sow_expectdate":sow_expectdate,
  "sow_givebirth":sow_givebirth,
  "sow_totalbaby":sow_totalbaby,
  "sow_feedbaby":sow_feedbaby,
  "sow_babyweight":sow_babyweight,
  "sow_sevrerdate":sow_sevrerdate, //이유두수
  "sow_sevrerqty":sow_sevrerqty, //이유날
  "sow_sevrerweight":sow_sevrerweight, //이유체중
  "vaccine1": vaccine1,
  "vaccine2": vaccine2,
  "vaccine3": vaccine3,
  "vaccine4":vaccine4,
  // "ocr_imgpath":'14',
  "memo": memo,};
  final dio = Dio();
  Response response;
  response = await dio.post(api,data: data);
  if(response.statusCode == 200){
    //resultToast('Ocr 분만사 update success... \n\n');
  }
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