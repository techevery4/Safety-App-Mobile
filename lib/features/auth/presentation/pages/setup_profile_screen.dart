import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/services/storage/onboarding_storage_service.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class SetupProfileScreen extends StatefulWidget {
  const SetupProfileScreen({super.key});
  @override
  State<SetupProfileScreen> createState() => _SetupProfileScreenState();
}

class _SetupProfileScreenState extends State<SetupProfileScreen> {
  int _currentStep = 1;
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  File? _selectedImage;
  bool _photoConfirmed = false;
  bool _setupComplete = false;
  bool _uploadFailed = false;

  String? _userId;

  @override
  void initState() {
    super.initState();
    // Read persisted user ID for the profile setup API call
    final onboardingStorage = sl<OnboardingStorageService>();
    _userId = onboardingStorage.getUserId();

    // If user already completed profile setup (name), jump to step 2
    final stage = onboardingStorage.getStage();
    if (stage == OnboardingStage.profileSetup) {
      _currentStep = 2;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _continueToStep2() {
    if (_firstNameController.text.isNotEmpty &&
        _lastNameController.text.isNotEmpty &&
        _userId != null) {
      // Call the profile setup API
      context.read<AuthBloc>().add(AuthSetupProfileRequested(
        userId: _userId!,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
      ));
    }
  }

  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
        _uploadFailed = false;
      });
    }
  }

  Future<void> _pickFromGallery() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // Check file size (max 5MB)
      final fileSize = await File(image.path).length();
      if (fileSize > 5 * 1024 * 1024) {
        setState(() => _uploadFailed = true);
        return;
      }
      setState(() {
        _selectedImage = File(image.path);
        _uploadFailed = false;
      });
    }
  }

  void _confirmPhoto() {
    // Photo upload API not available yet — store locally and proceed
    setState(() {
      _photoConfirmed = true;
      _setupComplete = true;
    });
    // Mark onboarding as completed
    sl<OnboardingStorageService>().saveStage(OnboardingStage.completed);
  }

  void _changePhoto() {
    setState(() {
      _selectedImage = null;
      _photoConfirmed = false;
    });
  }

  void _skipPhoto() {
    // Skip photo upload and mark onboarding as completed
    setState(() {
      _setupComplete = true;
    });
    sl<OnboardingStorageService>().saveStage(OnboardingStage.completed);
  }

  void _goToDashboard() {
    context.goNamed(AppRoutes.dashboard);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthProfileSetupSuccess) {
          // Profile name saved successfully — advance to photo step
          setState(() => _currentStep = 2);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (_setupComplete) return _buildSetupComplete();
    if (_uploadFailed) return _buildUploadFailed();
    if (_selectedImage != null && !_photoConfirmed) return _buildPhotoPreview();
    if (_currentStep == 2) return _buildStep2();
    return _buildStep1();
  }

  Widget _buildStep1() {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          AppStrings.setUpYourProfile,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  'Step 1 of 2',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Progress bar
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.dotInactive,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Center(
                child: Text(
                  AppStrings.enterYourInformation,
                  style: TextStyle(fontSize: 16, color: AppColors.textPrimary),
                ),
              ),
              const SizedBox(height: 24),
              CustomTextField(
                label: AppStrings.firstName,
                controller: _firstNameController,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: AppStrings.lastName,
                controller: _lastNameController,
              ),
              const Spacer(),
              BlocBuilder<AuthBloc, AuthState>(
                buildWhen: (prev, curr) =>
                    curr is AuthLoading || curr is AuthError || curr is AuthProfileSetupSuccess,
                builder: (context, state) {
                  final isLoading = state is AuthLoading;
                  return CustomButton(
                    text: isLoading ? 'Saving...' : AppStrings.continueText,
                    onPressed: isLoading ? null : _continueToStep2,
                  );
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep2() {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => setState(() => _currentStep = 1),
        ),
        title: const Text(
          AppStrings.uploadAPicture,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _skipPhoto,
            child: const Text(
              'Skip',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 8),
              const Text(
                'Step 2 of 2',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 12),
              // Progress bar
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Camera icon circle
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.onboardingCircleInner,
                  border: Border.all(color: AppColors.primary, width: 2),
                ),
                child: Image.asset(
                  "assets/icons/clear_picture.png",
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                AppStrings.uploadClearPicture,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  AppStrings.photoInstructions,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _instructionTile(
                "assets/icons/clear_view.png",
                AppStrings.clearViewOfFace,
              ),
              _instructionTile("assets/icons/gl.png", AppStrings.goodLighting),
              _instructionTile(
                "assets/icons/no_sunglasses.png",
                AppStrings.noSunglasses,
              ),
              _instructionTile(
                "assets/icons/recent_picture.png",
                AppStrings.recentPicture,
              ),
              const Spacer(),
              CustomButton(text: AppStrings.takeAPhoto, onPressed: _takePhoto),
              const SizedBox(height: 12),
              CustomButton(
                text: AppStrings.uploadFromGallery,
                onPressed: _pickFromGallery,
                isOutlined: true,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _instructionTile(String path, String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Image.asset(
            path,
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoPreview() {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: _changePhoto,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(),
              Stack(
                children: [
                  CircleAvatar(
                    radius: 80,
                    backgroundImage: FileImage(_selectedImage!),
                  ),
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.success,
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                AppStrings.lookingGood,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  AppStrings.profilePictureSet,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const Spacer(),
              CustomButton(
                text: AppStrings.continueBtn,
                onPressed: _confirmPhoto,
              ),
              const SizedBox(height: 12),
              CustomButton(
                text: AppStrings.changePhoto,
                onPressed: _changePhoto,
                isOutlined: true,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSetupComplete() {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () {},
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(),
              // Success illustration
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.onboardingCircleInner,
                ),
                child: Image.asset(
                  "assets/images/setup_complete.png",
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: AppColors.backgroundSuccess,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      "assets/icons/checkmark_circle.png",
                      fit: BoxFit.contain,
                      width: 20,
                      height: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      AppStrings.setupDonePercent,
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.success,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                AppStrings.setupComplete,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.textSecondary,
                  ),
                  children: [
                    TextSpan(text: 'Your profile is ready. You can '),
                    TextSpan(
                      text: 'RoamSafe',
                      style: TextStyle(color: AppColors.primary),
                    ),
                    TextSpan(text: ' now.'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.onboardingCircleInner,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      "assets/icons/small_profile.png",
                      fit: BoxFit.contain,
                      width: 20,
                      height: 20,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      AppStrings.profileInformation,
                      style: TextStyle(
                        fontSize: 19,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    Image.asset(
                      "assets/icons/checkmark_circle.png",
                      fit: BoxFit.contain,
                      width: 20,
                      height: 20,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              CustomButton(
                text: AppStrings.goToDashboard,
                onPressed: _goToDashboard,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadFailed() {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => setState(() {
            _uploadFailed = false;
            _selectedImage = null;
          }),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.errorBackground,
                ),
                child: const Center(
                  child: Icon(Icons.error, size: 64, color: AppColors.error),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                AppStrings.uploadFailed,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  AppStrings.uploadFailedDesc,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const Spacer(),
              CustomButton(
                text: AppStrings.tryAgain,
                onPressed: () => setState(() {
                  _uploadFailed = false;
                  _selectedImage = null;
                }),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
