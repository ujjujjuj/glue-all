import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:get/get.dart';
import 'package:glue/controllers/search_controller.dart';
import 'package:glue/controllers/tcp_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class Notebooks extends StatelessWidget {
  Notebooks({super.key});

  TCPController tcpController = Get.find();
  SearchController searchController = Get.put(SearchController());

  List<dynamic> filter(RxList items, String query) {
    return items
        .where((item) =>
            item.action.toString().toUpperCase().contains(query.toUpperCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 100,
            ),
            const Text(
              "Notebook",
              style: TextStyle(
                fontSize: 32,
                fontFamily: "Proxima Nova",
                fontWeight: FontWeight.w700,
                color: Color(0xff2C2B2B),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              onChanged: (value) {
                searchController.query(value);
              },
              decoration: const InputDecoration(
                  filled: true,
                  focusColor: Color(0xffECECEC),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 14, horizontal: 15),
                  fillColor: Color(0xffECECEC),
                  suffixIcon: Icon(
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
            const SizedBox(
              height: 20,
            ),
            Expanded(
                child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Obx(
                () => Wrap(
                  runSpacing: 15,
                  children: tcpController.recents.isNotEmpty
                      ? filter(tcpController.recents,
                              searchController.query.value)
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
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w400,
                                                height: 1.1,
                                                color: Color(0xff2C2B2B),
                                                fontFamily: "Proxima Nova"),
                                            linkStyle: const TextStyle(
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
                                          style: const TextStyle(
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
