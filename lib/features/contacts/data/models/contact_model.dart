import '../../domain/entities/contact_entity.dart';
class ContactModel extends ContactEntity {
  const ContactModel({required super.id, required super.email, super.name, super.profilePhotoUrl});
  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(id: json['id'], email: json['email'], name: json['name'], profilePhotoUrl: json['profilePhotoUrl']);
  }
}
