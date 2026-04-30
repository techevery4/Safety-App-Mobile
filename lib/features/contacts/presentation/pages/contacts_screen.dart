import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../../../dashboard/presentation/widgets/bottom_nav_bar.dart';
import '../../domain/entities/contact_entity.dart';
import '../bloc/contacts_bloc.dart';
import '../bloc/contacts_event.dart';
import '../bloc/contacts_state.dart';

/// Main contacts screen with Confirmed and Pending tabs.
class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  int _selectedTab = 0; // 0 = Confirmed, 1 = Pending
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_selectedTab == 0 && _isBottom) {
      context.read<ContactsBloc>().add(LoadMoreConfirmedContactsEvent());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _onNavTap(int index) {
    switch (index) {
      case 0:
        context.goNamed(AppRoutes.dashboard);
        break;
      case 1:
        // Already on contacts
        break;
      case 2:
        context.pushNamed(AppRoutes.locationSharing);
        break;
      case 3:
        context.pushNamed(AppRoutes.settings);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
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
          AppStrings.contacts,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            fontSize: 18,
          ),
        ),
      ),
      body: BlocConsumer<ContactsBloc, ContactsState>(
        listener: (context, state) {
          if (state is RemoveContactSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(AppStrings.contactRemoved)),
            );
          }
        },
        builder: (context, state) {
          if (state is ContactsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          List<ContactEntity> confirmed = [];
          List<ContactEntity> pending = [];
          List<ContactEntity> filtered = [];

          if (state is ContactsLoaded) {
            confirmed = state.confirmed;
            pending = state.pending;
            filtered = state.filtered;
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      AppStrings.trustedContacts,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      AppStrings.manageEmergencyContacts,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Tab switcher
                    _buildTabSwitcher(),
                    const SizedBox(height: 16),

                    // Search bar
                    _buildSearchBar(context),
                    const SizedBox(height: 12),
                  ],
                ),
              ),

              // Contact list
              Expanded(
                child: _buildContactList(
                  context,
                  confirmed: confirmed,
                  pending: pending,
                  filtered: filtered,
                  isLoadingMore: state is ContactsLoaded ? state.isLoadingMore : false,
                ),
              ),

              // Add New Contact button
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => context.pushNamed(AppRoutes.addContact),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: const Text(
                      AppStrings.addNewContact,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textWhite,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1,
        onTap: _onNavTap,
      ),
    );
  }

  Widget _buildTabSwitcher() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceGrey,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() {
                _selectedTab = 0;
                _searchController.clear();
                context.read<ContactsBloc>().add(
                      const SearchContactsEvent(query: ''),
                    );
              }),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: _selectedTab == 0
                      ? AppColors.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(22),
                ),
                alignment: Alignment.center,
                child: Text(
                  AppStrings.confirmedContacts,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _selectedTab == 0
                        ? AppColors.textWhite
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() {
                _selectedTab = 1;
                _searchController.clear();
                context.read<ContactsBloc>().add(
                      const SearchContactsEvent(query: ''),
                    );
              }),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: _selectedTab == 1
                      ? AppColors.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(22),
                ),
                alignment: Alignment.center,
                child: Text(
                  AppStrings.pending,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _selectedTab == 1
                        ? AppColors.textWhite
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (query) {
          context.read<ContactsBloc>().add(
                SearchContactsEvent(query: query),
              );
        },
        decoration: const InputDecoration(
          hintText: AppStrings.searchForContact,
          hintStyle: TextStyle(
            fontStyle: FontStyle.italic,
            color: AppColors.textHint,
          ),
          prefixIcon: Icon(Icons.search, color: AppColors.textHint),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildContactList(
    BuildContext context, {
    required List<ContactEntity> confirmed,
    required List<ContactEntity> pending,
    required List<ContactEntity> filtered,
    required bool isLoadingMore,
  }) {
    final bool isSearching = _searchController.text.isNotEmpty;
    List<ContactEntity> displayList;

    if (isSearching) {
      displayList = filtered
          .where((c) =>
              _selectedTab == 0
                  ? c.status == ContactStatus.confirmed
                  : c.status == ContactStatus.pending)
          .toList();
    } else {
      displayList = _selectedTab == 0 ? confirmed : pending;
    }

    if (displayList.isEmpty && !isLoadingMore) {
      return Center(
        child: Text(
          _selectedTab == 0
              ? AppStrings.noContactsYet
              : AppStrings.noPendingRequests,
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: displayList.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < displayList.length) {
          final contact = displayList[index];
          return _buildContactCard(context, contact);
        } else {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        }
      },
    );
  }

  Widget _buildContactCard(BuildContext context, ContactEntity contact) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildContactAvatar(contact.name),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  contact.email,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (contact.status == ContactStatus.confirmed)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: AppColors.error),
              onPressed: () => _showRemoveSheet(context, contact),
            )
          else ...[
            IconButton(
              icon: const Icon(Icons.check_circle_outline,
                  color: AppColors.success),
              onPressed: () {
                context.read<ContactsBloc>().add(
                      AcceptContactEvent(contactId: contact.id),
                    );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text(AppStrings.contactAccepted)),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.cancel_outlined, color: AppColors.error),
              onPressed: () => _showDeclineSheet(context, contact),
            ),
          ],
        ],
      ),
    );
  }

  void _showRemoveSheet(BuildContext context, ContactEntity contact) {
    final bloc = context.read<ContactsBloc>();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: AppColors.errorBackground,
                child: const Icon(Icons.person_remove,
                    color: AppColors.error, size: 28),
              ),
              const SizedBox(height: 16),
              Text(
                '${AppStrings.removeContact.replaceAll('Contact', '')}${contact.name}?',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                AppStrings.removeContactDesc,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    bloc.add(RemoveContactEvent(contactId: contact.id));
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    AppStrings.removeContact,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textWhite,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    side: const BorderSide(color: AppColors.border),
                  ),
                  child: const Text(
                    AppStrings.cancel,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeclineSheet(BuildContext context, ContactEntity contact) {
    final bloc = context.read<ContactsBloc>();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: AppColors.warningBackground,
                child: const Icon(Icons.warning_amber_rounded,
                    color: AppColors.warning, size: 28),
              ),
              const SizedBox(height: 16),
              const Text(
                AppStrings.declineThisRequest,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                AppStrings.declineRequestDesc,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    bloc.add(DeclineContactEvent(contactId: contact.id));
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(AppStrings.requestDeclined)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    AppStrings.declineRequest,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textWhite,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    side: const BorderSide(color: AppColors.border),
                  ),
                  child: const Text(
                    AppStrings.cancel,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- Avatar helpers ---

  Color _avatarColor(String name) {
    const colors = [
      Color(0xFF7E57C2), // purple
      Color(0xFFFF7043), // orange
      Color(0xFF26A69A), // teal
      Color(0xFF42A5F5), // blue
      Color(0xFFEC407A), // pink
    ];
    return colors[name.hashCode.abs() % colors.length];
  }

  Widget _buildContactAvatar(String name) {
    final color = _avatarColor(name);
    final parts = name.trim().split(' ');
    final initials = parts.length >= 2
        ? '${parts[0][0]}${parts[1][0]}'.toUpperCase()
        : (name.isNotEmpty ? name[0].toUpperCase() : '?');

    return CircleAvatar(
      radius: 20,
      backgroundColor: color.withValues(alpha: 0.2),
      child: Text(
        initials,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}
