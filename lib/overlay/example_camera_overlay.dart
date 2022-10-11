import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_camera_overlay/flutter_camera_overlay.dart';
import 'package:flutter_camera_overlay/model.dart';
import 'package:http_parser/http_parser.dart';
// import 'package:ocr/pages/navigations/camera_page.dart';
// import '../pages/navigations/camera_page.dart';

import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_native_image/flutter_native_image.dart';


late List<String> array = List.filled(35, "",growable: true);
late List<String> array_graph = List.filled(8, "", growable: true);


receiveresult(){
  print(array);
  return array;
}


main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ExampleCameraOverlay(),
  );
}

class ExampleCameraOverlay extends StatefulWidget {

  static const routeName = '/graph-page';

  const ExampleCameraOverlay({Key? key}) : super(key: key);

  @override
  _ExampleCameraOverlayState createState() => _ExampleCameraOverlayState();
}

class _ExampleCameraOverlayState extends State<ExampleCameraOverlay> {
  OverlayFormat format = OverlayFormat.cardID1;
  int tab = 0;

  cropImage(String cameraurl) async {
    File? croppedfile = await ImageCropper().cropImage(
        sourcePath: cameraurl,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Image Cropper',
            toolbarColor: Colors.deepPurpleAccent,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        )
    );

    if (croppedfile != null) {
      // imagefile = croppedfile;
      setState(() { });
    }else{
      print("Image is not cropped.");
    }
    return croppedfile;
  }
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);
    var size = media.size;
    double width = media.orientation == Orientation.portrait
        ? size.shortestSide * .9
        : size.longestSide * .5;

    double height = width * 1.414;

    return MaterialApp(
        home: Scaffold(
          // bottomNavigationBar: BottomNavigationBar(
          //   currentIndex: tab,
          //   onTap: (value) {
          //     setState(() {
          //       tab = value;
          //     });
          //     switch (value) {
          //       case (0):
          //         setState(() {
          //           format = OverlayFormat.cardID1;
          //         });
          //         break;
          //       // case (1):
          //       //   setState(() {
          //       //     format = OverlayFormat.cardID3;
          //       //   });
          //       //   break;
          //       // case (2):
          //       //   setState(() {
          //       //     format = OverlayFormat.simID000;
          //       //   });
          //       //   break;
          //     }
          //   },
          //   items: const [
          //     BottomNavigationBarItem(
          //       icon: Icon(Icons.credit_card),
          //       label: 'Bankcard',
          //     ),
          //     // BottomNavigationBarItem(
          //     //     icon: Icon(Icons.contact_mail), label: 'US ID'),
          //     // BottomNavigationBarItem(icon: Icon(Icons.sim_card), label: 'Sim'),
          //   ],
          // ),
          backgroundColor: Colors.white,
          body: FutureBuilder<List<CameraDescription>?>(
            future: availableCameras(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data == null) {
                  return const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'No camera found',
                        style: TextStyle(color: Colors.black),
                      ));
                }
                return CameraOverlay(
                    snapshot.data!.first,
                    CardOverlay.byFormat(format),
                        (XFile file) => showDialog(
                      context: context,
                      barrierColor: Colors.black,
                      builder: (context) {
                        CardOverlay overlay = CardOverlay.byFormat(format);
                        return AlertDialog(
                            actionsAlignment: MainAxisAlignment.center,
                            backgroundColor: Colors.black,
                            // title: const Text('찰칵',
                            //     style: TextStyle(color: Colors.white),
                            //     textAlign: TextAlign.center),
                            title: Row(
                              children: [
                                OutlinedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                      alignment: Alignment.topLeft,
                                      child: const Icon(Icons.arrow_back_rounded)
                                  ),
                                ),
                                OutlinedButton(
                                  onPressed: () async {

                                    ImageProperties properties = await FlutterNativeImage.getImageProperties(file.path);

                                    final filename = await submit_uploadimg_front(file);

                                    //서버로 사진 전송
                                    final api ='http://211.107.210.141:3000/api/ocrpregnatInsert';
                                    final dio = Dio();
                                    Response response;
                                    response = await dio.post(api, data: file);
                                    if(response.statusCode == 200){
                                      //resultToast('Ocr 임신사 insert success... \n\n');
                                      array = receiveresult();
                                      //_showToast(context);
                                    }

                                    Navigator.of(context).popUntil((route) => route.isFirst);
                                    await Navigator.push(context,MaterialPageRoute(builder: (context) =>
                                        ExampleCameraOverlay()),
                                    );
                                  },
                                  child: Container(
                                      alignment: Alignment.topRight,
                                      child: const Icon(Icons.send)

                                  ),
                                ),
                              ],
                            ),
                            // actions: [
                            //   OutlinedButton(
                            //     // onPressed: () => Navigator.of(context).pop(),
                            //     //
                            //     //     Navigator.pop(context, file.path);
                            //       onPressed: () async {
                            //         final croppedfile = await cropImage(file.path);
                            //         final filename = await submit_uploadimg_front(croppedfile); // 서버에 저장된 이름을 반환해줌 (이름을 알아야 url로 들어가니까)
                            //         print(file.path);
                            //         // final filename = await submit_uploadimg(file.path);
                            //         // print(filename);
                            //
                            //
                            //
                            //
                            //         Navigator.of(context).popUntil((route) => route.isFirst);
                            //         await Navigator.push(context,MaterialPageRoute(builder: (context) =>
                            //             ExampleCameraOverlay()),
                            //         );
                            //
                            //
                            //       },
                            //       child: const Icon(Icons.edit))
                            //
                            // ],
                            content: SizedBox( // 뒤로가기 버튼 만든 그 페이지 사이즈박스
                                width: double.infinity,
                                child: AspectRatio(
                                  // aspectRatio: overlay.ratio!,
                                  aspectRatio: width/height,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.fitWidth,
                                          alignment: FractionalOffset.center,
                                          image: FileImage(
                                            File(file.path),
                                          ),
                                        )),

                                  ),
                                )));
                      },


                    ),
                    info:
                    '박스에 맞춰 사진찍어주세요');
              } else {
                return const Align(
                    alignment: Alignment.center,
                    child: Text(
                      'ㅁㄴㅇㄹㅁㄴㄹㅁㄴㅇ',
                      style: TextStyle(color: Colors.black),
                    ));
              }
            },
          ),
        ));
  }
}

