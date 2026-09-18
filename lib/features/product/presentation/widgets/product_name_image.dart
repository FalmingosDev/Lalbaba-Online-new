


// import 'package:flutter/material.dart';
// import '../../../../core/widgets/app_shimmer.dart';

// // ==============================================================================
// // PRODUCT IMAGE HEADER
// // ==============================================================================

// class ProductImageHeader
//     extends StatefulWidget {
//   final String imageUrl;
//   final String name;

//   const ProductImageHeader({
//     super.key,
//     required this.imageUrl,
//     required this.name,
//   });

//   @override
//   State<ProductImageHeader>
//       createState() =>
//           _ProductImageHeaderState();
// }

// class _ProductImageHeaderState
//     extends State<ProductImageHeader> {
//   bool favourite = false;

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         final double cardWidth =
//             constraints.maxWidth;

//         double imageHeight;

//         if (cardWidth < 160) {
//           imageHeight = 140;
//         } else if (cardWidth < 220) {
//           imageHeight = 158;
//         } else {
//           imageHeight = 175;
//         }

//         return Column(
//           children: [
//             // ============================================
//             // IMAGE
//             // ============================================

//             SizedBox(
//               height: imageHeight,
//               width: double.infinity,
//               child: Stack(
//                 children: [
//                   Positioned.fill(
//                     child: Image.network(
//                       widget.imageUrl,
//                       fit: BoxFit.contain,
//                       loadingBuilder: (
//                         context,
//                         child,
//                         loadingProgress,
//                       ) {
//                         if (loadingProgress ==
//                             null) {
//                           return child;
//                         }

//                         return AppShimmer(
//                           width:
//                               double.infinity,
//                           height:
//                               imageHeight,
//                           radius: 0,
//                         );
//                       },
//                       errorBuilder: (
//                         context,
//                         error,
//                         stackTrace,
//                       ) {
//                         return const Center(
//                           child: Icon(
//                             Icons
//                                 .broken_image,
//                             color:
//                                 Colors.grey,
//                           ),
//                         );
//                       },
//                     ),
//                   ),

//                   // ========================================
//                   // FAVOURITE
//                   // ========================================

//                   Positioned(
//                     top: 7,
//                     right: 7,
//                     child:
//                         GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           favourite =
//                               !favourite;
//                         });
//                       },
//                       child: Icon(
//                         favourite
//                             ? Icons.favorite
//                             : Icons
//                                 .favorite_border,
//                         color: favourite
//                             ? const Color(
//                                 0xFFE23F1C,
//                               )
//                             : Colors.grey,
//                         size: 23,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // ============================================
//             // PRODUCT NAME
//             // ============================================

//             SizedBox(
//               height: 34,
//               width: double.infinity,
//               child: Padding(
//                 padding:
//                     const EdgeInsets
//                         .symmetric(
//                   horizontal: 7,
//                 ),
//                 child: Align(
//                   alignment:
//                       Alignment.centerLeft,
//                   child: Text(
//                     widget.name,
//                     maxLines: 2,
//                     overflow:
//                         TextOverflow.ellipsis,
//                     style:
//                         const TextStyle(
//                       fontSize: 13,
//                       height: 1.15,
//                       fontWeight:
//                           FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';

import '../../../../core/services/wishlist_service.dart';
import '../../../../core/widgets/app_shimmer.dart';

import '../model/product_models.dart';

import 'product_details_widget/product_repository.dart';

// =============================================================================
// PRODUCT IMAGE HEADER
// =============================================================================

