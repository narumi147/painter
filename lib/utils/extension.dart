import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart' hide TextDirection;

import 'constants.dart';

extension NumX on num {
  String format({
    bool compact = true,
    bool percent = false,
    double base = 0.01, // 0.01: 0.87 -> 87%, 10: 200->20%
    bool omit = true,
    int precision = 3,
    String? groupSeparator,
    num? minVal = 10000,
    int? maxDigits,
  }) {
    num number = this;
    if (percent) {
      compact = false;
      number /= base;
    }
    if (compact && (minVal == null || abs() >= minVal)) {
      return NumberFormat.compact(locale: 'en').format(number);
    }
    final pattern = [
      if (groupSeparator != null && groupSeparator.isNotEmpty)
        '###$groupSeparator',
      '###',
      if (precision > 0) '.${(omit ? '#' : '0') * precision}',
      // if (percent) '%'
    ].join();
    String s = NumberFormat(pattern, 'en').format(number);
    s = s.replaceFirstMapped(RegExp(r'^(\d+)\.(\d+)$'), (match) {
      String s1 = match.group(1)!, s2 = match.group(2)!;
      if (maxDigits != null) {
        if (s1.length < maxDigits) {
          s2 = s2.substring(0, min(s2.length, maxDigits - s1.length));
        } else {
          return s1;
        }
      } else if (percent && s1.length >= 3) {
        return s1;
      }
      return '$s1.$s2';
    });
    if (percent) s += '%';
    return s;
  }
}

extension IntX on int {
  DateTime sec2date() => DateTime.fromMillisecondsSinceEpoch(this * 1000);

  /// if [upperLimit]<[lowerLimit], then [lowerLimit] is used
  int clamp2(int? lowerLimit, [int? upperLimit]) {
    int result = this;
    if (upperLimit != null && upperLimit < result) result = upperLimit;
    if (lowerLimit != null && lowerLimit > result) result = lowerLimit;
    return result;
  }

  /// timestamp in seconds
  String toDateTimeString() =>
      DateTime.fromMillisecondsSinceEpoch(this * 1000).toStringShort();
}

extension ListX<T> on List<T> {
  // add another method to support -1 index
  T? getOrNull(int index) {
    if (index >= length || index < 0) {
      return null;
    }
    return elementAt(index % length);
  }

  void fixLength(int length, T Function() k) {
    assert(length >= 0);
    if (this.length == length) return;
    if (this.length > length) {
      this.length = length;
    } else {
      addAll(List.generate(length - this.length, (index) => k()));
    }
  }

  void sort2<V extends Comparable>(V Function(T e) compare,
      {bool reversed = false}) {
    if (reversed) {
      sort((a, b) => compare(b).compareTo(compare(a)));
    } else {
      sort((a, b) => compare(a).compareTo(compare(b)));
    }
  }

  List<T> sortReturn([int Function(T a, T b)? compare]) {
    sort(compare);
    return this;
  }
}

extension IterableX<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E element) test) {
    try {
      return firstWhere(test);
    } on StateError {
      return null;
    }
  }
}

extension SetX<E> on Set<E> {
  void toggle(E value) {
    if (contains(value)) {
      remove(value);
    } else {
      add(value);
    }
  }

  bool equalTo(Set<E> other) {
    return length == other.length && length == {...this, ...other}.length;
  }
}

extension NumMapDefault<K> on Map<K, int> {
  int get(K key) {
    return this[key] ?? 0;
  }

  int addNum(K key, int value) {
    return this[key] = get(key) + value;
  }

  void addDict(Map<K, int> other) {
    for (final entry in other.entries) {
      addNum(entry.key, entry.value);
    }
  }

  Map<K, int> multiple(int multiplier, {bool inplace = false}) {
    final d = inplace ? this : Map.of(this);
    for (final k in d.keys) {
      d[k] = d[k]! * multiplier;
    }
    return d;
  }
}

extension StringX on String {
  DateTime? toDateTime() {
    return DateTimeX.tryParse(this);
  }

  String toTitle() {
    return replaceAllMapped(RegExp(r'\S+'), (match) {
      String s = match.group(0)!;
      return s.substring(0, 1).toUpperCase() + s.substring(1);
    });
  }

  /// for half-width ascii: 1 char=1 byte, for full-width cn/jp 1 char=3 bytes mostly.
  /// assume there is no half-width cn/jp char.
  int get charWidth {
    return (length + utf8.encode(this).length) ~/ 2;
  }

  String trimChar(String chars) {
    return trimCharLeft(chars).trimCharRight(chars);
  }

