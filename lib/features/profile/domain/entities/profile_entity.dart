import 'package:equatable/equatable.dart';
class ProfileEntity extends Equatable {
  final String id;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? profilePhotoUrl;
  const ProfileEntity({required this.id, required this.email, this.firstName, this.lastName, this.profilePhotoUrl});
  @override
  List<Object?> get props => [id, email, firstName, lastName, profilePhotoUrl];
}
