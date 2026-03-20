import '../../domain/entities/ad_entity.dart';
class AdModel extends AdEntity {
  const AdModel({required super.id, required super.imageUrl, super.targetUrl, super.title});
  factory AdModel.fromJson(Map<String, dynamic> json) {
    return AdModel(id: json['id'], imageUrl: json['imageUrl'], targetUrl: json['targetUrl'], title: json['title']);
  }
}
