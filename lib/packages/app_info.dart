import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as pathlib;
import 'package:uuid/uuid.dart';

import 'package:painter/generated/git_info.dart';
import 'package:painter/packages/packages.dart';
import 'package:painter/utils/extension.dart';
import '../models/version.dart';
import '../utils/constants.dart';

class AppInfo {
  AppInfo._();

  static PackageInfo? _packageInfo;
  static String? _uuid;
  // ignore: unused_field
  static bool _isIPad = false;
  static int? _androidSdk;

  static final Map<String, dynamic> deviceParams = {};
  static final Map<String, dynamic> appParams = {};

  static Future<void> _loadDeviceInfo() async {
    if (PlatformU.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      deviceParams.addAll(androidInfo.toMap()..remove('systemFeatures'));
      _androidSdk = androidInfo.version.sdkInt;
    } else if (PlatformU.isIOS) {
      final iosInfo = await DeviceInfoPlugin().iosInfo;
      deviceParams.addAll(iosInfo.toMap());
      _isIPad = iosInfo.model?.toLowerCase().contains('ipad') ?? false;
    } else if (PlatformU.isMacOS) {
      final macOsInfo = await DeviceInfoPlugin().macOsInfo;
      deviceParams.addAll(macOsInfo.toMap());
    } else if (PlatformU.isMacOS) {
      final linuxInfo = await DeviceInfoPlugin().linuxInfo;
      deviceParams.addAll(linuxInfo.toMap());
    } else if (PlatformU.isWindows) {
      final windowsInfo = await DeviceInfoPlugin().windowsInfo;
      deviceParams['operatingSystem'] = PlatformU.operatingSystem;
      deviceParams['operatingSystemVersion'] = PlatformU.operatingSystemVersion;
      deviceParams.addAll(windowsInfo.toMap());
    } else if (PlatformU.isWeb) {
      final webInfo = await DeviceInfoPlugin().webBrowserInfo;
      deviceParams.addAll(webInfo.toMap());
    } else {
      deviceParams['operatingSystem'] = PlatformU.operatingSystem;
      deviceParams['operatingSystemVersion'] = PlatformU.operatingSystemVersion;
    }
  }

  /// PackageInfo: appName+version+buildNumber
  ///  - Android: support
  ///  - for iOS/macOS:
  ///   - if CF** keys not defined in info.plist, return null
  ///   - if buildNumber not defined, return version instead
  ///  - Windows: Not Support
  static Future<void> _loadApplicationInfo() async {
    ///Only android, iOS and macOS are implemented
    _packageInfo =
        await PackageInfo.fromPlatform().catchError((e) => PackageInfo(
              appName: kAppName,
              packageName: kPackageName,
              version: '0.0.0',
              buildNumber: '0',
              buildSignature: '',
            ));
    _packageInfo = PackageInfo(
      appName: _packageInfo!.appName.toTitle(),
      packageName: _packageInfo!.packageName,
      version: _packageInfo!.version,
      buildNumber: _packageInfo!.buildNumber,
    );
    appParams["version"] = _packageInfo?.version;
    appParams["appName"] = _packageInfo?.appName;
    appParams["buildNumber"] = _packageInfo?.buildNumber;
    appParams["packageName"] = _packageInfo?.packageName;
    logger.i('Resolved app version: ${_packageInfo?.packageName}'
        ' ${_packageInfo?.version}+${_packageInfo?.buildNumber}');
  }

