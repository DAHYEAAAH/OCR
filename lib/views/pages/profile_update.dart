import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../controllers/login_controller.dart';
import '../../locator.dart';
import '../../routing/route_names.dart';
import '../../services/navigation_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart' hide Response;

class ProfileUpdate extends StatefulWidget {

  const ProfileUpdate({Key? key}) : super(key: key);
  @override
  ProfileUpdateState createState(){
    return ProfileUpdateState();
  }
}

class ProfileUpdateState extends State<ProfileUpdate>{
  late PickedFile _imageFile;
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  var dia_email;
  var dia_password;
  var dia_name;
  var dia_avatar;

  String _email ='';
  String _password ='';
  String _name ='';
  String _phone ='';
  var _avatar =''.obs;
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController repassword = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController avatar = TextEditingController();
  String greetings='';

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    userGet();
    return Form(
      key:_formKey,
      child: Column(
        children: [
          SizedBox(
            width: 400,height: 70,
            child:unitTitle(),
          ),
          SizedBox(
            width: 400,height: 70,
            child:profileAvatar(),
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
            width: 400,
            child: buildPhone(),
          ),

          SizedBox(
            width: 400,
            child: buildUpdateBtn(),
          ),
        ],
      ),
    );
  }

  Widget unitTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/registered.png',width: 20,height: 20,),
        Text(' Profile Update',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)
      ],
    );
  }

  Widget profileAvatar() {
    return
      Obx(() => Container(
        child: Stack(
          alignment: Alignment(0.0, 0.0),
          children: [
            _avatar == '' ?
            CircleAvatar(
              radius: 80.0,
              backgroundImage: AssetImage('assets/noimage.png'),
            ):
            CircleAvatar(
              radius: 80.0,
              backgroundImage: AssetImage(_avatar.value,),
            ),
            Positioned(
              bottom: 20.0,
              right: 20.0,
              child: InkWell(
                onTap: (){
                  showModalBottomSheet(
                      context: context,
                      builder: ((builder)=>shotCamera()),
                  );
                },
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.teal,
                  size: 28.0,
                ),
              ),
            ),
          ],
        ),

      ));
  }

  Widget shotCamera() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: [
          Text("Choose profile photo",style: TextStyle(fontSize: 20.0),),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                icon: Icon(Icons.camera_alt),
                onPressed: (){
                  takePhoto(ImageSource.camera);
                },
                label: Text('Camera'),
              ),
              TextButton.icon(
                icon: Icon(Icons.image),
                onPressed: (){
                  takePhoto(ImageSource.gallery);
                },
                label: Text('Gallery'),
              ),
            ],
          )
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async{
    final pickedFile = await _picker.getImage(
        source: source,
    );
    setState(() {
      _imageFile = pickedFile!;
    });
  }

  Widget buildEmail(){
    return Container(
      child: Column(
        children: [

          TextFormField (
            controller: email,
            enabled: false,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.email),
              // suffixIcon: Icon(Icons.star),
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
            onTap: (){
              password.clear();
              repassword.clear();
            },
            controller: password,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.lock),
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
            controller: name,
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

  Widget buildPhone(){
    return Container(
      child: Column(
        children: [
          TextFormField(
            controller: phone,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.phone_android),
              // suffixIcon: Icon(Icons.star),
              hintText: 'Insert your phone number',

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
                _phone = value as String;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please insert your phone number.';
              } else {
                return null;
              }
            },
          ),

        ],
      ),
    );
  }

  Widget buildUpdateBtn(){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2),
      width: double.infinity,   //width full size
      height: 50,
      child: ElevatedButton.icon(
          onPressed: () async{
            if(_formKey.currentState!.validate()){
              _formKey.currentState!.save();
              final api ='https://www.dfxsoft.com/api/memberUpdate';
              final data = {
                "email":_email,
                "password":_password,
                "name":_name,
                "phone":_phone,
                // "avatar":_avatar
              };
              final dio = Dio();
              Response response;
              response = await dio.post(api,data: data);
              if(response.statusCode == 200){
                print('response.....'+response.data);
              }else{
              }
              locator<NavigationService>().navigateTo(HomeRoute);
            }else{
              return;
            }
          },
          icon: Icon(Icons.save),
          label: Text("save")
      ),
    );
  }

  void userGet() async {
    final api = 'https://www.dfxsoft.com/api/getUser';
    final dio = Dio();
    LoginController loginController = Get.find();

    final data = {
      "email": loginController.myInfo.value.email
    };
    Response response = await dio.post(api, data: data);
    if (response.statusCode == 200) {
      print('--------------->>');
      email.text = response.data[1];
      password.text = response.data[2];
      repassword.text = response.data[2];
      name.text = response.data[3];
      phone.text = response.data[4];
      if(response.data[6]==null){
        _avatar.value='';
      }else{
        _avatar.value = response.data[6];
      }

    }
  }
}