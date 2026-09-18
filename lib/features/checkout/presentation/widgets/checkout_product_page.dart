import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

import '../../../../app/theme/app_sizes.dart';
import '../../../../core/services/cart_notification_item.dart';
import '../../../../core/services/cart_service.dart';
import '../../../../core/widgets/app_shimmer.dart';

/// ============================================================================
/// CHECKOUT PRODUCT WIDGET (order summary card)
/// ============================================================================
class CheckoutProductWidget extends StatelessWidget {
  const CheckoutProductWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<CartNotificationItem>>(
      valueListenable: CartService.items,
      builder: (
        BuildContext context,
        List<CartNotificationItem> cartItems,
        Widget? child,
      ) {
        /// SUBTOTAL
        final double subtotal = cartItems.fold<double>(
          0,
          (double total, CartNotificationItem item) {
            final double price = _parsePrice(item.price);
            return total + (price * item.quantity);
          },
        );

        return Material(
          color: Colors.transparent,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSizes.radiusXLarge),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// HEADER
                _HeaderSection(itemCount: cartItems.length),

                Divider(
                  height: AppSizes.dividerHeight,
                  thickness: AppSizes.dividerHeight,
                  color: AppColors.divider,
                ),

                /// EMPTY CART
                if (cartItems.isEmpty) const _EmptyProductSection(),

                /// PRODUCT LIST
                if (cartItems.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      AppSizes.spacingLarge,
                      AppSizes.spacingLarge,
                      AppSizes.spacingLarge,
                      AppSizes.spacingSmall,
                    ),
                    child: Column(
                      children: List.generate(cartItems.length, (int index) {
                        final CartNotificationItem item = cartItems[index];

                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: index == cartItems.length - 1
                                ? 0
                                : AppSizes.spacingMedium,
                          ),
                          child: _CheckoutProductCard(item: item),
                        );
                      }),
                    ),
                  ),

                /// SUBTOTAL
                if (cartItems.isNotEmpty) _SubtotalSection(subtotal: subtotal),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// ============================================================================
/// SHIMMER PLACEHOLDER (shown while the checkout page is loading)
/// ============================================================================
class CheckoutProductShimmer extends StatelessWidget {
  const CheckoutProductShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusXLarge),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER ROW
          Row(
            children: [
              AppShimmer(width: 40, height: 40, radius: AppSizes.radiusMedium),
              SizedBox(width: AppSizes.spacingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppShimmer(width: 140, height: 15, radius: AppSizes.radiusSmall),
                    SizedBox(height: AppSizes.spacingXXSmall),
                    AppShimmer(width: 90, height: 11, radius: AppSizes.radiusSmall),
                  ],
                ),
              ),
              AppShimmer(width: 50, height: 20, radius: AppSizes.radiusLarge),
            ],
          ),

          SizedBox(height: AppSizes.spacingXLarge),

          /// TWO FAKE PRODUCT ROWS
          for (int i = 0; i < 2; i++) ...[
            AppShimmer(height: 110, radius: AppSizes.radiusLarge),
            SizedBox(height: AppSizes.spacingMedium),
          ],

          SizedBox(height: AppSizes.spacingSmall),

          /// SUBTOTAL ROW
          Row(
            children: [
              AppShimmer(width: 80, height: 16, radius: AppSizes.radiusSmall),
              const Spacer(),
              AppShimmer(width: 90, height: 20, radius: AppSizes.radiusSmall),
            ],
          ),
        ],
      ),
    );
  }
}

/// ============================================================================
/// HEADER
/// ============================================================================
class _HeaderSection extends StatelessWidget {
  final int itemCount;

  const _HeaderSection({required this.itemCount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.spacingLarge,
        vertical: AppSizes.spacingLarge,
      ),
      child: Row(
        children: [
          /// ICON
          Container(
            height: 40,
            width: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
            ),
            child: const Icon(
              Icons.shopping_bag_outlined,
              size: 22,
              color: AppColors.primary,
            ),
          ),

          SizedBox(width: AppSizes.spacingMedium),

          /// TITLE
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order Summary',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Products in your cart',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),

          /// ITEM COUNT
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.spacingSmall,
              vertical: AppSizes.spacingXXSmall,
            ),
            decoration: BoxDecoration(
              color: AppColors.disabledBackground,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$itemCount ${itemCount == 1 ? 'Item' : 'Items'}',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ============================================================================
/// PRODUCT CARD
/// ============================================================================
class _CheckoutProductCard extends StatelessWidget {
  final CartNotificationItem item;

  const _CheckoutProductCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final double unitPrice = _parsePrice(item.price);
    final double totalPrice = unitPrice * item.quantity;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.spacingLarge),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// NAME + DELETE
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// PRODUCT ICON
              Container(
                height: 42,
                width: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Icon(
                  Icons.inventory_2_outlined,
                  size: 21,
                  color: AppColors.textSecondary,
                ),
              ),

              SizedBox(width: AppSizes.spacingMedium),

              /// DETAILS
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name.trim(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.3,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (item.weight != null && item.weight!.trim().isNotEmpty) ...[
                      SizedBox(height: AppSizes.spacingXXSmall),
                      Text(
                        item.weight!.trim(),
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ],
                ),
              ),

              SizedBox(width: AppSizes.spacingSmall),

              /// DELETE
              _DeleteButton(
                onTap: () async {
                  await CartService.removeItem(item);
                },
              ),
            ],
          ),

          SizedBox(height: AppSizes.spacingLarge),
          Divider(height: AppSizes.dividerHeight, color: AppColors.divider),
          SizedBox(height: AppSizes.spacingMedium),

          /// UNIT PRICE + TOTAL
          Row(
            children: [
              Expanded(
                child: _PriceInfo(
                  label: 'Unit Price',
                  value: '₹${_formatPrice(unitPrice)}',
                ),
              ),
              Container(width: 1, height: 35, color: AppColors.border),
              SizedBox(width: AppSizes.spacingLarge),
              Expanded(
                child: _PriceInfo(
                  label: 'Total',
                  value: '₹${_formatPrice(totalPrice)}',
                  valueBold: true,
                ),
              ),
            ],
          ),

          SizedBox(height: AppSizes.spacingMedium),

          /// QUANTITY
          Row(
            children: [
              const Text(
                'Quantity',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              const Spacer(),
              _QuantityControl(item: item),
            ],
          ),
        ],
      ),
    );
  }
}

