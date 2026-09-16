import 'package:flutter/material.dart';

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

  const CheckoutBottomWidget({
    super.key,
    required this.continueButtonText,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.fromLTRB(
        16,
        16,
        16,
        18,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        border: Border(
          top: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,

        children: [
          /// ========================================================
          /// CONTINUE BUTTON
          /// ========================================================
          SizedBox(
            height: 48,

            child: ElevatedButton(
              onPressed: onContinue,

              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(
                  0xFFFF0000,
                ),

                foregroundColor:
                    Colors.white,

                elevation: 0,

                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),

                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    6,
                  ),
                ),
              ),

              child: Text(
                continueButtonText,

                style:
                    const TextStyle(
                  fontSize: 15,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          /// ========================================================
          /// RETURN TO SHOP
          /// ========================================================
          GestureDetector(
            behavior:
                HitTestBehavior.opaque,

            onTap: () {
              _goToHomePage(
                context,
              );
            },

            child: const Padding(
              padding:
                  EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),

              child: Row(
                mainAxisSize:
                    MainAxisSize.min,

                mainAxisAlignment:
                    MainAxisAlignment.center,

                children: [
                  Icon(
                    Icons.arrow_back,
                    size: 18,
                    color:
                        Color(
                      0xFF333333,
                    ),
                  ),

                  SizedBox(
                    width: 5,
                  ),

                  Text(
                    'Return to shop',

                    style:
                        TextStyle(
                      fontSize: 14,

                      fontWeight:
                          FontWeight.w500,

                      color:
                          Color(
                        0xFF333333,
                      ),
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

  /// ========================================================================
  /// GO TO HOME PAGE
  /// ========================================================================
  ///
  /// Checkout-এর সমস্ত previous route remove করে
  /// সরাসরি HomePage open করবে.
  ///
  void _goToHomePage(
    BuildContext context,
  ) {
    Navigator.pushAndRemoveUntil(
      context,

      MaterialPageRoute(
        builder: (
          BuildContext context,
        ) {
          return const HomePage();
        },
      ),

      /// Previous route সব remove
      (Route<dynamic> route) =>
          false,
    );
  }
}