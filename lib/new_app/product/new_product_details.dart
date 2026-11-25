import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/route_names.dart';
import '../../app/theme/app_colors.dart';
import '../../core/services/cart_service.dart';
import '../../core/services/cart_notification_item.dart';
import '../../core/services/wishlist_service.dart';
import '../../features/product/presentation/model/product_models.dart';
import '../../features/product/presentation/widgets/product_details_widget/product_repository.dart';
import '../constant/constantappbar.dart';
import '../constant/new_back_to_top_button.dart';
import '../constant/constantcolour.dart';
import '../constant/new_constant_text_styles.dart';
import '../dashboard/new_wishlist.dart';

class NewProductDetailsPage extends StatefulWidget {
  final ProductItem product;
  final bool isOutOfStock;

  const NewProductDetailsPage({
    super.key,
    required this.product,
    this.isOutOfStock = false,
  });

  @override
  State<NewProductDetailsPage> createState() => _NewProductDetailsPageState();
}

class _NewProductDetailsPageState extends State<NewProductDetailsPage> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  late final PageController _imageController;
  late final ScrollController _scrollController;
  late int _selectedImageIndex;
  int? _selectedVariantIndex;
  int _quantity = 1;
  bool? _wasInCart;
  int _activeTab = 0;
  bool _isAddingToCart = false;
  bool _isUpdatingCartQuantity = false;
  bool _showBackToTop = false;
  Timer? _addToCartSnackBarTimer;

  static const double _backToTopThreshold = 500;

  ProductItem get _product => widget.product;
  List<ProductVariant> get _variants => _product.variants;

  ProductVariant? get _selectedVariant {
    final index = _selectedVariantIndex;
    if (index == null || index < 0 || index >= _variants.length) return null;
    return _variants[index];
  }

  List<String> get _images {
    final images = _product.images.where((image) => image.trim().isNotEmpty);
    return images.isEmpty ? const [''] : images.toList();
  }

  @override
  void initState() {
    super.initState();
    _selectedImageIndex = 0;
    _selectedVariantIndex = _product.variants.isEmpty
        ? 0
        : _product.selectedVariant
              .clamp(0, _product.variants.length - 1)
              .toInt();
    _imageController = PageController();
    _scrollController = ScrollController()..addListener(_handleScroll);
    WishlistService.productsNotifier.addListener(_onWishlistChanged);
    CartService.items.addListener(_onCartChanged);
    CartService.initialize().then((_) {
      if (!mounted) return;
      setState(() => _wasInCart = _isInCart);
    });
  }

  bool get _isWishlisted => WishlistService.contains(_product);

  CartNotificationItem? get _cartItem {
    final variant = _selectedVariant;
    if (variant == null) return null;

    final productId = _product.id?.trim();
    final weight = variant.weight.trim().toLowerCase();
    for (final item in CartService.items.value) {
      final sameProduct = productId != null && productId.isNotEmpty
          ? item.productId?.trim() == productId
          : item.name.trim().toLowerCase() ==
                _product.name.trim().toLowerCase();
      if (sameProduct && (item.weight?.trim().toLowerCase() ?? '') == weight) {
        return item;
      }
    }
    return null;
  }

  bool get _isInCart => _cartItem != null;
  int get _displayQuantity => _cartItem?.quantity ?? _quantity;

  void _onWishlistChanged() {
    if (mounted) setState(() {});
  }

  void _onCartChanged() {
    if (!mounted) return;
    final bool isInCart = _isInCart;
    setState(() {
      if (_wasInCart == true && !isInCart) {
        _quantity = 1;
      }
      _wasInCart = isInCart;
    });
  }

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

  @override
  void didUpdateWidget(covariant NewProductDetailsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.product != widget.product) {
      _selectedImageIndex = 0;
      _selectedVariantIndex = _product.variants.isEmpty
          ? 0
          : _product.selectedVariant
                .clamp(0, _product.variants.length - 1)
                .toInt();
      _quantity = 1;
      _wasInCart = _isInCart;
      _activeTab = 0;
      if (_imageController.hasClients) {
        _imageController.jumpToPage(0);
      }
    }
  }

  @override
  void dispose() {
    _addToCartSnackBarTimer?.cancel();
    WishlistService.productsNotifier.removeListener(_onWishlistChanged);
    CartService.items.removeListener(_onCartChanged);
    _imageController.dispose();
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    super.dispose();
  }

  void _toggleWishlist() {
    final added = WishlistService.toggle(_product);
    if (!mounted) return;

    _showSnackBar(
      SnackBar(
        content: Text(added ? 'Saved to wishlist.' : 'Removed from wishlist.'),
        duration: const Duration(seconds: 5),
        action: added
            ? SnackBarAction(label: 'VIEW ALL', onPressed: _openWishlist)
            : null,
      ),
    );
  }

  void _showSnackBar(SnackBar snackBar) {
    _addToCartSnackBarTimer?.cancel();
    final messenger = _scaffoldMessengerKey.currentState;
    if (messenger == null) return;

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  void _showAddedToCartSnackBar() {
    final messenger = _scaffoldMessengerKey.currentState;
    if (messenger == null) return;

    _showSnackBar(
      SnackBar(
        content: Text('${_product.name} added to cart'),
        duration: const Duration(seconds: 5),
        action: SnackBarAction(label: 'GO TO CART', onPressed: _openNewCart),
      ),
    );
    _addToCartSnackBarTimer = Timer(const Duration(seconds: 5), () {
      if (mounted && _scaffoldMessengerKey.currentState == messenger) {
        messenger.hideCurrentSnackBar();
      }
    });
  }

  void _openWishlist() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const NewWishlistPage()));
  }

  void _openNewCart() {
    _addToCartSnackBarTimer?.cancel();
    if (!mounted) return;
    _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    context.push(RouteNames.newCart);
  }

  Future<void> _addToCart({bool openCart = false}) async {
    final ProductVariant? variant = _selectedVariant;
    if (widget.isOutOfStock || variant == null || _isAddingToCart) return;

    setState(() => _isAddingToCart = true);
    try {
      await CartService.postAddToCart(
        productId: _product.id,
        productName: _product.name,
        imageUrl: _product.imageUrl,
        price: '₹${variant.price.toStringAsFixed(2)}',
        weight: variant.weight,
        quantity: _quantity,
      );

      if (!mounted) return;
      setState(() {
        _isAddingToCart = false;
        _wasInCart = _isInCart;
      });

      if (openCart) {
        _openNewCart();
      } else {
        _showAddedToCartSnackBar();
      }
    } catch (error) {
      if (!mounted) return;
      setState(() => _isAddingToCart = false);
      _showSnackBar(
        const SnackBar(content: Text('Unable to add product to cart')),
      );
    }
  }

  Future<void> _changeQuantity(int change) async {
    if (widget.isOutOfStock || _isAddingToCart || _isUpdatingCartQuantity) {
      return;
    }

    final item = _cartItem;
    if (item == null) {
      setState(() {
        _quantity = (_quantity + change).clamp(1, 99).toInt();
      });
      return;
    }

    if (change > 0 && item.quantity >= 99) return;

    setState(() => _isUpdatingCartQuantity = true);
    try {
      if (change > 0) {
        await CartService.increaseItemQuantity(item);
      } else {
        await CartService.decreaseItemQuantity(item);
      }
    } catch (error) {
      if (!mounted) return;
      _showSnackBar(
        const SnackBar(content: Text('Unable to update cart quantity')),
      );
    } finally {
      if (mounted) {
        setState(() => _isUpdatingCartQuantity = false);
      }
    }
  }

  void _openProduct(ProductItem product) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => NewProductDetailsPage(
          key: ValueKey(product.id ?? product.name),
          product: product,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ProductVariant? variant = _selectedVariant;

    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: CommonAppBar(
          automaticallyImplyLeading: false,
          backgroundColor: HomeColors.secondary,
          titleColor: HomeColors.white,
          iconColor: HomeColors.white,
          elevation: 0,
          height: kToolbarHeight,
          title: _product.name,
          subtitle: variant == null
              ? null
              : '₹${variant.price.toStringAsFixed(0)}  |  ${variant.weight}',
          titleFontSize: HomeTextStyles.sizeProduct,
          subtitleFontSize: HomeTextStyles.sizeSmall,
          showBackButton: true,
        ),
        body: Stack(
          children: [
            ListView(
              controller: _scrollController,
              padding: EdgeInsets.zero,
              children: [
                _buildImageCarousel(),
                _buildProductSummary(variant),
                _buildPackSizes(),
                const _DeliveryPincodeCheck(),
                _buildBrandBanner(),
                _buildDetailTabs(),
                _buildRatingsAndReviews(),
                _buildProductRail('People also bought'),
                _buildProductRail('Similar Products'),
                const SizedBox(height: 18),
              ],
            ),
            if (_showBackToTop)
              Positioned(
                top: 12,
                left: 0,
                right: 0,
                child: Center(child: BackToTopButton(onPressed: _scrollToTop)),
              ),
          ],
        ),
        bottomNavigationBar: _buildStickyActions(),
      ),
    );
  }

  Widget _buildImageCarousel() {
    return Column(
      children: [
        SizedBox(
          height: 330,
          child: PageView.builder(
            controller: _imageController,
            itemCount: _images.length,
            onPageChanged: (index) {
              if (!mounted) return;
              setState(() => _selectedImageIndex = index);
            },
            itemBuilder: (context, index) {
              final image = _images[index];
              return Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    color: AppColors.surface,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(18),
                    child: image.isEmpty
                        ? const Icon(
                            Icons.image_not_supported_outlined,
                            size: 56,
                            color: AppColors.grey,
                          )
                        : Image.network(
                            image,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                                  Icons.broken_image_outlined,
                                  size: 56,
                                  color: AppColors.grey,
                                ),
                          ),
                  ),
                  if (widget.isOutOfStock)
                    Positioned.fill(
                      child: IgnorePointer(
                        child: ColoredBox(
                          color: Colors.white.withValues(alpha: 0.58),
                        ),
                      ),
                    ),
                  if (widget.isOutOfStock)
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: IgnorePointer(
                        child: Center(
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 9),
                            decoration: BoxDecoration(
                              color: HomeColors.disabledBackground.withValues(
                                alpha: 0.94,
                              ),
                              border: Border.symmetric(
                                horizontal: BorderSide(
                                  color: HomeColors.disabled,
                                  width: 0.7,
                                ),
                              ),
                            ),
                            child: Text(
                              'Out of stock',
                              textAlign: TextAlign.center,
                              style: HomeTextStyles.bodyEmphasis.copyWith(
                                color: HomeColors.textSecondary,
                                fontWeight: HomeTextStyles.semiBold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
        if (_images.length > 1)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_images.length, (index) {
                final selected = index == _selectedImageIndex;
                return GestureDetector(
                  onTap: () {
                    if (!_imageController.hasClients) return;
                    _imageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOut,
                    );
                  },
                  child: Container(
                    width: selected ? 22 : 7,
                    height: 7,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary : AppColors.border,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }

  Widget _buildProductSummary(ProductVariant? variant) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (_product.processedAt.isNotEmpty)
                _summaryChip(_product.processedAt),
              const Spacer(),
              const Icon(Icons.star, size: 18, color: AppColors.accent),
              const SizedBox(width: 3),
              Text(
                '${_product.rating.toStringAsFixed(1)} | ${_product.reviewCount}',
                style: HomeTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  _product.name,
                  style: HomeTextStyles.pageTitle.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Material(
                color: HomeColors.background,
                shape: const CircleBorder(),
                child: IconButton(
                  tooltip: _isWishlisted
                      ? 'Remove from wishlist'
                      : 'Add to wishlist',
                  onPressed: _toggleWishlist,
                  icon: Icon(
                    _isWishlisted ? Icons.favorite : Icons.favorite_border,
                    color: _isWishlisted
                        ? HomeColors.error
                        : HomeColors.textSecondary,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
          if (_product.shortTagline.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              _product.shortTagline,
              style: HomeTextStyles.body.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
          if (variant != null) ...[
            const SizedBox(height: 12),
            _buildVariantPricing(variant),
          ],
        ],
      ),
    );
  }

  Widget _buildVariantPricing(ProductVariant variant) {
    final mrp = variant.mrp;
    final hasDiscount = mrp != null && mrp > variant.price;
    final discountLabel = hasDiscount
        ? '${((mrp - variant.price) / mrp * 100).round()}% OFF'
        : _product.discountLabel.trim();

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 10,
      runSpacing: 6,
      children: [
        Text(
          '₹${variant.price.toStringAsFixed(0)}',
          style: HomeTextStyles.largePrice.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        if (hasDiscount)
          Text(
            '₹${mrp.toStringAsFixed(0)}',
            style: HomeTextStyles.body.copyWith(
              color: AppColors.textSecondary,
              decoration: TextDecoration.lineThrough,
            ),
          ),
        if (discountLabel.isNotEmpty) _summaryChip(discountLabel),
      ],
    );
  }

  Widget _summaryChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: HomeColors.secondaryLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: HomeTextStyles.chip.copyWith(color: HomeColors.secondary),
      ),
    );
  }

  Widget _buildPackSizes() {
    if (_variants.isEmpty) return const SizedBox.shrink();

    final selectedVariant = _selectedVariant;
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            selectedVariant == null
                ? 'Pack sizes'
                : 'Pack sizes  -  ${selectedVariant.weight}',
            style: HomeTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 9),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_variants.length, (index) {
                final selected = _selectedVariantIndex == index;
                final item = _variants[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedVariantIndex = selected ? null : index;
                      _quantity = 1;
                      _wasInCart = _isInCart;
                    });
                  },
                  child: Container(
                    width: 112,
                    margin: const EdgeInsets.only(right: 9),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.surface
                          : AppColors.background,
                      border: Border.all(
                        color: selected
                            ? HomeColors.secondary
                            : AppColors.border,
                        width: selected ? 1.5 : 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.weight,
                          style: HomeTextStyles.productCardTitle.copyWith(
                            color: selected
                                ? HomeColors.secondary
                                : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          '₹${item.price.toStringAsFixed(0)}',
                          style: HomeTextStyles.body.copyWith(
                            fontWeight: HomeTextStyles.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandBanner() {
    final image = _product.imageUrl;
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 22, 18, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'More About This Product',
            style: HomeTextStyles.sectionTitle.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 142,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (image.isNotEmpty)
                    Image.network(
                      image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(color: AppColors.textPrimary),
                    )
                  else
                    Container(color: AppColors.textPrimary),
                  Container(color: AppColors.black.withValues(alpha: 0.55)),
                  Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: HomeTextStyles.sectionTitle.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          'Quality rice for your everyday meals.',
                          style: HomeTextStyles.bodySmall.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                      ],
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

  Widget _buildDetailTabs() {
    const labels = ['Description', 'Additional information', 'Reviews'];
    return Container(
      margin: const EdgeInsets.only(top: 18),
      color: AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(18, 16, 18, 12),
            child: Text(
              'Product details',
              style: HomeTextStyles.sectionTitleLarge.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(labels.length, (index) {
                final selected = _activeTab == index;
                return GestureDetector(
                  onTap: () => setState(() => _activeTab = index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: selected
                              ? AppColors.primary
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Text(
                      labels[index],
                      style: HomeTextStyles.body.copyWith(
                        color: selected
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        fontWeight: selected
                            ? HomeTextStyles.bold
                            : HomeTextStyles.medium,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: _buildActiveTabContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveTabContent() {
    if (_activeTab == 0) {
      return Text(
        _product.description.isEmpty
            ? 'No description available for this product yet.'
            : _product.description,
        style: HomeTextStyles.body.copyWith(
          height: 1.5,
          color: AppColors.textSecondary,
        ),
      );
    }

    if (_activeTab == 1) {
      if (_product.specifications.isEmpty) {
        return Text(
          'No additional information available.',
          style: HomeTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        );
      }
      return Column(
        children: _product.specifications.map((specification) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 11),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.divider)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    specification.label,
                    style: HomeTextStyles.bodyEmphasis.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: Text(
                    specification.value,
                    style: HomeTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      );
    }

    if (_product.reviews.isEmpty) {
      return Text(
        'No reviews yet. Be the first to review this product.',
        style: HomeTextStyles.bodySmall.copyWith(
          color: AppColors.textSecondary,
        ),
      );
    }

    return Column(
      children: _product.reviews.map((review) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.divider)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      review.name,
                      style: HomeTextStyles.bodyEmphasis.copyWith(
                        fontWeight: HomeTextStyles.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  ...List.generate(5, (index) {
                    return Icon(
                      index < review.rating.round()
                          ? Icons.star
                          : Icons.star_border,
                      size: 16,
                      color: AppColors.accent,
                    );
                  }),
                ],
              ),
              const SizedBox(height: 3),
              Text(
                review.date,
                style: HomeTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                review.comment,
                style: HomeTextStyles.body.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildProductRail(String title) {
    final products = ProductRepository.relatedTo(_product);
    if (products.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: HomeTextStyles.sectionTitle.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.grey),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 260,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 18),
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
                return GestureDetector(
                  onTap: () => _openProduct(product),
                  child: SizedBox(
                    width: 148,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 154,
                          width: 148,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.divider),
                          ),
                          child: product.imageUrl.isEmpty
                              ? const Icon(
                                  Icons.image_not_supported_outlined,
                                  color: AppColors.grey,
                                )
                              : Image.network(
                                  product.imageUrl,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(
                                        Icons.broken_image_outlined,
                                        color: AppColors.grey,
                                      ),
                                ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: HomeTextStyles.bodyEmphasis.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (variant != null)
                          Text(
                            '₹${variant.price.toStringAsFixed(0)}  ·  ${variant.weight}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: HomeTextStyles.bodySmall.copyWith(
                              fontWeight: HomeTextStyles.bold,
                              color: AppColors.textPrimary,
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

  Widget _buildRatingsAndReviews() {
    return Container(
      color: AppColors.surface,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ratings & Reviews',
            style: HomeTextStyles.sectionTitle.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Verified purchases only',
            style: HomeTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _product.rating.toStringAsFixed(1),
                style: HomeTextStyles.rating.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Text(
                  '/5',
                  style: HomeTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: List.generate(5, (index) {
              return Icon(
                index < _product.rating.round()
                    ? Icons.star
                    : Icons.star_border,
                color: AppColors.accent,
              );
            }),
          ),
          const SizedBox(height: 4),
          Text(
            '${_product.reviewCount} ratings and ${_product.reviews.length} reviews',
            style: HomeTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStickyActions() {
    final variant = _selectedVariant;
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Color(0x1F000000),
              blurRadius: 10,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Quantity',
                    style: HomeTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                Container(
                  height: 38,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        onPressed:
                            !widget.isOutOfStock &&
                                variant != null &&
                                !_isAddingToCart &&
                                !_isUpdatingCartQuantity &&
                                (_isInCart || _quantity > 1)
                            ? () => _changeQuantity(-1)
                            : null,
                        icon: const Icon(Icons.remove, size: 18),
                      ),
                      Text(
                        '$_displayQuantity',
                        style: HomeTextStyles.productTitle,
                      ),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        onPressed:
                            widget.isOutOfStock ||
                                variant == null ||
                                _isAddingToCart ||
                                _isUpdatingCartQuantity ||
                                _displayQuantity >= 99
                            ? null
                            : () => _changeQuantity(1),
                        icon: const Icon(Icons.add, size: 18),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 46,
                    child: OutlinedButton(
                      onPressed: widget.isOutOfStock || _isAddingToCart
                          ? null
                          : variant == null
                          ? null
                          : _isInCart
                          ? _openNewCart
                          : () => _addToCart(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: HomeColors.secondary,
                        side: const BorderSide(color: HomeColors.secondary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: _isAddingToCart
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              widget.isOutOfStock
                                  ? 'Out of stock'
                                  : _isInCart
                                  ? 'Go to Cart'
                                  : 'Add to Cart',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: HomeTextStyles.bold,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 46,
                    child: ElevatedButton(
                      onPressed:
                          widget.isOutOfStock ||
                              variant == null ||
                              _isAddingToCart
                          ? null
                          : _isInCart
                          ? _openNewCart
                          : () => _addToCart(openCart: true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: HomeColors.secondary,
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Text(
                        widget.isOutOfStock ? 'Out of stock' : 'Buy Now',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: HomeTextStyles.button,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DeliveryPincodeCheck extends StatefulWidget {
  const _DeliveryPincodeCheck();

  @override
  State<_DeliveryPincodeCheck> createState() => _DeliveryPincodeCheckState();
}

class _DeliveryPincodeCheckState extends State<_DeliveryPincodeCheck> {
  final TextEditingController _pincodeController = TextEditingController();
  bool _isChecking = false;
  bool _isPincodeValid = false;
  String? _message;

  @override
  void dispose() {
    _pincodeController.dispose();
    super.dispose();
  }

  Future<void> _checkPincode() async {
    final pincode = _pincodeController.text.trim();
    if (!RegExp(r'^\d{6}$').hasMatch(pincode)) {
      setState(() {
        _message = 'Enter a valid 6-digit PIN code.';
        _isPincodeValid = false;
      });
      return;
    }

    setState(() {
      _isChecking = true;
      _message = null;
      _isPincodeValid = false;
    });

    try {
      await Future<void>.delayed(const Duration(milliseconds: 300));
      if (!mounted) return;
      setState(() {
        _message = 'PIN format is valid.';
        _isPincodeValid = true;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isChecking = false;
        });
      }
    }
  }

  void _onPincodeChanged(String value) {
    if (_message == null) return;
    setState(() {
      _message = null;
      _isPincodeValid = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Check Delivery Availability',
            style: HomeTextStyles.bodyEmphasis.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _pincodeController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6),
                  ],
                  onChanged: _onPincodeChanged,
                  decoration: const InputDecoration(
                    hintText: 'Enter a PIN code',
                    counterText: '',
                    isDense: true,
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: _isChecking ? null : _checkPincode,
                child: _isChecking
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: HomeColors.secondary,
                        ),
                      )
                    : const Text(
                        'Apply',
                        style: TextStyle(color: HomeColors.secondary),
                      ),
              ),
            ],
          ),
          if (_message != null) ...[
            const SizedBox(height: 6),
            Text(
              _message!,
              style: TextStyle(
                color: _isPincodeValid ? HomeColors.success : HomeColors.error,
                fontSize: 12,
              ),
            ),
          ],
          const SizedBox(height: 8),
          Text(
            'Fulfilled by Lalbaba',
            style: HomeTextStyles.bodySmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: HomeTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}
