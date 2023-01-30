import 'package:flutter/material.dart';
import '../../locator.dart';
import '../../routing/route_names.dart';
import '../../services/navigation_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class TestView extends StatefulWidget {
  const TestView({Key? key}) : super(key: key);
  @override
  TestViewState createState(){
    return TestViewState();
  }
}

class TestViewState extends State<TestView>{
  final _formKey = GlobalKey<FormState>();
  File? _image;
  final _picker = ImagePicker();

  Future<void> getImage(ImageSource source) async{
    ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
    await _picker.pickImage(source: source);
    if (pickedImage == null) return;
    final imageTemporary = File(pickedImage.path);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Form(
      key:_formKey,
      child: ListView(
        children: [
          imageProfile(),
          SizedBox(
            width: 400,
            height: 20,
          ),
          nameTextField(),
          SizedBox(
            height: 20,
          ),
          buildLoginBtn(),
        ],
      ),
    );
  }

  Widget imageProfile(){
    return Center(
      child:Stack(
      children: [
         _image != null
              ? Image.file(
            _image!,
            width: 250,
            height: 250,
            fit: BoxFit.cover,
          ):CircleAvatar(
           radius: 80.0,
           backgroundImage: AssetImage('assets/noimage.png'),
         ),
        Positioned(
          bottom: 20.0,
          right: 20.0,
          child: InkWell(
            onTap: (){
              showModalBottomSheet(
                  context: context,
                  builder: ((builder)=>bottomSheet()),
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
      )
    );
  }

  Widget bottomSheet(){
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: [
          Text(
            "Choose Profile photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                icon:Icon(Icons.camera),
                label: Text('Camera'),
                onPressed: (){
                  print('camera..');
                  getImage(ImageSource.camera);
                },
              ),
              TextButton.icon(
                icon:Icon(Icons.image),
                label: Text('Gallery'),
                onPressed: (){
                  getImage(ImageSource.gallery);
                },
              ),
            ],
          )
        ],
      ),
    );
  }



  Widget nameTextField(){
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.teal,
          )
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.orange,
            width: 2,
          )
        ),
        prefixIcon: Icon(
          Icons.person,
          color: Colors.green,
        ),
        labelText: 'name',
        helperText: 'name is empty'
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
