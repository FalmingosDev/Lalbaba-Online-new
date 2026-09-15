import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/services/cart_service.dart';
import '../../../../core/widgets/app_app_bar.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/helpers/snackbar_helper.dart';


import '../model/product_models.dart';
import '../widgets/fliter_drawer_widget.dart';
import '../widgets/product_details_widget/product_repository.dart';
import '../widgets/product_name_image.dart';
import '../widgets/product_price_deliver_weight.dart';
import '../widgets/qty_add_button_widget.dart';
import 'product_details_page.dart';


class ProductListPage extends StatefulWidget {
  // null       = all products
  // trending   = trending products
  // bestSeller = best seller products
  final String? sectionType;

  // Category page theke kon sub-category select hoyeche.
  // Example: Jeera Kathi, Basmati, Ratna etc.
  // null hole kono initial category filter apply hobe na.
  final String? initialCategory;

  final String pageTitle;

  const ProductListPage({
    super.key,
    this.sectionType,
    this.initialCategory,
    this.pageTitle = 'Products',
  });

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  RangeValues _priceRange = const RangeValues(119, 1649);

  final Set<String> _selectedCategories = {};
  final Set<String> _selectedWeights = {};

  String _selectedSort = 'Default';

  late List<ProductItem> _filteredProducts;

  bool _isLoading = true;

  // ===========================================================================
  // PRODUCTS
  // ===========================================================================

  // Sourced from the central repository - this is the single place the
  // product catalogue is defined, and it's what every product-details
  // page (and its "Trending this week" rail) reads from too, no matter
  // how deep the navigation stack gets.
  List<ProductItem> get products => ProductRepository.allProducts;

  // ===========================================================================
  // INIT STATE
  // ===========================================================================

