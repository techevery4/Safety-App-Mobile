import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../bloc/contacts_bloc.dart';
import '../bloc/contacts_event.dart';
import '../bloc/contacts_state.dart';

enum _AddContactView { form, success, failure }

/// Screen for adding a new trusted contact.
class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key});

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  _AddContactView _currentView = _AddContactView.form;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _clearForm() {
    _nameController.clear();
    _emailController.clear();
    _formKey.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ContactsBloc, ContactsState>(
      listener: (context, state) {
        if (state is AddContactSuccess) {
          setState(() {
            _isLoading = false;
            _currentView = _AddContactView.success;
          });
        } else if (state is AddContactFailure) {
          setState(() {
            _isLoading = false;
            _currentView = _AddContactView.failure;
          });
        }
      },
      child: _buildCurrentView(),
    );
  }

  Widget _buildCurrentView() {
    switch (_currentView) {
      case _AddContactView.form:
        return _buildFormView();
      case _AddContactView.success:
        return _buildSuccessView();
      case _AddContactView.failure:
        return _buildFailureView();
    }
  }

  // ============================================================
  // FORM VIEW
  // ============================================================
  Widget _buildFormView() {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          AppStrings.addContact,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                CustomTextField(
                  label: AppStrings.contactName,
                  hintText: AppStrings.enterContactName,
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: AppStrings.contactEmail,
                  hintText: AppStrings.enterContactEmail,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter an email';
                    }
                    final emailRegex = RegExp(
                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                    );
                    if (!emailRegex.hasMatch(value.trim())) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                CustomButton(
                  text: AppStrings.addContact,
                  isLoading: _isLoading,
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      setState(() => _isLoading = true);
                      context.read<ContactsBloc>().add(
                            AddContactEvent(
                              name: _nameController.text.trim(),
                              email: _emailController.text.trim(),
                            ),
                          );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SUCCESS VIEW
  // ============================================================
  Widget _buildSuccessView() {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Spacer(flex: 2),
              // Large green circle with success image
              Container(
                width: 200,
                height: 200,
                decoration: const BoxDecoration(
                  color: AppColors.backgroundSuccess,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Image.asset(
                    AppAssets.successImage,
                    width: 180,
                    height: 180,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.check_circle,
                      color: AppColors.success,
                      size: 100,
                    ),
                  ),
                ),
              ),
              const Spacer(flex: 1),
              const Text(
                AppStrings.contactAddedSuccessfully,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                AppStrings.contactAddedDesc,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              CustomButton(
                text: AppStrings.backToContacts,
                onPressed: () => context.goNamed(AppRoutes.contacts),
              ),
              const SizedBox(height: 12),
              CustomButton(
                text: AppStrings.addAnotherContact,
                isOutlined: true,
                onPressed: () {
                  _clearForm();
                  setState(() => _currentView = _AddContactView.form);
                },
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // FAILURE VIEW
  // ============================================================
  Widget _buildFailureView() {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Spacer(flex: 2),
              // Large pink/salmon circle with error image
              Container(
                width: 200,
                height: 200,
                decoration: const BoxDecoration(
                  color: AppColors.errorBackground,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Image.asset(
                    AppAssets.errorImage,
                    width: 180,
                    height: 180,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.error,
                      color: AppColors.error,
                      size: 100,
                    ),
                  ),
                ),
              ),
              const Spacer(flex: 1),
              const Text(
                AppStrings.contactNotFound,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                AppStrings.contactNotFoundDesc,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              CustomButton(
                text: AppStrings.backToContacts,
                onPressed: () => context.goNamed(AppRoutes.contacts),
              ),
              const SizedBox(height: 12),
              CustomButton(
                text: AppStrings.addAnotherContact,
                isOutlined: true,
                onPressed: () {
                  _clearForm();
                  setState(() => _currentView = _AddContactView.form);
                },
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
