import 'package:equatable/equatable.dart';
class ProfileEntity extends Equatable {
  final String id;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? profilePictureUrl;
  const ProfileEntity({required this.id, required this.email, this.firstName, this.lastName, this.profilePictureUrl});
  @override
  List<Object?> get props => [id, email, firstName, lastName, profilePictureUrl];
}
