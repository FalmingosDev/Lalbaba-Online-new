import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';


// ==============================================================================
// DELIVERY PINCODE WIDGET
// Pincode text field + Apply action + serviceability message +
// "Fulfilled by Lalbaba" line.
// ==============================================================================

class DeliveryPincodeWidget extends StatelessWidget {
  final String pincode;
  final bool isChecking;
  final String? message;
  final bool isServiceable;
  final ValueChanged<String> onChanged;
  final VoidCallback onApply;

  const DeliveryPincodeWidget({
    super.key,
    required this.pincode,
    required this.isChecking,
    required this.message,
    required this.isServiceable,
    required this.onChanged,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Delivery',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),

          const SizedBox(height: 8),

          Container(
            height: 46,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    onChanged: onChanged,
                    decoration: const InputDecoration(
                      counterText: '',
                      border: InputBorder.none,
                      hintText: 'Enter a Pincode',
                      hintStyle: TextStyle(color: AppColors.textHint),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: isChecking ? null : onApply,
                  child: isChecking
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(
                          'Apply',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ],
            ),
          ),

          if (message != null) ...[
            const SizedBox(height: 6),
            Text(
              message!,
              style: TextStyle(
                fontSize: 12,
                color: isServiceable ? AppColors.success : AppColors.error,
              ),
            ),
          ],

          const SizedBox(height: 10),

          const Text(
            'Fulfilled by Lalbaba',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
