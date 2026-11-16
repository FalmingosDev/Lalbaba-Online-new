import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../app/router/route_names.dart';
import '../app/theme/app_colors.dart';
import '../core/services/cart_service.dart';
import '../features/product/presentation/model/product_models.dart';
import '../features/product/presentation/widgets/product_details_widget/product_repository.dart';

class NewProductDetailsPage extends StatefulWidget {
  final ProductItem product;

  const NewProductDetailsPage({super.key, required this.product});

  @override
  State<NewProductDetailsPage> createState() => _NewProductDetailsPageState();
}

class _NewProductDetailsPageState extends State<NewProductDetailsPage> {
  late final PageController _imageController;
  late int _selectedImageIndex;
  late int _selectedVariantIndex;
  int _quantity = 1;
  int _activeTab = 0;
  bool _isAddingToCart = false;
  bool _isInCart = false;

  ProductItem get _product => widget.product;
  List<ProductVariant> get _variants => _product.variants;

  ProductVariant? get _selectedVariant {
    if (_variants.isEmpty) return null;
    return _variants[_selectedVariantIndex
        .clamp(0, _variants.length - 1)
        .toInt()];
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
      _activeTab = 0;
      _isInCart = false;
      _imageController.jumpToPage(0);
    }
  }

  @override
  void dispose() {
    _imageController.dispose();
    super.dispose();
  }

  Future<void> _addToCart({bool openCart = false}) async {
    final ProductVariant? variant = _selectedVariant;
    if (variant == null || _isAddingToCart) return;

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
        _isInCart = true;
      });

      if (openCart) {
        context.push(RouteNames.cart);
      } else {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text('${_product.name} added to cart'),
              duration: const Duration(seconds: 2),
              action: SnackBarAction(
                label: 'GO TO CART',
                onPressed: () => context.push(RouteNames.cart),
              ),
            ),
          );
      }
    } catch (error) {
      if (!mounted) return;
      setState(() => _isAddingToCart = false);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Unable to add product to cart')),
        );
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

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            if (variant != null)
              Text(
                '₹${variant.price.toStringAsFixed(0)}  |  ${variant.weight}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildImageCarousel(),
          _buildProductSummary(variant),
          _buildPackSizes(),
          _buildBrandBanner(),
          _buildProductRail('People also bought'),
          _buildProductRail('Similar Products'),
          _buildDetailTabs(),
          _buildRatingsAndReviews(),
          const SizedBox(height: 18),
        ],
      ),
      bottomNavigationBar: _buildStickyActions(),
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
              setState(() => _selectedImageIndex = index);
            },
            itemBuilder: (context, index) {
              final image = _images[index];
              return Container(
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
                  onTap: () => _imageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOut,
                  ),
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
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _product.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          if (_product.shortTagline.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              _product.shortTagline,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ],
          if (variant != null) ...[
            const SizedBox(height: 12),
            Text(
              '₹${variant.price.toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _summaryChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.secondaryLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.secondary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildPackSizes() {
    if (_variants.isEmpty) return const SizedBox.shrink();

    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pack sizes  -  ${_variants[_selectedVariantIndex].weight}',
            style: const TextStyle(color: AppColors.textSecondary),
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
                      _selectedVariantIndex = index;
                      _quantity = 1;
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
                            ? AppColors.secondary
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
                          style: TextStyle(
                            color: selected
                                ? AppColors.secondary
                                : AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          '₹${item.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
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
          const Text(
            'More About This Product',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
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
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 7),
                        const Text(
                          'Quality rice for your everyday meals.',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 13,
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
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (variant != null)
                          Text(
                            '₹${variant.price.toStringAsFixed(0)}  ·  ${variant.weight}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
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

  Widget _buildDetailTabs() {
    const labels = ['Description', 'Additional information', 'Reviews'];
    return Container(
      margin: const EdgeInsets.only(top: 18),
      color: AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(18, 16, 18, 12),
            child: Text(
              'Product details',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
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
                      style: TextStyle(
                        color: selected
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        fontWeight: selected
                            ? FontWeight.bold
                            : FontWeight.w500,
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
        style: const TextStyle(height: 1.5, color: AppColors.textSecondary),
      );
    }

    if (_activeTab == 1) {
      if (_product.specifications.isEmpty) {
        return const Text(
          'No additional information available.',
          style: TextStyle(color: AppColors.textSecondary),
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
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: Text(
                    specification.value,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      );
    }

    if (_product.reviews.isEmpty) {
      return const Text(
        'No reviews yet. Be the first to review this product.',
        style: TextStyle(color: AppColors.textSecondary),
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
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
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
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                review.comment,
                style: const TextStyle(color: AppColors.textPrimary),
              ),
            ],
          ),
        );
      }).toList(),
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
          const Text(
            'Ratings & Reviews',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Verified purchases only',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _product.rating.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Text(
                  '/5',
                  style: TextStyle(color: AppColors.textSecondary),
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
            style: const TextStyle(
              fontSize: 12,
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
                const Expanded(
                  child: Text(
                    'Quantity',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
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
                        onPressed: _quantity > 1
                            ? () => setState(() => _quantity--)
                            : null,
                        icon: const Icon(Icons.remove, size: 18),
                      ),
                      Text(
                        '$_quantity',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        onPressed: () => setState(() => _quantity++),
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
                      onPressed: _isAddingToCart
                          ? null
                          : _isInCart
                          ? () => context.push(RouteNames.cart)
                          : () => _addToCart(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.secondary,
                        side: const BorderSide(color: AppColors.secondary),
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
                              _isInCart ? 'Go to Cart' : 'Add to Cart',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
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
                      onPressed: variant == null || _isAddingToCart
                          ? null
                          : () => _addToCart(openCart: true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text(
                        'Buy Now',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.bold),
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
