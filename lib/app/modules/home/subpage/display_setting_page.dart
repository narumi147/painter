import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:painter/generated/l10n.dart';
import 'package:painter/packages/method_channel/app_method_channel.dart';
import 'package:painter/packages/platform/platform.dart';
import 'package:painter/widgets/tile_items.dart';
import '../../../../models/db.dart';
import '../../root/global_fab.dart';

class DisplaySettingPage extends StatefulWidget {
  DisplaySettingPage({Key? key}) : super(key: key);

  @override
  _DisplaySettingPageState createState() => _DisplaySettingPageState();
}

class _DisplaySettingPageState extends State<DisplaySettingPage> {
  CarouselSetting get carousel => db.settings.carousel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.display_setting),
      ),
      body: ListView(
        children: [],
      ),
    );
  }
}
