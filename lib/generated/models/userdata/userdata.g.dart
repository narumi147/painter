// GENERATED CODE - DO NOT MODIFY BY HAND

part of userdata;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserData _$UserDataFromJson(Map json) => $checkedCreate(
      'UserData',
      json,
      ($checkedConvert) {
        final val = UserData(
          version: $checkedConvert('version', (v) => v as int?),
          appVer: $checkedConvert('appVer', (v) => v as String?),
          artworks: $checkedConvert(
              'artworks',
              (v) => (v as List<dynamic>?)
                  ?.map((e) =>
                      Artwork.fromJson(Map<String, dynamic>.from(e as Map)))
                  .toList()),
          brushes: $checkedConvert(
              'brushes',
              (v) => (v as Map?)?.map(
                    (k, e) => MapEntry(int.parse(k as String),
                        Brush.fromJson(Map<String, dynamic>.from(e as Map))),
                  )),
          plants: $checkedConvert(
              'plants',
              (v) => (v as Map?)?.map(
                    (k, e) => MapEntry(int.parse(k as String),
                        Plant.fromJson(Map<String, dynamic>.from(e as Map))),
                  )),
        );
        return val;
      },
    );

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'version': instance.version,
      'appVer': instance.appVer,
      'artworks': instance.artworks.map((e) => e.toJson()).toList(),
      'brushes':
          instance.brushes.map((k, e) => MapEntry(k.toString(), e.toJson())),
      'plants':
          instance.plants.map((k, e) => MapEntry(k.toString(), e.toJson())),
    };

Artwork _$ArtworkFromJson(Map json) => $checkedCreate(
      'Artwork',
      json,
      ($checkedConvert) {
        final val = Artwork(
          name: $checkedConvert('name', (v) => v as String? ?? 'No name'),
          width: $checkedConvert('width', (v) => v as int),
          height: $checkedConvert('height', (v) => v as int),
          matrix: $checkedConvert(
              'matrix',
              (v) => (v as List<dynamic>)
                  .map((e) => (e as List<dynamic>)
                      .map((e) =>
                          ArtCell.fromJson(Map<String, dynamic>.from(e as Map)))
                      .toList())
                  .toList()),
          aspectRatio: $checkedConvert(
              'aspectRatio', (v) => (v as num?)?.toDouble() ?? 1),
          offx: $checkedConvert('offx', (v) => v as int? ?? 0),
          offy: $checkedConvert('offy', (v) => v as int? ?? 0),
          grid: $checkedConvert('grid', (v) => v as bool? ?? true),
          viewWidth: $checkedConvert('viewWidth', (v) => v as int? ?? 0),
        );
        return val;
      },
    );

Map<String, dynamic> _$ArtworkToJson(Artwork instance) => <String, dynamic>{
      'name': instance.name,
      'width': instance.width,
      'height': instance.height,
      'aspectRatio': instance.aspectRatio,
      'matrix': instance.matrix
          .map((e) => e.map((e) => e.toJson()).toList())
          .toList(),
      'offx': instance.offx,
      'offy': instance.offy,
      'grid': instance.grid,
      'viewWidth': instance.viewWidth,
    };

ArtCell _$ArtCellFromJson(Map json) => $checkedCreate(
      'ArtCell',
      json,
      ($checkedConvert) {
        final val = ArtCell(
          brushId: $checkedConvert('brushId', (v) => v as int),
          scale: $checkedConvert('scale', (v) => (v as num).toDouble()),
          angle: $checkedConvert('angle', (v) => v as int),
          zindex: $checkedConvert('zindex', (v) => v as int),
        );
        return val;
      },
    );

Map<String, dynamic> _$ArtCellToJson(ArtCell instance) => <String, dynamic>{
      'brushId': instance.brushId,
      'scale': instance.scale,
      'angle': instance.angle,
      'zindex': instance.zindex,
    };

Brush _$BrushFromJson(Map json) => $checkedCreate(
      'Brush',
      json,
      ($checkedConvert) {
        final val = Brush(
          id: $checkedConvert('id', (v) => v as int),
          plantId: $checkedConvert('plantId', (v) => v as int),
          zindex: $checkedConvert('zindex', (v) => v as int? ?? 1),
          scale:
              $checkedConvert('scale', (v) => (v as num?)?.toDouble() ?? 1.0),
          weight: $checkedConvert('weight', (v) => v as int? ?? 100),
          name: $checkedConvert('name', (v) => v as String? ?? ''),
        );
        return val;
      },
    );

Map<String, dynamic> _$BrushToJson(Brush instance) => <String, dynamic>{
      'id': instance.id,
      'plantId': instance.plantId,
      'zindex': instance.zindex,
      'scale': instance.scale,
      'weight': instance.weight,
      'name': instance.name,
    };

Plant _$PlantFromJson(Map json) => $checkedCreate(
      'Plant',
      json,
      ($checkedConvert) {
        final val = Plant(
          plantId: $checkedConvert('plantId', (v) => v as int),
          name: $checkedConvert('name', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$PlantToJson(Plant instance) => <String, dynamic>{
      'plantId': instance.plantId,
      'name': instance.name,
    };
