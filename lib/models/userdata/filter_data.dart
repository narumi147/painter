import 'package:flutter/material.dart';

import 'package:painter/utils/utils.dart';

typedef _FilterCompare<T> = bool Function(T value, T option);

class FilterGroupData<T> {
  bool _matchAll;

  bool get matchAll => _matchAll;

  set matchAll(bool matchAll) {
    _matchAll = matchAll;
    onChanged?.call();
  }

  bool _invert;

  bool get invert => _invert;

  set invert(bool invert) {
    _invert = invert;
    onChanged?.call();
  }

  Set<T> _options;

  Set<T> get options => _options;

  set options(Set<T> options) {
    _options = Set.from(options);
    onChanged?.call();
  }

  VoidCallback? onChanged;

  FilterGroupData({
    bool matchAll = false,
    bool invert = false,
    Set<T>? options,
    this.onChanged,
  })  : _matchAll = matchAll,
        _invert = invert,
        _options = options ?? {};

  T? get radioValue => throw UnimplementedError();

  bool contain(T v) =>
      options.isEmpty || (invert ? !options.contains(v) : options.contains(v));

  bool isEmpty(Iterable<T> values) {
    return options.isEmpty || values.every((e) => !options.contains(e));
  }

  bool isAll(Iterable<T> values) {
    return values.every((e) => options.contains(e));
  }

  void toggle(T value) {
    options.toggle(value);
    onChanged?.call();
  }

  void reset() {
    matchAll = invert = false;
    options.clear();
    onChanged?.call();
  }

  bool _match(
    T value,
    T option,
    _FilterCompare<T>? compare,
    Map<T, _FilterCompare<T>>? compares,
  ) {
    compare ??= compares?[option] ?? (T v, T o) => v == o;
    return compare.call(value, option);
  }

  bool matchOne(
    T value, {
    _FilterCompare<T>? compare,
    Map<T, _FilterCompare<T>>? compares,
  }) {
    if (options.isEmpty) return true;
    assert(!matchAll, 'When `matchAll` enabled, use `matchList` instead');
    bool result =
        options.any((option) => _match(value, option, compare, compares));
    return invert ? !result : result;
  }

  bool matchAny(
    Iterable<T> values, {
    _FilterCompare<T>? compare,
    Map<T, _FilterCompare<T>>? compares,
  }) {
    if (options.isEmpty) return true;
    bool result;
    if (matchAll) {
      result = options.every(
          (option) => values.any((v) => _match(v, option, compare, compares)));
    } else {
      result = options.any(
          (option) => values.any((v) => _match(v, option, compare, compares)));
    }
    return invert ? !result : result;
  }
}

class FilterRadioData<T> extends FilterGroupData<T> {
  T? _selected;
  final bool _nonnull;

  @override
  T? get radioValue {
    assert(!(_selected == null && _nonnull && null is! T));
    return _selected;
  }

  @override
  bool get matchAll => false;

  @override
  bool get invert => false;

  @override
  Set<T> get options => {if (_selected != null) _selected!};

  FilterRadioData([this._selected]) : _nonnull = false;
  FilterRadioData.nonnull(T selected)
      : _selected = selected,
        _nonnull = true;

  @override
  void toggle(T value) {
    if (value == _selected && !_nonnull) {
      _selected = null;
    } else {
      _selected = value;
    }
  }

  @override
  void reset() {
    _selected = null;
  }
}
