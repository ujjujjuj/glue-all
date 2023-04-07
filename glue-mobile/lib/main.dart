import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:get/route_manager.dart';
import 'package:glue/controllers/init_binding.dart';
import 'package:glue/routes.dart';
import 'package:glue/theme/theme.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  void enableNotification() async {
    const androidConfig = FlutterBackgroundAndroidConfig(
      notificationTitle: "Glue",
      notificationText: "Listening to Clipboard",
      notificationImportance: AndroidNotificationImportance.Default,
      notificationIcon: AndroidResource(
          name: 'background_icon',
          defType: 'drawable'), // Default is ic_launcher from folder mipmap
    );
    bool hasPermissions = await FlutterBackground.hasPermissions;

    bool success =
        await FlutterBackground.initialize(androidConfig: androidConfig);
    bool success2 = await FlutterBackground.enableBackgroundExecution();
  }

  void getFileStorageNotification() async {
    await Permission.storage.request();
  }

  @override
  Widget build(BuildContext context) {
    enableNotification();
    getFileStorageNotification();
    return GetMaterialApp(
      initialBinding: Init(),
      debugShowCheckedModeBanner: false,
      theme: theme,
      getPages: routes,
    );
  }
}
