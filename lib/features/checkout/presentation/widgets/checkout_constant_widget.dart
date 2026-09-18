import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';


/// ============================================================================
/// CHECKOUT STEP
/// ============================================================================
///
/// Order:
/// 0 = Cart
/// 1 = Address
/// 2 = Delivery
/// 3 = Payment
/// 4 = Complete
///
enum CheckoutStep {
  cart,
  address,
  delivery,
  payment,
  complete,
}

/// ============================================================================
/// TEST / PREVIEW PAGE FOR THE STEPPER
/// ============================================================================
class CheckoutConstantPage extends StatelessWidget {
  const CheckoutConstantPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,

      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,  
            color: AppColors.black,
          ),
        ),

        title: const Text(
          'Checkout',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSizes.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ==============================================================
              /// CHECKOUT COMMON WIDGET
              /// ==============================================================
              const CheckoutConstantWidget(
                currentStep: CheckoutStep.address,
              ),

              SizedBox(height: AppSizes.spacingSection - 2),

              const Text(
                'Shipping Address',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),

              SizedBox(height: AppSizes.spacingSmall),

              const Text(
                'Checkout testing page',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ============================================================================
/// CHECKOUT CONSTANT WIDGET (stepper)
/// ============================================================================
class CheckoutConstantWidget extends StatelessWidget {
  final CheckoutStep currentStep;

  const CheckoutConstantWidget({
    super.key,
    required this.currentStep,
  });

  /// Completed page
  static const Color completedColor = AppColors.success;

  /// Current page
  static const Color currentColor = AppColors.primary;

  /// Future page
  static const Color pendingColor = AppColors.disabled;

  /// Arrow
  static const Color arrowColor = AppColors.border;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,

      child: Container(
        width: double.infinity,

        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.spacingSmall + 2,
          vertical: AppSizes.spacingMedium + 1,
        ),

        decoration: BoxDecoration(
          color: AppColors.surface,

          borderRadius: BorderRadius.circular(AppSizes.radiusSmall + 2),

          border: Border.all(
            color: AppColors.border,
            width: 1,
          ),

          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.08),
              blurRadius: 7,
              offset: const Offset(2, 3),
            ),
          ],
        ),

        child: Row(
          children: [
            /// ================================================================
            /// CART
            /// ================================================================
            Expanded(
              child: _buildStep(
                step: CheckoutStep.cart,
                icon: Icons.shopping_cart_outlined,
              ),
            ),

            _buildArrow(),

            /// ================================================================
            /// ADDRESS
            /// ================================================================
            Expanded(
              child: _buildStep(
                step: CheckoutStep.address,
                icon: Icons.map_outlined,
              ),
            ),

            _buildArrow(),

            /// ================================================================
            /// DELIVERY
            /// ================================================================
            Expanded(
              child: _buildStep(
                step: CheckoutStep.delivery,
                icon: Icons.local_shipping_outlined,
              ),
            ),

            _buildArrow(),

            /// ================================================================
            /// PAYMENT
            /// ================================================================
            Expanded(
              child: _buildStep(
                step: CheckoutStep.payment,
                icon: Icons.credit_card_outlined,
              ),
            ),

            _buildArrow(),

            /// ================================================================
            /// COMPLETE
            /// ================================================================
            Expanded(
              child: _buildStep(
                step: CheckoutStep.complete,
                icon: Icons.check_circle_outline,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ==========================================================================
  /// SINGLE STEP
  /// ==========================================================================
  Widget _buildStep({
    required CheckoutStep step,
    required IconData icon,
  }) {
    return Center(
      child: Icon(
        icon,

        size: 35,

        /// Automatically:
        ///
        /// completed -> green
        /// current   -> black
        /// future    -> grey
        color: _getStepColor(step),
      ),
    );
  }

  /// ==========================================================================
  /// ARROW
  /// ==========================================================================
  Widget _buildArrow() {
    return const Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 1,
      ),
      child: Icon(
        Icons.chevron_right,
        size: 27,
        color: arrowColor,
      ),
    );
  }

  /// ==========================================================================
  /// MAIN COLOR FUNCTION
  /// ==========================================================================
  ///
  /// এই function-টাই পুরো logic control করছে.
  ///
  Color _getStepColor(
    CheckoutStep step,
  ) {
    final int currentStepIndex = currentStep.index;

    final int thisStepIndex = step.index;

    /// ------------------------------------------------------------------------
    /// STEP ALREADY COMPLETED
    /// ------------------------------------------------------------------------
    ///
    /// Current step-এর আগের সমস্ত step GREEN হবে.
    ///
    if (thisStepIndex < currentStepIndex) {
      return completedColor;
    }

    /// ------------------------------------------------------------------------
    /// CURRENT PAGE
    /// ------------------------------------------------------------------------
    ///
    /// যে page-এ user বর্তমানে আছে সেটা BLACK হবে.
    ///
    if (thisStepIndex == currentStepIndex) {
      return currentColor;
    }

    /// ------------------------------------------------------------------------
    /// FUTURE / NOT COMPLETED
    /// ------------------------------------------------------------------------
    ///
    /// Current page-এর পরের সমস্ত step GREY থাকবে.
    ///
    return pendingColor;
  }
}