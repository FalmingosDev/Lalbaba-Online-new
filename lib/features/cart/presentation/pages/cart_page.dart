// import 'package:flutter/material.dart';
// import '../../../../core/services/cart_notification_item.dart';
// import '../../../../core/services/cart_service.dart';
// import '../../../../core/widgets/app_app_bar.dart';
// import '../../../account/presentation/widgets/app_string.dart';

// class CartPage extends StatefulWidget {
//   const CartPage({super.key});

//   @override
//   State<CartPage> createState() => _CartPageState();
// }

// class _CartPageState extends State<CartPage> {
//   late final Future<void> _cartInitializeFuture;

//   @override
//   void initState() {
//     super.initState();

//     _cartInitializeFuture = CartService.initialize();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppAppBar(
//         title: AppStrings.cart,
//         // automaticallyImplyLeading: true,
//         centerTitle: true,
//       ),

//       body: SafeArea(
//         child: FutureBuilder<void>(
//           future: _cartInitializeFuture,

//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             }

//             return ValueListenableBuilder<List<CartNotificationItem>>(
//               valueListenable: CartService.items,

//               builder: (context, cartItems, child) {
//                 if (cartItems.isEmpty) {
//                   return const _EmptyCart();
//                 }

//                 final double subtotal = cartItems.fold<double>(0, (
//                   double total,
//                   CartNotificationItem item,
//                 ) {
//                   final double price = _parsePrice(item.price);

//                   return total + (price * item.quantity);
//                 });

//                 final double delivery = cartItems.isEmpty ? 0 : 40;

//                 final double total = subtotal + delivery;

//                 return Column(
//                   children: [
//                     Expanded(
//                       child: ListView.separated(
//                         padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),

//                         itemCount: cartItems.length,

//                         separatorBuilder: (context, index) {
//                           return const SizedBox(height: 12);
//                         },

//                         itemBuilder: (context, index) {
//                           final CartNotificationItem item = cartItems[index];

//                           return _CartItemCard(item: item);
//                         },
//                       ),
//                     ),

//                     _CartSummary(
//                       subtotal: subtotal,
//                       delivery: delivery,
//                       total: total,
//                     ),
//                   ],
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// // ===========================================================================
// // CART ITEM CARD
// // ===========================================================================

// class _CartItemCard extends StatelessWidget {
//   final CartNotificationItem item;

//   const _CartItemCard({required this.item});

//   @override
//   Widget build(BuildContext context) {
//     final double price = _parsePrice(item.price);

//     final double totalPrice = price * item.quantity;

//     return Container(
//       padding: const EdgeInsets.all(12),

//       decoration: BoxDecoration(
//         color: Theme.of(context).cardColor,

//         borderRadius: BorderRadius.circular(16),

//         border: Border.all(color: Colors.grey.shade200),

//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: 0.04),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),

//       child: Row(
//         children: [
//           // ================================================================
//           // PRODUCT IMAGE
//           // ================================================================
//           Container(
//             height: 78,
//             width: 78,

//             clipBehavior: Clip.antiAlias,

//             decoration: BoxDecoration(
//               color: Theme.of(
//                 context,
//               ).colorScheme.primary.withValues(alpha: 0.08),

//               borderRadius: BorderRadius.circular(14),
//             ),

//             child: item.imageUrl.trim().isNotEmpty
//                 ? Image.network(
//                     item.imageUrl,

//                     fit: BoxFit.cover,

//                     errorBuilder: (context, error, stackTrace) {
//                       return Icon(
//                         Icons.shopping_bag_outlined,
//                         size: 36,
//                         color: Theme.of(context).colorScheme.primary,
//                       );
//                     },
//                   )
//                 : Icon(
//                     Icons.shopping_bag_outlined,
//                     size: 36,
//                     color: Theme.of(context).colorScheme.primary,
//                   ),
//           ),

//           const SizedBox(width: 12),

//           // ================================================================
//           // PRODUCT DETAILS
//           // ================================================================
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,

//               children: [
//                 Text(
//                   item.name,

//                   maxLines: 2,

//                   overflow: TextOverflow.ellipsis,

//                   style: const TextStyle(
//                     fontSize: 15,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),

