import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../shared/widgets/custom_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingData> _pages = [
    _OnboardingData(
      title: 'Stay ',
      highlight: 'Connected',
      description: AppStrings.onboardingDesc1,
      icon: Icons.people,
      secondaryIcons: [Icons.people_outline, Icons.favorite, Icons.location_on],
    ),
    _OnboardingData(
      title: 'Instant ',
      highlight: 'Emergency',
      titleSuffix: ' Response',
      description: AppStrings.onboardingDesc2,
      icon: Icons.sos,
      secondaryIcons: [],
      isSOSPage: true,
    ),
    _OnboardingData(
      title: 'Enjoy ',
      highlight: 'Peace',
      titleSuffix: ' of Mind',
      description: AppStrings.onboardingDesc3,
      icon: Icons.shield,
      secondaryIcons: [],
    ),
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      context.goNamed(AppRoutes.register);
    }
  }

  void _skip() {
    context.goNamed(AppRoutes.register);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: GestureDetector(
                  onTap: _skip,
                  child: const Text(
                    AppStrings.skip,
                    style: TextStyle(fontSize: 16, color: AppColors.textPrimary, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),

            // Page content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) => _buildPage(_pages[index]),
              ),
            ),

            // Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: CustomButton(
                text: _currentPage == _pages.length - 1 ? AppStrings.getStarted : AppStrings.next,
                onPressed: _nextPage,
              ),
            ),

            const SizedBox(height: 20),

            // Dot indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? AppColors.primary : AppColors.dotInactive,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(_OnboardingData data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Circular illustration
          Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.onboardingCircleOuter.withValues(alpha: 0.6),
            ),
            child: Center(
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.onboardingCircleInner.withValues(alpha: 0.8),
                  border: Border.all(color: AppColors.onboardingCircleOuter.withValues(alpha: 0.3), width: 3),
                ),
                child: data.isSOSPage
                    ? _buildSOSIcon()
                    : _buildFeatureIcon(data),
              ),
            ),
          ),
          const SizedBox(height: 40),

          // Title with highlighted word
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              children: [
                TextSpan(text: data.title),
                TextSpan(
                  text: data.highlight,
                  style: const TextStyle(color: AppColors.primary),
                ),
                if (data.titleSuffix != null) TextSpan(text: data.titleSuffix),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Description
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: AppColors.textSecondary, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildSOSIcon() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 70,
          height: 120,
          decoration: BoxDecoration(
            color: AppColors.textPrimary.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withValues(alpha: 0.3),
                    ],
                  ),
                ),
                child: const Center(
                  child: Text('SOS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureIcon(_OnboardingData data) {
    if (data.secondaryIcons.isNotEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _circleIcon(Icons.person, 28),
              const SizedBox(width: 16),
              _circleIcon(Icons.people_outline, 28),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _circleIcon(Icons.favorite, 28),
              const SizedBox(width: 16),
              _circleIcon(Icons.location_on, 28),
            ],
          ),
        ],
      );
    }
    return Icon(data.icon, size: 60, color: AppColors.primary);
  }

  Widget _circleIcon(IconData icon, double size) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.5)),
      ),
      child: Icon(icon, size: size - 8, color: AppColors.primary),
    );
  }
}

class _OnboardingData {
  final String title;
  final String highlight;
  final String? titleSuffix;
  final String description;
  final IconData icon;
  final List<IconData> secondaryIcons;
  final bool isSOSPage;

  const _OnboardingData({
    required this.title,
    required this.highlight,
    this.titleSuffix,
    required this.description,
    required this.icon,
    required this.secondaryIcons,
    this.isSOSPage = false,
  });
}
