import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:worker_manager/worker_manager.dart';

import '../packages/logger.dart';

class JsonHelper {
  JsonHelper._();

  static final Executor _executor = Executor();

  static Future<T> loadModel<T>({
    required String fp,
    required T Function(dynamic data) fromJson,
    FutureOr<T> Function()? onError,
  }) async {
    final file = File(fp);
    if (!file.existsSync()) {
      if (onError == null) {
        throw OSError('File not found: $fp');
      }
      return onError();
    }
    try {
      final content = await file.readAsString();
      final decoded = content.length < 10e5
          ? jsonDecode(content)
          : await decodeString(content);
      return fromJson(decoded);
    } catch (e, s) {
      logger.e('failed to load $T json model', e, s);
      if (onError == null) {
        rethrow;
      }
      return onError();
    }
  }

  static Future<dynamic> decodeString<T>(String data) async {
    if (kIsWeb || data.length < 10 * 1024) return jsonDecode(data);
    return _executor.execute(fun1: _decodeString, arg1: data);
  }

  static Future<dynamic> decodeBytes<T>(List<int> bytes) async {
    if (kIsWeb || bytes.length < 10 * 1024) return _decodeBytes(bytes, null);
    return _executor.execute(fun1: _decodeBytes, arg1: bytes);
  }

  static Future<dynamic> decodeFile<T>(String fp) async {
    if (kIsWeb) return jsonDecode(await File(fp).readAsString());
    return _executor.execute(fun1: _decodeFile, arg1: fp);
  }

  static dynamic _decodeBytes<T>(List<int> bytes, TypeSendPort? port) {
    return jsonDecode(utf8.decode(bytes));
  }

  static dynamic _decodeString<T>(String text, TypeSendPort? port) {
    return jsonDecode(text);
  }

  static Future<dynamic> _decodeFile<T>(String fp, TypeSendPort? port) async {
    return jsonDecode(utf8.decode(await File(fp).readAsBytes()));
  }
}
