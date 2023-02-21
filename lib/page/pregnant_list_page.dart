import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../functions/functions.dart';
import '../page/pregnant_modify_page.dart';

class PregnantListPage extends StatefulWidget {
  String companyCode;
  PregnantListPage({Key? key, required this.companyCode, this.title}) : super(key: key);
  final String? title;

  @override
  PregnantListPageState createState() => PregnantListPageState();
}

class PregnantListPageState extends State<PregnantListPage> {
  int num  = 0;
  late List listfromserver_list_pre;
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
    listfromserver_list_pre = await pregnant_getocr(widget.companyCode);
    //서버로부터 값 받아오기
    setState(() {
      // print("hey");
      num = listfromserver_list_pre[0][0];
      sow_no.add("모돈번호");
      upload_day.add("업로드 시간");
      for (int i = 1; i < num + 1; i ++) {
        ocr_seq.add(listfromserver_list_pre[i][0]);
        sow_no.add(listfromserver_list_pre[i][1]);
        upload_day.add(listfromserver_list_pre[i][2]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();

    return MaterialApp(
        home: Scaffold(
            // appBar: AppBar(title: Text('임신사 기록보기')),
            body: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        _createDataTable(),
                      ],
                    ),
                  )
                ]
            )
        )
    );
  }
  Widget _createDataTable() {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 20,),
          Text('임신사 List',textAlign: TextAlign.start,style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black54),),
          SizedBox(height: 10,),
          FittedBox(
              fit: BoxFit.fitWidth,
              child: DataTable(
                border: TableBorder.all(
                  width: 1,
                  borderRadius: BorderRadius.circular(10),
                ),
                columns: _createColumns(),
                // columnSpacing: 30,
                rows: _createRows(),
                headingTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,

                ),
                headingRowColor: MaterialStateProperty.resolveWith(
                        (states) => Colors.grey
                ),
              )
          )
        ],
      ),
    );
  }

  List<DataColumn> _createColumns() {
    return [
      DataColumn(label: Expanded(child: Text( '모돈번호', textAlign: TextAlign.center,))),
      DataColumn(label: Expanded(child: Text( '업로드 시간', textAlign: TextAlign.center,))),
      DataColumn(label: Expanded(child: Text( 'Option', textAlign: TextAlign.center,))),
    ];
  }


  List<DataRow> _createRows() {
    List<DataRow> list = <DataRow>[];
    for (int i = 0; i < ocr_seq.length; i++) {
      list.add(
        DataRow(cells: [
          DataCell(
              Container(
                // width: 70,
                child: Row(
                  children: [
                    OutlinedButton(
                      onPressed: () {
                      },
                      child: Text(sow_no[i+1]),
                      style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(15))
                          )
                      ),
                    ),
                  ],
                ),
              )
          ),
          DataCell(
              Container(
                // width: 70,
                child: Row(
                  children: [
                    OutlinedButton(
                      onPressed: () {
                      },
                      child: Text(upload_day[i+1]),
                      style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(15))
                          )
                      ),
                    ),
                  ],
                ),
              )
          ),
          DataCell(
              Container(
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PregnantModifyPage(widget.companyCode,ocr_seq[i])));
                        },
                      child: Ink.image(
                        image: AssetImage('assets/wrench.png'),
                        // fit: BoxFit.cover,
                        width: 15,
                        height: 15,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        _showdialogDelete(context,i,sow_no[i+1]);
                      },
                      child: Ink.image(
                        image: AssetImage('assets/trash-bin.png'),
                        // fit: BoxFit.cover,
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ],
                ),
              )
          ),
        ]),
      );
    }
    return list;
  }
  Future<dynamic> _showdialogDelete(BuildContext context,int index,String name) async{
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(name+' 삭제'),
        content: Text('선택한 모돈을 삭제하시겠습니까?'),

        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () async => {
                    Navigator.pop(context, false),
                  await pregnant_deleterow(
                  widget.companyCode,
                  ocr_seq[index]),//서버로 사용자가 삭제하길 원한 행의 index값 보내기
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>
                  PregnantListPage(companyCode: widget.companyCode,)))


              },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  child: Text('삭제')),
              SizedBox(width: 10,),
              ElevatedButton(
                  onPressed: () => {
                    Navigator.pop(context, false),
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    foregroundColor: Colors.black54,
                    primary: Colors.white,
                  ),
                  child: Text('취소')
              ),
            ],
          )
        ],
      ),
    );
  }

}
