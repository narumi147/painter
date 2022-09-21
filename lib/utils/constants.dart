import 'dart:convert';

import 'package:flutter/material.dart';

const String kAppName = 'Painter';
const String kPackageName = 'cc.narumi.painter';
const String kUserDataFilename = 'userdata.json';

/// The global key passed to [MaterialApp], so you can access context anywhere
final kAppKey = GlobalKey<NavigatorState>();
const kDefaultDivider = Divider(height: 1, thickness: 0.5);
const kIndentDivider =
    Divider(height: 1, thickness: 0.5, indent: 16, endIndent: 16);
const kMonoFont = 'RobotoMono';
const kMonoStyle = TextStyle(fontFamily: kMonoFont);

const kStarChar = '☆';
// 0x01ffffff
final kOnePixel = base64.decode(
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAAAXNSR0IArs4c6QAAAA1JREFUGFdj+P//PyMACP0C//k2WXcAAAAASUVORK5CYII=');
