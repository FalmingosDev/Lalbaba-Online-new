

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lalbaba_online/features/account/presentation/widgets/app_string.dart';
import 'package:lalbaba_online/features/account/presentation/widgets/languange_constant.dart';
import 'package:lalbaba_online/features/product/presentation/pages/product_list_page.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/asset_constants.dart';
import '../../../../core/helpers/snackbar_helper.dart';
import '../../../../core/services/cart_notification_item.dart';
import '../../../../core/services/cart_service.dart';
import '../../../../core/widgets/app_app_bar.dart';
import '../../../../core/widgets/app_shimmer.dart';

// ==========================================================================
// HOME PAGE
// ==========================================================================

class HomeNewPage extends ConsumerStatefulWidget {
  const HomeNewPage({super.key});

  @override
  ConsumerState<HomeNewPage> createState() => _HomeNewPageState();
}

class _HomeNewPageState extends ConsumerState<HomeNewPage> {
  bool _isLoading = true;

  // ===========================================================================
  // HOME CATEGORY TABS
  // ===========================================================================

  final List<String> _categoryNames = ['For Youu', 'Rice', 'Spices'];

  // ===========================================================================
  // SEARCH CATEGORIES
  // ===========================================================================

  final List<String> _searchCategories = [
    'Minikit',
    'Banskathi',
    'Chamanmani',
    'Basmati',
    'Gobindo Bhog',
    'Jeera Rice',
    'Ratna',
  ];

  // ===========================================================================
  // TRENDING PRODUCTS
  // ===========================================================================

  final List<Map<String, dynamic>> _trendingProducts = [
    {
      'name': 'Lalbaba Superior Minikit',
      'imageUrl': AssetConstants.miniket,
      'price': '₹1,089.00',
      'originalPrice': '₹1,299.00',
      'discountLabel': '16% OFF',
      'rating': 5.0,
    },
    {
      'name': 'Lalbaba Basmati Steam',
      'imageUrl': AssetConstants.basmoti,
      'price': '₹230.00',
      'originalPrice': '₹270.00',
      'discountLabel': '15% OFF',
      'rating': 4.5,
    },
    {
      'name': 'Lalbaba Jeer Rice',
      'imageUrl': AssetConstants.jeerrice,
      'price': '₹650.00',
      'originalPrice': '',
      'discountLabel': '',
      'rating': 4.7,
    },
  ];

  // ===========================================================================
  // POPULAR SEARCH
  // ===========================================================================

  final List<Map<String, dynamic>> _popularSearch = [
    {
      'name': 'Minikit',
      'imageUrl': AssetConstants.miniket1,
      'discountLabel': '10% OFF',
    },
    {
      'name': 'Ratna Basmati',
      'imageUrl': AssetConstants.ratna,
      'discountLabel': '20% OFF',
    },
  ];

  // ===========================================================================
  // BEST SELLER
  // ===========================================================================

  final List<Map<String, dynamic>> _bestSellers = [
    {
      'name': 'Lalbaba Superior Minikit',
      'imageUrl': AssetConstants.miniket,
      'price': '₹1,089.00',
      'originalPrice': '₹1,299.00',
      'discountLabel': '16% OFF',
      'rating': 5.0,
    },
    {
      'name': 'Lalbaba Basmati',
      'imageUrl': AssetConstants.baskati,
      'price': '₹230.00',
      'originalPrice': '₹275.00',
      'discountLabel': '16% OFF',
      'rating': 4.5,
    },
    {
      'name': 'Lalbaba Jeer Rice',
      'imageUrl': AssetConstants.jeerrice,
      'price': '₹650.00',
      'originalPrice': '₹750.00',
      'discountLabel': '13% OFF',
      'rating': 4.6,
    },
  ];

  // ===========================================================================
  // SEARCH PRODUCTS
  // ===========================================================================

  List<Map<String, dynamic>> get _searchProducts {
    final Map<String, Map<String, dynamic>> unique = {};

    for (final product in [..._trendingProducts, ..._bestSellers]) {
      final String name = product['name']?.toString().trim() ?? '';

      if (name.isNotEmpty) {
        unique[name] = product;
      }
    }

    return unique.values.toList();
  }

  // ===========================================================================
  // INIT
  // ===========================================================================

  @override
  void initState() {
    super.initState();

    CartService.getCartCount();

    _loadHomeData();
  }

  // ===========================================================================
  // LOAD HOME DATA
  // ===========================================================================

  Future<void> _loadHomeData() async {
    await Future.delayed(const Duration(milliseconds: 900));

    if (!mounted) {
      return;
    }

    setState(() {
      _isLoading = false;
    });
  }

  // ===========================================================================
  // PRODUCT LIST PAGE
  // ===========================================================================

