import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:painter/app/modules/painter/brush_list.dart';
import 'package:painter/utils/basic.dart';
import '../../../routes/routes.dart';
import '../../painter/art_list.dart';
import '../../painter/painter_page.dart';
import '../../painter/plant_list.dart';

class GalleryItem {
  // instant part
  final String name;
  final String Function()? titleBuilder;
  final IconData? icon;
  final Widget? child;

  // final SplitPageBuilder? builder;
  final String? url;
  final Widget? page;
  final bool? isDetail;

  const GalleryItem({
    required this.name,
    required this.titleBuilder,
    this.icon,
    this.child,
    this.url,
    this.page,
    required this.isDetail,
  }) : assert(icon != null || child != null);

  Widget buildIcon(BuildContext context, {double size = 40, Color? color}) {
    if (child != null) return child!;
    bool fa = icon!.fontFamily?.toLowerCase().startsWith('fontawesome') == true;
    final _iconColor = color ??
        (Utility.isDarkMode(context)
            ? Theme.of(context).colorScheme.secondaryContainer
            : Theme.of(context).colorScheme.secondary);
    return fa
        ? Padding(
            padding: EdgeInsets.all(size * 0.05),
            child: FaIcon(icon, size: size * 0.9, color: _iconColor))
        : Icon(icon, size: size, color: _iconColor);
  }

  @override
  String toString() {
    return '$runtimeType($name)';
  }

  static List<GalleryItem> get persistentPages => [
        /*more*/
      ];
  static GalleryItem edit = GalleryItem(
    name: 'edit',
    titleBuilder: () => '',
    icon: FontAwesomeIcons.penToSquare,
    isDetail: false,
  );

  static GalleryItem done = GalleryItem(
    name: 'done',
    titleBuilder: () => '',
    icon: FontAwesomeIcons.circleCheck,
    isDetail: false,
  );

  static List<GalleryItem> get allItems => [
        artworks,
        brushes,
        plants,
        // faq,
        // if (kDebugMode) ...[lostRoom, palette],
        // more,
        // // unpublished
        // _apCal,
        // _damageCalc,
      ];
  static GalleryItem artworks = GalleryItem(
    name: 'artworks',
    titleBuilder: () => 'Artworks',
    icon: Icons.photo,
    url: Routes.artworks,
    page: const ArtListPage(),
    isDetail: null,
  );
  static GalleryItem brushes = GalleryItem(
    name: 'brushes',
    titleBuilder: () => 'Brushes',
    icon: Icons.brush_outlined,
    url: Routes.brushes,
    page: const BrushManagePage(),
    isDetail: null,
  );
  static GalleryItem plants = GalleryItem(
    name: 'plants',
    titleBuilder: () => 'Plants',
    icon: FontAwesomeIcons.tree,
    url: Routes.plants,
    page: const PlantManagePage(),
    isDetail: null,
  );
// static GalleryItem faq = GalleryItem(
//   name: 'faq',
//   titleBuilder: () => 'FAQ',
//   icon: Icons.help_center,
//   page: FAQPage(),
//   isDetail: true,
// );

  /// debug only
// static GalleryItem palette = GalleryItem(
//   name: 'palette',
//   titleBuilder: () => 'Palette',
//   icon: Icons.palette_outlined,
//   page: DarkLightThemePalette(),
//   isDetail: true,
// );

}
