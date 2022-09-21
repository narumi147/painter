// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../models/userdata/local_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocalSettings _$LocalSettingsFromJson(Map json) => $checkedCreate(
      'LocalSettings',
      json,
      ($checkedConvert) {
        final val = LocalSettings(
          beta: $checkedConvert('beta', (v) => v as bool? ?? false),
          showDebugFab:
              $checkedConvert('showDebugFab', (v) => v as bool? ?? false),
          alwaysOnTop:
              $checkedConvert('alwaysOnTop', (v) => v as bool? ?? false),
          windowPosition: $checkedConvert('windowPosition',
              (v) => (v as List<dynamic>?)?.map((e) => e as int).toList()),
          launchTimes: $checkedConvert('launchTimes', (v) => v as int? ?? 0),
          lastBackup: $checkedConvert('lastBackup', (v) => v as int? ?? 0),
          themeMode: $checkedConvert(
              'themeMode',
              (v) =>
                  $enumDecodeNullable(_$ThemeModeEnumMap, v) ??
                  ThemeMode.system),
          language: $checkedConvert('language', (v) => v as String?),
          autoRotate: $checkedConvert('autoRotate', (v) => v as bool? ?? false),
          display: $checkedConvert(
              'display',
              (v) => v == null
                  ? null
                  : DisplaySettings.fromJson(
                      Map<String, dynamic>.from(v as Map))),
          carousel: $checkedConvert(
              'carousel',
              (v) => v == null
                  ? null
                  : CarouselSetting.fromJson(
                      Map<String, dynamic>.from(v as Map))),
        );
        return val;
      },
    );

Map<String, dynamic> _$LocalSettingsToJson(LocalSettings instance) =>
    <String, dynamic>{
      'beta': instance.beta,
      'showDebugFab': instance.showDebugFab,
      'alwaysOnTop': instance.alwaysOnTop,
      'windowPosition': instance.windowPosition,
      'launchTimes': instance.launchTimes,
      'lastBackup': instance.lastBackup,
      'themeMode': _$ThemeModeEnumMap[instance.themeMode]!,
      'autoRotate': instance.autoRotate,
      'display': instance.display.toJson(),
      'carousel': instance.carousel.toJson(),
      'language': instance.language,
    };

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};

DisplaySettings _$DisplaySettingsFromJson(Map json) => $checkedCreate(
      'DisplaySettings',
      json,
      ($checkedConvert) {
        final val = DisplaySettings(
          showWindowFab:
              $checkedConvert('showWindowFab', (v) => v as bool? ?? true),
        );
        return val;
      },
    );

Map<String, dynamic> _$DisplaySettingsToJson(DisplaySettings instance) =>
    <String, dynamic>{
      'showWindowFab': instance.showWindowFab,
    };

CarouselSetting _$CarouselSettingFromJson(Map json) => $checkedCreate(
      'CarouselSetting',
      json,
      ($checkedConvert) {
        final val = CarouselSetting(
          updateTime: $checkedConvert('updateTime', (v) => v as int?),
          items: $checkedConvert(
              'items',
              (v) => (v as List<dynamic>?)
                  ?.map((e) => CarouselItem.fromJson(
                      Map<String, dynamic>.from(e as Map)))
                  .toList()),
          enabled: $checkedConvert('enabled', (v) => v as bool? ?? true),
        );
        return val;
      },
    );

Map<String, dynamic> _$CarouselSettingToJson(CarouselSetting instance) =>
    <String, dynamic>{
      'updateTime': instance.updateTime,
      'items': instance.items.map((e) => e.toJson()).toList(),
      'enabled': instance.enabled,
    };

CarouselItem _$CarouselItemFromJson(Map json) => $checkedCreate(
      'CarouselItem',
      json,
      ($checkedConvert) {
        final val = CarouselItem(
          type: $checkedConvert('type', (v) => v as int? ?? 0),
          priority: $checkedConvert('priority', (v) => v as int? ?? 100),
          startTime: $checkedConvert('startTime', (v) => v as String? ?? ""),
          endTime: $checkedConvert('endTime', (v) => v as String? ?? ""),
          title: $checkedConvert('title', (v) => v as String?),
          content: $checkedConvert('content', (v) => v as String?),
          image: $checkedConvert('image', (v) => v as String?),
          link: $checkedConvert('link', (v) => v as String?),
        );
        return val;
      },
    );

Map<String, dynamic> _$CarouselItemToJson(CarouselItem instance) =>
    <String, dynamic>{
      'type': instance.type,
      'priority': instance.priority,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'title': instance.title,
      'content': instance.content,
      'image': instance.image,
      'link': instance.link,
    };
