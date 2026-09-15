import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../model/product_models.dart';



// ==============================================================================
// WEIGHT SELECTOR
// ------------------------------------------------------------------------------
// Shows the CURRENT variant's price prominently at the top (this is bound to
// `selectedIndex`, so as soon as a different weight chip is tapped, this
// price updates immediately - it is never a static/hardcoded string), plus
// tappable weight chips that each show their own price underneath so the
// full price list is visible at a glance too.
// ==============================================================================

class WeightSelectorWidget extends StatelessWidget {
  final List<ProductVariant> variants;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const WeightSelectorWidget({
    super.key,
    required this.variants,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final ProductVariant selected = variants[selectedIndex];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // -----------------------------------------------------------------
          // CURRENT PRICE - always reflects whichever weight chip is
          // selected below. Tap a different chip and this updates instantly,
          // because it's built straight from `selectedIndex`.
          // -----------------------------------------------------------------
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '₹${selected.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '/ ${selected.weight} Bag',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          const Text(
            'Weight:',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),

          const SizedBox(height: 8),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List.generate(variants.length, (index) {
              final ProductVariant variant = variants[index];
              final bool isSelected = index == selectedIndex;

              return GestureDetector(
                onTap: () => onSelected(index),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                      width: isSelected ? 1.5 : 1,
                    ),
                    borderRadius: BorderRadius.circular(6),
                    color: isSelected
                        ? AppColors.primaryLight
                        : AppColors.surface,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        variant.weight,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '₹${variant.price.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 11,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