  static Future<void> _loadUniqueId(String appPath) async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    String? originId;
    if (PlatformU.isWeb) {
      // // use generated uuid
      // originId = null;
      // _uuid = '00000000-0000-0000-0000-000000000000';
      // return;
    } else if (PlatformU.isAndroid) {
      originId = (await deviceInfoPlugin.androidInfo).androidId;
    } else if (PlatformU.isIOS) {
      originId = (await deviceInfoPlugin.iosInfo).identifierForVendor;
    } else if (PlatformU.isWindows) {
      // reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "ProductId"
      // Output:
      // HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion
      //     ProductId    REG_SZ    XXXXX-XXXXX-XXXXX-XXXXX
      final result = await Process.run(
        'reg',
        [
          'query',
          // ProductId
          // r'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion',
          // MachineGuid
          r'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Cryptography',
          '/v',
          // 'ProductId'
          'MachineGuid'
        ],
        runInShell: true,
      );
      String resultString = result.stdout.toString().trim();
      // print('Windows MachineGuid query:\n$resultString');
      if (resultString.contains('MachineGuid') &&
          resultString.contains('REG_SZ')) {
        originId = resultString.trim().split(RegExp(r'\s+')).last;
      }
    } else if (PlatformU.isMacOS) {
      // https://stackoverflow.com/a/944103
      // However, IOPlatformUUID will change every boot, use IOPlatformSerialNumber instead
      // ioreg -rd1 -c IOPlatformExpertDevice | awk '/IOPlatformSerialNumber/ { split($0, line, "\""); printf("%s\n", line[4]); }'
      // the filter is shell feature so it's not used
      // Output containing:
      //  "IOPlatformUUID" = "8-4-4-4-12 standard uuid"
      // need to parse output
      final result = await Process.run(
        'ioreg',
        [
          '-rd1',
          '-c',
          'IOPlatformExpertDevice',
        ],
        runInShell: true,
      );
      for (String line in result.stdout.toString().split('\n')) {
        if (line.contains('IOPlatformSerialNumber')) {
          final _snMatches =
              RegExp(r'[0-9a-zA-Z\-]+').allMatches(line).toList();
          if (_snMatches.isNotEmpty) {
            final _sn = _snMatches.last.group(0);
            if (_sn != null) {
              originId = _sn;
              break;
            }
          }
        }
      }
    } else if (PlatformU.isLinux) {
      //cat /etc/machine-id
      final result = await Process.run(
        'cat',
        ['/etc/machine-id'],
        runInShell: true,
      );
      String resultString = result.stdout.toString().trim();
      print('Linux machine id query:\n$resultString');
      originId = resultString;
    } else {
      throw UnimplementedError(PlatformU.operatingSystem);
    }
    if (originId?.isNotEmpty != true) {
      var uuidFile = File(pathlib.join(appPath, '.uuid'));
      if (uuidFile.existsSync()) {
        originId = await uuidFile.readAsString();
      }
      if (originId?.isNotEmpty != true) {
        originId = const Uuid().v1();
        await uuidFile.writeAsString(originId);
      }
    }
    _uuid = const Uuid().v5(Uuid.NAMESPACE_URL, originId!).toUpperCase();

    logger.i('Unique ID: $_uuid');
  }

  static Future<void> resolve(String appPath) async {
    await _loadUniqueId(appPath);
    await _loadDeviceInfo();
    await _loadApplicationInfo();
  }

  static PackageInfo? get info => _packageInfo;

  static String get appName {
    if (_packageInfo?.appName.isNotEmpty == true) {
      return _packageInfo!.appName;
    } else {
      return kAppName;
    }
  }

  static const String commmitHash = kCommitHash;

  static const int commmitTimestamp = kCommitTimestamp;

  static String get commitDate => DateFormat.yMd()
      .format(DateTime.fromMillisecondsSinceEpoch(commmitTimestamp * 1000));

  static AppVersion get version => AppVersion.tryParse(fullVersion)!;

  /// e.g. "1.2.3"
  static String get versionString => _packageInfo?.version ?? '';

  static int get buildNumber =>
      int.tryParse(_packageInfo?.buildNumber ?? '0') ?? 0;

  static int get originBuild {
    if (PlatformU.isAndroid) {
      final _build = buildNumber;
      if (_build > 1000 && [10, 20, 40].contains(_build ~/ 100)) {
        return int.parse(_build.toString().substring(2));
      }
    }
    return buildNumber;
  }

  static String get packageName => info?.packageName ?? kPackageName;

  static int? get androidSdk => _androidSdk;

  /// e.g. "1.2.3+4"
  static String get fullVersion {
    String s = '';
    s += versionString;
    if (buildNumber > 0) s += '+$buildNumber';
    return s;
  }

  /// e.g. "1.2.3 (4)"
  static String get fullVersion2 {
    StringBuffer buffer = StringBuffer(versionString);
    if (buildNumber > 0) {
      buffer.write(' ($buildNumber)');
    }
    return buffer.toString();
  }

  static String get uuid => _uuid!;

  static bool get isDebugDevice {
    const excludeIds = [
      'FB26CA34-0B8F-588C-8542-4A748BB67740', // android
      'C150DF56-B65C-5167-852B-102D487D7159', // ios
      'BC87303D-6010-5DCE-90FB-68E8758EC260', // ios release
      '1D6D5558-9929-5AB0-9CE7-BC2E188948CD', // macos
      '6986A299-F7CB-5BBF-9680-14ED34013C07', // windows
    ];
    return excludeIds.contains(AppInfo.uuid);
  }
}

enum MacAppType {
  unknown,
  store,
  notarized,
  debug,
  notMacApp,
}
