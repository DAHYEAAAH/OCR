import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_rx/get_rx.dart';
import 'package:intl/intl.dart';
import 'package:last_ocr/entities/Ocr_maternity.dart';
import 'package:last_ocr/entities/Ocr_pregnant.dart';
import 'package:ntp/ntp.dart';
import 'package:path_provider/path_provider.dart';

Future<String> downloadFile(String imgname) async {
  String returnfilepath = "";
  Dio dio = Dio();
  try {
    var serverurl = "http://211.107.210.141:3000/api/ocrGetImage/"+imgname;
    print(serverurl);
    var dir = await getApplicationDocumentsDirectory();
    await dio.download(serverurl, '${dir.path}/'+imgname,
        onReceiveProgress: (rec, total) {
          print('Rec: $rec , Total: $total');
          returnfilepath = '${dir.path}/'+imgname;
        }, deleteOnError: true
    );
    print("download image success");
  } catch (e) {
    print("download image failed");
    print(e);
  }
  return returnfilepath;
}

Future<List> uploadimg_pregnant(File file)async{
  final api = 'http://211.107.210.141:3000/api/ocrImageUpload';
  final dio = Dio();

  DateTime currentTime = await NTP.now();
  currentTime = currentTime.toUtc().add(Duration(hours: 9));
  String formatDate = DateFormat('yyyyMMddHHmm').format(currentTime); //format변경
  String fileName = "pre"+formatDate+'.jpg';

  FormData _formData = FormData.fromMap({
    "file" : await MultipartFile.fromFile(file.path,
        filename: fileName, contentType : MediaType("image","jpg")),
  });

  Response response = await dio.post(
      api,
      data:_formData,
      onSendProgress: (rec, total) {
        print('Rec: $rec , Total: $total');
      }
  );
  print(response);
  print('Successfully uploaded');
  return response.data;
}


//분만사 전체 기록 불러오기
maternity_getocr() async {
  var maternity = <Ocr_maternity>[].obs;
  List<int> list_ocr_seq = [];
  List<String> list_sow_no = [];
  List<dynamic> list_add = [];

  final api ='http://211.107.210.141:3000/api/getOcr_maternity';
  final dio = Dio();
  Response response = await dio.get(api);

  if(response.statusCode == 200) {
    List<dynamic> result = response.data;
    maternity.assignAll(result.map((data) => Ocr_maternity.fromJson(data)).toList());
    maternity.refresh();
    for(int i=0; i<maternity.length; i++){
      if(i == 0) {
        print(" success..." + maternity[i].ocr_seq.toString() + " " + maternity[i].sow_no.toString());
        list_ocr_seq.add(maternity.length);
        list_sow_no.add(maternity.length.toString());
      }
      print(" success!"+ maternity[i].ocr_seq.toString()+" " +maternity[i].sow_no.toString());
      list_ocr_seq.add(maternity[i].ocr_seq!.toInt());
      list_sow_no.add(maternity[i].sow_no!.toString());
    }
  }
  else{
    print(" fail..."+response.statusCode.toString());
  }

  for( int i=0; i< list_ocr_seq.length; i++){
    list_add += [[list_ocr_seq[i],list_sow_no[i]]];
  }

  print(list_add);
  return list_add;
}

//선택한 기록 불러오기
//사용자 아이디, 모돈 번호를 보내고 그 값을 받아옴
pregnant_selectrow(int num) async{
  final api ='http://211.107.210.141:3000/api/ocr_pregnantSelectedRow';
  final data = {
    "ocr_seq": num, //pk
  };
  final dio = Dio();
  Response response;
  response = await dio.post(api,data: data);
  if(response.statusCode == 200) {
    print("col 1.."+response.data[0].toString());
    print("col 10.."+response.data[10].toString());
  }else{
    print(" fail..."+response.statusCode.toString());
  }
  return response.data;
}

delete_pregnant() async{
  final api ='http://211.107.210.141:3000/api/ocrDeleteAll';

  final dio = Dio();
  Response response;
  response = await dio.get(api);
  if(response.statusCode == 200) {
    print("successfully deleted");
  }else{
    print("failed to delete");
  }
}

//전체 기록 불러오기
pregnant_getocr() async {
  var pregnants = <Ocr_pregnant>[].obs;
  List<int> list_ocr_seq = [];
  List<String> list_sow_no = [];
  List<dynamic> list_add = [];

  final api ='http://211.107.210.141:3000/api/getOcr_pregnant';
  final dio = Dio();
  Response response = await dio.get(api);

  if(response.statusCode == 200) {

    List<dynamic> result = response.data;
    pregnants.assignAll(result.map((data) => Ocr_pregnant.fromJson(data)).toList());
    pregnants.refresh();
    for(int i=0; i<pregnants.length; i++){
      if(i == 0) {
        print(" success..." + pregnants[i].ocr_seq.toString() + " " + pregnants[i].sow_no.toString());
        list_ocr_seq.add(pregnants.length);
        list_sow_no.add(pregnants.length.toString());
      }
      print(" success!"+ pregnants[i].ocr_seq.toString()+" " +pregnants[i].sow_no.toString());
      list_ocr_seq.add(pregnants[i].ocr_seq!.toInt());
      list_sow_no.add(pregnants[i].sow_no!.toString());

    }
  }
  else{
    print(" fail..."+response.statusCode.toString());
  }

  for( int i=0; i< list_ocr_seq.length; i++){
    list_add += [[list_ocr_seq[i],list_sow_no[i]]];
  }

  print(list_add);
  return list_add;
}

Future<List> uploadimg_maternity(File file)async{
  final api ='http://211.107.210.141:3000/api/ocrImageUpload';
  final dio = Dio();

  DateTime currentTime = await NTP.now();

  currentTime = currentTime.toUtc().add(Duration(hours: 9));
  String formatDate = DateFormat('yyyyMMddHHmm').format(currentTime); //format변경
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
      }
  );
  print(response);
  print('Successfully uploaded');
  return response.data;
}

//선택한 리스트 값 받아오기
maternity_selectrow(int num) async {
  final api ='http://211.107.210.141:3000/api/ocr_maternitySelectedRow';
  final data = {
    "ocr_seq":num,
  };
  final dio = Dio();
  Response response;
  response = await dio.post(api,data: data);
  if(response.statusCode == 200) {
    print("col 1.."+response.data[0].toString());
    print("col 10.."+response.data[10].toString());
  }else{
    print(" fail..."+response.statusCode.toString());
  }
  print(response.data);
  return response.data;
}


resultToast(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      fontSize: 16.0
  );
}