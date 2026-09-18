import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_text_styles.dart';
import '../../../../app/theme/app_sizes.dart';


/// Cancel / Send Ticket action buttons.
///
/// Kept as a standalone widget (separate from [CreateTicketForm]) so the
/// form layout and its actions can be styled or reused independently.
class TicketFormActions extends StatelessWidget {
  const TicketFormActions({
    super.key,
    required this.onCancel,
    required this.onSubmit,
    this.isSubmitting = false,
  });

  final VoidCallback onCancel;
  final VoidCallback onSubmit;
  final bool isSubmitting;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: isSubmitting ? null : onCancel,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.textSecondary,
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.buttonHorizontalPadding,
              vertical: AppSizes.spacingMedium,
            ),
          ),
          child: const Text('Cancel'),
        ),
        SizedBox(width: AppSizes.spacingSmall),
        ElevatedButton(
          onPressed: isSubmitting ? null : onSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
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
          child: isSubmitting
              ? SizedBox(
                  width: AppSizes.iconSmall,
                  height: AppSizes.iconSmall,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.white,
                    ),
                  ),
                )
              : Text('Send Ticket', style: AppTextStyles.button),
        ),
      ],
    );
  }
}
