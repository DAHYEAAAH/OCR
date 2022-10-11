import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:last_ocr/overlay/example_camera_overlay.dart';

class PregnantPage extends StatefulWidget {
  //static const routeName = '/camera-page';
  final String path;
  // const UseCameraPage({Key? key}) : super(key: key);

  const PregnantPage(this.path);

  @override
  PregnantPageState createState() => PregnantPageState();
}

class PregnantPageState extends State<PregnantPage> {
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

  //final List<dynamic> array = [];

  List<dynamic> array = [];

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


  // 이미지를 보여주는 위젯
  Widget showImage() {

    final String cameraurl = 'http://211.107.210.141:4000/images/' + widget.path;
    print(cameraurl);
    // if(widget.path != "no"){
    //   array = receiveresult();
    //   print(array);
    //   modon = array[0];
    // };


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
            child: _image == null //삼항연!산!자!
                ? (widget.path == "no" ? Text('No image selected.') : Image
                .network(cameraurl))
                : galleryurl == '' ? Text('No url selected.') : Image.network(
                'http://211.107.210.141:3001/images/' + galleryurl)));
  }



  final sowID1_Controller = TextEditingController();
  final sowID2_Controller = TextEditingController();
  final sowID3_Controller = TextEditingController();
  final sowID4_Controller = TextEditingController();
  final sowID5_Controller = TextEditingController();
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
  final boar1ID3_Controller = TextEditingController();
  final boar1ID4_Controller = TextEditingController();
  final boar1ID5_Controller = TextEditingController();
  final boar2ID1_Controller = TextEditingController();
  final boar2ID2_Controller = TextEditingController();
  final boar2ID3_Controller = TextEditingController();
  final boar2ID4_Controller = TextEditingController();
  final boar2ID5_Controller = TextEditingController();
  final check_month_Controller = TextEditingController();
  final check_day_Controller = TextEditingController();
  final expect_month_Controller = TextEditingController();
  final expect_day_Controller = TextEditingController();
  final vaccine1_Controller = TextEditingController();
  final vaccine2_Controller = TextEditingController();
  final vaccine3_Controller = TextEditingController();
  final vaccine4_Controller = TextEditingController();
  final memo_Controller = TextEditingController();



  final pxController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    // 화면 세로 고정
    // String test='a';
    // print(test.runtimeType);
    // print('a'.runtimeType);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);


    if(widget.path != "no"){
      array = receiveresult();
      print(array);
      sowID1 = array[0];
      sowID2 = array[1];
      sowID3 = array[2];
      sowID4 = array[3];
      sowID5 = array[4];
      birth_year = array[5];
      birth_month = array[6];
      birth_day = array[7];
      adoption_year = array[8];
      adoption_month = array[9];
      adoption_day = array[10];
      hormone_year = array[11];
      hormone_month = array[12];
      hormone_day = array[13];
      mate_month = array[14];
      mate_day = array[15];
      boar1ID1 = array[16];
      boar1ID2 = array[17];
      boar1ID3 = array[18];
      boar1ID4 = array[19];
      boar1ID5 = array[20];
      boar2ID1 = array[21];
      boar2ID2 = array[22];
      boar2ID3 = array[23];
      boar2ID4 = array[24];
      boar2ID5 = array[25];
      check_month = array[26];
      check_day = array[27];
      expect_month = array[28];
      expect_day = array[29];
      vaccine1 = array[30];
      vaccine2 = array[31];
      vaccine3 = array[32];
      vaccine4 = array[33];
      memo = array[34];

    }else{
      array = [];
    };

    return SingleChildScrollView(
      // backgroundColor: const Color(0xfff4f3f9),
      scrollDirection: Axis.vertical,

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 30.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                child: Table(
                  defaultColumnWidth: FixedColumnWidth(45.7142857),
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle, // 표 가운데 정렬
                  border: TableBorder(
                    // color: Colors.white,
                    // style: BorderStyle.solid,
                    // width: 2
                      verticalInside: BorderSide(width: 1.0, color: Colors.black, style: BorderStyle.solid),
                      top: BorderSide(color: Colors.black, width: 1),
                      left: BorderSide(color: Colors.black, width: 1),
                      right: BorderSide(color: Colors.black, width: 1)
                  ),
                  children: [
                    TableRow(children: [
                      Column(children: [Text('모돈번호',
                          style: TextStyle(fontSize: 20.0))
                      ]),
                      Column(children: [TextField(controller: sowID1_Controller,
                        decoration: const InputDecoration(hintText: " "),)
                      ]),
                      Column(children: [TextField(controller: sowID2_Controller,
                        decoration: const InputDecoration(hintText: " "),)
                      ]),
                      Column(children: [TextField(controller: sowID3_Controller,
                        decoration: const InputDecoration(hintText: " "),)
                      ]),
                      Column(children: [TextField(controller: sowID4_Controller,
                        decoration: const InputDecoration(hintText: " "),)
                      ]),
                      Column(children: [Text('-',
                          style: TextStyle(fontSize: 20.0))
                      ]),
                      Column(children: [TextField(controller: sowID5_Controller,
                        decoration: const InputDecoration(hintText: " "),)
                      ]),
                    ]),
                  ],
                ),
              ),
            ],

          ),
          Row(
            // margin: EdgeInsets.all(10),
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                child: Table(
                  defaultColumnWidth: FixedColumnWidth(45.7142857),
                  border: TableBorder.all(
                      color: Colors.black,
                      style: BorderStyle.solid,
                      width: 1.3),
                  children: [
                    TableRow(children: [
                      Column(children: [Text('출생일')
                      ]),
                      Column(children: [TextField(controller: birth_year_Controller,
                        decoration: const InputDecoration(hintText: " "),)
                      ]),
                      Column(children: [Text('년')
                      ]),
                      Column(children: [TextField(controller: birth_month_Controller,
                        decoration: const InputDecoration(hintText: " "),)
                      ]),
                      Column(children: [Text('월')
                      ]),
                      Column(children: [TextField(controller: birth_day_Controller,
                        decoration: const InputDecoration(hintText: " "),)
                      ]),
                      Column(children: [Text('일')
                      ]),
                    ],
                    ),
                    TableRow(children: [
                      Column(children: [Text('구입일')
                      ]),
                      Column(children: [TextField(controller: adoption_year_Controller,
                        decoration: const InputDecoration(hintText: " "),)
                      ]),
                      Column(children: [Text('년')
                      ]),
                      Column(children: [TextField(controller: adoption_month_Controller,
                        decoration: const InputDecoration(hintText: " "),)
                      ]),
                      Column(children: [Text('월')
                      ]),
                      Column(children: [TextField(controller: adoption_day_Controller,
                        decoration: const InputDecoration(hintText: " "),)
                      ]),
                      Column(children: [Text('일')
                      ]),
                    ],
                    ),
                    TableRow(children: [
                      Column(children: [Text('초발정일')
                      ]),
                      Column(children: [TextField(controller: hormone_year_Controller,
                        decoration: const InputDecoration(hintText: " "),)
                      ]),
                      Column(children: [Text('년')
                      ]),
                      Column(children: [TextField(controller: hormone_month_Controller,
                        decoration: const InputDecoration(hintText: " "),)
                      ]),
                      Column(children: [Text('월')
                      ]),
                      Column(children: [TextField(controller: hormone_day_Controller,
                        decoration: const InputDecoration(hintText: " "),)
                      ]),
                      Column(children: [Text('일')
                      ]),
                    ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                child: Table(
                  defaultColumnWidth: FixedColumnWidth(64),
                  border: TableBorder.all(
                      color: Colors.black,
                      style: BorderStyle.solid,
                      width: 1.3),
                  children: [
                    TableRow(children: [
                      Column(children: [Text('교배일')
                      ]),
                      Column(children: [TextField(controller: mate_month_Controller,
                        decoration: const InputDecoration(hintText: " "),)
                      ]),
                      Column(children: [Text('월')
                      ]),
                      Column(children: [TextField(controller: mate_day_Controller,
                        decoration: const InputDecoration(hintText: " "),)
                      ]),
                      Column(children: [Text('일')
                      ]),
                    ],
                    ),
                  ],
                ),
              )
            ],
          ),
          Row(
            // margin: EdgeInsets.all(10),
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                child: Table(
                  defaultColumnWidth: FixedColumnWidth(45.7142857),
                  border: TableBorder.all(
                      color: Colors.black,
                      style: BorderStyle.solid,
                      width: 1.3),
                  children: [
                    TableRow(children: [
                      Column(children: [Text('1차웅돈번호')
                      ]),
                      Column(children: [TextField(controller: boar1ID1_Controller,
                        decoration: const InputDecoration(hintText: " "),)
                      ]),
                      Column(children: [TextField(controller: boar1ID2_Controller,
                        decoration: const InputDecoration(hintText: " "),)
                      ]),
                      Column(children: [TextField(controller: boar1ID3_Controller,
                        decoration: const InputDecoration(hintText: " "),)
                      ]),
                      Column(children: [TextField(controller: boar1ID4_Controller,
                        decoration: const InputDecoration(hintText: " "),)
                      ]),
                      Column(children: [Text('-')
                      ]),
                      Column(children: [TextField(controller: boar1ID5_Controller,
                        decoration: const InputDecoration(hintText: " "),)
                      ]),
                    ],
                    ),
                    TableRow(children: [
                      Column(children: [Text('2차웅돈번호')
                      ]),
                      Column(children: [TextField(controller: boar2ID1_Controller,
                        decoration: const InputDecoration(hintText: " "),)
                      ]),
                      Column(children: [TextField(controller: boar2ID2_Controller,
                        decoration: const InputDecoration(hintText: " "),)
                      ]),Column(children: [TextField(controller: boar2ID3_Controller,
                        decoration: const InputDecoration(hintText: " "),)
                      ]),
                      Column(children: [TextField(controller: boar2ID4_Controller,
                        decoration: const InputDecoration(hintText: " "),)
                      ]),
                      Column(children: [Text('-')
                      ]),
                      Column(children: [TextField(controller: boar2ID5_Controller,
                        decoration: const InputDecoration(hintText: " "),)
                      ]),
                    ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                child: Table(
                  defaultColumnWidth: FixedColumnWidth(64),
                  border: TableBorder.all(
                      color: Colors.black,
                      style: BorderStyle.solid,
                      width: 1.3),
                  children: [
                    TableRow(children: [
                      Column(children: [Text('재발확인일')
                      ]),
                      Column(children: [TextField(controller: check_month_Controller,
                        decoration: const InputDecoration(hintText: " "),)
                      ]),
                      Column(children: [Text('월')
                      ]),
                      Column(children: [TextField(controller: check_day_Controller,
                        decoration: const InputDecoration(hintText: " "),)
                      ]),
                      Column(children: [Text('일')
                      ]),
                    ],
                    ),
                    TableRow(children: [
                      Column(children: [Text('분만예정일')
                      ]),
                      Column(children: [TextField(controller: expect_month_Controller,
                        decoration: const InputDecoration(hintText: " "),)
                      ]),
                      Column(children: [Text('월')
                      ]),
                      Column(children: [TextField(controller: expect_day_Controller,
                        decoration: const InputDecoration(hintText: " "),)
                      ]),
                      Column(children: [Text('일')
                      ]),
                    ],
                    ),
                  ],
                ),
              )
            ],
          ),//여기임
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                child: Table(
                  defaultColumnWidth: FixedColumnWidth(80),
                  border: TableBorder.all(
                      color: Colors.black,
                      style: BorderStyle.solid,
                      width: 1.3),
                  children: [
                    TableRow(children: [
                      Column(children: [Text('백신1')
                      ]),
                      Column(children: [TextField(controller: vaccine1_Controller,
                        decoration: const InputDecoration(hintText: " "),)
                      ]),
                      Column(children: [Text('백신2')
                      ]),
                      Column(children: [TextField(controller: vaccine2_Controller,
                        decoration: const InputDecoration(hintText: " "),)
                      ]),
                    ])
                  ],
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                child: Table(
                  defaultColumnWidth: FixedColumnWidth(80),
                  border: TableBorder.all(
                      color: Colors.black,
                      style: BorderStyle.solid,
                      width: 1.3),
                  children: [
                    TableRow(children: [
                      Column(children: [Text('백신3')
                      ]),
                      Column(children: [TextField(controller: vaccine3_Controller,
                        decoration: const InputDecoration(hintText: " "),)
                      ]),
                      Column(children: [Text('백신4')
                      ]),
                      Column(children: [TextField(controller: vaccine4_Controller,
                        decoration: const InputDecoration(hintText: " "),)
                      ]),
                    ])
                  ],
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                child: Table(
                  defaultColumnWidth: FixedColumnWidth(160),
                  border: TableBorder.all(
                      color: Colors.black,
                      style: BorderStyle.solid,
                      width: 1.3),
                  children: [
                    TableRow(children: [
                      Column(children: [Text('특이사항')
                      ]),
                      Column(children: [TextField(controller: memo_Controller,
                        decoration: const InputDecoration(hintText: " "),)
                      ]),
                    ])
                  ],
                ),
              )
            ],
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ExampleCameraOverlay()));
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
                    sowID = sowID1_Controller.text + "," + sowID2_Controller.text+ "," + sowID3_Controller.text+ "," + sowID4_Controller.text+ "," + sowID5_Controller.text;
                    ocr_seq = sowID1_Controller.text + "," + sowID2_Controller.text+ "," + sowID3_Controller.text+ "," + sowID4_Controller.text+ "," + sowID5_Controller.text;
                    sow_no = sowID1_Controller.text + "," + sowID2_Controller.text+ "," + sowID3_Controller.text+ "," + sowID4_Controller.text+ "," + sowID5_Controller.text;
                    sow_birth = birth_year_Controller.text +"," + birth_month_Controller.text + "," + birth_day_Controller.text;
                    sow_buy = adoption_year_Controller.text + "," +  adoption_month_Controller.text + "," + adoption_day_Controller.text;
                    sow_estrus = hormone_year_Controller.text + "," + hormone_month_Controller.text + "," + hormone_day_Controller.text;
                    sow_cross =  mate_month_Controller.text + "," +mate_day_Controller.text;
                    boar_fir = boar1ID1_Controller.text + "," + boar1ID2_Controller.text + "," + boar1ID3_Controller.text + ","+ boar1ID4_Controller.text + ","+ boar1ID5_Controller.text;
                    boar_sec = boar2ID1_Controller.text + ","+boar2ID2_Controller.text+ ","+boar2ID3_Controller.text+ ","+boar2ID4_Controller.text+ ","+boar2ID5_Controller.text;
                    checkdate = check_month_Controller.text + "," + check_day_Controller.text;
                    expectdate = expect_month_Controller.text+ "," + expect_day_Controller.text;
                    vaccine1 = vaccine1_Controller.text;
                    vaccine2 = vaccine2_Controller.text;
                    vaccine3 = vaccine3_Controller.text;
                    vaccine4 = vaccine4_Controller.text;
                    // "ocr_imgpath":'17',
                    memo = memo_Controller.text;


                    sendData(ocr_seq, sow_no, sow_birth, sow_buy, sow_estrus, sow_cross, boar_fir, boar_sec, checkdate, expectdate, vaccine1, vaccine2, vaccine3, vaccine4, memo);

                    //서버로 사진 전송
                    // final api ='http://211.107.210.141:3000/api/ocrpregnatInsert';
                    // final dio = Dio();
                    // Response response;
                    // response = await dio.post(api);
                    // if(response.statusCode == 200){
                    //   //resultToast('Ocr 임신사 insert success... \n\n');
                    //   array = receiveresult();
                    //   _showToast(context);
                    // }
                    // getImage(ImageSource.gallery);
                  },
                ),
              ])

        ],
      ),
    );

  }

  void _showToast(BuildContext context) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Ocr 임신사 insert success... \n\n'),
        action: SnackBarAction(
            label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

}

sendData(String? ocr_seq, String? sow_no,String? sow_birth, String? sow_buy, String? sow_estrus, String? sow_cross, String? boar_fir, String? boar_sec,
String? checkdate, String? expectdate, String? vaccine1, String? vaccine2, String? vaccine3, String? vaccine4, String? memo) async {
  final api ='http://211.107.210.141:3000/api/ocrpregnatUpdate';
  final data = {
    "ocr_seq":'2',
    "sow_no":'2',
    "sow_birth":'5',
    "sow_buy":'6',
    "sow_estrus":'7',
    "sow_cross":'8',
    "boar_fir":'9',
    "boar_sec":'10',
    "checkdate":'11',
    "expectdate":'12',
    "vaccine1":'13',
    "vaccine2":'14',
    "vaccine3":'15',
    "vaccine4":'16',
    // "ocr_imgpath":'17',
    "memo":'18',
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