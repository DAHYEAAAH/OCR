import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:last_ocr/functions/functions.dart';
import 'package:last_ocr/page/pregnant_modify_page.dart';

class PregnantListPage extends StatefulWidget {

  final List<dynamic> listfromserver_list_pre ;
  const PregnantListPage(this.listfromserver_list_pre);

  @override
  PregnantListPageState createState() => PregnantListPageState();
}

class PregnantListPageState extends State<PregnantListPage> {
  int num  = 0;

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    final List<int> ocr_seq = <int>[];
    final List<String> sow_no = <String>[];
    final List<String> upload_day = <String>[];

    if(widget.listfromserver_list_pre.isNotEmpty) {
      num = widget.listfromserver_list_pre[0][0];
      for (int i = 1; i < num + 1; i ++) {
        ocr_seq.add(widget.listfromserver_list_pre[i][0]);
        sow_no.add(widget.listfromserver_list_pre[i][1]);
        upload_day.add(widget.listfromserver_list_pre[i][2]);
      }
    }

    return Scaffold(
        appBar: AppBar(title: Text('임신사 기록보기')), //앱 상단의 제목 :  "분만사 기록보기"
        body: Scrollbar( //앱의 내용을 스크롤로 보기 위해
            thumbVisibility: true, //always show scrollbar
            thickness: 10, //width of scrollbar
            radius: Radius.circular(20), //corner radius of scrollbar
            scrollbarOrientation: ScrollbarOrientation.right, //which side to show scrollbar
            child: Column(
                children:[
                  Row(
                        children: <Widget>[
                          SizedBox(width: 20,),
                          Container(
                            width: 70.0,
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                            alignment: Alignment.center,
                            child: Text("모돈번호", style: TextStyle(fontSize: 18),)
                          ),
                          SizedBox(width: 20,),
                          Container(
                              width: 160.0,
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                              alignment: Alignment.center,
                              child: Text("업로드 시간", style: TextStyle(fontSize: 18),)
                          ),
                          SizedBox(width: 20,),
                          Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                              width: 50.0,
                              child: Text("수정", style: TextStyle(fontSize: 18),)
                          ),
                          SizedBox(width: 10,),
                          Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                              child: Text("삭제", style: TextStyle(fontSize: 18),)
                          ),
                        ],
                      ),
                  Expanded(
                      child:ListView.separated( //리스트 뷰에서 리스트 별 나누기
                          padding: const EdgeInsets.all(8), //간격 : 8
                          itemCount: ocr_seq.length, //ocr_seq.길이만큼 리스트뷰의 리스트 구분하기
                          itemBuilder: (BuildContext context, int index) {
                            return Container( //리스트별 Container로 감싸기
                              // height: 50,
                              // color: Colors.amber[sow_no[index]],
                              // child: Center(child: Text('Entry ${ocr_seq[index]}')),
                              child: (
                                  Stack(
                                    children: [
                                      ListTile(
                                          // title: Text("모돈 번호 :" + sow_no[index].toString()),
                                        title: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children:[Text(sow_no[index]), Text(upload_day[index])]),
                                        trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              //편집 아이콘
                                              IconButton(onPressed: () async {
                                              List list = await pregnant_selectrow(ocr_seq[index]); //사용자가 선택한 행의 인덱스값 서버로 넘기고, 받은 리스트 list에 넣기
                                              print("임신사 selectrow 결과");
                                              print(list);

                                              String returnfilepath = await downloadFile("ocrpreimages/"+list[17].toString().split("/").last); //이미지 다운로드

                                              Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                                  PregnantModifyPage(list,returnfilepath))); //PregnantModifyPage로 변환하면서, list와 이미지경로 전달
                                              }, icon: const Icon(Icons.edit)), //edit icon 사용

                                              //삭제 아이콘
                                              IconButton(onPressed: () async {
                                                //사용자가 선택한 리스트 행 삭제
                                                await pregnant_deleterow(ocr_seq[index]); //서버로 사용자가 삭제하길 원한 행의 index값 보내기

                                                //서버로부터 리스트 다시 받고 다시 화면 새로고침
                                                List<dynamic> list = await pregnant_getocr(); //서버로부터 list page에 띄울 리스트 받아오기
                                                print("pregnant return get ocr->");
                                                Navigator.of(context).popUntil((route) => route.isFirst);
                                                print("pop 함");
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => PregnantListPage(list)));

                                              }, icon: const Icon(Icons.delete)), //delete icon 사용
                                            ],
                                          ),
                                        ) ,
                                      // Container( //리스트 감싸기
                                      //   height: 1, //높이 1
                                      //   color: Colors.black, //검은색 선으로
                                      // )
                                    ],
                                  )
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) => const Divider(), //구분선 생성하기
                        )
                  )
                ]
            )
        )
    );
  }
}
