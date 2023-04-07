import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:get/get.dart';
import 'package:glue/controllers/tcp_controller.dart';
import 'package:glue/controllers/user_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class Landing extends StatefulWidget {
  const Landing({Key? key}) : super(key: key);
  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  final UserController user = Get.find();
  final TCPController tcpController = Get.find();
  var deviceIndex = -1;

  Widget getDevice(element, index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          deviceIndex = index;
        });
      },
      child: SizedBox(
        width: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: (index == deviceIndex)
                          ? const Color.fromARGB(154, 44, 43, 43)
                          : const Color(0xffECECEC),
                      width: 1),
                  color: const Color(0xffECECEC),
                  borderRadius: BorderRadius.circular(4)),
              width: 110,
              height: 110,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Image.asset(
                  element.img,
                  width: 50,
                  height: 50,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              element.deviceName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  height: 1.1,
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.15,
                  color: Color(0xff2C2B2B),
                  fontFamily: "Proxima Nova"),
            )
          ],
        ),
      ),
    );
  }

  getBoxWidth(context) {
    return (MediaQuery.of(context).size.width - 78) / 3;
  }

  bool clipOt = false, fileOt = false, imageOt = false;

  List<dynamic> getRecentList(RxList<dynamic> list) {
    if (list.length > 3) {
      return list.value.sublist(0, 3);
    } else {
      return list;
    }
  }

  Future<Uint8List?> _readFileByte(String filePath) async {
    Uri myUri = Uri.parse(filePath);
    File myFile = new File.fromUri(myUri);
    Uint8List? bytes;
    await myFile.readAsBytes().then((value) {
      bytes = Uint8List.fromList(value);
    }).catchError((onError) {
    });
    return bytes;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 25),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          const SizedBox(height: 90),
          Text("Hello,", style: Theme.of(context).textTheme.headline6),
          const SizedBox(
            height: 5,
          ),
          Text('${user.user.value.userName}.',
              style: Theme.of(context).textTheme.headline1),
          const SizedBox(
            height: 23,
          ),
          Text("Connected Devices",
              style: Theme.of(context).textTheme.headline4),
          const SizedBox(
            height: 16,
          ),
          Obx(() => SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.start,
                  spacing: 23,
                  children: tcpController.connectedDevices.isNotEmpty
                      ? tcpController.connectedDevices
                          .asMap()
                          .map((index, element) =>
                              MapEntry(index, getDevice(element, index)))
                          .values
                          .toList()
                      : [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: 110,
                                  height: 110,
                                  decoration: BoxDecoration(
                                      color: const Color(0xffECECEC),
                                      borderRadius: BorderRadius.circular(4)),
                                  child: const Icon(
                                    Icons.broadcast_on_personal,
                                    color: Color(0xff8C8C8C),
                                    size: 50,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  "Broadcast",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      height: 1.1,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.15,
                                      color: Color(0xff2C2B2B),
                                      fontFamily: "Proxima Nova"),
                                )
                              ])
                        ],
                ),
              )),
          const SizedBox(
            height: 20,
          ),
          Text("Share", style: Theme.of(context).textTheme.headline4),
          const SizedBox(
            height: 12,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 25),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Clipboard.getData(Clipboard.kTextPlain).then((value) {
                      tcpController.sendData(value?.text);
                    });
                  },
                  onTapDown: (_) {
                    setState(() {
                      clipOt = true;
                    });
                  },
                  onTapUp: (_) {
                    setState(() {
                      clipOt = false;
                    });
                  },
                  onHorizontalDragEnd: (details) {
                    setState(() {
                      clipOt = false;
                    });
                  },
                  onVerticalDragEnd: (details) {
                    setState(() {
                      clipOt = false;
                    });
                  },
                  onPanDown: (details) {
                    setState(() {
                      clipOt = true;
                    });
                  },
                  child: Container(
                    width: getBoxWidth(context),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                        color: clipOt ? const Color(0xff2C2B2B) : Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border:
                            Border.all(color: const Color(0xff2C2B2B), width: 1.7)),
                    alignment: Alignment.center,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.paste,
                            color: clipOt ? Colors.white : const Color(0xff2C2B2B),
                            size: 22,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "Clip",
                            style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w600,
                                color:
                                    clipOt ? Colors.white : const Color(0xff2C2B2B),
                                fontFamily: "Proxima Nova"),
                          )
                        ]),
                  ),
                ),
                GestureDetector(
                  onTapDown: (_) {
                    setState(() {
                      fileOt = true;
                    });
                  },
                  onTapUp: (_) {
                    setState(() {
                      fileOt = false;
                    });
                  },
                  onHorizontalDragEnd: (details) {
                    setState(() {
                      fileOt = false;
                    });
                  },
                  onVerticalDragEnd: (details) {
                    setState(() {
                      fileOt = false;
                    });
                  },
                  onPanDown: (details) {
                    setState(() {
                      fileOt = true;
                    });
                  },
                  onTap: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles();

                    if (result != null) {
                      _readFileByte(result.files.first.path!).then((value) {
                        if (value != null) {
                          tcpController.sendFile(
                              value, result.files.first.name);
                        }
                      });
                    } else {
                      // User canceled the picker
                    }
                  },
                  child: Container(
                    width: getBoxWidth(context),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                        color: fileOt ? const Color(0xff2C2B2B) : Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border:
                            Border.all(color: const Color(0xff2C2B2B), width: 1.7)),
                    alignment: Alignment.center,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.insert_drive_file_outlined,
                            color: fileOt ? Colors.white : const Color(0xff2C2B2B),
                            size: 22,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "File",
                            style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w600,
                                color:
                                    fileOt ? Colors.white : const Color(0xff2C2B2B),
                                fontFamily: "Proxima Nova"),
                          )
                        ]),
                  ),
                ),
                GestureDetector(
                  onTapUp: (_) {
                    setState(() {
                      imageOt = false;
                    });
                  },
                  onHorizontalDragEnd: (details) {
                    setState(() {
                      imageOt = false;
                    });
                  },
                  onPanDown: (details) {
                    setState(() {
                      imageOt = true;
                    });
                  },
                  onVerticalDragEnd: (details) {
                    setState(() {
                      imageOt = false;
                    });
                  },
                  onTap: () async {
                    FilePickerResult? result = await FilePicker.platform
                        .pickFiles(type: FileType.image);

                    if (result != null) {
                      _readFileByte(result.files.first.path!).then((value) {
                        if (value != null) {
                          tcpController.sendFile(
                              value, result.files.first.name);
                        }
                      });
                    } else {
                      // User canceled the picker
                    }
                  },
                  child: Container(
                    width: getBoxWidth(context),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                        color: !imageOt ? Colors.white : const Color(0xff2C2B2B),
                        borderRadius: BorderRadius.circular(5),
                        border:
                            Border.all(color: const Color(0xff2C2B2B), width: 1.7)),
                    alignment: Alignment.center,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_outlined,
                            color: imageOt ? Colors.white : const Color(0xff2C2B2B),
                            size: 22,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "Image",
                            style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w600,
                                color:
                                    imageOt ? Colors.white : const Color(0xff2C2B2B),
                                fontFamily: "Proxima Nova"),
                          )
                        ]),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(right: 25),
            height: 1.1,
            color: const Color(0xff2C2B2B),
          ),
          const SizedBox(
            height: 23,
          ),
          GestureDetector(
            onTap: () {
              Get.toNamed("/recent");
            },
            child:
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Text("Recent Actions",
                  style: Theme.of(context).textTheme.headline4),
              const SizedBox(
                width: 8,
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child:
                      Text(">", style: Theme.of(context).textTheme.headline4)),
            ]),
          ),
          const SizedBox(
            height: 12,
          ),
          Expanded(
            child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Obx(
                  () => Padding(
                    padding: const EdgeInsets.only(right: 25),
                    child: Wrap(
                      runSpacing: 15,
                      children: tcpController.recents.isNotEmpty
                          ? getRecentList(tcpController.recents)
                              .map((element) => Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                            flex: 70,
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
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w400,
                                                    color: Color(0xff2C2B2B),
                                                    fontFamily: "Proxima Nova"),
                                                linkStyle: const TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w400,
                                                    color: Color(0xff3B86F5),
                                                    fontFamily:
                                                        "Proxima Nova"))),
                                        Expanded(
                                            flex: 30,
                                            child: Text(
                                              element.toDevice,
                                              textAlign: TextAlign.right,
                                            ))
                                      ]))
                              .toList()
                          : [],
                    ),
                  ),
                )),
          )
        ],
      ),
    );
  }
}
