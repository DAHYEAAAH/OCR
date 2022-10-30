import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_camera_overlay/flutter_camera_overlay.dart';
import 'package:flutter_camera_overlay/model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:path_provider/path_provider.dart';
import '../functions/functions.dart';
import '../page/maternity_page.dart';
import 'package:gallery_saver/gallery_saver.dart';


main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const CameraOverlayMaternity(),
  );
}

class CameraOverlayMaternity extends StatefulWidget {

  static const routeName = '/camera-overlay-maternity-page';

  const CameraOverlayMaternity({Key? key}) : super(key: key);

  @override
  CameraOverlayMaternityState createState() => CameraOverlayMaternityState();
}

class CameraOverlayMaternityState extends State<CameraOverlayMaternity> {
  OverlayFormat format = OverlayFormat.cardID2;

  // 이미지 편집
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
      setState(() {});
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
                        return Container(
                          child: Stack(
                            children: [
                              Stack(fit: StackFit.expand,children:[
                                Image.file(File(file.path))]),
                              Stack(
                                alignment: Alignment.center,
                                fit: StackFit.loose,
                                children: [
                                  Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        width: width,
                                        height: height,
                                        decoration: ShapeDecoration(
                                            color: Colors.transparent,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.zero,
                                                // borderRadius: BorderRadius.circular(radius),
                                                side: const BorderSide(width: 1, color: Colors.white))),
                                      )
                                  ),
                                  ColorFiltered(
                                    colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcOut),
                                    child: Stack(
                                      children: [
                                        Container(
                                          decoration: const BoxDecoration(
                                            color: Colors.transparent,
                                          ),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Container(
                                              width: width,
                                              height:height,
                                              decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius: BorderRadius.zero),
                                              // borderRadius: BorderRadius.circular(radius)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Material(
                                    color: Colors.transparent,
                                    child: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.black12,
                                          shape: BoxShape.circle,
                                        ),
                                        margin: const EdgeInsets.all(25),
                                        child: IconButton(
                                          enableFeedback: true,
                                          color: Colors.white,
                                          onPressed: () async {
                                            Navigator.of(context).pop();
                                          },
                                          icon: const Icon(
                                            Icons.arrow_back,
                                          ),
                                          iconSize: 30,
                                        ))),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Material(
                                    color: Colors.transparent,
                                    child: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.black12,
                                          shape: BoxShape.circle,
                                        ),
                                        margin: const EdgeInsets.all(25),
                                        child: IconButton(
                                          enableFeedback: true,
                                          color: Colors.white,
                                          onPressed: () async {
                                            showDialog(context: context, builder: (context){
                                              return Container(
                                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                alignment: Alignment.center,
                                                decoration: const BoxDecoration(
                                                  color: Colors.white70,
                                                ),
                                                child: Container(
                                                  // decoration: BoxDecoration(
                                                  //     color: Colors.white,
                                                  //     borderRadius: BorderRadius.circular(10.0)
                                                  // ),
                                                  width: 300.0,
                                                  height: 200.0,
                                                  alignment: AlignmentDirectional.center,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      const Center(
                                                        child: SizedBox(
                                                          height: 50.0,
                                                          width: 50.0,
                                                          child: CircularProgressIndicator( // 로딩화면 애니메이션
                                                            value: null,
                                                            strokeWidth: 7.0,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: const EdgeInsets.only(top: 25.0),
                                                        child: const Center(
                                                          child:
                                                          Text(
                                                            "loading.. wait...",
                                                            style: TextStyle(
                                                                color: Colors.blue
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });
                                            List list = await uploadimg_maternity(File(file.path));
                                            if(list[1].length==0||list[1][0]==""){
                                              print("ocr인식오류");
                                              Navigator.pop(context, 'Yep!');
                                              Navigator.pop(context, 'Yep!');
                                              Fluttertoast.showToast(
                                                  msg: "사진을 다시 찍어주세요",
                                                  toastLength: Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.TOP,
                                                  timeInSecForIosWeb: 1,
                                                  fontSize: 20.0
                                              );
                                            }
                                            else {
                                              // 서버로 임신사 사진 list에 넣어서 보내기
                                              GallerySaver.saveImage(file.path)
                                                  .then((value) => print('>>>> save value= $value'))
                                                  .catchError((err) {
                                                print('error : $err');
                                              });
                                              String returnfilepath = await downloadFile("ocrmatimages/" + list[0]);

                                              Navigator.of(context).popUntil((route) => route.isFirst);
                                              await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                                  MaternityPage(list, returnfilepath)),
                                              );
                                            }
                                          },
                                          icon: const Icon(
                                            Icons.send,
                                          ),
                                          iconSize: 30,
                                        ))),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    info:
                    '박스에 맞춰 사진찍어주세요');
              } else {
                return const Align(
                    alignment: Alignment.center,
                    child: Text(
                      '분만사 카메라',
                      style: TextStyle(color: Colors.black),
                    ));
              }
            },
          ),
        )
    );
  }
}
