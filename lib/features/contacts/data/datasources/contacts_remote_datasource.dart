import 'package:dio/dio.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/contact_model.dart';
import '../models/paginated_contacts_model.dart';

/// Remote datasource for contacts with real API integration.
class ContactsRemoteDatasource {
  final Dio _dio;

  ContactsRemoteDatasource(this._dio);

  /// Fetches confirmed contacts with pagination.
  Future<PaginatedContactsModel> getConfirmedContacts(
    String userId, {
    required int pageNo,
    required int pageSize,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.confirmedContacts.replaceFirst('{userId}', userId),
      queryParameters: {
        'pageNo': pageNo,
        'pageSize': pageSize,
      },
    );
    return PaginatedContactsModel.fromJson(response.data);
  }

  /// Fetches pending contact requests.
  Future<List<ContactModel>> getPendingContacts(String userId) async {
    final response = await _dio.get(
      ApiEndpoints.pendingContacts.replaceFirst('{userId}', userId),
    );
    return (response.data as List)
        .map((e) => ContactModel.fromJson(e))
        .toList();
  }

  /// Adds a new contact.
  Future<ContactModel> addContact({
    required String userId,
    required String name,
    required String email,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.contacts,
      data: {
        'userId': userId,
        'name': name,
        'email': email,
      },
    );
    return ContactModel.fromJson(response.data);
  }

  /// Responds to a contact request (ACCEPTED or DECLINED).
  Future<ContactModel> respondToContactRequest(
    String requestId,
    String status,
  ) async {
    final response = await _dio.post(
      ApiEndpoints.respondToContact
          .replaceFirst('{requestId}', requestId)
          .replaceFirst('{status}', status),
    );
    return ContactModel.fromJson(response.data);
  }

  /// Removes a contact.
  Future<void> removeContact(String contactId) async {
    await _dio.delete(
      ApiEndpoints.removeContact.replaceFirst('{id}', contactId),
    );
  }
}
