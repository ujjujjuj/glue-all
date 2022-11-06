import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class HomeController extends GetxController {
  var tabIndex = 0.obs;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  void changeTabIndex(int index) {
    tabIndex.value = index;
  }

  void toggleDrawer() {
    if (scaffoldKey.currentState!.isEndDrawerOpen) {
      scaffoldKey.currentState!.closeEndDrawer();
    } else {
      scaffoldKey.currentState!.openEndDrawer();
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
