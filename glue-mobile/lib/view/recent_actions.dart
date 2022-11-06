import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:get/get.dart';
import 'package:glue/controllers/tcp_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class RecentActions extends StatelessWidget {
  RecentActions({super.key});
  final TCPController tcpController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 70,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    padding: EdgeInsets.only(bottom: 2),
                    child: Icon(Icons.arrow_back_ios_new_rounded,
                        color: Color(0xff2C2B2B), size: 18),
                  ),
                ),
                SizedBox(
                  width: 7,
                ),
                Text(
                  "Recent Actions",
                  style: TextStyle(
                    fontSize: 23,
                    fontFamily: "Proxima Nova",
                    fontWeight: FontWeight.w700,
                    color: Color(0xff2C2B2B),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
                child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Obx(
                () => Wrap(
                  runSpacing: 15,
                  children: tcpController.recents.isNotEmpty
                      ? tcpController.recents
                          .map((element) => Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                        flex: 65,
                                        child: Linkify(
                                            onOpen: (link) async {
                                              if (await canLaunchUrl(
                                                  Uri.parse(link.url))) {
                                                await launchUrl(
                                                    Uri.parse(link.url));
                                              } else {
                                                //
                                              }
                                            },
                                            text: element.action,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w400,
                                                height: 1.1,
                                                color: Color(0xff2C2B2B),
                                                fontFamily: "Proxima Nova"),
                                            linkStyle: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w400,
                                                height: 1.1,
                                                color: Color(0xff3B86F5),
                                                fontFamily: "Proxima Nova"))),
                                    Expanded(
                                        flex: 35,
                                        child: Text(
                                          element.toDevice,
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              fontSize: 15,
                                              height: 1.2,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xff2C2B2B),
                                              fontFamily: "Proxima Nova"),
                                        ))
                                  ]))
                          .toList()
                      : [],
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
