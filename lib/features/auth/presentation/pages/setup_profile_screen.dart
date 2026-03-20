import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';

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

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _continueToStep2() {
    if (_firstNameController.text.isNotEmpty && _lastNameController.text.isNotEmpty) {
      setState(() => _currentStep = 2);
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
    setState(() {
      _photoConfirmed = true;
      _setupComplete = true;
    });
  }

  void _changePhoto() {
    setState(() {
      _selectedImage = null;
      _photoConfirmed = false;
    });
  }

  void _goToDashboard() {
    context.goNamed(AppRoutes.dashboard);
  }

  @override
  Widget build(BuildContext context) {
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
        title: const Text(AppStrings.setUpYourProfile,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Center(child: Text('Step 1 of 2', style: TextStyle(fontSize: 14, color: AppColors.textSecondary))),
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
                child: Text(AppStrings.enterYourInformation,
                    style: TextStyle(fontSize: 16, color: AppColors.textPrimary)),
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
              CustomButton(text: AppStrings.continueText, onPressed: _continueToStep2),
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
        title: const Text(AppStrings.uploadAPicture,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 8),
              const Text('Step 2 of 2', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
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
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 2),
                ),
                child: const Icon(Icons.camera_alt, size: 48, color: AppColors.primary),
              ),
              const SizedBox(height: 24),
              const Text(AppStrings.uploadClearPicture,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(AppStrings.photoInstructions,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              ),
              const SizedBox(height: 24),
              _instructionTile(Icons.camera_alt_outlined, AppStrings.clearViewOfFace),
              _instructionTile(Icons.light_mode_outlined, AppStrings.goodLighting),
              _instructionTile(Icons.block, AppStrings.noSunglasses),
              _instructionTile(Icons.image_outlined, AppStrings.recentPicture),
              const Spacer(),
              CustomButton(text: AppStrings.takeAPhoto, onPressed: _takePhoto),
              const SizedBox(height: 12),
              CustomButton(text: AppStrings.uploadFromGallery, onPressed: _pickFromGallery, isOutlined: true),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _instructionTile(IconData icon, String text) {
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
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontSize: 14, color: AppColors.textPrimary)),
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
              Icon(Icons.person, size: 24, color: AppColors.textPrimary.withValues(alpha: 0.5)),
              const SizedBox(height: 16),
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
                      child: const Icon(Icons.check, size: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(AppStrings.lookingGood,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(AppStrings.profilePictureSet,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
              ),
              const Spacer(),
              CustomButton(text: AppStrings.continueBtn, onPressed: _confirmPhoto),
              const SizedBox(height: 12),
              CustomButton(text: AppStrings.changePhoto, onPressed: _changePhoto, isOutlined: true),
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
                  color: AppColors.onboardingCircleInner.withValues(alpha: 0.5),
                ),
                child: const Icon(Icons.check_circle, size: 80, color: AppColors.primary),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.success,
                    ),
                    child: const Icon(Icons.check, size: 14, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  const Text(AppStrings.setupDonePercent,
                      style: TextStyle(fontSize: 14, color: AppColors.success, fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 16),
              const Text(AppStrings.setupComplete,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 12),
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                  children: [
                    TextSpan(text: 'Your profile is ready. You can '),
                    TextSpan(text: 'RoamSafe', style: TextStyle(color: AppColors.primary)),
                    TextSpan(text: ' now.'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary.withValues(alpha: 0.15),
                      ),
                      child: const Center(
                        child: Text('A', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(AppStrings.profileInformation,
                        style: TextStyle(fontSize: 14, color: AppColors.textPrimary)),
                    const Spacer(),
                    const Icon(Icons.check_circle, color: AppColors.success, size: 24),
                  ],
                ),
              ),
              const Spacer(),
              CustomButton(text: AppStrings.goToDashboard, onPressed: _goToDashboard),
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
              const Text(AppStrings.uploadFailed,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(AppStrings.uploadFailedDesc,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
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
