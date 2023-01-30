import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../functions/functions.dart';
import 'maternity_modify_page.dart';

class MaternityListPage extends StatefulWidget {

  const MaternityListPage({Key? key, this.title}) : super(key: key);
  final String? title;


  @override
  MaternityListPageState createState() => MaternityListPageState();
}

class MaternityListPageState extends State<MaternityListPage> {
  int num  = 0;
  late List listfromserver_list_mat;
  final List<int> ocr_seq = <int>[];
  final List<String> sow_no = <String>[];
  final List<String> upload_day = <String>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    prepareList();
  }
  prepareList() async{
    listfromserver_list_mat = await maternity_getocr();
    setState(() {
      // print(listfromserver_list_mat);
      num = listfromserver_list_mat[0][0];
      sow_no.add("모돈번호");
      upload_day.add("업로드 시간");
      for (int i = 1; i < num + 1; i ++) {
        ocr_seq.add(listfromserver_list_mat[i][0]);
        sow_no.add(listfromserver_list_mat[i][1]);
        upload_day.add(listfromserver_list_mat[i][2]);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();

    return Scaffold(
        appBar: AppBar(title: Text('분만사 기록보기')), //앱 상단의 제목 :  "분만사 기록보기"
        body: Scrollbar( //앱의 내용을 스크롤로 보기 위해
            thumbVisibility: true, //always show scrollbar
            thickness: 10, //width of scrollbar
            radius: Radius.circular(20), //corner radius of scrollbar
            scrollbarOrientation: ScrollbarOrientation.right, //which side to show scrollbar
            child: Column(
                children:[
                  Expanded(
                      child:ListView.separated( //리스트 뷰에서 리스트 별 나누기
                        padding: const EdgeInsets.all(8), //간격 : 8
                        itemCount: sow_no.length, //ocr_seq.길이만큼 리스트뷰의 리스트 구분하기
                        itemBuilder: (BuildContext context, int index) {
                          return Container( //리스트별 Container로 감싸기
                            child: (
                                Stack(
                                  children: [
                                    // for(int i = 0 ; i < ocr_seq.length ; i++)
                                    GestureDetector(
                                      onTap: () async {
                                        // print(index-1);
                                        if(index-1 != -1) {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => MaternityModifyPage(ocr_seq[index-1]))); //PregnantModifyPage로 변환하면서, list와 이미지경로 전달
                                        }
                                        },
                                        child: ListTile(
                                          title: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children:[
                                                Flexible(
                                                  flex: 2,
                                                  fit: FlexFit.tight,
                                                  child: Container(
                                                    child: Text(sow_no[index],textAlign: TextAlign.center),
                                                    // color: Colors.blue,
                                                  ),
                                                ),
                                                Flexible(
                                                  flex: 4,
                                                  fit: FlexFit.tight,
                                                  child: Container(
                                                    child: Text(upload_day[index],textAlign: TextAlign.center),
                                                    // color: Colors.blue,
                                                  ),
                                                ),
                                                if(index!=0)
                                                  Flexible(fit: FlexFit.tight, child: IconButton(onPressed: () async {
                                                    //사용자가 선택한 리스트 행 삭제
                                                    showDialog(context: context,
                                                        barrierDismissible: true,
                                                        builder: (context) {
                                                          // return Expanded(
                                                          return AlertDialog(
                                                              scrollable: true,
                                                              title: Text("삭제하시겠습니까?", textAlign: TextAlign.center,),
                                                              content: Column(
                                                                children: [
                                                                  Text("",),
                                                                  Text("모돈번호 " + sow_no[index] + "가 삭제됩니다", textAlign: TextAlign.center,),
                                                                ],),
                                                              actions: <Widget>[
                                                                ButtonBar(
                                                                    alignment: MainAxisAlignment.end,
                                                                    // buttonPadding: EdgeInsets.all(1.0),
                                                                    children: [
                                                                      TextButton(
                                                                        child: const Text('취소'),
                                                                        onPressed: () => Navigator.pop(context, '취소'),
                                                                      ),
                                                                      TextButton(
                                                                        onPressed: () async {
                                                                          await maternity_deleterow(ocr_seq[index-1]); //서버로 사용자가 삭제하길 원한 행의 index값 보내기

                                                                          Navigator.of(context).popUntil((route) => route.isFirst);
                                                                          // print("pop 함");
                                                                          Navigator.push(context, MaterialPageRoute(builder: (context) => MaternityListPage()));
                                                                        },
                                                                        child: const Text('삭제'),
                                                                      ),
                                                                    ]
                                                                )
                                                              ]
                                                          );
                                                          // child: null,;
                                                          // )
                                                        }
                                                    );
                                                  },icon: const Icon(Icons.delete, color: Colors.black,)),)
                                                else
                                                  Flexible(fit: FlexFit.tight, child: Text("삭제",textAlign: TextAlign.center))
                                              ]
                                          )
                                        ) ,
                                    ),
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