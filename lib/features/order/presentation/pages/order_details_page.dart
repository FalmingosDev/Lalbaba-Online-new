
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../core/widgets/app_app_bar.dart';

import '../../../account/presentation/widgets/languange_constant.dart';

import '../../model/order_provider.dart';

import '../widgets/order_details_widget/delivery_address_card.dart';
import '../widgets/order_details_widget/order_detail_summary_card.dart';
import '../widgets/order_details_widget/order_price_breakup_card.dart';
import '../widgets/order_details_widget/order_track_banner.dart';

import '../widgets/order_page_widget/order_shimmer.dart';


class OrderDetailsPage extends ConsumerStatefulWidget {
  const OrderDetailsPage({super.key, required this.orderId});

  final String orderId;

  @override
  ConsumerState<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends ConsumerState<OrderDetailsPage> {
  bool _minLoadingElapsed = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) setState(() => _minLoadingElapsed = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppLanguageConstants.instance,
      builder: (context, child) {
        final order = ref.watch(orderDetailsProvider(widget.orderId));
        final isLoading = !_minLoadingElapsed || order == null;

        return Scaffold(
          backgroundColor: AppColors.background,

          appBar: const AppAppBar(
            title: 'Order Details',
            automaticallyImplyLeading: true,
          ),

          body: isLoading
              ? const OrderListShimmer()
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      OrderDetailSummaryCard(order: order),
                      SizedBox(height: AppSizes.spacingSmall),
                      OrderTrackBanner(order: order),
                      SizedBox(height: AppSizes.spacingSmall),
                      DeliveryAddressCard(order: order),
                      SizedBox(height: AppSizes.spacingSmall),
                      OrderPriceBreakupCard(order: order),
                      SizedBox(height: AppSizes.spacingXLarge),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
