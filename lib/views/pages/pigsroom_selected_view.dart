import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../entities/PigsRoom.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' hide Response;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class PigsRoomSelectedView extends StatefulWidget {
  final String companyCode;
  final String roomNo;

  PigsRoomSelectedView({Key? key, required this.companyCode,required this.roomNo}) : super(key: key);

  @override
  State<PigsRoomSelectedView> createState() => _PigsRoomSelectedView();
}

class _PigsRoomSelectedView extends State<PigsRoomSelectedView> {
  var pigsroom = <Pigsroom>[].obs;
  late int intototal =0;
  late int outtotal =0;
  late int accidenttotal =0;
  final preyystock = TextEditingController();
  final into01 = TextEditingController();
  final into02 = TextEditingController();
  final into03 = TextEditingController();
  final into04 = TextEditingController();
  final into05 = TextEditingController();
  final into06 = TextEditingController();
  final into07 = TextEditingController();
  final into08 = TextEditingController();
  final into09 = TextEditingController();
  final into10 = TextEditingController();
  final into11 = TextEditingController();
  final into12 = TextEditingController();
  final out01 = TextEditingController();
  final out02 = TextEditingController();
  final out03 = TextEditingController();
  final out04 = TextEditingController();
  final out05 = TextEditingController();
  final out06 = TextEditingController();
  final out07 = TextEditingController();
  final out08 = TextEditingController();
  final out09 = TextEditingController();
  final out10 = TextEditingController();
  final out11 = TextEditingController();
  final out12 = TextEditingController();
  final accident01 = TextEditingController();
  final accident02 = TextEditingController();
  final accident03 = TextEditingController();
  final accident04 = TextEditingController();
  final accident05 = TextEditingController();
  final accident06 = TextEditingController();
  final accident07 = TextEditingController();
  final accident08 = TextEditingController();
  final accident09 = TextEditingController();
  final accident10 = TextEditingController();
  final accident11 = TextEditingController();
  final accident12 = TextEditingController();
  final stock01 = TextEditingController();
  final stock02 = TextEditingController();
  final stock03 = TextEditingController();
  final stock04 = TextEditingController();
  final stock05 = TextEditingController();
  final stock06 = TextEditingController();
  final stock07 = TextEditingController();
  final stock08 = TextEditingController();
  final stock09 = TextEditingController();
  final stock10 = TextEditingController();
  final stock11 = TextEditingController();
  final stock12 = TextEditingController();
  final stock = TextEditingController();
  final ctl_intototal = TextEditingController();
  final ctl_outtotal = TextEditingController();
  final ctl_accidenttotal = TextEditingController();

