import 'package:flutter/material.dart';

import '../../../../core/helpers/snackbar_helper.dart';
import '../../../../core/services/cart_service.dart';
import '../../../../core/services/wishlist_service.dart';
import '../../../../core/widgets/app_app_bar.dart';

import '../../../product/presentation/model/product_models.dart';
import '../../../product/presentation/pages/product_details_page.dart';
import '../../../product/presentation/widgets/product_name_image.dart';
import '../../../product/presentation/widgets/product_price_deliver_weight.dart';


// =============================================================================
// WISHLIST PAGE
// =============================================================================

class WishlistPage
    extends StatefulWidget {
  const WishlistPage({
    super.key,
  });

  @override
  State<WishlistPage> createState() =>
      _WishlistPageState();
}

class _WishlistPageState
    extends State<WishlistPage> {
  // ===========================================================================
  // GRID COLUMN COUNT
  // ===========================================================================

  int _getCrossAxisCount(
    double width,
  ) {
    if (width < 330) {
      return 1;
    }

    return 2;
  }

  // ===========================================================================
  // OPEN PRODUCT DETAILS
  // ===========================================================================

  void _openProductDetails(
    ProductItem product,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ProductDetailPage(
          key: ValueKey(
            product.id ??
                product.name,
          ),
          product: product,
        ),
      ),
    );
  }

  // ===========================================================================
  // SAFE VARIANT INDEX
  // ===========================================================================

  int _variantIndex(
    ProductItem product,
  ) {
    if (product.variants.isEmpty) {
      return 0;
    }

    if (product.selectedVariant <
            0 ||
        product.selectedVariant >=
            product.variants.length) {
      return 0;
    }

    return product.selectedVariant;
  }

  // ===========================================================================
  // ADD TO CART
  // ===========================================================================

  Future<void> _addToCart(
    ProductItem product,
  ) async {
    if (product.variants.isEmpty) {
      if (!mounted) {
        return;
      }

      FeedbackHelper.showError(
        context,
        'No product variant available',
      );

      return;
    }

    try {
      final int index =
          _variantIndex(product);

      final ProductVariant variant =
          product.variants[index];

      await CartService.postAddToCart(
        productId: product.id,
        productName: product.name,
        imageUrl: product.imageUrl,
        price:
            '₹${variant.price.toStringAsFixed(2)}',
        weight: variant.weight,

        // Wishlist page-e Qty selector nei.
        quantity: 1,
      );

      if (!mounted) {
        return;
      }

      FeedbackHelper.showSuccess(
        context,
        '${product.name} added to cart',
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      FeedbackHelper.showError(
        context,
        'Unable to add product to cart',
      );
    }
  }

  // ===========================================================================
  // DELETE
  // ===========================================================================

  void _deleteFromWishlist(
    ProductItem product,
  ) {
    WishlistService.remove(
      product,
    );

    FeedbackHelper.showSuccess(
      context,
      '${product.name} removed from wishlist',
    );
  }

  // ===========================================================================
  // WEIGHT SHEET
  // ===========================================================================

  void _showWeightSheet(
    ProductItem product,
  ) {
    if (product.variants.isEmpty) {
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor:
          const Color(
        0xfffafafa,
      ),
      isScrollControlled: true,
      shape:
          const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(
          top: Radius.circular(
            20,
          ),
        ),
      ),
      builder: (
        bottomSheetContext,
      ) {
        return SafeArea(
          child:
              SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.all(
                18,
              ),
              child: Column(
                mainAxisSize:
                    MainAxisSize.min,
                children: [
                  Text(
                    product.name,
                    textAlign:
                        TextAlign.center,
                    style:
                        const TextStyle(
                      fontSize: 17,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 14,
                  ),

                  ...List.generate(
                    product
                        .variants.length,
                    (
                      index,
                    ) {
                      final ProductVariant
                          item =
                          product.variants[
                              index];

                      final bool selected =
                          _variantIndex(
                                product,
                              ) ==
                              index;

                      return ListTile(
                        contentPadding:
                            EdgeInsets.zero,

                        onTap: () {
                          setState(() {
                            product.selectedVariant =
                                index;
                          });

                          Navigator.pop(
                            bottomSheetContext,
                          );
                        },

                        leading:
                            Container(
                          width: 22,
                          height: 22,
                          decoration:
                              BoxDecoration(
                            shape: BoxShape
                                .circle,
                            border:
                                Border.all(
                              color: selected
                                  ? const Color(
                                      0xFFE23F1C,
                                    )
                                  : Colors
                                      .grey,
                              width: 2,
                            ),
                          ),
                          child: selected
                              ? const Center(
                                  child:
                                      CircleAvatar(
                                    radius: 6,
                                    backgroundColor:
                                        Color(
                                      0xFFE23F1C,
                                    ),
                                  ),
                                )
                              : null,
                        ),

                        title: Text(
                          '${item.weight} - Rs ${item.price.toStringAsFixed(2)}',
                        ),
                      );
                    },
                  ),

                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor:
          const Color(
        0xfffafafa,
      ),

      // =======================================================================
      // APP BAR
      // =======================================================================

      appBar: const AppAppBar(
        title: 'Wishlist',
        centerTitle: true,
        automaticallyImplyLeading:
            true,
      ),

      // =======================================================================
      // BODY
      // =======================================================================

      body: ValueListenableBuilder<
          List<ProductItem>>(
        valueListenable:
            WishlistService
                .productsNotifier,
        builder: (
          context,
          products,
          child,
        ) {
          if (products.isEmpty) {
            return _buildEmptyWishlist();
          }

          return Column(
            children: [
              // ===============================================================
              // HEADER
              // ===============================================================

              Container(
                width:
                    double.infinity,
                height: 52,
                alignment:
                    Alignment.centerLeft,
                padding:
                    const EdgeInsets
                        .symmetric(
                  horizontal: 14,
                ),
                decoration:
                    const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom:
                        BorderSide(
                      color:
                          Color(
                        0xffeeeeee,
                      ),
                    ),
                  ),
                ),
                child: Text(
                  'Wishlist (${products.length})',
                  style:
                      const TextStyle(
                    fontSize: 14,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ),

              // ===============================================================
              // GRID
              // ===============================================================

              Expanded(
                child: LayoutBuilder(
                  builder: (
                    context,
                    constraints,
                  ) {
                    final int
                        crossAxisCount =
                        _getCrossAxisCount(
                      constraints
                          .maxWidth,
                    );

                    return GridView.builder(
                      padding:
                          const EdgeInsets
                              .only(
                        left: 7,
                        right: 7,
                        top: 8,
                        bottom: 20,
                      ),

                      gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            crossAxisCount,
                        crossAxisSpacing:
                            7,
                        mainAxisSpacing:
                            8,

                        // ProductList-er moto height.
                        mainAxisExtent:
                            385,
                      ),

                      itemCount:
                          products.length,

                      itemBuilder: (
                        context,
                        index,
                      ) {
                        final ProductItem
                            product =
                            products[
                                index];

                        return _WishlistProductCard(
                          key: ValueKey(
                            product.id ??
                                product
                                    .name,
                          ),
                          product:
                              product,

                          onTap: () {
                            _openProductDetails(
                              product,
                            );
                          },

                          onWeightTap:
                              () {
                            _showWeightSheet(
                              product,
                            );
                          },

                          onDelete: () {
                            _deleteFromWishlist(
                              product,
                            );
                          },

                          onAdd: () {
                            _addToCart(
                              product,
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ===========================================================================
  // EMPTY WISHLIST
  // ===========================================================================

  Widget _buildEmptyWishlist() {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets
                .symmetric(
          horizontal: 30,
        ),
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            Container(
              width: 86,
              height: 86,
              alignment:
                  Alignment.center,
              decoration:
                  const BoxDecoration(
                color:
                    Color(
                  0xFFFFF0ED,
                ),
                shape:
                    BoxShape.circle,
              ),
              child:
                  const Icon(
                Icons
                    .favorite_border_rounded,
                size: 42,
                color:
                    Color(
                  0xFFE23F1C,
                ),
              ),
            ),

            const SizedBox(
              height: 18,
            ),

            const Text(
              'Your wishlist is empty',
              textAlign:
                  TextAlign.center,
              style:
                  TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.w700,
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            const Text(
              'Tap the heart icon on a product to save it here.',
              textAlign:
                  TextAlign.center,
              style:
                  TextStyle(
                fontSize: 13,
                color:
                    Colors.grey,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// WISHLIST PRODUCT CARD
// =============================================================================

class _WishlistProductCard
    extends StatelessWidget {
  final ProductItem product;

  final VoidCallback onTap;

  final VoidCallback onWeightTap;

  final VoidCallback onDelete;

  final VoidCallback onAdd;

  const _WishlistProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onWeightTap,
    required this.onDelete,
    required this.onAdd,
  });

  int _variantIndex() {
    if (product.variants.isEmpty) {
      return 0;
    }

    if (product.selectedVariant <
            0 ||
        product.selectedVariant >=
            product.variants.length) {
      return 0;
    }

    return product.selectedVariant;
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    if (product.variants.isEmpty) {
      return const SizedBox.shrink();
    }

    final ProductVariant
        selectedVariant =
        product.variants[
            _variantIndex()];

    return Container(
      clipBehavior:
          Clip.antiAlias,

      decoration:
          BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          5,
        ),

        border:
            Border.all(
          color:
              const Color(
            0xffeeeeee,
          ),
        ),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black
                    .withValues(
              alpha: 0.04,
            ),
            blurRadius: 5,
            offset:
                const Offset(
              0,
              2,
            ),
          ),
        ],
      ),

      child: Column(
        children: [
          // ===================================================================
          // IMAGE + NAME + RATING
          // ===================================================================

          InkWell(
            onTap: onTap,
            child: Column(
              children: [
                ProductImageHeader(
                  imageUrl:
                      product.imageUrl,
                  name:
                      product.name,

                  // Exact product pass korchi.
                  product:
                      product,

                  // Wishlist page-e heart ar dorkar nei.
                  showFavourite:
                      false,
                ),

                SizedBox(
                  height: 25,
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .center,
                    children:
                        List.generate(
                      5,
                      (
                        index,
                      ) {
                        final double
                            rating =
                            product
                                .rating;

                        if (rating >=
                            index +
                                1) {
                          return const Icon(
                            Icons.star,
                            size: 15,
                            color: Colors
                                .orange,
                          );
                        }

                        if (rating >=
                            index +
                                0.5) {
                          return const Icon(
                            Icons
                                .star_half,
                            size: 15,
                            color: Colors
                                .orange,
                          );
                        }

                        return const Icon(
                          Icons
                              .star_border,
                          size: 15,
                          color: Colors
                              .orange,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ===================================================================
          // WEIGHT + PRICE + DELIVERY
          // ===================================================================

          ProductPriceInfo(
            weight:
                selectedVariant
                    .weight,
            price:
                selectedVariant
                    .price,
            deliveryDays:
                product
                    .deliveryDays,
            onWeightTap:
                onWeightTap,
          ),

          const Spacer(),

          // ===================================================================
          // DELETE + ADD BUTTON
          // ===================================================================

          SizedBox(
            height: 38,
            child: Padding(
              padding:
                  const EdgeInsets
                      .fromLTRB(
                7,
                3,
                7,
                5,
              ),
              child: Row(
                children: [
                  // -----------------------------------------------------------
                  // DELETE LEFT
                  // -----------------------------------------------------------

                  Expanded(
                    child:
                        SizedBox(
                      height: 30,
                      child:
                          OutlinedButton(
                        onPressed:
                            onDelete,

                        style:
                            OutlinedButton
                                .styleFrom(
                          foregroundColor:
                              const Color(
                            0xFFE23F1C,
                          ),
                          side:
                              const BorderSide(
                            color:
                                Color(
                              0xFFE23F1C,
                            ),
                          ),
                          minimumSize:
                              Size.zero,
                          padding:
                              const EdgeInsets
                                  .symmetric(
                            horizontal:
                                4,
                          ),
                          tapTargetSize:
                              MaterialTapTargetSize
                                  .shrinkWrap,
                          visualDensity:
                              VisualDensity
                                  .compact,
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius
                                    .circular(
                              4,
                            ),
                          ),
                        ),

                        child:
                            const FittedBox(
                          child: Row(
                            children: [
                              Icon(
                                Icons
                                    .delete_outline,
                                size: 14,
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Text(
                                'DELETE',
                                style:
                                    TextStyle(
                                  fontSize:
                                      10,
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    width: 6,
                  ),

                  // -----------------------------------------------------------
                  // ADD RIGHT
                  // -----------------------------------------------------------

                  Expanded(
                    child:
                        SizedBox(
                      height: 30,
                      child:
                          ElevatedButton(
                        onPressed:
                            onAdd,

                        style:
                            ElevatedButton
                                .styleFrom(
                          backgroundColor:
                              const Color(
                            0xFFE23F1C,
                          ),
                          foregroundColor:
                              Colors.white,
                          minimumSize:
                              Size.zero,
                          padding:
                              const EdgeInsets
                                  .symmetric(
                            horizontal:
                                4,
                          ),
                          tapTargetSize:
                              MaterialTapTargetSize
                                  .shrinkWrap,
                          visualDensity:
                              VisualDensity
                                  .compact,
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius
                                    .circular(
                              4,
                            ),
                          ),
                        ),

                        child:
                            const FittedBox(
                          child: Row(
                            children: [
                              Icon(
                                Icons
                                    .shopping_cart_outlined,
                                size: 14,
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Text(
                                'ADD',
                                style:
                                    TextStyle(
                                  fontSize:
                                      10,
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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