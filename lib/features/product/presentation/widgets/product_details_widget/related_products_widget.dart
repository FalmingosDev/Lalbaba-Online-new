import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../core/services/cart_service.dart';
import '../../model/product_models.dart';
import '../../pages/product_details_page.dart';
import '../../pages/product_list_page.dart';



// ==============================================================================
// RELATED PRODUCTS ("You May Also like")
// Reuses the exact same ProductCard widget shown on the product list page,
// so styling stays perfectly consistent between list and detail screens.
// ==============================================================================

class RelatedProductsWidget extends StatelessWidget {
  final List<ProductItem> products;

  const RelatedProductsWidget({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              'You May Also like',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),

          const SizedBox(height: 12),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              mainAxisExtent: 300,
            ),
            itemBuilder: (context, index) {
              final ProductItem product = products[index];

              return ProductCard(
                product: product,
                onWeightTap: () {
                  // Weight/variant switching for related cards mirrors the
                  // list page's own bottom-sheet - nothing extra needed
                  // here since ProductCard already owns that flow.
                },
                onAddToCart: (quantity) async {
                  await CartService.postAddToCart(
                    productId: product.id,
                    quantity: quantity,
                  );

                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text('${product.name} added to cart'),
                        duration: const Duration(milliseconds: 900),
                      ),
                    );
                },
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailPage(product: product),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