/// ============================================================================
/// PRICE INFO
/// ============================================================================
class _PriceInfo extends StatelessWidget {
  final String label;
  final String value;
  final bool valueBold;

  const _PriceInfo({
    required this.label,
    required this.value,
    this.valueBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        SizedBox(height: AppSizes.spacingXXSmall),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: valueBold ? FontWeight.w700 : FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

/// ============================================================================
/// QUANTITY CONTROL
/// ============================================================================
class _QuantityControl extends StatelessWidget {
  final CartNotificationItem item;

  const _QuantityControl({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall + 3),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// MINUS
          _QuantityButton(
            icon: Icons.remove,
            enabled: item.quantity > 1,
            onTap: () async {
              if (item.quantity > 1) {
                await CartService.decreaseItemQuantity(item);
              }
            },
          ),

          Container(width: 1, height: 22, color: AppColors.divider),

          /// QUANTITY
          SizedBox(
            width: 38,
            child: Center(
              child: Text(
                '${item.quantity}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),

          Container(width: 1, height: 22, color: AppColors.divider),

          /// PLUS
          _QuantityButton(
            icon: Icons.add,
            onTap: () async {
              await CartService.increaseItemQuantity(item);
            },
          ),
        ],
      ),
    );
  }
}

/// ============================================================================
/// QUANTITY BUTTON
/// ============================================================================
class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;

  const _QuantityButton({
    required this.icon,
    required this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: enabled ? onTap : null,
      child: SizedBox(
        height: 36,
        width: 36,
        child: Icon(
          icon,
          size: 17,
          color: enabled ? AppColors.textPrimary : AppColors.disabled,
        ),
      ),
    );
  }
}

/// ============================================================================
/// DELETE BUTTON
/// ============================================================================
class _DeleteButton extends StatelessWidget {
  final VoidCallback onTap;

  const _DeleteButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 34,
        width: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium - 1),
        ),
        child: const Icon(
          Icons.delete_outline_rounded,
          size: 19,
          color: AppColors.error,
        ),
      ),
    );
  }
}

/// ============================================================================
/// SUBTOTAL
/// ============================================================================
class _SubtotalSection extends StatelessWidget {
  final double subtotal;

  const _SubtotalSection({required this.subtotal});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.spacingXLarge - 2,
        vertical: AppSizes.spacingLarge + 1,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppSizes.radiusXLarge),
          bottomRight: Radius.circular(AppSizes.radiusXLarge),
        ),
        border: const Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Subtotal',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Text(
            '₹${_formatPrice(subtotal)}',
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

/// ============================================================================
/// EMPTY CART
/// ============================================================================
class _EmptyProductSection extends StatelessWidget {
  const _EmptyProductSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: AppSizes.spacingSection,
        horizontal: AppSizes.spacingXLarge,
      ),
      child: const Column(
        children: [
          Icon(Icons.shopping_cart_outlined, size: 45, color: AppColors.disabled),
          SizedBox(height: 10),
          Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// ============================================================================
/// PRICE PARSER
/// ============================================================================
double _parsePrice(String value) {
  final String cleaned = value.replaceAll(',', '').replaceAll(RegExp(r'[^0-9.]'), '');
  return double.tryParse(cleaned) ?? 0;
}

/// ============================================================================
/// PRICE FORMAT
/// ============================================================================
String _formatPrice(double value) {
  final String fixed = value.toStringAsFixed(2);
  final List<String> parts = fixed.split('.');
  final String integerPart = parts[0];
  final String decimalPart = parts.length > 1 ? parts[1] : '00';

  final StringBuffer buffer = StringBuffer();

  for (int i = 0; i < integerPart.length; i++) {
    buffer.write(integerPart[i]);
    final int remaining = integerPart.length - i - 1;
    if (remaining > 0 && remaining % 3 == 0) {
      buffer.write(',');
    }
  }

  return '${buffer.toString()}.$decimalPart';
}
