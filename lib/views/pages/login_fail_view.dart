import 'package:flutter/material.dart';
import '../../controllers/login_controller.dart';
import '../../locator.dart';
import '../../routing/route_names.dart';
import '../../services/navigation_service.dart';
import 'package:get/get.dart' hide Response;

class LoginFailView extends StatefulWidget {
  String? returnPage;

  LoginFailView({Key? key, this.returnPage=LoginFailRoute}) : super(key: key);

  @override
  State<LoginFailView> createState() => _LoginFailViewState();
}

class _LoginFailViewState extends State<LoginFailView> {
  LoginController controller = Get.find();
  final GlobalKey<FormState> loginFailFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    controller.loginEmailController.dispose();
    controller.loginPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: loginFailFormKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            unitTitle(),
            SizedBox(height: 20),
            SizedBox(
              width: 400,
              child: buildEmail(),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 400,
              child: buildPassword(),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 400,
              child: buildLoginBtn(),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 400,
              child: buildForgotPassBtn(),
            ),
          ],
        ),
      ),
    );
  }

  Widget unitTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/login.png',width: 20,height: 20,),
        Text(' Login Fail',style: TextStyle(color:Colors.red,fontSize: 20,fontWeight: FontWeight.bold),)
      ],
    );
  }

  Widget buildEmail(){
    return Container(
      child: Column(
        children: [
          TextFormField(
            controller: controller.loginEmailController,
            // initialValue: 'aaa@a.com',
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

  Widget buildPassword(){
    return Container(
      child: Column(
        children: [
          TextFormField(
            controller: controller.loginPasswordController,
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
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please insert your password.';
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
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2),
      width: double.infinity,   //width full size
      height: 50,
      child: ElevatedButton.icon(
          onPressed: () async{
            controller.login(loginFailFormKey, widget.returnPage!);
          },
          icon: Icon(Icons.login),
          label: Text("Login")
      ),
    );
  }

  Widget buildForgotPassBtn(){
    return Stack(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () => {
                locator<NavigationService>().navigateTo(RegisterRoute)
              },
              child: Text(
                "Register?",
                style: TextStyle(
                    color: Colors.black26,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => {
                locator<NavigationService>().navigateTo(ForgetRoute)
              },
              child: Text(
                "Forget Password?",
                style: TextStyle(
                    color: Colors.black26,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
        ]
    );
  }
}
