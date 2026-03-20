import 'package:equatable/equatable.dart';
class AdEntity extends Equatable {
  final String id;
  final String imageUrl;
  final String? targetUrl;
  final String? title;
  const AdEntity({required this.id, required this.imageUrl, this.targetUrl, this.title});
  @override
  List<Object?> get props => [id, imageUrl, targetUrl, title];
}
