abstract class ContactsRemoteDataSource {
  Future<List<Map<String, dynamic>>> getContacts();
  Future<void> addContact({required String email});
  Future<void> removeContact({required String id});
  Future<Map<String, dynamic>?> searchByEmail({required String email});
}
class ContactsRemoteDataSourceImpl implements ContactsRemoteDataSource {
  @override
  Future<List<Map<String, dynamic>>> getContacts() async { throw UnimplementedError(); }
  @override
  Future<void> addContact({required String email}) async { throw UnimplementedError(); }
  @override
  Future<void> removeContact({required String id}) async { throw UnimplementedError(); }
  @override
  Future<Map<String, dynamic>?> searchByEmail({required String email}) async { throw UnimplementedError(); }
}
