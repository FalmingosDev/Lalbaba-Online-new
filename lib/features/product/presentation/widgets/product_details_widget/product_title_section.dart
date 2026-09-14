import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';



// ==============================================================================
// PRODUCT TITLE SECTION
// "Processed At: ..." + product name + tagline + star rating
// ==============================================================================

class ProductTitleSection extends StatelessWidget {
  final String name;
  final String processedAt;
  final String tagline;
  final double rating;
  final int reviewCount;

  const ProductTitleSection({
    super.key,
    required this.name,
    required this.processedAt,
    required this.tagline,
    required this.rating,
    required this.reviewCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (processedAt.isNotEmpty)
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'Processed At: ',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  TextSpan(
                    text: processedAt,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 6),

          Text(
            name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),

          if (tagline.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              tagline,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ],

          const SizedBox(height: 6),

          Row(
            children: [
              ...List.generate(5, (index) {
                if (rating >= index + 1) {
                  return const Icon(Icons.star, size: 16, color: Colors.orange);
                }
                if (rating >= index + 0.5) {
                  return const Icon(
                    Icons.star_half,
                    size: 16,
                    color: Colors.orange,
                  );
                }
                return const Icon(
                  Icons.star_border,
                  size: 16,
                  color: Colors.orange,
                );
              }),
              const SizedBox(width: 6),
              Text(
                '($reviewCount reviews)',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
