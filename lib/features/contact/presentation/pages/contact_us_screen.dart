import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../new_app/constant/constantappbar.dart';
import '../../../../new_app/constant/constantcolour.dart';
import '../../../account/presentation/widgets/app_string.dart';
import 'create_ticket_form.dart';
import 'ticket_list_view.dart';

/// Contact Us / Support Ticket page.
///
/// - "Create a Ticket" button sits bottom right (FAB) and opens
///   [CreateTicketForm] in a modal bottom sheet.
/// - Submitted tickets are listed below in [TicketListView], showing
///   Subject and Status. New tickets show as "Pending" until the real
///   API drives their status.
/// - No bottom navigation — this is a standalone page.
class ContactUsScreen extends ConsumerWidget {
  const ContactUsScreen({super.key});

  void _openCreateTicketSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: HomeColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.dialogRadius_16),
        ),
      ),
      builder: (_) => const CreateTicketForm(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: HomeColors.background,
      appBar: CommonAppBar(
        title: AppStrings.contactUs,
        automaticallyImplyLeading: true,
        showBackButton: true,
        backgroundColor: HomeColors.secondary,
        titleColor: HomeColors.white,
        iconColor: HomeColors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openCreateTicketSheet(context),
        backgroundColor: HomeColors.secondary,
        foregroundColor: HomeColors.white,
        icon: const Icon(Icons.add),
        label: const Text('Create a Ticket'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSizes.screenPadding_16),
          child: const TicketListView(),
        ),
      ),
    );
  }
}
