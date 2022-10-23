import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get_rx/get_rx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:last_ocr/entities/Ocr_pregnant.dart';
import 'package:last_ocr/functions/functions.dart';
import 'package:last_ocr/page/pregnant_list_page.dart';
import 'package:last_ocr/page/maternity_list_page.dart';
import 'package:last_ocr/page/maternity_graph_page.dart';
import 'package:last_ocr/page/maternity_page.dart';
import 'package:last_ocr/page/pregnant_graph_page.dart';
import 'package:last_ocr/page/pregnant_owner_graph_page.dart';
import 'package:last_ocr/page/pregnant_page.dart';
import 'overlay/camera_overlay_pregnant.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}
class MyHomePage extends StatefulWidget {

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyAppState extends State<MyApp> {

  var pregnants = <Ocr_pregnant>[].obs;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 화면 오른쪽에 뜨는 디버크 표시 지우기
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("임신사")
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                    children: <Widget>[
                      OutlinedButton(
                          onPressed: () {
                            showDialog(context: context, barrierDismissible:true,builder: (context){
                              return AlertDialog( // 카메라와 갤러리 선택 dialog
                                  shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0)
                                  ),
                                  content: SizedBox(
                                    height: 120.0,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextButton.icon( // 카메라
                                          label: Text("CAMERA",style: TextStyle(color: Colors.black),),
                                          onPressed: () { // 선택하면 CameraOverlayPregnant로 넘어간다
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => CameraOverlayPregnant())); },
                                          icon: Icon(Icons.camera_alt, size:40,color: Colors.black,),),
                                        TextButton.icon( // 갤러리
                                            label: Text("GALLERY",style: TextStyle(color: Colors.black),),
                                            onPressed: () async { // ImagePicker를 이용하여 사진 선택
                                              final image = await ImagePicker().pickImage(source: ImageSource.gallery);
                                              if(image!=null) {
                                                showDialog(context: context,
                                                    builder: (context) {
                                                      return Container(
                                                        padding: const EdgeInsets
                                                            .fromLTRB(
                                                            0, 0, 0, 0),
                                                        alignment: Alignment
                                                            .center,
                                                        decoration: const BoxDecoration(
                                                          color: Colors.white70,
                                                        ),
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .blue[200],
                                                              borderRadius: BorderRadius
                                                                  .circular(
                                                                  10.0)
                                                          ),
                                                          width: 300.0,
                                                          height: 200.0,
                                                          alignment: AlignmentDirectional
                                                              .center,
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment
                                                                .center,
                                                            mainAxisAlignment: MainAxisAlignment
                                                                .center,
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
                                                                margin: const EdgeInsets
                                                                    .only(
                                                                    top: 25.0),
                                                                child: const Center(
                                                                  child: Text(
                                                                    "loading.. wait...",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize: 20
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    });
                                              }
                                              // 서버로 임신사 사진 returnlist에 넣어서 보내기
                                              List returnlist = await uploadimg_pregnant(File(image!.path));

                                              // 서버에서 받은 사진 returnfilepath라는 이름으로 저장
                                              String returnfilepath = await downloadFile("ocrpreimages/"+returnlist[0]);
                                              Navigator.of(context).popUntil((route) => route.isFirst); // 처음 화면으로 돌아가기
                                              await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                                  PregnantPage(returnlist, returnfilepath)), // PregnantPage로 넘어가기
                                              );
                                            },
                                            icon: Icon(Icons.photo, size:40,color: Colors.black,)),
                                      ],
                                    ),
                                    // width: 300.0,
                                  )
                              );
                            });
                          },
                          child: const Text('OCR')
                      ),
                      OutlinedButton(
                          onPressed: ()async{
                            //서버로부터 값 받아오기
                            List<dynamic> list = await pregnant_getocr();
                            print("pregnant get ocr->");
                            print(list);
                            // PregnantListPage로 넘어가기
                            Navigator.push(context, MaterialPageRoute(builder: (context) => PregnantListPage(list)));
                          },
                          child: const Text('기록')
                      ),
                      OutlinedButton(
                          onPressed: () {
                            // PregnantGraphPage로 넘어가기
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) =>  PregnantOwnerGraphPage()));
                          },
                          child: const Text('그래프')
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("분만사")
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      OutlinedButton(
                          onPressed: () {
                            showDialog(context: context, barrierDismissible:true,builder: (context){
                              return AlertDialog( // 카메라와 갤러리 선택 dialog
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0)
                                  ),
                                  content: SizedBox(
                                    height: 120.0,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextButton.icon( // 카메라
                                          label: Text("CAMERA",style: TextStyle(color: Colors.black),),
                                          onPressed: () { // 선택하면 CameraOverlayPregnant로 넘어간다
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => CameraOverlayPregnant())); },
                                          icon: Icon(Icons.camera_alt, size:40,color: Colors.black,),),
                                        TextButton.icon( // 갤러리
                                            label: Text("GALLERY",style: TextStyle(color: Colors.black),),
                                            onPressed: () async { // ImagePicker를 이용하여 사진 선택
                                              final image = await ImagePicker().pickImage(source: ImageSource.gallery);
                                              if(image != null) {
                                                showDialog(context: context,
                                                    builder: (context) {
                                                      return Container(
                                                        padding: const EdgeInsets
                                                            .fromLTRB(
                                                            0, 0, 0, 0),
                                                        alignment: Alignment
                                                            .center,
                                                        decoration: const BoxDecoration(
                                                          color: Colors.white70,
                                                        ),
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .blue[200],
                                                              borderRadius: BorderRadius
                                                                  .circular(
                                                                  10.0)
                                                          ),
                                                          width: 300.0,
                                                          height: 200.0,
                                                          alignment: AlignmentDirectional
                                                              .center,
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment
                                                                .center,
                                                            mainAxisAlignment: MainAxisAlignment
                                                                .center,
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
                                                                margin: const EdgeInsets
                                                                    .only(
                                                                    top: 25.0),
                                                                child: const Center(
                                                                  child: Text(
                                                                    "loading.. wait...",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize: 20
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    });
                                              }
                                              // 서버로 분만사 사진 returnlist에 넣어서 보내기
                                              List returnlist = await uploadimg_maternity(File(image!.path));

                                              // 서버에서 받은 사진 returnfilepath라는 이름으로 저장
                                              String returnfilepath = await downloadFile("ocrmatimages/"+returnlist[0]);

                                              await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                                  MaternityPage(returnlist, returnfilepath)), // MaternityPage로 넘어가기
                                              );
                                            },
                                            icon: Icon(Icons.photo, size:40,color: Colors.black,)),
                                      ],
                                    ),
                                    // width: 300.0,
                                  )
                              );
                            });
                          },
                          child: const Text('OCR')
                      ),
                      OutlinedButton(
                          onPressed: () async{
                            //서버로부터 값 받아오기
                            List<dynamic> list = await maternity_getocr();
                            print("maternity get ocr->");
                            print(list);
                            // MaternityListPage로 넘어가기
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => MaternityListPage(list)));
                          },
                          child: const Text('기록')
                      ),
                      OutlinedButton(
                          onPressed: () {
                            // MaternityGraphPage로 넘어가기
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => MaternityGraphPage()));
                          },
                          child: const Text('그래프')
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      OutlinedButton(
                          onPressed: () {
                            delete_pregnant();
                          },
                          child: const Text('삭제')
                      ),
                    ],
                  ),
                ]
            )
        )
    );
  }
}
