import 'package:flutter/material.dart';
import 'package:lalbaba_online/new_app/constant/new_constant_checkout_page.dart';

import '../../core/services/cart_notification_item.dart';
import '../../core/services/cart_service.dart';
import '../../core/services/wishlist_service.dart';
import '../../features/product/presentation/model/product_models.dart';
import '../../features/product/presentation/widgets/product_details_widget/product_repository.dart';

import '../constant/new_back_to_top_button.dart';
import '../constant/constantcolour.dart';
import '../constant/new_constant_text_styles.dart';
import '../new_auth/new_login.dart';
import '../product/new_product_details.dart';
import 'new_wishlist.dart';

// ============================================================
// NEW CART PAGE
// ============================================================

class NewCartPage extends StatefulWidget {
  final bool showBackButton;
  final VoidCallback? onBack;

  const NewCartPage({super.key, this.showBackButton = false, this.onBack});

  @override
  State<NewCartPage> createState() => _NewCartPageState();
}

class _NewCartPageState extends State<NewCartPage> {
  static const double _backToTopThreshold = 500;

  late final Future<void> _cartInitializeFuture;
  late final ScrollController _scrollController;

  bool _showBackToTop = false;

  @override
  void initState() {
    super.initState();

    _cartInitializeFuture = CartService.initialize();

    _scrollController = ScrollController()..addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();

    super.dispose();
  }

  // ==========================================================
  // BACK TO TOP
  // ==========================================================

  void _handleScroll() {
    final shouldShow =
        _scrollController.hasClients &&
        _scrollController.offset > _backToTopThreshold;

    if (shouldShow != _showBackToTop) {
      setState(() => _showBackToTop = shouldShow);
    }
  }

