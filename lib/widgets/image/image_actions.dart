import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:path/path.dart';
import 'package:url_launcher/url_launcher.dart' show launchUrl;

import 'package:painter/utils/utils.dart';
import '../../packages/packages.dart';
import '../custom_dialogs.dart';

class ImageActions {
  static Future showSaveShare({
    required BuildContext context,
    Uint8List? data,
    String? srcFp,
    bool gallery = true,
    String? destFp,
    bool share = true,
    String? shareText,
    List<Widget> extraHeaders = const [],
    Future<void> Function()? onClearCache,
  }) {
    assert(srcFp != null || data != null);
    if (srcFp == null && data == null) return Future.value();
    return showMaterialModalBottomSheet(
      context: context,
      duration: const Duration(milliseconds: 250),
      builder: (context) {
        List<Widget> children = [...extraHeaders];
        if (!PlatformU.isWeb && destFp != null) {
          children.add(ListTile(
            leading: const Icon(Icons.save),
            title: const Text('Save'),
            onTap: () {
              Navigator.pop(context);
              final bytes = data ?? File(srcFp!).readAsBytesSync();
              File(destFp).parent.createSync(recursive: true);
              File(destFp).writeAsBytesSync(bytes);
              SimpleCancelOkDialog(
                hideCancel: true,
                title: const Text('Saved'),
                content: Text(destFp),
                actions: [
                  if (PlatformU.isDesktop)
                    TextButton(
                      onPressed: () {
                        openFile(dirname(destFp));
                      },
                      child: const Text('Open'),
                    ),
                ],
              ).showDialog(context);
            },
          ));
        }
        if (kIsWeb && data != null) {
          children.add(ListTile(
            leading: const Icon(Icons.save),
            title: const Text('Save'),
            onTap: () {
              Navigator.pop(context);
              launchUrl(Uri.dataFromBytes(data));
            },
          ));
        }

        if (onClearCache != null) {
          children.add(ListTile(
            leading: const Icon(Icons.cached),
            title: const Text('Clear Cache'),
            onTap: () {
              Navigator.pop(context);
              onClearCache();
            },
          ));
        }
        children.addAll([
          Material(
            color: Colors.grey.withOpacity(0.1),
            child: const SizedBox(height: 6),
          ),
          ListTile(
            leading: const Icon(Icons.close),
            title: const Text('Cancel'),
            onTap: () {
              Navigator.pop(context);
            },
          )
        ]);
        return ListView.separated(
          shrinkWrap: true,
          controller: ModalScrollController.of(context),
          itemBuilder: (context, index) => children[index],
          separatorBuilder: (_, __) =>
              const Divider(height: 0.5, thickness: 0.5),
          itemCount: children.length,
        );
      },
    );
  }
}
