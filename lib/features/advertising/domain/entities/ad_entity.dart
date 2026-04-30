import 'package:equatable/equatable.dart';

/// Represents an advertisement or campaign.
class AdEntity extends Equatable {
  final String id;
  final String? campaignName;
  final String imageUrl; // For backward compatibility / single image
  final List<String> imagePaths; // For multiple images
  final DateTime? startDate;
  final int? durationDays;
  final double? dailyRate;
  final double? totalCost;
  final String? status; // pending, active, expired
  final String? targetUrl;
  final String? title;

  const AdEntity({
    required this.id,
    this.campaignName,
    required this.imageUrl,
    this.imagePaths = const [],
    this.startDate,
    this.durationDays,
    this.dailyRate,
    this.totalCost,
    this.status,
    this.targetUrl,
    this.title,
  });

  @override
  List<Object?> get props => [
        id,
        campaignName,
        imageUrl,
        imagePaths,
        startDate,
        durationDays,
        dailyRate,
        totalCost,
        status,
        targetUrl,
        title,
      ];
}
