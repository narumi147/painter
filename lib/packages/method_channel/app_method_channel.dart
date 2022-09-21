import 'package:flutter/services.dart';

import 'package:painter/models/db.dart';
import '../platform/platform.dart';

// default channel
const MethodChannel kMethodChannel = MethodChannel('painter.narumi.cc/painter');

class AppMethodChannel {
  static void configMethodChannel() {
    kMethodChannel.setMethodCallHandler((call) async {
      print('[dart] on call: ${call.method}, ${call.arguments}');
    });
  }

  /// Set window always on top
  ///
  /// only available on macOS
  static Future<void> setAlwaysOnTop([bool? onTop]) async {
    if (PlatformU.isWindows || PlatformU.isMacOS) {
      onTop ??= db.settings.alwaysOnTop;
      return kMethodChannel.invokeMethod<bool?>(
        'alwaysOnTop',
        <String, dynamic>{
          'onTop': onTop,
        },
      ).then((value) => print('alwaysOnTop success = $value'));
    }
  }

  static Future<void> setWindowPos([dynamic rect]) async {
    if (PlatformU.isWindows) {
      rect ??= db.settings.windowPosition;
      print('rect ${rect.runtimeType}: $rect');
      if (rect != null &&
          rect is List &&
          rect.length == 4 &&
          rect.any((e) => e is int && e > 0)) {
        print('ready to set window rect: $rect');
        return kMethodChannel.invokeMethod('setWindowRect', <String, dynamic>{
          'pos': rect,
        });
      }
    }
  }
}
