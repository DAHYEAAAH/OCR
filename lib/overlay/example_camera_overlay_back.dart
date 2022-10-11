import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_camera_overlay/model.dart';
import 'package:flutter_camera_overlay/overlay_shape.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_cropper/image_cropper.dart';
// import 'package:flutter/src/widgets/image.dart';
import 'package:last_ocr/overlay/example_camera_overlay_back.dart';


// import 'dart:io';
// import 'package:image/image.dart' as img;

typedef XFileCallback = void Function(XFile file);

late List<String> array = List.filled(35, "",growable: true);
late List<String> array_graph = List.filled(8, "", growable: true);


receiveresult(){
  print(array);
  return array;
}


class CameraOverlay extends StatefulWidget {
  const CameraOverlay(
      this.camera,
      this.model,
      this.onCapture, {
        Key? key,
        this.flash = false,
        this.label,
        this.info,
        this.loadingWidget,
        this.infoMargin,
      }) : super(key: key);
  final CameraDescription camera;
  final OverlayModel model;
  final bool flash;
  final XFileCallback onCapture;
  final String? label;
  final String? info;
  final Widget? loadingWidget;
  final EdgeInsets? infoMargin;
  @override
  _FlutterCameraOverlayState createState() => _FlutterCameraOverlayState();
}

class _FlutterCameraOverlayState extends State<CameraOverlay> {
  _FlutterCameraOverlayState();
  late CameraController controller;


  @override
  void initState() {
    super.initState();
    controller = CameraController(widget.camera, ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget loadingWidget = widget.loadingWidget ??
        Container(
          color: Colors.white,
          height: double.infinity,
          width: double.infinity,
          child: const Align(
            alignment: Alignment.center,
            child: Text('loading cameraaaa'),
          ),
        );

    if (!controller.value.isInitialized) {
      return loadingWidget;
    }

    controller
        .setFlashMode(widget.flash == true ? FlashMode.auto : FlashMode.off);

    return Container(
      color: Colors.black,
      child: Stack(
          alignment: Alignment.center,
          fit: StackFit.loose,
          children: [
            CameraPreview(controller),
            OverlayShape(widget.model),
            if (widget.label != null || widget.info != null)
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                    margin: widget.infoMargin ??
                        const EdgeInsets.only(top: 100, left: 20, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.label != null)
                          Text(
                            widget.label!,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w700),
                          ),
                        if (widget.info != null)
                          Flexible(
                            child: Text(
                              widget.info!,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                      ],
                    )),
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
                          for (int i = 10; i > 0; i--) {
                            await HapticFeedback.vibrate();
                          }

                          XFile file = await controller.takePicture();
                          widget.onCapture(file);
                          print("flutter_camera_overlay - camera charkakkk!");
                          // file = copyResize(image, width: 120);
                          // file  = copyCrop(file,0,0,60,60);


                        },
                        icon: const Icon(
                          Icons.camera,
                        ),
                        iconSize: 72,
                      ))),
            ),
          ]
      ),
    );
  }
}

submit_uploadimg_back(dynamic file) async {
  String filename = "no";
  try {
    // print("분만사 이미지 전송 함");
    Response res = await uploading_back(file.path);

    switch(res.statusCode){
      case 200:
        final jsonbody = res.data;       // ex) {"result":[335,"1111-11-11","2022_08_10_14_57_16.jpg"]}
        filename = jsonbody['result'][37]; // ex) "2022_08_10_14_57_16.jpg"
        array = jsonbody['result'];
        print("array is ?");
        print(array);
        print("분만사 이미지 전송 함");
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

uploading_back(String imagePath) async {
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
        'http://211.107.210.141:3001/ocrs/uploadimg/back',
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
