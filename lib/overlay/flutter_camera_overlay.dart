// import 'package:camera/camera.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_camera_overlay/model.dart';
// // import 'package:flutter_camera_overlay/overlay_shape.dart';
// import 'flutter_overlay_shape.dart';
//
// typedef XFileCallback = void Function(XFile file);
//
// class CameraOverlay extends StatefulWidget {
//   const CameraOverlay(
//       this.camera,
//       // this.camera2,
//       this.model,
//       this.onCapture, {
//         Key? key,
//         this.flash = false,
//         this.label,
//         this.info,
//         this.loadingWidget,
//         this.infoMargin,
//       }) : super(key: key);
//   final CameraDescription camera;
//   // final CameraDescription camera2;
//   final OverlayModel model;
//   final bool flash;
//   final XFileCallback onCapture;
//   final String? label;
//   final String? info;
//   final Widget? loadingWidget;
//   final EdgeInsets? infoMargin;
//   @override
//   _FlutterCameraOverlayState createState() => _FlutterCameraOverlayState();
// }
//
// class _FlutterCameraOverlayState extends State<CameraOverlay> {
//   _FlutterCameraOverlayState();
//   late CameraController controller;
//   int cameraIndex = 0;
//
//   // @override
//   // void initState() {
//   //   super.initState();
//   //   controller = CameraController(widget.camera, ResolutionPreset.max);
//   //   controller.initialize().then((_) {
//   //     if (!mounted) {
//   //       return;
//   //     }
//   //     setState(() {});
//   //   });
//   // }
//   @override
//   void initState() {
//     super.initState();
//     _initCamera();
//   }
//   Future<void> _initCamera() async {
//     controller = CameraController(widget.camera, ResolutionPreset.max);
//     final cameras = await availableCameras();
//
//     controller = new CameraController(cameras[cameraIndex], ResolutionPreset.veryHigh);
//     controller.initialize().then((_) {
//       if (!mounted) {
//         return;
//       }
//       setState(() {});
//     });
//   }
//
//
//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Widget loadingWidget = widget.loadingWidget ??
//         Container(
//           color: Colors.white,
//           height: double.infinity,
//           width: double.infinity,
//           child: const Align(
//             alignment: Alignment.center,
//             child: Text('Camera is connecting',style: TextStyle(fontSize: 20),),
//           ),
//         );
//
//     // if (!controller.value.isInitialized) {
//     //   return loadingWidget;
//     // }
//
//     controller
//         .setFlashMode(widget.flash == true ? FlashMode.auto : FlashMode.off);
//
//     return Container(
//       color: Colors.black,
//       child: Stack(
//           alignment: Alignment.center,
//           fit: StackFit.loose,
//           children: [
//             CameraPreview(controller),
//             OverlayShape(widget.model),
//             if (widget.label != null || widget.info != null)
//               Align(
//                 alignment: Alignment.topCenter,
//                 child: Container(
//                     margin: widget.infoMargin ??
//                         const EdgeInsets.only(top: 100, left: 20, right: 20),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         if (widget.label != null)
//                           Text(
//                             widget.label!,
//                             style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 24,
//                                 fontWeight: FontWeight.w700),
//                           ),
//                         if (widget.info != null)
//                           Flexible(
//                             child: Text(
//                               widget.info!,
//                               style: const TextStyle(color: Colors.white),
//                             ),
//                           ),
//                       ],
//                     )),
//               ),
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Material(
//                   color: Colors.transparent,
//                   child: Container(
//                       decoration: const BoxDecoration(
//                         color: Colors.black12,
//                         shape: BoxShape.circle,
//                       ),
//                       margin: const EdgeInsets.all(25),
//                       child: IconButton(
//                         enableFeedback: true,
//                         color: Colors.white,
//                         onPressed: () async {
//                           for (int i = 10; i > 0; i--) {
//                             await HapticFeedback.vibrate();
//                           }
//                           XFile file = await controller.takePicture();
//                           widget.onCapture(file);
//                           print("flutter_camera_overlay - camera charkakkk!");
//
//                         },
//                         icon: const Icon(
//                           Icons.camera,
//                         ),
//                         iconSize: 72,
//                       ))),
//             ),
//             Align(
//               alignment: Alignment.bottomRight,
//               child: Material(
//                   color: Colors.transparent,
//                   child: Container(
//                       decoration: const BoxDecoration(
//                         color: Colors.black12,
//                         shape: BoxShape.circle,
//                       ),
//                       margin: const EdgeInsets.all(25),
//                       child: IconButton(
//                         enableFeedback: true,
//                         color: Colors.white,
//                         onPressed: () async {
//                           /// 후면 카메라 <-> 전면 카메라 변경
//                           try {
//                             cameraIndex = cameraIndex == 0 ? 1 : 0;
//                             await _initCamera();
//                           }
//                           catch(error){
//                             print("can't change cameraIndex ");
//                           }
//                         },
//                         icon: const Icon(
//                           Icons.flip_camera_android,
//                           color: Colors.white,
//                           size: 34.0,
//                         ),
//                         iconSize: 72,
//                       ))),
//             ),
//
//           ]
//       ),
//     );
//
//   }
// }
//
// // sendframe(File file, int i) async{
// //   print("sendframeEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE");
// //   final api = 'http://192.168.0.26:4000/api/newocrImageUpload';
// //   final dio = Dio();
// //
// //   String fileName = 'test.jpg';
// //
// //   FormData _formData = FormData.fromMap({
// //     "file" : await MultipartFile.fromFile(file.path,
// //         filename: fileName, contentType : MediaType("image","jpg")),
// //   });
// //
// //   Response response = await dio.post(
// //       api,
// //       data:_formData,
// //       onSendProgress: (rec, total) {
// //         // print('Rec: $rec , Total: $total');
// //       }
// //   );
// //
// //   returnlist = response.data;
// //   if(returnlist.length>0){
// //     print("response is : ");
// //     print(returnlist);
// //     return "success";
// //   }
// //   else{
// //     print("response is : ");
// //     print(returnlist);
// //     return "fail";
// //   }
// //
// // }
