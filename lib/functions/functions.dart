import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_rx/get_rx.dart';
import 'package:last_ocr/entities/Ocr_pregnant.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http_parser/http_parser.dart';
//임신사 사진전송
// pregnant_insert(String path) async {
//   final api ='http://211.107.210.141:3000/api/ocrpregnatInsert';
//   final data = {
//     "ocr_imgpath": path,
//   };
//   final dio = Dio();
//   Response response;
//   response = await dio.post(api,data: data);
//   if(response.statusCode == 200){
//     resultToast('Ocr 임신사 insert success... \n\n');
//   }
// }
late List<String> array = List.filled(35, "",growable: true);
late List<String> array_graph = List.filled(8, "", growable: true);

//전체 기록 불러오기
pregnant_getocr() async {
  var pregnants = <Ocr_pregnant>[].obs;
  late List<String> list_ocr_seq = <String>[];
  late List<String> list_sow_num = <String>[];

  final api ='http://211.107.210.141:3000/api/getOcr_pregnant';
  final dio = Dio();

  print("기록 불러올거임");
  Response response = await dio.get(api);

  if(response.statusCode == 200) {

    List<dynamic> result = response.data;
    pregnants.assignAll(result.map((data) => Ocr_pregnant.fromJson(data)).toList());
    pregnants.refresh();

    print("기록 불러와짐");
    print(pregnants.length);

    for( int i=0; i<pregnants.length; i++){
      print(" success..."+pregnants[i].ocr_seq.toString()+" "+pregnants[i].sow_no.toString());
      list_ocr_seq.add(pregnants[i].ocr_seq.toString());
      list_sow_num.add(pregnants[i].sow_no.toString());
      // return list_sow_num + list_sow_num;
    }
  }else{
    print(" fail..."+response.statusCode.toString());
  }
  return list_ocr_seq + list_ocr_seq;
  //Navigator.pushNamed(context, '/second', arguments: list_sow_num);

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
}

submitimg(File file)async{
  // final api = 'http://172.17.53.63:3000/api/ocrImageUpload';
  final api ='http://211.107.210.141:3000/api/ocrImageUpload';
  final dio = Dio();
  // String fileName = file.path.split('/').last;

  DateTime now = DateTime.now();
  String fileName = now.year.toString()+now.month.toString()+now.day.toString()+now.hour.toString()+now.minute.toString()+'.jpg';
  // final api2 = 'http://172.17.53.63:3000/api/ocrImageUpload' + fileName;

  FormData _formData = FormData.fromMap({
    "file" : await MultipartFile.fromFile(file.path,
        filename: fileName, contentType : MediaType("image","jpg")),
  });

  Response response = await dio.post(
      api,
      data:_formData
  );
  // print(response.data.toString());
  return response.data;
  //  Response response2 = await dio.get(
  //    api2,
  //    data:_formData
  // );
}

//수정 후 서버 전송가 아닌 서버에서 ocr돌리고 받은 값을 수정한 insert..
pregnant_insert(String? sow_no,String? sow_birth, String? sow_buy, String? sow_estrus, String? sow_cross, String? boar_fir, String? boar_sec,
    String? checkdate, String? expectdate, String? vaccine1, String? vaccine2, String? vaccine3, String? vaccine4, String? memo) async {
  final api ='http://211.107.210.141:3000/api/ocrpregnatInsert';
  final data = {
    // "ocr_seq": ocr_seq,
    "sow_no": sow_no,
    "sow_birth": sow_birth,
    "sow_buy":sow_buy,
    "sow_estrus":sow_estrus,
    "sow_cross":sow_cross,
    "boar_fir":boar_fir,
    "boar_sec":boar_sec,
    "checkdate":checkdate,
    "expectdate":expectdate,
    "vaccine1":vaccine1,
    "vaccine2":vaccine2,
    "vaccine3":vaccine3,
    "vaccine4":vaccine4,
    // "ocr_imgpath":'17',
    "memo":memo,
  };
  final dio = Dio();
  Response response;
  response = await dio.post(api,data: data);
  print(response.data.toString());
  print(response.data);
  if(response.statusCode == 200){
//resultToast('Ocr 임신사 update success... \n\n');
    print('Ocr 임신사 update success... \n\n');
  }
  return 0;
}


