import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as pathlib;
import 'package:uuid/uuid.dart';

import 'package:painter/utils/utils.dart';
import '../../models/db.dart';
import 'cached_image_option.dart';
import 'image_actions.dart';
import 'photo_view_option.dart';

export 'cached_image_option.dart';
export 'fullscreen_image_viewer.dart';
export 'image_actions.dart';
export 'photo_view_option.dart';

class CachedImage extends StatefulWidget {
  final ImageProvider? imageProvider;

  final String? imageUrl;

  /// Save only if the image is wiki file
  final String? cacheDir;
  final String? cacheName;
  final bool showSaveOnLongPress;
  final double? aspectRatio;

  /// [width], [height], [placeholder] will override [cachedOption]
  final double? width; //2
  final double? height; //2
  final PlaceholderWidgetBuilder? placeholder; //2

  final CachedImageOption? cachedOption;
  final PhotoViewOption? photoViewOption;
  final VoidCallback? onTap;

  const CachedImage({
    Key? key,
    required this.imageUrl,
    this.cacheDir,
    this.cacheName,
    this.showSaveOnLongPress = false,
    this.width,
    this.height,
    this.aspectRatio,
    this.placeholder,
    this.cachedOption,
    this.photoViewOption,
    this.onTap,
  })  : imageProvider = null,
        super(key: key);

  const CachedImage.fromProvider({
    Key? key,
    required this.imageProvider,
    this.showSaveOnLongPress = false,
    this.width,
    this.height,
    this.aspectRatio,
    this.placeholder,
    this.cachedOption = const CachedImageOption(),
    this.photoViewOption,
    this.onTap,
  })  : imageUrl = null,
        cacheDir = null,
        cacheName = null,
        super(key: key);

  @override
  _CachedImageState createState() => _CachedImageState();

  /// If download is available, use [CircularProgressIndicator].
  /// Otherwise, use an empty Container.
  static Widget defaultProgressPlaceholder(BuildContext context, String? url) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width =
            0.3 * min(constraints.biggest.width, constraints.biggest.height);
        width = min(width, 50);
        return Center(
          child: SizedBox(
            width: width,
            height: width,
            child: const Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }

  static Widget defaultErrorWidget(
      BuildContext context, String? url, dynamic error) {
    return const SizedBox();
  }

  static Widget sizeChild(
      {required Widget child,
      double? width,
      double? height,
      double? aspectRatio}) {
    if (aspectRatio != null) {
      child = AspectRatio(aspectRatio: aspectRatio, child: child);
    }
    if (width != null || height != null) {
      child = SizedBox(width: width, height: height, child: child);
    }
    return child;
  }
}

class _CachedImageState extends State<CachedImage> {
  CachedImageOption get cachedOption =>
      widget.cachedOption ?? const CachedImageOption();

  ImageStreamListener? _imageStreamListener;

  @override
  Widget build(BuildContext context) {
    Widget child = resolveChild();
    child = CachedImage.sizeChild(
      child: child,
      width: widget.width,
      height: widget.height,
      aspectRatio: widget.aspectRatio,
    );
    if (widget.onTap != null) {
      child = GestureDetector(
        onTap: widget.onTap,
        child: child,
      );
    }
    return child;
  }

  Widget resolveChild() {
    if (widget.imageProvider != null) {
      return _withProvider(widget.imageProvider!);
    }
    String? url = widget.imageUrl;
    if (url == null) return _withPlaceholder(context, '');
    return _withCached(url);
  }

  Widget _withError(BuildContext context, String url, [dynamic error]) {
    return cachedOption.errorWidget?.call(context, url, error) ??
        const SizedBox();
  }

  Widget _withProvider(ImageProvider provider,
      {Future<void> Function()? onClearCache}) {
    Widget child = FadeInImage(
      placeholder: MemoryImage(kOnePixel),
      image: provider,
      imageErrorBuilder: cachedOption.errorWidget == null
          ? (ctx, e, s) => CachedImage.defaultErrorWidget(ctx, '', e)
          : (ctx, e, s) => cachedOption.errorWidget!(ctx, '', e),
      placeholderErrorBuilder: (ctx, e, s) => const SizedBox(),
      // width: widget.width,
      // height: widget.height,
      fit: cachedOption.fit,
      alignment: cachedOption.alignment,
      repeat: cachedOption.repeat,
      matchTextDirection: cachedOption.matchTextDirection,
      fadeInCurve: cachedOption.fadeInCurve,
      fadeOutCurve: cachedOption.fadeOutCurve,
      fadeInDuration: cachedOption.fadeInDuration,
      fadeOutDuration: cachedOption.fadeOutDuration,
    );
    if (widget.showSaveOnLongPress) {
      child = GestureDetector(
        child: child,
        onLongPress: () async {
          _imageStreamListener ??= ImageStreamListener((info, sycCall) async {
            final bytes =
                await info.image.toByteData(format: ui.ImageByteFormat.png);
            final data = bytes?.buffer.asUint8List();
            if (data == null) {
              EasyLoading.showError('Failed');
              return;
            }
            if (!mounted) return;
            // some sha1 hash value for same data
            String fn =
                '${const Uuid().v5(Uuid.NAMESPACE_URL, sha1.convert(data).toString())}.png';
            ImageActions.showSaveShare(
              context: context,
              data: data,
              destFp: joinPaths(db.paths.downloadDir, fn),
              gallery: true,
              share: true,
              onClearCache: onClearCache,
            );
          });
          provider.resolve(ImageConfiguration.empty)
            ..removeListener(_imageStreamListener!)
            ..addListener(_imageStreamListener!);
        },
      );
    }
    return child;
  }

