library userdata;

import 'package:flutter/material.dart';

import 'package:painter/utils/utils.dart';
import '../../packages/app_info.dart';
import '../db.dart';
import '_helper.dart';

part 'artwork.dart';
part 'brush.dart';

part '../../generated/models/userdata/userdata.g.dart';

/// user data will be shared across devices and cloud
@JsonSerializable()
class UserData {
  static const int modelVersion = 4;

  final int version;
  final String appVer;
  @JsonKey(ignore: true)
  int previousVersion;

  List<Artwork> artworks;
  Map<int, Brush> brushes;
  Map<int, Plant> plants;
  // int gridPixel;

  UserData({
    int? version,
    String? appVer,
    this.previousVersion = 0,
    int curUserKey = 0,
    List<Artwork>? artworks,
    Map<int, Brush>? brushes,
    Map<int, Plant>? plants,
    // this.gridPixel = 100,
  })  : version = UserData.modelVersion,
        appVer = AppInfo.versionString,
        artworks = artworks ?? [],
        brushes = brushes ?? {},
        plants = plants ?? {} {
    validate();
  }

  factory UserData.fromJson(Map<String, dynamic> json) {
    final previousVersion = json['version'];
    UserData userData = _$UserDataFromJson(json);
    if (previousVersion is int || previousVersion == null) {
      userData.previousVersion = previousVersion ?? 0;
    }
    return userData;
  }

  Map<String, dynamic> toJson() => _$UserDataToJson(this);

  void validate() {
    brushes = Map.fromIterable(brushes.values, key: (e) => (e as Brush).id);
    brushes.removeWhere((key, value) => key <= 0);
    plants = Map.fromIterable(plants.values, key: (e) => (e as Plant).plantId);
    plants.removeWhere((key, value) => key <= 0);
  }

  void sort() {
    //
  }
}
