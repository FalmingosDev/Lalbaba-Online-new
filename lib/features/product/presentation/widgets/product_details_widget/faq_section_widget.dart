import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../model/product_models.dart';



// ==============================================================================
// FAQ SECTION
// "Frequently Asked Questions" accordion - only one item open at a time.
// Open item gets a light-red background + a red circular "x" close button.
// Closed items show a small pink circular "+" button.
// ==============================================================================

class FaqSectionWidget extends StatelessWidget {
  final List<ProductFaq> faqs;
  final int? expandedIndex;
  final ValueChanged<int> onToggle;

  const FaqSectionWidget({
    super.key,
    required this.faqs,
    required this.expandedIndex,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    if (faqs.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.fromLTRB(14, 18, 14, 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Frequently Asked Questions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: 4),

          const Text(
            'Find answers to the most common questions about this product.',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),

          const SizedBox(height: 14),

          ...List.generate(faqs.length, (index) {
            final ProductFaq faq = faqs[index];
            final bool expanded = expandedIndex == index;

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: expanded ? AppColors.primaryLight : AppColors.surface,
                border: Border.all(
                  color: expanded ? AppColors.primaryLight : AppColors.divider,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  InkWell(
                    onTap: () => onToggle(index),
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              '${index + 1}) ${faq.question}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: expanded
                                    ? AppColors.primary
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          CircleAvatar(
                            radius: 13,
                            backgroundColor: expanded
                                ? AppColors.primary
                                : AppColors.primaryLight,
                            child: Icon(
                              expanded ? Icons.close : Icons.arrow_drop_down,
                              size: 15,
                              color:
                                  expanded ? Colors.white : AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (expanded)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          faq.answer,
                          style: const TextStyle(
                            fontSize: 13,
                            height: 1.5,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