  String trimCharLeft(String chars) {
    String s = this;
    while (s.isNotEmpty && chars.contains(s.substring(0, 1))) {
      s = s.substring(1);
    }
    return s;
  }

  String trimCharRight(String chars) {
    String s = this;
    while (s.isNotEmpty && chars.contains(s[s.length - 1])) {
      s = s.substring(0, s.length - 1);
    }
    return s;
  }

  String setMaxLines([int n = 1]) {
    final lines = split('\n');
    if (lines.length <= n) return this;
    return [lines.sublist(0, n).join('\n'), ...lines.skip(n)].join(' ');
  }

  Text toText({
    Key? key,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextAlign? textAlign,
    TextDirection? textDirection,
    Locale? locale,
    bool? softWrap,
    TextOverflow? overflow,
    double? textScaleFactor,
    int? maxLines,
    String? semanticsLabel,
    TextWidthBasis? textWidthBasis,
    TextHeightBehavior? textHeightBehavior,
  }) {
    return Text(
      this,
      key: key,
      style: style,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
    );
  }
}

extension DateTimeX on DateTime {
  static DateTime? tryParse(String? formattedString) {
    if (formattedString == null) return null;
    var date = DateTime.tryParse(formattedString);
    if (date != null) return date;
    // replace 2020-2-2 0:0 to 2020-02-02 00:00
    formattedString = formattedString.replaceFirstMapped(
        RegExp(r'^([+-]?\d{4})-?(\d{1,2})-?(\d{1,2})'), (match) {
      String year = match.group(1)!;
      String month = match.group(2)!.padLeft(2, '0');
      String day = match.group(3)!.padLeft(2, '0');
      return '$year-$month-$day';
    });
    formattedString = formattedString
        .replaceFirstMapped(RegExp(r'(\d{1,2}):(\d{1,2})$'), (match) {
      String hour = match.group(1)!.padLeft(2, '0');
      String minute = match.group(2)!.padLeft(2, '0');
      return '$hour:$minute';
    });
    return DateTime.tryParse(formattedString);
  }

  /// [this] is reference time, check [dateTime] outdated or not
  /// If [duration] is provided, compare [dateTime]-[duration] ~ this
  bool checkOutdated(DateTime? dateTime, [Duration? duration]) {
    if (dateTime == null) return false;
    if (duration != null) dateTime = dateTime.add(duration);
    return isAfter(dateTime);
  }

  String toStringShort({bool omitSec = false}) {
    return toString().replaceFirstMapped(RegExp(r'(:\d+)(\.\d+)(Z?)'), (match) {
      return omitSec || match.group(1) == ":00"
          ? match.group(3)!
          : match.group(1)! + match.group(3)!;
    });
  }

  String toDateString([String sep = '-']) {
    return [
      year,
      month.toString().padLeft(2, '0'),
      day.toString().padLeft(2, '0')
    ].join(sep);
  }

  static int compare(DateTime? a, DateTime? b) {
    if (a != null && b != null) {
      return a.compareTo(b);
    } else if (a != null) {
      return 1;
    } else if (b != null) {
      return -1;
    } else {
      return 0;
    }
  }

  int get timestamp => millisecondsSinceEpoch ~/ 1000;
}

/// This widget should not have any dependency of outer [context]
extension DialogShowMethod on material.Widget {
  /// Don't use this when dialog children depends on [context]
  Future<T?> showDialog<T>(material.BuildContext? context,
      {bool barrierDismissible = true, bool useRootNavigator = false}) {
    context ??= kAppKey.currentContext;
    if (context == null) return Future.value();
    return material.showDialog<T>(
      context: context,
      builder: (context) => this,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
    );
  }
}

extension ThemeDataX on ThemeData {
  bool get isDarkMode {
    return brightness == material.Brightness.dark;
  }
}

extension ResponseX<T> on Response<T> {
  Map<String, dynamic> json() {
    if (data is Map) {
      return Map.from(data as Map);
    } else if (data is String) {
      return jsonDecode(data as String);
    } else {
      return {};
    }
  }
}

extension DioErrorX on DioError {
  String _limit(String s) {
    if (s.length > 1000) return s.substring(0, 1000);
    return s;
  }

  String _tryDecodeData() {
    if (response?.data is List<int>) {
      try {
        return utf8.decode(response!.data);
      } catch (e) {
        return response!.data.toString();
      }
    } else {
      return (response?.data).toString();
    }
  }

  String messageWithData() {
    String msg = '[NetworkError] DioError [$type]: $message';
    if (response?.data != null) {
      msg += '\n${_limit(_tryDecodeData())}';
    }
    return msg;
  }
}
