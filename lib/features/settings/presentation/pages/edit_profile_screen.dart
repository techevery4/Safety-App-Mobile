import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/custom_button.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController(text: 'Jane');
  final _lastNameController = TextEditingController(text: 'Doe');
  final _phoneController = TextEditingController(text: '+2348000000000');
  final _emailController = TextEditingController(text: 'jane.doe@example.com');

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      // TODO: Dispatch updated profile to Bloc
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully'), backgroundColor: AppColors.primary),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Edit Profile', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      Center(
                        child: Stack(
                          children: [
                            const CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=a042581f4e29026704d'),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                                child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      CustomTextField(
                        controller: _firstNameController,
                        hintText: 'First Name',
                        prefixIcon: const Icon(Icons.person_outline, color: AppColors.textSecondary),
                        validator: (value) => value == null || value.isEmpty ? 'First name is required' : null,
                      ),
                      const SizedBox(height: 16),
                      
                      CustomTextField(
                        controller: _lastNameController,
                        hintText: 'Last Name',
                        prefixIcon: const Icon(Icons.person_outline, color: AppColors.textSecondary),
                        validator: (value) => value == null || value.isEmpty ? 'Last name is required' : null,
                      ),
                      const SizedBox(height: 16),
                      
                      CustomTextField(
                        controller: _phoneController,
                        hintText: 'Phone Number',
                        prefixIcon: const Icon(Icons.phone_outlined, color: AppColors.textSecondary),
                        keyboardType: TextInputType.phone,
                        validator: (value) => value == null || value.isEmpty ? 'Phone number is required' : null,
                      ),
                      const SizedBox(height: 16),
                      
                      CustomTextField(
                        controller: _emailController,
                        hintText: 'Email Address',
                        prefixIcon: const Icon(Icons.email_outlined, color: AppColors.textSecondary),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) => value == null || value.isEmpty ? 'Email is required' : null,
                      ),
                    ],
                  ),
                ),
                
                CustomButton(
                  text: 'Save Changes',
                  onPressed: _saveChanges,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
