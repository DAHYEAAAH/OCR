import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_camera_overlay/flutter_camera_overlay.dart';
import 'package:flutter_camera_overlay/model.dart';
import 'package:image_cropper/image_cropper.dart';
import '../functions/functions.dart';
import '../page/pregnant_page.dart';
import 'package:gallery_saver/gallery_saver.dart';


main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const CameraOverlayPregnant(),
  );
}

class CameraOverlayPregnant extends StatefulWidget {

  static const routeName = '/graph-page';

  const CameraOverlayPregnant({Key? key}) : super(key: key);

  @override
  CameraOverlayPregnantState createState() => CameraOverlayPregnantState();
}

class CameraOverlayPregnantState extends State<CameraOverlayPregnant> {
  // camera overlay에서 cardID2라는 카메라를 사용
  OverlayFormat format = OverlayFormat.cardID2;

  cropImage(String cameraurl) async {
    File? croppedfile = await ImageCropper().cropImage(
        sourcePath: cameraurl,

        // cropImage 비율 정의
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        // cropImage ui 정의
        androidUiSettings: const AndroidUiSettings(
            toolbarTitle: 'Image Cropper',
            toolbarColor: Colors.deepPurpleAccent,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: const IOSUiSettings(
          minimumAspectRatio: 1.0,
        )
    );
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
                // 카메라가 없는 경우
                if (snapshot.data == null) {
                  return const Align(
                    alignment: Alignment.center,
                    child: Text(
                      'No camera found',
                      style: TextStyle(color: Colors.black),
                    ));
                }
                return CameraOverlay(
                    // 카메라 화면
                    snapshot.data!.first,
                    CardOverlay.byFormat(format),
                        (XFile file) => showDialog(
                      context: context,
                      barrierColor: Colors.black,
                      builder: (context) {
                        return AlertDialog(
                            actionsAlignment: MainAxisAlignment.center,
                            backgroundColor: Colors.black,
                            title: Row(
                              children: [
                                // 뒤로가기 버튼
                                OutlinedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                      alignment: Alignment.topLeft,
                                      child: const Icon(Icons.arrow_back_rounded, color: Colors.white,)
                                  ),
                                ),
                                OutlinedButton(
                                  onPressed: () async {
                                    //로딩화면 알죠?
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
                                    // 서버로 임신사 사진 list에 넣어서 보내기
                                    List list = await uploadimg_pregnant(File(file.path));

                                    // 찍은 사진 갤러리에 저장
                                    GallerySaver.saveImage(file.path)
                                        .then((value) => print('>>>> save value= $value'))
                                        .catchError((err) {print('error : $err');
                                    });

                                    // 서버에서 받은 사진 returnfilepath라는 이름으로 저장
                                    String returnfilepath = await downloadFile("ocrpreimages/" + list[0]);

                                    Navigator.of(context).popUntil((route) => route.isFirst); // 처음 화면으로 돌아가기
                                    await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                          PregnantPage(list, returnfilepath)), // PregnantPage 넘어가기
                                    );
                                  },
                                  child: Container( // 전송버튼
                                      alignment: Alignment.topRight,
                                      child: Icon(Icons.send, color: Colors.white,)
                                  ),
                                ),
                              ],
                            ),
                            actions:[
                              OutlinedButton(
                                  onPressed: () async {
                                    // 수동으로 자른 사진 croppedfile로 저장
                                    final croppedfile = await cropImage(file.path);
                                    showDialog(context: context, builder: (context){
                                      return Container(
                                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(color: Colors.white,),
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
                                                      color: Colors.blue,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                                    // 서버로 수동으로 자른 임신사 사진 list에 넣어서 보내기
                                    List list = await uploadimg_pregnant(File(croppedfile.path));

                                    // 찍고 수동으로 자른 사진 갤러리에 저장
                                    GallerySaver.saveImage(croppedfile.path)
                                        .then((value) => print('>>>> save value= $value'))
                                        .catchError((err) {print('error : $err');
                                    });

                                    // 서버에서 받은 사진 returnfilepath라는 이름으로 저장
                                    String returnfilepath = await downloadFile("ocrpreimages/" + list[0]); // 처음 화면으로 돌아가기

                                    Navigator.of(context).popUntil((route) => route.isFirst);
                                    await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                          PregnantPage(list, returnfilepath)), // PregnantPage 넘어가기
                                    );
                                  },
                                  child: const Icon(Icons.edit, color: Colors.white,))
                            ],
                            // 사진 미리보기
                            content:SizedBox(
                                width: double.infinity,
                                child: AspectRatio(
                                  // aspectRatio: overlay.ratio!,
                                  aspectRatio: width / height,
                                  child: Container(
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
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
                      '임신사 카메라',
                      style: TextStyle(color: Colors.black),
                    ));
              }
            },
          ),
        )
    );
  }
}


