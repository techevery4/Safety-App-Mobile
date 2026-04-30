import '../../domain/entities/ad_entity.dart';

class AdModel extends AdEntity {
  const AdModel({
    required super.id,
    super.campaignName,
    required super.imageUrl,
    super.imagePaths = const [],
    super.startDate,
    super.durationDays,
    super.dailyRate,
    super.totalCost,
    super.status,
    super.targetUrl,
    super.title,
  });

  factory AdModel.fromJson(Map<String, dynamic> json) {
    return AdModel(
      id: json['id'],
      campaignName: json['campaignName'],
      imageUrl: json['imageUrl'] ?? '',
      imagePaths: List<String>.from(json['imagePaths'] ?? []),
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : null,
      durationDays: json['durationDays'],
      dailyRate: (json['dailyRate'] as num?)?.toDouble(),
      totalCost: (json['totalCost'] as num?)?.toDouble(),
      status: json['status'],
      targetUrl: json['targetUrl'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'campaignName': campaignName,
      'imageUrl': imageUrl,
      'imagePaths': imagePaths,
      'startDate': startDate?.toIso8601String(),
      'durationDays': durationDays,
      'dailyRate': dailyRate,
      'totalCost': totalCost,
      'status': status,
      'targetUrl': targetUrl,
      'title': title,
    };
  }
}
