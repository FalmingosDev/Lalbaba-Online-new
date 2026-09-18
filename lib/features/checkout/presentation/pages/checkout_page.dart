import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';

import '../../../../app/theme/app_sizes.dart';
import '../../../../core/widgets/app_app_bar.dart';
import '../../../account/presentation/widgets/app_string.dart';
import '../widgets/checkout_constant_widget.dart';
import '../widgets/checkout_continue_button_widget.dart';
import '../widgets/checkout_product_page.dart';


/// ============================================================================
/// CHECKOUT PAGE PROVIDER
/// ============================================================================
///
/// Simulates fetching whatever the checkout page needs before it can render
/// the real content (cart summary, saved address, etc). Swap the body of
/// this provider for a real repository/API call whenever it's ready -
/// the page below already reacts to loading / data / error states.
///
final checkoutInitProvider = FutureProvider.autoDispose<bool>((ref) async {
  await Future.delayed(const Duration(milliseconds: 900));
  return true;
});

/// ============================================================================
/// CHECKOUT PAGE
/// ============================================================================
class CheckoutPage extends ConsumerStatefulWidget {
  const CheckoutPage({super.key});

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> {
  /// Tracks whether "Continue" has been tapped, to avoid double navigation
  /// while we're busy (e.g. validating the cart) before moving on.
  bool _isContinuing = false;

  @override
  Widget build(BuildContext context) {
    final AsyncValue<bool> checkoutInit = ref.watch(checkoutInitProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(
        title: AppStrings.checkout,
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            /// ================================================================
            /// SCROLLABLE CONTENT
            /// ================================================================
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppSizes.screenPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// STEP TRACKER - user is on the Cart step here
                    const CheckoutConstantWidget(
                      currentStep: CheckoutStep.cart,
                    ),

                    SizedBox(height: AppSizes.spacingXLarge),

                    /// ORDER SUMMARY / SHIMMER WHILE LOADING
                    checkoutInit.when(
                      data: (_) => const CheckoutProductWidget(),
                      loading: () => const CheckoutProductShimmer(),
                      error: (Object error, StackTrace stackTrace) =>
                          _CheckoutErrorState(
                        onRetry: () => ref.invalidate(checkoutInitProvider),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// ================================================================
            /// CONTINUE / RETURN TO SHOP
            /// ================================================================
            CheckoutBottomWidget(
              continueButtonText: 'Continue to Shipping',
              isEnabled: checkoutInit.hasValue && !_isContinuing,
              onContinue: () => _onContinuePressed(context),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onContinuePressed(BuildContext context) async {
    setState(() => _isContinuing = true);

    // TODO: replace with real validation / navigation to the Address step.
    await Future.delayed(const Duration(milliseconds: 300));

    if (!context.mounted) return;

    setState(() => _isContinuing = false);

    // Navigator.push(context, MaterialPageRoute(builder: (_) => const CheckoutAddressPage()));
  }
}

/// ============================================================================
/// ERROR STATE
/// ============================================================================
class _CheckoutErrorState extends StatelessWidget {
  final VoidCallback onRetry;

  const _CheckoutErrorState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.spacingXLarge),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusXLarge),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const Icon(Icons.error_outline, size: 40, color: AppColors.error),
          SizedBox(height: AppSizes.spacingMedium),
          const Text(
            'Something went wrong while loading your cart.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          SizedBox(height: AppSizes.spacingMedium),
          TextButton(
            onPressed: onRetry,
            child: const Text('Retry', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}
