import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:painter/generated/l10n.dart';
import 'package:painter/models/db.dart';
import 'package:painter/utils/utils.dart';
import 'package:painter/widgets/widgets.dart';

class PlantManagePage extends StatefulWidget {
  const PlantManagePage({super.key});

  @override
  State<PlantManagePage> createState() => _PlantManagePageState();
}

class _PlantManagePageState extends State<PlantManagePage> {
  @override
  Widget build(BuildContext context) {
    final plants = db.userData.plants.values.toList();
    plants.sort2((e) => e.plantId);
    return Scaffold(
      appBar: AppBar(
        title: const Text('植物'),
        actions: [
          IconButton(
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (context) => const PlantAddDialog(),
              );
              if (mounted) setState(() {});
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          final plant = plants[index];
          return ListTile(
            title: Text(plant.name),
            subtitle: Text('ID: ${plant.plantId}'),
            trailing: PopupMenuButton(itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Text(S.current.edit),
                  onTap: () async {
                    await null;
                    await showDialog(
                      context: context,
                      builder: (context) => PlantAddDialog(plant: plant),
                    );
                    if (mounted) setState(() {});
                  },
                ),
                PopupMenuItem(
                  child: Text(S.current.delete),
                  onTap: () {
                    setState(() {
                      db.userData.plants.remove(plant);
                    });
                  },
                ),
              ];
            }),
          );
        },
        itemCount: plants.length,
      ),
    );
  }
}

class PlantAddDialog extends StatefulWidget {
  final Plant? plant;
  const PlantAddDialog({super.key, this.plant});

  @override
  State<PlantAddDialog> createState() => _PlantAddDialogState();
}

class _PlantAddDialogState extends State<PlantAddDialog> {
  late final _nameController = TextEditingController(text: widget.plant?.name);
  late final _idController = TextEditingController(
      text: (widget.plant?.plantId ?? Maths.max(db.userData.plants.keys, 0) + 1)
          .toString());
  int? newId;

  @override
  Widget build(BuildContext context) {
    return SimpleCancelOkDialog(
      title: Text(widget.plant == null ? '新增' : '编辑'),
      hideOk: true,
      actions: [
        TextButton(
          onPressed: () {
            Plant plant;
            if (widget.plant == null) {
              newId = int.tryParse(_idController.text);
              if (db.userData.plants.containsKey(newId)) {
                EasyLoading.showError('ID已存在');
                return;
              }
              plant = Plant(plantId: newId!, name: _nameController.text);
            } else {
              plant = widget.plant!;
              if (newId != null && newId != plant.plantId) {
                if (db.userData.plants.containsKey(newId)) {
                  EasyLoading.showError('ID已存在');
                  return;
                }
                db.userData.plants.remove(plant.plantId);
                plant.plantId = newId!;
              }
            }
            plant.name = _nameController.text;
            db.userData.plants[plant.plantId] = plant;
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
        ],
      ),
    );
  }
}
