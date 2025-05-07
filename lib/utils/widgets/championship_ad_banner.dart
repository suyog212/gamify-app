import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:kGamify/repositories/banner_ad_repository.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ChampionshipBannerAds extends StatefulWidget {
  final String champId;

  const ChampionshipBannerAds({super.key, required this.champId});

  @override
  State<ChampionshipBannerAds> createState() => _ChampionshipBannerAdsState();
}

class _ChampionshipBannerAdsState extends State<ChampionshipBannerAds> {
  late Future<List<dynamic>> _adsFuture;

  @override
  void initState() {
    super.initState();
    _adsFuture = BannerAdRepository().getChampionshipBannerAds(int.parse(widget.champId));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _adsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Skeletonizer(
            effect: PulseEffect(
              from: Colors.grey.shade100,
              to: Colors.orange.shade100,
            ),
            enabled: true,
            child: const SizedBox(height: kToolbarHeight),
          );
        }

        if (snapshot.hasError) {
          return const SizedBox();
        }

        final banners = snapshot.data ?? [];

        if (banners.isEmpty) {
          return const SizedBox(); // Or fallback content
        }

        return CarouselSlider.builder(
          itemCount: banners.length,
          itemBuilder: (context, index, realIndex) {
            final adImage = banners[index]['ad_image'] ?? '';
            return CachedNetworkImage(
              imageUrl: adImage,
              width: double.infinity,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => const Icon(Icons.error),
            );
          },
          options: CarouselOptions(
            autoPlay: false,
            scrollPhysics: const NeverScrollableScrollPhysics(),
            height: kToolbarHeight,
            viewportFraction: 1.0,
          ),
        );
      },
    );
  }
}
