import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../packages/logger.dart';
import '../packages/platform/platform.dart';
import '../utils/constants.dart';

class PathManager {
  /// [_appPath] root path where app data stored, can be configured by user
  String? _appPath;

  // ignore: unused_element
  Future<String?> _debugPath(
      String key, Future<dynamic> Function() getter) async {
    dynamic _path;
    try {
      _path = await getter();
    } catch (e) {
      _path = '$e';
    }
    String result = '';
    if (_path is String) {
      result = _path;
    } else if (_path is Directory) {
      result = _path.path;
    } else if (_path is List<Directory> || _path is List<Directory?>) {
      result = List<Directory?>.of(_path).map((e) => e?.path).join('\n\t\t');
    } else {
      result = _path.toString();
    }
    print('$key\n\t\t$result');
    return result;
  }

  Future<void> initRootPath() async {
    // await _debugPath(
    //     '1-ApplicationDocuments', () => getApplicationDocumentsDirectory());
    // await _debugPath(
    //     '2-ApplicationSupport', () => getApplicationSupportDirectory());
    // await _debugPath('3-Temporary', () => getTemporaryDirectory());
    // await _debugPath('4-Library', () => getLibraryDirectory());
    // await _debugPath('5-Downloads', () => getDownloadsDirectory());
    // await _debugPath('6-ExternalCache', () => getExternalCacheDirectories());
    // await _debugPath('7-ExternalStorage', () => getExternalStorageDirectory());
    // await _debugPath(
    //     '8-ExternalStorages', () => getExternalStorageDirectories());

    if (_appPath != null) return;
    if (PlatformU.isWeb) {
      _appPath = 'web';
      initiateLoggerPath('');
      return;
    }

    if (PlatformU.isAndroid) {
      // enhancement: startup check, if SD card not exists and set to use external, raise a warning
      List<String> externalPaths = (await getExternalStorageDirectories(
              type: StorageDirectory.documents))!
          .map((e) => dirname(e.path))
          .whereType<String>()
          .toList();
      _appPath = externalPaths[0];
      // _tempPath = (await getTemporaryDirectory())?.path;
    } else if (PlatformU.isIOS) {
      _appPath = (await getApplicationDocumentsDirectory()).path;
      // _tempPath = (await getTemporaryDirectory())?.path;
    } else if (PlatformU.isMacOS) {
      _appPath = (await getApplicationDocumentsDirectory()).path;
    } else if (PlatformU.isWindows) {
      // _tempPath = (await getTemporaryDirectory())?.path;
      // set link:
      // in old version windows, it may need admin permission, so it may fail
      String exeFolder = dirname(PlatformU.resolvedExecutable);
      _appPath = join(exeFolder, 'userdata');
      if (kDebugMode) {
        _appPath = (await getApplicationSupportDirectory()).path;
      }
    } else if (PlatformU.isLinux) {
      String exeFolder = dirname(PlatformU.resolvedExecutable);
      _appPath = join(exeFolder, 'userdata');
      if (kDebugMode) {
        _appPath = (await getApplicationSupportDirectory()).path;
      }
    } else {
      throw UnimplementedError(
          'Not supported for ${PlatformU.operatingSystem}');
    }
    if (_appPath == null) {
      throw const OSError('Cannot resolve document folder');
    }

    logger.i('appPath: $_appPath');
    // ensure directory exist
    for (String dir in [
      appPath,
      userDir,
      brushFolder,
      tempDir,
      downloadDir,
      backupDir,
      logDir,
      hiveDir,
      assetsDir,
    ]) {
      Directory(dir).createSync(recursive: true);
    }
    // logger
    initiateLoggerPath(appLog);
    // crash files
    final File crashFile = File(crashLog);
    if (!crashFile.existsSync()) {
      crashFile.writeAsString('crash.log\n', flush: true);
    }
    rollLogFiles(crashFile.path, 3, 1 * 1024 * 1024);
  }

  static String hiveAsciiKey(String s) {
    return Uri.tryParse(s)?.toString() ?? base64Encode(utf8.encode(s));
  }

  /// root dir
  String get appPath => _appPath!;

  String get userDir => join(appPath, 'user');

  String get brushFolder => join(appPath, 'brushes');

  String get tempDir => join(appPath, 'temp');
  String get downloadDir => join(appPath, 'downloads');

  String get backupDir => join(appPath, 'backup');

  String get logDir => join(appPath, 'logs');

  String get hiveDir => join(appPath, 'hive');

  /// game/
  String get assetsDir => join(appPath, 'assets');

  /// user/
  String get settingsPath => join(userDir, 'settings.json');

  String get userDataPath => join(userDir, kUserDataFilename);

  /// logs/
  String get appLog => join(logDir, 'log.log');

  String get crashLog => join(logDir, 'crash.log');
}
