import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:last_ocr/overlay/example_camera_overlay.dart';
import 'package:last_ocr/overlay/example_camera_overlay_back.dart';


late List<String> array = List.filled(35, "",growable: true);
late List<String> array_graph = List.filled(8, "", growable: true);


receiveresult(){
  print(array);
  return array;
}

class MaternityPage extends StatefulWidget {
  //static const routeName = '/camera-page';
  final String path;
  // const UseCameraPage({Key? key}) : super(key: key);

  const MaternityPage(this.path);

  @override
  MaternityPageState createState() => MaternityPageState();
}

class F {
  final double x;
  final double px;
  final double multiply;
  F({
    required this.x,
    required this.px,
  }) : multiply = x * px;
}

class MaternityPageState extends State<MaternityPage> {
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

  late String expect_month ='';
  late String expect_day ='';

  late String givebirth_month ='';
  late String givebirth_day ='';

  late String totalbaby ='';
  late String feedbaby ='';
  late String weight ='';

  late String teen_month ='';
  late String teen_day ='';

  late String totalteen ='';
  late String teenweight ='';

  late String vaccine1 ='';
  late String vaccine2 ='';
  late String vaccine3 ='';
  late String vaccine4 ='';

  late String memo = '';

  late String lastresult ='';
  late String modon = '';
  late String title = '';

  String galleryurl = '';

  // final List<dynamic> array = [];
  List<dynamic> array = [];

