import 'package:get/route_manager.dart';
import 'package:glue/view/home.dart';
import 'package:glue/view/login.dart';
import 'package:glue/view/recent_actions.dart';
import 'package:glue/view/splash_screen.dart';

final routes = [
  GetPage(
    name: '/',
    page: () => const SplashScreen(),
  ),
  GetPage(name: '/home', page: () => const Home()),
  GetPage(name: "/recent", page: () => RecentActions()),
  GetPage(name: "/login", page: () => Login())
];
