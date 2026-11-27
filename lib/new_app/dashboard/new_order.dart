import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../app/router/route_names.dart';
import '../../core/services/cart_service.dart';
import '../../features/order/model/order_model.dart';
import '../../features/order/model/order_provider.dart';
import '../constant/constantappbar.dart';
import '../constant/constantcolour.dart';

class NewOrdersPage extends ConsumerStatefulWidget {
  const NewOrdersPage({super.key});

  @override
  ConsumerState<NewOrdersPage> createState() => _NewOrdersPageState();
}

class _NewOrdersPageState extends ConsumerState<NewOrdersPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshOrders() {
    return ref.read(ordersProvider.notifier).loadOrders();
  }

  List<OrderModel> _filterOrders(List<OrderModel> orders) {
    final String query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return orders;
    return orders.where((order) {
      return order.orderId.toLowerCase().contains(query) ||
          order.items.any((item) => item.name.toLowerCase().contains(query));
    }).toList();
  }

  void _openOrder(OrderModel order) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => NewOrderDetailsPage(orderId: order.orderId),
      ),
    );
  }

  Future<void> _cancelOrder(OrderModel order) async {
    final bool? shouldCancel = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cancel order?'),
        content: Text('Are you sure you want to cancel ${order.orderId}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Keep order'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: TextButton.styleFrom(foregroundColor: HomeColors.error),
            child: const Text('Cancel order'),
          ),
        ],
      ),
    );
    if (shouldCancel != true || !mounted) return;

    await ref.read(ordersProvider.notifier).cancelOrder(order.orderId);
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<OrderModel>> ordersAsync = ref.watch(ordersProvider);

    return Scaffold(
      backgroundColor: HomeColors.background,
      appBar: const CommonAppBar(
        automaticallyImplyLeading: false,
        title: 'My Orders',
        centerTitle: true,
        backgroundColor: HomeColors.secondary,

        ////test
        titleColor: HomeColors.white,
        iconColor: HomeColors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Search your orders',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchQuery.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Clear search',
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                        icon: const Icon(Icons.close_rounded),
                      ),
                filled: true,
                fillColor: HomeColors.surface,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: HomeColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: HomeColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: HomeColors.secondary,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ordersAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: HomeColors.secondary),
              ),
              error: (error, stackTrace) => _OrdersMessage(
                message: 'We could not load your orders.',
                actionLabel: 'Try again',
                onAction: _refreshOrders,
              ),
              data: (orders) {
                final List<OrderModel> filteredOrders = _filterOrders(orders);
                if (filteredOrders.isEmpty) {
                  return _OrdersMessage(
                    message: orders.isEmpty
                        ? 'Your orders will appear here.'
                        : 'No orders match your search.',
                    actionLabel: orders.isEmpty ? null : 'Clear search',
                    onAction: orders.isEmpty
                        ? null
                        : () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                  );
                }

                return RefreshIndicator(
                  color: HomeColors.secondary,
                  onRefresh: _refreshOrders,
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    itemCount: filteredOrders.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      final OrderModel order = filteredOrders[index];
                      return _OrderHistoryCard(
                        order: order,
                        onTap: () => _openOrder(order),
                        onCancel: () => _cancelOrder(order),
                        onRate: () => _openOrder(order),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class NewOrderDetailsPage extends ConsumerStatefulWidget {
  const NewOrderDetailsPage({super.key, required this.orderId});

  final String orderId;

  @override
  ConsumerState<NewOrderDetailsPage> createState() =>
      _NewOrderDetailsPageState();
}

class _NewOrderDetailsPageState extends ConsumerState<NewOrderDetailsPage> {
  final Map<String, int> _itemRatings = <String, int>{};
  bool _isReordering = false;
  bool _ratingSubmitted = false;

  Future<void> _reorder(OrderModel order) async {
    if (_isReordering) return;
    setState(() => _isReordering = true);

    try {
      await CartService.initialize();
      for (final OrderItemModel item in order.items) {
        await CartService.postAddToCart(
          productName: item.name,
          imageUrl: item.imageUrl,
          price: '₹${item.discountedMrp.toStringAsFixed(2)}',
          originalPrice: item.discountedMrp < item.mrp
              ? '₹${item.mrp.toStringAsFixed(2)}'
              : null,
          weight: item.weight,
        );
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: const Text('Order items added to your cart.'),
            action: SnackBarAction(
              label: 'VIEW CART',
              textColor: HomeColors.white,
              onPressed: () => context.push(RouteNames.newCart),
            ),
          ),
        );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Unable to reorder these items.')),
        );
    } finally {
      if (mounted) setState(() => _isReordering = false);
    }
  }

  void _submitRatings(OrderModel order) {
    final bool hasRating = order.items.any(
      (item) => (_itemRatings[item.id] ?? 0) > 0,
    );
    if (!hasRating) return;

    setState(() => _ratingSubmitted = true);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Thank you for rating your items.')),
      );
  }

  Future<void> _showTracking(OrderModel order) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _TrackingDetailsSheet(order: order),
    );
  }

  @override
  Widget build(BuildContext context) {
    final OrderModel? order = ref.watch(orderDetailsProvider(widget.orderId));

    if (order == null) {
      return Scaffold(
        backgroundColor: HomeColors.background,
        appBar: const CommonAppBar(
          automaticallyImplyLeading: true,
          showBackButton: true,
          title: 'Order Details',
          centerTitle: true,
          backgroundColor: HomeColors.secondary,
          titleColor: HomeColors.white,
          iconColor: HomeColors.white,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final bool canRate = order.status == OrderStatus.delivered;

    return Scaffold(
      backgroundColor: HomeColors.background,
      appBar: const CommonAppBar(
        automaticallyImplyLeading: true,
        showBackButton: true,
        title: 'Order Details',
        centerTitle: true,
        backgroundColor: HomeColors.secondary,
        titleColor: HomeColors.white,
        iconColor: HomeColors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          _OrderSummaryHeader(order: order),
          if (order.trackingEvents.isNotEmpty) ...[
            const SizedBox(height: 14),
            _TrackingBanner(order: order, onTap: () => _showTracking(order)),
          ],
          const SizedBox(height: 14),
          _OrderItemsSection(order: order),
          if (canRate) ...[
            const SizedBox(height: 14),
            _RateItemsSection(
              order: order,
              ratings: _itemRatings,
              submitted: _ratingSubmitted,
              onRatingChanged: (item, rating) {
                setState(() {
                  _itemRatings[item.id] = rating;
                  _ratingSubmitted = false;
                });
              },
              onSubmit: () => _submitRatings(order),
            ),
          ],
          const SizedBox(height: 14),
          _DeliveryAndPaymentCard(order: order),
          const SizedBox(height: 14),
          _BillDetailsCard(order: order),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
          child: SizedBox(
            height: 54,
            child: ElevatedButton.icon(
              onPressed: _isReordering ? null : () => _reorder(order),
              style: ElevatedButton.styleFrom(
                backgroundColor: HomeColors.secondary,
                foregroundColor: HomeColors.white,
                disabledBackgroundColor: HomeColors.secondary.withValues(
                  alpha: 0.6,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              icon: _isReordering
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: HomeColors.white,
                      ),
                    )
                  : const Icon(Icons.refresh_rounded),
              label: Text(_isReordering ? 'Adding items...' : 'Reorder'),
            ),
          ),
        ),
      ),
    );
  }
}

class _OrderHistoryCard extends StatelessWidget {
  const _OrderHistoryCard({
    required this.order,
    required this.onTap,
    required this.onCancel,
    required this.onRate,
  });

  final OrderModel order;
  final VoidCallback onTap;
  final VoidCallback onCancel;
  final VoidCallback onRate;

  @override
  Widget build(BuildContext context) {
    final bool delivered = order.status == OrderStatus.delivered;

    return Material(
      color: HomeColors.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            border: Border.all(color: HomeColors.border.withValues(alpha: 0.7)),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: HomeColors.secondaryLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      delivered
                          ? Icons.check_rounded
                          : Icons.inventory_2_outlined,
                      color: HomeColors.secondary,
                      size: 23,
                    ),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _statusLabel(order.status),
                          style: const TextStyle(
                            color: HomeColors.textPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '₹${order.priceBreakup.orderTotal.toStringAsFixed(0)}  ·  ${_formatDate(order.deliveredDate ?? order.orderDate)}',
                          style: const TextStyle(
                            color: HomeColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'View order details',
                    visualDensity: VisualDensity.compact,
                    onPressed: onTap,
                    icon: const Icon(
                      Icons.chevron_right_rounded,
                      color: HomeColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 66,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: order.items.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 9),
                  itemBuilder: (context, index) => _CompactProductImage(
                    imageUrl: order.items[index].imageUrl,
                    size: 66,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '${order.items.length} ${order.items.length == 1 ? 'item' : 'items'}  ·  Order ID: ${order.orderId}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: HomeColors.textSecondary,
                  fontSize: 12,
                ),
              ),
              const Divider(height: 20, color: HomeColors.divider),
              Row(
                children: [
                  if (order.status == OrderStatus.processing ||
                      order.status == OrderStatus.shipped)
                    Expanded(
                      child: TextButton(
                        onPressed: onCancel,
                        style: TextButton.styleFrom(
                          foregroundColor: HomeColors.error,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        child: const Text('Cancel order'),
                      ),
                    )
                  else
                    Expanded(
                      child: TextButton(
                        onPressed: onRate,
                        style: TextButton.styleFrom(
                          foregroundColor: HomeColors.secondary,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        child: Text(delivered ? 'Rate items' : 'Order details'),
                      ),
                    ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: HomeColors.secondary,
                        foregroundColor: HomeColors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                      ),
                      child: const Text('View order'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderSummaryHeader extends StatelessWidget {
  const _OrderSummaryHeader({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final String statusText = order.status == OrderStatus.delivered
        ? 'Delivered ${_formatDate(order.deliveredDate ?? order.orderDate)}'
        : _statusLabel(order.status);

    return _OrderPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order ID: ${order.orderId}',
            style: const TextStyle(
              color: HomeColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text(
                  statusText,
                  style: const TextStyle(
                    color: HomeColors.textPrimary,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              if (order.status == OrderStatus.delivered)
                _StatusPill(
                  label: order.onTime ? 'On time' : 'Delayed',
                  color: order.onTime ? HomeColors.secondary : HomeColors.error,
                  background: order.onTime
                      ? HomeColors.secondaryLight
                      : const Color(0xFFFFEBEE),
                ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: HomeColors.divider),
          const SizedBox(height: 12),
          Text(
            '${order.items.length} ${order.items.length == 1 ? 'item' : 'items'} in this order',
            style: const TextStyle(
              color: HomeColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          for (int index = 0; index < order.items.length; index++) ...[
            _OrderItemRow(item: order.items[index]),
            if (index != order.items.length - 1)
              const Divider(height: 16, color: HomeColors.divider),
          ],
        ],
      ),
    );
  }
}

class _TrackingBanner extends StatelessWidget {
  const _TrackingBanner({required this.order, required this.onTap});

  final OrderModel order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final TrackingEvent latest = order.trackingEvents.last;
    return _OrderPanel(
      child: Row(
        children: [
          const Icon(
            Icons.local_shipping_outlined,
            color: HomeColors.secondary,
            size: 23,
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Text(
              latest.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: HomeColors.textPrimary,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: onTap,
            style: TextButton.styleFrom(
              foregroundColor: HomeColors.secondary,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            ),
            child: const Text('Track order'),
          ),
        ],
      ),
    );
  }
}

class _TrackingDetailsSheet extends StatelessWidget {
  const _TrackingDetailsSheet({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        height: MediaQuery.sizeOf(context).height * 0.72,
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
        decoration: const BoxDecoration(
          color: HomeColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: HomeColors.border,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Tracking details',
                    style: TextStyle(
                      color: HomeColors.textPrimary,
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Close',
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            if (order.deliveryPartner.isNotEmpty ||
                order.trackingId.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: HomeColors.background,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _TrackingLabelValue(
                        label: 'Delivery partner',
                        value: order.deliveryPartner.isEmpty
                            ? 'Not available'
                            : order.deliveryPartner,
                      ),
                    ),
                    Container(width: 1, height: 36, color: HomeColors.border),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: _TrackingLabelValue(
                              label: 'Tracking ID',
                              value: order.trackingId.isEmpty
                                  ? 'Not available'
                                  : order.trackingId,
                            ),
                          ),
                          if (order.trackingId.isNotEmpty)
                            IconButton(
                              tooltip: 'Copy tracking ID',
                              visualDensity: VisualDensity.compact,
                              onPressed: () {
                                Clipboard.setData(
                                  ClipboardData(text: order.trackingId),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Tracking ID copied.'),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.copy_outlined,
                                size: 19,
                                color: HomeColors.textSecondary,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 18),
            Expanded(
              child: ListView.builder(
                itemCount: order.trackingEvents.length,
                itemBuilder: (context, index) => _TrackingEventRow(
                  event: order.trackingEvents[index],
                  isLast: index == order.trackingEvents.length - 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrackingLabelValue extends StatelessWidget {
  const _TrackingLabelValue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: HomeColors.textSecondary, fontSize: 11),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: HomeColors.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _TrackingEventRow extends StatelessWidget {
  const _TrackingEventRow({required this.event, required this.isLast});

  final TrackingEvent event;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final bool pending = event.state == TrackingState.pending;
    final Color eventColor = pending
        ? HomeColors.disabled
        : HomeColors.secondary;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 28,
            child: Column(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: eventColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    event.state == TrackingState.completed
                        ? Icons.check_rounded
                        : Icons.circle,
                    color: HomeColors.white,
                    size: event.state == TrackingState.completed ? 15 : 8,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: pending
                          ? HomeColors.border
                          : HomeColors.secondaryLight,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: TextStyle(
                      color: pending
                          ? HomeColors.textSecondary
                          : HomeColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    event.description,
                    style: const TextStyle(
                      color: HomeColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _formatDateTime(event.timestamp),
                    style: const TextStyle(
                      color: HomeColors.textHint,
                      fontSize: 12,
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
}

class _OrderItemsSection extends StatelessWidget {
  const _OrderItemsSection({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return _OrderPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Items in this order',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: HomeColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          for (int index = 0; index < order.items.length; index++) ...[
            _OrderItemRow(item: order.items[index]),
            if (index != order.items.length - 1)
              const Divider(height: 18, color: HomeColors.divider),
          ],
        ],
      ),
    );
  }
}

class _OrderItemRow extends StatelessWidget {
  const _OrderItemRow({required this.item});

  final OrderItemModel item;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _CompactProductImage(imageUrl: item.imageUrl, size: 70),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: HomeColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.weight,
                style: const TextStyle(
                  color: HomeColors.textSecondary,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Text(
                    '₹${item.discountedMrp.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: HomeColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (item.mrp > item.discountedMrp) ...[
                    const SizedBox(width: 7),
                    Text(
                      '₹${item.mrp.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: HomeColors.textHint,
                        fontSize: 12,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RateItemsSection extends StatelessWidget {
  const _RateItemsSection({
    required this.order,
    required this.ratings,
    required this.submitted,
    required this.onRatingChanged,
    required this.onSubmit,
  });

  final OrderModel order;
  final Map<String, int> ratings;
  final bool submitted;
  final void Function(OrderItemModel item, int rating) onRatingChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return _OrderPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rate your order',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: HomeColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'How were the items you received?',
            style: TextStyle(color: HomeColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 12),
          for (int index = 0; index < order.items.length; index++) ...[
            _ItemRatingRow(
              item: order.items[index],
              rating: ratings[order.items[index].id] ?? 0,
              onChanged: (rating) =>
                  onRatingChanged(order.items[index], rating),
            ),
            if (index != order.items.length - 1)
              const Divider(height: 16, color: HomeColors.divider),
          ],
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed:
                  submitted ||
                      !order.items.any((item) => (ratings[item.id] ?? 0) > 0)
                  ? null
                  : onSubmit,
              style: OutlinedButton.styleFrom(
                foregroundColor: HomeColors.secondary,
                disabledForegroundColor: HomeColors.textHint,
                side: const BorderSide(color: HomeColors.secondary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(submitted ? 'Rating submitted' : 'Submit rating'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemRatingRow extends StatelessWidget {
  const _ItemRatingRow({
    required this.item,
    required this.rating,
    required this.onChanged,
  });

  final OrderItemModel item;
  final int rating;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _CompactProductImage(imageUrl: item.imageUrl, size: 56),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: HomeColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 3),
              _StarRating(rating: rating, onChanged: onChanged),
            ],
          ),
        ),
      ],
    );
  }
}

class _StarRating extends StatelessWidget {
  const _StarRating({required this.rating, required this.onChanged});

  final int rating;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List<Widget>.generate(5, (index) {
        final int value = index + 1;
        return IconButton(
          tooltip: '$value star${value == 1 ? '' : 's'}',
          visualDensity: VisualDensity.compact,
          constraints: const BoxConstraints(minWidth: 31, minHeight: 34),
          padding: EdgeInsets.zero,
          onPressed: () => onChanged(value),
          icon: Icon(
            value <= rating ? Icons.star_rounded : Icons.star_border_rounded,
            size: 25,
            color: value <= rating ? HomeColors.accent : HomeColors.textHint,
          ),
        );
      }),
    );
  }
}

class _DeliveryAndPaymentCard extends StatelessWidget {
  const _DeliveryAndPaymentCard({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return _OrderPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: HomeColors.secondary,
                size: 21,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Delivery address',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: HomeColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            order.customerName,
            style: const TextStyle(
              color: HomeColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            order.deliveryAddress,
            style: const TextStyle(color: HomeColors.textSecondary),
          ),
          const SizedBox(height: 4),
          Text(
            order.customerPhone,
            style: const TextStyle(color: HomeColors.textSecondary),
          ),
          const Divider(height: 24, color: HomeColors.divider),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Payment mode',
                  style: TextStyle(color: HomeColors.textSecondary),
                ),
              ),
              Text(
                order.paymentMode,
                style: const TextStyle(
                  color: HomeColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BillDetailsCard extends StatelessWidget {
  const _BillDetailsCard({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final OrderPriceBreakup bill = order.priceBreakup;

    return _OrderPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bill details',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: HomeColors.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          _BillRow(label: 'Total MRP', amount: bill.totalMrp),
          const SizedBox(height: 10),
          _BillRow(label: 'Discounted total', amount: bill.discountedTotalMrp),
          const SizedBox(height: 10),
          _BillRow(label: 'Tax', amount: bill.tax),
          const SizedBox(height: 10),
          _BillRow(label: 'Shipping charges', amount: bill.shippingCharges),
          const Divider(height: 24, color: HomeColors.divider),
          _BillRow(
            label: 'Order total',
            amount: bill.orderTotal,
            isTotal: true,
          ),
          if (bill.youSaved > 0) ...[
            const SizedBox(height: 12),
            _StatusPill(
              label: 'You saved ₹${bill.youSaved.toStringAsFixed(0)}',
              color: HomeColors.secondary,
              background: HomeColors.secondaryLight,
            ),
          ],
        ],
      ),
    );
  }
}

class _BillRow extends StatelessWidget {
  const _BillRow({
    required this.label,
    required this.amount,
    this.isTotal = false,
  });

  final String label;
  final double amount;
  final bool isTotal;

  @override
  Widget build(BuildContext context) {
    final TextStyle style = TextStyle(
      color: isTotal ? HomeColors.textPrimary : HomeColors.textSecondary,
      fontSize: isTotal ? 15 : 14,
      fontWeight: isTotal ? FontWeight.w800 : FontWeight.w400,
    );
    return Row(
      children: [
        Expanded(child: Text(label, style: style)),
        Text('₹${amount.toStringAsFixed(0)}', style: style),
      ],
    );
  }
}

class _CompactProductImage extends StatelessWidget {
  const _CompactProductImage({required this.imageUrl, required this.size});

  final String imageUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7F5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: HomeColors.divider),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: imageUrl.trim().isEmpty
            ? const Icon(
                Icons.image_not_supported_outlined,
                color: HomeColors.textHint,
              )
            : Image.network(
                imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.image_not_supported_outlined,
                  color: HomeColors.textHint,
                ),
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const Center(
                    child: SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: HomeColors.secondary,
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class _OrderPanel extends StatelessWidget {
  const _OrderPanel({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: HomeColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: HomeColors.border.withValues(alpha: 0.7)),
      ),
      child: child,
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.label,
    required this.color,
    required this.background,
  });

  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _OrdersMessage extends StatelessWidget {
  const _OrdersMessage({
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.receipt_long_outlined,
              size: 48,
              color: HomeColors.secondary,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: HomeColors.textSecondary,
                fontSize: 15,
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 10),
              TextButton(
                onPressed: onAction,
                child: Text(
                  actionLabel!,
                  style: const TextStyle(color: HomeColors.secondary),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

String _statusLabel(OrderStatus status) {
  switch (status) {
    case OrderStatus.processing:
      return 'Order confirmed';
    case OrderStatus.shipped:
      return 'On the way';
    case OrderStatus.delivered:
      return 'Delivered';
    case OrderStatus.cancelled:
      return 'Cancelled';
  }
}

String _formatDate(DateTime date) {
  const List<String> months = <String>[
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${date.day} ${months[date.month - 1]} ${date.year}';
}

String _formatDateTime(DateTime date) {
  final int hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
  final String minute = date.minute.toString().padLeft(2, '0');
  final String period = date.hour >= 12 ? 'PM' : 'AM';
  return '${_formatDate(date)}, $hour:$minute $period';
}
