import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../features/ads/presentation/bloc/ads_bloc.dart';
import '../../../../features/ads/presentation/bloc/ads_state.dart';
import '../../../advertising/domain/entities/ad_entity.dart';

class AdCarouselWidget extends StatefulWidget {
  const AdCarouselWidget({super.key});

  @override
  State<AdCarouselWidget> createState() => _AdCarouselWidgetState();
}

class _AdCarouselWidgetState extends State<AdCarouselWidget> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoPlay(int totalPages) {
    _timer?.cancel();
    if (totalPages <= 1) return;

    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (_currentPage < totalPages - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdsBloc, AdsState>(
      builder: (context, state) {
        if (state is AdsInitial || state is AdsLoading) {
          return const SizedBox(
            height: 180,
            child: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

        List<AdEntity> ads = [];
        if (state is AdsLoaded) {
          ads = state.ads;
        }

        if (ads.isEmpty) {
          return const SizedBox.shrink(); // Hide if no ads
        }

        // Restart timer when list changes
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _startAutoPlay(ads.length);
        });

        return Column(
          children: [
            SizedBox(
              height: 180,
              width: double.infinity,
              child: PageView.builder(
                controller: _pageController,
                itemCount: ads.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final ad = ads[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceGrey.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: _buildAdImage(ad),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            _buildIndicators(ads.length),
          ],
        );
      },
    );
  }

  Widget _buildAdImage(AdEntity ad) {
    // Handle both local file paths and network URLs
    if (ad.imageUrl.startsWith('http')) {
      return Image.network(
        ad.imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Center(
          child: Icon(Icons.image, size: 50, color: AppColors.textHint),
        ),
      );
    } else {
      return Image.file(
        File(ad.imageUrl),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Center(
          child: Icon(Icons.image, size: 50, color: AppColors.textHint),
        ),
      );
    }
  }

  Widget _buildIndicators(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: _currentPage == index ? 20 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: _currentPage == index ? AppColors.primary : AppColors.border,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}