//                 if (item.weight != null && item.weight!.trim().isNotEmpty) ...[
//                   const SizedBox(height: 5),

//                   Text(
//                     item.weight!,

//                     style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
//                   ),
//                 ],

//                 const SizedBox(height: 8),

//                 Row(
//                   children: [
//                     Text(
//                       '₹${totalPrice.toStringAsFixed(0)}',

//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w700,

//                         color: Theme.of(context).colorScheme.primary,
//                       ),
//                     ),

//                     if (item.originalPrice != null &&
//                         item.originalPrice!.trim().isNotEmpty) ...[
//                       const SizedBox(width: 8),

//                       Text(
//                         '₹${item.originalPrice}',

//                         style: TextStyle(
//                           fontSize: 12,

//                           color: Colors.grey.shade500,

//                           decoration: TextDecoration.lineThrough,
//                         ),
//                       ),
//                     ],
//                   ],
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(width: 8),

//           // ================================================================
//           // DELETE + QUANTITY
//           // ================================================================
//           Column(
//             children: [
//               IconButton(
//                 onPressed: () async {
//                   await CartService.removeItem(item);
//                 },

//                 icon: const Icon(Icons.delete_outline, size: 21),

//                 visualDensity: VisualDensity.compact,
//               ),

//               Container(
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey.shade300),

//                   borderRadius: BorderRadius.circular(8),
//                 ),

//                 child: Row(
//                   children: [
//                     // ------------------------------------------------------
//                     // MINUS
//                     // ------------------------------------------------------
//                     InkWell(
//                       onTap: () async {
//                         await CartService.decreaseItemQuantity(item);
//                       },

//                       child: const Padding(
//                         padding: EdgeInsets.all(5),

//                         child: Icon(Icons.remove, size: 16),
//                       ),
//                     ),

//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 7),

//                       child: Text(
//                         '${item.quantity}',

//                         style: const TextStyle(
//                           fontSize: 13,

//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),

//                     // ------------------------------------------------------
//                     // PLUS
//                     // ------------------------------------------------------
//                     InkWell(
//                       onTap: () async {
//                         await CartService.increaseItemQuantity(item);
//                       },

//                       child: const Padding(
//                         padding: EdgeInsets.all(5),

//                         child: Icon(Icons.add, size: 16),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ===========================================================================
// // CART SUMMARY
// // ===========================================================================

// class _CartSummary extends StatelessWidget {
//   final double subtotal;
//   final double delivery;
//   final double total;

//   const _CartSummary({
//     required this.subtotal,
//     required this.delivery,
//     required this.total,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),

//       decoration: BoxDecoration(
//         color: Theme.of(context).cardColor,

//         border: Border(top: BorderSide(color: Colors.grey.shade200)),
//       ),

//       child: Column(
//         children: [
//           _SummaryRow(
//             title: 'Subtotal',
//             value: '₹${subtotal.toStringAsFixed(0)}',
//           ),

//           const SizedBox(height: 8),

//           _SummaryRow(
//             title: 'Delivery',
//             value: '₹${delivery.toStringAsFixed(0)}',
//           ),

//           const SizedBox(height: 12),

//           Divider(color: Colors.grey.shade200),

//           const SizedBox(height: 10),

//           _SummaryRow(
//             title: 'Total',
//             value: '₹${total.toStringAsFixed(0)}',
//             isTotal: true,
//           ),

//           const SizedBox(height: 16),

//           SizedBox(
//             width: double.infinity,

//             height: 52,

//             child: ElevatedButton(
//               onPressed: () {
//                 // TODO:
//                 // Checkout route
//               },

//               style: ElevatedButton.styleFrom(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//               ),

//               child: Text(
//                 AppStrings.proceedToCheckout,
//                 style: const TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ===========================================================================
// // SUMMARY ROW
// // ===========================================================================

// class _SummaryRow extends StatelessWidget {
//   final String title;
//   final String value;
//   final bool isTotal;

//   const _SummaryRow({
//     required this.title,
//     required this.value,
//     this.isTotal = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,

//       children: [
//         Text(
//           title,

//           style: TextStyle(
//             fontSize: isTotal ? 17 : 14,

//             fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
//           ),
//         ),

//         Text(
//           value,

