import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../model/product_models.dart';



// ==============================================================================
// CUSTOMER REVIEWS TAB
// ==============================================================================

class CustomerReviewsTab extends StatelessWidget {
  final List<ProductReview> reviews;

  const CustomerReviewsTab({super.key, required this.reviews});

  @override
  Widget build(BuildContext context) {
    if (reviews.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(14),
        child: Text('No reviews yet. Be the first to review this product.'),
      );
    }

    return Column(
      children:
          reviews.map((review) => _ReviewTile(review: review)).toList(),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  final ProductReview review;

  const _ReviewTile({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.disabledBackground,
            child: Icon(Icons.image, color: AppColors.grey),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      review.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < review.rating.round()
                              ? Icons.star
                              : Icons.star_border,
                          size: 15,
                          color: Colors.orange,
                        );
                      }),
                    ),
                  ],
                ),

                const SizedBox(height: 2),

                Text(
                  review.date,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 6),

                Text(review.comment, style: const TextStyle(fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
