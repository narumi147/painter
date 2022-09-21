part of userdata;

@JsonSerializable()
class Artwork {
  String name;
  int _width;
  int get width => _width;
  int _height;
  int get height => _height;
  double aspectRatio;
  List<List<ArtCell>> matrix;
  @JsonKey(ignore: true)
  List<List<ArtCell?>> foreground;
  // viewport
  int offx;
  int offy;
  bool grid;
  int _viewWidth;
  int get viewWidth => _viewWidth > 1 ? _viewWidth : width;
  set viewWidth(int v) => _viewWidth = v;

  @override
  int get hashCode => Object.hashAll([
        width,
        height,
        aspectRatio,
        offx,
        offy,
        grid,
        _viewWidth,
        for (final r in matrix) Object.hashAll(r)
      ]);

  Artwork({
    this.name = 'No name',
    required int width,
    required int height,
    required this.matrix,
    this.aspectRatio = 1,
    this.offx = 0,
    this.offy = 0,
    this.grid = true,
    int viewWidth = 0,
  })  : assert(width > 0 &&
            height > 0 &&
            matrix.length == height &&
            matrix.first.length == width),
        _width = width,
        _height = height,
        _viewWidth = viewWidth,
        foreground = List.generate(matrix.length,
            (index) => List.generate(matrix[index].length, (_) => null));

  Artwork.fromSize(
    int width,
    int height, {
    this.name = 'No name',
    this.aspectRatio = 1,
    this.grid = true,
  })  : _width = width,
        _height = height,
        offx = 0,
        offy = 0,
        _viewWidth = 0,
        matrix = List.generate(
          height,
          (y) => List.generate(width, (x) => ArtCell.empty()),
        ),
        foreground =
            List.generate(height, (index) => List.generate(width, (_) => null));

  Artwork finalize() {
    return Artwork(
      name: name,
      width: width,
      height: height,
      matrix: matrix.map((e) => List.of(e)).toList(),
      aspectRatio: aspectRatio,
      offx: 0,
      offy: 0,
      grid: false,
      viewWidth: 0,
    );
  }

  void resize({int? w, int? h, Alignment alignment = Alignment.center}) {
    // -1.0 -> 0, 0.0 -> (_w-w)/2, 1.0 -> (_w-w)
    if (w == null && h == null) return;
    w ??= _width;
    h ??= _height;
    final originX = ((_width - w) ~/ 2 * (alignment.x + 1)).floor();
    final originY = ((_height - h) ~/ 2 * (alignment.y + 1)).floor();
    matrix = List.generate(
      h,
      (y) => List.generate(
        w!,
        (x) =>
            matrix.getOrNull(y + originY)?.getOrNull(x + originX) ??
            ArtCell.empty(),
      ),
    );
    foreground = List.generate(h, (y) => List.generate(w!, (x) => null));
    _width = w;
    _height = h;
  }

  void drawAt(int x, int y, ArtCell value) {
    if (x >= 0 && x < width && y >= 0 && y < height) {
      final v = matrix[y][x];
      if (value.brushId >= 0) {
        // normal brush
        if (v.brushId >= 0) {
          matrix[y][x] = value;
        }
      } else if (value.brushId == Brush.kEraser) {
        if (v.brushId >= 0) {
          matrix[y][x].brushId = 0;
        }
      } else if (value.brushId == Brush.kMask) {
        matrix[y][x] = value;
      } else if (value.brushId == Brush.kMaskEraser) {
        if (v.brushId == Brush.kMask) {
          matrix[y][x].brushId = 0;
        }
      }
    } else {
      return;
      // throw PaintError(
      //     'Out of boundary: x=$x, y=$y, width=$width, height=$height, matrix=${matrix.first.length}x${matrix.length}');
    }
  }

  void drawAtView(int vx, int vy, ArtCell value) {
    int x = vx - offx, y = vy - offy;
    drawAt(x, y, value);
  }

  factory Artwork.fromJson(Map<String, dynamic> json) =>
      _$ArtworkFromJson(json);

  Map<String, dynamic> toJson() => _$ArtworkToJson(this);

  @override
  bool operator ==(Object other) {
    return other is Artwork && other.hashCode == hashCode;
  }
}

@JsonSerializable()
class ArtCell {
  int brushId; // -> image
  double scale; // 0.5-3
  int angle; // -180~180
  int zindex; // 1~

  ArtCell({
    required this.brushId,
    required this.scale,
    required this.angle,
    required this.zindex,
  });

  ArtCell.empty()
      : brushId = 0,
        scale = 1,
        angle = 0,
        zindex = 1;

  @override
  int get hashCode => Object.hashAll([brushId, scale, angle]);

  factory ArtCell.fromJson(Map<String, dynamic> json) =>
      _$ArtCellFromJson(json);

  Map<String, dynamic> toJson() => _$ArtCellToJson(this);

  @override
  bool operator ==(Object other) {
    return other is ArtCell && other.hashCode == hashCode;
  }
}

class PaintError implements Exception {
  String message;
  PaintError([this.message = '']);
  @override
  String toString() {
    return 'PaintError: $message';
  }
}
