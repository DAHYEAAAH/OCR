import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_camera_overlay/model.dart';
import 'package:flutter_camera_overlay/overlay_shape.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path/path.dart';
import '../functions/functions.dart';
import '../page/pregnant_page.dart';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:ntp/ntp.dart';
import 'package:intl/intl.dart';

typedef XFileCallback = void Function(XFile file);
late List returnlist = [1,[]];
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

  List<double> left = [0,0,0,0];
  List<double> top=[0,0,0,0];
  List<double> width=[0,0,0,0];
  List<double> height=[0,0,0,0];
  @override
  Widget build(BuildContext context) {
    var density = MediaQuery.of(context).devicePixelRatio;
    print("density");
    print(density);
    var media = MediaQuery.of(context);
    var size = media.size;
    double phonewidth = size.width;

    double phoneheight = size.height;

    up()async {
      // XFile file = await controller.takePicture();
      // widget.onCapture(file);
      // print("TABTABTABTABTABTABTABTABTABTABTABTABTABTAB");
      while (true) {
        XFile file = await controller.takePicture();
        print("whidhs");
        print(phonewidth);
        print(phoneheight);

        print(
            "sendframeEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE");
        final api = 'https://www.dfxsoft.com/api/ocrImageUpload';
        final dio = Dio();
        DateTime currentTime = await NTP.now();
        currentTime = currentTime.toUtc().add(Duration(hours: 9));
        String formatDate = DateFormat('yyyyMMddHHmm').format(
            currentTime); //format변경
        String fileName = "pre" + formatDate + '.jpg';

        FormData _formData = FormData.fromMap({
          "file": await MultipartFile.fromFile(file.path,
              filename: fileName, contentType: MediaType("image", "jpg")),
        });

        Response response = await dio.post(
            api,
            data: _formData,
            onSendProgress: (rec, total) {
              // print('Rec: $rec , Total: $total');
            }
        );

        // Response response = await dio.get(
        //     'http://172.17.135.16:4000/ocrs'
        // );
        returnlist = response.data;

        setState(() {
          if (returnlist[2].length == 5) {
            left=[
              returnlist[2][0][0][0] / density,
              returnlist[2][1][0][0] / density,
              returnlist[2][2][0][0] / density,
              returnlist[2][3][0][0] / density,
            ];
            top=[
              returnlist[2][0][0][1] / density,
              returnlist[2][1][0][1] / density,
              returnlist[2][2][0][1] / density,
              returnlist[2][3][0][1] / density,
            ];
            width = [
              returnlist[2][0][1][0] / density - returnlist[2][0][0][0] / density,
              returnlist[2][1][1][0] / density - returnlist[2][1][0][0] / density,
              returnlist[2][2][1][0] / density - returnlist[2][2][0][0] / density,
              returnlist[2][3][1][0] / density - returnlist[2][3][0][0] / density
            ];
            height = [
              returnlist[2][0][3][1] / density - returnlist[2][0][0][1] / density,
              returnlist[2][1][3][1] / density - returnlist[2][1][0][1] / density,
              returnlist[2][2][3][1] / density - returnlist[2][2][0][1] / density,
              returnlist[2][3][3][1] / density - returnlist[2][3][0][1] / density
            ];
          }
          else if (returnlist[2].length == 4) {
            left=[
              returnlist[2][0][0][0] / density,
              returnlist[2][1][0][0] / density,
              returnlist[2][2][0][0] / density,
              0
            ];
            top=[
              returnlist[2][0][0][1] / density,
              returnlist[2][1][0][1] / density,
              returnlist[2][2][0][1] / density,
              0
            ];
            width = [
              returnlist[2][0][1][0] / density - returnlist[2][0][0][0] / density,
              returnlist[2][1][1][0] / density - returnlist[2][1][0][0] / density,
              returnlist[2][2][1][0] / density - returnlist[2][2][0][0] / density,
              0
            ];
            height = [
              returnlist[2][0][3][1] / density - returnlist[2][0][0][1] / density,
              returnlist[2][1][3][1] / density - returnlist[2][1][0][1] / density,
              returnlist[2][2][3][1] / density - returnlist[2][2][0][1] / density,
              0
            ];
          }
          else if (returnlist[2].length == 3) {
            left=[
              returnlist[2][0][0][0] / density,
              returnlist[2][1][0][0] / density,
              0,
              0
            ];
            top=[
              returnlist[2][0][0][1] / density,
              returnlist[2][1][0][1] / density,
              0,
              0
            ];
            width = [
              returnlist[2][0][1][0] / density - returnlist[2][0][0][0] / density,
              returnlist[2][1][1][0] / density - returnlist[2][1][0][0] / density,
              0,
              0
            ];
            height = [
              returnlist[2][0][3][1] / density - returnlist[2][0][0][1] / density,
              returnlist[2][1][3][1] / density - returnlist[2][1][0][1] / density,
              0,
              0
            ];
          }
          else if (returnlist.length == 2) {
            left[0] = returnlist[2][0][0][0] / density;
            top[0] = returnlist[2][0][0][1] / density;
            width = [
              returnlist[2][0][1][0] / density - returnlist[2][0][0][0] / density,
              0,
              0,
              0
            ];
            height = [
              returnlist[2][0][3][1] / density - returnlist[2][0][0][1] / density,
              0,
              0,
              0
            ];
          }
          else {
            width = [0, 0, 0, 0];
            height = [0, 0, 0, 0];
          }
        });

        if (returnlist[1].length > 0) {
          print("success - response is : ");
          print(returnlist);
          Fluttertoast.showToast(
              msg: "OCR인식 성공", toastLength: Toast.LENGTH_SHORT);

          // 찍은 사진 갤러리에 저장
          GallerySaver.saveImage(file.path)
              .then((value) =>
              print(
                  '>>>> save value= $value'))
              .catchError((err) {
            print('error : $err');
          });

          Navigator.of(context).popUntil((route) =>
          route.isFirst); // 처음 화면으로 돌아가기
          await Navigator.push(context,
            MaterialPageRoute(builder: (context) =>
                PregnantPage(
                    returnlist)), // PregnantPage 넘어가기
          );

          break;
        }
        else {
          print("fail - response is : ");
          print(returnlist);
        }
      }
    }
    up();

    Widget loadingWidget = widget.loadingWidget ??
        Container(
          color: Colors.white,
          height: double.infinity,
          width: double.infinity,
          child: const Align(
            alignment: Alignment.center,
            child: Text('Camera is connecting',style: TextStyle(fontSize: 20),),
          ),
        );

    if (!controller.value.isInitialized) {
      return loadingWidget;
    }

    controller
        .setFlashMode(widget.flash == true ? FlashMode.auto : FlashMode.off);

    return  GestureDetector(
        onTap: () async{

        },
        child:Container(
          color: Colors.black,
          child: Stack(
          alignment: Alignment.center,
          fit: StackFit.loose,
          children: [
            CameraPreview(controller),
            // OverlayShape(widget.model),
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

            Container(
              // color: Colors.red,
                width: phonewidth,
                child: AspectRatio(
                // aspectRatio: width/height,
                aspectRatio: (1 / controller.value.aspectRatio),
                    child: Stack(
                    fit: StackFit.expand,
                    children: [
                      SizedBox(height: 10,),
                      width[0]!=0&&width[1]==0&&width[2]==0&&width[3]==0?
                      Text("1/4",style:TextStyle(backgroundColor: Colors.black,color: Colors.white),textAlign: TextAlign.center,):SizedBox(),
                      width[0]!=0&&width[1]!=0&&width[2]==0&&width[3]==0?
                      Text("2/4",style:TextStyle(backgroundColor: Colors.black,color: Colors.white),textAlign: TextAlign.center,):SizedBox(),
                      width[0]!=0&&width[1]!=0&&width[2]!=0&&width[3]==0?
                      Text("3/4",style:TextStyle(backgroundColor: Colors.black,color: Colors.white),textAlign: TextAlign.center,):SizedBox(),
                      width[0]!=0&&width[1]!=0&&width[2]!=0&&width[3]!=0?
                      Text("4/4",style:TextStyle(backgroundColor: Colors.black,color: Colors.white),textAlign: TextAlign.center,):SizedBox(),
                        Positioned(
                          left: left[0],
                          top: top[0],
                          width: width[0],
                          height: height[0],
                          child: Container(
                            child: left[0]<phonewidth/2&&top[0]<phoneheight/2?Image.asset('assets/drawable/marker_left_top.png'):
                            left[0]>phonewidth/2&&top[0]<phoneheight/2?Image.asset('assets/drawable/marker_right_top.png'):
                            left[0]<phonewidth/2&&top[0]>phoneheight/2?Image.asset('assets/drawable/marker_left_bottom.png'):
                            Image.asset('assets/drawable/marker_right_bottom.png'),
                            decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              // border: Border.all(color: Colors.pink, width: 2.0),
                            ),
                          ),
                        ),
                        Positioned(
                          left: left[1],
                          top: top[1],
                          width: width[1],
                          height: height[1],
                          child: Container(
                            child: left[1]<phonewidth/2&&top[1]<phoneheight/2?Image.asset('assets/drawable/marker_left_top.png'):
                            left[1]>phonewidth/2&&top[1]<phoneheight/2?Image.asset('assets/drawable/marker_right_top.png'):
                            left[1]<phonewidth/2&&top[1]>phoneheight/2?Image.asset('assets/drawable/marker_left_bottom.png'):
                            Image.asset('assets/drawable/marker_right_bottom.png'),
                            decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              // border: Border.all(color: Colors.pink, width: 2.0),
                            ),
                          ),
                        ),
                        Positioned(
                          left: left[2],
                          top: top[2],
                          width: width[2],
                          height: height[2],
                          child: Container(
                            child: left[2]<phonewidth/2&&top[2]<phoneheight/2?Image.asset('assets/drawable/marker_left_top.png'):
                            left[2]>phonewidth/2&&top[2]<phoneheight/2?Image.asset('assets/drawable/marker_right_top.png'):
                            left[2]<phonewidth/2&&top[2]>phoneheight/2?Image.asset('assets/drawable/marker_left_bottom.png'):
                            Image.asset('assets/drawable/marker_right_bottom.png'),
                            decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              // border: Border.all(color: Colors.black, width: 2.0),
                            ),
                          ),
                        ),
                        Positioned(
                          left: left[3],
                          top: top[3],
                          width: width[3],
                          height: height[3],
                          child: Container(
                            child: left[3]<phonewidth/2&&top[3]<phoneheight/2?Image.asset('assets/drawable/marker_left_top.png'):
                            left[3]>phonewidth/2&&top[3]<phoneheight/2?Image.asset('assets/drawable/marker_right_top.png'):
                            left[3]<phonewidth/2&&top[3]>phoneheight/2?Image.asset('assets/drawable/marker_left_bottom.png'):
                            Image.asset('assets/drawable/marker_right_bottom.png'),
                            decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              // border: Border.all(color: Colors.pink, width: 2.0),
                            ),
                          ),
                        ),
                      ],
                    ))
            ),
            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: Material(
            //       color: Colors.transparent,
            //       child: Container(
            //           decoration: const BoxDecoration(
            //             color: Colors.black12,
            //             shape: BoxShape.circle,
            //           ),
            //           margin: const EdgeInsets.all(25),
            //           child: IconButton(
            //             enableFeedback: true,
            //             color: Colors.white,
            //             onPressed: () async {
            //               // for (int i = 10; i > 0; i--) {
            //               //   await HapticFeedback.vibrate();
            //               // }
            //
            //               // XFile file = await controller.takePicture();
            //               // widget.onCapture(file);
            //               // print("flutter_camera_overlay - camera charkakkk!");
            //
            //             },
            //             icon: const Icon(
            //               Icons.camera,
            //             ),
            //             iconSize: 72,
            //           ))),
            // ),
          ]
      ),
    ));
  }

}
