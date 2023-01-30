import 'package:flutter/material.dart';
import '../../locator.dart';
import '../../routing/route_names.dart';
import '../../services/navigation_service.dart';

class BaseForm extends StatefulWidget {
  const BaseForm({Key? key}) : super(key: key);

  @override
  BaseFormState createState(){
    return BaseFormState();
  }
}

class BaseFormState extends State<BaseForm>{
  final _formKey = GlobalKey<FormState>();
  String _email ='';
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Form(
        key:_formKey,
        child: Column(
        children: [
          Text('base form'),
          SizedBox(
            width: 400,
            child: buildEmail(),
          ),

          SizedBox(
            width: 400,
            child: buildLoginBtn(),
          ),

        ],
      ),
    );
  }

  Widget buildEmail(){
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.email),
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

  Widget buildLoginBtn(){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2),
      width: double.infinity,   //width full size
      height: 50,
      child: ElevatedButton.icon(
          onPressed: () {
            if(_formKey.currentState!.validate()){
              _formKey.currentState!.save();
            }else{
              return;
            }
            print('save click');
            locator<NavigationService>().navigateTo(ResultRoute);
          },
          icon: Icon(Icons.save),
          label: Text("Register")
      ),
    );
  }
}
