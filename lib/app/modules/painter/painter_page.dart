import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path/path.dart' as pathlib;

import 'package:painter/generated/l10n.dart';
import 'package:painter/models/db.dart';
import 'package:painter/utils/utils.dart';
import 'package:painter/widgets/widgets.dart';
import '../../../packages/packages.dart';
import 'art_list.dart';

class PainterPage extends StatefulWidget {
  final Artwork artwork;
  const PainterPage({super.key, required this.artwork});

  @override
  State<PainterPage> createState() => _PainterPageState();
}

class _PainterPageState extends State<PainterPage> {
  late final Artwork art = widget.artwork;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('画布'),
        actions: [popupMenu],
      ),
      body: buildContent(context),
    );
  }

  PopupMenuButton get popupMenu {
    return PopupMenuButton(
      itemBuilder: (context) => [
        PopupMenuItem(
          child: const Text('修改画布'),
          onTap: () async {
            await null;
            if (!mounted) return;
            await showDialog(
              context: context,
              builder: (context) => ArtworkAddDialog(artwork: art),
            );
            if (mounted) setState(() {});
          },
        ),
        PopupMenuItem(
          onTap: export,
          child: const Text('导出'),
        )
      ],
    );
  }

  Future<void> export() async {
    final recorder = ui.PictureRecorder();
    final _art = art.finalize();
    final size = Size(_art.width * 100, _art.height * 100 / _art.aspectRatio);
    final canvas = Canvas(
      recorder,
      Rect.fromLTWH(0, 0, size.width, size.height),
    );
    ArtPainter.drawCanvas(canvas, size, _art, brushImages);
    final picture = recorder.endRecording();
    EasyLoading.show(
        status: 'Rendering...', maskType: EasyLoadingMaskType.clear);
    try {
      await Future.delayed(const Duration(milliseconds: 50));
      ui.Image img =
          await picture.toImage(size.width.toInt(), size.height.toInt());
      final imgBytes = (await img.toByteData(format: ui.ImageByteFormat.png))
          ?.buffer
          .asUint8List();
      if (imgBytes == null) {
        EasyLoading.showError('失败');
        return;
      }
      EasyLoading.showSuccess('渲染成功，请保存图片');
      final filepath = await FilePicker.platform.saveFile(
          dialogTitle: '保存 ${_art.name}',
          allowedExtensions: ['png'],
          fileName: 'example.png');
      print('save path: $filepath');
      if (filepath == null) {
        EasyLoading.showError('未选择路径');
        return;
      }
      File(filepath).writeAsBytesSync(imgBytes);
      EasyLoading.showSuccess('保存成功');
      // openFile(File(filepath).parent.path);
    } catch (e, s) {
      logger.e('render canvas failed', e, s);
      EasyLoading.showError(e.toString());
    }
  }

  Map<int, ui.Image?> brushImages = {};

  int? curBrushId;
  Brush? get brush => db.userData.brushes[curBrushId];
  double? curScale;
  int angle = 0;
  int brushSize = 1;
  bool randomMode = false;

  void update() {
    // art.dy = art.dy.clamp2(-art.height);
    if (mounted) setState(() {});
  }

  Future<void> loadAllBrushes() async {
    brushImages = {
      for (final brush in db.userData.brushes.values)
        brush.id: await loadBrush(brush),
    };
    update();
    if (mounted) setState(() {});
  }

  Future<ui.Image?> loadBrush(Brush brush) async {
    ImageProvider provider = FileImage(File(brush.filepath));
    final stream = provider.resolve(ImageConfiguration.empty);
    final completer = Completer<ui.Image?>();
    stream.addListener(ImageStreamListener((info, _) {
      completer.complete(info.image);
    }, onError: (e, s) async {
      // EasyLoading.showError(e.toString());
      logger.e('load Image error', e, s);
      completer.complete(null);
    }));
    return completer.future;
  }

  @override
  void initState() {
    super.initState();
    loadAllBrushes();
  }

  final focusNode = FocusNode();
  final canvasKey = GlobalKey();

  Widget buildContent(BuildContext context) {
    update();
    return FocusScope(
      child: RawKeyboardListener(
        focusNode: focusNode,
        onKey: (event) {
          if (event is! RawKeyDownEvent) return;
          if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
            art.offy -= 1;
          } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
            art.offy += 1;
          } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
            art.offx -= 1;
          } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
            art.offx += 1;
          }
          if (mounted) setState(() {});
        },
        child: Row(
          children: [
            Expanded(
              child: paint,
            ),
            kVerticalDivider,
            SizedBox(width: 240, child: buttonBar),
          ],
        ),
      ),
    );
  }

  Offset _moveOffset = Offset.zero;

  Widget get paint {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: GestureDetector(
        key: canvasKey,
        onSecondaryTapDown: (details) {
          // right mouse button
        },
        onPanStart: (details) {
          details.kind;
          if (curBrushId == Brush.kMove) {
            _moveOffset = Offset(art.offx.toDouble(), art.offy.toDouble());
            return;
          }
          _drawAt(details.localPosition, null);
        },
        onPanUpdate: (details) {
          _drawAt(details.localPosition, details.delta);
        },
        child: CustomPaint(
          painter: ArtPainter(art, brushImages),
          size: Size.infinite,
        ),
      ),
    );
  }

  Widget get buttonBar {
    List<Brush> brushes = db.userData.brushes.values.toList();
    brushes.sort((a, b) {
      if (a.plantId != b.plantId) return a.plantId - b.plantId;
      return a.id - b.id;
    });
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            children: [
              const Text('视图', textAlign: TextAlign.center),
              Text('画布大小: ${art.width}×${art.height}'),
              Row(
                children: [
                  Expanded(child: Text('dx=${art.offx}')),
                  Expanded(child: Text('dy=${art.offy}')),
                ],
              ),
              Text('单元格长宽比=${art.aspectRatio}'),

              Text('可视宽度=${art.viewWidth}'),
              Slider.adaptive(
                value: max(10.0, art.viewWidth.toDouble()),
                min: 20.0,
                max: art.width * 3,
                onChanged: (v) {
                  setState(() {
                    art.viewWidth = v.round();
                  });
                },
              ),
              CheckboxWithLabel(
                value: art.grid,
                label: const Text('网格'),
                onChanged: (v) {
                  setState(
                    () {
                      art.grid = v ?? art.grid;
                    },
                  );
                },
              ),
              const Divider(height: 16),
              Text('Scale=${curScale ?? brush?.scale ?? 1}'),
              Slider.adaptive(
                value: curScale ?? brush?.scale ?? 1.0,
                min: 0.5,
                max: 3.0,
                divisions: (3 - 0.5) ~/ 0.1,
                onChanged: (v) {
                  setState(() {
                    curScale = (v * 10).toInt() / 10;
                  });
                },
              ),
              Text('旋转(顺时针)=$angle'),
              Slider.adaptive(
                value: angle.toDouble(),
                min: -180,
                max: 180,
                divisions: 360 ~/ 5,
                onChanged: (v) {
                  setState(() {
                    angle = v.round();
                  });
                },
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    art.offx = art.offy = 1;
                    art.viewWidth = art.width + 2;
                    curScale = brush?.scale;
                    angle = 0;
                  });
                },
                child: const Text('重置视图'),
              ),
              const Divider(indent: 8, endIndent: 8, height: 16),
              //
              const Text('笔刷s', textAlign: TextAlign.center),
              Wrap(
                spacing: 2,
                runSpacing: 2,
                children: [
                  _SelectedButton(
                    selected: curBrushId == Brush.kMove,
                    icon: const FaIcon(FontAwesomeIcons.hand, size: 14),
                    child: const Text('移动'),
                    onPressed: () {
                      setState(() {
                        curBrushId = Brush.kMove;
                      });
                    },
                  ),
                  _SelectedButton(
                    selected: curBrushId == Brush.kEraser,
                    icon: const FaIcon(FontAwesomeIcons.eraser, size: 14),
                    child: const Text('橡皮擦'),
                    onPressed: () {
                      setState(() {
                        curBrushId = Brush.kEraser;
                      });
                    },
                  ),
                  _SelectedButton(
                    selected: curBrushId == Brush.kMask,
                    icon: const FaIcon(FontAwesomeIcons.mask, size: 14),
                    child: const Text('遮罩'),
                    onPressed: () {
                      setState(() {
                        curBrushId = Brush.kMask;
                      });
                    },
                  ),
                  _SelectedButton(
                    selected: curBrushId == Brush.kMaskEraser,
                    // icon: const FaIcon(FontAwesomeIcons.mask),
                    child: const Text('遮罩橡皮擦'),
                    onPressed: () {
                      setState(() {
                        curBrushId = Brush.kMaskEraser;
                      });
                    },
                  ),
                ],
              ),
              SwitchListTile.adaptive(
                value: randomMode,
                title: const Text(
                  '随机笔刷(同一植物)',
                  textScaleFactor: 0.75,
                ),
                onChanged: (v) {
                  setState(() {
                    randomMode = v;
                  });
                },
              ),
              Text('笔刷大小: $brushSize'),
              Slider.adaptive(
                value: brushSize.toDouble(),
                min: 1,
                max: 20,
                divisions: (20 - 1) ~/ 1,
                onChanged: (v) {
                  setState(() {
                    brushSize = v.round();
                  });
                },
              ),
              for (final b in brushes)
                _SelectedButton(
                  selected: randomMode
                      ? brush?.plantId == b.plantId
                      : curBrushId == b.id,
                  icon: Image.file(File(b.filepath), width: 24),
                  child:
                      Text('${b.id} ${b.name} - ${b.plantId} ${b.plant?.name}'),
                  onPressed: () {
                    setState(() {
                      curBrushId = b.id;
                    });
                  },
                )
            ],
          ),
        ),
        const Divider(indent: 8, endIndent: 8, height: 16),
        Center(
          child: SizedBox(
            width: 72,
            height: 72,
            child: GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              shrinkWrap: true,
              children: [
                const SizedBox(),
                _arrow(Icons.keyboard_arrow_up, () => art.offy -= 1),
                const SizedBox(),
                _arrow(Icons.keyboard_arrow_left, () => art.offx -= 1),
                const SizedBox(),
                _arrow(Icons.keyboard_arrow_right, () => art.offx += 1),
                const SizedBox(),
                _arrow(Icons.keyboard_arrow_down, () => art.offy += 1),
                const SizedBox(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _drawAt(Offset localPos, Offset? delta) {
    int? _brushId = curBrushId;
    if (_brushId == null) return;
    final box = canvasKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;
    final dx = box.size.width / art.viewWidth;
    final dy = dx / art.aspectRatio;
    if (_brushId == Brush.kMove && delta != null) {
      _moveOffset += Offset(delta.dx / dx, delta.dy / dy);
      art.offx = _moveOffset.dx.round();
      art.offy = _moveOffset.dy.round();
      art.offx = art.offx.clamp(-art.width, art.viewWidth);
    } else {
      final lx = localPos.dx;
      final ly = localPos.dy;
      // 1->0,2->0.5,3->1,4->1.5
      final brushIds = <int>[];
      if (randomMode && brush != null && brush!.id > 0) {
        final validBrushes = db.userData.brushes.values
            .where((b) => b.plantId == brush?.plantId)
            .toList();
        for (final b in validBrushes) {
          brushIds.addAll(List.filled(b.weight, b.id));
        }
      }
      if (brushIds.isEmpty) {
        brushIds.add(_brushId);
      }
      final random = Random();
      int getBrush() {
        if (brushIds.length == 1) return brushIds.first;
        return brushIds[random.nextInt(brushIds.length)];
      }

      for (int i = 0; i < brushSize; i++) {
        for (int j = 0; j < brushSize; j++) {
          final cx = lx + (-(brushSize - 1) / 2 + i) * dx;
          final cy = ly + (-(brushSize - 1) / 2 + j) * dy;
          final b = getBrush();
          art.drawAtView(
            cx ~/ dx,
            cy ~/ dy,
            ArtCell(
              brushId: b,
              scale: curScale ?? brush?.scale ?? 1,
              angle: angle,
              zindex: brush?.zindex ?? 1,
            ),
          );
        }
      }
    }
    setState(() {});
  }

  void _drawOnce() {}

  Timer? _timer;

  Widget _arrow(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: () {
        print('onTap');
        setState(() {
          onTap();
        });
      },
      onTapDown: (details) async {
        _timer?.cancel();
        _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
          if (timer.tick < 5) return;
          if (mounted) {
            setState(() {
              onTap();
            });
          }
        });
      },
      onTapUp: (details) {
        _timer?.cancel();
        _timer = null;
      },
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Icon(icon),
      ),
    );
  }
}

