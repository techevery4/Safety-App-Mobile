import 'package:flutter/material.dart';
class AdBannerWidget extends StatelessWidget {
  final String? imageUrl;
  final VoidCallback? onTap;
  const AdBannerWidget({super.key, this.imageUrl, this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        width: 200,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: imageUrl != null
            ? ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(imageUrl!, fit: BoxFit.cover))
            : const Center(child: Icon(Icons.image, size: 40, color: Colors.grey)),
      ),
    );
  }
}
