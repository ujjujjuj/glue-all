import 'dart:async';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:glue/controllers/tcp_controller.dart';

class ClipController extends GetxController {
  var clipData = "".obs;
  TCPController controller = Get.find<TCPController>();
  @override
  void onReady() async {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      Clipboard.getData(Clipboard.kTextPlain).then((value) {
        if (value != null) {
          if (value.text != clipData.value &&
              (controller.recievedData != value.text)) {
            controller.sendData(value.text);
            clipData(value.text);
          }
        }
      });
    });
  }
}