class ProductImageHeader
    extends StatelessWidget {
  final String imageUrl;

  final String name;

  // Product directly pass korle exact product use hobe.
  // Existing pages-e product pass na korleo
  // ProductRepository theke resolve hobe.
  final ProductItem? product;

  // Wishlist page-e heart hide korar jonno.
  final bool showFavourite;

  const ProductImageHeader({
    super.key,
    required this.imageUrl,
    required this.name,
    this.product,
    this.showFavourite = true,
  });

  // ===========================================================================
  // FIND PRODUCT
  // ===========================================================================

  ProductItem? _resolveProduct() {
    if (product != null) {
      return product;
    }

    // First exact image + name matching.
    for (final ProductItem item
        in ProductRepository.allProducts) {
      if (item.name == name &&
          item.imageUrl == imageUrl) {
        return item;
      }
    }

    // Fallback name matching.
    for (final ProductItem item
        in ProductRepository.allProducts) {
      if (item.name.trim().toLowerCase() ==
          name.trim().toLowerCase()) {
        return item;
      }
    }

    return null;
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    final ProductItem? resolvedProduct =
        _resolveProduct();

    return LayoutBuilder(
      builder: (
        context,
        constraints,
      ) {
        final double cardWidth =
            constraints.maxWidth;

        double imageHeight;

        if (cardWidth < 160) {
          imageHeight = 140;
        } else if (cardWidth < 220) {
          imageHeight = 158;
        } else {
          imageHeight = 175;
        }

        return Column(
          children: [
            // ===============================================================
            // IMAGE
            // ===============================================================

            SizedBox(
              height: imageHeight,
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.contain,

                      // =====================================================
                      // LOADING
                      // =====================================================

                      loadingBuilder: (
                        context,
                        child,
                        loadingProgress,
                      ) {
                        if (loadingProgress ==
                            null) {
                          return child;
                        }

                        return AppShimmer(
                          width:
                              double.infinity,
                          height:
                              imageHeight,
                          radius: 0,
                        );
                      },

                      // =====================================================
                      // ERROR
                      // =====================================================

                      errorBuilder: (
                        context,
                        error,
                        stackTrace,
                      ) {
                        return const Center(
                          child: Icon(
                            Icons
                                .broken_image_outlined,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),

                  // =========================================================
                  // WISHLIST HEART
                  // =========================================================

                  if (showFavourite &&
                      resolvedProduct !=
                          null)
                    Positioned(
                      top: 7,
                      right: 7,
                      child:
                          ValueListenableBuilder<
                              List<
                                  ProductItem>>(
                        valueListenable:
                            WishlistService
                                .productsNotifier,
                        builder: (
                          context,
                          wishlist,
                          child,
                        ) {
                          final bool favourite =
                              WishlistService
                                  .contains(
                            resolvedProduct,
                          );

                          return Material(
                            color:
                                Colors.transparent,
                            child: InkWell(
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                30,
                              ),
                              onTap: () {
                                final bool
                                    added =
                                    WishlistService
                                        .toggle(
                                  resolvedProduct,
                                );

                                ScaffoldMessenger
                                        .of(
                                  context,
                                )
                                    .hideCurrentSnackBar();

                                ScaffoldMessenger
                                        .of(
                                  context,
                                )
                                    .showSnackBar(
                                  SnackBar(
                                    duration:
                                        const Duration(
                                      milliseconds:
                                          1200,
                                    ),
                                    content: Text(
                                      added
                                          ? '$name added to wishlist'
                                          : '$name removed from wishlist',
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: 34,
                                height: 34,
                                alignment:
                                    Alignment
                                        .center,
                                decoration:
                                    BoxDecoration(
                                  color: Colors
                                      .white
                                      .withValues(
                                    alpha:
                                        0.92,
                                  ),
                                  shape: BoxShape
                                      .circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors
                                          .black
                                          .withValues(
                                        alpha:
                                            0.08,
                                      ),
                                      blurRadius:
                                          5,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  favourite
                                      ? Icons
                                          .favorite
                                      : Icons
                                          .favorite_border,
                                  color: favourite
                                      ? const Color(
                                          0xFFE23F1C,
                                        )
                                      : Colors
                                          .grey,
                                  size: 22,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),

            // ===============================================================
            // PRODUCT NAME
            // ===============================================================

            SizedBox(
              height: 34,
              width: double.infinity,
              child: Padding(
                padding:
                    const EdgeInsets
                        .symmetric(
                  horizontal: 7,
                ),
                child: Align(
                  alignment:
                      Alignment.centerLeft,
                  child: Text(
                    name,
                    maxLines: 2,
                    overflow:
                        TextOverflow.ellipsis,
                    style:
                        const TextStyle(
                      fontSize: 13,
                      height: 1.15,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}