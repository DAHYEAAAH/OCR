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

late final domain = "https://www.dfxsoft.com/api/";



// 서버로 현재 날짜를 보내고 임신사의 교배복수 총합 받기
send_date_pregnant(List sendlist) async {
  print("send_date_pregnant");
  final api = domain+'ocrPregnantSendDate';
  final dio = Dio();

  final data={
    'everysunday':sendlist
  };
  Response response;
  // print(data);
  response = await dio.post(api, data:data);
  if(response.statusCode==200){
    print("날짜보내기 성공");
  }
  else{
    print("날짜보내기 실패");
  }
  print("pre-returndata");
  print(response.data);

  List<dynamic> li = response.data;

  return li;
}

// 서버로 현재 날짜를 보내고 분만사의 총산자수, 포유개시두수, 이유두수의 총합 받기
send_date_maternity(List sendlist) async {
  // print("materntiy");
  final api = domain+'ocrMaternitySendDate';
  final dio = Dio();

  final data={
    'everysunday':sendlist
  };
  Response response;
  print("send_date_maternity");
  // print(data);
  response = await dio.post(api, data:data);
  if(response.statusCode==200){
    print("날짜보내기 성공");
  }
  else{
    print("날짜보내기 실패");
  }
  print("returndata");
  print(response.data);
  List<dynamic> li = response.data;
  return li;
}

// 서버에 현재 날짜와 교배복수, 총산자수, 포유개시두수, 이유두수의 목표값 보내고 받기
ocrTargetInsertUpdate(String yyyy, String mm, String sow_totalbaby, String sow_feedbaby, String sow_sevrer, String sow_cross) async {
  print("ocrTargetInsertUpate");
  final api = domain+'ocrTargetInsertUpdate';
  final dio = Dio();

  final data={
    'yyyy': yyyy,
    'mm':mm,
    'sow_totalbaby':sow_totalbaby,
    'sow_feedbaby' : sow_feedbaby,
    'sow_sevrer' : sow_sevrer,
    'sow_cross' : sow_cross,
  };
  Response response;
  print(data);
  response = await dio.post(api, data:data);
  if(response.statusCode==200){
    print("목표값보내기 성공");
  }
  else{
    print("목표값보내기 실패");
  }
  print("returndata-목표값");
  print(response.data);
}

// 서버에 현재 날짜 보내고 목표값 받기
ocrTargetSelectedRow(String yyyy, String mm) async {
  final api = domain+'ocrTargetSelectedRow';
  final dio = Dio();

  final data={
    'yyyy': yyyy,
    'mm':mm,
  };
  Response response;
  print(data);
  response = await dio.post(api, data:data);
  if(response.statusCode==200){
    print("목표값받기 성공");
  }
  else{
    print("목표값받기 실패");
  }
  print("returndata-목표값");
  print(response.data);

  // 총산자수, 포유, 이유, 교배 순으로 계산 값을 받아온다
  return response.data;
}

