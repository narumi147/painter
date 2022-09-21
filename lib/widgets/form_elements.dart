import 'package:flutter/material.dart';

class CheckboxWithLabel extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final Widget label;
  final EdgeInsetsGeometry? padding;

  const CheckboxWithLabel({
    Key? key,
    required this.value,
    required this.label,
    required this.onChanged,
    this.padding = const EdgeInsets.only(right: 8),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget child = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(value: value, onChanged: onChanged),
        label,
      ],
    );
    if (padding != null) {
      child = Padding(padding: padding!, child: child);
    }
    return InkWell(
      onTap: onChanged == null ? null : () => onChanged!(!value),
      child: child,
    );
  }
}

class RadioWithLabel<T> extends StatelessWidget {
  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final Widget label;
  final EdgeInsetsGeometry? padding;

  const RadioWithLabel({
    Key? key,
    required this.value,
    required this.groupValue,
    required this.label,
    required this.onChanged,
    this.padding = const EdgeInsets.only(right: 8),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget child = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
        ),
        label,
      ],
    );
    if (padding != null) {
      child = Padding(padding: padding!, child: child);
    }
    return InkWell(
      onTap: onChanged == null ? null : () => onChanged!(value),
      child: child,
    );
  }
}