class ArtPainter extends CustomPainter {
  final Artwork artwork;
  final Map<int, ui.Image?> brushes;

  ArtPainter(this.artwork, this.brushes);

  int _lastArtHash = 0;

  static void drawCanvas(
      Canvas canvas, Size size, Artwork artwork, Map<int, ui.Image?> brushes) {
    final dx = size.width / artwork.viewWidth;
    final dy = dx / artwork.aspectRatio; //ratio=1.0
    final w = artwork.viewWidth, h = size.height ~/ dy;

    final vertices = [
      Offset(artwork.offx * dx, artwork.offy * dy),
      Offset((artwork.offx + artwork.width) * dx, artwork.offy * dy),
      Offset((artwork.offx + artwork.width) * dx,
          (artwork.offy + artwork.height) * dy),
      Offset(artwork.offx * dx, (artwork.offy + artwork.height) * dy),
    ];

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..color = Colors.grey);

    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, h * dy));
    canvas.drawRect(Rect.fromPoints(vertices[0], vertices[2]),
        Paint()..color = Colors.white);

    final allZIndex = {
      for (final row in artwork.matrix)
        for (final cell in row) cell.zindex
    }.whereType<int>().toList()
      ..sort();

    // from bottom to top
    for (final zindex in allZIndex) {
      for (int y = h - 1; y >= 0; y--) {
        // from left to right
        for (int x = 0; x < w; x++) {
          double left = x * dx, top = y * dy;
          final cell = artwork.matrix
              .getOrNull(y - artwork.offy)
              ?.getOrNull(x - artwork.offx);
          // bg cell
          if (cell == null) {
            // canvas.drawRect(
            //   Rect.fromLTWH(left, top, dx, dy),
            //   Paint()..color = Colors.grey,
            // );
            continue;
          } else if (cell.brushId == Brush.kMask) {
            canvas.drawRect(
              Rect.fromLTWH(left, top, dx, dy),
              Paint()..color = Colors.yellow,
            );
            continue;
          } else if (cell.brushId == Brush.kEraser) {
            // transparent, not paint yet
            continue;
          } else if (cell.brushId == 0) {
            // transparent, not paint yet
            continue;
          }
          if (cell.zindex != zindex) {
            // draw order by zindex
            continue;
          }
          final brushImage = brushes[cell.brushId];
          // brush not found
          if (brushImage == null) continue;
          // image
          canvas.save();
          canvas.translate(left + dx / 2, top + dy / 2);
          canvas.rotate(cell.angle / 180 * pi);
          canvas.drawImageRect(
            brushImage,
            Rect.fromLTWH(0, 0, brushImage.width.toDouble(),
                brushImage.height.toDouble()),
            // Rect.fromLTWH(left, top, dx, dy),
            Rect.fromCenter(
              center: Offset.zero,
              width: cell.scale * dx,
              height: cell.scale * dy,
            ),
            Paint(),
          );
          canvas.restore();
        }
      }
    }
    // foreground

    for (int y = h - 1; y >= 0; y--) {
      // from left to right
      for (int x = 0; x < w; x++) {
        double left = x * dx, top = y * dy;
        final cell = artwork.foreground
            .getOrNull(y - artwork.offy)
            ?.getOrNull(x - artwork.offx);
        // bg cell
        if (cell == null) {
          continue;
        } else if (cell.brushId == Brush.kMask) {
          canvas.drawRect(
            Rect.fromLTWH(left, top, dx, dy),
            Paint()..color = Colors.yellow,
          );
          continue;
        } else if (cell.brushId == 0) {
          // transparent, not paint yet
          continue;
        }
        final brushImage = brushes[cell.brushId];
        // brush not found
        if (brushImage == null) continue;
        // image
        canvas.save();
        canvas.translate(left + dx / 2, top + dy / 2);
        canvas.rotate(cell.angle / 180 * pi);
        canvas.drawImageRect(
          brushImage,
          Rect.fromLTWH(
              0, 0, brushImage.width.toDouble(), brushImage.height.toDouble()),
          // Rect.fromLTWH(left, top, dx, dy),
          Rect.fromCenter(
            center: Offset.zero,
            width: cell.scale * dx,
            height: cell.scale * dy,
          ),
          Paint(),
        );
        canvas.restore();
      }
    }

    // grid
    if (artwork.grid) {
      final gridPaint = Paint()
        ..strokeWidth = 1
        ..color = Colors.grey;
      for (int y = 0; y <= h; y++) {
        canvas.drawLine(
            Offset(0, y * dy), Offset(size.width, y * dy), gridPaint);
      }
      for (int x = 0; x <= w; x++) {
        canvas.drawLine(
            Offset(x * dx, 0), Offset(x * dx, size.height), gridPaint);
      }
      final borderPaint = Paint()
        ..strokeWidth = 2
        ..color = Colors.black87;
      // canvas.save();
      canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
      for (int index = 0; index < vertices.length; index++) {
        canvas.drawLine(vertices[index],
            vertices[(index + 1) % vertices.length], borderPaint);
      }
      // canvas.restore();
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    _lastArtHash = artwork.hashCode;
    drawCanvas(canvas, size, artwork, brushes);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is! ArtPainter) return true;
    if (oldDelegate.brushes != brushes ||
        _lastArtHash != artwork.hashCode ||
        oldDelegate.artwork != artwork) {
      return true;
    }
    return false;
  }
}

class _SelectedButton extends StatelessWidget {
  final bool selected;
  final Widget child;
  final VoidCallback? onPressed;
  final Widget? icon;
  const _SelectedButton({
    required this.selected,
    required this.child,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    Widget _child = selected
        ? icon == null
            ? ElevatedButton(onPressed: onPressed, child: child)
            : ElevatedButton.icon(
                onPressed: onPressed, icon: icon!, label: child)
        : icon == null
            ? OutlinedButton(onPressed: onPressed, child: child)
            : OutlinedButton.icon(
                onPressed: onPressed, icon: icon!, label: child);
    return Padding(
      padding: const EdgeInsets.all(2),
      child: _child,
    );
  }
}
