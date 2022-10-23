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

    if(widget.listfromserver_list_pre.isNotEmpty) {
      num = widget.listfromserver_list_pre[0][0];
      for (int i = 1; i < num + 1; i ++) {
        ocr_seq.add(widget.listfromserver_list_pre[i][0]);
        sow_no.add(widget.listfromserver_list_pre[i][1]);
      }
    }

    return Scaffold(
        appBar: AppBar(title: Text('분만사 기록보기')),
        body: Scrollbar(
            thumbVisibility: true, //always show scrollbar
            thickness: 10, //width of scrollbar
            radius: Radius.circular(20), //corner radius of scrollbar
            scrollbarOrientation: ScrollbarOrientation.right, //which side to show scrollbar
            child:ListView.separated(
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
                              // title: Text("모돈 번호 :" + sow_no[index].toString()),
                              title: Text("모돈 번호 :" + sow_no[index]),

                              //subtitle: Text(sow_no[index]),
                              trailing: Icon(Icons.keyboard_arrow_right),
                              onTap: () async {
                                List list = await pregnant_selectrow(ocr_seq[index]);

                                print("임신사 selectrow 결과");
                                print(list);

                                String returnfilepath = await downloadFile("ocrpreimages/"+list[17].toString().split("/").last);

                                Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                    PregnantModifyPage(list,returnfilepath)));
                                //   print("서버에게 받은 리스트 null 값임");
                              },
                            ) ,
                          Container(
                            height: 1,
                            color: Colors.black,
                          )
                        ],
                      )
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) => const Divider(),
            )
        )
    );
  }
}