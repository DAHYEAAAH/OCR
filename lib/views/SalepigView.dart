import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../entities/CompanyCombo.dart';
import '../entities/Vender.dart';
import '../entities/VenderCombo.dart';
import '../entities/company.dart';
import '../locator.dart';
import '../routing/route_names.dart';
import '../services/navigation_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' hide Response;

late final domain = "https://www.gfarmx.com/api/";

class SalepigView extends StatefulWidget {
  String companyCode;
  SalepigView({Key? key, required this.companyCode}) : super(key: key);

  @override
  SalepigViewState createState(){
    return SalepigViewState();
  }

}

class SalepigViewState extends State<SalepigView>{
  AutovalidateMode _autovalidate = AutovalidateMode.disabled;
  final _formKey = GlobalKey<FormState>();

  String _seqno ='';
  String _companyCode ='';
  String _venderCode ='';
  String _roomNo ='';
  String _yyyy ='';
  String _mm ='';
  String _dd ='';
  String _qty ='';
  String _memo ='';
  late List<dynamic> listMonths = [];
  List<CompanyCombo> companyList = <CompanyCombo>[].obs;
  var companys = <Company>[].obs;
  var selectedDropdown="0";
  var selectedDropdownVender="0";
  List<VenderCombo> venderList = <VenderCombo>[].obs;
  var venders = <Vender>[].obs;
  var venderDropDowninti = "0";

  var presentStock = '';
  var inputQty = '';

  final List<bool> _selectedSaleTypes = <bool>[true, false];
  bool vertical = false;
  List<Widget> saletypes = <Widget>[
    Text('정상출고'),
    Text('사고출고'),
  ];

  final TextEditingController seqno = TextEditingController();
  final TextEditingController companyCode = TextEditingController();
  final TextEditingController venderCode = TextEditingController();
  final TextEditingController roomNo = TextEditingController();
  final TextEditingController yyyy = TextEditingController();
  final TextEditingController mm = TextEditingController();
  final TextEditingController dd = TextEditingController();
  final TextEditingController qty = TextEditingController();
  final TextEditingController memo = TextEditingController();

  String _selectedMonth = DateTime.now().month.toString();
  String _selectedDay = DateTime.now().day.toString();
  String _selectedYear = DateTime.now().year.toString();