// 서버로 임신사 사진 보내는 api
Future<List> uploadimg_pregnant(File file)async{
  print("uploadimg_pregnant");
  final api = 'http://192.168.1.39:3000/api/ocrImageUpload';
  final dio = Dio();

  DateTime currentTime = await NTP.now();
  currentTime = currentTime.toUtc().add(Duration(hours: 9));
  String formatDate = DateFormat('yyyyMMddHHmm').format(currentTime); //format변경
  String fileName = "pre"+formatDate+'.jpg';
  print(api);
  print(fileName);
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

// 선택한 임신사 기록 불러오기, ocr_seq를 보내고 그 값을 받아옴
pregnant_selectrow(int num) async{
  final api =domain+'ocr_pregnantSelectedRow';
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

// homepage img 임신사 전체 기록 불러오기
homepage_img() async {
  List list = [];
  final api =domain+'launchersGetList';
  final dio = Dio();
  Response response = await dio.get(api);

  if(response.statusCode == 200) {
    List<dynamic> result = response.data;
  }
  else{
    print(" fail..."+response.statusCode.toString());
  }

  for(int i = 0 ; i < 26 ; i++){
    list.add(response.data[i]);
  }

  print(list);

  return list;
}


pregnant_deleterow(int num) async{
  final api =domain+'ocr_pregnantDelete';
  final data = {
    "ocr_seq": num, //pk
  };
  final dio = Dio();
  Response response;
  print("행 삭제 합니다");
  response = await dio.post(api,data: data);
  print(response.data);
  if(response.statusCode == 200) {
    print("행 삭제");
    print("*******************");
  }else{
    print(" fail..."+response.statusCode.toString());
  }
  print(response);
}

// 서버에서 이미지 받는 api
Future<String> downloadFile(String imgname) async {
  String returnfilepath = "";
  Dio dio = Dio();
  try {
    var serverurl = domain+"ocrGetImage/"+imgname;
    print(serverurl);
    var dir = await getTemporaryDirectory();
    // var dir = await getApplicationDocumentsDirectory();
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

// 임신사 전체 기록 불러오기
pregnant_getocr() async {
  var pregnants = <Ocr_pregnant>[].obs;
  List<int> list_ocr_seq = [];
  List<String> list_sow_no = [];
  List<String> list_upload_day = [];
  List<dynamic> list_add = [];

  final api =domain+'getOcr_pregnant';
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
        list_upload_day.add(pregnants.length.toString());
      }
      print(" success!"+ pregnants[i].ocr_seq.toString()+" " +pregnants[i].sow_no.toString());
      list_ocr_seq.add(pregnants[i].ocr_seq!.toInt());
      list_sow_no.add(pregnants[i].sow_no!.toString());
      list_upload_day.add(pregnants[i].input_date.toString()+" "+pregnants[i].input_time.toString().split(":")[0]+":"+pregnants[i].input_time.toString().split(":")[1]);
    }
  }
  else{
    print(" fail..."+response.statusCode.toString());
  }

  for( int i=0; i< list_ocr_seq.length; i++){
    list_add += [[list_ocr_seq[i],list_sow_no[i],list_upload_day[i]]];
  }

  print(list_add);
  return list_add;
}

// 임신사 기록 지우기
delete_pregnant() async{
  final api =domain+'ocrDeleteAll';

  final dio = Dio();
  Response response;
  response = await dio.get(api);
  if(response.statusCode == 200) {
    print("successfully deleted");
  }else{
    print("failed to delete");
  }
}

// 서버로 분만사 사진 보내는 api
Future<List> uploadimg_maternity(File file)async{
  final api =domain+'ocrImageUpload';
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

// 선택한 분만사 기록 불러오기, ocr_seq를 보내고 그 값을 받아옴
maternity_selectrow(int num) async {
  final api =domain+'ocr_maternitySelectedRow';
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

// 분만사 전체 기록 불러오기
maternity_getocr() async {
  var maternity = <Ocr_maternity>[].obs;
  List<int> list_ocr_seq = [];
  List<String> list_sow_no = [];
  List<String> list_upload_day = [];
  List<dynamic> list_add = [];

  final api =domain+'getOcr_maternity';
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
        list_upload_day.add(maternity.length.toString());
      }
      print(" success!"+ maternity[i].ocr_seq.toString()+" " +maternity[i].sow_no.toString());
      list_ocr_seq.add(maternity[i].ocr_seq!.toInt());
      list_sow_no.add(maternity[i].sow_no!.toString());
      list_upload_day.add(maternity[i].input_date.toString()+" "+maternity[i].input_time.toString().split(":")[0]+":"+maternity[i].input_time.toString().split(":")[1]);

    }
  }
  else{
    print(" fail..."+response.statusCode.toString());
  }

  for( int i=0; i< list_ocr_seq.length; i++){
    list_add += [[list_ocr_seq[i],list_sow_no[i],list_upload_day[i]]];
  }

  print(list_add);
  return list_add;
}
maternity_deleterow(int num) async{
  final api =domain+'ocr_maternityDelete';
  final data = {
    "ocr_seq": num, //pk
  };
  final dio = Dio();
  Response response;
  print("행 삭제 합니다");
  response = await dio.post(api,data: data);
  print(response.data);
  if(response.statusCode == 200) {
    print("행 삭제");
    print("*******************");
  }else{
    print(" fail..."+response.statusCode.toString());
  }
  print(response);
}



