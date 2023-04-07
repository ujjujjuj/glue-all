import 'dart:async';
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

class TCPController extends GetxController {
  TCPClient client = TCPClient("192.168.1.159", 31337, "hello");
  RxBool isConnected = false.obs;
  RxList connectedDevices = [].obs;
  RxList recents = <UserActions>[].obs;

  String recievedData = "";

  UserController user = Get.find<UserController>();
  late final preferences;

  void saveRecents() async {
    final String encodedData = UserActions.encode(<UserActions>[...recents]);
    await preferences.setString('recents', encodedData);
  }

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  late AndroidDeviceInfo androidInfo;

  void getRecents() async {
    final String? recentsString = preferences.getString('recents');
    if (recentsString != null) {
      final List<UserActions> actions = UserActions.decode(recentsString);
      recents(actions);
    }
  }

  @override
  void onReady() async {
    preferences = await SharedPreferences.getInstance();
    getRecents();
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
      saveRecents();
    });

    client.get("CLIP_FILE", (dat) async {
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
      await filePath.writeAsBytes(dat['file']).catchError((onError) {
        print(onError);
      });
      print(filePath);
      Get.snackbar(
        "File Recieved",
        "from ${dat['name']}",
        backgroundColor: Colors.white,
        colorText: const Color(0xff2C2B2B),
        snackPosition: SnackPosition.BOTTOM,
      );
      saveRecents();
    });

    startConnection();
  }

  startConnection() {
    client.connect(() {
      isConnected(true);
      print("connected");
      client.authenticate(user.user.value.token);
    }, onDisconnect);
  }

  onDisconnect() {
    isConnected(false);
    Timer(const Duration(seconds: 3), () {
      startConnection();
    });
  }

  closeConnection() {
    client.disconnect();
  }

  sendData(data) async {
    if (isConnected.value) {
      if (data.toString().isNotEmpty) {
        client.sendText(data.toString(), androidInfo.model);
        recents.insert(
            0,
            UserActions(
                action: "Sent ${data.toString()}", toDevice: "Broadcast"));
      }
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
