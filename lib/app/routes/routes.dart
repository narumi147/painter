import 'package:flutter/material.dart';

import 'package:painter/app/modules/painter/art_list.dart';
import 'package:painter/app/modules/painter/brush_list.dart';
import 'package:painter/app/modules/painter/plant_list.dart';
import '../../packages/split_route/split_route.dart';
import '../../utils/extension.dart';
import '../modules/common/not_found.dart';
import '../modules/common/splash.dart';
import '../modules/home/home.dart';

class Routes {
  static const String home = '/';
  static const String bootstrap = '/welcome';
  static const String artworks = '/artworks';
  static const String brushes = '/brushes';
  static const String plants = '/plants';

  static const String notFound = '/404';

  static const List<String> masterRoutes = [
    home,
  ];
}

class RouteConfiguration {
  final String? url;
  final Uri? uri;
  final bool? detail;
  final dynamic arguments;
  final Widget? child;

  RouteConfiguration({this.url, this.child, this.detail, this.arguments})
      : uri = url == null ? null : Uri.tryParse(url);

  RouteConfiguration.fromUri(
      {this.uri, this.child, this.detail, this.arguments})
      : url = uri.toString();

  RouteConfiguration.slash({required String nextPageUrl})
      : url = null,
        uri = null,
        detail = null,
        arguments = null,
        child = SplashPage(nextPageUrl: nextPageUrl);

  String? get path => uri?.path ?? url;

  String? get first {
    if (uri == null) return url;
    if (uri!.path.isEmpty || uri!.path == Routes.home) return Routes.home;
    return '/${uri!.pathSegments.first}';
  }

  String? get second => uri?.pathSegments.getOrNull(1);

  Map<String, String> get query => uri?.queryParameters ?? {};

  RouteConfiguration.notFound([this.arguments])
      : url = Routes.notFound,
        uri = Uri.parse(Routes.notFound),
        child = null,
        detail = null;

  RouteConfiguration.home()
      : url = Routes.home,
        uri = Uri.parse(Routes.home),
        child = null,
        arguments = null,
        detail = false;

  SplitPage createPage() {
    return SplitPage(
      child: resolvedChild ?? NotFoundPage(configuration: this),
      detail: detail,
      name: url,
      arguments: this,
      key: UniqueKey(),
    );
  }

  @override
  String toString() {
    return '$runtimeType(url=$url, detail=$detail)';
  }

  RouteConfiguration copyWith({
    String? url,
    Widget? child,
    bool? detail,
    dynamic arguments,
  }) {
    return RouteConfiguration(
      url: url ?? this.url,
      child: child ?? this.child,
      detail: detail ?? this.detail,
      arguments: arguments ?? this.arguments,
    );
  }

  Widget? get resolvedChild {
    if (child != null) return child!;
    switch (first) {
      case Routes.home:
        return HomePage();
      case Routes.notFound:
        return NotFoundPage(configuration: this);
      case Routes.artworks:
        return const ArtListPage();
      case Routes.brushes:
        return const BrushManagePage();
      case Routes.plants:
        return const PlantManagePage();
    }
    return null;
  }
}

class SplitPage extends MaterialPage {
  final bool? detail;

  const SplitPage({
    required Widget child,
    this.detail,
    bool maintainState = true,
    bool fullscreenDialog = false,
    LocalKey? key,
    String? name,
    Object? arguments,
    String? restorationId,
  }) : super(
          key: key,
          child: child,
          maintainState: maintainState,
          fullscreenDialog: fullscreenDialog,
          name: name,
          arguments: arguments,
          restorationId: restorationId,
        );

  @override
  Route createRoute(BuildContext context) {
    return SplitRoute(
      settings: this,
      builder: (context, _) => child,
      detail: detail,
      // masterRatio: _kSplitMasterRatio,
      opaque: detail != true,
      maintainState: maintainState,
      // this.title,
      fullscreenDialog: fullscreenDialog,
    );
  }

  @override
  String toString() {
    return '$runtimeType("$name", $key, $arguments, ${child.runtimeType})';
  }
}
