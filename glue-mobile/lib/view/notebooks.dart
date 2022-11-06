import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:get/get.dart';
import 'package:glue/controllers/tcp_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class Notebooks extends StatelessWidget {
  Notebooks({super.key});

  TCPController tcpController = Get.find();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 100,
            ),
            Text(
              "Notebook",
              style: TextStyle(
                fontSize: 32,
                fontFamily: "Proxima Nova",
                fontWeight: FontWeight.w700,
                color: Color(0xff2C2B2B),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              decoration: InputDecoration(
                  filled: true,
                  focusColor: Color(0xffECECEC),
                  fillColor: Color(0xffECECEC),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Color(0xff2C2B2B),
                  ),
                  prefixIconColor: Color(0xff2C2B2B),
                  hintText: "Search across your notebook"),
              style: TextStyle(
                fontSize: 17,
                fontFamily: "Proxima Nova",
                fontWeight: FontWeight.w500,
                color: Color(0xff2C2B2B),
              ),
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
        ));
  }
}
