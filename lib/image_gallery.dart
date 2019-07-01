import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';

class FlutterGallaryPlugin {
  static const MethodChannel _channel =
      const MethodChannel('image_gallery');


  static Future<Object> get getAllImages async {
    if (Platform.isIOS) {
      List object = await _channel.invokeMethod('getAllImages');
      return object;
    } else {
      List object = await _channel.invokeListMethod('getAllImages');

      List<String> result = new List();
      for (var item in object) {
        result.add(item['path']);
      }

      return result.reversed.toList();
    }
  }
}
