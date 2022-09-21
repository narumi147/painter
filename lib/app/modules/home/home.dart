import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';
import '../../../models/db.dart';
import '../../../packages/split_route/split_route.dart';
import '../../../widgets/after_layout.dart';
import '../../app.dart';
import '../root/global_fab.dart';
import 'gallery_page.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AfterLayoutMixin {
  int _curIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _curIndex,
        children: [GalleryPage(), SettingsPage()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _curIndex,
        items: [
          BottomNavigationBarItem(
              icon: const SafeArea(child: Icon(Icons.layers)),
              label: S.current.gallery_tab_name),
          BottomNavigationBarItem(
              icon: const SafeArea(child: Icon(Icons.settings)),
              label: S.current.settings_tab_name),
        ],
        onTap: (index) {
          // if (_curIndex != index) db2.saveData();
          setState(() => _curIndex = index);
        },
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    if (mounted) {
      if (db.settings.display.showWindowFab &&
          !(rootRouter.appState.showSidebar && SplitRoute.isSplit(null))) {
        WindowManagerFab.createOverlay(context);
      }
      if (db.settings.showDebugFab) {
        DebugFab.createOverlay(context);
      }
    }
  }
}