  //late final String pig_num = "ㄴㅁㅇㅁㄹ";
  //late final String birth_year, birth_month, birth_day, buy_year, buy_month, buy_day, rutting_year, rutting_month, rutting_day, et_ruting_date, delivery_date,
  //baby_meal_day,male_pig_num, baby_num_born, baby_num_survive, rutting_second, survive_baby_num, teenager_weight, estimated_delivery_date, baby_weight, memo;
  // 비동기 처리를 통해 카메라와 갤러리에서 이미지를 가져온다.
  Future getImage2(ImageSource imageSource) async {
    final image = await picker.pickImage(source: imageSource);

    final temp = await submit_uploadimg_back(image);
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
                'http://211.107.210.141:4000/images/' + galleryurl)));
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
  final expect_month_Controller = TextEditingController();
  final expect_day_Controller = TextEditingController();
  final givebirth_month_Controller = TextEditingController();
  final givebirth_day_Controller = TextEditingController();
  final totalbaby_Controller = TextEditingController();
  final feedbaby_Controller = TextEditingController();
  final weight_Controller = TextEditingController();
  final teen_month_Controller = TextEditingController();
  final teen_day_Controller = TextEditingController();
  final totalteen_Controller = TextEditingController();
  final teenweight_Controller = TextEditingController();


  final vaccine1_Controller = TextEditingController();
  final vaccine2_Controller = TextEditingController();
  final vaccine3_Controller = TextEditingController();
  final vaccine4_Controller = TextEditingController();
  final memo_Controller = TextEditingController();


  @override
  Widget build(BuildContext context) {
    // 화면 세로 고정
    // String test='a';
    // print(test.runtimeType);
    // print('a'.runtimeType);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    array = receiveresult() ;
    //array=['1','2','3'];
    print(array);
    print(array.length);

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

    expect_month = array[11];
    expect_day = array[12];

    givebirth_month = array[13];
    givebirth_day = array[14];

    totalbaby = array[15];
    feedbaby = array[16];
    weight = array[17];

    teen_month = array[18];
    teen_day = array[19];

    totalteen = array[20];
    teenweight = array[21];

    vaccine1 = array[22];
    vaccine2 = array[23];
    vaccine3 = array[24];
    vaccine4 = array[25];

    memo = array[26];

    // if(widget.path != "no"){
    //   array = receiveresult() ;
    //   //array=['1','2','3'];
    //   print(array);
    //   print(array.length);
    //
    //   sowID1 = array[0];
    //   sowID2 = array[1];
    //   sowID3 = array[2];
    //   sowID4 = array[3];
    //   sowID5 = array[4];
    //
    //   birth_year = array[5];
    //   birth_month = array[6];
    //   birth_day = array[7];
    //
    //   adoption_year = array[8];
    //   adoption_month = array[9];
    //   adoption_day = array[10];
    //
    //   expect_month = array[11];
    //   expect_day = array[12];
    //
    //   givebirth_month = array[13];
    //   givebirth_day = array[14];
    //
    //   totalbaby = array[15];
    //   feedbaby = array[16];
    //   weight = array[17];
    //
    //   teen_month = array[18];
    //   teen_day = array[19];
    //
    //   totalteen = array[20];
    //   teenweight = array[21];
    //
    //   vaccine1 = array[22];
    //   vaccine2 = array[23];
    //   vaccine3 = array[24];
    //   vaccine4 = array[25];
    //
    //   memo = array[26];
    //
    //
    // }else{
    //   array = [];
    // };

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
                    TableRow(children: [
                      Column(children: [Text('분만일')
                      ]),
                      Column(children: [TextField(controller: givebirth_month_Controller,
                        decoration: const InputDecoration(hintText: " "),)
                      ]),
                      Column(children: [Text('월')
                      ]),
                      Column(children: [TextField(controller: givebirth_day_Controller,
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                child: Table(
                  defaultColumnWidth: FixedColumnWidth(53.333334),
                  border: TableBorder.all(
                      color: Colors.black,
                      style: BorderStyle.solid,
                      width: 1.3),
                  children: [
                    TableRow(children: [
                      Column(children: [Text('총산자수')
                      ]),
                      Column(children: [TextField(controller: totalbaby_Controller,
                        decoration: const InputDecoration(hintText: " "),)
                      ]),
                      Column(children: [Text('포유개시두수')
                      ]),
                      Column(children: [TextField(controller: feedbaby_Controller,
                        decoration: const InputDecoration(hintText: " "),)
                      ]),
                      Column(children: [Text('생시체중')
                      ]),
                      Column(children: [TextField(controller: weight_Controller,
                        decoration: const InputDecoration(hintText: " "),)
                      ]),
                    ],
                    ),
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
                  defaultColumnWidth: FixedColumnWidth(64),
                  border: TableBorder.all(
                      color: Colors.black,
                      style: BorderStyle.solid,
                      width: 1.3),
                  children: [
                    TableRow(children: [
                      Column(children: [Text('이유일')
                      ]),
                      Column(children: [TextField(controller: teen_month_Controller,
                        decoration: const InputDecoration(hintText: " "),)
                      ]),
                      Column(children: [Text('월')
                      ]),
                      Column(children: [TextField(controller: teen_day_Controller,
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
                      Column(children: [Text('이유두수')
                      ]),
                      Column(children: [TextField(controller: totalteen_Controller,
                        decoration: const InputDecoration(hintText: " "),)
                      ]),
                      Column(children: [Text('이유체중')
                      ]),
                      Column(children: [TextField(controller: teenweight_Controller,
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
                    //galleryurl = await getImage2(ImageSource.gallery);
                    galleryurl = await getImage2(ImageSource.gallery);
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
                    lastresult = sowID1_Controller.text + "," + sowID1_Controller.text + "," + sowID2_Controller.text + ","+ sowID3_Controller.text + ","+ sowID4_Controller.text + ","
                        + sowID5_Controller.text + ","+ birth_year_Controller.text + "," + birth_month_Controller.text + "," +birth_day_Controller.text+ "," + adoption_year_Controller.text + "," + adoption_month_Controller.text
                        + "," + adoption_day_Controller.text + "," + expect_month_Controller.text + "," + expect_day_Controller.text
                        + "," + givebirth_month_Controller.text + "," +givebirth_day_Controller.text + "," + totalbaby_Controller.text
                        + "," + feedbaby_Controller.text+ "," +weight_Controller.text+ "," +teen_month_Controller.text+ "," + teen_day_Controller.text
                        + "," + totalteen_Controller.text + "," + teenweight_Controller.text + "," +vaccine1_Controller.text + "," + vaccine2_Controller.text
                        + "," + vaccine3_Controller.text + "," + vaccine4_Controller.text+ "," + memo_Controller.text;
                    // sowID = '';
                    modon = sowID1_Controller.text + "," + sowID1_Controller.text + "," + sowID2_Controller.text + ","+ sowID3_Controller.text + ","+ sowID4_Controller.text + "," + sowID5_Controller.text;
                    print(sowID1_Controller.text);
                    // getImage(ImageSource.gallery);
                    sendData(modon, lastresult);

                  },
                ),
              ])

        ],
      ),
    );

  }
}
sendData(String? modon, String? lastresult) async {
  Dio dio = new Dio();
  try {

    Response response = await dio.post(
        'http://211.107.210.141:4000/ocrs/uploadimg/back',
        data: {
          'modon' : modon,
          'lastresult' : lastresult
        }
    );
    final jsonBody = response.data;
    return response.statusCode;
  } catch (e) {
    Exception(e);
  } finally {
    dio.close();
  }
  return 0;
}
