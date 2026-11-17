import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lalbaba_online/new_app/new_constant_text_styles.dart';

import '../app/router/route_names.dart';
import '../core/services/cart_notification_item.dart';
import '../core/services/cart_service.dart';
import '../core/services/wishlist_service.dart';
import '../features/product/presentation/model/product_models.dart';
import 'constantcolour.dart';

class NewWishlistPage extends StatefulWidget {
  const NewWishlistPage({super.key});

  @override
  State<NewWishlistPage> createState() => _NewWishlistPageState();
}

class _NewWishlistPageState extends State<NewWishlistPage> {
  late final Future<void> _cartInitializeFuture;

  @override
  void initState() {
    super.initState();
    _cartInitializeFuture = CartService.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HomeColors.background,
      appBar: AppBar(
        backgroundColor: HomeColors.secondary,
        foregroundColor: HomeColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text('My Wishlist', style: HomeTextStyles.appBarTitle),
      ),
      body: FutureBuilder<void>(
        future: _cartInitializeFuture,
        builder: (context, cartSnapshot) {
          if (cartSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: HomeColors.secondary),
            );
          }
          if (cartSnapshot.hasError) {
            return Center(
              child: Text(
                'Unable to load your basket: ${cartSnapshot.error}',
                style: HomeTextStyles.body.copyWith(
                  color: HomeColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }

          return ValueListenableBuilder<List<ProductItem>>(
            valueListenable: WishlistService.productsNotifier,
            builder: (context, products, child) {
              if (products.isEmpty) return const _EmptyWishlist();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                    child: Text(
                      '${products.length} ${products.length == 1 ? 'item' : 'items'} saved',
                      style: HomeTextStyles.bodySmall.copyWith(
                        color: HomeColors.textSecondary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final columns = constraints.maxWidth < 360 ? 1 : 2;
                        return GridView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: columns,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                mainAxisExtent: 305,
                              ),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            return _WishlistProductCard(
                              product: products[index],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _WishlistProductCard extends StatelessWidget {
  const _WishlistProductCard({required this.product});

  final ProductItem product;

  ProductVariant? get _selectedVariant {
    if (product.variants.isEmpty) return null;
    final index = product.selectedVariant
        .clamp(0, product.variants.length - 1)
        .toInt();
    return product.variants[index];
  }

  bool _isInCart(List<CartNotificationItem> cartItems, ProductVariant variant) {
    final productId = product.id?.trim();
    final weight = variant.weight.trim().toLowerCase();
    return cartItems.any((item) {
      final sameProduct = productId != null && productId.isNotEmpty
          ? item.productId?.trim() == productId
          : item.name.trim().toLowerCase() == product.name.trim().toLowerCase();
      return sameProduct && (item.weight?.trim().toLowerCase() ?? '') == weight;
    });
  }

  @override
  Widget build(BuildContext context) {
    final variant = _selectedVariant;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: HomeColors.surface,
        border: Border.all(color: HomeColors.border),
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      color: HomeColors.background,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(8),
                      child: product.imageUrl.trim().isEmpty
                          ? const Icon(
                              Icons.image_not_supported_outlined,
                              size: 42,
                              color: HomeColors.textHint,
                            )
                          : Image.network(
                              product.imageUrl,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                    Icons.image_not_supported_outlined,
                                    size: 42,
                                    color: HomeColors.textHint,
                                  ),
                            ),
                    ),
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: Material(
                    color: HomeColors.surface,
                    shape: const CircleBorder(),
                    child: IconButton(
                      tooltip: 'Remove from wishlist',
                      visualDensity: VisualDensity.compact,
                      onPressed: () => WishlistService.remove(product),
                      icon: const Icon(
                        Icons.delete_outline,
                        color: HomeColors.error,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            product.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: HomeTextStyles.productCardTitle.copyWith(
              color: HomeColors.textPrimary,
            ),
          ),
          const SizedBox(height: 3),
          if (variant != null)
            Row(
              children: [
                Expanded(
                  child: Text(
                    variant.weight,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: HomeTextStyles.caption.copyWith(
                      color: HomeColors.textSecondary,
                    ),
                  ),
                ),
                Text(
                  '₹${variant.price.toStringAsFixed(0)}',
                  style: HomeTextStyles.bodyEmphasis.copyWith(
                    color: HomeColors.secondary,
                  ),
                ),
              ],
            )
          else
            Text(
              'No variant available',
              style: HomeTextStyles.caption.copyWith(
                color: HomeColors.textSecondary,
              ),
            ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 38,
            child: ValueListenableBuilder<List<CartNotificationItem>>(
              valueListenable: CartService.items,
              builder: (context, cartItems, child) {
                final inCart = variant != null && _isInCart(cartItems, variant);
                return ElevatedButton.icon(
                  onPressed: variant == null
                      ? null
                      : inCart
                      ? () => context.push(RouteNames.cart)
                      : () => _addToCart(context, variant),
                  icon: Icon(
                    inCart
                        ? Icons.shopping_basket
                        : Icons.shopping_basket_outlined,
                    size: 17,
                  ),
                  label: Text(inCart ? 'Go to basket' : 'Add to basket'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HomeColors.secondary,
                    foregroundColor: HomeColors.white,
                    disabledBackgroundColor: HomeColors.disabledBackground,
                    disabledForegroundColor: HomeColors.textHint,
                    elevation: 0,
                    textStyle: HomeTextStyles.compactButton,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addToCart(BuildContext context, ProductVariant variant) async {
    try {
      await CartService.postAddToCart(
        productId: product.id,
        productName: product.name,
        imageUrl: product.imageUrl,
        price: '₹${variant.price.toStringAsFixed(2)}',
        originalPrice: variant.mrp == null
            ? null
            : '₹${variant.mrp!.toStringAsFixed(2)}',
        weight: variant.weight,
      );
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text('${product.name} added to cart')),
        );
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Unable to add product to cart')),
        );
    }
  }
}

class _EmptyWishlist extends StatelessWidget {
  const _EmptyWishlist();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 116,
              height: 116,
              decoration: const BoxDecoration(
                color: HomeColors.secondaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_border,
                color: HomeColors.secondary,
                size: 58,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Found something you like?',
              textAlign: TextAlign.center,
              style: HomeTextStyles.sectionTitle.copyWith(
                color: HomeColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add it to your wishlist now and to your basket later.',
              textAlign: TextAlign.center,
              style: HomeTextStyles.body.copyWith(
                color: HomeColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).maybePop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: HomeColors.secondary,
                  foregroundColor: HomeColors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Continue shopping',
                  style: HomeTextStyles.button,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
