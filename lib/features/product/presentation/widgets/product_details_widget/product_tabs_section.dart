import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../model/product_detail_provider.dart';



// ==============================================================================
// PRODUCT TABS BAR
// Description | Additional information | Customer Reviews
//
// This is intentionally NOT a TabBarView - the content underneath scrolls
// together with the rest of the page (per the requirement that description /
// additional info / reviews are "vertically scrollable like a tab"), it just
// swaps which section is shown when a tab is tapped.
// ==============================================================================

class ProductTabsBar extends StatelessWidget {
  final ProductDetailTab activeTab;
  final ValueChanged<ProductDetailTab> onTabSelected;

  const ProductTabsBar({
    super.key,
    required this.activeTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          _tab(context, 'Description', ProductDetailTab.description),
          _tab(
            context,
            'Additional information',
            ProductDetailTab.additionalInfo,
          ),
          _tab(context, 'Customer Reviews', ProductDetailTab.reviews),
        ],
      ),
    );
  }

  Widget _tab(BuildContext context, String label, ProductDetailTab tab) {
    final bool selected = tab == activeTab;

    return Expanded(
      child: InkWell(
        onTap: () => onTabSelected(tab),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: selected ? AppColors.primary : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: selected ? FontWeight.bold : FontWeight.w500,
              color: selected ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
