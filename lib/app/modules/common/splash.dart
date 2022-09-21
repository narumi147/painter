import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'blank_page.dart';

class SplashPage extends StatefulWidget {
  final String? nextPageUrl;

  const SplashPage({Key? key, this.nextPageUrl}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return const BlankPage(showIndicator: !kIsWeb);
  }
}

class StarterGuidancePage extends StatefulWidget {
  const StarterGuidancePage({Key? key}) : super(key: key);

  @override
  _StarterGuidancePageState createState() => _StarterGuidancePageState();
}

class _StarterGuidancePageState extends State<StarterGuidancePage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