  void _scrollToTop() {
    if (!_scrollController.hasClients) return;

    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
    );
  }

  void _openProductDetails(CartNotificationItem item) {
    ProductItem? catalogProduct = ProductRepository.findById(item.productId);
    final normalizedName = item.name.trim().toLowerCase();
    catalogProduct ??= ProductRepository.allProducts
        .where((product) => product.name.trim().toLowerCase() == normalizedName)
        .firstOrNull;

    final variants = List<ProductVariant>.from(
      catalogProduct?.variants ?? const <ProductVariant>[],
    );
    final weight = item.weight?.trim();
    var selectedVariant = weight == null || weight.isEmpty
        ? -1
        : variants.indexWhere(
            (variant) =>
                variant.weight.trim().toLowerCase() == weight.toLowerCase(),
          );

    if (selectedVariant < 0 && weight?.isNotEmpty == true) {
      variants.add(
        ProductVariant(weight: weight!, price: _parsePrice(item.price)),
      );
      selectedVariant = variants.length - 1;
    }

    if (variants.isEmpty) {
      variants.add(
        ProductVariant(
          weight: weight?.isNotEmpty == true ? weight! : '1 item',
          price: _parsePrice(item.price),
        ),
      );
      selectedVariant = 0;
    } else if (selectedVariant < 0) {
      selectedVariant = 0;
    }

    final product = ProductItem(
      id: catalogProduct?.id ?? item.productId,
      name: catalogProduct?.name ?? item.name,
      images: catalogProduct?.images.isNotEmpty == true
          ? catalogProduct!.images
          : null,
      imageUrl: catalogProduct?.imageUrl.isNotEmpty == true
          ? catalogProduct!.imageUrl
          : item.imageUrl,
      rating: catalogProduct?.rating ?? 0,
      reviewCount: catalogProduct?.reviewCount ?? 0,
      deliveryDays: catalogProduct?.deliveryDays ?? 3,
      variants: variants,
      discountLabel: catalogProduct?.discountLabel ?? '',
      processedAt: catalogProduct?.processedAt ?? '',
      shortTagline: catalogProduct?.shortTagline ?? '',
      description: catalogProduct?.description ?? '',
      specifications: catalogProduct?.specifications ?? const [],
      reviews: catalogProduct?.reviews ?? const [],
      faqs: catalogProduct?.faqs ?? const [],
      selectedVariant: selectedVariant,
    );

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => NewProductDetailsPage(product: product),
      ),
    );
  }

  // ==========================================================
  // MAIN BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HomeColors.background,

      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: HomeColors.secondary,
        foregroundColor: HomeColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,

        leading: widget.showBackButton
            ? IconButton(
                tooltip: 'Back',
                onPressed:
                    widget.onBack ?? () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.arrow_back),
              )
            : null,

        title: const Text('Cart', style: HomeTextStyles.appBarTitle),

        actions: [
          IconButton(
            tooltip: 'Wishlist',
            onPressed: () => _openWishlist(context),
            icon: const Icon(Icons.favorite_border),
          ),
        ],
      ),

      body: FutureBuilder<void>(
        future: _cartInitializeFuture,

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: HomeColors.secondary),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),

                child: Text(
                  'Unable to load your cart: ${snapshot.error}',
                  textAlign: TextAlign.center,

                  style: HomeTextStyles.body.copyWith(
                    color: HomeColors.textSecondary,
                  ),
                ),
              ),
            );
          }

          return ValueListenableBuilder<List<CartNotificationItem>>(
            valueListenable: CartService.items,

            builder: (context, cartItems, child) {
              //const delivery = 40.0;

              final total = cartItems.fold<double>(
                0,
                (sum, item) => sum + _parsePrice(item.price) * item.quantity,
              );
              // delivery;

              return Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: ListView(
                          controller: _scrollController,

                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),

                          children: [
                            // =================================
                            // CART PRODUCTS
                            // NO CHECKOUT STEPPER IN CART
                            // =================================

                            if (cartItems.isEmpty)
                              const _EmptyCart()
                            else ...[
                              _CartSectionHeader(
                                title: 'Your basket',

                                trailing:
                                    '${cartItems.length} ${cartItems.length == 1 ? 'Product' : 'Products'}',
                              ),

                              const SizedBox(height: 12),

                              ...cartItems.map(
                                (item) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),

                                  child: _CartItemCard(
                                    item: item,
                                    onImageTap: () => _openProductDetails(item),
                                  ),
                                ),
                              ),
                            ],

                            // =================================
                            // TRENDING PRODUCTS
                            // =================================
                            _ProductRail(
                              title: 'Trending',
                              products: _trendingProducts(cartItems),
                            ),

                            // =================================
                            // RELATED PRODUCTS
                            // =================================
                            _ProductRail(
                              title: 'People also bought these',
                              products: _peopleAlsoBought(cartItems),
                            ),

                            // =================================
                            // WISHLIST
                            // =================================
                            const _WishlistSection(),
                          ],
                        ),
                      ),

                      // =======================================
                      // FIXED COMMON CHECKOUT BUTTON
                      // =======================================
                      if (cartItems.isNotEmpty) _CartCheckoutBar(total: total),
                    ],
                  ),

                  // ===========================================
                  // BACK TO TOP BUTTON
                  // ===========================================
                  if (_showBackToTop)
                    Positioned(
                      top: 12,
                      left: 0,
                      right: 0,

                      child: Center(
                        child: BackToTopButton(onPressed: _scrollToTop),
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

  // ==========================================================
  // TRENDING PRODUCTS
  // ==========================================================

  List<ProductItem> _trendingProducts(List<CartNotificationItem> cartItems) {
    final cartIds = cartItems
        .map((item) => item.productId?.trim())
        .whereType<String>()
        .where((id) => id.isNotEmpty)
        .toSet();

    return ProductRepository.allProducts
        .where((product) => !cartIds.contains(product.id))
        .take(6)
        .toList();
  }

  // ==========================================================
  // PEOPLE ALSO BOUGHT
  // ==========================================================

  List<ProductItem> _peopleAlsoBought(List<CartNotificationItem> cartItems) {
    ProductItem? anchor;

    if (cartItems.isNotEmpty) {
      for (final product in ProductRepository.allProducts) {
        if (product.id == cartItems.first.productId) {
          anchor = product;
          break;
        }
      }
    }

    final baseProduct =
        anchor ??
        (ProductRepository.allProducts.isEmpty
            ? null
            : ProductRepository.allProducts.first);

    if (baseProduct == null) return const [];

    final cartIds = cartItems
        .map((item) => item.productId?.trim())
        .whereType<String>()
        .where((id) => id.isNotEmpty)
        .toSet();

    return ProductRepository.relatedTo(
      baseProduct,
    ).where((product) => !cartIds.contains(product.id)).take(6).toList();
  }
}

// ============================================================
// CART SECTION HEADER
// ============================================================

class _CartSectionHeader extends StatelessWidget {
  final String title;
  final String trailing;

  const _CartSectionHeader({required this.title, required this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,

            style: HomeTextStyles.sectionTitle.copyWith(
              color: HomeColors.textPrimary,
            ),
          ),
        ),

        Text(
          trailing,

          style: HomeTextStyles.bodySmall.copyWith(
            color: HomeColors.textSecondary,
            fontWeight: HomeTextStyles.medium,
          ),
        ),
      ],
    );
  }
}

