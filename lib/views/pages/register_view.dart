import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../locator.dart';
import '../../routing/route_names.dart';
import '../../services/navigation_service.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  RegisterViewState createState(){
    return RegisterViewState();
  }
}

class RegisterViewState extends State<RegisterView>{
  final _formKey = GlobalKey<FormState>();
  String _email ='';
  String _password ='';
  String _name ='';
  String _phone ='';
  bool _emailCheck = false;
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController repassword = TextEditingController();
  String greetings='';
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Form(
      key:_formKey,
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              SizedBox(
                width: 400,height: 70,
                child:unitTitle(),
              ),

              SizedBox(
                width: 400,
                child: buildEmail(),
              ),

              SizedBox(
                width: 400,
                child: buildPassword(),
              ),

              SizedBox(
                width: 400,
                child: buildName(),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 400,
                child: buildLoginBtn(),
              ),
            ],
          ),
        ),

      ),
    );
  }

  Widget unitTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/registered.png',width: 20,height: 20,),
        Text(' Register',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)
      ],
    );
  }

  Widget buildEmail(){
    return Container(
      child: Column(
        children: [
          TextFormField (
            controller: email,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.email),
              // suffixIcon: Icon(Icons.star),
              suffixIcon: GestureDetector (
                  onTap: () async{
                    print('email:'+email.text);
                    final api ='https://www.dfxsoft.com:22070/api/confirmEmail';
                    final data = {
                      "email":email.text
                    };
                    final dio = Dio();
                    Response response;
                    print('before email:'+_email);
                    response = await dio.post(api,data: data);
                    if(response.statusCode == 200){
                      if(response.data == 'y')
                        _emailCheck = false;
                      else
                        _emailCheck = true;
                    }else{
                      print('faild.....email');
                    }
                    setState(() {
                      _emailCheck = !_emailCheck;
                    });
                  },
                  child: Icon(
                    _emailCheck ? Icons.check_box : Icons.check_box_outline_blank,
                  )),
              hintText: 'aaa@a.com',
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
            onSaved: (value){
              setState(() {
                _email = value as String;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {

                return 'Please insert your Email.';
              } else {
                String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp = new RegExp(pattern);
                if(!regExp.hasMatch(value)){
                  _emailCheck = false;
                  return 'Invalid email format!';
                }else{
                  return null;
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Widget buildPassword(){
    return Container(
      child: Column(
        children: [
          TextFormField(
            controller: password,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.lock),
              // suffixIcon: Icon(Icons.star),
              hintText: 'Insert new password',

              border: InputBorder.none,
              // labelText: 'Label Text',
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(0.5)),
                borderSide: BorderSide( width:2,color: Colors.blue),
              ),
              filled: true,
              fillColor: Colors.black12,

            ),
            keyboardType: TextInputType.text,
            obscureText: true,
            autovalidateMode: AutovalidateMode.always,
            onSaved: (value){
              setState(() {
                _password = value as String;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please insert your password.';
              } else {
                return null;
              }
            },
          ),

          TextFormField(
            controller: repassword,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.lock),
              // suffixIcon: Icon(Icons.star),
              hintText: 'check password',

              border: InputBorder.none,
              // labelText: 'Label Text',
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(0.5)),
                borderSide: BorderSide( width:2,color: Colors.blue),
              ),
              filled: true,
              fillColor: Colors.black12,

            ),
            keyboardType: TextInputType.text,
            obscureText: true,
            autovalidateMode: AutovalidateMode.always,
            onSaved: (value){
              setState(() {
                _password = value as String;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please insert your password.';
              }
              if (value != password.text){
                return 'no match password';
              }
              return null;
            },
          ),

        ],
      ),
    );
  }

  Widget buildName(){
    return Container(
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.person),
              // suffixIcon: Icon(Icons.star),
              hintText: 'Insert your name',

              border: InputBorder.none,
              // labelText: 'Label Text',
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(0.5)),
                borderSide: BorderSide( width:2,color: Colors.blue),
              ),
              filled: true,
              fillColor: Colors.black12,

            ),
            autovalidateMode: AutovalidateMode.always,
            onSaved: (value){
              setState(() {
                _name = value as String;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please insert your name.';
              } else {
                return null;
              }
            },
          ),

        ],
      ),
    );
  }

  Widget buildLoginBtn(){
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            // flex: 1,
            child: Container(
              height: 40,
              child: ElevatedButton.icon(
                onPressed: () async{
                  if(_formKey.currentState!.validate()){
                    _formKey.currentState!.save();

                    // final api ='http://192.168.35.233:22070/api/memberRegister';
                    final api ='https://www.dfxsoft.com/api/memberRegister';
                    final data = {
                      "email":_email,
                      "password":_password,
                      "name":_name,
                      "phone":_phone
                    };
                    final dio = Dio();
                    Response response;
                    print('before email:'+_email);
                    response = await dio.post(api,data: data);
                    if(response.statusCode == 200){
                      if(response.data.toString() == 'save'){
                        resultToast('회원등록 되었습니다. \n\n 로그인 후 사용하세요.');
                      }else{
                        resultToast('저정되지 않았습니다. \n\n 입력 정보를 체크하세요.');
                      }
                    }
                    locator<NavigationService>().navigateTo(HomeRoute);
                  }else{
                    return;
                  }
                },
                icon: Icon(Icons.save),
                label: Text("Register"),
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Flexible(
            // flex: 1,
            child: Container(
              height: 40,

              child: ElevatedButton.icon(
                onPressed: () async{
                  locator<NavigationService>().navigateTo(HomeRoute);
                },
                icon: Icon(Icons.cancel),
                label: Text("Cancel"),
              ),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
            ),
          ),

        ]
    );
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
