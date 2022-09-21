import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:auto_size_text/auto_size_text.dart';

import 'package:painter/widgets/tile_items.dart';
import '../../../generated/l10n.dart';
import '../../../models/db.dart';
import '../../../packages/app_info.dart';
import '../../../packages/packages.dart';
import '../../../utils/utils.dart';
import 'elements/grid_gallery.dart';
import 'elements/news_carousel.dart';

class GalleryPage extends StatefulWidget {
  GalleryPage({Key? key}) : super(key: key);

  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    Future.delayed(const Duration(seconds: 2)).then((_) async {
      if (kDebugMode || AppInfo.isDebugDevice) return;
      await Future.delayed(const Duration(seconds: 2));
    }).onError((e, s) async {
      logger.e('init app extras', e, s);
    });
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
        title: const Text(kAppName),
        titleSpacing: NavigationToolbar.kMiddleSpacing,
        toolbarHeight: kToolbarHeight,
      ),
      body: db.settings.carousel.enabled
          ? RefreshIndicator(
              child: body,
              onRefresh: () async {
                await AppNewsCarousel.resolveSliderImageUrls(true);
                if (mounted) setState(() {});
              },
            )
          : body,
    );
  }

  Widget get body {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ListView(
          controller: _scrollController,
          children: <Widget>[
            ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight:
                      PlatformU.isDesktopOrWeb ? 0 : constraints.maxHeight),
              child: Column(
                children: [
                  if (db.settings.carousel.enabled)
                    AppNewsCarousel(maxWidth: constraints.maxWidth),
                  if (db.settings.carousel.enabled)
                    const Divider(height: 0.5, thickness: 0.5),
                  GridGallery(maxWidth: constraints.maxWidth),
                ],
              ),
            ),
            const ListTile(
              subtitle: Center(
                  child: AutoSizeText(
                '~~~~~ · ~~~~~',
                maxLines: 1,
              )),
            ),
            if (kDebugMode) buildTestInfoPad(),
          ],
        );
      },
    );
  }

  /// TEST
  Widget buildTestInfoPad() {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: divideTiles(<Widget>[
          ListTile(
            title: Center(
              child: Text(S.current.test_info_pad,
                  style: const TextStyle(fontSize: 18)),
            ),
          ),
          ListTile(
            title: const Text('UUID'),
            subtitle: Text(AppInfo.uuid),
          ),
          ListTile(
            title: Text(S.current.screen_size),
            trailing: Text(MediaQuery.of(context).size.toString()),
          ),
        ]),
      ),
    );
  }
}
