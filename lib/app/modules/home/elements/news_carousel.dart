import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:string_validator/string_validator.dart';

import 'package:painter/app/app.dart';
import 'package:painter/models/db.dart';
import 'package:painter/utils/utils.dart';
import 'package:painter/widgets/carousel_util.dart';
import 'package:painter/widgets/custom_dialogs.dart';
import 'package:painter/widgets/image/image_viewer.dart';

class AppNewsCarousel extends StatefulWidget {
  final double? maxWidth;

  const AppNewsCarousel({Key? key, this.maxWidth}) : super(key: key);

  @override
  _AppNewsCarouselState createState() => _AppNewsCarouselState();

  static Future<void> resolveSliderImageUrls([bool showToast = false]) async {
    //
  }
}

class _AppNewsCarouselState extends State<AppNewsCarousel> {
  int _curCarouselIndex = 0;
  final CarouselController _carouselController = CarouselController();

  CarouselSetting get carouselSetting => db.settings.carousel;

  @override
  void initState() {
    super.initState();
    carouselSetting.needUpdate = carouselSetting.shouldUpdate;
  }

  @override
  Widget build(BuildContext context) {
    final limitOption =
        CarouselUtil.limitHeight(width: widget.maxWidth, maxHeight: 150);

    final pages = getPages();

    if (pages.isEmpty) {
      //
    }
    _curCarouselIndex =
        pages.isEmpty ? 0 : _curCarouselIndex.clamp(0, pages.length - 1);

    CarouselOptions options = CarouselOptions(
        height: limitOption.height,
        aspectRatio: limitOption.aspectRatio,
        autoPlay: pages.length > 1,
        autoPlayInterval: const Duration(seconds: 6),
        viewportFraction: limitOption.viewportFraction,
        enlargeCenterPage: limitOption.enlargeCenterPage,
        enlargeStrategy: limitOption.enlargeStrategy,
        initialPage: _curCarouselIndex,
        onPageChanged: (v, _) {
          setState(() {
            _curCarouselIndex = v;
          });
        });
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CarouselSlider(
          carouselController: _carouselController,
          items: pages,
          options: options,
        ),
        if (pages.isNotEmpty)
          FittedBox(
            fit: BoxFit.scaleDown,
            child: DotsIndicator(
              dotsCount: pages.length,
              position: _curCarouselIndex.toDouble(),
              decorator: const DotsDecorator(
                color: Colors.white70,
                spacing: EdgeInsets.symmetric(vertical: 6, horizontal: 3),
              ),
              onTap: (v) {
                setState(() {
                  _curCarouselIndex = v.toInt().clamp(0, pages.length - 1);
                  _carouselController.animateToPage(_curCarouselIndex);
                });
              },
            ),
          ),
      ],
    );
  }

  List<Widget> getPages() {
    List<Widget> sliders = [];
    if (carouselSetting.needUpdate) {
      AppNewsCarousel.resolveSliderImageUrls().then((_) {
        if (mounted) setState(() {});
      });
      return sliders;
    }
    final items = carouselSetting.items.toList();
    items.removeWhere((item) {
      final t = DateTime.now();
      return item.startTime.isAfter(t) || item.endTime.isBefore(t);
    });
    items.sort((a, b) {
      if (a.priority != b.priority) return a.priority - b.priority;
      return a.startTime.compareTo(b.startTime);
    });
    for (final item in carouselSetting.items) {
      if (item.priority < 0 && !kDebugMode) continue;
      Widget? child;
      if (item.image != null && isURL(item.image!)) {
        child = CachedImage(
          imageUrl: item.image,
          aspectRatio: 8 / 3,
          cachedOption: CachedImageOption(
            errorWidget: (context, url, error) => Container(),
            fit: item.fit,
          ),
        );
      } else if (item.content?.isNotEmpty == true) {
        child = Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          child: Center(
            child: AutoSizeText(
              item.content!,
              textAlign: TextAlign.center,
              maxFontSize: 20,
              minFontSize: 5,
              maxLines: item.content!.split('\n').length,
            ),
          ),
        );
      }
      if (child == null) continue;
      if (item.link != null) {
        child = GestureDetector(
          onTap: () async {
            final link = item.link!;
            const routePrefix = '/painter/route';
            if (link.toLowerCase().startsWith(routePrefix) &&
                link.length > routePrefix.length + 1) {
              router.push(url: link.substring(routePrefix.length));
            } else if (await canLaunch(link)) {
              jumpToExternalLinkAlert(url: link, content: item.title);
            }
          },
          child: child,
        );
      }
      sliders.add(child);
    }
    return sliders;
  }
}
