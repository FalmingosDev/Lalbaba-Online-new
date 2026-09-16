

import 'package:flutter/material.dart';

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

class CheckoutConstantPage extends StatelessWidget {
  const CheckoutConstantPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: true,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),

        title: const Text(
          'Checkout',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: const SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              /// ==============================================================
              /// CHECKOUT COMMON WIDGET
              /// ==============================================================
              CheckoutConstantWidget(
                currentStep:
                    CheckoutStep.address,
              ),

              SizedBox(
                height: 30,
              ),

              Text(
                'Shipping Address',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight:
                      FontWeight.w700,
                ),
              ),

              SizedBox(
                height: 8,
              ),

              Text(
                'Checkout testing page',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CheckoutConstantWidget
    extends StatelessWidget {
  final CheckoutStep currentStep;

  const CheckoutConstantWidget({
    super.key,
    required this.currentStep,
  });

  /// Completed page
  static const Color completedColor =
      Color(0xFF00C389);

  /// Current page
  static const Color currentColor =
      Color(0xFF171722);

  /// Future page
  static const Color pendingColor =
      Color(0xFFB9B9BD);

  /// Arrow
  static const Color arrowColor =
      Color(0xFFE1E1E1);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,

      child: Container(
        width: double.infinity,

        padding:
            const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 13,
        ),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius:
              BorderRadius.circular(
            8,
          ),

          border: Border.all(
            color:
                const Color(
              0xFFC5C5C5,
            ),
            width: 1,
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withValues(
                alpha: 0.08,
              ),
              blurRadius: 7,
              offset:
                  const Offset(
                2,
                3,
              ),
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
                step:
                    CheckoutStep.cart,
                icon: Icons
                    .shopping_cart_outlined,
              ),
            ),

            _buildArrow(),

            /// ================================================================
            /// ADDRESS
            /// ================================================================
            Expanded(
              child: _buildStep(
                step:
                    CheckoutStep.address,
                icon:
                    Icons.map_outlined,
              ),
            ),

            _buildArrow(),

            /// ================================================================
            /// DELIVERY
            /// ================================================================
            Expanded(
              child: _buildStep(
                step:
                    CheckoutStep.delivery,
                icon: Icons
                    .local_shipping_outlined,
              ),
            ),

            _buildArrow(),

            /// ================================================================
            /// PAYMENT
            /// ================================================================
            Expanded(
              child: _buildStep(
                step:
                    CheckoutStep.payment,
                icon: Icons
                    .credit_card_outlined,
              ),
            ),

            _buildArrow(),

            /// ================================================================
            /// COMPLETE
            /// ================================================================
            Expanded(
              child: _buildStep(
                step:
                    CheckoutStep.complete,
                icon: Icons
                    .check_circle_outline,
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
        color:
            _getStepColor(
          step,
        ),
      ),
    );
  }

  /// ==========================================================================
  /// ARROW
  /// ==========================================================================
  Widget _buildArrow() {
    return const Padding(
      padding:
          EdgeInsets.symmetric(
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
    final int currentStepIndex =
        currentStep.index;

    final int thisStepIndex =
        step.index;

    /// ------------------------------------------------------------------------
    /// STEP ALREADY COMPLETED
    /// ------------------------------------------------------------------------
    ///
    /// Current step-এর আগের সমস্ত step GREEN হবে.
    ///
    if (thisStepIndex <
        currentStepIndex) {
      return completedColor;
    }

    /// ------------------------------------------------------------------------
    /// CURRENT PAGE
    /// ------------------------------------------------------------------------
    ///
    /// যে page-এ user বর্তমানে আছে সেটা BLACK হবে.
    ///
    if (thisStepIndex ==
        currentStepIndex) {
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