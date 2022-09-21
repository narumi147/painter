part of userdata;

@JsonSerializable()
class Brush {
  // constants
  static const kEraser = -1;
  static const kMask = -2;
  static const kMaskEraser = -3;
  static const kMove = -99;

  //
  final BrushType type;
  int id;
  int plantId;
  int zindex;
  double scale;
  int weight;
  String _name;
  String get name => _name.isEmpty ? 'Brush $id' : _name;
  set name(String v) => _name = v;

  Plant? get plant => db.userData.plants[plantId];

  Brush({
    required this.id,
    required this.plantId,
    this.zindex = 1,
    this.scale = 1.0,
    this.weight = 10,
    String name = '',
  })  : _name = name,
        type = BrushType.normal;

  String get filename => '$id.png';
  String get filepath => joinPaths(db.paths.brushFolder, filename);
  factory Brush.fromJson(Map<String, dynamic> json) => _$BrushFromJson(json);
  Map<String, dynamic> toJson() => _$BrushToJson(this);
}

@JsonSerializable()
class Plant {
  int plantId;
  String _name;
  String get name => _name.isEmpty ? 'Plant $plantId' : _name;
  set name(String v) => _name = v;
  Plant({
    required this.plantId,
    required String name,
  }) : _name = name;
  factory Plant.fromJson(Map<String, dynamic> json) => _$PlantFromJson(json);
  Map<String, dynamic> toJson() => _$PlantToJson(this);
}

enum BrushType {
  normal,
  eraser,
  mask,
  maskEraser,
}
