import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_camera_overlay/model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:last_ocr/page/maternity_page.dart';
import '../page/pregnant_page.dart';
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
  var open = 1;
  List<double> left  =[0,0,0,0];
  List<double> top   =[0,0,0,0];
  List<double> width =[0,0,0,0];
  List<double> height=[0,0,0,0];
  int recog_count = 0;
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
      // while (true) {
      XFile file = await controller.takePicture();
      print("whidhs");
      print(phonewidth);
      print(phoneheight);

      print("sendframeEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE");
      final api = 'https://www.dfxsoft.com/api/ocrImageUpload';
      final dio = Dio();
      DateTime currentTime = await NTP.now();
      currentTime = currentTime.toUtc().add(Duration(hours: 9));
      String formatDate = DateFormat('yyyyMMddHHmm').format(
          currentTime); //format변경
      String fileName = "mat" + formatDate + '.jpg';

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

      returnlist = response.data;
      setState(() {
        left=[0,0,0,0]; top=[0,0,0,0]; width=[0,0,0,0]; height=[0,0,0,0];
        recog_count=returnlist[2].length-1;
        if(recog_count>0){
          Map dic = returnlist[2];
          List key = dic.keys.toList();
          List values = dic.values.toList();
          print(key);
          print(values);
          for (int i = 0; i < recog_count; i++) {
            switch (key[i]) {
              case '923':
                left[0] = values[i][0][0] / density;
                top[0] = values[i][0][1] / density;
                width[0] = values[i][1][0] / density - values[i][0][0] / density;
                height[0] = values[i][3][1] / density - values[i][0][1] / density;
                break;
              case '1001':
                left[1] = values[i][0][0] / density;
                top[1] = values[i][0][1] / density;
                width[1] = values[i][1][0] / density - values[i][0][0] / density;
                height[1] = values[i][3][1] / density - values[i][0][1] / density;
                break;
              case '1007':
                left[2] = values[i][0][0] / density;
                top[2] = values[i][0][1] / density;
                width[2] = values[i][1][0] / density - values[i][0][0] / density;
                height[2] = values[i][3][1] / density - values[i][0][1] / density;
                break;
              case '241':
                left[3] = values[i][0][0] / density;
                top[3] = values[i][0][1] / density;
                width[3] = values[i][1][0] / density - values[i][0][0] / density;
                height[3] = values[i][3][1] / density - values[i][0][1] / density;
                break;
            }
          }
        }
      });
      if (returnlist[1].length > 0) {
        print("success - response is : ");
        print(returnlist);
        open=0;
        Fluttertoast.showToast(msg: "OCR인식 성공", toastLength: Toast.LENGTH_SHORT);
        // widget.onCapture(file);
        // 찍은 사진 갤러리에 저장
        GallerySaver.saveImage(file.path).then((value) => print('>>>> save value= $value'))
            .catchError((err) {print('error : $err');});

        Navigator.of(context).popUntil((route) => route.isFirst); // 처음 화면으로 돌아가기
        await Navigator.push(context,
          MaterialPageRoute(builder: (context) => MaternityPage(returnlist)), // PregnantPage 넘어가기
        );
      }
      else {
        print("fail - response is : ");
        print(returnlist);
      }
      // }
    }

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
    if(open==1)up();
    return GestureDetector(
        onTap: () async{
          // up();
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
                            recog_count==0?
                            Text("0/4",style:TextStyle(backgroundColor: Colors.black,color: Colors.white),textAlign: TextAlign.center,):SizedBox(),
                            recog_count==1?
                            Text("1/4",style:TextStyle(backgroundColor: Colors.black,color: Colors.white),textAlign: TextAlign.center,):SizedBox(),
                            recog_count==2?
                            Text("2/4",style:TextStyle(backgroundColor: Colors.black,color: Colors.white),textAlign: TextAlign.center,):SizedBox(),
                            recog_count==3?
                            Text("3/4",style:TextStyle(backgroundColor: Colors.black,color: Colors.white),textAlign: TextAlign.center,):SizedBox(),
                            recog_count==4?
                            Text("4/4",style:TextStyle(backgroundColor: Colors.black,color: Colors.white),textAlign: TextAlign.center,):SizedBox(),
                            Positioned(
                              left: left[0],
                              top: top[0],
                              width: width[0],
                              height: height[0],
                              child: Container(
                                child: Image.asset('assets/drawable/marker_left_top.png'),
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
                                child: Image.asset('assets/drawable/marker_right_top.png'),                             decoration: BoxDecoration(
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
                                child: Image.asset('assets/drawable/marker_left_bottom.png'),
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
                                child: Image.asset('assets/drawable/marker_right_bottom.png'),                             decoration: BoxDecoration(
                                color: Colors.black26,
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                // border: Border.all(color: Colors.pink, width: 2.0),
                              ),
                              ),
                            ),
                          ],
                        ))
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
                          child: SizedBox()
                      )
                  ),
                ),
              ]
          ),
        ));
  }

}
