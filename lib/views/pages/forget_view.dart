import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../locator.dart';
import '../../routing/route_names.dart';
import '../../services/navigation_service.dart';

class ForgetView extends StatefulWidget {
  const ForgetView({Key? key}) : super(key: key);

  @override
  ForgetViewState createState() {
    return ForgetViewState();
  }
}

class ForgetViewState extends State<ForgetView> {
  final _formKey = GlobalKey<FormState>();

  String _email ='';
  @override
  Widget build(BuildContext context) {
    return Form(
      key:_formKey,
      child: Column(

        children: [
          SizedBox(height: 20),
          SizedBox(
            width: 400,height: 70,
            child:unitTitle(),
          ),
          SizedBox(height: 20),
          SizedBox(
            width: 400,
            child: buildEmail(),
          ),
          SizedBox(height: 20),

          SizedBox(
            width: 400,
            child: findPasswordBtn(),
          ),
        ],
      ),
    );
  }

  Widget unitTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/search.png',width: 20,height: 20,),
        Text(' Find Password',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)
      ],
    );
  }

  Widget buildEmail(){
    return Container(
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.email),
              // suffixIcon: Icon(Icons.star),
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

  Widget findPasswordBtn(){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2),
      width: double.infinity,   //width full size
      height: 50,
      child: ElevatedButton.icon(
          onPressed: () async{
            if(_formKey.currentState!.validate()){
              _formKey.currentState!.save();

              final api ='https://www.dfxsoft.com/api/forgetPassword';
              final data = {
                "email":_email
              };
              final dio = Dio();
              Response response = await dio.post(api,data: data);

              CircularProgressIndicator(
                backgroundColor: Colors.redAccent,
                valueColor: AlwaysStoppedAnimation(Colors.green),
                strokeWidth: 10,
              );

              if(response.statusCode == 200){


                if(response.data =='nothing'){
                  String msg='Does not exist email !';
                  showAlertDialog(context,msg);
                }else{

                  String msg='sent a new password !';
                  showAlertDialog(context,msg);
                  locator<NavigationService>().navigateTo(HomeRoute);
                }
              }
            }else{
              return;
            }
          },
          icon: Image.asset('assets/send_mail.png',width: 20,height: 20,),
          label: Text("Send Email for New Password"),

      ),
    );
  }

  Future<dynamic> showAlertDialog(BuildContext context,String msg) async{
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Email Check',style:TextStyle(color: Colors.red)),
        content: Text(msg),

        actions: [
          ElevatedButton(
              onPressed: () => {
                Navigator.pop(context, false),
              },
              child: Text('Sure')),

        ],
      ),
    );
  }
}