  @override
  void initState() {
    super.initState();

    _filteredProducts = _getSectionProducts();

    // Global cart count sync.
    CartService.getCartCount();

    // Temporary loading.
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    });
  }

  // ===========================================================================
  // RESPONSIVE GRID COLUMN
  // ===========================================================================

  int _getCrossAxisCount(double width) {
    if (width < 330) {
      return 1;
    }

    return 2;
  }

  // ===========================================================================
  // SECTION PRODUCTS
  // ===========================================================================

  List<ProductItem> _getSectionProducts() {
    // First sectionType onujayi base product list ready kori.
    List<ProductItem> result;

    if (widget.sectionType == null) {
      result = List<ProductItem>.from(products);
    } else if (widget.sectionType == 'trending' ||
        widget.sectionType == 'bestSeller') {
      result = products.where((product) {
        final String name = product.name.toLowerCase();

        return name.contains('minikit') ||
            name.contains('basmati') ||
            name.contains('jeera');
      }).toList();
    } else {
      result = List<ProductItem>.from(products);
    }

    // Category page theke sub-category pathano hole
    // shudhu oi category-r matching products dekhabo.
    final String? initialCategory = widget.initialCategory;

    if (initialCategory != null && initialCategory.trim().isNotEmpty) {
      result = result.where((product) {
        return _productMatchesCategory(product, initialCategory);
      }).toList();
    }

    return result;
  }

  // ===========================================================================
  // NAVIGATE TO PRODUCT DETAILS
  // ===========================================================================
  //
  // A unique `key` per product ensures each pushed details page is treated as
  // its own distinct page in the navigation stack - so tapping product A,
  // then product B from A's page, then product C from B's page, and pressing
  // back three times lands you on C -> B -> A -> the list, in that order,
  // exactly as you'd expect from a normal stack of pages.
  //
  // Note: ProductDetailPage looks up its own "related products" from
  // ProductRepository internally, so nothing needs to be threaded through
  // here for that to work correctly at any navigation depth.
  // ===========================================================================

  void _openProductDetails(ProductItem product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailPage(
          key: ValueKey(product.id ?? product.name),
          product: product,
        ),
      ),
    );
  }

  // ===========================================================================
  // ADD TO CART
  // ===========================================================================

  Future<void> _addToCart(ProductItem product, int quantity) async {
    if (quantity <= 0) {
      return;
    }

    try {
      final ProductVariant selectedVariant =
          product.variants[product.selectedVariant];

      await CartService.postAddToCart(
        productId: product.id,
        productName: product.name,
        imageUrl: product.imageUrl,
        price: '₹${selectedVariant.price.toStringAsFixed(2)}',
        weight: selectedVariant.weight,
        quantity: quantity,
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
  // BUILD
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffafafa),
      appBar: AppAppBar(
        title: widget.pageTitle,
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          _buildProductHeader(),
          Expanded(
            child: _isLoading
                ? _buildShimmerGrid()
                : _filteredProducts.isEmpty
                    ? _buildEmptyResult()
                    : _buildProductGrid(),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // RESPONSIVE PRODUCT GRID
  // ===========================================================================

  Widget _buildProductGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final int crossAxisCount = _getCrossAxisCount(constraints.maxWidth);

        return GridView.builder(
          padding: const EdgeInsets.only(left: 7, right: 7, top: 8, bottom: 15),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 7,
            mainAxisSpacing: 8,
            mainAxisExtent: 385,
          ),
          itemCount: _filteredProducts.length,
          itemBuilder: (context, index) {
            final ProductItem product = _filteredProducts[index];

            return ProductCard(
              key: ValueKey(product.name),
              product: product,
              onWeightTap: () => _showWeightSheet(product),
              onAddToCart: (quantity) => _addToCart(product, quantity),
              onTap: () => _openProductDetails(product),
            );
          },
        );
      },
    );
  }

  // ===========================================================================
  // SHIMMER GRID
  // ===========================================================================

  Widget _buildShimmerGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final int crossAxisCount = _getCrossAxisCount(constraints.maxWidth);

        return GridView.builder(
          padding: const EdgeInsets.only(left: 7, right: 7, top: 8, bottom: 15),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 7,
            mainAxisSpacing: 8,
            mainAxisExtent: 385,
          ),
          itemCount: 6,
          itemBuilder: (context, index) {
            return const ProductShimmer();
          },
        );
      },
    );
  }

  // ===========================================================================
  // EMPTY RESULT
  // ===========================================================================

  Widget _buildEmptyResult() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off, size: 60, color: Colors.grey),
            const SizedBox(height: 12),
            const Text(
              'No products found',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            const Text(
              'Try changing your filter options.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _clearFilters,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE23F1C),
                foregroundColor: Colors.white,
              ),
              child: const Text('CLEAR FILTER'),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // PRODUCT HEADER
  // ===========================================================================

  Widget _buildProductHeader() {
    final int filterCount = _selectedCategories.length + _selectedWeights.length;

    final bool hasFilter = _selectedCategories.isNotEmpty ||
        _selectedWeights.isNotEmpty ||
        _priceRange.start != 119 ||
        _priceRange.end != 1649;

    final String title = _isLoading
        ? widget.pageTitle
        : hasFilter
            ? 'Filtered products (${_filteredProducts.length})'
            : '${widget.pageTitle} (${_filteredProducts.length})';

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool smallScreen = constraints.maxWidth < 360;

        // =====================================================
        // SMALL PHONE HEADER
        // =====================================================

        if (smallScreen) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Color(0xffeeeeee)),
                bottom: BorderSide(color: Color(0xffeeeeee)),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    const Spacer(),
                    _buildSortButton(),
                    const SizedBox(width: 6),
                    _buildFilterButton(filterCount),
                  ],
                ),
              ],
            ),
          );
        }

        // =====================================================
        // NORMAL PHONE HEADER
        // =====================================================

        return Container(
          constraints: const BoxConstraints(minHeight: 55),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: Color(0xffeeeeee)),
              bottom: BorderSide(color: Color(0xffeeeeee)),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 14, right: 5),
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              _buildSortButton(),
              _buildFilterButton(filterCount),
            ],
          ),
        );
      },
    );
  }

  // ===========================================================================
  // SORT BUTTON
  // ===========================================================================

  Widget _buildSortButton() {
    return InkWell(
      onTap: _isLoading ? null : _showSortSheet,
      borderRadius: BorderRadius.circular(5),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.sort, size: 18),
            SizedBox(width: 4),
            Text('Sort By', style: TextStyle(fontSize: 13)),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // FILTER BUTTON
  // ===========================================================================

  Widget _buildFilterButton(int filterCount) {
    return InkWell(
      onTap: _isLoading ? null : _openFilter,
      borderRadius: BorderRadius.circular(5),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.filter_list, size: 18),
            const SizedBox(width: 3),
            const Text('Filter', style: TextStyle(fontSize: 13)),
            if (filterCount > 0) ...[
              const SizedBox(width: 4),
              Container(
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$filterCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // WEIGHT SHEET
  // ===========================================================================

  void _showWeightSheet(ProductItem product) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xfffafafa),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    product.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 14),
                  ...List.generate(product.variants.length, (index) {
                    final ProductVariant item = product.variants[index];
                    final bool selected = product.selectedVariant == index;

                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      onTap: () {
                        setState(() {
                          product.selectedVariant = index;
                        });

                        Navigator.pop(context);
                      },
                      leading: Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selected
                                ? const Color(0xFFE23F1C)
                                : Colors.grey,
                            width: 2,
                          ),
                        ),
                        child: selected
                            ? const Center(
                                child: CircleAvatar(
                                  radius: 6,
                                  backgroundColor: Color(0xFFE23F1C),
                                ),
                              )
                            : null,
                      ),
                      title: Text(
                        '${item.weight} - Rs ${item.price.toStringAsFixed(2)}',
                      ),
                    );
                  }),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ===========================================================================
  // SORT SHEET
  // ===========================================================================

  void _showSortSheet() {
    const List<String> options = [
      'Default',
      'Price Low→High',
      'Price High→Low',
      'Newest',
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: options.map((option) {
              final bool selected = _selectedSort == option;

              return ListTile(
                title: Text(option),
                trailing: selected
                    ? const Icon(Icons.check, color: Color(0xFFE23F1C))
                    : null,
                onTap: () {
                  Navigator.pop(context);

                  setState(() {
                    _selectedSort = option;
                  });

                  _applyFilters();
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  // ===========================================================================
  // APPLY FILTERS
  // ===========================================================================

  void _applyFilters() {
    List<ProductItem> result = _getSectionProducts();

    // CATEGORY
    if (_selectedCategories.isNotEmpty) {
      result = result.where((product) {
        return _selectedCategories.any(
          (category) => _productMatchesCategory(product, category),
        );
      }).toList();
    }

    // PRICE + WEIGHT
    result = result.where((product) {
      return product.variants.any((variant) {
        final bool priceMatches = variant.price >= _priceRange.start &&
            variant.price <= _priceRange.end;

        final bool weightMatches = _selectedWeights.isEmpty ||
            _selectedWeights.contains(variant.weight);

        return priceMatches && weightMatches;
      });
    }).toList();

    // SORT
    switch (_selectedSort) {
      case 'Price Low→High':
        result.sort((a, b) => _lowestPrice(a).compareTo(_lowestPrice(b)));
        break;

      case 'Price High→Low':
        result.sort((a, b) => _lowestPrice(b).compareTo(_lowestPrice(a)));
        break;

      case 'Newest':
        // Pore API-te createdAt thakle ekhane sort korbe.
        break;

      case 'Default':
        break;
    }

    setState(() {
      _filteredProducts = result;
    });
  }

  // ===========================================================================
  // CATEGORY MATCH
  // ===========================================================================

  bool _productMatchesCategory(ProductItem product, String category) {
    final String name = product.name.toLowerCase();

    switch (category.toLowerCase()) {
      case 'minikit':
        return name.contains('minikit');

      case 'banskathi':
        return name.contains('banskathi');

      case 'ratna':
        return name.contains('ratna');

      case 'gobindo bhog':
        return name.contains('gobindo bhog');

      case 'basmati':
        return name.contains('basmati');

      case 'jeera kathi':
        return name.contains('jeera kathi');

      default:
        return false;
    }
  }

  // ===========================================================================
  // LOWEST PRICE
  // ===========================================================================

  double _lowestPrice(ProductItem product) {
    if (product.variants.isEmpty) {
      return double.infinity;
    }

    return product.variants
        .map((variant) => variant.price)
        .reduce((a, b) => a < b ? a : b);
  }

  // ===========================================================================
  // CLEAR FILTER
  // ===========================================================================

  void _clearFilters() {
    setState(() {
      _priceRange = const RangeValues(119, 1649);
      _selectedCategories.clear();
      _selectedWeights.clear();
      _selectedSort = 'Default';
      _filteredProducts = _getSectionProducts();
    });
  }

  // ===========================================================================
  // FILTER DRAWER
  // ===========================================================================

  Future<void> _openFilter() async {
    final FilterResult? result = await showGeneralDialog<FilterResult>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Filter',
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.centerRight,
          child: FilterDrawer(
            initialPriceRange: _priceRange,
            initialCategories: _selectedCategories,
            initialWeights: _selectedWeights,
          ),
        );
      },
    );

    if (result == null) {
      return;
    }

    setState(() {
      _priceRange = result.priceRange;

      _selectedCategories
        ..clear()
        ..addAll(result.categories);

      _selectedWeights
        ..clear()
        ..addAll(result.weights);
    });

    _applyFilters();
  }
}

// =============================================================================
// PRODUCT CARD
// =============================================================================

class ProductCard extends StatelessWidget {
  final ProductItem product;
  final VoidCallback onWeightTap;
  final ValueChanged<int> onAddToCart;

  /// Opens the product details page. Optional so this widget still works
  /// anywhere it was already used without a details page wired up.
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.onWeightTap,
    required this.onAddToCart,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ProductVariant selectedVariant =
        product.variants[product.selectedVariant];

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: const Color(0xffeeeeee)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // ===============================================================
          // IMAGE + PRODUCT NAME + RATING (tappable -> opens details)
          // ===============================================================
          InkWell(
            onTap: onTap,
            child: Column(
              children: [
                ProductImageHeader(imageUrl: product.imageUrl, name: product.name),

                SizedBox(
                  height: 25,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      final double rating = product.rating;

                      if (rating >= index + 1) {
                        return const Icon(
                          Icons.star,
                          size: 15,
                          color: Colors.orange,
                        );
                      }

                      if (rating >= index + 0.5) {
                        return const Icon(
                          Icons.star_half,
                          size: 15,
                          color: Colors.orange,
                        );
                      }

                      return const Icon(
                        Icons.star_border,
                        size: 15,
                        color: Colors.orange,
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),

          // ===============================================================
          // WEIGHT + PRICE + DELIVERY
          // ===============================================================
          ProductPriceInfo(
            weight: selectedVariant.weight,
            price: selectedVariant.price,
            deliveryDays: product.deliveryDays,
            onWeightTap: onWeightTap,
          ),

          // ===============================================================
          // QTY + ADD
          // ===============================================================
          QtyAddButton(onAddToCart: onAddToCart),
        ],
      ),
    );
  }
}
