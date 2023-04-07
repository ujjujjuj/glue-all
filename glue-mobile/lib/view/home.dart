import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:glue/controllers/clip_controller.dart';
import 'package:glue/controllers/home_controller.dart';
import 'package:glue/controllers/tcp_controller.dart';
import 'package:glue/controllers/user_controller.dart';
import 'package:glue/theme/theme.dart';
import 'package:glue/view/landing.dart';
import 'package:glue/view/notebooks.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  buildBottomNavigationMenu(context, landingPageController) {
    return Obx(() => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: SizedBox(
          height: 80,
          child: BottomNavigationBar(
            showUnselectedLabels: false,
            showSelectedLabels: true,
            onTap: landingPageController.changeTabIndex,
            currentIndex: landingPageController.tabIndex.value,
            backgroundColor: const Color(0xff2C2B2B),
            unselectedItemColor: Colors.white.withOpacity(0.5),
            selectedItemColor: Colors.white,
            selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15,
                color: Colors.white,
                fontFamily: "Proxima Nova"),
            items: [
              BottomNavigationBarItem(
                  icon: Container(
                    margin: const EdgeInsets.only(bottom: 7),
                    child: const Icon(
                      Icons.home,
                      size: 25.0,
                    ),
                  ),
                  label: 'Home'),
              BottomNavigationBarItem(
                  icon: Container(
                    margin: const EdgeInsets.only(bottom: 7),
                    child: const Icon(
                      Icons.insert_drive_file_rounded,
                      size: 25.0,
                    ),
                  ),
                  label: 'Notebooks')
            ],
          ),
        )));
  }

  TCPController tcpController = Get.put(TCPController());
  ClipController clipController = Get.put(ClipController());
  UserController user = Get.find();
  @override
  Widget build(BuildContext context) {
    final HomeController landingPageController =
        Get.put(HomeController(), permanent: false);
    return SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
            key: landingPageController.scaffoldKey,
            backgroundColor: Colors.white,
            endDrawer: Drawer(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      tcpController.closeConnection();
                      user.logOut();
                    },
                    child: const Text(
                      "Log Out",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.15,
                          color: secondary,
                          fontFamily: "Proxima Nova"),
                    ),
                  )
                ],
              ),
            ),
            bottomNavigationBar:
                buildBottomNavigationMenu(context, landingPageController),
            body: Stack(children: [
              Positioned(
                right: 25,
                top: 55,
                child: GestureDetector(
                  onTap: () {
                    landingPageController.toggleDrawer();
                  },
                  child: const Icon(
                    Icons.menu_rounded,
                    size: 33,
                  ),
                ),
              ),
              Obx(() => IndexedStack(
                    index: landingPageController.tabIndex.value,
                    children: [const Landing(), Notebooks()],
                  ))
            ])));
  }
}
