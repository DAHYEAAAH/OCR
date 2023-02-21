import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../entities/Vender.dart';
import '../locator.dart';
import '../routing/route_names.dart';
import '../services/navigation_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' hide Response;
import 'package:flutter/services.dart';


class VenderList extends StatefulWidget {
  // @override
  // _CompanyinfoList createState() => _CompanyinfoList();
  @override
  State<VenderList> createState() => _VenderListList();
}

class _VenderListList extends State<VenderList> {
  var venders = <Vender>[].obs;
  var dia_code;
  var dia_name;
  var dia_businessno;
  var dia_ceoname;
  var dia_tel;

  @override
  void initState() {
    super.initState();
    venderList();
  }
  @override
  void dispose(){
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return
      MaterialApp(
        home:
        Scaffold(
          body:
          Column(children: [
            Expanded(child: ListView(
              children: [
                _createDataTable(),
              ],
            ),
          )
          ])
        )
    );
  }

  Widget _createDataTable() {
    return Container(
        child: Column(
          children: [
            SizedBox(height: 20,),
            Text('거래처 List',textAlign: TextAlign.start,style: TextStyle(
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
      DataColumn(label: Expanded(child: Text( '코드', textAlign: TextAlign.center,))),
      DataColumn(label: Expanded(child: Text( '거래처명', textAlign: TextAlign.center,))),
      DataColumn(label: Expanded(child: Text( '사업자번호', textAlign: TextAlign.center,))),
      DataColumn(label: Expanded(child: Text( '대표자명', textAlign: TextAlign.center,))),
      DataColumn(label: Expanded(child: Text( '전화번호', textAlign: TextAlign.center,))),
      DataColumn(label: Expanded(child: Text( 'Option', textAlign: TextAlign.center,))),
    ];
  }


  List<DataRow> _createRows() {
    List<DataRow> list = <DataRow>[];
    for (int i = 0; i < venders.length; i++) {
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
                      child: Text("${venders[i].code.toString()}"),
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
                // width: 110,
                child: TextFormField(
                  textAlign: TextAlign.center,
                  initialValue: '${venders[i].name}',
                  decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(20.0),
                    ),
                  ),
                  onChanged: (text){
                    venders[i].name = text;
                  },
                )
            ),
          ),
          DataCell(
            Container(
                // width: 90,
                child: TextFormField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  initialValue: '${venders[i].businessno}',
                  decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(20.0),
                    ),
                  ),
                  onChanged: (text){
                    venders[i].businessno = text;
                  },
                )
            ),
          ),
          DataCell(
            Container(
                // width: 90,
                child: TextFormField(
                  textAlign: TextAlign.center,
                  initialValue: '${venders[i].ceoname}',
                  decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(20.0),
                    ),
                  ),
                  onChanged: (text){
                    venders[i].ceoname = text;
                  },
                )
            ),
          ),
          DataCell(
            Container(
                // width: 90,
                child: TextFormField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  initialValue: '${venders[i].tel}',
                  decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(20.0),
                    ),
                  ),
                  onChanged: (text){
                    venders[i].tel = text;
                  },
                )
            ),
          ),

          DataCell(
              Container(
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        _showdialogUpdateContent(context,venders[i].code!, venders[i].name!,venders[i].businessno!,venders[i].ceoname!,venders[i].tel!);
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
                        _showdialogDelete(context,venders[i].code!,venders[i].name!);
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

  Future<void> venderList() async{
    final api ='https://www.dfxsoft.com/api/getVenderAll';
    final dio = Dio();
    Response response = await dio.get(api);
    if(response.statusCode == 200) {
      setState(() {
        List<dynamic> result = response.data;
        venders.assignAll(result.map((data) => Vender.fromJson(data)).toList());
        venders.refresh();
      });
    }
  }

  Future<dynamic> _showdialogUpdateContent(BuildContext context,int code,String name,String businessno,String ceoname,String tel) async{
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(name+' 수정'),
        content: Text('변경된 정보를 수정하시겠습니까?'),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () => {
                    Navigator.pop(context, false),
                    venderUpdate(code,name,businessno,ceoname,tel)
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  child: Text('수정')),
              SizedBox(width: 10,),
              ElevatedButton(
                  onPressed: () => {
                    Navigator.pop(context, false),
                    Navigator.push(context, MaterialPageRoute(builder: (context) => VenderList()))
                  // locator<NavigationService>().navigateTo(VenderListRoute)
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

  void venderUpdate(int code,String name,String businessno,String ceoname,String tel) async {
    final api ='https://www.dfxsoft.com/api/venderUpdate';
    final dio = Dio();
    final data = {
      "code":code,
      "name":name,
      "businessno":businessno,
      "ceoname":ceoname,
      "tel":tel
    };
    Response response = await dio.post(api,data: data);
    if(response.statusCode == 200) {
      resultToast(response.data);
    }
  }

  Future<dynamic> _showdialogDelete(BuildContext context,int code,String name) async{
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(name+' 삭제'),
        content: Text('선택한 농장을 삭제하시겠습니까?'),

        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () => {
                    Navigator.pop(context, false),
                    Navigator.push(context, MaterialPageRoute(builder: (context) => VenderList())),
                    venderDelete(code),
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => VenderList()))
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

  void venderDelete(int code) async {
    final api ='https://www.dfxsoft.com/api/venderDelete';
    final dio = Dio();
    final data = {
      "code":code
    };
    Response response = await dio.post(api,data: data);
    if(response.statusCode == 200) {
      resultToast(response.data);
    }
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