//수정 후 서버 전송
pregnant_update(String? sow_no,String? sow_birth, String? sow_buy, String? sow_estrus, String? sow_cross, String? boar_fir, String? boar_sec,
    String? checkdate, String? expectdate, String? vaccine1, String? vaccine2, String? vaccine3, String? vaccine4, String? memo) async {
  final api ='http://211.107.210.141:3000/api/ocrpregnatUpdate';
  final data = {
    // "ocr_seq": ocr_seq,
    "sow_no": sow_no,
    "sow_birth": sow_birth,
    "sow_buy":sow_buy,
    "sow_estrus":sow_estrus,
    "sow_cross":sow_cross,
    "boar_fir":boar_fir,
    "boar_sec":boar_sec,
    "checkdate":checkdate,
    "expectdate":expectdate,
    "vaccine1":vaccine1,
    "vaccine2":vaccine2,
    "vaccine3":vaccine3,
    "vaccine4":vaccine4,
    // "ocr_imgpath":'17',
    "memo":memo,
  };
  final dio = Dio();
  Response response;
  response = await dio.post(api,data: data);
  print(response.data.toString());
  print(response.data);
  if(response.statusCode == 200){
//resultToast('Ocr 임신사 update success... \n\n');
    print('Ocr 임신사 update success... \n\n');
  }
  return 0;
}


