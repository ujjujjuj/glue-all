import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:buffer/buffer.dart';
import 'package:flutter/foundation.dart';
import 'package:msgpack_dart/msgpack_dart.dart';

class TCPClient {
  var host;
  int port;
  String token;
  late Socket s;
  bool isProcessing = false;
  num lengthRemaining = 0;
  var buffers = List.empty(growable: true);
  Map<String, dynamic> routes = {};
  Map<String, dynamic> state = {"auth": false, "id": null};

  TCPClient(this.host, this.port, this.token);

  connect(onSuccess, onDisconnect) async {
    try {
      s = await Socket.connect(host, port);
      print('Connected to: ${s.remoteAddress.address}:${s.remotePort}');
      s.setOption(SocketOption.tcpNoDelay, true);
      onSuccess();
      s.listen(onData, onDone: () {
        print("Disconnected");
        s.close();
        onDisconnect();
      }, onError: (error) {
        print(error.toString());
        s.close();
        onDisconnect();
      });
    } catch (error) {
      print(error);
      onDisconnect();
    }
  }

  send(obj) {
    var data = serialize(obj);
    int length = data.length;
    ByteDataWriter buffer =
        ByteDataWriter(bufferLength: length + 4, endian: Endian.little);
    buffer.writeUint32(length);
    buffer.write(data);
    s.add(buffer.toBytes());
  }

  Uint8List int32bytes(int value) =>
      Uint8List(4)..buffer.asInt32List()[0] = value;

  authenticate(token) {
    send({"type": "AUTH", "token": token, "name": "naman", "device": "Phone"});
  }

  sendText(text, sname) {
    send({"type": "CLIP_TEXT", "text": text, "name": sname});
  }

  sendFile(bytes, name, sname) {
    send({"type": "CLIP_FILE", "file": bytes, "fileName": name, "name": sname});
  }

  onData(buff) {
    if (buff.isEmpty) return;
    if (isProcessing) {
      if (buff.length >= lengthRemaining) {
        buffers = buffers + buff;
        buff = buffers;
        buffers = [];
      } else {
        buffers = buffers + buff;
        lengthRemaining -= buff.length;
        return;
      }
    } else {
      int length = readUInt32LE(buff, 0);
      if (buff.length < length - 4) {
        isProcessing = true;
        lengthRemaining = length - buff.length - 4;
        buffers = buff;
        return;
      }
    }

    isProcessing = false;
    int length = readUInt32LE(Uint8List.fromList(buff), 0);
    Uint8List data = Uint8List.fromList(buff.sublist(4, length + 4));
    Map<dynamic, dynamic> obj = deserialize(data);
    if (routes.keys.contains(obj["type"])) {
      routes[obj["type"]](obj);
    } else {
      print('Unknown route ${obj["type"]}');
    }
    onData(buff.sublist(length + 4));
  }

  int readUInt32LE(Uint8List b, int idx) {
    return b[idx + 3] * (1 << 24) +
        (b[idx + 2] << 16) +
        (b[idx + 1] << 8) +
        b[idx];
  }

  get(route, handler) {
    routes[route] = handler;
  }
}
