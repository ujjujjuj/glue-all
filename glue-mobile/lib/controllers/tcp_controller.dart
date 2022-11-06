import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:glue/controllers/user_controller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:glue/models/actions.dart';
import 'package:glue/models/tcp_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_dtx/shared_preferences_dtx.dart';

class TCPController extends GetxController {
  TCPClient client = TCPClient("192.168.196.25", 31337, "hello");
  RxBool isConnected = false.obs;
  RxList connectedDevices = [
    // Device(deviceName: "Macbook Air", deviceType: "PC"),
  ].obs;
  RxList recents = [
    // UserActions(action: "Sent an image", toDevice: "MacBook Air"),
  ].obs;

  String recievedData = "";

  UserController user = Get.find<UserController>();

  // void saveRecents() async {
  //   final preferences = await SharedPreferences.getInstance();
  //   await preferences.setValue("recent", <UserActions>[...recents]);
  // }

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  late AndroidDeviceInfo androidInfo;

  // void getRecents() async {
  //   final preferences = await SharedPreferences.getInstance();
  //   var recentList = preferences.getValue<List<UserActions>>("recent");
  //   if (recentList != null) {
  //     recents(recentList);
  //   }
  // }

  @override
  void onReady() async {
    androidInfo = await deviceInfo.androidInfo;
    client.get("AUTH_OK", (data) {
      client.state["auth"] = true;
      client.state["id"] = data["id"];
      user.user.value.authId = data["id"];
    });

    client.get("CLIP_TEXT", (dat) async {
      recents.insert(
          0,
          UserActions(
              action: "Recieved ${dat["text"]}", toDevice: dat['name']));
      recievedData = dat["text"];
      await Clipboard.setData(ClipboardData(text: dat["text"]));
    });

    client.get("CLIP_FILE", (dat) async {
      print(dat);
      recents.insert(
          0,
          UserActions(
              action: "Recieved File ${dat['fileName']}",
              toDevice: dat['name']));
      var directory = Directory('/storage/emulated/0/Download');
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        if (!await directory.exists()) {
          directory = (await getExternalStorageDirectory())!;
        }
      }
      final filePath =
          await File('${directory.path}/${dat['fileName']}').create();
      await filePath.writeAsBytes(dat['file']);
      Get.snackbar(
        "File Recieved",
        "from ${dat['name']}",
        backgroundColor: Colors.white,
        colorText: Color(0xff2C2B2B),
        snackPosition: SnackPosition.BOTTOM,
      );
    });

    startConnection();
  }

  startConnection() {
    client.connect(() {
      isConnected(true);
      client.authenticate(user.user.value.token);
    }, onDisconnect);
  }

  onDisconnect() {
    isConnected(false);
    print('[-] Retrying...');
    Timer(const Duration(seconds: 3), () {
      startConnection();
    });
  }

  sendData(data) async {
    if (isConnected.value) {
      client.sendText(data.toString(), androidInfo.model);
      recents.insert(
          0,
          UserActions(
              action: "Sent ${data.toString()}", toDevice: "Broadcast"));
    }
  }

  sendFile(data, name) async {
    if (isConnected.value) {
      client.sendFile(data, name, androidInfo.model);
      recents.insert(
          0, UserActions(action: "Sent File $name", toDevice: "Broadcart"));
    }
  }
}
