import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lalbaba_online/features/order/model/order_model.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../core/widgets/app_app_bar.dart';
import '../../../account/presentation/widgets/app_string.dart';
import '../../../account/presentation/widgets/languange_constant.dart';
import '../../model/order_provider.dart';
import '../widgets/order_page_widget/order_card.dart';
import '../widgets/order_page_widget/order_shimmer.dart';
import 'order_details_page.dart';




class MyOrdersPage extends ConsumerStatefulWidget {
  const MyOrdersPage({super.key});

  @override
  ConsumerState<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends ConsumerState<MyOrdersPage> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppLanguageConstants.instance,
      builder: (context, child) {
        final ordersAsync = ref.watch(ordersProvider);

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppAppBar(
            title: AppStrings.myOrders,
            automaticallyImplyLeading: false,
            ),
          body: ordersAsync.when(
            loading: () => const OrderListShimmer(),
            error: (error, stackTrace) {
              return _ErrorState(
                onRetry: _refreshOrders,
              );
            },
            data: (orders) {
              if (orders.isEmpty) {
                return const _EmptyState();
              }

              return RefreshIndicator(
                onRefresh: _refreshOrders,
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(
                    AppSizes.spacingMedium,
                  ),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];

                    return OrderCard(
                      order: order,
                      onCancel: () {
                        _confirmCancel(order);
                      },
                      onView: () {
                        _viewOrder(order);
                      },
                      onItemTap: (item) {
                        _viewItem(item);
                      },
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _refreshOrders() async {
    await ref
        .read(ordersProvider.notifier)
        .loadOrders();
  }

  void _confirmCancel(OrderModel order) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Cancel Order'),
          content: Text(
            'Cancel order ${order.orderId}?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(dialogContext);

                await ref
                    .read(ordersProvider.notifier)
                    .cancelOrder(order.orderId);

                await _refreshOrders();
              },
              child: Text(
                'Yes, Cancel',
                style: TextStyle(
                  color: AppColors.error,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _viewOrder(OrderModel order) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OrderDetailsPage(
          orderId: order.orderId,
        ),
      ),
    );
  }

  void _viewItem(OrderItemModel item) {
    // TODO: Navigate to product details page.
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'No orders yet',
        style: TextStyle(
          fontSize: 14.sp,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.onRetry,
  });

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Something went wrong',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(
            height: AppSizes.spacingSmall,
          ),
          ElevatedButton(
            onPressed: () {
              onRetry();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}