import 'package:flutter/material.dart';

import '../../../../core/services/cart_notification_item.dart';
import '../../../../core/services/cart_service.dart';

class CheckoutProductWidget extends StatelessWidget {
  const CheckoutProductWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<CartNotificationItem>>(
      valueListenable: CartService.items,
      builder: (
        BuildContext context,
        List<CartNotificationItem> cartItems,
        Widget? child,
      ) {
        /// ============================================================
        /// SUBTOTAL
        /// ============================================================
        final double subtotal = cartItems.fold<double>(
          0,
          (
            double total,
            CartNotificationItem item,
          ) {
            final double price = _parsePrice(
              item.price,
            );

            return total +
                (price * item.quantity);
          },
        );

        return Material(
          color: Colors.transparent,

          child: Container(
            width: double.infinity,

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius: BorderRadius.circular(
                16,
              ),

              border: Border.all(
                color: const Color(
                  0xFFE3E3E3,
                ),
              ),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: 0.05,
                  ),
                  blurRadius: 12,
                  offset: const Offset(
                    0,
                    4,
                  ),
                ),
              ],
            ),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// ==================================================
                /// HEADER
                /// ==================================================
                _HeaderSection(
                  itemCount: cartItems.length,
                ),

                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(
                    0xFFEEEEEE,
                  ),
                ),

                /// ==================================================
                /// EMPTY CART
                /// ==================================================
                if (cartItems.isEmpty)
                  const _EmptyProductSection(),

                /// ==================================================
                /// PRODUCT LIST
                /// ==================================================
                if (cartItems.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      14,
                      14,
                      14,
                      8,
                    ),

                    child: Column(
                      children: List.generate(
                        cartItems.length,
                        (
                          int index,
                        ) {
                          final CartNotificationItem item =
                              cartItems[index];

                          return Padding(
                            padding: EdgeInsets.only(
                              bottom:
                                  index ==
                                          cartItems.length -
                                              1
                                      ? 0
                                      : 12,
                            ),

                            child: _CheckoutProductCard(
                              item: item,
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                /// ==================================================
                /// SUBTOTAL
                /// ==================================================
                if (cartItems.isNotEmpty)
                  _SubtotalSection(
                    subtotal: subtotal,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// ============================================================================
/// HEADER
/// ============================================================================

class _HeaderSection extends StatelessWidget {
  final int itemCount;

  const _HeaderSection({
    required this.itemCount,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),

      child: Row(
        children: [
          /// ICON
          Container(
            height: 40,
            width: 40,

            alignment: Alignment.center,

            decoration: BoxDecoration(
              color: const Color(
                0xFFFFF0F0,
              ),

              borderRadius: BorderRadius.circular(
                10,
              ),
            ),

            child: const Icon(
              Icons.shopping_bag_outlined,
              size: 22,
              color: Colors.red,
            ),
          ),

          const SizedBox(
            width: 12,
          ),

          /// TITLE
          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  'Order Summary',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight:
                        FontWeight.w700,
                    color: Color(
                      0xFF202020,
                    ),
                  ),
                ),

                SizedBox(
                  height: 3,
                ),

                Text(
                  'Products in your cart',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(
                      0xFF888888,
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// ITEM COUNT
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),

            decoration: BoxDecoration(
              color: const Color(
                0xFFF5F5F5,
              ),

              borderRadius: BorderRadius.circular(
                20,
              ),
            ),

            child: Text(
              '$itemCount ${itemCount == 1 ? 'Item' : 'Items'}',

              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(
                  0xFF555555,
                ),
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

class _CheckoutProductCard
    extends StatelessWidget {
  final CartNotificationItem item;

  const _CheckoutProductCard({
    required this.item,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final double unitPrice =
        _parsePrice(
      item.price,
    );

    final double totalPrice =
        unitPrice *
            item.quantity;

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(
        14,
      ),

      decoration: BoxDecoration(
        color: const Color(
          0xFFFAFAFA,
        ),

        borderRadius: BorderRadius.circular(
          13,
        ),

        border: Border.all(
          color: const Color(
            0xFFEEEEEE,
          ),
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          /// ========================================================
          /// PRODUCT NAME + DELETE
          /// ========================================================
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              /// PRODUCT ICON
              Container(
                height: 42,
                width: 42,

                alignment: Alignment.center,

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius:
                      BorderRadius.circular(
                    10,
                  ),

                  border: Border.all(
                    color: const Color(
                      0xFFE7E7E7,
                    ),
                  ),
                ),

                child: const Icon(
                  Icons.inventory_2_outlined,
                  size: 21,
                  color: Color(
                    0xFF555555,
                  ),
                ),
              ),

              const SizedBox(
                width: 11,
              ),

              /// PRODUCT DETAILS
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    Text(
                      item.name.trim(),

                      maxLines: 2,

                      overflow:
                          TextOverflow.ellipsis,

                      style:
                          const TextStyle(
                        fontSize: 14,
                        height: 1.3,

                        fontWeight:
                            FontWeight.w600,

                        color: Color(
                          0xFF222222,
                        ),
                      ),
                    ),

                    if (item.weight !=
                            null &&
                        item.weight!
                            .trim()
                            .isNotEmpty) ...[
                      const SizedBox(
                        height: 4,
                      ),

                      Text(
                        item.weight!.trim(),

                        style:
                            const TextStyle(
                          fontSize: 12,

                          color: Color(
                            0xFF888888,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(
                width: 8,
              ),

              /// DELETE
              _DeleteButton(
                onTap: () async {
                  await CartService.removeItem(
                    item,
                  );
                },
              ),
            ],
          ),

          const SizedBox(
            height: 14,
          ),

          const Divider(
            height: 1,
            color: Color(
              0xFFEAEAEA,
            ),
          ),

          const SizedBox(
            height: 13,
          ),

          /// ========================================================
          /// UNIT PRICE + TOTAL
          /// ========================================================
          Row(
            children: [
              /// UNIT PRICE
              Expanded(
                child: _PriceInfo(
                  label: 'Unit Price',

                  value:
                      '₹${_formatPrice(unitPrice)}',
                ),
              ),

              Container(
                width: 1,
                height: 35,
                color: const Color(
                  0xFFE6E6E6,
                ),
              ),

              const SizedBox(
                width: 16,
              ),

              /// TOTAL
              Expanded(
                child: _PriceInfo(
                  label: 'Total',

                  value:
                      '₹${_formatPrice(totalPrice)}',

                  valueBold: true,
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 14,
          ),

          /// ========================================================
          /// QUANTITY
          /// ========================================================
          Row(
            children: [
              const Text(
                'Quantity',

                style: TextStyle(
                  fontSize: 12,
                  color: Color(
                    0xFF777777,
                  ),
                ),
              ),

              const Spacer(),

              _QuantityControl(
                item: item,
              ),
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
  Widget build(
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        Text(
          label,

          style: const TextStyle(
            fontSize: 11,
            color: Color(
              0xFF888888,
            ),
          ),
        ),

        const SizedBox(
          height: 4,
        ),

        Text(
          value,

          style: TextStyle(
            fontSize: 14,

            fontWeight:
                valueBold
                    ? FontWeight.w700
                    : FontWeight.w600,

            color: const Color(
              0xFF222222,
            ),
          ),
        ),
      ],
    );
  }
}

/// ============================================================================
/// QUANTITY CONTROL
/// ============================================================================

class _QuantityControl
    extends StatelessWidget {
  final CartNotificationItem item;

  const _QuantityControl({
    required this.item,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      height: 36,

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(
          9,
        ),

        border: Border.all(
          color: const Color(
            0xFFDADADA,
          ),
        ),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          /// MINUS
          _QuantityButton(
            icon: Icons.remove,

            enabled:
                item.quantity >
                    1,

            onTap: () async {
              if (item.quantity >
                  1) {
                await CartService
                    .decreaseItemQuantity(
                  item,
                );
              }
            },
          ),

          Container(
            width: 1,
            height: 22,

            color: const Color(
              0xFFE7E7E7,
            ),
          ),

          /// QUANTITY
          SizedBox(
            width: 38,

            child: Center(
              child: Text(
                '${item.quantity}',

                style:
                    const TextStyle(
                  fontSize: 13,

                  fontWeight:
                      FontWeight.w600,

                  color: Color(
                    0xFF222222,
                  ),
                ),
              ),
            ),
          ),

          Container(
            width: 1,
            height: 22,

            color: const Color(
              0xFFE7E7E7,
            ),
          ),

          /// PLUS
          _QuantityButton(
            icon: Icons.add,

            onTap: () async {
              await CartService
                  .increaseItemQuantity(
                item,
              );
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

class _QuantityButton
    extends StatelessWidget {
  final IconData icon;

  final VoidCallback onTap;

  final bool enabled;

  const _QuantityButton({
    required this.icon,
    required this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,

      onTap:
          enabled
              ? onTap
              : null,

      child: SizedBox(
        height: 36,
        width: 36,

        child: Icon(
          icon,

          size: 17,

          color:
              enabled
                  ? const Color(
                    0xFF444444,
                  )
                  : const Color(
                    0xFFC5C5C5,
                  ),
        ),
      ),
    );
  }
}

/// ============================================================================
/// DELETE BUTTON
/// ============================================================================

class _DeleteButton
    extends StatelessWidget {
  final VoidCallback onTap;

  const _DeleteButton({
    required this.onTap,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,

      onTap: onTap,

      child: Container(
        height: 34,
        width: 34,

        alignment: Alignment.center,

        decoration: BoxDecoration(
          color: const Color(
            0xFFFFEEEE,
          ),

          borderRadius: BorderRadius.circular(
            9,
          ),
        ),

        child: const Icon(
          Icons.delete_outline_rounded,

          size: 19,

          color: Color(
            0xFFE60000,
          ),
        ),
      ),
    );
  }
}

/// ============================================================================
/// SUBTOTAL
/// ============================================================================

class _SubtotalSection
    extends StatelessWidget {
  final double subtotal;

  const _SubtotalSection({
    required this.subtotal,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 17,
      ),

      decoration: const BoxDecoration(
        color: Color(
          0xFFF8F8F8,
        ),

        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(
            16,
          ),

          bottomRight: Radius.circular(
            16,
          ),
        ),

        border: Border(
          top: BorderSide(
            color: Color(
              0xFFE8E8E8,
            ),
          ),
        ),
      ),

      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Subtotal',

              style: TextStyle(
                fontSize: 15,

                fontWeight:
                    FontWeight.w600,

                color: Color(
                  0xFF444444,
                ),
              ),
            ),
          ),

          Text(
            '₹${_formatPrice(subtotal)}',

            style: const TextStyle(
              fontSize: 19,

              fontWeight:
                  FontWeight.w700,

              color: Color(
                0xFF111111,
              ),
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

class _EmptyProductSection
    extends StatelessWidget {
  const _EmptyProductSection();

  @override
  Widget build(
    BuildContext context,
  ) {
    return const Padding(
      padding: EdgeInsets.symmetric(
        vertical: 35,
        horizontal: 20,
      ),

      child: Column(
        children: [
          Icon(
            Icons.shopping_cart_outlined,

            size: 45,

            color: Color(
              0xFFBBBBBB,
            ),
          ),

          SizedBox(
            height: 10,
          ),

          Text(
            'Your cart is empty',

            style: TextStyle(
              fontSize: 14,

              fontWeight:
                  FontWeight.w600,

              color: Color(
                0xFF666666,
              ),
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

double _parsePrice(
  String value,
) {
  final String cleaned =
      value
          .replaceAll(
            ',',
            '',
          )
          .replaceAll(
            RegExp(
              r'[^0-9.]',
            ),
            '',
          );

  return double.tryParse(
        cleaned,
      ) ??
      0;
}

/// ============================================================================
/// PRICE FORMAT
/// ============================================================================

String _formatPrice(
  double value,
) {
  final String fixed =
      value.toStringAsFixed(
    2,
  );

  final List<String> parts =
      fixed.split('.');

  final String integerPart =
      parts[0];

  final String decimalPart =
      parts.length > 1
          ? parts[1]
          : '00';

  final StringBuffer buffer =
      StringBuffer();

  for (
    int i = 0;
    i < integerPart.length;
    i++
  ) {
    buffer.write(
      integerPart[i],
    );

    final int remaining =
        integerPart.length -
            i -
            1;

    if (remaining > 0 &&
        remaining % 3 == 0) {
      buffer.write(',');
    }
  }

  return '${buffer.toString()}.$decimalPart';
}