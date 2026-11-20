// import 'package:flutter/material.dart';

// import 'package:lalbaba_online/new_app/constantcolour.dart';

// class NewConstantCheckout extends StatelessWidget {
//   final int currentIndex;

//   const NewConstantCheckout({
//     super.key,
//     required this.currentIndex,
//   }) : assert(currentIndex >= 0 && currentIndex <= 4);

//   // =====================================================
//   // CHECKOUT PAGE INDEX
//   // =====================================================

//   static const int cart = 0;
//   static const int address = 1;
//   static const int delivery = 2;
//   static const int payment = 3;
//   static const int complete = 4;

//   // =====================================================
//   // CHECKOUT COLOURS
//   // =====================================================

//   static const Color completedColor = HomeColors.success;
//   static const Color currentColor = HomeColors.primary;
//   static const Color pendingColor = HomeColors.disabled;
//   static const Color arrowColor = HomeColors.border;

//   // =====================================================
//   // CHECKOUT ICON LIST
//   // =====================================================

//   static const List<IconData> _icons = [
//     Icons.shopping_cart_outlined,
//     Icons.map_outlined,
//     Icons.local_shipping_outlined,
//     Icons.credit_card_outlined,
//     Icons.check_circle_outline,
//   ];

//   // =====================================================
//   // CHECKOUT TITLE LIST
//   // =====================================================

//   static const List<String> _titles = [
//     'Cart',
//     'Shipping Address',
//     'Delivery',
//     'Payment',
//     'Complete',
//   ];

//   // =====================================================
//   // GET STEP COLOUR
//   // =====================================================

//   Color _getStepColor(int index) {
//     // Already completed step = GREEN

//     if (index < currentIndex) {
//       return completedColor;
//     }

//     // Current working step = RED

//     if (index == currentIndex) {
//       return currentColor;
//     }

//     // Pending step = GREY

//     return pendingColor;
//   }

//   // =====================================================
//   // MAIN BUILD
//   // =====================================================

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,

//       padding: const EdgeInsets.symmetric(
//         horizontal: 10,
//         vertical: 13,
//       ),

//       decoration: BoxDecoration(
//         color: HomeColors.surface,

//         borderRadius: BorderRadius.circular(6),

//         border: Border.all(
//           color: HomeColors.border,
//           width: 1,
//         ),

//         boxShadow: [
//           BoxShadow(
//             color: HomeColors.black.withValues(
//               alpha: 0.08,
//             ),
//             blurRadius: 7,
//             offset: const Offset(2, 3),
//           ),
//         ],
//       ),

//       child: Row(
//         children: [
//           for (int index = 0;
//               index < _icons.length;
//               index++) ...[
//             Expanded(
//               child: _buildStep(index),
//             ),

//             if (index < _icons.length - 1)
//               _buildArrow(),
//           ],
//         ],
//       ),
//     );
//   }

//   // =====================================================
//   // SINGLE CHECKOUT ICON
//   // =====================================================

//   Widget _buildStep(int index) {
//     return Semantics(
//       label: _titles[index],
//       selected: index == currentIndex,

//       child: Center(
//         child: Icon(
//           _icons[index],
//           size: 30,
//           color: _getStepColor(index),
//         ),
//       ),
//     );
//   }

//   // =====================================================
//   // ARROW ICON
//   // =====================================================

//   Widget _buildArrow() {
//     return const Padding(
//       padding: EdgeInsets.symmetric(
//         horizontal: 1,
//       ),

//       child: Icon(
//         Icons.chevron_right_rounded,
//         size: 20,
//         color: arrowColor,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'constantcolour.dart';
import 'new_constant_text_styles.dart';

// ============================================================
// CHECKOUT CONSTANT STEPPER
// ============================================================

class NewConstantCheckout extends StatelessWidget {
  final int currentIndex;

  const NewConstantCheckout({super.key, required this.currentIndex})
    : assert(currentIndex >= 0 && currentIndex <= 4);

  static const int cart = 0;
  static const int shipping = 1;
  static const int address = shipping;
  static const int delivery = 2;
  static const int payment = 3;
  static const int complete = 4;

  static const Color completedColor = HomeColors.success;
  static const Color currentColor = HomeColors.primary;
  static const Color pendingColor = HomeColors.disabled;
  static const Color arrowColor = HomeColors.border;

  static const List<IconData> _icons = [
    Icons.shopping_cart_outlined,
    Icons.map_outlined,
    Icons.local_shipping_outlined,
    Icons.credit_card_outlined,
    Icons.check_circle_outline,
  ];

  static const List<String> _titles = [
    'Cart',
    'Shipping Address',
    'Delivery',
    'Payment',
    'Complete',
  ];

  Color _getStepColor(int index) {
    if (index < currentIndex) {
      return completedColor;
    }

    if (index == currentIndex) {
      return currentColor;
    }

    return pendingColor;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
      decoration: BoxDecoration(
        color: HomeColors.surface,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: HomeColors.border),
        boxShadow: [
          BoxShadow(
            color: HomeColors.black.withValues(alpha: 0.08),
            blurRadius: 7,
            offset: const Offset(2, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          for (int index = 0; index < _icons.length; index++) ...[
            Expanded(
              child: Semantics(
                label: _titles[index],
                selected: index == currentIndex,
                child: Center(
                  child: Icon(
                    _icons[index],
                    size: 30,
                    color: _getStepColor(index),
                  ),
                ),
              ),
            ),
            if (index < _icons.length - 1)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 1),
                child: Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: arrowColor,
                ),
              ),
          ],
        ],
      ),
    );
  }
}

// ============================================================
// COMMON CHECKOUT BOTTOM BAR
// ============================================================

class NewCheckoutBottomBar extends StatelessWidget {
  final int currentIndex;
  final VoidCallback? onContinue;
  final VoidCallback? onReturnToShop;
  final double? total;

  const NewCheckoutBottomBar({
    super.key,
    required this.currentIndex,
    required this.onContinue,
    this.onReturnToShop,
    this.total,
  }) : assert(currentIndex >= 0 && currentIndex <= 4);

  static const List<String> _labels = [
    'Continue to Shipping',
    'Continue to Delivery',
    'Continue to Payment',
    'Place Order',
    'Continue Shopping',
  ];

  @override
  Widget build(BuildContext context) {
    final button = SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onContinue,
        style: ElevatedButton.styleFrom(
          backgroundColor: HomeColors.secondary,
          foregroundColor: HomeColors.white,
          disabledBackgroundColor: HomeColors.disabled,
          disabledForegroundColor: HomeColors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                _labels[currentIndex],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: HomeTextStyles.button,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.arrow_forward, size: 18),
          ],
        ),
      ),
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: const BoxDecoration(
        color: HomeColors.surface,
        border: Border(top: BorderSide(color: HomeColors.divider)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (total != null)
              Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total',
                          style: HomeTextStyles.bodySmall.copyWith(
                            color: HomeColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '₹${total!.toStringAsFixed(0)}',
                          style: HomeTextStyles.price.copyWith(
                            color: HomeColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(flex: 2, child: button),
                ],
              )
            else
              button,

            if (onReturnToShop != null) ...[
              const SizedBox(height: 10),
              TextButton.icon(
                onPressed: onReturnToShop,
                icon: const Icon(Icons.arrow_back, size: 18),
                label: const Text('Return to shop'),
                style: TextButton.styleFrom(
                  foregroundColor: HomeColors.textPrimary,
                  textStyle: HomeTextStyles.body.copyWith(
                    fontWeight: HomeTextStyles.medium,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