// ============================================================
// CART PRODUCT CARD
// ============================================================

class _CartItemCard extends StatelessWidget {
  final CartNotificationItem item;
  final VoidCallback onImageTap;

  const _CartItemCard({required this.item, required this.onImageTap});

  @override
  Widget build(BuildContext context) {
    final price = _parsePrice(item.price);
    final lineTotal = price * item.quantity;

    final originalPrice = item.originalPrice == null
        ? 0
        : _parsePrice(item.originalPrice!);

    return Container(
      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: HomeColors.surface,

        border: Border.all(color: HomeColors.border),

        borderRadius: BorderRadius.circular(14),

        boxShadow: [
          BoxShadow(
            color: HomeColors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // ==================================================
          // PRODUCT IMAGE
          // ==================================================

          GestureDetector(
            onTap: onImageTap,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 82,
                height: 82,
                color: HomeColors.background,
                alignment: Alignment.center,
                child: item.imageUrl.trim().isEmpty
                    ? const Icon(
                        Icons.shopping_bag_outlined,
                        color: HomeColors.textHint,
                        size: 34,
                      )
                    : Image.network(
                        item.imageUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.shopping_bag_outlined,
                              color: HomeColors.textHint,
                              size: 34,
                            ),
                      ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // ==================================================
          // PRODUCT INFORMATION
          // ==================================================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  item.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,

                  style: HomeTextStyles.productTitle.copyWith(
                    color: HomeColors.textPrimary,
                  ),
                ),

                if (item.weight?.trim().isNotEmpty == true) ...[
                  const SizedBox(height: 4),

                  Text(
                    item.weight!,

                    style: HomeTextStyles.bodySmall.copyWith(
                      color: HomeColors.textSecondary,
                    ),
                  ),
                ],

                const SizedBox(height: 8),

                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,

                  children: [
                    Text(
                      '₹${lineTotal.toStringAsFixed(0)}',

                      style: HomeTextStyles.price.copyWith(
                        color: HomeColors.secondary,
                      ),
                    ),

                    if (originalPrice > 0)
                      Text(
                        '₹${originalPrice.toStringAsFixed(0)}',

                        style: HomeTextStyles.caption.copyWith(
                          color: HomeColors.textHint,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 10),

                _QuantityControl(item: item),
              ],
            ),
          ),

          // ==================================================
          // DELETE BUTTON
          // ==================================================
          IconButton(
            tooltip: 'Remove ${item.name}',
            visualDensity: VisualDensity.compact,

            onPressed: () => CartService.removeItem(item),

            icon: const Icon(
              Icons.delete_outline,
              color: HomeColors.textSecondary,
              size: 21,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// QUANTITY CONTROL
// ============================================================

class _QuantityControl extends StatelessWidget {
  final CartNotificationItem item;

  const _QuantityControl({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,

      decoration: BoxDecoration(
        color: HomeColors.secondaryLight,
        borderRadius: BorderRadius.circular(18),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          // MINUS BUTTON

          _QuantityButton(
            icon: Icons.remove,

            label: item.quantity == 1
                ? 'Remove product from cart'
                : 'Decrease quantity',

            onTap: () async {
              if (item.quantity <= 1) {
                await CartService.removeItem(item);
              } else {
                await CartService.decreaseItemQuantity(item);
              }
            },
          ),

          // QUANTITY VALUE
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),

            child: Text(
              '${item.quantity}',

              style: const TextStyle(
                color: HomeColors.secondary,
                fontSize: HomeTextStyles.sizeBody,
                fontWeight: HomeTextStyles.semiBold,
              ),
            ),
          ),

          // PLUS BUTTON
          _QuantityButton(
            icon: Icons.add,
            label: 'Increase quantity',

            onTap: () => CartService.increaseItemQuantity(item),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// QUANTITY BUTTON
// ============================================================

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuantityButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: label,
      onPressed: onTap,
      visualDensity: VisualDensity.compact,

      padding: const EdgeInsets.symmetric(horizontal: 8),

      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),

      icon: Icon(icon, size: 17, color: HomeColors.secondary),
    );
  }
}

// ============================================================
// TRENDING / PEOPLE ALSO BOUGHT
// ============================================================

class _ProductRail extends StatelessWidget {
  final String title;
  final List<ProductItem> products;

  const _ProductRail({required this.title, required this.products});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 22),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            title,

            style: HomeTextStyles.sectionTitle.copyWith(
              color: HomeColors.textPrimary,
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            height: 252,

            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: products.length,

              separatorBuilder: (context, index) => const SizedBox(width: 12),

              itemBuilder: (context, index) {
                final product = products[index];

                final variant = product.variants.isEmpty
                    ? null
                    : product.variants[product.selectedVariant
                          .clamp(0, product.variants.length - 1)
                          .toInt()];

                return SizedBox(
                  width: 148,

                  child: Container(
                    padding: const EdgeInsets.all(10),

                    decoration: BoxDecoration(
                      color: HomeColors.surface,

                      border: Border.all(color: HomeColors.border),

                      borderRadius: BorderRadius.circular(12),

                      boxShadow: [
                        BoxShadow(
                          color: HomeColors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        // PRODUCT IMAGE

                        Expanded(
                          child: InkWell(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) =>
                                    NewProductDetailsPage(product: product),
                              ),
                            ),

                            child: Center(
                              child: product.imageUrl.isEmpty
                                  ? const Icon(
                                      Icons.image_not_supported_outlined,
                                      color: HomeColors.textHint,
                                      size: 42,
                                    )
                                  : Image.network(
                                      product.imageUrl,
                                      fit: BoxFit.contain,

                                      errorBuilder:
                                          (
                                            context,
                                            error,
                                            stackTrace,
                                          ) => const Icon(
                                            Icons.image_not_supported_outlined,
                                            color: HomeColors.textHint,
                                            size: 42,
                                          ),
                                    ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // PRODUCT NAME
                        Text(
                          product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,

                          style: HomeTextStyles.productCardTitle.copyWith(
                            color: HomeColors.textPrimary,
                          ),
                        ),

                        // PRODUCT WEIGHT AND PRICE
                        if (variant != null)
                          Text(
                            '${variant.weight} · ₹${variant.price.toStringAsFixed(0)}',

                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,

                            style: HomeTextStyles.caption.copyWith(
                              color: HomeColors.textSecondary,
                            ),
                          ),

                        const SizedBox(height: 6),

                        // ADD BUTTON
                        SizedBox(
                          width: double.infinity,
                          height: 34,

                          child: OutlinedButton(
                            onPressed: variant == null
                                ? null
                                : () => _addProduct(context, product, variant),

                            style: OutlinedButton.styleFrom(
                              foregroundColor: HomeColors.secondary,

                              side: const BorderSide(
                                color: HomeColors.secondary,
                              ),

                              padding: EdgeInsets.zero,

                              textStyle: HomeTextStyles.compactButton,

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),

                            child: const Text('ADD'),
                          ),
                        ),
                      ],
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

  // ==========================================================
  // ADD PRODUCT TO CART
  // ==========================================================

  Future<void> _addProduct(
    BuildContext context,
    ProductItem product,
    ProductVariant variant,
  ) async {
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

// ============================================================
// WISHLIST SECTION
// ============================================================

class _WishlistSection extends StatelessWidget {
  const _WishlistSection();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<ProductItem>>(
      valueListenable: WishlistService.productsNotifier,

      builder: (context, products, child) {
        return Padding(
          padding: const EdgeInsets.only(top: 24),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Wishlist',

                      style: HomeTextStyles.sectionTitle.copyWith(
                        color: HomeColors.textPrimary,
                      ),
                    ),
                  ),

                  if (products.isNotEmpty)
                    TextButton(
                      onPressed: () => _openWishlist(context),
                      child: const Text(
                        'View all',
                        style: HomeTextStyles.compactButton,
                      ),
                    ),
                ],
              ),

              if (products.isEmpty)
                _EmptyWishlistCard(onOpen: () => _openWishlist(context))
              else ...[
                const SizedBox(height: 8),

                SizedBox(
                  height: 142,

                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: products.length,

                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 12),

                    itemBuilder: (context, index) =>
                        _WishlistProductCard(product: products[index]),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

// ============================================================
// WISHLIST PRODUCT CARD
// ============================================================

class _WishlistProductCard extends StatelessWidget {
  final ProductItem product;

  const _WishlistProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final variant = product.variants.isEmpty
        ? null
        : product.variants[product.selectedVariant
              .clamp(0, product.variants.length - 1)
              .toInt()];

    return Container(
      width: 270,
      padding: const EdgeInsets.all(10),

      decoration: BoxDecoration(
        color: HomeColors.surface,

        border: Border.all(color: HomeColors.border),

        borderRadius: BorderRadius.circular(14),
      ),

      child: Row(
        children: [
          // ==================================================
          // PRODUCT IMAGE
          // ==================================================

          GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => NewProductDetailsPage(product: product),
              ),
            ),

            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),

              child: Container(
                width: 78,
                height: 110,
                color: HomeColors.background,
                alignment: Alignment.center,

                child: product.imageUrl.isEmpty
                    ? const Icon(
                        Icons.image_not_supported_outlined,
                        color: HomeColors.textHint,
                      )
                    : Image.network(
                        product.imageUrl,
                        fit: BoxFit.contain,

                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.image_not_supported_outlined,
                              color: HomeColors.textHint,
                            ),
                      ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          // ==================================================
          // PRODUCT INFORMATION
          // ==================================================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,

                  style: HomeTextStyles.productCardTitle.copyWith(
                    color: HomeColors.textPrimary,
                  ),
                ),

                if (variant != null) ...[
                  const SizedBox(height: 4),

                  Text(
                    variant.weight,

                    style: HomeTextStyles.caption.copyWith(
                      color: HomeColors.textSecondary,
                    ),
                  ),

                  Text(
                    '₹${variant.price.toStringAsFixed(0)}',

                    style: HomeTextStyles.bodyEmphasis.copyWith(
                      color: HomeColors.secondary,
                    ),
                  ),
                ],

                const SizedBox(height: 4),

                Row(
                  children: [
                    // REMOVE FROM WISHLIST

                    IconButton(
                      tooltip: 'Remove from wishlist',

                      onPressed: () => WishlistService.remove(product),

                      visualDensity: VisualDensity.compact,

                      padding: EdgeInsets.zero,

                      constraints: const BoxConstraints(
                        minWidth: 36,
                        minHeight: 36,
                      ),

                      icon: const Icon(
                        Icons.favorite,
                        color: HomeColors.error,
                        size: 20,
                      ),
                    ),

                    const SizedBox(width: 8),

                    // ADD TO CART
                    Expanded(
                      child: SizedBox(
                        height: 34,

                        child: ElevatedButton(
                          onPressed: variant == null
                              ? null
                              : () => _addWishlistProduct(
                                  context,
                                  product,
                                  variant,
                                ),

                          style: ElevatedButton.styleFrom(
                            backgroundColor: HomeColors.secondary,
                            foregroundColor: HomeColors.white,
                            elevation: 0,
                            padding: EdgeInsets.zero,

                            textStyle: HomeTextStyles.compactButton,

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),

                          child: const Text('ADD'),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // ADD WISHLIST PRODUCT TO CART
  // ==========================================================

  Future<void> _addWishlistProduct(
    BuildContext context,
    ProductItem product,
    ProductVariant variant,
  ) async {
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

// ============================================================
// EMPTY WISHLIST
// ============================================================

class _EmptyWishlistCard extends StatelessWidget {
  final VoidCallback onOpen;

  const _EmptyWishlistCard({required this.onOpen});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: HomeColors.surface,

        border: Border.all(color: HomeColors.border),

        borderRadius: BorderRadius.circular(14),
      ),

      child: Row(
        children: [
          const Icon(
            Icons.favorite_border,
            color: HomeColors.secondary,
            size: 32,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  'Your wishlist is empty',

                  style: HomeTextStyles.bodyEmphasis.copyWith(
                    color: HomeColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  'Save products you would like to buy later.',

                  style: HomeTextStyles.caption.copyWith(
                    color: HomeColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            tooltip: 'Open wishlist',
            onPressed: onOpen,

            icon: const Icon(
              Icons.chevron_right,
              color: HomeColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// OPEN WISHLIST PAGE
// ============================================================

void _openWishlist(BuildContext context) {
  Navigator.of(
    context,
  ).push(MaterialPageRoute<void>(builder: (_) => const NewWishlistPage()));
}

// ============================================================
// CONSTANT CHECKOUT BOTTOM BUTTON
// ============================================================

class _CartCheckoutBar extends StatelessWidget {
  final double total;

  const _CartCheckoutBar({required this.total});

  @override
  Widget build(BuildContext context) {
    return NewCheckoutBottomBar(
      currentIndex: NewConstantCheckout.cart,

      total: total,

      onContinue: () => Navigator.of(context).push<void>(
        MaterialPageRoute<void>(builder: (_) => const NewCheckoutLoginPopup()),
      ),
    );
  }
}

// ============================================================
// EMPTY CART
// ============================================================

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      margin: const EdgeInsets.only(bottom: 4),

      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 26),

      decoration: BoxDecoration(
        color: HomeColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),

      child: Column(
        children: [
          const Icon(
            Icons.shopping_basket_outlined,
            color: HomeColors.secondary,
            size: 54,
          ),

          const SizedBox(height: 12),

          Text(
            'Your cart is empty',

            style: HomeTextStyles.sectionTitle.copyWith(
              color: HomeColors.textPrimary,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            'Add products to your basket to continue.',

            textAlign: TextAlign.center,

            style: HomeTextStyles.bodySmall.copyWith(
              color: HomeColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// PRICE PARSER
// ============================================================

double _parsePrice(String value) {
  final cleaned = value.replaceAll(',', '').replaceAll(RegExp(r'[^0-9.]'), '');

  return double.tryParse(cleaned) ?? 0;
}
