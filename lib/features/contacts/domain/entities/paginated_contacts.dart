import 'contact_entity.dart';

class PaginatedContacts {
  final int totalPages;
  final int size;
  final int totalElements;
  final bool hasNext;
  final bool hasPrevious;
  final List<ContactEntity> content;

  PaginatedContacts({
    required this.totalPages,
    required this.size,
    required this.totalElements,
    required this.hasNext,
    required this.hasPrevious,
    required this.content,
  });
}
