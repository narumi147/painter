import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';

import '../packages/app_info.dart';
import '../packages/method_channel/app_method_channel.dart';
import '../packages/packages.dart';
import '../utils/http_override.dart';
import '../utils/json_helper.dart';
import '../utils/utils.dart';
import '../widgets/widgets.dart';
import 'paths.dart';
import 'runtime_data.dart';
import 'userdata/local_settings.dart';
import 'userdata/userdata.dart';

export 'userdata/userdata.dart';
export 'userdata/local_settings.dart';

void _emptyCallback() {}

class _Database {
  // members
  final paths = PathManager();
  LocalSettings settings = LocalSettings();
  UserData _userData = UserData();

  UserData get userData => _userData;

  set userData(UserData userData) {
    _userData = userData;
    _userData.validate();
  }

  RuntimeData runtimeData = RuntimeData();
  CacheManager cacheManager = CacheManager(Config('painter'));

  VoidCallback notifyAppUpdate = _emptyCallback;

  // singleton
  static final _instance = _Database._internal();

  factory _Database() => _instance;

  _Database._internal() {
    _userNotifier = StreamController.broadcast();
    _settingNotifier = StreamController.broadcast();
    // _gameNotifier = ValueNotifier(gameData);
  }

  void dispose() {
    _userNotifier.close();
    _settingNotifier.close();
  }

  // listenable
  late final StreamController<UserData> _userNotifier;
  late final StreamController<LocalSettings> _settingNotifier;

  // late final ValueNotifier<GameData> _gameNotifier;

  void notifyUserdata() {
    _userNotifier.sink.add(userData);
    EasyDebounce.debounce('save_userdata', const Duration(seconds: 10), () {
      saveUserData();
      saveSettings();
    });
  }

  void notifySettings() {
    _settingNotifier.sink.add(settings);
  }

  Widget onUserData(AsyncWidgetBuilder<UserData> builder) {
    return StreamBuilder(
      initialData: userData,
      stream: _userNotifier.stream,
      builder: builder,
    );
  }

  Widget onSettings(AsyncWidgetBuilder<LocalSettings> builder) {
    return StreamBuilder(
      initialData: settings,
      stream: _settingNotifier.stream,
      builder: builder,
    );
  }

  // methods
  Future<void> initiate() async {
    await paths.initRootPath();
    HttpOverrides.global = CustomHttpOverrides();
    await AppInfo.resolve(paths.appPath);
    AppMethodChannel.configMethodChannel();
    _startSavingLoop();
  }

  /// return the [UserData] instance, don't assign to [userData]
  Future<UserData?> loadUserData([String? fp]) async {
    return _loadWithBak<UserData?>(
      fp: fp ?? paths.userDataPath,
      fromJson: (data) => UserData.fromJson(data),
      onError: () => null,
    );
  }

  Future<LocalSettings> loadSettings([String? fp]) async {
    return settings = await _loadWithBak<LocalSettings>(
      fp: fp ?? paths.settingsPath,
      fromJson: (data) => LocalSettings.fromJson(data),
      onError: () => LocalSettings(),
    );
  }

  static const _backSuffix = '.bak';

  Future<T> _loadWithBak<T>({
    required String fp,
    required T Function(dynamic) fromJson,
    T Function()? onError,
  }) async {
    return JsonHelper.loadModel<T>(
      fp: fp,
      fromJson: fromJson,
      onError: () => JsonHelper.loadModel<T>(
        fp: fp + _backSuffix,
        fromJson: fromJson,
        onError: onError,
      ),
    );
  }

  Future<void> saveAll() async {
    await saveUserData();
    await saveSettings();
  }

  Future<void> saveUserData() => _saveWithBak(paths.userDataPath, userData);

  Future<void> saveSettings() => _saveWithBak(paths.settingsPath, settings);

  Future<void> _saveWithBak(String fp, Object obj) async {
    try {
      String content = jsonEncode(obj);
      await File(fp).writeAsString(content, flush: true);
      await File(fp + _backSuffix).writeAsString(content, flush: true);
    } catch (e, s) {
      if (kAppKey.currentContext != null) {
        EasyLoading.showError(e.toString());
      }
      logger.e('saving file failed', e, s);
    }
  }

  void _startSavingLoop() {
    String? _lastUserHash;
    String? _lastSettingHash;
    String _getHash(Object obj) {
      return md5.convert(utf8.encode(jsonEncode(obj))).toString();
    }

    Timer.periodic(const Duration(seconds: 10), (timer) {
      final _userHash = _getHash(userData);
      final _settingHash = _getHash(settings);
      if (_lastUserHash != null && _lastSettingHash != null) {
        if (_userHash != _lastUserHash) {
          saveUserData();
        }
        if (_settingHash != _lastSettingHash) {
          saveSettings();
        }
      }
      _lastUserHash = _userHash;
      _lastSettingHash = _settingHash;
    });
  }

  Future<List<String>> backupUserdata(
      {bool disk = false, bool memory = true}) async {
    String timeStamp = DateFormat('yyyyMMddTHHmmss').format(DateTime.now());

    List<String> _saved = [];
    final _lastSavedFile = File(paths.userDataPath);
    List<List<int>> objs = [
      if (disk && _lastSavedFile.existsSync())
        await _lastSavedFile.readAsBytes(),
      if (memory) utf8.encode(jsonEncode(userData)),
    ];
    for (var obj in objs) {
      String filename = '$timeStamp${obj is File ? 'd' : 'm'}.json';
      await File(joinPaths(paths.backupDir, filename)).writeAsBytes(obj);
      _saved.add(filename);
    }
    if (_saved.isNotEmpty) {
      db.settings.lastBackup = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    }
    return _saved;
  }

  final AssetImage errorImage = const AssetImage('res/img/gudako.png');

  /// Only call this when [iconKey] SHOULD be saved to icon dir.
  /// If just want to use network image, use [CachedImage] instead.
  ///
  /// size of [Image] widget is zero before file is loaded to memory.
  /// wrap Container to ensure the placeholder size
  Widget getIconImage(
    String? iconUrl, {
    double? width,
    double? height,
    double? aspectRatio,
    BoxFit? fit,
    bool? preferPng,
    bool withBorder = true,
    bool? clip,
    EdgeInsetsGeometry? padding,
    WidgetBuilder? placeholder,
    LoadingErrorWidgetBuilder? errorWidget,
    VoidCallback? onTap,
  }) {
    Widget image;
    if (iconUrl == null || iconUrl.isEmpty) {
      image = Image(
        image: errorImage,
        width: width,
        height: height,
        fit: fit,
      );
    } else {
      image = CachedImage(
        imageUrl: iconUrl,
        // cacheDir: paths.gameIconDir,
        width: width,
        height: height,
        aspectRatio: aspectRatio,
        cachedOption: CachedImageOption(
          fit: fit,
          errorWidget: errorWidget ??
              (context, url, e) => SizedBox(
                    width: width,
                    height: height,
                    child: placeholder?.call(context),
                  ),
          cacheManager: cacheManager,
        ),
        placeholder: (context, __) => SizedBox(
          width: width,
          height: height,
          child: placeholder?.call(context),
        ),
      );
    }
    if (padding != null) {
      image = Padding(padding: padding, child: image);
    }
    if (onTap != null) {
      image = GestureDetector(onTap: onTap, child: image);
    }
    return image;
  }
}

final db = _Database();
