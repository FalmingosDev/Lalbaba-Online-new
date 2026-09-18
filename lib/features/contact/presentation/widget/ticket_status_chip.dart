import 'package:flutter/material.dart';

import '../../../../../core/constants/app_sizes.dart';

import 'support_ticket.dart';

/// Small colored pill showing a ticket's status (e.g. "Pending").
class TicketStatusChip extends StatelessWidget {
  const TicketStatusChip({super.key, required this.status});

  final TicketStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.spacingMedium_12,
        vertical: AppSizes.spacingXSmall_4,
      ),
      decoration: BoxDecoration(
        color: status.color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(AppSizes.radiusXLarge_16),
        border: Border.all(color: status.color.withOpacity(0.4)),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          color: status.color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
