import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import '../models/db.dart' show db;
import '../utils/extension.dart';

class Language {
  final String code;
  final String name;
  final String nameEn;
  final Locale locale;

  const Language(this.code, this.name, this.nameEn, this.locale);

  static const zh = Language('zh', '简体中文', 'Simplified Chinese',
      Locale.fromSubtags(languageCode: 'zh'));
  static const en = Language('en', 'English', 'English', Locale('en', ''));

  static List<Language> get supportLanguages => const [zh, en];

  /// warn that [Intl.canonicalizedLocale] cannot treat script code
  static Language? getLanguage(String? code) {
    code = Intl.canonicalizedLocale(code ??= systemLocale.toString());
    return supportLanguages
        .firstWhereOrNull((lang) => code?.startsWith(lang.code) ?? false);
  }

  static Locale get systemLocale =>
      WidgetsBinding.instance.platformDispatcher.locale;

  /// used for 5 region game data
  static bool get isZH => current == zh;

  static bool get isEN => current == en;

  static Language get current => getLanguage(db.settings.language) ?? en;

  @override
  String toString() {
    return "$runtimeType('$code', '$name')";
  }
}
