import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_rx/get_rx.dart';
import 'package:last_ocr/entities/Ocr_pregnant.dart';

class OcrApi extends StatefulWidget {
  const OcrApi({Key? key}) : super(key: key);

  @override
  State<OcrApi> createState() => _OcrApiState();
}

class _OcrApiState extends State<OcrApi> {
  var pregnants = <Ocr_pregnant>[].obs;
  @override
  Widget build(BuildContext context) {
    return Container(
      child:Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                // flex: 1,
                child: Container(
                  height: 40,
                  child: ElevatedButton.icon(
                    onPressed: () async{
                      final api ='http://211.107.210.141:3000/api/ocrpregnatInsert';
                      final data = {
                        "sow_no":'2',
                        "sow_birth":'2',
                        "sow_buy":'3',
                        "sow_estrus":'4',
                        "sow_cross":'5',
                        "boar_fir":'6',
                        "boar_sec":'7',
                        "checkdate":'8',
                        "expectdate":'9',
                        "vaccine1":'10',
                        "vaccine2":'11',
                        "vaccine3":'12',
                        "vaccine4":'13',
                        "ocr_imgpath":'14',
                        "memo":'16',
                      };
                      final dio = Dio();
                      Response response;
                      response = await dio.post(api,data: data);
                      if(response.statusCode == 200){
                        resultToast('Ocr 임신사 insert success... \n\n');
                      }
                    },
                    icon: Icon(Icons.pregnant_woman),
                    label: Text("임신사 OCR Insert"),
                  ),
                ),
              ),

              SizedBox(
                width: 20,
              ),
              Flexible(
                // flex: 1,
                child: Container(
                  height: 40,
                  child: ElevatedButton.icon(
                    onPressed: () async{
                      final api ='http://211.107.210.141:3000/api/getOcr_pregnant';
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
                    },
                    icon: Icon(Icons.read_more),
                    label: Text("임신사 OCR  Read"),
                  ),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Flexible(
                // flex: 1,
                child: Container(
                  height: 40,
                  child: ElevatedButton.icon(
                    onPressed: () async{
                      final api ='http://211.107.210.141:3000/api/ocr_pregnantSelectedRow';
                      final data = {
                        "ocr_seq":1, //pk
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
                    },
                    icon: Icon(Icons.autofps_select),
                    label: Text("임신사 OCR  Selected Read"),
                  ),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Flexible(
                // flex: 1,
                child: Container(
                  height: 40,
                  child: ElevatedButton.icon(
                    onPressed: () async{
                      final api ='http://211.107.210.141:3000/api/ocrpregnatUpdate';
                      final data = {
                        "ocr_seq":'2',
                        "sow_no":'2',
                        "sow_birth":'5',
                        "sow_buy":'6',
                        "sow_estrus":'7',
                        "sow_cross":'8',
                        "boar_fir":'9',
                        "boar_sec":'10',
                        "checkdate":'11',
                        "expectdate":'12',
                        "vaccine1":'13',
                        "vaccine2":'14',
                        "vaccine3":'15',
                        "vaccine4":'16',
                        // "ocr_imgpath":'17',
                        "memo":'18',
                      };
                      final dio = Dio();
                      Response response;
                      response = await dio.post(api,data: data);
                      if(response.statusCode == 200){
                        resultToast('Ocr 임신사 update success... \n\n');
                      }
                    },
                    icon: Icon(Icons.pregnant_woman),
                    label: Text("임신사 OCR Update"),
                  ),
                ),
              ),
            ],
          ),
//         -------------------------------------------------------
          SizedBox(height: 50,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                // flex: 1,
                child: Container(
                  height: 40,
                  child: ElevatedButton.icon(
                    onPressed: () async{
                      final api ='http://211.107.210.141:3000/api/ocrmaternityInsert';
                      final data = {
                        "sow_no":'2',
                        "sow_birth":'2',
                        "sow_buy":'3',
                        "sow_expectdate":'4',
                        "sow_givebirth":'5',
                        "sow_totalbaby":'6',
                        "sow_feedbaby":'7',
                        "sow_babyweight":'8',
                        "sow_sevrerdate":'9',
                        "sow_sevrerqty":'9',
                        "sow_sevrerweight":'9',
                        "vaccine1":'10',
                        "vaccine2":'11',
                        "vaccine3":'12',
                        "vaccine4":'13',
                        "ocr_imgpath":'14',
                        "memo":'16',
                      };
                      final dio = Dio();
                      Response response;
                      response = await dio.post(api,data: data);
                      if(response.statusCode == 200){
                        resultToast('Ocr 분만사 insert success... \n\n');
                      }
                    },
                    icon: Icon(Icons.pregnant_woman),
                    label: Text("분만사 OCR Insert"),
                  ),
                ),
              ),

              SizedBox(
                width: 20,
              ),
              Flexible(
                // flex: 1,
                child: Container(
                  height: 40,
                  child: ElevatedButton.icon(
                    onPressed: () async{
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
                    },
                    icon: Icon(Icons.read_more),
                    label: Text("분만사 OCR  Read"),
                  ),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Flexible(
                // flex: 1,
                child: Container(
                  height: 40,
                  child: ElevatedButton.icon(
                    onPressed: () async{
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
                    },
                    icon: Icon(Icons.autofps_select),
                    label: Text("분만사 OCR  Selected Read"),
                  ),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Flexible(
                // flex: 1,
                child: Container(
                  height: 40,
                  child: ElevatedButton.icon(
                    onPressed: () async{
                      final api ='http://211.107.210.141:3000/api/ocrmaternityUpdate';
                      final data = {
                        "ocr_seq":'1',
                        "sow_no":'2',
                        "sow_birth":'5',
                        "sow_buy":'6',
                        "sow_expectdate":'4',
                        "sow_givebirth":'5',
                        "sow_totalbaby":'6',
                        "sow_feedbaby":'7',
                        "sow_babyweight":'8',
                        "sow_sevrerdate":'9',
                        "sow_sevrerqty":'9',
                        "sow_sevrerweight":'9',
                        "vaccine1":'10',
                        "vaccine2":'11',
                        "vaccine3":'12',
                        "vaccine4":'13',
                        // "ocr_imgpath":'14',
                        "memo":'22',
                      };
                      final dio = Dio();
                      Response response;
                      response = await dio.post(api,data: data);
                      if(response.statusCode == 200){
                        resultToast('Ocr 분만사 update success... \n\n');
                      }
                    },
                    icon: Icon(Icons.pregnant_woman),
                    label: Text("분만사 OCR Update"),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
}

