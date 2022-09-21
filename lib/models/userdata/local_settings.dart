import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:intl/intl.dart';

import '../../generated/l10n.dart';
import '../../packages/language.dart';
import '_helper.dart';

export 'filter_data.dart';

part '../../generated/models/userdata/local_settings.g.dart';

@JsonSerializable()
class LocalSettings {
  bool beta;
  bool showDebugFab;
  bool alwaysOnTop;
  List<int>? windowPosition;
  int launchTimes;
  int lastBackup;
  ThemeMode themeMode;
  String? _language;
  bool autoRotate;
  DisplaySettings display;
  CarouselSetting carousel;

  LocalSettings({
    this.beta = false,
    this.showDebugFab = false,
    this.alwaysOnTop = false,
    this.windowPosition,
    this.launchTimes = 0,
    this.lastBackup = 0,
    this.themeMode = ThemeMode.system,
    String? language,
    this.autoRotate = false,
    Map<int, String>? priorityTags,
    Map<String, bool>? galleries,
    DisplaySettings? display,
    CarouselSetting? carousel,
  })  : _language = language,
        display = display ?? DisplaySettings(),
        carousel = carousel ?? CarouselSetting();

  String? get language => _language;

  Future<S> setLanguage(Language lang) {
    _language = Intl.defaultLocale = lang.code;
    return S.load(lang.locale, override: true);
  }

  factory LocalSettings.fromJson(Map<String, dynamic> json) =>
      _$LocalSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$LocalSettingsToJson(this);

  bool get isResolvedDarkMode {
    if (themeMode == ThemeMode.system) {
      return SchedulerBinding.instance.window.platformBrightness ==
          Brightness.dark;
    }
    return themeMode == ThemeMode.dark;
  }
}

@JsonSerializable()
class DisplaySettings {
  bool showWindowFab;

  DisplaySettings({
    this.showWindowFab = true,
  }) {
    validateSvtTabs();
  }
  void validateSvtTabs() {
    //
  }

  factory DisplaySettings.fromJson(Map<String, dynamic> data) =>
      _$DisplaySettingsFromJson(data);

  Map<String, dynamic> toJson() => _$DisplaySettingsToJson(this);
}

@JsonSerializable()
class CarouselSetting {
  int? updateTime;
  List<CarouselItem> items;
  bool enabled;
  @JsonKey(ignore: true)
  bool needUpdate = false;

  CarouselSetting({
    this.updateTime,
    List<CarouselItem>? items,
    this.enabled = true,
  }) : items = items ?? [];

  bool get shouldUpdate {
    if (updateTime == null) return true;
    if (items.isEmpty && enabled) {
      return true;
    }
    DateTime lastTime =
            DateTime.fromMillisecondsSinceEpoch(updateTime! * 1000).toUtc(),
        now = DateTime.now().toUtc();
    int hours = now.difference(lastTime).inHours;
    if (hours > 24 || hours < 0) return true;
    // update at 17:00(+08), 18:00(+09) => 9:00(+00)
    int hour = (9 - lastTime.hour) % 24 + lastTime.hour;
    final time1 =
        DateTime.utc(lastTime.year, lastTime.month, lastTime.day, hour, 10);
    if (now.isAfter(time1)) return true;
    return false;
  }

  factory CarouselSetting.fromJson(Map<String, dynamic> data) =>
      _$CarouselSettingFromJson(data);

  Map<String, dynamic> toJson() => _$CarouselSettingToJson(this);
}

@JsonSerializable()
class CarouselItem {
  // 0-default, 1-sticky
  int type;
  int priority; // if <0, only used for debug
  DateTime startTime;
  DateTime endTime;
  String? title;
  String? content;
  String? image;
  String? link;
  @JsonKey(ignore: true)
  BoxFit? fit;

  CarouselItem({
    this.type = 0,
    this.priority = 100,
    String startTime = "",
    String endTime = "",
    this.title,
    this.content,
    this.image,
    this.link,
    this.fit,
  })  : startTime = DateTime.tryParse(startTime) ?? DateTime(2000),
        endTime = DateTime.tryParse(endTime) ?? DateTime(2099);

  factory CarouselItem.fromJson(Map<String, dynamic> data) =>
      _$CarouselItemFromJson(data);

  Map<String, dynamic> toJson() => _$CarouselItemToJson(this);
}