// 결과를 toast로 띄우는 함수
resultToast(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      fontSize: 16.0
  );
}

preparegraph() async{
  var mating_week = List<double>.filled(5, 0, growable: true);
  var feedbaby_week = List<double>.filled(5, 0, growable: true);
  var sevrer_week = List<double>.filled(5, 0, growable: true);
  var totalbaby_week = List<double>.filled(5, 0, growable: true);

  var goals = List<String>.filled(6, "");

  var thisyear = DateTime.now().year;   // 년도
  var thismonth = DateTime.now().month; // 월
  List li=[];

  var now = DateTime(2022,thismonth,1); //선택한 달의 1일을 기준날짜로 잡음

  var firstSunday = DateTime(now.year, now.month, now.day - (now.weekday - 0)); //기준날짜가 속한 주의 일요일을 구함

  if(firstSunday.day>now.day){ // 찾아낸 일요일이 이전달일경우 +7일을 함 (ex)10.1일이 속한 일요일 9월25일 =(변경)=> 10월 2일)
    firstSunday = firstSunday.add(const Duration(days: 7));
  }

  var sunday = firstSunday;
  List templist=[]; // [시작날짜,끝날짜]를 저장하기 위한 임시 리스트
  templist.add(DateFormat('yyyy-MM-dd').format(sunday.add(const Duration(days:-6)))); //시작날짜계산법 : 일요일날짜-6
  templist.add(DateFormat('yyyy-MM-dd').format(sunday)); // 끝날짜
  li.add(templist); // [시작날짜,끝날짜] 형태로 리스트에 추가

  while(true){
    List templist=[];
    var nextsunday = sunday.add(const Duration(days: 7)); // 다음주 일요일 계산법 : 일요일+7
    if(nextsunday.day<sunday.day){ // 다음주 일요일이 다음달에 속할 경우 리스트에 추가하지 않고 반복문을 종료시킴.
      break;
    }
    templist.add(DateFormat('yyyy-MM-dd').format(nextsunday.add(const Duration(days:-6)))); // 시작날짜계산법 : 다음주일요일-6
    templist.add(DateFormat('yyyy-MM-dd').format(nextsunday));  // 끝날짜
    li.add(templist); // [시작날짜, 끝날짜] 형태로 리스트에 추가
    sunday = nextsunday; // 그 다음주를 계산하기 위해 sunday를 nextsunday로 변경
  }
  print(li);

  var pregnantdata= await send_date_pregnant(li);
  print(pregnantdata.length);
  for(int i=0; i<li.length; i++){
    if(pregnantdata[i]['sow_cross']==null){
      mating_week[i]=0;
    }else{
      mating_week[i] = pregnantdata[i]['sow_cross'];
    }
  }
  print(mating_week);

  var maternitydata= await send_date_maternity(li);
  print(maternitydata.length);
  for(int i=0; i<li.length; i++){
    if(maternitydata[i]['feedbaby']==null){
      feedbaby_week[i]=0;
    } else{
      feedbaby_week[i] = maternitydata[i]['feedbaby'];
    }
    if(maternitydata[i]['sevrer']==null){
      sevrer_week[i]=0;
    }else{
      sevrer_week[i] = maternitydata[i]['sevrer'];
    }
    if(maternitydata[i]['totalbaby']==null){
      totalbaby_week[i]=0;
    }else{
      totalbaby_week[i] = maternitydata[i]['totalbaby'];
    }
  }
  var targetdata= await ocrTargetSelectedRow(thisyear.toString(), thismonth.toString().padLeft(2, "0").toString());
  if(targetdata==null){
    goals[0]=now.year.toString();
    goals[1]=now.month.toString();
    goals[2]='0';
    goals[3]='0';
    goals[4]='0';
    goals[5]='0';
  }else {
    goals[0] = targetdata[0];
    goals[1] = targetdata[1];
    goals[2] = targetdata[2];
    goals[3] = targetdata[3];
    goals[4] = targetdata[4];
    goals[5] = targetdata[5];
    print(goals);
  }
  li.clear();
  return [mating_week,sevrer_week,totalbaby_week,feedbaby_week, goals];
}