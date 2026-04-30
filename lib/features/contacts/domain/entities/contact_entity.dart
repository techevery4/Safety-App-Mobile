import 'package:equatable/equatable.dart';

/// Status of a trusted contact.
enum ContactStatus { confirmed, pending }

/// Domain entity representing a trusted contact.
class ContactEntity extends Equatable {
  final String id;
  final String userId;
  final String contactId;
  final String name;
  final String email;
  final ContactStatus status;

  const ContactEntity({
    required this.id,
    required this.userId,
    required this.contactId,
    required this.name,
    required this.email,
    required this.status,
  });

  /// Returns the initials (first letter of first + last name).
  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  @override
  List<Object?> get props => [id, userId, contactId, name, email, status];
}
