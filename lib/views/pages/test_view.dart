import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../entities/user.dart';
import 'package:get/get.dart' hide Response;

import 'package:intl/intl.dart';

class TestView extends StatefulWidget {
  const TestView({Key? key}) : super(key: key);

  @override
  TestViewState createState(){
    return TestViewState();
  }
}

class TestViewState extends State<TestView>{
  var users = <User>[].obs;
  late bool isShowSticker;
  DateTime now = DateTime.now();
  late String nowTime;
  String _find ='';
  final TextEditingController find = TextEditingController();

  @override
  void initState() {
    super.initState();
    nowTime = DateFormat('MM:dd').format(now);
    memberList();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView(

        children: [
          Stack(
            children: [
              Center(
                child: Container(
                  width: 600,
                  child: DefaultTabController(
                      length: 2,
                      initialIndex: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TabBar(
                              overlayColor: MaterialStateProperty.resolveWith<Color?>(
                                    (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.hovered))
                                    return Colors.amberAccent; //<-- SEE HERE
                                  return null;
                                },
                              ),

                              indicatorColor: Colors.blue[100],labelColor: const Color(0xFF3baee7),


                              tabs: [Tab(text: 'Group'),Tab(text: 'Users')]),
                          Container(
                              height: 300.0,
                              child: TabBarView(
                                children: [
                                  Center(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 20,),
                                          Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: IconButton(
                                                  onPressed: () =>{addUserDialoadContainer(context)},
                                                  icon: Image.asset('assets/add_user.png'),
                                                )
                                            ),
                                          )
                                        ],
                                      )
                                  ),
                                  Center(
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Expanded(child: userListTop()),
                                          ]
                                      )
                                  ),
                                ],
                              ))
                        ],
                      )
                  ),
                ),

              )
            ],
          ),
        ]
    );
  }

  Future<void> memberList() async{
    // final api ='http://localhost:5000/api/getUsers';
    // final dio = Dio();
    // Response response = await dio.get(api);
    // if(response.statusCode == 200) {
    //   List<dynamic> result = response.data;
    //   users.assignAll(result.map((data) => User.fromJson(data)).toList());
    //   users.refresh();
    // }
  }

  Widget userListTop() {
    return Container(
      child: Obx(()=>Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          buildFindfield(),
          Expanded(
            child: ListView.separated(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (context,index) =>
                    Container(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                              },
                              child: users[index].avatar == null ?
                              Ink.image(
                                image: AssetImage('assets/noimage.png'),
                                width: 20,
                                height: 20,
                              ):Ink.image(
                                image: AssetImage(users[index].avatar.toString()),
                                width: 20,
                                height: 20,
                              ),
                            ),
                            SizedBox(width: 10,),
                            Text(users[index].name.toString())
                          ],
                        )
                    ),
                separatorBuilder: (_,index) => SizedBox(width: 15,),
                itemCount: users.length
            ),
          )

        ],
      ),
      ),
    );
  }

  Widget buildFindfield(){
    return Container(
      alignment: Alignment.centerLeft,
      child: Column(

        children: [
          SizedBox(
            width: 200,
            child: TextFormField(
              controller: find,
              decoration: InputDecoration(
                hintText: 'Name after click',
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 25.0, top: 16.0),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search, color: Colors.green, size: 20.0,),
                  onPressed: () {
                    findMemberList();
                  },
                ),
              ),
              keyboardType: TextInputType.text,
              obscureText: false,
              autovalidateMode: AutovalidateMode.always,
              onSaved: (value){
                setState(() {
                  _find = value as String;
                });
              },
            ),
          )

        ],
      ),
    );
  }

  Future<void> findMemberList() async{
    final api ='http://localhost:5000/api/getFindUsers';
    final dio = Dio();
    final data = {
      "find": find.text,
    };
    Response response = await dio.post(api,data: data);
    if(response.statusCode == 200) {
      List<dynamic> result = response.data;
      print('response length:'+result.length.toString());
      users.assignAll(result.map((data) => User.fromJson(data)).toList());
      users.refresh();
    }
  }

  void addUserDialoadContainer(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("User List"),
          content: Center(
              child: Column(
                children: [
                  Expanded(child: userListTop()),
                  Text('aaaa'),
                  Text('aaaa'),
                  Text('aaaa'),
                  Text('aaaa'),
                  Text('aaaa'),
                  Text('aaaa'),
                  Text('aaaa'),
                  Text('aaaa'),
                  Text('aaaa'),
                  Text('aaaa'),
                  Text('aaaa'),
                  Text('aaaa'),
                  Text('aaaa'),
                  Text('aaaa'),
                  Text('aaaa'),
                  Text('aaaa'),
                ],
              )
          ),
          actions: <Widget>[
            new TextButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
