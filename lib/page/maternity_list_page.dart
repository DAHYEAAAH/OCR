import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../functions/functions.dart';
import 'maternity_modify_page.dart';

class MaternityListPage extends StatefulWidget {

  final List<dynamic> listfromserver_list_mat;
  const MaternityListPage(this.listfromserver_list_mat);

  @override
  MaternityListPageState createState() => MaternityListPageState();
}

class MaternityListPageState extends State<MaternityListPage> {
  int num  = 0;

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    final List<int> ocr_seq = <int>[];
    final List<String> sow_no = <String>[];
    final List<String> upload_day = <String>[];

    if(widget.listfromserver_list_mat.isNotEmpty) {
      num = widget.listfromserver_list_mat[0][0];
      for (int i = 1; i < num + 1; i ++) {
        ocr_seq.add(widget.listfromserver_list_mat[i][0]);
        sow_no.add(widget.listfromserver_list_mat[i][1]);
        upload_day.add(widget.listfromserver_list_mat[i][2]);
      }
    }

    return Scaffold(
        appBar: AppBar(title: Text('분만사 기록보기')),
        body: Scrollbar(
            thumbVisibility: true, //always show scrollbar
            thickness: 10, //width of scrollbar
            radius: Radius.circular(20), //corner radius of scrollbar
            scrollbarOrientation: ScrollbarOrientation.right, //which side to show scrollbar
            child:Column(
              children: [
                Row(children: <Widget>[

                  SizedBox(width: 20,),
                  Container(
                      width: 70.0,
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                      alignment: Alignment.center,
                      child: Text("모돈번호", style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),)
                  ),
                  SizedBox(width: 20,),
                  Container(
                      width: 160.0,
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                      alignment: Alignment.center,
                      child: Text("업로드 시간", style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),)
                  ),
                  SizedBox(width: 20,),
                  Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                      width: 50.0,
                      child: Text("수정", style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),)
                  ),
                  SizedBox(width: 10,),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                    child: Text("삭제", style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),)
                  ),
                ]),
                Expanded(
                    child: ListView.separated(
                    padding: const EdgeInsets.all(8),
                    itemCount: ocr_seq.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        // height: 50,
                        // color: Colors.amber[sow_no[index]],
                        // child: Center(child: Text('Entry ${ocr_seq[index]}')),
                        child: (
                            Stack(
                              children: [
                                for(int i = 0 ; i < ocr_seq.length ; i++)
                                  ListTile(
                                      title: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children:[Text(sow_no[index],textAlign: TextAlign.center,), Text(upload_day[index],textAlign: TextAlign.center,)]),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(onPressed: () async{
                                            List list = await maternity_selectrow(ocr_seq[index]);

                                            print("분만사 selectrow 결과");
                                            print(list);

                                            String returnfilepath = await downloadFile("ocrmatimages/"+list[19].toString().split("/").last);

                                            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                                MaternityModifyPage(list, returnfilepath)));
                                            //   print("서버에게 받은 리스트 null 값임");

                                          }, icon: const Icon(Icons.edit)),
                                          IconButton(onPressed: () async {
                                            //사용자가 선택한 리스트 행 삭제
                                            showDialog(context: context,
                                              barrierDismissible: true,
                                              builder: (context) {
                                              // return Expanded(
                                              return AlertDialog(
                                                  scrollable: true,
                                                  title: Text("삭제하시겠습니까?",textAlign: TextAlign.center,),
                                                  content: Column(children: [
                                                    Text("모돈번호 " + sow_no[index]+ "가 삭제됩니다",textAlign: TextAlign.center,),
                                                  ],),
                                                actions: <Widget>[
                                                  ButtonBar(
                                                  alignment: MainAxisAlignment.end,
                                                  // buttonPadding: EdgeInsets.all(1.0),
                                                  children: [
                                                  TextButton( child: const Text('취소'), onPressed: () => Navigator.pop(context, '취소')),
                                                  TextButton(
                                                    onPressed: () async{
                                                      await pregnant_deleterow(ocr_seq[index]); //서버로 사용자가 삭제하길 원한 행의 index값 보내기

                                                      //서버로부터 리스트 다시 받고 다시 화면 새로고침
                                                      List<dynamic> list = await maternity_getocr(); //서버로부터 list page에 띄울 리스트 받아오기
                                                      print("maternity return get ocr->");
                                                      Navigator.of(context).popUntil((route) => route.isFirst);
                                                      print("pop 함");
                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => MaternityListPage(list)));
                                                    },
                                                    child: const Text('삭제'),
                                                  ),
                                                  ]
                                                  )
                                                ]
                                              );
                                            }
                                            );
                                            }, icon: const Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                // Container(
                                //   height: 1,
                                //   color: Colors.black,
                                // )
                              ],
                            )
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) => const Divider(),
                    )
                )
              ],
            )
        )
    );
  }
}


