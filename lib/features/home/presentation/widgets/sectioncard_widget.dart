



// import 'package:flutter/material.dart';

// import 'product_card_widget.dart';

// class SectionCardWidget extends StatelessWidget {
//   final String title;
//   final List<Map<String, dynamic>> products;

//   final void Function(Map<String, dynamic> product)?
//       onProductTap;

//   final void Function(Map<String, dynamic> product)?
//       onAddToCart;

//   final VoidCallback? onViewAllTap;

//   const SectionCardWidget({
//     super.key,
//     required this.title,
//     required this.products,
//     this.onProductTap,
//     this.onAddToCart,
//     this.onViewAllTap,
//   });

//   static const double _outerMargin = 8;
//   static const double _railPadding = 14;
//   static const double _cardGap = 10;

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (
//         context,
//         constraints,
//       ) {
//         final double availableWidth =
//             constraints.maxWidth > 0
//                 ? constraints.maxWidth
//                 : MediaQuery.of(context).size.width;

//         final double cardWidth =
//             (availableWidth -
//                     (_outerMargin * 2) -
//                     (_railPadding * 2) -
//                     _cardGap) /
//                 2;

//         return Container(
//           margin: const EdgeInsets.symmetric(
//             horizontal: _outerMargin,
//             vertical: 6,
//           ),

//           padding: const EdgeInsets.symmetric(
//             vertical: 14,
//           ),

//           decoration: BoxDecoration(
//             color: Colors.white,

//             borderRadius: BorderRadius.circular(4),

//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withValues(
//                   alpha: 0.06,
//                 ),
//                 blurRadius: 8,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),

//           child: Column(
//             children: [
//               // =================================================================
//               // HEADER
//               // =================================================================

//               Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: _railPadding,
//                 ),

//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Text(
//                         title,

//                         style: const TextStyle(
//                           fontSize: 17,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),

//                     // =============================================================
//                     // VIEW ALL
//                     // =============================================================

//                     InkWell(
//                       borderRadius: BorderRadius.circular(6),

//                       onTap: onViewAllTap,

//                       child: const Padding(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 4,
//                           vertical: 4,
//                         ),

//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,

//                           children: [
//                             Text(
//                               'View All',

//                               style: TextStyle(
//                                 fontSize: 13,
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.black,
//                               ),
//                             ),

//                             SizedBox(width: 3),

//                             Icon(
//                               Icons.chevron_right,
//                               size: 18,
//                               color: Colors.black,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 8),

//               // =================================================================
//               // PRODUCT LIST
//               // =================================================================

//               SizedBox(
//                 height: 250,

//                 child: ListView.separated(
//                   scrollDirection: Axis.horizontal,

//                   padding: const EdgeInsets.symmetric(
//                     horizontal: _railPadding,
//                   ),

//                   itemCount: products.length,

//                   separatorBuilder: (
//                     context,
//                     index,
//                   ) {
//                     return const SizedBox(
//                       width: _cardGap,
//                     );
//                   },

//                   itemBuilder: (
//                     context,
//                     index,
//                   ) {
//                     final product = products[index];

//                     return ProductCardWidget(
//                       name: product['name'] ?? '',
//                       imageUrl: product['imageUrl'] ?? '',
//                       price: product['price'] ?? '',
//                       originalPrice:
//                           product['originalPrice'] ?? '',
//                       discountLabel:
//                           product['discountLabel'] ?? '',
//                       rating:
//                           (product['rating'] ?? 0).toDouble(),

//                       showPriceAndRating: true,

//                       width: cardWidth,

//                       onTap: () {
//                         onProductTap?.call(product);
//                       },

//                       onAddToCart: () {
//                         onAddToCart?.call(product);
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';

import 'product_card_widget.dart';

class SectionCardWidget extends StatelessWidget {
  final String title;

  final List<Map<String, dynamic>> products;

  final void Function(
    Map<String, dynamic> product,
  )? onProductTap;

  final void Function(
    Map<String, dynamic> product,
  )? onAddToCart;

  final VoidCallback? onViewAllTap;

  const SectionCardWidget({
    super.key,
    required this.title,
    required this.products,
    this.onProductTap,
    this.onAddToCart,
    this.onViewAllTap,
  });

  static const double _outerMargin = 8;
  static const double _railPadding = 14;
  static const double _cardGap = 10;

  // Minimum width-er niche product card ke
  // squeeze korte debo na.
  static const double _minCardWidth = 150;

  // Boro phone-e card khub beshi wide-o hobe na.
  static const double _maxCardWidth = 210;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (
        context,
        constraints,
      ) {
        final double screenWidth =
            constraints.maxWidth > 0
                ? constraints.maxWidth
                : MediaQuery.sizeOf(context).width;

        // Container margin + inner list padding bad diye
        // actual product area calculate kora hocche.
        final double usableWidth =
            screenWidth -
            (_outerMargin * 2) -
            (_railPadding * 2);

        final double twoCardWidth =
            (usableWidth - _cardGap) / 2;

        // Small phone:
        // card 150px-er niche jabe na.
        //
        // Normal phone:
        // available width onujayi 2ta card fit korbe.
        //
        // Big phone:
        // maximum 210px.
        final double cardWidth = twoCardWidth
            .clamp(
              _minCardWidth,
              _maxCardWidth,
            )
            .toDouble();

        // Card width-er sathe image height-o
        // ektu responsive.
        final double imageHeight =
            (cardWidth * 0.70)
                .clamp(
                  100.0,
                  125.0,
                )
                .toDouble();

        return Container(
          margin: const EdgeInsets.symmetric(
            horizontal: _outerMargin,
            vertical: 6,
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 14,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: 0.06,
                ),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              // =============================================================
              // HEADER
              // =============================================================

              Padding(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: _railPadding,
                ),
                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        softWrap: true,
                        style:
                            const TextStyle(
                          fontSize: 17,
                          fontWeight:
                              FontWeight.bold,
                          color: Colors.black,
                          height: 1.2,
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    // =======================================================
                    // VIEW ALL
                    // =======================================================

                    Material(
                      color:
                          Colors.transparent,
                      child: InkWell(
                        borderRadius:
                            BorderRadius.circular(
                          6,
                        ),
                        onTap: onViewAllTap,
                        child: const Padding(
                          padding:
                              EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 6,
                          ),
                          child: Row(
                            mainAxisSize:
                                MainAxisSize.min,
                            children: [
                              Text(
                                'View All',
                                maxLines: 1,
                                style:
                                    TextStyle(
                                  fontSize: 13,
                                  fontWeight:
                                      FontWeight
                                          .w600,
                                  color:
                                      Colors.black,
                                ),
                              ),
                              SizedBox(width: 2),
                              Icon(
                                Icons
                                    .chevron_right,
                                size: 18,
                                color:
                                    Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // =============================================================
              // PRODUCT LIST
              // =============================================================

              SizedBox(
                height: 264,
                child: ListView.separated(
                  scrollDirection:
                      Axis.horizontal,

                  physics:
                      const BouncingScrollPhysics(),

                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: _railPadding,
                  ),

                  itemCount: products.length,

                  separatorBuilder:
                      (
                    contextutt,
                    index,
                  ) {
                    return const SizedBox(
                      width: _cardGap,
                    );
                  },

                  itemBuilder:
                      (
                    context,
                    index,
                  ) {
                    final Map<String, dynamic>
                        product =
                        products[index];

                    final dynamic ratingValue =
                        product['rating'];

                    final double rating =
                        ratingValue is num
                            ? ratingValue
                                .toDouble()
                            : 0;

                    return ProductCardWidget(
                      name:
                          product['name']
                                  ?.toString() ??
                              '',

                      imageUrl:
                          product['imageUrl']
                                  ?.toString() ??
                              '',

                      price:
                          product['price']
                                  ?.toString() ??
                              '',

                      originalPrice:
                          product[
                                  'originalPrice']
                              ?.toString(),

                      discountLabel:
                          product[
                                  'discountLabel']
                              ?.toString(),

                      rating: rating,

                      showPriceAndRating:
                          true,

                      width: cardWidth,

                      imageHeight:
                          imageHeight,

                      onTap: () {
                        onProductTap?.call(
                          product,
                        );
                      },

                      // Parent-e add callback na thakle
                      // button-o show korbe na.
                      onAddToCart:
                          onAddToCart == null
                              ? null
                              : () {
                                  onAddToCart!(
                                    product,
                                  );
                                },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}