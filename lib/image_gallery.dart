import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';

class FlutterGallaryPlugin {
  static const MethodChannel _channel =
      const MethodChannel('image_gallery');


  static Future<Object> get getAllImages async {
    if (Platform.isIOS) {
      var object = await _channel.invokeMethod('getAllImages');
      List result = new List.from(object);
      result.removeWhere((item) => item['actualPath'].toString().endsWith('.HEIC'));
      return result;
    } else {
      var object = await _channel.invokeListMethod('getAllImages');

      List<String> result = new List();
      for (var item in object) {
        result.add(item['actualPath']);
      }

      return result.reversed.toList();
    }
  }

  static Future<int> get getImagesCount async {
    return await _channel.invokeMethod('getImagesCount');
  }
}
