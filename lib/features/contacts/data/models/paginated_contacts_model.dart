import 'contact_model.dart';

/// Represents a paginated response of contacts from the backend.
class PaginatedContactsModel {
  final int totalPages;
  final int size;
  final int totalElements;
  final bool hasNext;
  final bool hasPrevious;
  final List<ContactModel> content;

  PaginatedContactsModel({
    required this.totalPages,
    required this.size,
    required this.totalElements,
    required this.hasNext,
    required this.hasPrevious,
    required this.content,
  });

  factory PaginatedContactsModel.fromJson(Map<String, dynamic> json) {
    return PaginatedContactsModel(
      totalPages: json['totalPages'] as int? ?? 0,
      size: json['size'] as int? ?? 0,
      totalElements: json['totalElements'] as int? ?? 0,
      hasNext: json['hasNext'] as bool? ?? false,
      hasPrevious: json['hasPrevious'] as bool? ?? false,
      content: (json['content'] as List<dynamic>?)
              ?.map((e) => ContactModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
