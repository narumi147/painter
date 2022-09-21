import 'package:flutter/foundation.dart';

import 'package:screenshot/screenshot.dart';

import '../packages/app_info.dart';

class RuntimeData {
  double? criticalWidth;

  // debug
  bool _enableDebugTools = false;

  bool get enableDebugTools =>
      _enableDebugTools || kDebugMode || AppInfo.isDebugDevice;

  set enableDebugTools(bool v) => _enableDebugTools = v;

  bool _showDebugFAB = true;

  bool get showDebugFAB => _showDebugFAB && enableDebugTools;

  set showDebugFAB(bool value) => _showDebugFAB = value;

  bool showWindowManager = false;

  /// Controller of [Screenshot] widget which set root [MaterialApp] as child
  final screenshotController = ScreenshotController();

  /// store anything you like
  Map<dynamic, dynamic> tempDict = {};
}