  @override
  void initState() {
    companysList();
    vendersList();
    nowDateSetCustom();
  }

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false ,
      home: Scaffold(
        appBar: AppBar(),
        body: Form(
          key:_formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 30,),
              SizedBox(
                width: 700,height: 70,
                child:unitTitle(),
              ),
              Container(
                width: 700,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black54,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  // color: const Color(0xf6f6f6f6),
                ),
                child: Row(
                  children: [
                    // Expanded(child: SizedBox(width: 50,), flex:1 ),
                    SizedBox(width: 20,),
                    Expanded(child: inputContents(), flex:1 ),
                    SizedBox(width: 20,),
                    Expanded(child: inputContentsDeco(), flex:1 ),
                    // Expanded(child: SizedBox(width: 50,), flex:1 ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ) ;

  }

  Widget unitTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(' 자돈 매출',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)
      ],
    );
  }

  Widget inputContents(){

    return Container(
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.all(Radius.circular(5)),
        // color: const Color(0xf6ee4485),
      ),
      child: Column(
        children: [
          SizedBox(height: 30,),
          SizedBox(
            child: buildCompanyCode(),
          ),
          SizedBox(height: 5,),
          SizedBox(
            child: buildRoomNo(),
          ),
          SizedBox(height: 5,),
          SizedBox(
            child: buildVenderCode(),
          ),
          SizedBox(height: 5,),
          SizedBox(
            //child: buildSaleDate(),
            child: buildSaleDate(),
          ),
          SizedBox(height: 5,),
          SizedBox(
            child: saleToggleTypes(),
          ),
          SizedBox(height: 15,),
          SizedBox(
            child: presentStockView(),
          ),
          SizedBox(height: 5,),

          SizedBox(
            child: buildQty(),
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            child: salePigSaveBtn(),
          ),
          SizedBox(height: 30,)
        ],
      ),
    );
  }
  Widget inputContentsDeco(){
    return Container(
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.all(Radius.circular(5)),
        color: const Color(0xf64481ee),
      ),
      // height: MediaQuery.of(context).size.height / 2,
      // width: MediaQuery.of(context).size.width / 2,
      child: Image.asset('assets/register_right.png'),
    );
  }

  Widget buildCompanyCode(){
    return Container(
      child: Container(
        child: DropdownButtonFormField(
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(15.0),
                  ),
                ),
                filled: true,
                hintStyle: TextStyle(color: Colors.grey[800]),
                // hintText: "Name",
                fillColor: Colors.blue[200]),
            isExpanded: true,
            value: widget.companyCode,
            items: companyList.map((company){
              return DropdownMenuItem(
                child: Text(company.name.toString()),
                value: company.tabindex.toString(),
              );
            }).toList(),
            onChanged: (value){
              setState(() {
                selectedDropdown=value.toString();
              });
            }
        ),
      ),
    );
  }

  Widget buildRoomNo(){
    return Container(
      child: Column(
        children: [
          TextFormField(
            controller: roomNo,
            decoration: const InputDecoration(
              // suffixIcon: Icon(Icons.star),
              labelText: '자돈Room 번호',
              contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              // border: InputBorder.none,
              // labelText: 'Label Text',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                borderSide: BorderSide( width:2,color: Colors.black54),
              ),
              filled: true,
              fillColor: Colors.white,

            ),
            keyboardType: TextInputType.text,
            autovalidateMode: AutovalidateMode.always,
            onChanged: (text){
              getPigsroomStock(text);
            },
            onSaved: (value){
              setState(() {
                _roomNo = value as String;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please insert pigRoom.';
              } else {
                return null;
              }
            },
          ),
        ],
      ),
    );
  }

  Widget buildVenderCode(){
    return Container(
      child: Container(
        child: DropdownButtonFormField(
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(15.0),
                  ),
                ),
                filled: true,
                hintStyle: TextStyle(color: Colors.grey[800]),
                // hintText: "Name",
                fillColor: Colors.blue[200]),
            isExpanded: true,
            value: venderDropDowninti,
            items: venderList.map((vend){
              return DropdownMenuItem(
                child: Text(vend.name.toString()),
                value: vend.code.toString(),
              );
            }).toList(),
            onChanged: (value){
              setState(() {
                selectedDropdownVender=value.toString();
              });
            }
        ),
      ),
    );
  }

  Widget buildSaleDate(){
    List<String> _yearList = [];
    List<String> _monthList = [];
    List<String> _dayList = [];

    for(int i = 0; i<=2; i++){
      _yearList.add((DateTime.now().year-1+i).toString());
    }
    for(int i = 1; i<=12; i++){
      _monthList.add(i.toString());
    }
    for(int i = 1; i<=DateTime(int.parse(_selectedYear), int.parse(_selectedMonth)+1,0).day; i++){
      _dayList.add(i.toString());
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Flexible(
          fit: FlexFit.tight,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all()
            ),
            child: DropdownButtonHideUnderline(
              child:
              DropdownButton(
                isExpanded: true,
                value: _selectedYear,
                items: _yearList.map((String item) {
                  return DropdownMenuItem<String>(
                    child: Center(child: Text('$item',textAlign: TextAlign.center,)),
                    value: item,
                  );
                }).toList(),
                onChanged: (dynamic value) {
                  setState(() {
                    _selectedYear = value;
                  });
                },
              ),
            )
          ),
        ),
        Flexible(
          fit: FlexFit.tight,
          child: Container(
            decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all()
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                isExpanded: true,
                value: _selectedMonth,
                items: _monthList.map((String item) {
                  return DropdownMenuItem<String>(
                    child: Center(child: Text('$item',textAlign: TextAlign.center,)),
                    value: item,
                  );
                }).toList(),
                onChanged: (dynamic value) {
                  setState(() {
                    _selectedMonth = value;
                  });
                },
              ),
            )
          )
        ),
        Flexible(
            fit: FlexFit.tight,
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all()
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    isExpanded: true,
                    value: _selectedDay,
                    items: _dayList.map((String item) {
                      return DropdownMenuItem<String>(
                        child: Center(child: Text('$item',textAlign: TextAlign.center,)),
                        value: item,
                      );
                    }).toList(),
                    onChanged: (dynamic value) {
                      setState(() {
                        _selectedDay = value;
                      });
                    },
                  ),
                )
            )
        ),
      ],
    );
  }

  Widget buildQty(){
    return Container(
      child: Column(
        children: [
          TextFormField(
            controller: qty,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              labelText: '판매두수',
              contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              // border: InputBorder.none,
              // labelText: 'Label Text',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                borderSide: BorderSide( width:2,color: Colors.black54),
              ),
              filled: true,
              fillColor: Colors.white,

            ),
            autovalidateMode: AutovalidateMode.always,
            onChanged: (value){
              setState(() {
                inputQty=value;
              });
            },
            onSaved: (value){
              setState(() {
                _qty = value as String;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please insert sale qty';
              } else {
                return null;
              }
            },
          ),
        ],
      ),
    );
  }

  Widget saleToggleTypes(){
    return Container(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // ToggleButtons with a single selection.
            const SizedBox(height: 5),
            ToggleButtons(
              direction: vertical ? Axis.vertical : Axis.horizontal,
              onPressed: (int index) {
                setState(() {
                  // The button that is tapped is set to true, and the others to false.
                  for (int i = 0; i < _selectedSaleTypes.length; i++) {
                    _selectedSaleTypes[i] = i == index;
                  }
                });
              },
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              selectedBorderColor: Colors.red[700],
              selectedColor: Colors.white,
              fillColor: Colors.red[200],
              color: Colors.red[400],
              constraints: const BoxConstraints(
                minHeight: 40.0,
                minWidth: 80.0,
              ),
              isSelected: _selectedSaleTypes,
              children: saletypes,
            ),
            const SizedBox(height: 20),
            // ToggleButtons with a multiple selection.

          ],
        ),
      ),
    );
  }

  Widget presentStockView(){
    return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('출고가능 두수'),
            SizedBox(width: 20),
            Text(presentStock,style: TextStyle(color: Colors.red),),
          ],
        )

    );
  }

  void getPigsroomStock(String roomNo) async{

    final api = domain + 'getPigsroomStock';
    final data = {
      "companyCode":widget.companyCode,
      "roomNo":roomNo
    };
    final dio = Dio();
    Response response;
    response = await dio.post(api,data: data);
    if(response.statusCode == 200){
      setState(() {
        presentStock = response.data.toString();
      });
    }
  }

  Widget salePigSaveBtn(){
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            flex: 1,
            child: Container(
              width: 150,
              height: 30,
              child: OutlinedButton(onPressed: (){locator<NavigationService>().navigateTo(HomeRoute);}, child: Text("취소"),
                  style:OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      )
                  )),

            ),
          ),
          SizedBox(width: 5,),
          Flexible(
            flex: 1,
            child: Container(
              width: 150,
              height: 30,
              child: OutlinedButton(child: Text("저장",style: TextStyle(color: Colors.white),),
                style:OutlinedButton.styleFrom(
                  backgroundColor: const Color(0xf64481ee),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                ),
                onPressed: () async{



                  if(int.parse(inputQty) > int.parse(presentStock)){
                    resultToast("보유두수 보다 출고 두수가 많습니다.");
                    return;
                  }

                  if(selectedDropdownVender == '' || selectedDropdownVender == '0'){
                    resultToast("출고 거래처를 선택하세요.");
                    return;
                  }
                  if(_formKey.currentState!.validate()){
                    _formKey.currentState!.save();
                    final api = domain + 'salepigInsert';
                    final data = {
                      "companyCode":selectedDropdown,
                      "venderCode":selectedDropdownVender,
                      "roomNo":_roomNo,
                      "saleType":_selectedSaleTypes[0].toString(),
                      "yyyy":_yyyy,
                      "mm":_mm,
                      "dd":_dd,
                      "qty":_qty,
                    };
                    final dio = Dio();
                    Response response;
                    response = await dio.post(api,data: data);
                    if(response.statusCode == 200){
                      if(response.data.toString() == 'save'){
                        resultToast('자돈판매 저장되었습니다.');
                      }else{
                        resultToast('저장되지 않았습니다. \n\n 입력 정보를 체크하세요.');
                      }
                    }
                    // locator<NavigationService>().navigateTo(SalepigViewRoute, arguments: "0");
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SalepigView(companyCode: '0',)));
                  }else{
                    return;
                  }
                },
              ),
            ),
          ),
        ]
    );
  }

  Future<void> companysList() async{
    final api = domain + 'getCompanyinfoAll';
    final dio = Dio();
    Response response = await dio.get(api);
    if(response.statusCode == 200) {
      setState(() {
        List<dynamic> result = response.data;
        companys.assignAll(
            result.map((data) => Company.fromJson(data)).toList());
        companys.refresh();
        CompanyCombo combo;
        for (int i = 0; i < companys.length; i++) {
          combo = new CompanyCombo(
              companys[i].tabindex.toString(), companys[i].name.toString());
          companyList.add(combo);
        }
      }
      );
    }
  }

  Future<void> vendersList() async{
    final api = domain + 'getVenderAll';
    final dio = Dio();
    Response response = await dio.get(api);
    if(response.statusCode == 200) {
      setState(() {
        List<dynamic> result = response.data;
        venders.assignAll(result.map((data) => Vender.fromJson(data)).toList());
        venders.refresh();
        VenderCombo vendercombo;
        for (int i = 0; i < venders.length; i++) {
          vendercombo = new VenderCombo(venders[i].code,venders[i].name);
          venderList.add(vendercombo);
        }
      }
      );
    }
  }

  void nowDateSetCustom(){
    setState(() {
      var now = DateTime.now();
      yyyy.text = now.year.toString();
      String str = now.month.toString();
      mm.text=str.toString().padLeft(2, "0");
      str = now.day.toString();
      dd.text=str.toString().padLeft(2, "0");
    });
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
