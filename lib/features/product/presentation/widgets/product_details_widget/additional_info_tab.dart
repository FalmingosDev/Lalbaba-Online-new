import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../model/product_models.dart';



// ==============================================================================
// ADDITIONAL INFORMATION TAB
// "Product Specifications:" table, matching the screenshot's two-column
// label/value layout.
// ==============================================================================

class AdditionalInfoTab extends StatelessWidget {
  final List<ProductSpecification> specifications;

  const AdditionalInfoTab({super.key, required this.specifications});

  @override
  Widget build(BuildContext context) {
    if (specifications.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(14),
        child: Text('No additional information available.'),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Product Specifications:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          Table(
            border: TableBorder.all(color: AppColors.divider),
            columnWidths: const {
              0: FractionColumnWidth(0.32),
              1: FractionColumnWidth(0.68),
            },
            children: specifications.map((spec) {
              return TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      spec.label,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      spec.value,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
