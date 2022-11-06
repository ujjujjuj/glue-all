import 'package:flutter/material.dart';

class Device {
  String deviceName;
  String deviceType;
  String img = "";
  Device({required this.deviceName, required this.deviceType}) {
    if (deviceType == "PC") {
      img = "images/laptop.png";
    } else {
      img = "images/mobile.png";
    }
  }
}
