import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart';

import '../../../generated/l10n.dart';
import '../../../widgets/widgets.dart';

class SharedBuilder {
  SharedBuilder._();

  static Color? appBarForeground(BuildContext context) {
    final theme = Theme.of(context);
    return theme.appBarTheme.foregroundColor ??
        (theme.colorScheme.brightness == Brightness.dark
            ? theme.colorScheme.onSurface
            : theme.colorScheme.onPrimary);
  }

  static Widget grid<T>({
    required BuildContext context,
    required Iterable<T> items,
    required Widget Function(BuildContext context, T item) builder,
    EdgeInsetsGeometry? padding,
  }) {
    Widget child = Wrap(
      spacing: 1,
      runSpacing: 1,
      children: [
        for (final item in items) builder(context, item),
      ],
    );
    if (padding != null) {
      child = Padding(padding: padding, child: child);
    }
    return child;
  }

  static TextSpan textButtonSpan({
    required BuildContext context,
    required String text,
    List<InlineSpan>? children,
    TextStyle? style,
    VoidCallback? onTap,
    GestureRecognizer? recognizer,
  }) {
    return TextSpan(
      text: text,
      children: children,
      style: style ??
          TextStyle(color: Theme.of(context).colorScheme.secondaryContainer),
      recognizer: recognizer ??
          (onTap == null ? null : (TapGestureRecognizer()..onTap = onTap)),
    );
  }

  static Future<FilePickerResult?> pickImageOrFiles({
    required BuildContext context,
    bool allowMultiple = true,
    bool withData = false,
  }) async {
    FileType? fileType;
    await showDialog(
      context: context,
      useRootNavigator: false,
      builder: (context) => SimpleDialog(
        title: Text(S.current.import_image),
        contentPadding: const EdgeInsets.fromLTRB(8.0, 12.0, 0.0, 16.0),
        children: [
          ListTile(
            horizontalTitleGap: 0,
            leading: const Icon(Icons.photo_library),
            title: const Text('Photos'),
            onTap: () {
              fileType = FileType.image;
              Navigator.pop(context);
            },
          ),
          ListTile(
            horizontalTitleGap: 0,
            leading: const Icon(Icons.file_copy),
            title: const Text('Files'),
            onTap: () {
              fileType = FileType.any;
              Navigator.pop(context);
            },
          ),
          const SFooter('Help'),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.clear),
          ),
        ],
      ),
    );
    if (fileType == null) return null;
    return FilePicker.platform.pickFiles(
        type: fileType!, allowMultiple: allowMultiple, withData: withData);
  }
}
