import 'dart:convert';

import 'package:get/get.dart';
import 'package:glue/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends GetxController {
  Rx<UserModel> user = UserModel(token: "", userName: "", authId: "").obs;

  set name(String uName) {
    user.value.userName = uName;
    saveLocal();
  }

  void saveLocal() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString('user', jsonEncode(user.value.toJson()));
  }

  void setUser(Map<String, dynamic> data) {}

  @override
  void onReady() async {
    final prefs = await SharedPreferences.getInstance();

    final user = prefs.getString('user');

    if (user != null) {
      this.user.value = UserModel.fromJson(json: jsonDecode(user));
    }

    if (user != null) {
      Get.offAllNamed('/home');
    } else {
      Get.offAllNamed('/login');
    }

    super.onReady();
  }

  void setUserFromJson(Map<String, dynamic> data) {
    user.update((val) {
      if (val == null) return;
      val.token = data['token'];
      val.userName = data['userName'];
      val.authId = data['authId'];
    });
  }

  void loginUser(name, token) {
    user.value.userName = name;
    user.value.token = token;
    saveLocal();
    Get.offAllNamed('/home');
  }

  void logOut() async {
    final prefs = await SharedPreferences.getInstance();
    
    prefs.remove('user');
    Get.offAndToNamed("/login");
  }
}
