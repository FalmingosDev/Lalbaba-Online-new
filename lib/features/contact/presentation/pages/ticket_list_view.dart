import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_text_styles.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/widgets/app_shimmer.dart';

import '../../model/ticket_providers.dart';
import '../widget/support_ticket.dart';
import '../widget/ticket_status_chip.dart';

/// Shows the "Subject / Status" table of submitted tickets.
///
/// Handles loading (shimmer), error (retry) and empty ("Nothing found")
/// states, mirroring the existing web Support Ticket page.
class TicketListView extends ConsumerWidget {
  const TicketListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ticketsAsync = ref.watch(ticketListProvider);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge_12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(AppSizes.cardPadding_12),
            child: Text('Tickets', style: AppTextStyles.headingSmall),
          ),
          const Divider(height: 1, color: AppColors.divider),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.cardPadding_12,
              vertical: AppSizes.spacingSmall_8,
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Subject',
                    style: AppTextStyles.label.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Status',
                    style: AppTextStyles.label.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),
          ticketsAsync.when(
            data: (tickets) => _TicketRows(tickets: tickets),
            loading: () => Padding(
              padding: EdgeInsets.all(AppSizes.cardPadding_12),
              child: Column(
                children: List.generate(
                  3,
                  (index) => Padding(
                    padding: EdgeInsets.only(bottom: AppSizes.spacingSmall_8),
                    child: AppShimmer(height: AppSizes.buttonHeightSmall_40),
                  ),
                ),
              ),
            ),
            error: (error, stackTrace) => _TicketError(
              onRetry: () => ref.read(ticketListProvider.notifier).refresh(),
            ),
          ),
        ],
      ),
    );
  }
}

class _TicketRows extends StatelessWidget {
  const _TicketRows({required this.tickets});

  final List<SupportTicket> tickets;

  @override
  Widget build(BuildContext context) {
    if (tickets.isEmpty) {
      return const _TicketEmptyState();
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: AppSizes.spacingSmall_8),
      itemCount: tickets.length,
      separatorBuilder: (_, __) =>
          const Divider(height: 1, color: AppColors.divider),
      itemBuilder: (context, index) {
        final ticket = tickets[index];
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.cardPadding_12,
            vertical: AppSizes.spacingSmall_8,
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  ticket.subject,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TicketStatusChip(status: ticket.status),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TicketEmptyState extends StatelessWidget {
  const _TicketEmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSizes.spacingXXLarge_24),
      child: Column(
        children: [
          Icon(
            Icons.sentiment_dissatisfied_outlined,
            size: AppSizes.iconXLarge_32,
            color: AppColors.textHint,
          ),
          SizedBox(height: AppSizes.spacingSmall_8),
          Text(
            'Nothing found',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _TicketError extends StatelessWidget {
  const _TicketError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSizes.spacingXXLarge_24),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            size: AppSizes.iconXLarge_32,
            color: AppColors.error,
          ),
          SizedBox(height: AppSizes.spacingSmall_8),
          Text('Could not load tickets', style: AppTextStyles.bodyMedium),
          SizedBox(height: AppSizes.spacingSmall_8),
          TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