submit_uploadimg_pregnant(dynamic file) async {
  String filename = "no";
  try {
    //print("임신사 이미지 전송 함");
    Response res = await uploadimg_pregnant(file.path);

    switch(res.statusCode){
      case 200:
        final jsonbody = res.data;       // ex) {"result":[335,"1111-11-11","2022_08_10_14_57_16.jpg"]}
        filename = jsonbody['result'][37]; // ex) "2022_08_10_14_57_16.jpg"
        array = jsonbody['result'];
        print("array is ?");
        print(array);
        print("임신사 이미지 전송 함");
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

uploadimg_pregnant(String imagePath) async {
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
        'http://211.107.210.141:3000/api/ocrpregnatInsert',
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


//분만사 페이지 전송
maternity_insert(String? sow_no, String? sow_birth, String? sow_buy, String? sow_expectdate, String? sow_givebirth, String? sow_totalbaby, String? sow_feedbaby,
    String? sow_babyweight, String? sow_sevrerdate, String? sow_sevrerqty, String? sow_sevrerweight,  String? vaccine1, String? vaccine2,
    String? vaccine3, String? vaccine4, String? memo) async {
  final api ='http://211.107.210.141:3000/api/ocrmaternityInsert';
  final data = {
    "sow_no": sow_no,
    "sow_birth": sow_birth,
    "sow_buy":sow_buy,
    "sow_expectdate":sow_expectdate,
    "sow_givebirth":sow_givebirth,
    "sow_totalbaby":sow_totalbaby,
    "sow_feedbaby":sow_feedbaby,
    "sow_babyweight":sow_babyweight,
    "sow_sevrerdate":sow_sevrerdate, //이유두수
    "sow_sevrerqty":sow_sevrerqty, //이유날
    "sow_sevrerweight":sow_sevrerweight, //이유체중
    "vaccine1": vaccine1,
    "vaccine2": vaccine2,
    "vaccine3": vaccine3,
    "vaccine4":vaccine4,
    // "ocr_imgpath":'14',
    "memo": memo,};
  final dio = Dio();
  Response response;
  response = await dio.post(api,data: data);
  if(response.statusCode == 200){
//resultToast('Ocr 분만사 update success... \n\n');
  }
}


//분만사 전체 기록 불러오기
maternity_getocr() async {
  var pregnants = <Ocr_pregnant>[].obs;

  final api ='http://211.107.210.141:3000/api/getOcr_maternity';
  final dio = Dio();
  Response response = await dio.get(api);
  if(response.statusCode == 200) {

    List<dynamic> result = response.data;
    pregnants.assignAll(result.map((data) => Ocr_pregnant.fromJson(data)).toList());
    pregnants.refresh();
    for( int i=0; i<pregnants.length; i++){
      print(" success..."+pregnants[i].ocr_seq.toString()+" "+pregnants[i].sow_no.toString());
    }
  }else{
    print(" fail..."+response.statusCode.toString());
  }
}

//선택한 리스트 값 받아오기
maternity_selectrow() async {
  final api ='http://211.107.210.141:3000/api/ocr_maternitySelectedRow';
  final data = {
    "ocr_seq":int.parse('1'),
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
}

//수정 후 서버로 다시 전송
maternity_update(String? sow_no, String? sow_birth, String? sow_buy, String? sow_expectdate, String? sow_givebirth, String? sow_totalbaby, String? sow_feedbaby,
    String? sow_babyweight, String? sow_sevrerdate, String? sow_sevrerqty, String? sow_sevrerweight,  String? vaccine1, String? vaccine2,
    String? vaccine3, String? vaccine4, String? memo) async {
  final api ='http://211.107.210.141:3000/api/ocrmaternityUpdate';
  final data = {
    "sow_no": sow_no,
    "sow_birth": sow_birth,
    "sow_buy":sow_buy,
    "sow_expectdate":sow_expectdate,
    "sow_givebirth":sow_givebirth,
    "sow_totalbaby":sow_totalbaby,
    "sow_feedbaby":sow_feedbaby,
    "sow_babyweight":sow_babyweight,
    "sow_sevrerdate":sow_sevrerdate, //이유두수
    "sow_sevrerqty":sow_sevrerqty, //이유날
    "sow_sevrerweight":sow_sevrerweight, //이유체중
    "vaccine1": vaccine1,
    "vaccine2": vaccine2,
    "vaccine3": vaccine3,
    "vaccine4":vaccine4,
    // "ocr_imgpath":'14',
    "memo": memo,};
  final dio = Dio();
  Response response;
  response = await dio.post(api,data: data);
  if(response.statusCode == 200){
//resultToast('Ocr 분만사 update success... \n\n');
  }
}

submit_uploadimg_maternity(dynamic file) async {
  String filename = "no";
  try {
    // print("분만사 이미지 전송 함");
    Response res = await uploading_maternity(file.path);

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

uploading_maternity(String imagePath) async {
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


getimg(String filename) async{
  final api ="http://172.17.66.48:4000/uploads/"+filename;
  final dio = Dio();

  Response response = await dio.get(api);
  // if(response.statusCode == 200) {
  //   // print(" success..."+response.data);
  //   return "end";
  // }else{
  //   print(" fail..."+response.statusCode.toString());
  // }
  // try {
  //   Response response = await dio.get(
  //     api,
  //     onReceiveProgress: showDownloadProgress,
  //     //Received data with List<int>
  //     options: Options(
  //         responseType: ResponseType.bytes,
  //         followRedirects: false,
  //         // validateStatus: (status) { return status<500; }
  //     ),
  //   );
  //   print(response.headers);
  //   File file = File("./hi.jpg");
  //   var raf = file.openSync(mode: FileMode.write);
  //   // response.data is List<int> type
  //   raf.writeFromSync(response.data);
  //   await raf.close();
  // } catch (e) {
  //   print(e);
  // }
  // bool downloading=true;
  // String downloadingStr="No data";
  // double download=0.0;
  // File f;
  // var dir=await getApplicationDocumentsDirectory();
  // f=File("${dir.path}/hi.jpg");
  // String fileName=api.substring(api.lastIndexOf("/")+1);
  // dio.download(api, "${dir.path}/$fileName",onReceiveProgress: (rec,total)
  // {
  // setState(() {
  //   downloading = true;
  //   download = (rec / total) * 100;
  //   print(fileName);
  //   downloadingStr = "Downloading Image : " + (download).toStringAsFixed(0);
  // });
  // });
}

Future<void> downloadFile() async {
  bool downloading = false;

  String progress = '0';

  bool isDownloaded = false;

  String uri = 'http://172.17.66.48:4000/uploads/hi.jpg'; // url of the file to be downloaded

  String filename = 'hi.jpg'; // file name that you desire to keep

  String savePath = await getFilePath(filename);

  Dio dio = Dio();

  dio.download(
    uri,
    savePath,
    onReceiveProgress: (rcv, total) {
      print(
          'received: ${rcv.toStringAsFixed(0)} out of total: ${total
              .toStringAsFixed(0)}');

      if (progress == '100') {
      } else if (double.parse(progress) < 100) {}
    },
    deleteOnError: true,
  ).then((_) {

  });
}

Future<String> getFilePath(uniqueFileName) async {
  String path = '';

  Directory dir = await getApplicationDocumentsDirectory();

  path = '${dir.path}/$uniqueFileName.jpg';

  return path;
}

void showDownloadProgress(received, total) {
  if (total != -1) {
    print((received / total * 100).toStringAsFixed(0) + "%");
  }
}
// Future<String> uploadImage(File file) async {
//   String fileName = file.path.split('/').last;
//   FormData formData = FormData.fromMap({
//     "file":
//     await MultipartFile.fromFile(file.path, filename:fileName),
//   });
//   response = await dio.post("/info", data: formData);
//   return response.data['id'];
// }
//Toast 찍기
resultToast(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      fontSize: 16.0
  );
}