import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:shared_preferences/shared_preferences.dart';
import '../services/navigation_service.dart';
import '../locator.dart';
import '../model/user_model.dart';
import '../routing/route_names.dart';

class LoginController extends GetxController {
  Rx<User> myInfo = User().obs;

  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void login(GlobalKey<FormState> loginFormKey, String returnPage) async {
    if (loginFormKey.currentState!.validate()) {
      final api ='https://www.dfxsoft.com/api/login';
      final data = {
        "email":loginEmailController.text,
        "password":loginPasswordController.text,
      };
      final dio = Dio();
      Response response = await dio.post(api, data: data);
      if(response.statusCode == 200) {
        if (response.data == 'fail'){
          locator<NavigationService>().navigateTo(LoginFailRoute);
        } else {
          var result = response.data;
          myInfo.value = User.fromJson(result);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('userData', jsonEncode(myInfo));
          setUser();
          print('로그인 유저 이름: ${myInfo.value.name}');
          locator<NavigationService>().navigateTo(HomeRoute);
        }
      }
    }
  }

  // 웹에서 새로고침 해도 로그인 상태 유지
  Future<void> setUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('userData') != null) {
      String? userPref = prefs.getString('userData');
      Map<String, dynamic> userData = jsonDecode(userPref!) as Map<String, dynamic>;

      myInfo.value.id = userData['id'];
      myInfo.value.email = userData['email'];
      myInfo.value.name = userData['name'];
      myInfo.value.avatar = userData['avatar'] ?? '';
      myInfo.value.memlevel = userData['memlevel'] ?? 10;
      myInfo.value.phone = userData['phone'] ?? '';
    }
  }

}
