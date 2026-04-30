import '../../domain/entities/contact_entity.dart';

/// Data model that maps to/from JSON for [ContactEntity].
class ContactModel extends ContactEntity {
  final DateTime? createdOn;

  const ContactModel({
    required super.id,
    required super.userId,
    required super.contactId,
    required super.name,
    required super.email,
    required super.status,
    this.createdOn,
  });

  /// Creates a [ContactModel] from a JSON map.
  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      contactId: json['contactId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      status: ContactStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => ContactStatus.pending,
      ),
      createdOn: json['createdOn'] != null
          ? DateTime.tryParse(json['createdOn'])
          : null,
    );
  }

  /// Converts this model to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'contactId': contactId,
      'name': name,
      'email': email,
      'status': status.name,
      'createdOn': createdOn?.toIso8601String(),
    };
  }

  /// Creates a [ContactModel] from a [ContactEntity].
  factory ContactModel.fromEntity(ContactEntity entity) {
    return ContactModel(
      id: entity.id,
      userId: entity.userId,
      contactId: entity.contactId,
      name: entity.name,
      email: entity.email,
      status: entity.status,
    );
  }
}
