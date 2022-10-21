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
  String? returnfilepath = "";
  bool downloading = false;
  var progressString = "";


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

  Future<List> uploadimg_maternity(File file)async{
    final api ='http://211.107.210.141:3000/api/ocrImageUpload';
    final dio = Dio();

    DateTime currentTime = await NTP.now();

    currentTime = currentTime.toUtc().add(Duration(hours: 9));
    String formatDate = DateFormat('yyMMddHHmm').format(currentTime); //format변경
    String fileName = "mat"+formatDate+'.jpg';

    FormData _formData = FormData.fromMap({
      "file" : await MultipartFile.fromFile(file.path,
          filename: fileName, contentType : MediaType("image","jpg")),
    });

    Response response = await dio.post(
        api,
        data:_formData,
        onSendProgress: (rec, total) {
          print('Rec: $rec , Total: $total');
          setState(() {
            downloading = true;
            progressString = ((rec / total) * 100).toStringAsFixed(0) + '%';
            print(progressString);
          });
        }
    );
    print(response);
    print('Successfully uploaded');
    return response.data;
  }
  Future<void> downloadFile(String imgname) async {
    Dio dio = Dio();
    try {
      var serverurl = "http://211.107.210.141:3000/api/ocrGetImage/"+imgname;
      var dir = await getApplicationDocumentsDirectory();
      await dio.download(serverurl, '${dir.path}/'+imgname,
          onReceiveProgress: (rec, total) {
            print('Rec: $rec , Total: $total');
            returnfilepath = '${dir.path}/'+imgname;
            setState(() {
              setState(() {
                downloading = true;
                progressString = ((rec / total) * 100).toStringAsFixed(0) + '%';
                print(progressString);
              });
            });
          }, deleteOnError: true
      );
      print("download image success");
    } catch (e) {
      print("download image failed");
      print(e);
    }
    setState(() {
      downloading = false;
      progressString = 'Completed';
    });
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
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.blue[200],
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
                                                        color: Colors.white
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

                                    await downloadFile("ocrmatimages/" + list[0]);

                                    Navigator.of(context).popUntil((route) => route.isFirst);
                                    await Navigator.push(context,MaterialPageRoute(builder: (context) =>
                                        MaternityPage(list, returnfilepath!)),
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
                                    await downloadFile("ocrmatimages/" + list[0]);

                                    Navigator.of(context).popUntil((route) => route.isFirst);
                                    await Navigator.push(context,MaterialPageRoute(builder: (context) =>
                                        MaternityPage(list, returnfilepath!)),
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