  Widget _withCached(String fullUrl) {
    final _cacheManager =
        cachedOption.cacheManager ?? ImageViewerCacheManager();
    Uri? uri = Uri.tryParse(fullUrl);
    String url = uri?.toString() ?? fullUrl;

    Widget child = CachedNetworkImage(
      imageUrl: url,
      httpHeaders: cachedOption.httpHeaders,
      imageBuilder: cachedOption.imageBuilder,
      placeholder: _withPlaceholder,
      progressIndicatorBuilder: cachedOption.progressIndicatorBuilder,
      errorWidget: cachedOption.errorWidget ?? CachedImage.defaultErrorWidget,
      fadeOutDuration: cachedOption.fadeOutDuration,
      fadeOutCurve: cachedOption.fadeOutCurve,
      fadeInDuration: cachedOption.fadeInDuration,
      fadeInCurve: cachedOption.fadeInCurve,
      width: widget.width ?? cachedOption.width,
      height: widget.height ?? cachedOption.height,
      fit: cachedOption.fit,
      alignment: cachedOption.alignment,
      repeat: cachedOption.repeat,
      matchTextDirection: cachedOption.matchTextDirection,
      cacheManager: _cacheManager,
      useOldImageOnUrlChange: cachedOption.useOldImageOnUrlChange,
      color: cachedOption.color,
      filterQuality: cachedOption.filterQuality,
      colorBlendMode: cachedOption.colorBlendMode,
      placeholderFadeInDuration: cachedOption.placeholderFadeInDuration,
      memCacheWidth: cachedOption.memCacheWidth,
      memCacheHeight: cachedOption.memCacheHeight,
      cacheKey: cachedOption.cacheKey,
      maxWidthDiskCache: cachedOption.maxWidthDiskCache,
      maxHeightDiskCache: cachedOption.maxHeightDiskCache,
    );
    if (widget.showSaveOnLongPress) {
      Future<void> onClearCache() async {
        await _cacheManager.removeFile(cachedOption.cacheKey ?? url);
        if (mounted) setState(() {});
      }

      child = GestureDetector(
        child: child,
        onLongPress: () async {
          if (kIsWeb) {
            return ImageActions.showSaveShare(
              context: context,
              srcFp: fullUrl,
              onClearCache: onClearCache,
            );
          } else {
            File file = File((await _cacheManager.getSingleFile(fullUrl)).path);
            String fn = pathlib.basename(file.path);
            return ImageActions.showSaveShare(
              context: context,
              srcFp: file.path,
              destFp: joinPaths(db.paths.downloadDir, fn),
              gallery: true,
              share: true,
              shareText: fn,
              onClearCache: onClearCache,
            );
          }
        },
      );
    }
    return child;
  }

  Widget _withPlaceholder(BuildContext context, String url) {
    if (widget.placeholder != null) return widget.placeholder!(context, url);
    if (cachedOption.placeholder != null) {
      return cachedOption.placeholder!(context, url);
    }
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: CachedImage.defaultProgressPlaceholder(context, url),
    );
  }
}

class ImageViewerCacheManager extends CacheManager with ImageCacheManager {
  static const key = 'painterCachedImageData';

  static final ImageViewerCacheManager _instance = ImageViewerCacheManager._();
  factory ImageViewerCacheManager() {
    return _instance;
  }

  ImageViewerCacheManager._()
      : super(Config(
          key,
          stalePeriod: const Duration(days: 30),
          fileService: _MyHttpFileService(),
        ));
}

class _MyHttpFileService extends FileService {
  final http.Client _httpClient;

  _MyHttpFileService({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  @override
  Future<FileServiceResponse> get(String url,
      {Map<String, String>? headers}) async {
    final uri = Uri.parse(url);
    final req = http.Request('GET', uri);
    if (headers != null) {
      req.headers.addAll(headers);
    }
    final httpResponse = await _httpClient.send(req);
    if ([
      'webview.fate-go.jp',
      'news.fate-go.jp',
      'i0.hdslb.com',
      'webview.fate-go.us',
      'static.fate-go.com.tw',
    ].contains(uri.host)) {
      // 30days=2,592,000
      httpResponse.headers
          .addAll({HttpHeaders.cacheControlHeader: 'max-age=2592000'});
    }
    return HttpGetResponse(httpResponse);
  }
}
