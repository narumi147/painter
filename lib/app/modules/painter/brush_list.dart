import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:painter/generated/l10n.dart';
import 'package:painter/models/db.dart';
import 'package:painter/utils/utils.dart';
import 'package:painter/widgets/widgets.dart';

class BrushManagePage extends StatefulWidget {
  const BrushManagePage({super.key});

  @override
  State<BrushManagePage> createState() => _BrushManagePageState();
}

class _BrushManagePageState extends State<BrushManagePage> {
  @override
  Widget build(BuildContext context) {
    final brushes = db.userData.brushes.values.toList();
    brushes.sort2((e) => e.id);
    return Scaffold(
      appBar: AppBar(
        title: const Text('笔刷'),
        actions: [
          IconButton(
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (context) => const BrushAddDialog(),
              );
              if (mounted) setState(() {});
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          final brush = brushes[index];
          return ListTile(
            leading: Image.file(File(brush.filepath), width: 64),
            title: Text(brush.name),
            subtitle: Text(
                'ID:${brush.id}   plant: ${brush.plantId}-${brush.plant?.name}\n'
                'z:${brush.zindex}     scale:${brush.scale.toStringAsFixed(1)}\n'
                'weight: ${brush.weight}'),
            trailing: PopupMenuButton(itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Text(S.current.edit),
                  onTap: () async {
                    await null;
                    await showDialog(
                      context: context,
                      builder: (context) => BrushAddDialog(brush: brush),
                    );
                    if (mounted) setState(() {});
                  },
                ),
                PopupMenuItem(
                  child: Text(S.current.delete),
                  onTap: () {
                    db.userData.brushes.remove(brush);
                    setState(() {});
                  },
                ),
              ];
            }),
          );
        },
        itemCount: brushes.length,
      ),
    );
  }
}

class BrushAddDialog extends StatefulWidget {
  final Brush? brush;
  const BrushAddDialog({super.key, this.brush});

  @override
  State<BrushAddDialog> createState() => _BrushAddDialogState();
}

class _BrushAddDialogState extends State<BrushAddDialog> {
  late final _nameController = TextEditingController(text: widget.brush?.name);
  late final _idController = TextEditingController(
      text: (widget.brush?.id ?? Maths.max(db.userData.brushes.keys, 0) + 1)
          .toString());
  late final _zindexController =
      TextEditingController(text: (widget.brush?.zindex ?? 1).toString());
  late final _scaleController =
      TextEditingController(text: (widget.brush?.scale ?? 1.0).toString());
  late final _weightController =
      TextEditingController(text: (widget.brush?.weight ?? 100).toString());

  Uint8List? imgData;
  int? newId;
  late int plantId = widget.brush?.plantId ?? 0;
  @override
  void initState() {
    super.initState();
    if (widget.brush != null) {
      try {
        imgData = File(widget.brush!.filepath).readAsBytesSync();
      } catch (e) {
        print('Read image failed: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SimpleCancelOkDialog(
      title: Text(widget.brush == null ? '新增' : '编辑'),
      hideOk: true,
      actions: [
        TextButton(
          onPressed: imgData == null
              ? null
              : () {
                  Brush brush;
                  if (widget.brush == null) {
                    newId = int.tryParse(_idController.text);
                    if (db.userData.brushes.containsKey(newId)) {
                      EasyLoading.showError('ID已存在');
                      return;
                    }
                    brush = Brush(id: newId!, plantId: 0);
                  } else {
                    brush = widget.brush!;
                    if (newId != null && newId != brush.id) {
                      if (db.userData.brushes.containsKey(newId)) {
                        EasyLoading.showError('ID已存在');
                        return;
                      }
                      db.userData.brushes.remove(brush.id);
                      brush.id = newId!;
                    }
                  }
                  brush.plantId = plantId;
                  brush.zindex =
                      int.tryParse(_zindexController.text) ?? brush.zindex;
                  brush.scale =
                      double.tryParse(_scaleController.text) ?? brush.scale;
                  brush.name = _nameController.text;
                  brush.weight =
                      int.tryParse(_weightController.text) ?? brush.weight;
                  File(brush.filepath).writeAsBytesSync(imgData!);
                  db.userData.brushes[brush.id] = brush;
                  Navigator.pop(context);
                },
          child: Text(S.current.confirm),
        ),
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Text('ID'),
              const Spacer(),
              SizedBox(
                width: 90,
                child: TextField(
                  controller: _idController,
                  textAlign: TextAlign.end,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (s) {
                    newId = int.tryParse(s);
                  },
                ),
              )
            ],
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            title: const Text('植物ID'),
            subtitle:
                Text('$plantId ${db.userData.plants[plantId]?.name ?? ""}'),
            trailing: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return SimpleDialog(
                      title: const Text('变更植物'),
                      children: [
                        for (final p in db.userData.plants.values)
                          SimpleDialogOption(
                            child: Text('${p.plantId} ${p.name}'),
                            onPressed: () {
                              Navigator.pop(context);
                              plantId = p.plantId;
                              if (mounted) setState(() {});
                            },
                          ),
                        Center(
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.clear),
                          ),
                        )
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.change_circle),
            ),
          ),
          Row(
            children: [
              const Text('Z-Index'),
              const Spacer(),
              SizedBox(
                width: 90,
                child: TextField(
                  controller: _zindexController,
                  textAlign: TextAlign.end,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  // onChanged: (s) {
                  //   newId = int.tryParse(s);
                  // },
                ),
              )
            ],
          ),
          Row(
            children: [
              const Text('Default scale'),
              const Spacer(),
              SizedBox(
                width: 90,
                child: TextField(
                  controller: _scaleController,
                  textAlign: TextAlign.end,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'\d*\.*\d*'))
                  ],
                  // onChanged: (s) {
                  //   newId = int.tryParse(s);
                  // },
                ),
              )
            ],
          ),
          Row(
            children: [
              const Text('出现几率'),
              const Spacer(),
              SizedBox(
                width: 90,
                child: TextField(
                  controller: _weightController,
                  textAlign: TextAlign.end,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (s) {
                    //
                  },
                ),
              )
            ],
          ),
          Row(
            children: [
              const Text('名称'),
              const Spacer(),
              SizedBox(
                width: 120,
                child: TextField(
                  controller: _nameController,
                  textAlign: TextAlign.end,
                ),
              )
            ],
          ),
          Row(
            children: [
              const Text('图片'),
              const Spacer(),
              IconButton(
                onPressed: () async {
                  final result = await FilePicker.platform
                      .pickFiles(type: FileType.image, withData: true);
                  if (result != null) {
                    imgData = result.files.getOrNull(0)?.bytes;
                  }
                  if (mounted) setState(() {});
                },
                icon: imgData == null
                    ? const Icon(Icons.add_photo_alternate)
                    : Image.memory(imgData!, height: 48),
              ),
            ],
          )
        ],
      ),
    );
  }
}
