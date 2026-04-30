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
      id: 1,
      title: 'Stay ',
      highlight: 'Connected',
      description: AppStrings.onboardingDesc1,
      imagePath: 'assets/images/connected.png',
    ),
    _OnboardingData(
      id: 2,
      title: 'Instant ',
      highlight: 'Emergency',
      titleSuffix: ' Response',
      description: AppStrings.onboardingDesc2,
      imagePath: 'assets/images/sos.png',
    ),
    _OnboardingData(
      id: 3,
      title: 'Enjoy ',
      highlight: 'Peace',
      titleSuffix: ' of Mind',
      description: AppStrings.onboardingDesc3,
      imagePath: 'assets/images/shield.png',
    ),
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.goNamed(AppRoutes.register);
    }
  }

  void _skip() => context.goNamed(AppRoutes.register);

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
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: GestureDetector(
                  onTap: _skip,
                  child: const Text(
                    AppStrings.skip,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
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

            // Next / Get Started button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: CustomButton(
                text: _currentPage == _pages.length - 1
                    ? AppStrings.getStarted
                    : AppStrings.next,
                onPressed: _nextPage,
              ),
            ),

            const SizedBox(height: 16),

            // Outlined Login Button
            if (_currentPage == _pages.length - 1)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: CustomButton(
                  text: "Login",
                  onPressed: () => context.goNamed(AppRoutes.login),
                  isOutlined: true,
                ),
              ),

            const SizedBox(height: 32),

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
                    color: _currentPage == index
                        ? AppColors.primary
                        : AppColors.dotInactive,
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
          // Outer teal ring
          Container(
            width: 260,
            height: 260,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.onboardingCircleOuter,
            ),
            child: Center(
              // Inner white circle that holds the image
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: data.id == 1 ? Colors.white : Colors.transparent,
                ),
                child: Image.asset(data.imagePath, fit: BoxFit.cover),
              ),
            ),
          ),

          const SizedBox(height: 48),

          // Title with highlighted word
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
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
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingData {
  final int id;
  final String title;
  final String highlight;
  final String? titleSuffix;
  final String description;
  final String imagePath;

  const _OnboardingData({
    required this.id,
    required this.title,
    required this.highlight,
    this.titleSuffix,
    required this.description,
    required this.imagePath,
  });
}
