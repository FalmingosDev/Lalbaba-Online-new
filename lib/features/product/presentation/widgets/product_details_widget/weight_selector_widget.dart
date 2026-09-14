import 'package:flutter/material.dart';
import 'package:lalbaba_online/features/product/presentation/model/product_models.dart';

import '../../../../../app/theme/app_colors.dart';


// ==============================================================================
// WEIGHT SELECTOR
// Price range line + tappable weight chips (matches the screenshot's
// "5 Kg" / "10 Kg" boxes, with the selected chip outlined in red).
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
    final double lowest =
        variants.map((v) => v.price).reduce((a, b) => a < b ? a : b);
    final double highest =
        variants.map((v) => v.price).reduce((a, b) => a > b ? a : b);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            lowest == highest
                ? 'Price: ₹${lowest.toStringAsFixed(2)} /Bag'
                : 'Price: ₹${lowest.toStringAsFixed(2)} - ₹${highest.toStringAsFixed(2)} /Bag',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
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
              final bool selected = index == selectedIndex;

              return GestureDetector(
                onTap: () => onSelected(index),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: selected ? AppColors.primary : AppColors.border,
                      width: selected ? 1.5 : 1,
                    ),
                    borderRadius: BorderRadius.circular(6),
                    color: selected
                        ? AppColors.primaryLight
                        : AppColors.surface,
                  ),
                  child: Text(
                    variant.weight,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: selected
                          ? AppColors.primary
                          : AppColors.textPrimary,
                    ),
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
