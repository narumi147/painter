import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:painter/app/modules/common/frame_rate_layer.dart';
import 'package:painter/generated/l10n.dart';
import 'package:painter/packages/language.dart';
import 'package:painter/packages/method_channel/app_method_channel.dart';
import 'package:painter/packages/packages.dart';
import 'package:painter/utils/utils.dart';
import 'package:painter/widgets/tile_items.dart';
import '../../../models/db.dart';
import '../root/global_fab.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // avoid PrimaryController error
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.settings_tab_name),
        titleSpacing: NavigationToolbar.kMiddleSpacing,
        toolbarHeight: kToolbarHeight,
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverTileGroup(
            header: S.current.settings_general,
            children: <Widget>[
              ListTile(
                title: Text(S.current.settings_language),
                subtitle:
                    Language.isEN ? const Text('语言') : const Text('Language'),
                trailing: db.onSettings(
                  (context, snapshot) => DropdownButton<Language>(
                    underline:
                        const Divider(thickness: 0, color: Colors.transparent),
                    // need to check again
                    value: Language.getLanguage(S.current.localeName),
                    items: Language.supportLanguages
                        .map((lang) => DropdownMenuItem(
                            value: lang, child: Text(lang.name)))
                        .toList(),
                    onChanged: (lang) {
                      if (lang == null) return;
                      db.settings.setLanguage(lang);
                      db.saveSettings();
                      db.notifyAppUpdate();
                      db.notifySettings();
                    },
                  ),
                ),
              ),
              ListTile(
                title: Text(S.current.dark_mode),
                trailing: db.onSettings(
                  (context, snapshot) => DropdownButton<ThemeMode>(
                    value: db.settings.themeMode,
                    underline: Container(),
                    items: [
                      DropdownMenuItem(
                          value: ThemeMode.system,
                          child: Text(S.current.dark_mode_system)),
                      DropdownMenuItem(
                          value: ThemeMode.light,
                          child: Text(S.current.dark_mode_light)),
                      DropdownMenuItem(
                          value: ThemeMode.dark,
                          child: Text(S.current.dark_mode_dark)),
                    ],
                    onChanged: (v) {
                      if (v != null) {
                        db.settings.themeMode = v;
                        db.saveSettings();
                        db.notifySettings();
                        db.notifyAppUpdate();
                      }
                    },
                  ),
                ),
              ),
              // ListTile(
              //   title: Text(S.current.display_setting),
              //   trailing:
              //       Icon(DirectionalIcons.keyboard_arrow_forward(context)),
              //   onTap: () {
              //     router.push(child: DisplaySettingPage(), detail: true);
              //   },
              // ),
            ],
          ),
          // SliverTileGroup(
          //   header: 'Painter',
          //   children: [
          //     ListTile(
          //       title: const Text('单元格像素大小(不建议随意改动)'),
          //       trailing: Text(db.userData.gridPixel.toString()),
          //     ),
          //     Slider(
          //       value: db.userData.gridPixel.toDouble(),
          //       min: 25,
          //       max: 200,
          //       divisions: (200 - 25) ~/ 25,
          //       onChanged: (v) {
          //         setState(() {
          //           db.userData.gridPixel = v.toInt();
          //         });
          //       },
          //     ),
          //   ],
          // ),
          SliverTileGroup(
            header: 'App',
            children: [
              if (PlatformU.isMacOS || PlatformU.isWindows)
                SwitchListTile.adaptive(
                  value: db.settings.alwaysOnTop,
                  title: Text(S.current.setting_always_on_top),
                  onChanged: (v) async {
                    db.settings.alwaysOnTop = v;
                    db.saveSettings();
                    AppMethodChannel.setAlwaysOnTop(v);
                    setState(() {});
                  },
                ),
              SwitchListTile.adaptive(
                value: db.settings.display.showWindowFab,
                title: Text(S.current.display_show_window_fab),
                onChanged: (v) async {
                  db.settings.display.showWindowFab = v;
                  db.saveSettings();
                  if (v) {
                    WindowManagerFab.createOverlay(context);
                  } else {
                    WindowManagerFab.removeOverlay();
                  }
                  setState(() {});
                },
              ),
              // only show on mobile phone, not desktop and tablet
              // on Android, cannot detect phone or mobile
              if (PlatformU.isMobile || kDebugMode)
                SwitchListTile.adaptive(
                  value: db.settings.autoRotate,
                  title: Text(S.current.setting_auto_rotate),
                  onChanged: (v) {
                    setState(() {
                      db.settings.autoRotate = v;
                      if (v) {
                        SystemChrome.setPreferredOrientations([]);
                      } else {
                        SystemChrome.setPreferredOrientations(
                            [DeviceOrientation.portraitUp]);
                      }
                    });
                    db.notifyAppUpdate();
                  },
                ),
            ],
          ),
          if (db.runtimeData.enableDebugTools)
            SliverTileGroup(
              header: S.current.debug,
              children: <Widget>[
                ListTile(
                  title: const Text('Test Func'),
                  onTap: () {
                    //
                  },
                ),
                SwitchListTile.adaptive(
                  value: FrameRateLayer.showFps,
                  title: Text(S.current.show_frame_rate),
                  onChanged: (v) {
                    setState(() {
                      FrameRateLayer.showFps = v;
                    });
                    if (v) {
                      FrameRateLayer.createOverlay(context);
                    } else {
                      FrameRateLayer.removeOverlay();
                    }
                  },
                ),
                SwitchListTile.adaptive(
                  value: db.settings.showDebugFab,
                  title: Text(S.current.debug_fab),
                  onChanged: (v) {
                    setState(() {
                      db.settings.showDebugFab = v;
                      db.saveSettings();
                    });
                    if (v) {
                      DebugFab.createOverlay(context);
                    } else {
                      DebugFab.removeOverlay();
                    }
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }

  // ignore: unused_element
  Widget _wrapArrowTrailing(Widget trailing) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        trailing,
        Icon(DirectionalIcons.keyboard_arrow_forward(context))
      ],
    );
  }
}
