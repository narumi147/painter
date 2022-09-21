import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';
import '../../../models/db.dart';
import '../../../packages/language.dart';
import '../../../widgets/movable_fab.dart';
import '../../app.dart';

class WindowManagerFab extends StatefulWidget {
  const WindowManagerFab({Key? key}) : super(key: key);

  @override
  _WindowManagerFabState createState() => _WindowManagerFabState();

  static GlobalKey<_WindowManagerFabState> globalKey = GlobalKey();
  static OverlayEntry? _instance;

  static void createOverlay(BuildContext context) {
    context = router.navigatorKey.currentContext ?? context;
    _instance?.remove();
    _instance =
        OverlayEntry(builder: (context) => WindowManagerFab(key: globalKey));
    Overlay.of(context, rootOverlay: true)?.insert(_instance!);
  }

  static void removeOverlay() {
    _instance?.remove();
    _instance = null;
  }

  static void markNeedRebuild() {
    _instance?.markNeedsBuild();
  }
}

class _WindowManagerFabState extends State<WindowManagerFab> {
  @override
  Widget build(BuildContext context) {
    return MovableFab(
      icon: Icon(
        rootRouter.appState.showWindowManager ? Icons.reply : Icons.grid_view,
        size: 20,
      ),
      onPressed: () {
        setState(() {
          rootRouter.appState.showWindowManager =
              !rootRouter.appState.showWindowManager;
        });
      },
    );
  }
}

class DebugFab extends StatefulWidget {
  const DebugFab({Key? key}) : super(key: key);

  @override
  _DebugFabState createState() => _DebugFabState();

  static GlobalKey<_DebugFabState> globalKey = GlobalKey();
  static OverlayEntry? _instance;

  static void createOverlay(BuildContext context) {
    _instance?.remove();
    _instance = OverlayEntry(builder: (context) => DebugFab(key: globalKey));
    Overlay.of(context, rootOverlay: true)?.insert(_instance!);
  }

  static void removeOverlay() {
    _instance?.remove();
    _instance = null;
  }
}

class _DebugFabState extends State<DebugFab> {
  bool isMenuShowing = false;
  double opacity = 0.75;

  @override
  Widget build(BuildContext context) {
    return MovableFab(
      icon: const Icon(Icons.menu_open, size: 20),
      initialY: 0.9,
      opacity: opacity,
      enabled: !isMenuShowing,
      backgroundColor: isMenuShowing ? Theme.of(context).disabledColor : null,
      onPressed: () {
        setState(() {
          isMenuShowing = true;
        });
        final context = rootRouter.navigatorKey.currentContext;
        if (context == null) return;
        showDialog(
          context: context,
          builder: (context) => _DebugMenuDialog(state: this),
        ).then((value) {
          isMenuShowing = false;
          if (mounted) setState(() {});
        });
      },
    );
  }

  void hide([int seconds = 60]) {
    opacity = 0;
    if (mounted) {
      setState(() {});
    }
    Future.delayed(Duration(seconds: seconds), () {
      opacity = 0.75;
      if (mounted) {
        setState(() {});
      }
    });
  }
}

class _DebugMenuDialog extends StatefulWidget {
  final _DebugFabState? state;

  const _DebugMenuDialog({Key? key, this.state}) : super(key: key);

  @override
  __DebugMenuDialogState createState() => __DebugMenuDialogState();
}

class __DebugMenuDialogState extends State<_DebugMenuDialog> {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(S.current.debug_menu),
      children: [
        ListTile(
          leading: const Icon(Icons.dark_mode),
          title: Text(S.current.toggle_dark_mode),
          horizontalTitleGap: 0,
          onTap: () {
            Navigator.pop(context);
            db.settings.themeMode = db.settings.isResolvedDarkMode
                ? ThemeMode.light
                : ThemeMode.dark;
            db.notifyAppUpdate();
          },
        ),
        ListTile(
          leading: const Icon(Icons.language),
          title: Text(S.current.settings_language),
          horizontalTitleGap: 0,
          trailing: DropdownButton<Language>(
            underline: const Divider(thickness: 0, color: Colors.transparent),
            value: Language.getLanguage(db.settings.language),
            items: Language.supportLanguages
                .map((lang) =>
                    DropdownMenuItem(value: lang, child: Text(lang.name)))
                .toList(),
            onChanged: (lang) {
              if (lang == null) return;
              db.settings.setLanguage(lang);
              db.notifyAppUpdate();
            },
          ),
        ),
        ListTile(
          horizontalTitleGap: 0,
          leading: const Icon(Icons.timer),
          title: const Text('Hide 60s'),
          onTap: () {
            widget.state?.hide(60);
            Navigator.pop(context);
          },
        ),
        Center(
          child: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        )
      ],
    );
  }
}
