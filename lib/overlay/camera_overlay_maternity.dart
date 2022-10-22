import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_camera_overlay/flutter_camera_overlay.dart';
import 'package:flutter_camera_overlay/model.dart';
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

  static const routeName = '/graph-page';

  const CameraOverlayMaternity({Key? key}) : super(key: key);

  @override
  CameraOverlayMaternityState createState() => CameraOverlayMaternityState();
}

class CameraOverlayMaternityState extends State<CameraOverlayMaternity> {
  OverlayFormat format = OverlayFormat.cardID1;

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
                            title: Row(
                              children: [
                                OutlinedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                      alignment: Alignment.topLeft,
                                      child: const Icon(Icons.arrow_back_rounded,color: Colors.white,)
                                  ),
                                ),
                                OutlinedButton(
                                  onPressed: () async {
                                    showDialog(context: context, builder: (context){
                                      return Container(
                                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        alignment: Alignment.center,
                                        decoration: const BoxDecoration(
                                          color: Colors.white70,
                                          backgroundBlendMode: BlendMode.darken
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(10.0)
                                          ),
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
                                                  child: CircularProgressIndicator(
                                                    value: null,
                                                    strokeWidth: 7.0,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(top: 25.0),
                                                child: const Center(
                                                  child: Text(
                                                    "loading.. wait...",
                                                    style: TextStyle(
                                                        color: Colors.black
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

                                    GallerySaver.saveImage(file.path)
                                        .then((value) => print('>>>> save value= $value'))
                                        .catchError((err) {print('error : $err');
                                    });

                                    String returnfilepath = await downloadFile("ocrmatimages/" + list[0]);

                                    Navigator.of(context).popUntil((route) => route.isFirst);
                                    await Navigator.push(context,MaterialPageRoute(builder: (context) =>
                                        MaternityPage(list, returnfilepath)),
                                    );
                                  },
                                  child: Container(
                                      alignment: Alignment.topRight,
                                      child: const Icon(Icons.send, color: Colors.white,)
                                  ),
                                ),
                              ],
                            ),
                            actions: [
                              OutlinedButton(
                                  onPressed: () async {
                                    final croppedfile = await cropImage(file.path);
                                    List list = await uploadimg_maternity(File(croppedfile.path));

                                    GallerySaver.saveImage(croppedfile.path)
                                        .then((value) => print('>>>> save value= $value'))
                                        .catchError((err) {
                                      print('error : $err');
                                    });
                                    String returnfilepath = await downloadFile("ocrmatimages/" + list[0]);

                                    Navigator.of(context).popUntil((route) => route.isFirst);
                                    await Navigator.push(context,MaterialPageRoute(builder: (context) =>
                                        MaternityPage(list, returnfilepath)),
                                    );
                                  },
                                  child: const Icon(Icons.edit, color: Colors.white,))
                            ],
                            content: SizedBox( // 뒤로가기 버튼 만든 그 페이지 사이즈박스
                                width: double.infinity,
                                child: AspectRatio(
                                  // aspectRatio: overlay.ratio!,
                                  aspectRatio: width/height,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.fill,
                                          alignment: FractionalOffset.center,
                                          image: FileImage(File(file.path),
                                          )))))
                            )
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
