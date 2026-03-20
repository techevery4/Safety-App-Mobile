import 'package:equatable/equatable.dart';
class ContactEntity extends Equatable {
  final String id;
  final String email;
  final String? name;
  final String? profilePhotoUrl;
  const ContactEntity({required this.id, required this.email, this.name, this.profilePhotoUrl});
  @override
  List<Object?> get props => [id, email, name, profilePhotoUrl];
}