//           style: TextStyle(
//             fontSize: isTotal ? 18 : 14,

//             fontWeight: FontWeight.w700,
//           ),
//         ),
//       ],
//     );
//   }
// }

// // ===========================================================================
// // EMPTY CART
// // ===========================================================================

// class _EmptyCart extends StatelessWidget {
//   const _EmptyCart();

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(24),

//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,

//           children: [
//             Icon(
//               Icons.shopping_cart_outlined,

//               size: 80,

//               color: Colors.grey.shade400,
//             ),

//             const SizedBox(height: 18),

//             const Text(
//               'Your cart is empty',

//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
//             ),

//             const SizedBox(height: 8),

//             Text(
//               'Add products to your cart to continue.',

//               textAlign: TextAlign.center,

//               style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ===========================================================================
// // PRICE PARSER
// // ===========================================================================

// double _parsePrice(String value) {
//   final String cleaned = value
//       .replaceAll(',', '')
//       .replaceAll(RegExp(r'[^0-9.]'), '');

//   return double.tryParse(cleaned) ?? 0;
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/cart_notification_item.dart';
import '../../../../core/services/cart_service.dart';
import '../../../../core/widgets/app_app_bar.dart';

import '../../../account/presentation/widgets/app_string.dart';
import '../../../account/presentation/widgets/languange_constant.dart';

class CartPage extends ConsumerStatefulWidget {
  const CartPage({super.key});

  @override
  ConsumerState<CartPage> createState() =>
      _CartPageState();
}

