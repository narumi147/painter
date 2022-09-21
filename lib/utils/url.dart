import 'package:url_launcher/url_launcher.dart' as launcher;

import 'package:painter/packages/platform/platform.dart';

Future<bool> launch(String url) {
  return launcher.launchUrl(
    Uri.parse(url),
    mode: PlatformU.isAndroid
        ? launcher.LaunchMode.externalApplication
        : launcher.LaunchMode.platformDefault,
  );
}

Future<bool> canLaunch(String url) {
  return launcher.canLaunchUrl(Uri.parse(url));
}

Future<bool> openFile(String fp) {
  return launcher.launchUrl(Uri.file(fp));
}
