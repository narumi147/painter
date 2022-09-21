import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:painter/generated/l10n.dart';
import 'package:painter/models/db.dart';
import 'package:painter/packages/app_info.dart';
import 'package:painter/utils/utils.dart';
import 'package:painter/widgets/markdown_page.dart';

class AboutPage extends StatefulWidget {
  AboutPage({Key? key}) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  bool showDebugInfo = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    return Scaffold(
      appBar: AppBar(
        title: Text(MaterialLocalizations.of(context)
            .aboutListTileTitle(AppInfo.appName)),
      ),
      body: ListView(
        children: <Widget>[
          GestureDetector(
            onDoubleTap: () {
              setState(() {
                showDebugInfo = true;
              });
            },
            onLongPress: () async {
              setState(() {
                showDebugInfo = true;
                db.runtimeData.enableDebugTools = true;
              });
              await Clipboard.setData(ClipboardData(text: AppInfo.uuid));
              EasyLoading.showToast('UUID ${S.current.copied}');
            },
            child: _AboutProgram(
              name: AppInfo.appName,
              version: AppInfo.fullVersion2,
              icon: SizedBox(
                height: 120,
                child: Image.asset('res/img/icon.png', height: 120),
              ),
              legalese: 'Copyright © 2022 ???.\nAll rights reserved.',
              debugInfo: showDebugInfo
                  ? 'UUID\n${AppInfo.uuid}\n'
                      'Size: ${size.width.toInt()}×${size.height.toInt()} [×$devicePixelRatio]'
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _AboutProgram extends StatelessWidget {
  const _AboutProgram({
    Key? key,
    required this.name,
    required this.version,
    this.icon,
    this.legalese,
    this.debugInfo,
  }) : super(key: key);

  final String name;
  final String version;
  final Widget? icon;
  final String? legalese;
  final String? debugInfo;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24.0),
        child: Column(
          children: <Widget>[
            if (icon != null)
              IconTheme(data: Theme.of(context).iconTheme, child: icon!),
            Text(
              name,
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              version,
              style: Theme.of(context).textTheme.bodyText2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 3),
            Text.rich(
              TextSpan(
                text: "${AppInfo.commmitHash} - ${AppInfo.commitDate}",
                // recognizer: TapGestureRecognizer()
                //   ..onTap = () => launch(AppInfo.commitUrl),
                style: Theme.of(context).textTheme.caption,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              legalese ?? '',
              style: Theme.of(context).textTheme.caption,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            if (debugInfo != null) ...[
              const SizedBox(height: 12),
              Text(
                debugInfo!,
                style: Theme.of(context).textTheme.caption,
                textAlign: TextAlign.center,
              )
            ],
          ],
        ),
      ),
    );
  }
}

// ignore: unused_element
class _GithubMarkdownPage extends StatelessWidget {
  final String title;
  final String? link;
  final String? assetKey;
  final bool disableMd;

  const _GithubMarkdownPage({
    Key? key,
    required this.title,
    this.link,
    this.assetKey,
    this.disableMd = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          if (link != null)
            IconButton(
              onPressed: () {
                launch(link!);
              },
              icon: const FaIcon(FontAwesomeIcons.github),
              tooltip: 'view on Github',
            )
        ],
      ),
      body: MyMarkdownWidget(assetKey: assetKey, disableMd: disableMd),
    );
  }
}
