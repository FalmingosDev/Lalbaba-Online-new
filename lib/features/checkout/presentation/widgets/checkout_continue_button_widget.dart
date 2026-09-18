import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';


import '../../../../app/theme/app_sizes.dart';
/// আপনার HomePage-এর actual path দিন
import '../../../home/presentation/pages/home_page.dart';

class CheckoutBottomWidget extends StatelessWidget {
  /// Example:
  /// Continue to Shipping
  /// Continue to Delivery
  /// Continue to Payment
  final String continueButtonText;

  /// Next page navigation
  final VoidCallback onContinue;

  /// Disables the button while the page is loading / submitting
  final bool isEnabled;

  const CheckoutBottomWidget({
    super.key,
    required this.continueButtonText,
    required this.onContinue,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        AppSizes.screenPadding,
        AppSizes.spacingLarge,
        AppSizes.screenPadding,
        AppSizes.spacingXLarge - 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.divider, width: 1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// CONTINUE BUTTON
          SizedBox(
            height: AppSizes.buttonHeight,
            child: ElevatedButton(
              onPressed: isEnabled ? onContinue : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: AppColors.disabled,
                foregroundColor: AppColors.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.buttonHorizontalPadding,
                  vertical: AppSizes.spacingMedium,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                ),
              ),
              child: Text(
                continueButtonText,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ),

          SizedBox(height: AppSizes.spacingMedium - 2),

          /// RETURN TO SHOP
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _goToHomePage(context),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.spacingMedium,
                vertical: AppSizes.spacingXXSmall + 2,
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_back, size: 18, color: AppColors.textPrimary),
                  SizedBox(width: 5),
                  Text(
                    'Return to shop',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Checkout-এর সমস্ত previous route remove করে
  /// সরাসরি HomePage open করবে.
  void _goToHomePage(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => const HomePage()),

      /// Previous route সব remove
      (Route<dynamic> route) => false,
    );
  }
}