  Future<void> _openProductListPage({
    String? sectionType,
    String title = 'Products',
  }) async {
    // -------------------------------------------------------------------------
    // HOME CATEGORY NAVIGATION BLOCK
    // -------------------------------------------------------------------------

    if (title == 'For You' || title == 'Rice' || title == 'Spices') {
      debugPrint('Category navigation blocked: $title');

      return;
    }

    // -------------------------------------------------------------------------
    // OTHER NAVIGATION
    // -------------------------------------------------------------------------

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ProductListPage(sectionType: sectionType, pageTitle: title),
      ),
    );
  }

  // ===========================================================================
  // ADD TO CART
  // ===========================================================================

  Future<void> _handleAddToCart(Map<String, dynamic> product) async {
    final String productName = product['name']?.toString().trim() ?? 'Product';

    try {
      await CartService.postAddToCart(
        productId: product['id']?.toString(),
        productName: productName,
        imageUrl: product['imageUrl']?.toString(),
        price: product['price']?.toString(),
        originalPrice: product['originalPrice']?.toString(),
        quantity: 1,
      );

      if (!mounted) {
        return;
      }

      FeedbackHelper.showSuccess(context, '$productName added to cart');
    } catch (error) {
      if (!mounted) {
        return;
      }

      FeedbackHelper.showError(context, 'Unable to add product to cart');
    }
  }

  // ===========================================================================
  // NOTIFICATION
  // ===========================================================================

  Future<void> _openCartNotificationPage() async {
    // ✅ Notification page open howa niye change
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CartNotificationPage()),
    );
  }

  // ===========================================================================
  // SEARCH CATEGORY
  // ===========================================================================

  void _handleSearchCategoryTap(String category) {
    debugPrint('Search category: $category');

    _openProductListPage(title: category);
  }

  // ===========================================================================
  // SEARCH PRODUCT
  // ===========================================================================

  void _handleSearchProductTap(Map<String, dynamic> product) {
    debugPrint('Search product: ${product['name']}');
  }

  // ===========================================================================
  // RECIPE TAP
  // ===========================================================================

  void _handleRecipeTap(int index) {
    debugPrint('Recipe clicked: $index');
  }

  // ===========================================================================
  // REVIEW TAP
  // ===========================================================================

  void _handleReviewTap(int index) {
    debugPrint('Review clicked: $index');
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    const double categoryHeight = 60;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,

        // =====================================================================
        // APP BAR
        // =====================================================================
        appBar: LalBabaAppBar(
          onNotificationTap: _openCartNotificationPage,
          onCartTap: () {},
        ),

        // =====================================================================
        // BODY
        // =====================================================================
        body: _isLoading
            ? _buildShimmerBody()
            : CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),

                slivers: [
                  // ===========================================================
                  // TOP SPACE
                  // ===========================================================

                  const SliverToBoxAdapter(child: SizedBox(height: 10)),

                  // ===========================================================
                  // SEARCH
                  // ===========================================================
                  SliverToBoxAdapter(
                    child: SearchWidget(
                      categories: _searchCategories,
                      products: _searchProducts,
                      onCategoryTap: _handleSearchCategoryTap,
                      onProductTap: _handleSearchProductTap,
                    ),
                  ),

                  // ===========================================================
                  // CATEGORY
                  // ===========================================================
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _StickyHeaderDelegate(
                      height: categoryHeight,

                      child: CategoryWidget(
                        names: _categoryNames,

                        onCategoryTap: (name) {
                          _openProductListPage(title: name);
                        },
                      ),
                    ),
                  ),

                  // ===========================================================
                  // MAIN HOME CONTENT
                  // ===========================================================
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,

                      children: [
                        const SizedBox(height: 8),

                        // =====================================================
                        // BANNER
                        // =====================================================
                        const BannerWidget(),

                        // =====================================================
                        // TRENDING
                        // =====================================================
                        AnimatedBuilder(
                          animation: AppLanguageConstants.instance,

                          builder: (context, child) {
                            return TrendingWidget(
                              products: _trendingProducts,

                              onProductTap: (product) {
                                debugPrint(
                                  'Trending Product: '
                                  '${product['name']}',
                                );
                              },

                              onAddToCart: _handleAddToCart,

                              onViewAllTap: () {
                                _openProductListPage(
                                  sectionType: 'trending',

                                  title: AppStrings.trendingThisWeek,
                                );
                              },
                            );
                          },
                        ),

                        // =====================================================
                        // POPULAR SEARCH
                        // =====================================================
                        AnimatedBuilder(
                          animation: AppLanguageConstants.instance,

                          builder: (context, child) {
                            return PopularSearchWidget(
                              products: _popularSearch,

                              onProductTap: _handleSearchProductTap,
                            );
                          },
                        ),

                        // =====================================================
                        // BEST SELLER
                        // =====================================================
                        AnimatedBuilder(
                          animation: AppLanguageConstants.instance,

                          builder: (context, child) {
                            return BestSellerWidget(
                              products: _bestSellers,

                              onProductTap: (product) {
                                debugPrint(
                                  'Best Seller Product: '
                                  '${product['name']}',
                                );
                              },

                              onAddToCart: _handleAddToCart,

                              onViewAllTap: () {
                                _openProductListPage(
                                  sectionType: 'bestSeller',

                                  title: AppStrings.bestSeller,
                                );
                              },
                            );
                          },
                        ),

                        // =====================================================
                        // RECIPE
                        // =====================================================
                        RecipeWidget(onRecipeTap: _handleRecipeTap),

                        // =====================================================
                        // HAPPY HOME CHEFS
                        // =====================================================
                        TestimonialWidget(onReviewTap: _handleReviewTap),

                        // =====================================================
                        // SMALL BOTTOM GAP
                        //
                        // Age 110 chilo.
                        // Ekhon 24 kora holo.
                        // =====================================================
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  // ===========================================================================
  // SHIMMER BODY
  // ===========================================================================

  Widget _buildShimmerBody() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),

      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),

      children: [
        // =====================================================================
        // SEARCH SHIMMER
        // =====================================================================

        const AppShimmer(height: 48, radius: 24),

        const SizedBox(height: 16),

        // =====================================================================
        // CATEGORY SHIMMER
        // =====================================================================
        SizedBox(
          height: 36,

          child: ListView.separated(
            scrollDirection: Axis.horizontal,

            physics: const NeverScrollableScrollPhysics(),

            itemCount: _categoryNames.length,

            separatorBuilder: (context, index) {
              return const SizedBox(width: 10);
            },

            itemBuilder: (context, index) {
              return const AppShimmer(width: 90, height: 36, radius: 20);
            },
          ),
        ),

        const SizedBox(height: 16),

        // =====================================================================
        // BANNER SHIMMER
        // =====================================================================
        const AppShimmer(height: 150, radius: 12),

        const SizedBox(height: 20),

        // =====================================================================
        // TRENDING TITLE
        // =====================================================================
        const AppShimmer(width: 160, height: 18, radius: 6),

        const SizedBox(height: 10),

        // =====================================================================
        // TRENDING PRODUCTS
        // =====================================================================
        SizedBox(
          height: 260,

          child: ListView.separated(
            scrollDirection: Axis.horizontal,

            itemCount: 3,

            separatorBuilder: (context, index) {
              return const SizedBox(width: 10);
            },

            itemBuilder: (context, index) {
              return const SizedBox(width: 150, child: ProductShimmer());
            },
          ),
        ),

        const SizedBox(height: 20),

        // =====================================================================
        // POPULAR SEARCH TITLE
        // =====================================================================
        const AppShimmer(width: 160, height: 18, radius: 6),

        const SizedBox(height: 10),

        // =====================================================================
        // POPULAR SEARCH
        // =====================================================================
        SizedBox(
          height: 90,

          child: ListView.separated(
            scrollDirection: Axis.horizontal,

            itemCount: 2,

            separatorBuilder: (context, index) {
              return const SizedBox(width: 10);
            },

            itemBuilder: (context, index) {
              return const AppShimmer(width: 140, height: 90, radius: 10);
            },
          ),
        ),

        const SizedBox(height: 20),

        // =====================================================================
        // BEST SELLER TITLE
        // =====================================================================
        const AppShimmer(width: 160, height: 18, radius: 6),

        const SizedBox(height: 10),

        // =====================================================================
        // BEST SELLER PRODUCTS
        // =====================================================================
        SizedBox(
          height: 260,

          child: ListView.separated(
            scrollDirection: Axis.horizontal,

            itemCount: 3,

            separatorBuilder: (context, index) {
              return const SizedBox(width: 10);
            },

            itemBuilder: (context, index) {
              return const SizedBox(width: 150, child: ProductShimmer());
            },
          ),
        ),

        const SizedBox(height: 28),

        // =====================================================================
        // RECIPE HEADER SHIMMER
        // =====================================================================
        Row(
          children: [
            const AppShimmer(width: 4, height: 34, radius: 4),

            const SizedBox(width: 10),

            const AppShimmer(width: 170, height: 20, radius: 5),

            const Spacer(),

            const AppShimmer(width: 36, height: 36, radius: 18),
          ],
        ),

        const SizedBox(height: 14),

        // =====================================================================
        // RECIPE CARD SHIMMER
        // =====================================================================
        const AppShimmer(height: 210, radius: 16),

        const SizedBox(height: 28),

        const Divider(height: 1),

        const SizedBox(height: 24),

        // =====================================================================
        // HOME CHEFS HEADER SHIMMER
        // =====================================================================
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const AppShimmer(width: 4, height: 48, radius: 4),

            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  const AppShimmer(width: 170, height: 20, radius: 5),

                  const SizedBox(height: 7),

                  const AppShimmer(width: 220, height: 12, radius: 4),
                ],
              ),
            ),

            const AppShimmer(width: 36, height: 36, radius: 18),
          ],
        ),

        const SizedBox(height: 14),

        // =====================================================================
        // TESTIMONIAL SHIMMER
        // =====================================================================
        const AppShimmer(height: 285, radius: 16),

        // =====================================================================
        // SMALL BOTTOM GAP
        // =====================================================================
        const SizedBox(height: 24),
      ],
    );
  }
}

// =============================================================================
// STICKY HEADER
// =============================================================================

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double height;

  final Widget child;

  _StickyHeaderDelegate({required this.height, required this.child});

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Material(
      color: Colors.white,

      elevation: overlapsContent ? 2 : 0,

      shadowColor: Colors.black.withValues(alpha: 0.08),

      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant _StickyHeaderDelegate oldDelegate) {
    return oldDelegate.height != height || oldDelegate.child != child;
  }
}

// ==========================================================================
// APP BAR
// ==========================================================================

class LalBabaAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int cartCount;
  final int notificationCount;
  final VoidCallback? onCartTap;
  final VoidCallback? onNotificationTap;

  const LalBabaAppBar({
    super.key,
    this.cartCount = 0,
    this.notificationCount = 0,
    this.onCartTap,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: CartService.count,
      builder: (context, globalCount, child) {
        return AppBar(
          backgroundColor: AppColors.error,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          automaticallyImplyLeading: false,
          titleSpacing: 12,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 56,
                height: 56,
                child: Image.asset(
                  AssetConstants.logo,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.rice_bowl_rounded,
                    color: AppColors.background,
                    size: 36,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'LalBaba',
                    style: TextStyle(
                      color: AppColors.background,
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      height: 1.1,
                      letterSpacing: 0.2,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Quality You Trust',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.4,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            IconButton(
              tooltip: 'Notifications',
              onPressed: onNotificationTap,
              style: IconButton.styleFrom(
                backgroundColor: AppColors.background.withValues(alpha: 0.12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: Badge(
                isLabelVisible: globalCount > 0,
                label: Text(globalCount > 99 ? '99+' : '$globalCount'),
                child: const Icon(
                  Icons.notifications_none_rounded,
                  color: AppColors.background,
                  size: 28,
                ),
              ),
            ),
            const SizedBox(width: 16),
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// ==========================================================================
// SEARCH
// ==========================================================================

class SearchWidget extends StatefulWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  final List<String> searchHints;

  // Search suggestion data
  final List<String> categories;
  final List<Map<String, dynamic>> products;

  final ValueChanged<String>? onCategoryTap;
  final ValueChanged<Map<String, dynamic>>? onProductTap;

  const SearchWidget({
    super.key,
    this.controller,
    this.onChanged,
    this.searchHints = const ['Search for Rice', 'Search for Spices'],
    this.categories = const [],
    this.products = const [],
    this.onCategoryTap,
    this.onProductTap,
  });

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  late final TextEditingController _controller;
  late final bool _ownsController;

  final FocusNode _focusNode = FocusNode();

  Timer? _searchTimer;

  bool _showResult = false;
  bool _isSearching = false;

  List<String> _filteredCategories = [];
  List<Map<String, dynamic>> _filteredProducts = [];

  @override
  void initState() {
    super.initState();

    _ownsController = widget.controller == null;

    _controller = widget.controller ?? TextEditingController();

    _controller.addListener(_onControllerChanged);
  }

  // ===========================================================================
  // CONTROLLER
  // ===========================================================================

  void _onControllerChanged() {
    if (!mounted) return;

    setState(() {});
  }

  // ===========================================================================
  // SEARCH
  // ===========================================================================

  void _onSearchChanged(String value) {
    widget.onChanged?.call(value);

    _searchTimer?.cancel();

    final String query = value.trim().toLowerCase();

    if (query.isEmpty) {
      setState(() {
        _showResult = false;
        _isSearching = false;

        _filteredCategories = [];
        _filteredProducts = [];
      });

      return;
    }

    // Type করার সাথে সাথে shimmer show
    setState(() {
      _showResult = true;
      _isSearching = true;
    });

    // পরে API এলে এখানে API search বসাতে পারো
    _searchTimer = Timer(const Duration(milliseconds: 450), () {
      if (!mounted) return;

      // =============================================================
      // CATEGORY FILTER
      // =============================================================

      final List<String> categories = widget.categories.where((category) {
        return category.toLowerCase().contains(query);
      }).toList();

      // =============================================================
      // PRODUCT FILTER
      // =============================================================

      final List<Map<String, dynamic>> products = widget.products.where((
        product,
      ) {
        final String name = product['name']?.toString().toLowerCase() ?? '';

        return name.contains(query);
      }).toList();

      setState(() {
        _filteredCategories = categories;
        _filteredProducts = products;

        _isSearching = false;
      });
    });
  }

  // ===========================================================================
  // CLEAR
  // ===========================================================================

  void _clearSearch() {
    _searchTimer?.cancel();

    _controller.clear();

    setState(() {
      _showResult = false;
      _isSearching = false;

      _filteredCategories = [];
      _filteredProducts = [];
    });

    widget.onChanged?.call('');

    _focusNode.requestFocus();
  }

  // ===========================================================================
  // CATEGORY TAP
  // ===========================================================================

  void _handleCategoryTap(String category) {
    FocusScope.of(context).unfocus();

    setState(() {
      _showResult = false;
    });

    widget.onCategoryTap?.call(category);
  }

  // ===========================================================================
  // PRODUCT TAP
  // ===========================================================================

  void _handleProductTap(Map<String, dynamic> product) {
    FocusScope.of(context).unfocus();

    setState(() {
      _showResult = false;
    });

    widget.onProductTap?.call(product);
  }

  @override
  void dispose() {
    _searchTimer?.cancel();

    _controller.removeListener(_onControllerChanged);

    _focusNode.dispose();

    if (_ownsController) {
      _controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool hasText = _controller.text.trim().isNotEmpty;

    final bool showRotatingHint = !hasText && widget.searchHints.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ===================================================================
          // SEARCH BAR
          // ===================================================================

          Container(
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFE6E6E6), width: 1),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const SizedBox(width: 10),

                // =============================================================
                // LOGO
                // =============================================================
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Image.asset(
                    AssetConstants.logo,
                    fit: BoxFit.contain,
                    frameBuilder:
                        (
                          BuildContext context,
                          Widget child,
                          int? frame,
                          bool wasSynchronouslyLoaded,
                        ) {
                          if (wasSynchronouslyLoaded) {
                            return child;
                          }

                          if (frame == null) {
                            return const AppShimmer(
                              width: 24,
                              height: 24,
                              radius: 6,
                            );
                          }

                          return child;
                        },
                    errorBuilder:
                        (
                          BuildContext context,
                          Object error,
                          StackTrace? stackTrace,
                        ) {
                          return const Icon(
                            Icons.rice_bowl_rounded,
                            color: AppColors.error,
                            size: 20,
                          );
                        },
                  ),
                ),

                const SizedBox(width: 8),

                Container(width: 1, height: 20, color: const Color(0xFFE6E6E6)),

                const SizedBox(width: 8),

                // =============================================================
                // SEARCH ICON
                // =============================================================
                const Icon(
                  Icons.search_rounded,
                  color: Color(0xFF9A9A9A),
                  size: 22,
                ),

                const SizedBox(width: 6),

                // =============================================================
                // TEXT FIELD
                // =============================================================
                Expanded(
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      if (showRotatingHint)
                        IgnorePointer(
                          child: _VerticalRotatingHint(
                            hints: widget.searchHints,
                          ),
                        ),

                      TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        onChanged: _onSearchChanged,
                        textInputAction: TextInputAction.search,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.black,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 13),
                        ),
                      ),
                    ],
                  ),
                ),

                // =============================================================
                // CLEAR
                // =============================================================
                if (hasText)
                  IconButton(
                    splashRadius: 18,
                    onPressed: _clearSearch,
                    icon: const Icon(
                      Icons.close_rounded,
                      color: Color(0xFF9A9A9A),
                      size: 18,
                    ),
                  )
                else
                  const SizedBox(width: 12),
              ],
            ),
          ),

          // ===================================================================
          // SEARCH RESULT
          // ===================================================================
          if (_showResult && hasText) ...[
            const SizedBox(height: 5),

            if (_isSearching)
              const _SearchResultShimmer()
            else
              _SearchResultBox(
                categories: _filteredCategories,
                products: _filteredProducts,
                onCategoryTap: _handleCategoryTap,
                onProductTap: _handleProductTap,
              ),
          ],
        ],
      ),
    );
  }
}

// =============================================================================
// SEARCH RESULT BOX
// =============================================================================

class _SearchResultBox extends StatelessWidget {
  final List<String> categories;
  final List<Map<String, dynamic>> products;

  final ValueChanged<String> onCategoryTap;
  final ValueChanged<Map<String, dynamic>> onProductTap;

  const _SearchResultBox({
    required this.categories,
    required this.products,
    required this.onCategoryTap,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool noResult = categories.isEmpty && products.isEmpty;

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxHeight: 430),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: const Color(0xFFE8E8E8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ===============================================================
            // CATEGORY SUGGESTIONS
            // ===============================================================

            if (categories.isNotEmpty) ...[
              const _SearchHeader(title: 'CATEGORY SUGGESTIONS'),

              ...categories.map((category) {
                return Material(
                  color: Colors.white,
                  child: InkWell(
                    onTap: () {
                      onCategoryTap(category);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 9,
                      ),
                      child: Text(
                        category,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF202027),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],

            // ===============================================================
            // PRODUCTS
            // ===============================================================
            if (products.isNotEmpty) ...[
              const _SearchHeader(title: 'PRODUCTS'),

              ...products.map((product) {
                return _SearchProductItem(
                  product: product,
                  onTap: () {
                    onProductTap(product);
                  },
                );
              }),
            ],

            // ===============================================================
            // NO RESULT
            // ===============================================================
            if (noResult)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 16),
                child: Column(
                  children: [
                    Icon(
                      Icons.search_off_rounded,
                      size: 34,
                      color: Color(0xFFAAAAAA),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'No results found',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF777777),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// HEADER
// =============================================================================

class _SearchHeader extends StatelessWidget {
  final String title;

  const _SearchHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF1F2F4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      alignment: Alignment.centerRight,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          color: Color(0xFF747A84),
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

// =============================================================================
// PRODUCT ITEM
// =============================================================================

class _SearchProductItem extends StatelessWidget {
  final Map<String, dynamic> product;
  final VoidCallback onTap;

  const _SearchProductItem({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final String name = product['name']?.toString() ?? '';

    final String price = product['price']?.toString() ?? '';

    final String imageUrl = product['imageUrl']?.toString() ?? '';

    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 52,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F7F7),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: _SearchProductImage(imageUrl: imageUrl),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13.5,
                        height: 1.25,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF202027),
                      ),
                    ),

                    if (price.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        price,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// PRODUCT IMAGE
// =============================================================================

class _SearchProductImage extends StatelessWidget {
  final String imageUrl;

  const _SearchProductImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return const _ImagePlaceholder();
    }

    final bool isNetwork =
        imageUrl.startsWith('http://') || imageUrl.startsWith('https://');

    if (isNetwork) {
      return Image.network(
        imageUrl,
        fit: BoxFit.contain,
        loadingBuilder:
            (BuildContext context, Widget child, ImageChunkEvent? progress) {
              if (progress == null) {
                return child;
              }

              return const AppShimmer(width: 46, height: 52, radius: 5);
            },
        errorBuilder: (context, error, stackTrace) {
          return const _ImagePlaceholder();
        },
      );
    }

    return Image.asset(
      imageUrl,
      fit: BoxFit.contain,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) {
          return child;
        }

        if (frame == null) {
          return const AppShimmer(width: 46, height: 52, radius: 5);
        }

        return child;
      },
      errorBuilder: (context, error, stackTrace) {
        return const _ImagePlaceholder();
      },
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Icon(Icons.image_outlined, size: 24, color: Color(0xFFAAAAAA)),
    );
  }
}

// =============================================================================
// SEARCH SHIMMER
// =============================================================================

class _SearchResultShimmer extends StatelessWidget {
  const _SearchResultShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: AppShimmer(width: 135, height: 12, radius: 4),
          ),

          SizedBox(height: 12),

          AppShimmer(width: 90, height: 14, radius: 4),

          SizedBox(height: 10),

          AppShimmer(width: 120, height: 14, radius: 4),

          SizedBox(height: 15),

          Align(
            alignment: Alignment.centerRight,
            child: AppShimmer(width: 70, height: 12, radius: 4),
          ),

          SizedBox(height: 12),

          _ProductResultShimmer(),

          SizedBox(height: 10),

          _ProductResultShimmer(),
        ],
      ),
    );
  }
}

class _ProductResultShimmer extends StatelessWidget {
  const _ProductResultShimmer();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        AppShimmer(width: 46, height: 52, radius: 5),

        SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppShimmer(height: 13, radius: 4),
              SizedBox(height: 8),
              AppShimmer(width: 75, height: 13, radius: 4),
            ],
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// ROTATING HINT
// =============================================================================

class _VerticalRotatingHint extends StatefulWidget {
  final List<String> hints;

  const _VerticalRotatingHint({required this.hints});

  @override
  State<_VerticalRotatingHint> createState() => _VerticalRotatingHintState();
}

class _VerticalRotatingHintState extends State<_VerticalRotatingHint>
    with SingleTickerProviderStateMixin {
  static const double _lineHeight = 18;

  static const TextStyle _hintStyle = TextStyle(
    fontSize: 14,
    color: Color(0xFF9A9A9A),
  );

  late final AnimationController _controller;

  Timer? _timer;

  int _currentIndex = 0;
  int _nextIndex = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );

    if (widget.hints.length > 1) {
      _nextIndex = 1;

      _timer = Timer.periodic(const Duration(seconds: 2), (_) => _rotate());
    }
  }

  Future<void> _rotate() async {
    if (!mounted || widget.hints.length <= 1 || _controller.isAnimating) {
      return;
    }

    await _controller.forward(from: 0);

    if (!mounted) return;

    setState(() {
      _currentIndex = _nextIndex;

      _nextIndex = (_nextIndex + 1) % widget.hints.length;
    });

    _controller.value = 0;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.hints.isEmpty) {
      return const SizedBox.shrink();
    }

    if (widget.hints.length == 1) {
      return Text(
        widget.hints.first,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: _hintStyle,
      );
    }

    return ClipRect(
      child: SizedBox(
        height: _lineHeight,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final double t = _controller.value;

            return Stack(
              children: [
                Positioned(
                  top: -t * _lineHeight,
                  left: 0,
                  right: 0,
                  child: Opacity(
                    opacity: 1 - t,
                    child: Text(
                      widget.hints[_currentIndex],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: _hintStyle,
                    ),
                  ),
                ),

                Positioned(
                  top: _lineHeight - t * _lineHeight,
                  left: 0,
                  right: 0,
                  child: Opacity(
                    opacity: t,
                    child: Text(
                      widget.hints[_nextIndex],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: _hintStyle,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ==========================================================================
// CATEGORY
// ==========================================================================

class CategoryWidget extends StatefulWidget {
  final List<String> names;
  final ValueChanged<String>? onCategoryTap;
  final int? selectedIndex;
  const CategoryWidget({
    super.key,
    required this.names,
    this.onCategoryTap,
    this.selectedIndex,
  });
  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  static const Color _primary = Color(0xFFf70707);
  static const Color _background = Color(0xFFffffff);
  static const Color _grey = Color(0xFF6B6B6B);
  static const Color _border = Color(0xFFE6E6E6);
  static const Color _accent = _primary;
  late int _internalSelectedIndex;

  @override
  void initState() {
    super.initState();
    _internalSelectedIndex = widget.selectedIndex ?? 0;
  }

  @override
  void didUpdateWidget(covariant CategoryWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedIndex != null &&
        widget.selectedIndex != oldWidget.selectedIndex) {
      _internalSelectedIndex = widget.selectedIndex!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: _background,
      padding: const EdgeInsets.symmetric(vertical: 10),
      height: 60,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: widget.names.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final String name = widget.names[index];
          final bool isSelected = index == _internalSelectedIndex;
          return Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () {
                setState(() => _internalSelectedIndex = index);
                widget.onCategoryTap?.call(name);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? _accent : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: isSelected ? _accent : _border),
                  boxShadow: [
                    BoxShadow(
                      color: isSelected
                          ? _accent.withValues(alpha: 0.30)
                          : Colors.black.withValues(alpha: 0.04),
                      blurRadius: isSelected ? 10 : 6,
                      offset: Offset(0, isSelected ? 4 : 2),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    color: isSelected ? Colors.white : _grey,
                    letterSpacing: 0.1,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ==========================================================================
// BANNER
// ==========================================================================

class BannerWidget extends StatefulWidget {
  final ValueChanged<int>? onBannerTap;

  const BannerWidget({super.key, this.onBannerTap});

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  // ===========================================================================
  // COLORS
  // ===========================================================================

  static const Color _primary = Color(0xFFF70707);

  static const Color _black = Color(0xFF000000);

  static const Color _grey = Color(0xFF9E9E9E);

  // ===========================================================================
  // BANNER IMAGE URLS
  // ===========================================================================

  static const List<String> _bannerImageUrls = [
    'https://lalbabaonline.com/public/uploads/all/XuxYGkH5U1dpGFcK5x3SBtphEhgDg2hka78lG3vS.webp',
    'https://lalbabaonline.com/public/uploads/all/ih7h1OcLwu13H3TVKBdIOyNVgIp4pP3PoQa9coxj.webp',
    'https://lalbabaonline.com/public/uploads/all/96hqz7NNM37PLDfGpg3fNEm4joTpvgftraurkNVR.webp',
    'https://lalbabaonline.com/public/uploads/all/EryH9j4ylQ7qtbZM5iyUuUvTvn6gUwoy7WOluwe9.webp',
  ];

  // ===========================================================================
  // PAGE CONTROLLER
  // ===========================================================================

  late final PageController _pageController;

  Timer? _autoScrollTimer;

  int _currentIndex = 0;

  int get _bannerCount => _bannerImageUrls.length;

  // ===========================================================================
  // INIT STATE
  // ===========================================================================

  @override
  void initState() {
    super.initState();

    // -------------------------------------------------------------------------
    // IMPORTANT
    //
    // Previous:
    // initialPage: 10000
    //
    // Now:
    // initialPage: 0
    //
    // Fake infinite page system completely removed.
    // -------------------------------------------------------------------------

    _pageController = PageController(initialPage: 0, viewportFraction: 0.92);

    // -------------------------------------------------------------------------
    // AUTO SCROLL
    // -------------------------------------------------------------------------

    if (_bannerCount > 1) {
      _autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (_) {
        _goToNext();
      });
    }
  }

  // ===========================================================================
  // AUTO NEXT
  // ===========================================================================

  void _goToNext() {
    // Page dispose hoye gele kichu korbe na.
    if (!mounted) {
      return;
    }

    // Controller PageView-er sathe attach na hole return.
    if (!_pageController.hasClients) {
      return;
    }

    // Single banner hole auto scroll dorkar nei.
    if (_bannerCount <= 1) {
      return;
    }

    // -------------------------------------------------------------------------
    // NEXT PAGE
    //
    // Example:
    //
    // 0 -> 1
    // 1 -> 2
    // 2 -> 3
    // 3 -> 0
    //
    // -------------------------------------------------------------------------

    final int nextIndex = (_currentIndex + 1) % _bannerCount;

    _pageController.animateToPage(
      nextIndex,
      duration: const Duration(milliseconds: 550),
      curve: Curves.easeInOutCubic,
    );
  }

  // ===========================================================================
  // DISPOSE
  // ===========================================================================

  @override
  void dispose() {
    _autoScrollTimer?.cancel();

    _pageController.dispose();

    super.dispose();
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    if (_bannerCount == 0) {
      return const SizedBox.shrink();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // =====================================================================
        // BANNER CAROUSEL
        // =====================================================================

        SizedBox(
          height: 150,
          width: double.infinity,
          child: PageView.builder(
            controller: _pageController,

            // -----------------------------------------------------------------
            // IMPORTANT FIX
            //
            // OLD:
            // itemCount: 100000
            //
            // NEW:
            // Real banner count only.
            // -----------------------------------------------------------------
            itemCount: _bannerCount,

            clipBehavior: Clip.hardEdge,

            // -----------------------------------------------------------------
            // PAGE CHANGE
            // -----------------------------------------------------------------
            onPageChanged: (index) {
              if (!mounted) {
                return;
              }

              setState(() {
                _currentIndex = index;
              });
            },

            // -----------------------------------------------------------------
            // ITEM
            // -----------------------------------------------------------------
            itemBuilder: (context, index) {
              final String imageUrl = _bannerImageUrls[index];

              return AnimatedBuilder(
                animation: _pageController,

                builder: (context, child) {
                  double scale = 1.0;

                  // -----------------------------------------------------------
                  // ACTIVE PAGE SCALE EFFECT
                  // -----------------------------------------------------------

                  if (_pageController.hasClients &&
                      _pageController.position.haveDimensions) {
                    final double page =
                        _pageController.page ?? _currentIndex.toDouble();

                    final double distance = (page - index).abs();

                    scale = (1 - (distance * 0.06)).clamp(0.94, 1.0);
                  }

                  return Transform.scale(scale: scale, child: child);
                },

                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),

                  child: GestureDetector(
                    // ---------------------------------------------------------
                    // BANNER TAP
                    // ---------------------------------------------------------

                    onTap: () {
                      widget.onBannerTap?.call(index);
                    },

                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: _black.withValues(alpha: 0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),

                      clipBehavior: Clip.antiAlias,

                      child: _BannerImage(imageUrl: imageUrl),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // =====================================================================
        // DOT INDICATOR
        // =====================================================================
        if (_bannerCount > 1) ...[
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: List.generate(_bannerCount, (index) {
              final bool isActive = index == _currentIndex;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 220),

                margin: const EdgeInsets.symmetric(horizontal: 3),

                width: isActive ? 18 : 6,

                height: 6,

                decoration: BoxDecoration(
                  color: isActive ? _primary : _grey.withValues(alpha: 0.40),

                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }
}

// =============================================================================
// BANNER IMAGE
// =============================================================================

class _BannerImage extends StatelessWidget {
  final String imageUrl;

  const _BannerImage({required this.imageUrl});

  static const Color _secondary = Color(0xFFEEE4E4);

  static const Color _primary = Color(0xFFF70707);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,

      width: double.infinity,

      height: double.infinity,

      fit: BoxFit.cover,

      // =======================================================================
      // IMAGE LOADING
      // =======================================================================
      loadingBuilder:
          (
            BuildContext context,
            Widget child,
            ImageChunkEvent? loadingProgress,
          ) {
            if (loadingProgress == null) {
              return child;
            }

            // Loading-er somoy simple placeholder.
            // CircularProgressIndicator rakha hoyni.

            return Container(
              width: double.infinity,
              height: double.infinity,
              color: _secondary,
            );
          },

      // =======================================================================
      // IMAGE ERROR
      // =======================================================================
      errorBuilder:
          (BuildContext context, Object error, StackTrace? stackTrace) {
            return Container(
              width: double.infinity,

              height: double.infinity,

              color: _secondary,

              alignment: Alignment.center,

              child: const Icon(
                Icons.image_not_supported_outlined,
                color: _primary,
                size: 26,
              ),
            );
          },
    );
  }
}

// ==========================================================================
// TRENDING
// ==========================================================================

class TrendingWidget extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final ValueChanged<Map<String, dynamic>>? onProductTap;
  final void Function(Map<String, dynamic> product)? onAddToCart;
  final VoidCallback? onViewAllTap;
  const TrendingWidget({
    super.key,
    required this.products,
    this.onProductTap,
    this.onAddToCart,
    this.onViewAllTap,
  });
  @override
  Widget build(BuildContext context) => SectionCardWidget(
    title: AppStrings.trendingThisWeek,
    products: products,
    onProductTap: onProductTap,
    onAddToCart: onAddToCart,
    onViewAllTap: onViewAllTap,
  );
}

// ==========================================================================
// BEST SELLER
// ==========================================================================

class BestSellerWidget extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final ValueChanged<Map<String, dynamic>>? onProductTap;
  final void Function(Map<String, dynamic> product)? onAddToCart;
  final VoidCallback? onViewAllTap;
  const BestSellerWidget({
    super.key,
    required this.products,
    this.onProductTap,
    this.onAddToCart,
    this.onViewAllTap,
  });
  @override
  Widget build(BuildContext context) => SectionCardWidget(
    title: AppStrings.bestSeller,
    products: products,
    onProductTap: onProductTap,
    onAddToCart: onAddToCart,
    onViewAllTap: onViewAllTap,
  );
}

// ==========================================================================
// SECTION CARDS
// ==========================================================================

class SectionCardWidget extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> products;
  final void Function(Map<String, dynamic> product)? onProductTap;
  final void Function(Map<String, dynamic> product)? onAddToCart;
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
  static const double _minCardWidth = 150;
  static const double _maxCardWidth = 210;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();
    return LayoutBuilder(
      builder: (context, constraints) {
        final double screenWidth = constraints.maxWidth > 0
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        final double usableWidth =
            screenWidth - (_outerMargin * 2) - (_railPadding * 2);
        final double twoCardWidth = (usableWidth - _cardGap) / 2;
        final double cardWidth = twoCardWidth
            .clamp(_minCardWidth, _maxCardWidth)
            .toDouble();
        final double imageHeight = (cardWidth * 0.70)
            .clamp(100.0, 125.0)
            .toDouble();
        return Container(
          margin: const EdgeInsets.symmetric(
            horizontal: _outerMargin,
            vertical: 6,
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: _railPadding),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        softWrap: true,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          height: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(6),
                        onTap: onViewAllTap,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 6,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'View All',
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(width: 2),
                              Icon(
                                Icons.chevron_right,
                                size: 18,
                                color: Colors.black,
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
              SizedBox(
                height: 264,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: _railPadding),
                  itemCount: products.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: _cardGap),
                  itemBuilder: (context, index) {
                    final Map<String, dynamic> product = products[index];
                    final dynamic ratingValue = product['rating'];
                    final double rating = ratingValue is num
                        ? ratingValue.toDouble()
                        : 0;
                    return ProductCardWidget(
                      name: product['name']?.toString() ?? '',
                      imageUrl: product['imageUrl']?.toString() ?? '',
                      price: product['price']?.toString() ?? '',
                      originalPrice: product['originalPrice']?.toString(),
                      discountLabel: product['discountLabel']?.toString(),
                      rating: rating,
                      showPriceAndRating: true,
                      width: cardWidth,
                      imageHeight: imageHeight,
                      onTap: () => onProductTap?.call(product),
                      onAddToCart: onAddToCart == null
                          ? null
                          : () => onAddToCart!(product),
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

// ==========================================================================
// PRODUCT CARDS
// ==========================================================================

class ProductCardWidget extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String price;
  final String? originalPrice;
  final String? discountLabel;
  final double rating;

  final bool showPriceAndRating;

  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;

  final double width;
  final double imageHeight;

  const ProductCardWidget({
    super.key,
    required this.name,
    required this.imageUrl,
    this.price = '',
    this.originalPrice,
    this.discountLabel,
    this.rating = 0,
    this.showPriceAndRating = false,
    this.onTap,
    this.onAddToCart,
    this.width = 150,
    this.imageHeight = 105,
  });

  static const Color accentColor = Color(0xFFE23F1C);

  static const Color _ratingGreen = Color(0xFF2E7D32);

  static const Color _black = Color(0xFF212121);

  static const Color _grey = Color(0xFF878787);

  static const Color _imageBg = Color(0xFFFAFAFA);

  @override
  Widget build(BuildContext context) {
    final bool compact = width < 160;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFF0F0F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ============================================================
              // PRODUCT IMAGE
              // ============================================================

              SizedBox(
                height: imageHeight,
                width: double.infinity,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        color: _imageBg,
                        padding: EdgeInsets.all(compact ? 7 : 10),
                        child: _buildProductImage(),
                      ),
                    ),

                    // ======================================================
                    // DISCOUNT BADGE
                    // ======================================================
                    if (discountLabel != null &&
                        discountLabel!.trim().isNotEmpty)
                      Positioned(
                        top: 7,
                        left: 7,
                        child: Container(
                          constraints: BoxConstraints(maxWidth: width - 14),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: accentColor,
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: accentColor.withValues(alpha: 0.35),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            discountLabel!,
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // ============================================================
              // PRODUCT INFORMATION
              // ============================================================
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 7, 10, 4),
                  child: showPriceAndRating
                      ? _buildFullInfo(compact)
                      : _buildSimpleInfo(compact),
                ),
              ),

              // ============================================================
              // ADD TO CART BUTTON
              // ============================================================
              if (onAddToCart != null)
                SizedBox(
                  height: 39,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 1, 8, 7),
                    child: SizedBox(
                      width: double.infinity,
                      height: 31,
                      child: ElevatedButton(
                        onPressed: onAddToCart,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentColor,
                          foregroundColor: Colors.white,
                          elevation: 0,

                          // Important:
                          // default minimum
                          // button width remove.
                          minimumSize: Size.zero,

                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 0,
                          ),

                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,

                          visualDensity: VisualDensity.compact,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add_shopping_cart_rounded, size: 14),
                              SizedBox(width: 5),
                              Text(
                                'Add to Cart',
                                maxLines: 1,
                                softWrap: false,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // FULL INFO
  // ==========================================================================

  Widget _buildFullInfo(bool compact) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ================================================================
        // PRODUCT NAME
        // ================================================================

        Flexible(
          child: Text(
            name,

            // maxLines + ellipsis remove.
            // Text available space-er moddhe
            // naturally wrap korbe.
            softWrap: true,

            overflow: TextOverflow.fade,

            style: TextStyle(
              fontSize: compact ? 11.8 : 12.5,
              fontWeight: FontWeight.w600,
              color: _black,
              height: 1.22,
            ),
          ),
        ),

        const SizedBox(height: 5),

        // ================================================================
        // RATING
        // ================================================================
        if (rating > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            decoration: BoxDecoration(
              color: _ratingGreen,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  rating.toStringAsFixed(1),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 2),
                const Icon(Icons.star_rounded, size: 11, color: Colors.white),
              ],
            ),
          ),

        if (rating > 0) const SizedBox(height: 5),

        // ================================================================
        // PRICE
        // ================================================================
        if (price.isNotEmpty ||
            (originalPrice != null && originalPrice!.isNotEmpty))
          Wrap(
            spacing: 6,
            runSpacing: 2,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (price.isNotEmpty)
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: _black,
                  ),
                ),

              if (originalPrice != null && originalPrice!.isNotEmpty)
                Text(
                  originalPrice!,
                  style: const TextStyle(
                    fontSize: 11,
                    color: _grey,
                    decoration: TextDecoration.lineThrough,
                    decorationColor: _grey,
                  ),
                ),
            ],
          ),
      ],
    );
  }

  // ==========================================================================
  // SIMPLE INFO
  // ==========================================================================

  Widget _buildSimpleInfo(bool compact) {
    return Align(
      alignment: Alignment.topCenter,
      child: Text(
        name,
        textAlign: TextAlign.center,
        softWrap: true,
        overflow: TextOverflow.fade,
        style: TextStyle(
          fontSize: compact ? 11.5 : 12,
          fontWeight: FontWeight.w600,
          color: _black,
          height: 1.25,
        ),
      ),
    );
  }

  // ==========================================================================
  // PRODUCT IMAGE
  // ==========================================================================

  Widget _buildProductImage() {
    if (imageUrl.trim().isEmpty) {
      return const Center(
        child: Icon(Icons.image_outlined, size: 32, color: Colors.grey),
      );
    }

    final bool isNetwork =
        imageUrl.startsWith('http://') || imageUrl.startsWith('https://');

    if (isNetwork) {
      return Image.network(
        imageUrl,
        fit: BoxFit.contain,
        width: double.infinity,
        height: double.infinity,
        loadingBuilder:
            (
              BuildContext context,
              Widget child,
              ImageChunkEvent? loadingProgress,
            ) {
              if (loadingProgress == null) {
                return child;
              }

              return AppShimmer(
                width: double.infinity,
                height: imageHeight,
                radius: 10,
              );
            },
        errorBuilder:
            (BuildContext context, Object error, StackTrace? stackTrace) {
              return const Center(
                child: Icon(Icons.image_outlined, size: 32, color: Colors.grey),
              );
            },
      );
    }

    return Image.asset(
      imageUrl,
      fit: BoxFit.contain,
      width: double.infinity,
      height: double.infinity,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) {
          return child;
        }

        if (frame == null) {
          return AppShimmer(
            width: double.infinity,
            height: imageHeight,
            radius: 10,
          );
        }

        return child;
      },
      errorBuilder: (context, error, stackTrace) {
        return const Center(
          child: Icon(Icons.image_outlined, size: 32, color: Colors.grey),
        );
      },
    );
  }
}

// ==========================================================================
// POPULAR SEARCH
// ==========================================================================

class PopularSearchWidget extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  final ValueChanged<Map<String, dynamic>>? onProductTap;

  const PopularSearchWidget({
    super.key,
    required this.products,
    this.onProductTap,
  });

  static const Color _accent = AppColors.primary;

  static const Color _black = Color(0xFF212121);

  static const double _gap = 12;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final double availableWidth = constraints.maxWidth > 0
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;

        final double usableWidth = availableWidth - 48;

        final double twoTileWidth = (usableWidth - _gap) / 2;

        final double tileWidth = twoTileWidth.clamp(140.0, 190.0).toDouble();

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFFE9E0), Color(0xFFFFF3E0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: _accent.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =============================================================
              // HEADER
              // =============================================================

              Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: _accent,
                      borderRadius: BorderRadius.circular(9),
                      boxShadow: [
                        BoxShadow(
                          color: _accent.withValues(alpha: 0.35),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.local_fire_department_rounded,
                      color: AppColors.primaryLight,
                      size: 18,
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      AppStrings.popularSearch,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _black,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // =============================================================
              // PRODUCT LIST
              // =============================================================
              SizedBox(
                height: 165,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: products.length,
                  separatorBuilder: (context, index) {
                    return const SizedBox(width: _gap);
                  },
                  itemBuilder: (context, index) {
                    final product = products[index];

                    return SizedBox(
                      width: tileWidth,
                      child: _PopularSearchTile(
                        name: product['name']?.toString() ?? '',
                        imageUrl: product['imageUrl']?.toString() ?? '',
                        discountLabel: product['discountLabel']?.toString(),
                        onTap: () {
                          onProductTap?.call(product);
                        },
                      ),
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

// =============================================================================
// TILE
// =============================================================================

class _PopularSearchTile extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String? discountLabel;
  final VoidCallback? onTap;

  const _PopularSearchTile({
    required this.name,
    required this.imageUrl,
    this.discountLabel,
    this.onTap,
  });

  static const Color _accent = AppColors.primary;

  static const Color _black = Color(0xFF212121);

  static const Color _grey = Color(0xFF666666);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _buildImage(),

                    if (discountLabel != null &&
                        discountLabel!.trim().isNotEmpty)
                      Positioned(
                        top: 6,
                        left: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: _accent,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: _accent.withValues(alpha: 0.35),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.arrow_downward_rounded,
                                size: 10,
                                color: AppColors.primaryLight,
                              ),

                              const SizedBox(width: 1),

                              Text(
                                discountLabel!,
                                maxLines: 1,
                                overflow: TextOverflow.fade,
                                softWrap: false,
                                style: const TextStyle(
                                  color: AppColors.primaryLight,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(8, 7, 8, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.fade,
                      softWrap: true,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: _grey,
                        height: 1.2,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _accent.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppStrings.dealsForYou,
                          maxLines: 1,
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: _black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (imageUrl.trim().isEmpty) {
      return Container(
        color: const Color(0xFFF5F5F5),
        alignment: Alignment.center,
        child: const Icon(Icons.image_outlined, size: 28, color: Colors.grey),
      );
    }

    final bool isNetwork =
        imageUrl.startsWith('http://') || imageUrl.startsWith('https://');

    if (isNetwork) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        loadingBuilder:
            (BuildContext context, Widget child, ImageChunkEvent? progress) {
              if (progress == null) {
                return child;
              }

              return Container(color: const Color(0xFFF5F5F5));
            },
        errorBuilder:
            (BuildContext context, Object error, StackTrace? stackTrace) {
              return Container(
                color: const Color(0xFFF5F5F5),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.image_outlined,
                  size: 28,
                  color: Colors.grey,
                ),
              );
            },
      );
    }

    return Image.asset(
      imageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: const Color(0xFFF5F5F5),
          alignment: Alignment.center,
          child: const Icon(Icons.image_outlined, size: 28, color: Colors.grey),
        );
      },
    );
  }
}

// ==========================================================================
// RECIPES
// ==========================================================================

class RecipeWidget extends StatefulWidget {
  final ValueChanged<int>? onRecipeTap;

  const RecipeWidget({super.key, this.onRecipeTap});

  @override
  State<RecipeWidget> createState() => _RecipeWidgetState();
}

class _RecipeWidgetState extends State<RecipeWidget> {
  static const Color _primary = Color(0xFFF70707);

  static const Color _black = Color(0xFF212121);

  static const Color _grey = Color(0xFF777777);

  // ===========================================================================
  // RECIPE DATA
  // ===========================================================================

  static const List<Map<String, String>> _recipes = [
    {
      'imageUrl':
          'https://lalbabaonline.com/public/uploads/all/y4NE0in0SBidT7FjYc9OkOWMDt9PelZi9U4wEHA6.webp',
      'title': 'Basmati Mixed Fried Rice (Indo-Chinese Style)',
    },
    {
      'imageUrl':
          'https://lalbabaonline.com/public/uploads/all/tyyWmiCV2vMtiFKPeYq43STzLh6LhjGAuPakXxGo.webp',
      'title': 'Vegetable Pulao (Light & Fragrant)',
    },
    {
      'imageUrl':
          'https://lalbabaonline.com/public/uploads/all/00D3pqgepFevSrA9fvG42scBArhC8QkSU41HmDQJ.webp',
      'title': 'Classic Chicken Biryani',
    },
    {
      'imageUrl':
          'https://lalbabaonline.com/public/uploads/all/SuNZxBfg7s4Mx4XxK6N4wqcG9qCrOYxDmuPdm6td.webp',
      'title': 'Lemon Rice (South Indian Style)',
    },
    {
      'imageUrl':
          'https://lalbabaonline.com/public/uploads/all/dS7re1Qz0FvnooB5aLCN1HumVF5qwmOcaHnnuN10.webp',
      'title': 'Coconut Rice (Kerala Style)',
    },
  ];

  // ===========================================================================
  // PAGE CONTROLLER
  // ===========================================================================

  late final PageController _pageController;

  Timer? _autoScrollTimer;

  int _currentPage = 0;

  int get _recipeCount => _recipes.length;

  // ===========================================================================
  // INIT
  // ===========================================================================

  @override
  void initState() {
    super.initState();

    _pageController = PageController(
      initialPage: 0,

      // Next card-er halka preview dekhabe
      // kintu section-er baire jabe na
      viewportFraction: 0.90,
    );

    if (_recipeCount > 1) {
      _autoScrollTimer = Timer.periodic(const Duration(seconds: 4), (_) {
        _goToNext();
      });
    }
  }

  // ===========================================================================
  // AUTO NEXT
  // ===========================================================================

  void _goToNext() {
    if (!_pageController.hasClients) {
      return;
    }

    if (_recipeCount <= 1) {
      return;
    }

    int nextPage = _currentPage + 1;

    // Last recipe-er por abar first recipe
    if (nextPage >= _recipeCount) {
      nextPage = 0;
    }

    _pageController.animateToPage(
      nextPage,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
    );
  }

  // ===========================================================================
  // DISPOSE
  // ===========================================================================

  @override
  void dispose() {
    _autoScrollTimer?.cancel();

    _pageController.dispose();

    super.dispose();
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    if (_recipes.isEmpty) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: AppLanguageConstants.instance,
      builder: (context, child) {
        return Container(
          width: double.infinity,

          // Recipe section-er nijer space
          margin: const EdgeInsets.only(top: 20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===============================================================
              // RECIPE HEADER
              // ===============================================================

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ---------------------------------------------------------
                    // RED LINE
                    // ---------------------------------------------------------

                    Container(
                      width: 4,
                      height: 34,
                      decoration: BoxDecoration(
                        color: _primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    const SizedBox(width: 10),

                    // ---------------------------------------------------------
                    // TITLE
                    // ---------------------------------------------------------
                    Expanded(
                      child: Text(
                        AppStrings.recipesYoullLove,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: _black,
                        ),
                      ),
                    ),

                    // ---------------------------------------------------------
                    // ICON
                    // ---------------------------------------------------------
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: _primary.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.restaurant_menu_rounded,
                        size: 20,
                        color: _primary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // ===============================================================
              // RECIPE CAROUSEL
              // ===============================================================
              SizedBox(
                height: 210,
                width: double.infinity,
                child: PageView.builder(
                  controller: _pageController,

                  itemCount: _recipeCount,

                  // Card section-er baire berobe na
                  clipBehavior: Clip.hardEdge,

                  onPageChanged: (index) {
                    _currentPage = index;
                  },

                  itemBuilder: (context, index) {
                    final recipe = _recipes[index];

                    return Padding(
                      padding: EdgeInsets.only(
                        left: index == 0 ? 16 : 6,
                        right: 10,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          widget.onRecipeTap?.call(index);
                        },
                        child: _RecipeCard(
                          imageUrl: recipe['imageUrl']!,
                          title: recipe['title']!,
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 28),

              // ===============================================================
              // SECTION DIVIDER
              // Recipe ar Happy Home Chef clearly separate korbe
              // ===============================================================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  height: 1,
                  width: double.infinity,
                  color: const Color(0xFFE8E8E8),
                ),
              ),

              const SizedBox(height: 4),
            ],
          ),
        );
      },
    );
  }
}

// =============================================================================
// RECIPE CARD
// =============================================================================

class _RecipeCard extends StatelessWidget {
  final String imageUrl;
  final String title;

  const _RecipeCard({required this.imageUrl, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(16),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      clipBehavior: Clip.antiAlias,

      child: Stack(
        fit: StackFit.expand,
        children: [
          // ===================================================================
          // IMAGE
          // ===================================================================

          _RecipeImage(imageUrl: imageUrl),

          // ===================================================================
          // DARK GRADIENT
          // ===================================================================
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Color(0x18000000),
                    Color(0xD9000000),
                  ],
                  stops: [0, 0.55, 1],
                ),
              ),
            ),
          ),

          // ===================================================================
          // RECIPE TITLE
          // ===================================================================
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w800,
                height: 1.3,
                shadows: [
                  Shadow(
                    color: Colors.black45,
                    blurRadius: 4,
                    offset: Offset(0, 1),
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

// =============================================================================
// RECIPE IMAGE
// =============================================================================

class _RecipeImage extends StatelessWidget {
  final String imageUrl;

  const _RecipeImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,

      fit: BoxFit.cover,

      width: double.infinity,

      height: double.infinity,

      // =======================================================================
      // IMAGE LOADING
      // =======================================================================
      loadingBuilder: (context, child, progress) {
        if (progress == null) {
          return child;
        }

        return const AppShimmer(
          width: double.infinity,
          height: double.infinity,
          radius: 16,
        );
      },

      // =======================================================================
      // IMAGE ERROR
      // =======================================================================
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: const Color(0xFFF4F4F4),
          alignment: Alignment.center,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image_not_supported_outlined,
                color: Color(0xFFF70707),
                size: 30,
              ),

              SizedBox(height: 6),

              Text(
                'Image unavailable',
                style: TextStyle(color: Color(0xFF777777), fontSize: 11),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ==========================================================================
// HOME CHEFS
// ==========================================================================

class TestimonialWidget extends StatefulWidget {
  final ValueChanged<int>? onReviewTap;

  const TestimonialWidget({super.key, this.onReviewTap});

  @override
  State<TestimonialWidget> createState() => _TestimonialWidgetState();
}

class _TestimonialWidgetState extends State<TestimonialWidget> {
  static const Color _navy = Color(0xFF1E2A6E);

  static const Color _black = Color(0xFF212121);

  static const Color _grey = Color(0xFF6B6B6B);

  // ===========================================================================
  // REVIEWS
  // ===========================================================================

  static const List<Map<String, String>> _reviews = [
    {
      'imageUrl':
          'https://lalbabaonline.com/public/uploads/all/pZbNxM9gJAzjo8IdurZClyu6VmIiK7FX39jNrg4j.webp',
      'quote':
          'We loved the overall experience. The food is scrumptious! They were very courteous. We are regular customers now.',
      'name': 'Jharna Bose (Homemaker)',
    },
    {
      'imageUrl':
          'https://lalbabaonline.com/public/uploads/all/bURkWLeNCHrdLRsGW9HZHCIhPhvN6NbfT0kAnRLf.webp',
      'quote':
          'Good products, the company is very professional and helpful. Quick solution for the smallest problem.',
      'name': 'Sana Khan (Homemaker)',
    },
    {
      'imageUrl':
          'https://lalbabaonline.com/public/uploads/all/HiUcgKV7lcSs2SHhulqBb7ukhTY844mqzYl8fNnZ.webp',
      'quote':
          'As a caterer, consistency is everything. Lalbaba\'s quality never wavers — always reliable.',
      'name': 'Priya Sharma (Catering Manager)',
    },
    {
      'imageUrl':
          'https://lalbabaonline.com/public/uploads/all/k7XzoAL0hBmbXGiBggtgObemLqZs0Y44HbEdaUec.webp',
      'quote':
          'Perfect for biryani and pulao — long, consistent grains that give restaurant-style results at home.',
      'name': 'Rajiv Mehra (Home Chef)',
    },
    {
      'imageUrl':
          'https://lalbabaonline.com/public/uploads/all/rf8rf1loASwSeArbhayRZ7vZJepqwzJClfiOjEzw.webp',
      'quote':
          'Quick to cook and rice stays soft — my kids ask for Lalbaba rice every day.',
      'name': 'Neha Roy (Homemaker)',
    },
    {
      'imageUrl':
          'https://lalbabaonline.com/public/uploads/all/Omd0y1GhNijua9gvV33wwGjpSYDnaJtdFHc9elRX.webp',
      'quote':
          'Excellent value — fragrant, non-sticky rice that my small restaurant customers love.',
      'name': 'Subhajit Chatterjee (Restaurant Owner)',
    },
  ];

  // ===========================================================================
  // CONTROLLER
  // ===========================================================================

  late final PageController _pageController;

  Timer? _autoScrollTimer;

  int _currentPage = 0;

  int get _reviewCount => _reviews.length;

  // ===========================================================================
  // INIT
  // ===========================================================================

  @override
  void initState() {
    super.initState();

    // IMPORTANT:
    // initialPage 10000 remove kora hoyeche.
    _pageController = PageController(initialPage: 0, viewportFraction: 0.86);

    if (_reviewCount > 1) {
      _autoScrollTimer = Timer.periodic(const Duration(seconds: 4), (_) {
        _goToNext();
      });
    }
  }

  // ===========================================================================
  // AUTO SCROLL
  // ===========================================================================

  void _goToNext() {
    if (!mounted) {
      return;
    }

    if (!_pageController.hasClients) {
      return;
    }

    if (_reviewCount <= 1) {
      return;
    }

    final int nextPage = (_currentPage + 1) % _reviewCount;

    _pageController.animateToPage(
      nextPage,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
    );
  }

  // ===========================================================================
  // DISPOSE
  // ===========================================================================

  @override
  void dispose() {
    _autoScrollTimer?.cancel();

    _pageController.dispose();

    super.dispose();
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    if (_reviews.isEmpty) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: AppLanguageConstants.instance,
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(14, 24, 14, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===============================================================
              // HEADER
              // ===============================================================

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // -----------------------------------------------------------
                  // BLUE LINE
                  // -----------------------------------------------------------

                  Container(
                    width: 4,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _navy,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // -----------------------------------------------------------
                  // TITLE + SUBTITLE
                  // -----------------------------------------------------------
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.happyHomeChefs,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: _black,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          AppStrings.homeChefsSubtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12.5,
                            height: 1.35,
                            color: _grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 10),

                  // -----------------------------------------------------------
                  // QUOTE ICON
                  // -----------------------------------------------------------
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: _navy.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.format_quote_rounded,
                      color: _navy,
                      size: 22,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ===============================================================
              // REVIEW CAROUSEL
              // ===============================================================
              SizedBox(
                height: 285,
                width: double.infinity,
                child: PageView.builder(
                  controller: _pageController,

                  // IMPORTANT
                  // 100000 REMOVE
                  itemCount: _reviewCount,

                  clipBehavior: Clip.hardEdge,

                  onPageChanged: (index) {
                    if (!mounted) {
                      return;
                    }

                    setState(() {
                      _currentPage = index;
                    });
                  },

                  itemBuilder: (context, index) {
                    final review = _reviews[index];

                    return Padding(
                      padding: EdgeInsets.only(
                        left: index == 0 ? 0 : 6,
                        right: 12,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          widget.onReviewTap?.call(index);
                        },
                        child: _ReviewCard(
                          imageUrl: review['imageUrl']!,
                          quote: review['quote']!,
                          name: review['name']!,
                        ),
                      ),
                    );
                  },
                ),
              ),

              // ===============================================================
              // INDICATORS
              // ===============================================================
              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_reviewCount, (index) {
                  final bool isActive = index == _currentPage;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: isActive ? 18 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: isActive ? _navy : _navy.withValues(alpha: 0.20),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}

// =============================================================================
// REVIEW CARD
// =============================================================================

class _ReviewCard extends StatelessWidget {
  final String imageUrl;

  final String quote;

  final String name;

  const _ReviewCard({
    required this.imageUrl,
    required this.quote,
    required this.name,
  });

  static const Color _navy = Color(0xFF1E2A6E);

  static const Color _black = Color(0xFF212121);

  static const Color _grey = Color(0xFF666666);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEEEE), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===================================================================
          // IMAGE
          // ===================================================================

          SizedBox(
            height: 145,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                _ReviewImage(imageUrl: imageUrl),

                // -------------------------------------------------------------
                // QUOTE BADGE
                // -------------------------------------------------------------
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    width: 38,
                    height: 38,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.format_quote_rounded,
                      color: _navy,
                      size: 21,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ===================================================================
          // REVIEW CONTENT
          // ===================================================================
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '“$quote”',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12.5,
                      height: 1.45,
                      color: _grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const Spacer(),

                  Container(
                    width: double.infinity,
                    height: 1,
                    color: const Color(0xFFEEEEEE),
                  ),

                  const SizedBox(height: 9),

                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: _black,
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

// =============================================================================
// REVIEW IMAGE
// =============================================================================

class _ReviewImage extends StatelessWidget {
  final String imageUrl;

  const _ReviewImage({required this.imageUrl});

  static const Color _secondary = Color(0xFFEDEFF7);

  static const Color _navy = Color(0xFF1E2A6E);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,

      loadingBuilder: (context, child, progress) {
        if (progress == null) {
          return child;
        }

        return Container(
          width: double.infinity,
          height: double.infinity,
          color: _secondary,
          alignment: Alignment.center,
          child: const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2, color: _navy),
          ),
        );
      },

      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          color: _secondary,
          alignment: Alignment.center,
          child: const Icon(
            Icons.person_outline_rounded,
            color: _navy,
            size: 32,
          ),
        );
      },
    );
  }
}

// ==========================================================================
// CART NOTIFICATION PAGE
// ==========================================================================

class CartNotificationPage extends StatelessWidget {
  const CartNotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),

      appBar: AppAppBar(
        title: 'Added to Cart',
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),

      body: ValueListenableBuilder<List<CartNotificationItem>>(
        valueListenable: CartService.items,

        builder: (context, items, child) {
          if (items.isEmpty) {
            return const _EmptyCartNotification();
          }

          return Column(
            children: [
              // =============================================================
              // SUMMARY
              // =============================================================

              _SummaryHeader(itemCount: items.length),

              // =============================================================
              // ADDED PRODUCTS
              // =============================================================
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 24),

                  itemCount: items.length,

                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 10);
                  },

                  itemBuilder: (context, index) {
                    final CartNotificationItem item = items[index];

                    return _AddedProductCard(
                      item: item,

                      onRemove: () async {
                        await CartService.removeItem(item);
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
}

// =============================================================================
// SUMMARY HEADER
// =============================================================================

class _SummaryHeader extends StatelessWidget {
  final int itemCount;

  const _SummaryHeader({required this.itemCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.fromLTRB(16, 12, 10, 12),

      decoration: const BoxDecoration(
        color: Colors.white,

        border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
      ),

      child: Row(
        children: [
          Expanded(
            child: ValueListenableBuilder<int>(
              valueListenable: CartService.count,

              builder: (context, count, child) {
                return Text(
                  '$itemCount products • $count total quantity',

                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF212121),
                  ),
                );
              },
            ),
          ),

          TextButton(
            onPressed: () {
              _showClearDialog(context);
            },

            child: const Text(
              'Clear All',

              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showClearDialog(BuildContext context) async {
    final bool clear =
        await showDialog<bool>(
          context: context,

          builder: (context) {
            return AlertDialog(
              title: const Text('Clear added products?'),

              content: const Text(
                'All products shown in this list will be removed and the notification count will become 0.',
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },

                  child: const Text('Cancel'),
                ),

                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },

                  child: const Text(
                    'Clear',

                    style: TextStyle(color: AppColors.primary),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;

    if (clear) {
      await CartService.clearCart();
    }
  }
}

// =============================================================================
// PRODUCT CARD
// =============================================================================

class _AddedProductCard extends StatelessWidget {
  final CartNotificationItem item;

  final VoidCallback onRemove;

  const _AddedProductCard({required this.item, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(12),

        border: Border.all(color: const Color(0xFFEEEEEE)),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),

            blurRadius: 8,

            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // ===============================================================
          // IMAGE
          // ===============================================================

          _ProductImage(imageUrl: item.imageUrl),

          const SizedBox(width: 12),

          // ===============================================================
          // INFO
          // ===============================================================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  item.name,

                  maxLines: 2,

                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    fontSize: 14,

                    fontWeight: FontWeight.w700,

                    color: Color(0xFF212121),

                    height: 1.25,
                  ),
                ),

                // =========================================================
                // WEIGHT
                // =========================================================
                if (item.weight != null) ...[
                  const SizedBox(height: 5),

                  Text(
                    'Weight: ${item.weight}',

                    style: const TextStyle(
                      fontSize: 12,

                      color: Color(0xFF666666),
                    ),
                  ),
                ],

                const SizedBox(height: 7),

                // =========================================================
                // PRICE
                // =========================================================
                Wrap(
                  spacing: 7,
                  runSpacing: 4,

                  crossAxisAlignment: WrapCrossAlignment.center,

                  children: [
                    if (item.price.isNotEmpty)
                      Text(
                        item.price,

                        style: const TextStyle(
                          fontSize: 15,

                          fontWeight: FontWeight.w800,

                          color: Color(0xFF212121),
                        ),
                      ),

                    if (item.originalPrice != null)
                      Text(
                        item.originalPrice!,

                        style: const TextStyle(
                          fontSize: 12,

                          color: Color(0xFF888888),

                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 8),

                // =========================================================
                // QUANTITY
                // =========================================================
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 4,
                  ),

                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.10),

                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Text(
                    'Quantity: ${item.quantity}',

                    style: const TextStyle(
                      fontSize: 12,

                      fontWeight: FontWeight.w700,

                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ===============================================================
          // REMOVE
          // ===============================================================
          IconButton(
            tooltip: 'Remove',

            onPressed: onRemove,

            icon: const Icon(
              Icons.close_rounded,

              size: 20,

              color: Color(0xFF777777),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// PRODUCT IMAGE
// =============================================================================

class _ProductImage extends StatelessWidget {
  final String imageUrl;

  const _ProductImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 82,
      height: 82,

      padding: const EdgeInsets.all(6),

      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),

        borderRadius: BorderRadius.circular(10),
      ),

      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),

        child: _buildImage(),
      ),
    );
  }

  Widget _buildImage() {
    if (imageUrl.trim().isEmpty) {
      return const Icon(Icons.image_outlined, color: Colors.grey);
    }

    final bool isNetwork =
        imageUrl.startsWith('http://') || imageUrl.startsWith('https://');

    if (isNetwork) {
      return Image.network(
        imageUrl,

        fit: BoxFit.contain,

        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.image_outlined, color: Colors.grey);
        },
      );
    }

    return Image.asset(
      imageUrl,

      fit: BoxFit.contain,

      errorBuilder: (context, error, stackTrace) {
        return const Icon(Icons.image_outlined, color: Colors.grey);
      },
    );
  }
}

// =============================================================================
// EMPTY
// =============================================================================

class _EmptyCartNotification extends StatelessWidget {
  const _EmptyCartNotification();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            Icon(
              Icons.notifications_none_rounded,

              size: 72,

              color: Colors.grey,
            ),

            SizedBox(height: 16),

            Text(
              'No added products yet',

              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: 18,

                fontWeight: FontWeight.w700,

                color: Color(0xFF212121),
              ),
            ),

            SizedBox(height: 6),

            Text(
              'Add a product from any page. It will appear here automatically.',

              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: 13,

                color: Color(0xFF777777),

                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


