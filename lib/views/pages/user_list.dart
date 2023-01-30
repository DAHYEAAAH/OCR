import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../entities/user.dart';
import '../../locator.dart';
import '../../routing/route_names.dart';
import '../../services/navigation_service.dart';
import 'package:get/get.dart' hide Response;
import 'package:flutter/services.dart';


class UserList extends StatefulWidget {
  @override
  _UserList createState() => _UserList();
}

class _UserList extends State<UserList> {
  var users = <User>[].obs;
  var dia_email;
  var dia_password;
  var dia_name;
  var dia_memlebel;

  @override
  void initState() {
    super.initState();
    memberList();
  }
  @override
  void dispose(){
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text('User List'),
          ),
          body: Obx(() => ListView(
            children: [
              _createDataTable()
            ],
          ),
          ),
        ));
  }

  DataTable _createDataTable() {
    return DataTable(columns: _createColumns(),
      rows: _createRows(),
      dividerThickness: 5,
      dataRowHeight: 80,
      showBottomBorder: true,
      headingTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white
      ),
      headingRowColor: MaterialStateProperty.resolveWith(
              (states) => Colors.black
      ),
    );
  }

  List<DataColumn> _createColumns() {
    return [
      DataColumn(label: Text('이메일',textAlign: TextAlign.center)),
      DataColumn(label: Text('이름',textAlign: TextAlign.center)),
      DataColumn(label: Text('회원레벨',textAlign: TextAlign.center)),
      DataColumn(label: Text('Options',textAlign: TextAlign.center ))
    ];
  }

  List<DataRow> _createRows() {
    List<DataRow> list = <DataRow>[];

    for (int i = 0; i < users.length; i++) {
      list.add(
        DataRow(cells: [
          DataCell(Text('${users[i].email}',textAlign: TextAlign.center),onTap: () {
            userDetailDialog('${users[i].email}');
          },),
          DataCell(Text('${users[i].name}')),
          DataCell(
            Container(
                width: 60,
                child: TextFormField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  initialValue: '${users[i].memlevel}',
                  decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(20.0),
                    ),
                  ),
                  onChanged: (text){
                    users[i].memlevel = int.parse(text);
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
                        _showdialogUpdateLevel(context,users[i].email!, users[i].memlevel!);
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
                        _showdialogDelete(context,users[i].email!);
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

  Future<void> memberList() async{
    final api ='https://www.dfxsoft.com/api/getUsers';
    final dio = Dio();
    Response response = await dio.get(api);
    if(response.statusCode == 200) {
      List<dynamic> result = response.data;
      users.assignAll(result.map((data) => User.fromJson(data)).toList());
      users.refresh();
    }
  }

  Future<dynamic> _showdialogUpdateLevel(BuildContext context,String email,int memlevel) async{
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('회원 레벨 수정'),
        content: Text('회원 레벨을 "'+memlevel.toString() + '" 로 수정하시겠습니까?'),

        actions: [
          ElevatedButton(
              onPressed: () => {
                Navigator.pop(context, false),
                userLevelUpdate(email,memlevel)
              },
              child: Text('Update')),
          ElevatedButton(
              onPressed: () => {
                Navigator.pop(context, false),
                locator<NavigationService>().navigateTo(UserListRoute)
              },
                child: Text('Cancel')),
        ],
      ),
    );
  }

  void userLevelUpdate(String email,int memlevel) async {
    final api ='https://www.dfxsoft.com/api/userLevelUpdate';
    final dio = Dio();
    final data = {
      "email":email,
      "memlevel":memlevel
    };
    Response response = await dio.post(api,data: data);
    if(response.statusCode == 200) {
      print('response level:'+response.data);
    }
  }

  Future<dynamic> _showdialogDelete(BuildContext context,String email) async{
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('회원 삭제'),
        content: Text('회원 "'+email + '" 을 삭제하시겠습니까?'),

        actions: [
          ElevatedButton(
              onPressed: () => {
                Navigator.pop(context, false),
                userDelete(email),
                locator<NavigationService>().navigateTo(UserListRoute)
              },
              child: Text('Delete')),
          ElevatedButton(
              onPressed: () => {
                Navigator.pop(context, false),
                locator<NavigationService>().navigateTo(UserListRoute)
              },
              child: Text('Cancel')),
        ],
      ),
    );
  }

  void userDelete(String email) async {
    final api ='https://www.dfxsoft.com/api/userDelete';
    final dio = Dio();
    final data = {
      "email":email
    };
    Response response = await dio.post(api,data: data);
    if(response.statusCode == 200) {
      print('response level:'+response.data);
    }
  }

  void userDetailDialog(String email) async{
    final api ='https://www.dfxsoft.com/api/getUsers';
    final dio = Dio();
    final data = {
      "email":email
    };
    Response response = await dio.post(api,data: data);

    if(response.statusCode == 200) {
      dia_email=response.data[0];
      dia_password=response.data[1];
      dia_name=response.data[2];
      dia_memlebel=response.data[4].toString();
    }
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('회원정보 변경'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [

                  TextFormField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email),

                      border: InputBorder.none,
                      // labelText: 'Label Text',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(0.5)),
                        borderSide: BorderSide( color: Colors.blue, ),
                      ),
                      filled: true,
                      fillColor: Colors.black12,
                    ),
                    autovalidateMode: AutovalidateMode.always,
                    enabled: false,
                    initialValue: dia_email,
                    onSaved: (value){
                      setState(() {
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please insert your Email.';
                      } else {
                        String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                        RegExp regExp = new RegExp(pattern);
                        if(!regExp.hasMatch(value)){
                          return 'Invalid email format!';
                        }else{
                          return null;
                        }
                      }
                    },
                  ),

                  TextFormField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email),

                      border: InputBorder.none,
                      // labelText: 'Label Text',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(0.5)),
                        borderSide: BorderSide( color: Colors.blue, ),
                      ),
                      filled: true,
                      fillColor: Colors.black12,
                    ),
                    autovalidateMode: AutovalidateMode.always,
                    enabled: false,
                    initialValue: dia_name,
                    onSaved: (value){
                      setState(() {
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please insert your Email.';
                      } else {
                        String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                        RegExp regExp = new RegExp(pattern);
                        if(!regExp.hasMatch(value)){
                          return 'Invalid email format!';
                        }else{
                          return null;
                        }
                      }
                    },
                  ),

                  TextFormField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email),

                      border: InputBorder.none,
                      // labelText: 'Label Text',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(0.5)),
                        borderSide: BorderSide( color: Colors.blue, ),
                      ),
                      filled: true,
                      fillColor: Colors.black12,
                    ),
                    autovalidateMode: AutovalidateMode.always,
                    initialValue: dia_memlebel,
                    onSaved: (value){
                      setState(() {
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please insert your Email.';
                      } else {
                        String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                        RegExp regExp = new RegExp(pattern);
                        if(!regExp.hasMatch(value)){
                          return 'Invalid email format!';
                        }else{
                          return null;
                        }
                      }
                    },
                  ),

                ],
              ),
            ),
            actions: [
              FloatingActionButton(
                  child: Text('ok'),
                  onPressed: (){
                    Navigator.of(context).pop();
                  }
              ),
              FloatingActionButton(
                  child: Text('cancel'),
                  onPressed: (){
                    Navigator.of(context).pop();
                  }
              )
            ],
          );
        }
    );
  }
}