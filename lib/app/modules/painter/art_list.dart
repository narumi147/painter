import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:painter/app/app.dart';
import 'package:painter/app/modules/painter/painter_page.dart';
import 'package:painter/generated/l10n.dart';
import 'package:painter/models/db.dart';
import 'package:painter/widgets/widgets.dart';

class ArtListPage extends StatefulWidget {
  const ArtListPage({super.key});

  @override
  State<ArtListPage> createState() => _ArtListPageState();
}

class _ArtListPageState extends State<ArtListPage> {
  @override
  Widget build(BuildContext context) {
    final artworks = db.userData.artworks.toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('笔刷'),
        actions: [
          IconButton(
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (context) => const ArtworkAddDialog(),
              );
              if (mounted) setState(() {});
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          final artwork = artworks[index];
          return ListTile(
            title: Text(artwork.name),
            subtitle: Text('${artwork.width}×${artwork.height}'),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () {
              router.pushPage(PainterPage(artwork: artwork));
            },
          );
        },
        itemCount: artworks.length,
      ),
    );
  }
}

class ArtworkAddDialog extends StatefulWidget {
  final Artwork? artwork;
  const ArtworkAddDialog({super.key, this.artwork});

  @override
  State<ArtworkAddDialog> createState() => _ArtworkAddDialogState();
}

class _ArtworkAddDialogState extends State<ArtworkAddDialog> {
  late final _nameController =
      TextEditingController(text: widget.artwork?.name ?? '未命名');
  late final _widthController =
      TextEditingController(text: (widget.artwork?.width ?? 400).toString());
  late final _heightController =
      TextEditingController(text: (widget.artwork?.height ?? 300).toString());

  @override
  Widget build(BuildContext context) {
    return SimpleCancelOkDialog(
      title: const Text('新建'),
      hideOk: true,
      actions: [
        TextButton(
          onPressed: () {
            final name = _nameController.text;
            final width = int.tryParse(_widthController.text) ?? 0;
            final height = int.tryParse(_heightController.text) ?? 0;
            if (name.isEmpty || width <= 0 || height <= 0) {
              EasyLoading.showError('无效输入');
              return;
            }
            if (widget.artwork != null) {
              final art = widget.artwork!;
              art.name = name;
              art.resize(w: width, h: height);
              Navigator.pop(context);
            } else {
              final art = Artwork.fromSize(width, height, name: name);
              db.userData.artworks.add(art);
              Navigator.pop(context);
              router.pushPage(PainterPage(artwork: art));
            }
          },
          child: Text(S.current.confirm),
        ),
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
              const Text('宽度'),
              const Spacer(),
              SizedBox(
                width: 90,
                child: TextField(
                  controller: _widthController,
                  textAlign: TextAlign.end,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              )
            ],
          ),
          Row(
            children: [
              const Text('高度'),
              const Spacer(),
              SizedBox(
                width: 90,
                child: TextField(
                  controller: _heightController,
                  textAlign: TextAlign.end,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