class _CartPageState
    extends ConsumerState<CartPage> {
  late final Future<void>
      _cartInitializeFuture;

  @override
  void initState() {
    super.initState();

    _cartInitializeFuture =
        CartService.initialize();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return AnimatedBuilder(
      animation:
          AppLanguageConstants.instance,
      builder: (
        context,
        child,
      ) {
        return Scaffold(
          appBar: AppAppBar(
            title:
                AppStrings.cart,
            // automaticallyImplyLeading: true,
            centerTitle: true,
          ),

          body: SafeArea(
            child:
                FutureBuilder<void>(
              future:
                  _cartInitializeFuture,

              builder: (
                context,
                snapshot,
              ) {
                if (snapshot
                        .connectionState ==
                    ConnectionState
                        .waiting) {
                  return const Center(
                    child:
                        CircularProgressIndicator(),
                  );
                }

                return ValueListenableBuilder<
                    List<
                        CartNotificationItem>>(
                  valueListenable:
                      CartService.items,

                  builder: (
                    context,
                    cartItems,
                    child,
                  ) {
                    if (cartItems
                        .isEmpty) {
                      return const _EmptyCart();
                    }

                    final double
                        subtotal =
                        cartItems.fold<
                            double>(
                      0,
                      (
                        double total,
                        CartNotificationItem
                            item,
                      ) {
                        final double
                            price =
                            _parsePrice(
                          item.price,
                        );

                        return total +
                            (price *
                                item.quantity);
                      },
                    );

                    final double
                        delivery =
                        cartItems
                                .isEmpty
                            ? 0
                            : 40;

                    final double
                        total =
                        subtotal +
                            delivery;

                    return Column(
                      children: [
                        Expanded(
                          child:
                              ListView.separated(
                            padding:
                                const EdgeInsets
                                    .fromLTRB(
                              16,
                              16,
                              16,
                              10,
                            ),

                            itemCount:
                                cartItems
                                    .length,

                            separatorBuilder:
                                (
                              context,
                              index,
                            ) {
                              return const SizedBox(
                                height: 12,
                              );
                            },

                            itemBuilder:
                                (
                              context,
                              index,
                            ) {
                              final CartNotificationItem
                                  item =
                                  cartItems[
                                      index];

                              return _CartItemCard(
                                item:
                                    item,
                              );
                            },
                          ),
                        ),

                        _CartSummary(
                          subtotal:
                              subtotal,
                          delivery:
                              delivery,
                          total:
                              total,
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}

// ===========================================================================
// CART ITEM CARD
// ===========================================================================

class _CartItemCard
    extends StatelessWidget {
  final CartNotificationItem item;

  const _CartItemCard({
    required this.item,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final double price =
        _parsePrice(
      item.price,
    );

    final double totalPrice =
        price * item.quantity;

    return Container(
      padding:
          const EdgeInsets.all(
        12,
      ),

      decoration:
          BoxDecoration(
        color:
            Theme.of(context)
                .cardColor,

        borderRadius:
            BorderRadius.circular(
          16,
        ),

        border:
            Border.all(
          color:
              Colors.grey.shade200,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withValues(
              alpha: 0.04,
            ),
            blurRadius: 10,
            offset:
                const Offset(
              0,
              4,
            ),
          ),
        ],
      ),

      child: Row(
        children: [
          // ================================================================
          // PRODUCT IMAGE
          // ================================================================

          Container(
            height: 78,
            width: 78,

            clipBehavior:
                Clip.antiAlias,

            decoration:
                BoxDecoration(
              color:
                  Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(
                    alpha: 0.08,
                  ),

              borderRadius:
                  BorderRadius
                      .circular(
                14,
              ),
            ),

            child: item.imageUrl
                    .trim()
                    .isNotEmpty
                ? Image.network(
                    item.imageUrl,

                    fit:
                        BoxFit.cover,

                    errorBuilder:
                        (
                      context,
                      error,
                      stackTrace,
                    ) {
                      return Icon(
                        Icons
                            .shopping_bag_outlined,
                        size: 36,
                        color: Theme.of(
                          context,
                        )
                            .colorScheme
                            .primary,
                      );
                    },
                  )
                : Icon(
                    Icons
                        .shopping_bag_outlined,
                    size: 36,
                    color:
                        Theme.of(
                      context,
                    )
                            .colorScheme
                            .primary,
                  ),
          ),

          const SizedBox(
            width: 12,
          ),

          // ================================================================
          // PRODUCT DETAILS
          // ================================================================

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

              children: [
                Text(
                  item.name,

                  maxLines: 2,

                  overflow:
                      TextOverflow
                          .ellipsis,

                  style:
                      const TextStyle(
                    fontSize: 15,
                    fontWeight:
                        FontWeight
                            .w600,
                  ),
                ),

                if (item.weight !=
                        null &&
                    item.weight!
                        .trim()
                        .isNotEmpty) ...[
                  const SizedBox(
                    height: 5,
                  ),

                  Text(
                    item.weight!,

                    style:
                        TextStyle(
                      fontSize: 13,
                      color: Colors
                          .grey
                          .shade600,
                    ),
                  ),
                ],

                const SizedBox(
                  height: 8,
                ),

                Row(
                  children: [
                    Text(
                      '₹${totalPrice.toStringAsFixed(0)}',

                      style:
                          TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight
                                .w700,

                        color:
                            Theme.of(
                          context,
                        )
                                .colorScheme
                                .primary,
                      ),
                    ),

                    if (item.originalPrice !=
                            null &&
                        item
                            .originalPrice!
                            .trim()
                            .isNotEmpty) ...[
                      const SizedBox(
                        width: 8,
                      ),

                      Text(
                        '₹${item.originalPrice}',

                        style:
                            TextStyle(
                          fontSize: 12,

                          color: Colors
                              .grey
                              .shade500,

                          decoration:
                              TextDecoration
                                  .lineThrough,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(
            width: 8,
          ),

          // ================================================================
          // DELETE + QUANTITY
          // ================================================================

          Column(
            children: [
              IconButton(
                onPressed:
                    () async {
                  await CartService
                      .removeItem(
                    item,
                  );
                },

                icon:
                    const Icon(
                  Icons
                      .delete_outline,
                  size: 21,
                ),

                visualDensity:
                    VisualDensity
                        .compact,
              ),

              Container(
                decoration:
                    BoxDecoration(
                  border:
                      Border.all(
                    color: Colors
                        .grey
                        .shade300,
                  ),

                  borderRadius:
                      BorderRadius
                          .circular(
                    8,
                  ),
                ),

                child: Row(
                  children: [
                    // ------------------------------------------------------
                    // MINUS
                    // ------------------------------------------------------

                    InkWell(
                      onTap:
                          () async {
                        await CartService
                            .decreaseItemQuantity(
                          item,
                        );
                      },

                      child:
                          const Padding(
                        padding:
                            EdgeInsets
                                .all(
                          5,
                        ),

                        child: Icon(
                          Icons.remove,
                          size: 16,
                        ),
                      ),
                    ),

                    Padding(
                      padding:
                          const EdgeInsets
                              .symmetric(
                        horizontal:
                            7,
                      ),

                      child:
                          Text(
                        '${item.quantity}',

                        style:
                            const TextStyle(
                          fontSize:
                              13,

                          fontWeight:
                              FontWeight
                                  .w600,
                        ),
                      ),
                    ),

                    // ------------------------------------------------------
                    // PLUS
                    // ------------------------------------------------------

                    InkWell(
                      onTap:
                          () async {
                        await CartService
                            .increaseItemQuantity(
                          item,
                        );
                      },

                      child:
                          const Padding(
                        padding:
                            EdgeInsets
                                .all(
                          5,
                        ),

                        child: Icon(
                          Icons.add,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// CART SUMMARY
// ===========================================================================

class _CartSummary
    extends StatelessWidget {
  final double subtotal;
  final double delivery;
  final double total;

  const _CartSummary({
    required this.subtotal,
    required this.delivery,
    required this.total,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      padding:
          const EdgeInsets.fromLTRB(
        16,
        16,
        16,
        20,
      ),

      decoration:
          BoxDecoration(
        color:
            Theme.of(context)
                .cardColor,

        border:
            Border(
          top:
              BorderSide(
            color:
                Colors.grey
                    .shade200,
          ),
        ),
      ),

      child: Column(
        children: [
          _SummaryRow(
            title:
                'Subtotal',
            value:
                '₹${subtotal.toStringAsFixed(0)}',
          ),

          const SizedBox(
            height: 8,
          ),

          _SummaryRow(
            title:
                'Delivery',
            value:
                '₹${delivery.toStringAsFixed(0)}',
          ),

          const SizedBox(
            height: 12,
          ),

          Divider(
            color:
                Colors.grey
                    .shade200,
          ),

          const SizedBox(
            height: 10,
          ),

          _SummaryRow(
            title:
                'Total',
            value:
                '₹${total.toStringAsFixed(0)}',
            isTotal:
                true,
          ),

          const SizedBox(
            height: 16,
          ),

          SizedBox(
            width:
                double.infinity,

            height: 52,

            child:
                ElevatedButton(
              onPressed: () {
                // TODO:
                // Checkout route
              },

              style:
                  ElevatedButton
                      .styleFrom(
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius
                          .circular(
                    14,
                  ),
                ),
              ),

              child: Text(
                AppStrings
                    .proceedToCheckout,

                style:
                    const TextStyle(
                  fontSize: 15,

                  fontWeight:
                      FontWeight
                          .w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// SUMMARY ROW
// ===========================================================================

class _SummaryRow
    extends StatelessWidget {
  final String title;
  final String value;
  final bool isTotal;

  const _SummaryRow({
    required this.title,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment
              .spaceBetween,

      children: [
        Text(
          title,

          style:
              TextStyle(
            fontSize:
                isTotal
                    ? 17
                    : 14,

            fontWeight:
                isTotal
                    ? FontWeight
                        .w700
                    : FontWeight
                        .w500,
          ),
        ),

        Text(
          value,

          style:
              TextStyle(
            fontSize:
                isTotal
                    ? 18
                    : 14,

            fontWeight:
                FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

// ===========================================================================
// EMPTY CART
// ===========================================================================

class _EmptyCart
    extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(
    BuildContext context,
  ) {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(
          24,
        ),

        child: Column(
          mainAxisAlignment:
              MainAxisAlignment
                  .center,

          children: [
            Icon(
              Icons
                  .shopping_cart_outlined,

              size: 80,

              color:
                  Colors.grey
                      .shade400,
            ),

            const SizedBox(
              height: 18,
            ),

            const Text(
              'Your cart is empty',

              style:
                  TextStyle(
                fontSize: 20,

                fontWeight:
                    FontWeight
                        .w700,
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            Text(
              'Add products to your cart to continue.',

              textAlign:
                  TextAlign.center,

              style:
                  TextStyle(
                fontSize: 14,

                color:
                    Colors.grey
                        .shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===========================================================================
// PRICE PARSER
// ===========================================================================

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