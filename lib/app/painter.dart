import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_window_close/flutter_window_close.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';

import 'package:painter/generated/intl/messages_all.dart';
import 'package:painter/utils/utils.dart';
import 'package:painter/widgets/widgets.dart';
import '../generated/l10n.dart';
import '../models/db.dart';
import '../packages/language.dart';
import '../packages/logger.dart';
import '../packages/method_channel/app_method_channel.dart';
import '../packages/platform/platform.dart';
import '../utils/catcher/catcher_util.dart';
import '../widgets/after_layout.dart';
import 'app.dart';
import 'routes/parser.dart';

class PainterApp extends StatefulWidget {
  PainterApp({Key? key}) : super(key: key);

  @override
  _PainterAppState createState() => _PainterAppState();
}

class _PainterAppState extends State<PainterApp> with AfterLayoutMixin {
  final routeInformationParser = AppRouteInformationParser();
  final backButtonDispatcher = RootBackButtonDispatcher();

  @override
  void reassemble() {
    super.reassemble();
    reloadMessages();
  }

  @override
  Widget build(BuildContext context) {
    final lightTheme = _getThemeData(dark: false);
    final darkTheme = _getThemeData(dark: true);
    Widget child = Screenshot(
      controller: db.runtimeData.screenshotController,
      child: MaterialApp.router(
        title: kAppName,
        onGenerateTitle: (_) => kAppName,
        routeInformationParser: routeInformationParser,
        routerDelegate: rootRouter,
        backButtonDispatcher: backButtonDispatcher,
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: db.settings.themeMode,
        scrollBehavior: DraggableScrollBehavior(),
        locale: Language.getLanguage(db.settings.language)?.locale ??
            Language.zh.locale,
        localizationsDelegates: const [
          S.delegate,
          ...GlobalMaterialLocalizations.delegates
        ],
        supportedLocales: Language.supportLanguages.map((e) => e.locale),
        builder: (context, widget) {
          ErrorWidget.builder = CatcherUtil.errorWidgetBuilder;
          return FlutterEasyLoading(child: widget);
        },
      ),
    );
    if (PlatformU.isAndroid) {
      child = AnnotatedRegion<SystemUiOverlayStyle>(
        value: db.settings.isResolvedDarkMode
            ? SystemUiOverlayStyle.dark.copyWith(
                // statusBarColor: Colors.transparent,
                systemNavigationBarColor: darkTheme.scaffoldBackgroundColor,
                // statusBarIconBrightness: Brightness.light,
                systemNavigationBarIconBrightness: Brightness.light,
              )
            : SystemUiOverlayStyle.light.copyWith(
                // statusBarColor: Colors.transparent,
                systemNavigationBarColor: lightTheme.scaffoldBackgroundColor,
                // statusBarIconBrightness: Brightness.dark,
                systemNavigationBarIconBrightness: Brightness.dark,
              ),
        child: child,
      );
    }
    return child;
  }

  ThemeData _getThemeData({required bool dark}) {
    var themeData = dark
        ? ThemeData(brightness: Brightness.dark)
        : ThemeData(brightness: Brightness.light);
    return themeData.copyWith(
      appBarTheme: themeData.appBarTheme.copyWith(
        titleSpacing: 0,
        toolbarHeight: 48, // kToolbarHeight=56,
        titleTextStyle: kIsWeb
            ? null
            : (themeData.appBarTheme.titleTextStyle ?? const TextStyle())
                .copyWith(fontSize: 20),
      ),
    );
  }

  void onAppUpdate() {
    for (final _router in rootRouter.appState.children) {
      _router.forceRebuild();
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    debugPrint('initiate $runtimeType');
    super.initState();
    db.notifyAppUpdate = onAppUpdate;
    db.settings.launchTimes += 1;
    if (db.settings.language != null) {
      Intl.defaultLocale = Language.current.code;
    }

    SystemChannels.lifecycle.setMessageHandler((msg) async {
      debugPrint('SystemChannels> $msg');
      if (msg == AppLifecycleState.resumed.toString()) {
        // Actions when app is resumed
      } else if (msg == AppLifecycleState.inactive.toString()) {
        db.saveAll();
        debugPrint('save userdata before being inactive');
      }
      return null;
    });

    setOnWindowClose();
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    if (PlatformU.isWindows || PlatformU.isMacOS) {
      AppMethodChannel.setAlwaysOnTop();
    }
    if (PlatformU.isWindows) {
      AppMethodChannel.setWindowPos();
    }
    if (DateTime.now().timestamp - db.settings.lastBackup > 24 * 3600) {
      db.backupUserdata();
    }
    if (PlatformU.isMobile) {
      if (!db.settings.autoRotate) {
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      }
    }
  }

  void setOnWindowClose() {
    if (!PlatformU.isDesktop) return;
    FlutterWindowClose.setWindowShouldCloseHandler(() async {
      logger.i('closing desktop app...');
      await db.saveAll();
      return _alertUpload();
    });
  }

  Future<bool> _alertUpload() async {
    final ctx = kAppKey.currentContext;
    if (ctx == null) return true;
    final close = await showDialog(
      context: ctx,
      builder: (context) => AlertDialog(
        content: Text(S.current.confirm),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: Text(S.current.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: Text(S.current.general_close),
          ),
        ],
      ),
    );
    return close == true;
  }
}

class DraggableScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => <PointerDeviceKind>{
        PointerDeviceKind.touch,
        // PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.invertedStylus,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.unknown,
      };
}