  @override
  void initState() {
    super.initState();
    pigsRoomSelectedRow();
  }
  @override
  void dispose(){
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Form(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 10,),
              SizedBox(
                width: 700,height: 70,
                child:unitTitle(),
              ),
              Container(
                width: 800,
                // decoration: BoxDecoration(
                //   border: Border.all(
                //     color: Colors.black54,
                //   ),
                //   borderRadius: BorderRadius.all(Radius.circular(5)),
                //   // color: const Color(0xf6f6f6f6),
                // ),
                child: Column(
                  children: [
                    rowTitle(),
                    SizedBox(width: 5,),
                    rowView01(),
                    SizedBox(width: 5,),
                    rowView02(),
                    SizedBox(width: 5,),
                    rowView03(),
                    SizedBox(width: 5,),
                    rowView04(),
                    SizedBox(width: 5,),
                    rowView05(),
                    SizedBox(width: 5,),
                    rowView06(),
                    SizedBox(width: 5,),
                    rowView07(),
                    SizedBox(width: 5,),
                    rowView08(),
                    SizedBox(width: 5,),
                    rowView09(),
                    SizedBox(width: 5,),
                    rowView10(),
                    SizedBox(width: 5,),
                    rowView11(),
                    SizedBox(width: 5,),
                    rowView12(),
                    SizedBox(width: 5,),
                    totalView(),
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }

  Widget unitTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        OutlinedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(" 닫기 "),
          style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 16),
              shape: const RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.all(Radius.circular(15))
              )
          ),
        ),
        OutlinedButton(
          onPressed: () {
            pigsroomUpdateDialogYesNo(context);
          },
          child: Text(" 수정 "),
          style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 16),
              shape: const RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.all(Radius.circular(15))
              )
          ),
        ),
      ],
    );
  }

  Future<dynamic> pigsroomUpdateDialogYesNo(BuildContext context) async{
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('돈사재고 수정'),
        content: Text('돈사정보를 수정하시겠습니까?'),

        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () => {
                    Navigator.pop(context, false),
                    pigsroomUpdateDialogUpdate(),
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
                  // locator<NavigationService>().navigateTo(UserListRoute)
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  foregroundColor: Colors.black54,
                  primary: Colors.white,
                ),
                child: Text('취소'),

              ),
            ],
          )
        ],
      ),
    );
  }

  void pigsroomUpdateDialogUpdate() async {
    final api ='https://www.gfarmx.com/api/pigsRoomUpdateWhole';
    final dio = Dio();
    final data = {
      "companyCode":widget.companyCode,
      "pigsroom":pigsroom.toJson(),
    };
    Response response = await dio.post(api,data: data);
    if(response.statusCode == 200) {
      resultToast("돈사재고 정보가 수정 되었습니다.");
    }
  }

  Widget rowTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black26,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
            ),
            child: Text(widget.roomNo.toString() +' Room 현황',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.blueAccent)),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.black12,
            ),
            child: Text("입고 두수",),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.blueAccent,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.black12,
            ),
            child: Text("출고 두수",),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.black12,
            ),
            child: Text("사고 두수",),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.black12,
            ),
            child: Text("재고 두수"),
          ),
        ),
      ],
    );
  }

  Widget rowView01() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.black12,
            ),
            child: Text("01 월"),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
            ),
            child: TextFormField(
              controller: into01,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                ),
              ),
              onChanged: (text){
                pigsroom[0].into01 = int.parse(text);
              },
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
            ),
            child: TextFormField(
              controller: out01,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                ),
              ),
              onChanged: (text){
                pigsroom[0].out01 = int.parse(text);
              },
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
            ),
            child: TextFormField(
              controller: accident01,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                ),
              ),
              onChanged: (text){
                pigsroom[0].accident01 = int.parse(text);
              },
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
            ),
            child: TextFormField(
              controller: stock01,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                ),
              ),
              onChanged: (text){
                pigsroom[0].stock01 = int.parse(text);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget rowView02() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.black12,
            ),
            child: Text("02 월"),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
            ),
            child: TextFormField(
              controller: into02,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                ),
              ),
              onChanged: (text){
                pigsroom[0].into02 = int.parse(text);
              },
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
            ),
            child: TextFormField(
              controller: out02,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                ),
              ),
              onChanged: (text){
                pigsroom[0].out02 = int.parse(text);
              },
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
            ),
            child: TextFormField(
              controller: accident02,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                ),
              ),
              onChanged: (text){
                pigsroom[0].accident02 = int.parse(text);
              },
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
            ),
            child: TextFormField(
              controller: stock02,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                ),
              ),
              onChanged: (text){
                pigsroom[0].stock02 = int.parse(text);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget rowView03() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.black12,
            ),
            child: Text("03 월"),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
            ),
            child: TextFormField(
              controller: into03,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                ),
              ),
              onChanged: (text){
                pigsroom[0].into03 = int.parse(text);
              },
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
            ),
            child: TextFormField(
              controller: out03,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                ),
              ),
              onChanged: (text){
                pigsroom[0].out03 = int.parse(text);
              },
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
            ),
            child: TextFormField(
              controller: accident03,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                ),
              ),
              onChanged: (text){
                pigsroom[0].accident03 = int.parse(text);
              },
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
            ),
            child: TextFormField(
              controller: stock03,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                ),
              ),
              onChanged: (text){
                pigsroom[0].stock03 = int.parse(text);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget rowView04() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.black12,
            ),
            child: Text("04 월"),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
            ),
            child: TextFormField(
              controller: into04,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                ),
              ),
              onChanged: (text){
                pigsroom[0].into04 = int.parse(text);
              },
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
            ),
            child: TextFormField(
              controller: out04,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                ),
              ),
              onChanged: (text){
                pigsroom[0].out04 = int.parse(text);
              },
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
            ),
            child: TextFormField(
              controller: accident04,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                ),
              ),
              onChanged: (text){
                pigsroom[0].accident04 = int.parse(text);
              },
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
            ),
            child: TextFormField(
              controller: stock04,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                ),
              ),
              onChanged: (text){
                pigsroom[0].stock04 = int.parse(text);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget rowView05() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.black12,
            ),
            child: Text("05 월"),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
            ),
            child: TextFormField(
              controller: into05,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                ),
              ),
              onChanged: (text){
                pigsroom[0].into05 = int.parse(text);
              },
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
            ),
            child: TextFormField(
              controller: out05,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                ),
              ),
              onChanged: (text){
                pigsroom[0].out05 = int.parse(text);
              },
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
            ),
            child: TextFormField(
              controller: accident05,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                ),
              ),
              onChanged: (text){
                pigsroom[0].accident05 = int.parse(text);
              },
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
            ),
            child: TextFormField(
              controller: stock05,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                ),
              ),
              onChanged: (text){
                pigsroom[0].stock05 = int.parse(text);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget rowView06() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.black12,
            ),
            child: Text("06 월"),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
            ),
            child: TextFormField(
              controller: into06,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                ),
              ),
              onChanged: (text){
                pigsroom[0].into06 = int.parse(text);
              },
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
            ),
            child: TextFormField(
              controller: out06,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                ),
              ),
              onChanged: (text){
                pigsroom[0].out06 = int.parse(text);
              },
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
            ),
            child: TextFormField(
              controller: accident06,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                ),
              ),
              onChanged: (text){
                pigsroom[0].accident06 = int.parse(text);
              },
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
            ),
            child: TextFormField(
              controller: stock06,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                ),
              ),
              onChanged: (text){
                pigsroom[0].stock06 = int.parse(text);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget rowView07() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.black12,
            ),
            child: Text("07 월"),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
            ),
            child: TextFormField(
              controller: into07,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                ),
              ),
              onChanged: (text){
                pigsroom[0].into07 = int.parse(text);
              },
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
            ),
            child: TextFormField(
              controller: out07,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                ),
              ),
              onChanged: (text){
                pigsroom[0].out07 = int.parse(text);
              },
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
            ),
            child: TextFormField(
              controller: accident07,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                ),
              ),
              onChanged: (text){
                pigsroom[0].accident07 = int.parse(text);
              },
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
            ),
            child: TextFormField(
              controller: stock07,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                ),
              ),
              onChanged: (text){
                pigsroom[0].stock07 = int.parse(text);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget rowView08() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.black12,
            ),
            child: Text("08 월"),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
            ),
            child: TextFormField(
              controller: into08,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                ),
              ),
              onChanged: (text){
                pigsroom[0].into08 = int.parse(text);
              },
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
            ),
            child: TextFormField(
              controller: out08,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                ),
              ),
              onChanged: (text){
                pigsroom[0].out08 = int.parse(text);
              },
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
            ),
            child: TextFormField(
              controller: accident08,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                ),
              ),
              onChanged: (text){
                pigsroom[0].accident08 = int.parse(text);
              },
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
            ),
            child: TextFormField(
              controller: stock08,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                ),
              ),
              onChanged: (text){
                pigsroom[0].stock08 = int.parse(text);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget rowView09() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.black12,
            ),
            child: Text("09 월"),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
            ),
            child: TextFormField(
              controller: into09,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                ),
              ),
              onChanged: (text){
                pigsroom[0].into09 = int.parse(text);
              },
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
            ),
            child: TextFormField(
              controller: out09,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                ),
              ),
              onChanged: (text){
                pigsroom[0].out09 = int.parse(text);
              },
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
            ),
            child: TextFormField(
              controller: accident09,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                ),
              ),
              onChanged: (text){
                pigsroom[0].accident09 = int.parse(text);
              },
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
            ),
            child: TextFormField(
              controller: stock09,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                ),
              ),
              onChanged: (text){
                pigsroom[0].stock09 = int.parse(text);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget rowView10() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.black12,
            ),
            child: Text("10 월"),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
            ),
            child: TextFormField(
              controller: into10,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                ),
              ),
              onChanged: (text){
                pigsroom[0].into10 = int.parse(text);
              },
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
            ),
            child: TextFormField(
              controller: out10,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                ),
              ),
              onChanged: (text){
                pigsroom[0].out10 = int.parse(text);
              },
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
            ),
            child: TextFormField(
              controller: accident10,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                ),
              ),
              onChanged: (text){
                pigsroom[0].accident10 = int.parse(text);
              },
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
            ),
            child: TextFormField(
              controller: stock10,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                ),
              ),
              onChanged: (text){
                pigsroom[0].stock10 = int.parse(text);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget rowView11() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.black12,
            ),
            child: Text("11 월"),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
            ),
            child: TextFormField(
              controller: into11,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                ),
              ),
              onChanged: (text){
                pigsroom[0].into11 = int.parse(text);
              },
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
            ),
            child: TextFormField(
              controller: out11,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                ),
              ),
              onChanged: (text){
                pigsroom[0].out11 = int.parse(text);
              },
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
            ),
            child: TextFormField(
              controller: accident11,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                ),
              ),
              onChanged: (text){
                pigsroom[0].accident11 = int.parse(text);
              },
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
            ),
            child: TextFormField(
              controller: stock11,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                ),
              ),
              onChanged: (text){
                pigsroom[0].stock11 = int.parse(text);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget rowView12() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.black12,
            ),
            child: Text("12 월"),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
            ),
            child: TextFormField(
              controller: into12,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                ),
              ),
              onChanged: (text){
                pigsroom[0].into12 = int.parse(text);
              },
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
            ),
            child: TextFormField(
              controller: out12,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                ),
              ),
              onChanged: (text){
                pigsroom[0].out12 = int.parse(text);
              },
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
            ),
            child: TextFormField(
              controller: accident12,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                ),
              ),
              onChanged: (text){
                pigsroom[0].accident12 = int.parse(text);
              },
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
            ),
            child: TextFormField(
              controller: stock12,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                ),
              ),
              onChanged: (text){
                pigsroom[0].stock12 = int.parse(text);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget totalView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
            ),
            child: Text(" 합계 ",style: TextStyle(color: Colors.blueAccent),),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
            ),
            child: TextFormField(
              readOnly:true,
              controller: ctl_intototal,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                ),
              ),
              style: TextStyle(color: Colors.blueAccent),
              onChanged: (text){
              },
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
            ),
            child: TextFormField(
              readOnly:true,
              controller: ctl_outtotal,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                ),
              ),
              style: TextStyle(color: Colors.blueAccent),
              onChanged: (text){
                pigsroom[0].out02 = int.parse(text);
              },
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
            ),
            child: TextFormField(
              readOnly:true,
              controller: ctl_accidenttotal,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                ),
              ),
              style: TextStyle(color: Colors.blueAccent),
              onChanged: (text){
                pigsroom[0].accident02 = int.parse(text);
              },
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height:40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
            ),
            child: TextFormField(
              readOnly:true,
              controller: stock,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                ),
              ),
              style: TextStyle(color: Colors.blueAccent),
              onChanged: (text){
                pigsroom[0].stock = int.parse(text);
              },
            ),
          ),
        ),
      ],
    );
  }

  void pigsRoomSelectedRow() async {
    final api = 'https://www.gfarmx.com/api/pigsRoomSelectedRow';
    final dio = Dio();
    final data = {
      "roomNo": int.parse(widget.roomNo!),
      "companyCode": widget.companyCode
    };
    Response response = await dio.post(api, data: data);

    if (response.statusCode == 200) {
      setState(() {
        List<dynamic> result = response.data;
        pigsroom.assignAll(result.map((data) => Pigsroom.fromJson(data)).toList());
        preyystock.text = pigsroom[0].preyystock.toString();
        into01.text = pigsroom[0].into01.toString();
        into02.text = pigsroom[0].into02.toString();
        into03.text = pigsroom[0].into03.toString();
        into04.text = pigsroom[0].into04.toString();
        into05.text = pigsroom[0].into05.toString();
        into06.text = pigsroom[0].into06.toString();
        into07.text = pigsroom[0].into07.toString();
        into08.text = pigsroom[0].into08.toString();
        into09.text = pigsroom[0].into09.toString();
        into10.text = pigsroom[0].into10.toString();
        into11.text = pigsroom[0].into11.toString();
        into12.text = pigsroom[0].into12.toString();
        out01.text = pigsroom[0].out01.toString();
        out02.text = pigsroom[0].out02.toString();
        out03.text = pigsroom[0].out03.toString();
        out04.text = pigsroom[0].out04.toString();
        out05.text = pigsroom[0].out05.toString();
        out06.text = pigsroom[0].out06.toString();
        out07.text = pigsroom[0].out07.toString();
        out08.text = pigsroom[0].out08.toString();
        out09.text = pigsroom[0].out09.toString();
        out10.text = pigsroom[0].out10.toString();
        out11.text = pigsroom[0].out11.toString();
        out12.text = pigsroom[0].out12.toString();
        accident01.text = pigsroom[0].accident01.toString();
        accident02.text = pigsroom[0].accident02.toString();
        accident03.text = pigsroom[0].accident03.toString();
        accident04.text = pigsroom[0].accident04.toString();
        accident05.text = pigsroom[0].accident05.toString();
        accident06.text = pigsroom[0].accident06.toString();
        accident07.text = pigsroom[0].accident07.toString();
        accident08.text = pigsroom[0].accident08.toString();
        accident09.text = pigsroom[0].accident09.toString();
        accident10.text = pigsroom[0].accident10.toString();
        accident11.text = pigsroom[0].accident11.toString();
        accident12.text = pigsroom[0].accident12.toString();
        stock01.text = pigsroom[0].stock01.toString();
        stock02.text = pigsroom[0].stock02.toString();
        stock03.text = pigsroom[0].stock03.toString();
        stock04.text = pigsroom[0].stock04.toString();
        stock05.text = pigsroom[0].stock05.toString();
        stock06.text = pigsroom[0].stock06.toString();
        stock07.text = pigsroom[0].stock07.toString();
        stock08.text = pigsroom[0].stock08.toString();
        stock09.text = pigsroom[0].stock09.toString();
        stock10.text = pigsroom[0].stock10.toString();
        stock11.text = pigsroom[0].stock11.toString();
        stock12.text = pigsroom[0].stock12.toString();
        stock.text = pigsroom[0].stock.toString();
        intototal = pigsroom[0].into01! + pigsroom[0].into02!+ pigsroom[0].into03!+ pigsroom[0].into04!
            + pigsroom[0].into05!+ pigsroom[0].into06!+ pigsroom[0].into07!+ pigsroom[0].into08!
            + pigsroom[0].into09!+ pigsroom[0].into10!+ pigsroom[0].into11!+ pigsroom[0].into12!;
        ctl_intototal.text = intototal.toString();

        outtotal = pigsroom[0].out01! + pigsroom[0].out02!+ pigsroom[0].out03!+ pigsroom[0].out04!
            + pigsroom[0].out05!+ pigsroom[0].out06!+ pigsroom[0].out07!+ pigsroom[0].out08!
            + pigsroom[0].out09!+ pigsroom[0].out10!+ pigsroom[0].out11!+ pigsroom[0].out12!;
        ctl_outtotal.text = outtotal.toString();

        accidenttotal = pigsroom[0].accident01! + pigsroom[0].accident02!+ pigsroom[0].accident03!+ pigsroom[0].accident04!
            + pigsroom[0].accident05!+ pigsroom[0].accident06!+ pigsroom[0].accident07!+ pigsroom[0].accident08!
            + pigsroom[0].accident09!+ pigsroom[0].accident10!+ pigsroom[0].accident11!+ pigsroom[0].accident12!;
        ctl_accidenttotal.text = accidenttotal.toString();
      });
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