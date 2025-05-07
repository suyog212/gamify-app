import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kGamify/repositories/banner_ad_repository.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AdBannerCarousel extends StatefulWidget {
  const AdBannerCarousel({super.key});

  @override
  State<AdBannerCarousel> createState() => _AdBannerCarouselState();
}

class _AdBannerCarouselState extends State<AdBannerCarousel> {
  final ValueNotifier<int> _dotIndex = ValueNotifier<int>(0);
  late Future<List<dynamic>> _bannerFuture;

  @override
  void initState() {
    super.initState();
    _bannerFuture = BannerAdRepository().getAdPosters();
  }

  @override
  void dispose() {
    _dotIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _bannerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Skeletonizer(
            enabled: true,
            effect: PulseEffect(
              from: Colors.grey.shade100,
              to: Colors.orange.shade100,
            ),
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.25,
            ),
          );
        }

        if (snapshot.hasError) {
          return SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.25,
            child: Center(
              child: AutoSizeText("Error loading...."),
            ),
          );
        }

        final banners = snapshot.data ?? [];

        if (banners.isEmpty) {
          return const SizedBox(); // or a fallback banner
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CarouselSlider.builder(
              itemCount: banners.length,
              itemBuilder: (context, index, realIdx) {
                final adImageUrl = banners[index]['ad_image'];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4).r,
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(adImageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
              options: CarouselOptions(
                onPageChanged: (index, reason) => _dotIndex.value = index,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 5),
                pauseAutoPlayOnTouch: true,
                aspectRatio: 16 / 9,
                scrollPhysics: const BouncingScrollPhysics(),
                enableInfiniteScroll: banners.length <= 1,
                viewportFraction: 1,
              ),
            ),
            ValueListenableBuilder<int>(
              valueListenable: _dotIndex,
              builder: (context, value, _) => DotsIndicator(
                dotsCount: banners.length,
                position: value.toDouble(),
                decorator: DotsDecorator(
                  activeColor: Theme.of(context).colorScheme.secondary,
                  size: Size(6.r, 6.r),
                  spacing: EdgeInsets.symmetric(horizontal: 4.r, vertical: 6.r),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