submit_uploadimg_front(dynamic file) async {
  String filename = "no";
  try {
    //print("임신사 이미지 전송 함");
    Response res = await uploadimg_front(file.path);

    switch(res.statusCode){
      case 200:
        final jsonbody = res.data;       // ex) {"result":[335,"1111-11-11","2022_08_10_14_57_16.jpg"]}
        filename = jsonbody['result'][37]; // ex) "2022_08_10_14_57_16.jpg"
        array = jsonbody['result'];
        print("array is ?");
        print(array);
        print("임신사 이미지 전송 함");
        break;
      case 201:
        break;
      case 202:
        break;
      default:
        break;
    }
    return filename;
  } catch (error) {
    print("error");
    return filename;
  }
}

uploadimg_front(String imagePath) async {
  Dio dio = new Dio();
  try {
    dio.options.contentType = 'multipart/form-data';
    dio.options.maxRedirects.isFinite;
    String fileName = imagePath.split('/').last;

    print(fileName);
    FormData _formData = FormData.fromMap({
      "Image" : await MultipartFile.fromFile(imagePath,
          filename: fileName, contentType:MediaType("image","jpg")),
    });
    Response response = await dio.post(
        'http://211.107.210.141:4000/ocrs/uploadimg/front/',
        data:_formData
    );
    print(response);

    final jsonBody = response.data;
    return response;
  } catch (e) {
    Exception(e);
  } finally {
    dio.close();
  }
  // return 0;
}