import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lalbaba_online/features/account/presentation/widgets/app_string.dart';
import 'package:lalbaba_online/features/account/presentation/widgets/languange_constant.dart';
import 'package:lalbaba_online/features/product/presentation/model/product_models.dart';
import 'package:lalbaba_online/new_app/checkout/new_notification.dart';
import 'package:lalbaba_online/new_app/checkout/new_profile.dart';
import 'package:lalbaba_online/new_app/constant/constantappbar.dart';
import 'package:lalbaba_online/new_app/dashboard/new_cart.dart';
import 'package:lalbaba_online/new_app/product/new_product_details.dart';
import 'package:lalbaba_online/new_app/product/productlistscreen.dart';
import 'package:lalbaba_online/new_app/constant/constantcolour.dart';
import 'package:lalbaba_online/new_app/constant/new_constant_text_styles.dart';
import 'package:lalbaba_online/core/constants/asset_constants.dart';
import 'package:lalbaba_online/core/services/cart_notification_item.dart';
import 'package:lalbaba_online/core/services/cart_service.dart';
import 'package:lalbaba_online/core/widgets/app_shimmer.dart';

class HomeNewPage extends ConsumerStatefulWidget {
  final VoidCallback? onGoToCart;

  final NewProfileData? profileData;
  final ValueChanged<NewProfileData>? onProfileSaved;

  const HomeNewPage({
    super.key,
    this.onGoToCart,
    this.profileData,
    this.onProfileSaved,
  });

  @override
  ConsumerState<HomeNewPage> createState() => _HomeNewPageState();
}

class _HomeNewPageState extends ConsumerState<HomeNewPage> {
  bool _isLoading = true;

  NewProfileData? _currentProfileData;

  Future<void> _openProfilePage() async {
    final profile = _currentProfileData ?? widget.profileData;

    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => NewProfilePage(
          name: profile?.name.isNotEmpty == true ? profile!.name : 'John Doe',

          email: profile?.email.isNotEmpty == true
              ? profile!.email
              : 'john.doe@example.com',

          phoneNumber: profile?.phoneNumber ?? '',

          avatarUrl: profile?.avatarUrl ?? '',

          selectedImagePath: profile?.selectedImagePath,

          onSaved: (updatedProfile) {
            if (mounted) {
              setState(() {
                _currentProfileData = updatedProfile;
              });
            }

            widget.onProfileSaved?.call(updatedProfile);
          },
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant HomeNewPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.profileData != oldWidget.profileData) {
      _currentProfileData = widget.profileData;
    }
  }

  // Controls the scrollable home content (not the pinned top controls).
  final ScrollController _homeScrollController = ScrollController();
  bool _showBackToTop = false;
  bool _hideAppBar = false;
  // Cart state shared between Trending and Best Seller cards.
  Set<String> get _addedProductNames => CartService.items.value
      .map(
        (item) =>
            HomeProductPacks.cartKey(item.productId, item.name, item.weight),
      )
      .toSet();

  void _refreshHomeCart() {
    if (mounted) setState(() {});
  }

  final Set<String> _addingProductNames = <String>{};

  void _handleHomeScroll() {
    if (!_homeScrollController.hasClients) return;
    final shouldShow = _homeScrollController.offset > 350;
    final shouldHideAppBar = _homeScrollController.offset > 80;
    if (mounted &&
        (shouldShow != _showBackToTop || shouldHideAppBar != _hideAppBar)) {
      setState(() {
        _showBackToTop = shouldShow;
        _hideAppBar = shouldHideAppBar;
      });
    }
  }

  Future<void> _scrollToTop() async {
    if (!_homeScrollController.hasClients) return;
    await _homeScrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 550),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    CartService.items.removeListener(_refreshHomeCart);
    _homeScrollController.removeListener(_handleHomeScroll);
    _homeScrollController.dispose();
    super.dispose();
  }

  // ===========================================================================
  // HOME CATEGORY TABS
  // ===========================================================================

  final List<String> _categoryNames = [
    'For You',
    'Rice',
    'Spices',
    'All Products',
  ];

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

  final List<Map<String, dynamic>> _trendingProductsRaw = [
    {
      'id': 'home-superior-minikit',
      'name': 'Lalbaba Superior Minikit',
      'weight': '25 kg', // Demo home pack
      'imageUrl': AssetConstants.miniket,
      'rating': 5.0,
    },
    {
      'id': 'home-basmati-steam',
      'name': 'Lalbaba Basmati Steam',
      'weight': '1 kg', // Demo home pack
      'imageUrl': AssetConstants.basmoti,
      'rating': 4.5,
    },
    {
      'id': 'home-jeer-rice',
      'name': 'Lalbaba Jeer Rice',
      'weight': '5 kg', // Demo home pack
      'imageUrl': AssetConstants.jeerrice,
      'rating': 4.7,
    },
    {
      'id': 'home-jeer-rice',
      'name': 'Lalbaba Jeer Rice',
      'weight': '10 kg', // Demo home pack
      'imageUrl': AssetConstants.jeerrice,
      'rating': 4.7,
    },
  ];

  // ===========================================================================
  // POPULAR SEARCH
  // ===========================================================================

  final List<Map<String, dynamic>> _popularSearchRaw = [
    {
      'id': 'home-superior-minikit',
      'name': 'Minikit',
      'weight': '5 kg', // Demo home pack
      'imageUrl': AssetConstants.miniket1,
    },
    {
      'id': 'home-ratna-basmati',
      'name': 'Ratna Basmati',
      'weight': '10 kg', // Demo home pack
      'imageUrl': AssetConstants.ratna,
    },
    {
      'id': 'home-ratna-basmati',
      'name': 'Ratna Basmati',
      'weight': '5 kg', // Demo home pack
      'imageUrl': AssetConstants.ratna,
    },
  ];

  // ===========================================================================
  // BEST SELLER
  // ===========================================================================

  final List<Map<String, dynamic>> _bestSellersRaw = [
    {
      'id': 'home-superior-minikit',
      'name': 'Lalbaba Superior Minikit',
      'weight': '10 kg', // Demo home pack
      'imageUrl': AssetConstants.miniket,
      'rating': 5.0,
    },
    {
      'id': 'home-basmati',
      'name': 'Lalbaba Basmati',
      'weight': '1 kg', // Demo home pack
      'imageUrl': AssetConstants.baskati,
      'rating': 4.5,
    },
    {
      'id': 'home-jeer-rice',
      'name': 'Lalbaba Jeer Rice',
      'weight': '5 kg', // Demo home pack
      'imageUrl': AssetConstants.jeerrice,
      'rating': 4.6,
    },
    {
      'id': 'home-jeer-rice',
      'name': 'Lalbaba Jeer Rice',
      'weight': '1 kg', // Demo home pack
      'imageUrl': AssetConstants.jeerrice,
      'rating': 4.6,
    },
  ];

  // ===========================================================================
  // SEARCH PRODUCTS
  // ===========================================================================

  // The same three pack/price records are shared with ProductListscreen.
  Map<String, dynamic> _withPack(Map<String, dynamic> raw) =>
      HomeProductPacks.prepare(raw);

  List<Map<String, dynamic>> get _trendingProducts =>
      _trendingProductsRaw.map(_withPack).toList();
  List<Map<String, dynamic>> get _bestSellers =>
      _bestSellersRaw.map(_withPack).toList();
  List<Map<String, dynamic>> get _popularSearch =>
      _popularSearchRaw.map(_withPack).toList();

  void _homeMessage(String message, {bool error = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: error ? HomeColors.error : HomeColors.success,
          content: Text(
            message,
            style: HomeTextStyles.body.copyWith(color: HomeColors.white),
          ),
        ),
      );
  }

  List<Map<String, dynamic>> get _searchProducts {
    final Map<String, Map<String, dynamic>> unique = {};

    for (final product in [
      ..._trendingProducts,
      ..._bestSellers,
      ..._popularSearch,
    ]) {
      final String name = product['name']?.toString().trim() ?? '';

      if (name.isNotEmpty) {
        unique.putIfAbsent(
          HomeProductPacks.productCartKey(product),
          () => product,
        );
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

    _homeScrollController.addListener(_handleHomeScroll);

    CartService.items.addListener(_refreshHomeCart);
    _initializeHomeCart();

    _loadHomeData();
  }

  // ===========================================================================
  // LOAD HOME DATA
  // ===========================================================================

  Future<void> _initializeHomeCart() async {
    try {
      await CartService.initialize();
      CartService.getCartCount();
    } catch (error) {
      debugPrint('Home cart initialization failed: $error');
    }
  }

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
    List<Map<String, dynamic>>? products,
  }) async {
    // -------------------------------------------------------------------------
    // HOME CATEGORY NAVIGATION BLOCK
    // -------------------------------------------------------------------------

    if (title == 'For You' ||
        title == 'For Youu' ||
        title == 'Rice' ||
        title == 'Spices') {
      debugPrint('Category navigation blocked: $title');

      return;
    }

    // -------------------------------------------------------------------------
    // OTHER NAVIGATION
    // -------------------------------------------------------------------------

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductListscreen(
          sectionType: sectionType,
          pageTitle: title,
          products: products,
        ),
      ),
    );
  }

  // ===========================================================================
  // ADD TO CART
  // ===========================================================================

  Future<void> _handleAddToCart(Map<String, dynamic> product) async {
    if (HomeProductPacks.isOutOfStock(product)) {
      _homeMessage('This product is currently out of stock.', error: true);
      return;
    }
    final model = product['_model'];
    final String productName = model is ProductItem
        ? model.name
        : (product['name']?.toString().trim() ?? 'Product');
    final key = HomeProductPacks.productCartKey(product);
    final weight = product['weight']?.toString().trim() ?? '';
    if (weight.isEmpty || _parseProductPrice(product['price']) == null) {
      _homeMessage(
        'Pack weight or price is unavailable for this product.',
        error: true,
      );
      return;
    }
    if (_addedProductNames.contains(key) || _addingProductNames.contains(key))
      return;

    setState(() => _addingProductNames.add(key));
    try {
      await CartService.postAddToCart(
        productId: product['id']?.toString(),
        productName: productName,
        imageUrl: product['imageUrl']?.toString(),
        price: product['price']?.toString(),
        originalPrice: product['originalPrice']?.toString(),
        quantity: 1,
        weight: weight,
      );
      if (!mounted) return;
      _refreshHomeCart();
      _homeMessage('$productName added to cart');
    } catch (error) {
      if (!mounted) return;
      _homeMessage('Unable to add product to cart', error: true);
    } finally {
      if (mounted) setState(() => _addingProductNames.remove(key));
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
    _refreshHomeCart();
  }

  Future<void> _openCartPage() async {
    if (!mounted) return;

    final onGoToCart = widget.onGoToCart;
    if (onGoToCart != null) {
      onGoToCart();
      return;
    }

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const NewCartPage(showBackButton: true),
      ),
    );

    _refreshHomeCart();
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
    _openProductDetails(product);
  }

  void _openProductDetails(Map<String, dynamic> product) {
    final String? id = product['id']?.toString().trim();
    if (id == null || id.isEmpty) {
      debugPrint('Cannot open product details without a product id.');
      return;
    }
    final String imageUrl = product['imageUrl']?.toString() ?? '';
    final String discountLabel = product['discountLabel']?.toString() ?? '';
    final model = product['_model'];
    final String name = model is ProductItem
        ? model.name
        : (product['name']?.toString().trim() ?? 'Product');
    final double? price = _parseProductPrice(product['price']);
    final double? originalPrice = _parseProductPrice(product['originalPrice']);
    final dynamic ratingValue = product['rating'];
    final double rating = ratingValue is num
        ? ratingValue.toDouble()
        : double.tryParse(ratingValue?.toString() ?? '') ?? 0;
    final weight = product['weight']?.toString().trim() ?? '';
    final variants = <ProductVariant>[];
    final rawVariants = product['variants'];
    if (price != null && weight.isNotEmpty) {
      variants.add(
        ProductVariant(weight: weight, price: price, mrp: originalPrice),
      );
    }
    if (rawVariants is List) {
      for (final option in rawVariants) {
        if (option is! Map) continue;
        final optionWeight = option['weight']?.toString().trim() ?? '';
        final optionPrice = _parseProductPrice(option['price']);
        if (optionWeight.isEmpty ||
            optionPrice == null ||
            optionPrice <= 0 ||
            variants.any(
              (v) =>
                  HomeProductPacks.normalize(v.weight) ==
                  HomeProductPacks.normalize(optionWeight),
            ))
          continue;
        variants.add(
          ProductVariant(
            weight: optionWeight,
            price: optionPrice,
            mrp: _parseProductPrice(option['mrp']),
          ),
        );
        if (variants.length == 3) break;
      }
    }

    if (variants.isEmpty) {
      _homeMessage(
        'Pack weight or price is unavailable for this product.',
        error: true,
      );
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        settings: RouteSettings(
          arguments: {'isOutOfStock': HomeProductPacks.isOutOfStock(product)},
        ),
        builder: (_) => NewProductDetailsPage(
          key: ValueKey(id),
          product: ProductItem(
            id: id,
            name: name,
            imageUrl: imageUrl,
            discountLabel: discountLabel,
            rating: rating,
            deliveryDays: 3,
            variants: variants,
          ),
          isOutOfStock: HomeProductPacks.isOutOfStock(product),
        ),
      ),
    );
  }

  double? _parseProductPrice(dynamic value) {
    if (value == null) return null;
    final String normalized = value.toString().replaceAll(
      RegExp(r'[^0-9.]'),
      '',
    );
    return double.tryParse(normalized);
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
    return SafeArea(
      child: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
            primary: HomeColors.secondary,
            secondary: HomeColors.secondary,
            surface: HomeColors.surface,
          ),
          scaffoldBackgroundColor: HomeColors.background,
        ),
        child: Scaffold(
          backgroundColor: HomeColors.background,
          body: _isLoading
              ? _buildShimmerBody()
              : Column(
                  children: [
                    // =====================================================
                    // APP BAR - LALBABA LOGO LEFT ALIGNED
                    // =====================================================

                    // =====================================================
                    // APP BAR - COMPACT HEIGHT, LEFT ALIGNED LOGO
                    // =====================================================

                    // =====================================================
                    // APP BAR - SAME LOGO SIZE, MINIMUM TOP/BOTTOM GAP
                    // =====================================================

                    // =====================================================
                    // HOME APP BAR - COMPACT HEIGHT, SAME LOGO SIZE
                    // =====================================================

                    // =====================================================
                    // HOME APP BAR - LOGO LEFT + NOTIFICATION + PROFILE
                    // =====================================================
                    AnimatedSize(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      alignment: Alignment.topCenter,
                      child: _hideAppBar
                          ? const SizedBox(width: double.infinity)
                          : SizedBox(
                              height: 50,
                              child: CommonAppBar(
                                automaticallyImplyLeading: false,
                                height: 50,
                                centerTitle: false,
                                backgroundColor: HomeColors.secondary,

                                // =================================================
                                // LEFT SIDE LOGO
                                // =================================================
                                titleWidget: Transform.translate(
                                  offset: const Offset(-14, 0),
                                  child: ClipRect(
                                    child: SizedBox(
                                      width:
                                          MediaQuery.sizeOf(context).width > 320
                                          ? MediaQuery.sizeOf(context).width -
                                                130
                                          : MediaQuery.sizeOf(context).width -
                                                115,
                                      height: 42,
                                      child: OverflowBox(
                                        alignment: Alignment.centerLeft,
                                        minWidth: 350,
                                        maxWidth: 350,
                                        minHeight: 68,
                                        maxHeight: 68,
                                        child: SizedBox(
                                          width: 350,
                                          height: 68,
                                          child: Image.asset(
                                            AssetConstants.logo,
                                            fit: BoxFit.contain,
                                            alignment: Alignment.centerLeft,
                                            filterQuality: FilterQuality.high,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  return const Icon(
                                                    Icons.rice_bowl_rounded,
                                                    color: HomeColors.surface,
                                                    size: 36,
                                                  );
                                                },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // =================================================
                                // RIGHT SIDE ICONS
                                // =================================================
                                actions: [
                                  // =====================================================
                                  // NOTIFICATION ICON
                                  // =====================================================
                                  Tooltip(
                                    message: 'Notifications',
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Material(
                                        color: Colors.white.withValues(
                                          alpha: 0.13,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute<void>(
                                                builder: (_) =>
                                                    const NewNotificationPage(),
                                              ),
                                            );
                                          },
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          child: Container(
                                            width: 38,
                                            height: 38,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: Colors.white.withValues(
                                                  alpha: 0.28,
                                                ),
                                                width: 1,
                                              ),
                                            ),
                                            child: const Icon(
                                              Icons.notifications_none_rounded,
                                              size: 22,
                                              color: HomeColors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  // =====================================================
                                  // PROFILE ICON
                                  // =====================================================
                                  Tooltip(
                                    message: 'My Profile',
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 12),
                                      child: Material(
                                        color: Colors.white.withValues(
                                          alpha: 0.13,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                        child: InkWell(
                                          onTap: _openProfilePage,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          child: Container(
                                            width: 38,
                                            height: 38,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: Colors.white.withValues(
                                                  alpha: 0.28,
                                                ),
                                                width: 1,
                                              ),
                                            ),
                                            child: const Icon(
                                              Icons.person_outline_rounded,
                                              size: 22,
                                              color: HomeColors.white,
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

                    // AnimatedSize(
                    //   duration: const Duration(milliseconds: 200),
                    //   curve: Curves.easeInOut,
                    //   alignment: Alignment.topCenter,
                    //   child: _hideAppBar
                    //       ? const SizedBox(width: double.infinity)
                    //       : SizedBox(
                    //           height: 72,
                    //           child: CommonAppBar(
                    //             automaticallyImplyLeading: false,
                    //             height: 72,
                    //             backgroundColor: HomeColors.secondary,

                    //             titleWidget: Transform.translate(
                    //               // Logo আরও বাম দিকে সরানো হয়েছে
                    //               offset: const Offset(-16, 0),
                    //               child: SizedBox(
                    //                 width: 350,
                    //                 height: 68,
                    //                 child: Image.asset(
                    //                   AssetConstants.logo,
                    //                   fit: BoxFit.contain,
                    //                   alignment: Alignment.centerLeft,
                    //                   filterQuality: FilterQuality.high,
                    //                   errorBuilder:
                    //                       (context, error, stackTrace) {
                    //                         return const Icon(
                    //                           Icons.rice_bowl_rounded,
                    //                           color: HomeColors.surface,
                    //                           size: 40,
                    //                         );
                    //                       },
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    // ),

                    // =====================================================
                    // SEARCH BAR
                    // =====================================================
                    const SizedBox(height: 10),

                    SearchWidget(
                      categories: _searchCategories,
                      products: _searchProducts,
                      onCategoryTap: _handleSearchCategoryTap,
                      onProductTap: _handleSearchProductTap,
                    ),

                    // =====================================================
                    // HORIZONTAL CATEGORIES
                    // =====================================================
                    CategoryWidget(
                      names: _categoryNames,
                      onCategoryTap: (name) {
                        _openProductListPage(title: name);
                      },
                    ),

                    // =====================================================
                    // SCROLLABLE HOME CONTENT
                    // =====================================================
                    Expanded(
                      child: Stack(
                        children: [
                          CustomScrollView(
                            controller: _homeScrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            slivers: [
                              SliverToBoxAdapter(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    const SizedBox(height: 8),

                                    // =====================================
                                    // BANNER
                                    // =====================================
                                    const BannerWidget(),

                                    // =====================================
                                    // TRENDING
                                    // =====================================
                                    AnimatedBuilder(
                                      animation: AppLanguageConstants.instance,
                                      builder: (context, child) {
                                        return TrendingWidget(
                                          products: _trendingProducts,
                                          onProductTap: _openProductDetails,
                                          onAddToCart: _handleAddToCart,
                                          onGoToCart: _openCartPage,
                                          addedProductNames: _addedProductNames,
                                          addingProductNames:
                                              _addingProductNames,
                                          onViewAllTap: () {
                                            _openProductListPage(
                                              sectionType: 'trending',
                                              title:
                                                  AppStrings.trendingThisWeek,
                                              products: _trendingProducts,
                                            );
                                          },
                                        );
                                      },
                                    ),

                                    // =====================================
                                    // POPULAR SEARCH
                                    // =====================================
                                    AnimatedBuilder(
                                      animation: AppLanguageConstants.instance,
                                      builder: (context, child) {
                                        return PopularSearchWidget(
                                          products: _popularSearch,
                                          onProductTap: _handleSearchProductTap,
                                          onViewAllTap: () {
                                            _openProductListPage(
                                              sectionType: 'popularSearch',
                                              title: AppStrings.popularSearch,
                                              products: _popularSearch,
                                            );
                                          },
                                        );
                                      },
                                    ),

                                    // =====================================
                                    // BEST SELLER
                                    // =====================================
                                    AnimatedBuilder(
                                      animation: AppLanguageConstants.instance,
                                      builder: (context, child) {
                                        return BestSellerWidget(
                                          products: _bestSellers,
                                          onProductTap: _openProductDetails,
                                          onAddToCart: _handleAddToCart,
                                          onGoToCart: _openCartPage,
                                          addedProductNames: _addedProductNames,
                                          addingProductNames:
                                              _addingProductNames,
                                          onViewAllTap: () {
                                            _openProductListPage(
                                              sectionType: 'bestSeller',
                                              title: AppStrings.bestSeller,
                                              products: _bestSellers,
                                            );
                                          },
                                        );
                                      },
                                    ),

                                    // =====================================
                                    // RECIPE
                                    // =====================================
                                    RecipeWidget(onRecipeTap: _handleRecipeTap),

                                    // =====================================
                                    // HAPPY HOME CHEFS
                                    // =====================================
                                    TestimonialWidget(
                                      onReviewTap: _handleReviewTap,
                                    ),

                                    // =====================================
                                    // BOTTOM GAP
                                    // =====================================
                                    const SizedBox(height: 24),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          // =============================================
                          // FLOATING BACK TO TOP BUTTON
                          // =============================================
                          Positioned(
                            top: 24,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: IgnorePointer(
                                ignoring: !_showBackToTop,
                                child: AnimatedOpacity(
                                  opacity: _showBackToTop ? 1 : 0,
                                  duration: const Duration(milliseconds: 180),
                                  child: Material(
                                    color: HomeColors.textPrimary,
                                    elevation: 5,
                                    shadowColor: HomeColors.black.withValues(
                                      alpha: 0.26,
                                    ),
                                    borderRadius: BorderRadius.circular(28),
                                    child: InkWell(
                                      onTap: _scrollToTop,
                                      borderRadius: BorderRadius.circular(28),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 10,
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.keyboard_double_arrow_up,
                                              color: HomeColors.white,
                                              size: 19,
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              'Back to top',
                                              style: TextStyle(
                                                color: HomeColors.white,
                                                fontSize:
                                                    HomeTextStyles.sizeSmall,
                                                fontWeight:
                                                    HomeTextStyles.semiBold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
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
      color: HomeColors.white,

      elevation: overlapsContent ? 2 : 0,

      shadowColor: HomeColors.black.withValues(alpha: 0.08),

      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant _StickyHeaderDelegate oldDelegate) {
    return oldDelegate.height != height || oldDelegate.child != child;
  }
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
          // =========================================================
          // SEARCH BAR
          // =========================================================

          Container(
            height: 60,
            decoration: BoxDecoration(
              color: HomeColors.disabledBackground,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: HomeColors.border, width: 1),
              boxShadow: [
                BoxShadow(
                  color: HomeColors.textPrimary.withValues(alpha: 0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const SizedBox(width: 6),

                // ===================================================
                // BIG LALBABA LOGO
                // ===================================================
                SizedBox(
                  width: 50,
                  height: 50,
                  child: Image.asset(
                    AssetConstants.logo,
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                    filterQuality: FilterQuality.high,
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
                              width: 50,
                              height: 50,
                              radius: 8,
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
                            color: HomeColors.secondary,
                            size: 32,
                          );
                        },
                  ),
                ),

                const SizedBox(width: 6),

                // ===================================================
                // DIVIDER
                // ===================================================
                Container(width: 1, height: 24, color: HomeColors.border),

                const SizedBox(width: 10),

                // ===================================================
                // SEARCH ICON
                // ===================================================
                const Icon(
                  Icons.search_rounded,
                  color: HomeColors.textSecondary,
                  size: 22,
                ),

                const SizedBox(width: 8),

                // ===================================================
                // TEXT FIELD
                // ===================================================
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
                          fontWeight: HomeTextStyles.regular,
                          fontSize: HomeTextStyles.sizeSmall,
                          color: HomeColors.textPrimary,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                    ],
                  ),
                ),

                // ===================================================
                // CLEAR BUTTON
                // ===================================================
                if (hasText)
                  IconButton(
                    splashRadius: 18,
                    onPressed: _clearSearch,
                    icon: const Icon(
                      Icons.close_rounded,
                      color: HomeColors.textSecondary,
                      size: 18,
                    ),
                  )
                else
                  const SizedBox(width: 12),
              ],
            ),
          ),

          // =========================================================
          // SEARCH RESULTS
          // =========================================================
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
        color: HomeColors.white,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: HomeColors.border),
        boxShadow: [
          BoxShadow(
            color: HomeColors.black.withValues(alpha: 0.08),
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
                  color: HomeColors.white,
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
                          fontSize: HomeTextStyles.sizeSmall,
                          fontWeight: HomeTextStyles.semiBold,
                          color: HomeColors.textPrimary,
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
                      color: HomeColors.textHint,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'No results found',
                      style: TextStyle(
                        fontSize: HomeTextStyles.sizeSmall,
                        fontWeight: HomeTextStyles.semiBold,
                        color: HomeColors.textSecondary,
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
      color: HomeColors.disabledBackground,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      alignment: Alignment.centerRight,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: HomeTextStyles.sizeCaption,
          fontWeight: HomeTextStyles.bold,
          color: HomeColors.textSecondary,
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
      color: HomeColors.white,
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
                  color: HomeColors.background,
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
                        fontSize: HomeTextStyles.sizeSmall,
                        height: 1.25,
                        fontWeight: HomeTextStyles.semiBold,
                        color: HomeColors.textPrimary,
                      ),
                    ),

                    Text(
                      (product['weight']?.toString().trim().isNotEmpty ?? false)
                          ? product['weight'].toString()
                          : 'Weight unavailable',
                      style: const TextStyle(
                        fontSize: HomeTextStyles.sizeCaption,
                        fontWeight: HomeTextStyles.medium,
                        color: HomeColors.textSecondary,
                      ),
                    ),
                    if (price.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        price,
                        style: const TextStyle(
                          fontSize: HomeTextStyles.sizeSmall,
                          fontWeight: HomeTextStyles.bold,
                          color: HomeColors.black,
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
      child: Icon(Icons.image_outlined, size: 24, color: HomeColors.textHint),
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
        color: HomeColors.white,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: HomeColors.border),
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
    fontWeight: HomeTextStyles.regular,
    fontSize: HomeTextStyles.sizeSmall,
    color: HomeColors.textSecondary,
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
  static const Color _primary = HomeColors.secondary;
  static const Color _background = HomeColors.surface;
  static const Color _grey = HomeColors.textSecondary;
  static const Color _border = HomeColors.border;
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
      padding: const EdgeInsets.symmetric(vertical: 8),
      height: 60,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: widget.names.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final String name = widget.names[index];
          final bool isSelected = index == _internalSelectedIndex;
          return Material(
            color: HomeColors.surface.withValues(alpha: 0),
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
                  color: isSelected
                      ? HomeColors.secondaryLight
                      : HomeColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isSelected ? HomeColors.secondaryLight : _border,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isSelected
                          ? _accent.withValues(alpha: 0.30)
                          : HomeColors.black.withValues(alpha: 0.04),
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
                    fontSize: HomeTextStyles.sizeSmall,
                    fontWeight: isSelected
                        ? HomeTextStyles.bold
                        : HomeTextStyles.semiBold,
                    color: isSelected ? HomeColors.secondary : _grey,
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

  static const Color _primary = HomeColors.secondary;

  static const Color _grey = HomeColors.textSecondary;

  // ===========================================================================
  // BANNER IMAGE URLS
  // ===========================================================================

  static const List<String> _bannerImageUrls = [
    'https://lalbabaonline.com/public/uploads/all/XuxYGkH5U1dpGFcK5x3SBtphEhgDg2hka78lG3vS.webp',
    'https://lalbabaonline.com/public/uploads/all/ih7h1OcLwu13H3TVKBdIOyNVgIp4pP3PoQa9coxj.webp',
    'https://lalbabaonline.com/public/uploads/all/96hqz7NNM37PLDfGpg3fNEm4joTpvgftraurkNVR.webp',
    'https://lalbabaonline.com/public/uploads/all/EryH9j4ylQ7qtbZM5iyUuUvTvn6gUwoy7WOluwe9.webp',
  ];

  static const List<double> _bannerAspectRatios = [
    1424 / 630,
    1424 / 630,
    1424 / 630,
    1424 / 636,
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

    _pageController = PageController(initialPage: 0);

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

        AspectRatio(
          aspectRatio: _bannerAspectRatios[_currentIndex],
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

                child: GestureDetector(
                  // ---------------------------------------------------------
                  // BANNER TAP
                  // ---------------------------------------------------------

                  onTap: () {
                    widget.onBannerTap?.call(index);
                  },

                  child: _BannerImage(imageUrl: imageUrl),
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

  static const Color _secondary = HomeColors.secondaryLight;

  static const Color _primary = HomeColors.secondary;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,

      width: double.infinity,

      height: double.infinity,

      fit: BoxFit.contain,

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
  final VoidCallback? onGoToCart;
  final Set<String> addedProductNames;
  final Set<String> addingProductNames;
  final VoidCallback? onViewAllTap;
  const TrendingWidget({
    super.key,
    required this.products,
    this.onProductTap,
    this.onAddToCart,
    this.onGoToCart,
    this.addedProductNames = const <String>{},
    this.addingProductNames = const <String>{},
    this.onViewAllTap,
  });
  @override
  Widget build(BuildContext context) => SectionCardWidget(
    title: AppStrings.trendingThisWeek,
    products: products,
    onProductTap: onProductTap,
    onAddToCart: onAddToCart,
    onGoToCart: onGoToCart,
    addedProductNames: addedProductNames,
    addingProductNames: addingProductNames,
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
  final VoidCallback? onGoToCart;
  final Set<String> addedProductNames;
  final Set<String> addingProductNames;
  final VoidCallback? onViewAllTap;
  const BestSellerWidget({
    super.key,
    required this.products,
    this.onProductTap,
    this.onAddToCart,
    this.onGoToCart,
    this.addedProductNames = const <String>{},
    this.addingProductNames = const <String>{},
    this.onViewAllTap,
  });
  @override
  Widget build(BuildContext context) => SectionCardWidget(
    title: AppStrings.bestSeller,
    products: products,
    onProductTap: onProductTap,
    onAddToCart: onAddToCart,
    onGoToCart: onGoToCart,
    addedProductNames: addedProductNames,
    addingProductNames: addingProductNames,
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
  final VoidCallback? onGoToCart;
  final Set<String> addedProductNames;
  final Set<String> addingProductNames;
  final VoidCallback? onViewAllTap;
  const SectionCardWidget({
    super.key,
    required this.title,
    required this.products,
    this.onProductTap,
    this.onAddToCart,
    this.onGoToCart,
    this.addedProductNames = const <String>{},
    this.addingProductNames = const <String>{},
    this.onViewAllTap,
  });
  static const double _outerMargin = 0;
  static const double _railPadding = 10;
  static const double _cardGap = 7;

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
        // Precisely three visible cards per row, regardless of phone width.
        final double cardWidth = ((usableWidth - (_cardGap * 2)) / 3)
            .clamp(70.0, 300.0)
            .toDouble();
        final double imageHeight = (cardWidth * 1.30)
            .clamp(108.0, 170.0)
            .toDouble();
        return Container(
          margin: const EdgeInsets.symmetric(
            horizontal: _outerMargin,
            vertical: 5,
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: const BoxDecoration(color: HomeColors.surface),
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
                          fontSize: HomeTextStyles.sizeSection,
                          fontWeight: HomeTextStyles.bold,
                          color: HomeColors.textPrimary,
                          height: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Material(
                      color: HomeColors.disabledBackground,
                      shape: const CircleBorder(),
                      child: IconButton(
                        tooltip: 'View All',
                        onPressed: onViewAllTap,
                        icon: const Icon(
                          Icons.chevron_right_rounded,
                          color: HomeColors.textPrimary,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 334,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const ClampingScrollPhysics(),
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
                      isOutOfStock: HomeProductPacks.isOutOfStock(product),
                      name: product['name']?.toString() ?? '',
                      imageUrl: product['imageUrl']?.toString() ?? '',
                      price: product['price']?.toString() ?? '',
                      weight: product['weight']?.toString() ?? '',
                      originalPrice: product['originalPrice']?.toString(),
                      discountLabel: product['discountLabel']?.toString(),
                      rating: rating,
                      showPriceAndRating: true,
                      width: cardWidth,
                      imageHeight: imageHeight,
                      isInCart: addedProductNames.contains(
                        HomeProductPacks.productCartKey(product),
                      ),
                      isAdding: addingProductNames.contains(
                        HomeProductPacks.productCartKey(product),
                      ),
                      onGoToCart: onGoToCart,
                      onTap: () => onProductTap?.call(product),
                      onAddToCart:
                          onAddToCart == null ||
                              HomeProductPacks.isOutOfStock(product)
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
  final bool isOutOfStock;
  final String name;
  final String imageUrl;
  final String price;
  final String weight;
  final String? originalPrice;
  final String? discountLabel;
  final double rating;
  final bool showPriceAndRating;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;
  final VoidCallback? onGoToCart;
  final bool isInCart;
  final bool isAdding;
  final double width;
  final double imageHeight;

  const ProductCardWidget({
    super.key,
    this.isOutOfStock = false,
    required this.name,
    required this.imageUrl,
    this.price = '',
    this.weight = '',
    this.originalPrice,
    this.discountLabel,
    this.rating = 0,
    this.showPriceAndRating = false,
    this.onTap,
    this.onAddToCart,
    this.onGoToCart,
    this.isInCart = false,
    this.isAdding = false,
    this.width = 150,
    this.imageHeight = 105,
  });

  // BigBasket-like hierarchy: image -> offer -> price -> name -> rating.
  // Display the selected demo pack and its matching price only.
  @override
  Widget build(BuildContext context) {
    final bool hasOffer = discountLabel?.trim().isNotEmpty ?? false;
    return SizedBox(
      width: width,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: imageHeight,
              width: width,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: ProductStockOverlay(
                        isOutOfStock: isOutOfStock,
                        child: ColoredBox(
                          color: HomeColors.disabledBackground,
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: _productImage(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // The original cart operation is unchanged. The visual
                  // treatment is now the circular + button on the image.
                  if (!isOutOfStock && onAddToCart != null)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: GestureDetector(
                        onTap: () {
                          if (isAdding) return;
                          if (isInCart) {
                            onGoToCart?.call();
                          } else {
                            onAddToCart?.call();
                          }
                        },
                        child: Container(
                          width: isInCart ? 39 : 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: HomeColors.secondary,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: HomeColors.white,
                              width: 2,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: isAdding
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: HomeColors.white,
                                  ),
                                )
                              : Icon(
                                  isInCart
                                      ? Icons.shopping_cart_checkout_rounded
                                      : Icons.add_rounded,
                                  color: HomeColors.white,
                                  size: 25,
                                ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Reserve identical heights for every card so rows never stagger.
            SizedBox(
              height: 18,
              child: isInCart && onGoToCart != null
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: onGoToCart,
                        child: const Text(
                          'Go to Cart',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: HomeColors.secondary,
                            fontSize: HomeTextStyles.sizeCaption,
                            fontWeight: HomeTextStyles.bold,
                          ),
                        ),
                      ),
                    )
                  : null,
            ),
            // Offer row always takes the same height, even without an offer.
            SizedBox(
              height: 27,
              child: hasOffer
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        constraints: const BoxConstraints(
                          maxWidth: double.infinity,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: HomeColors.accent,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          discountLabel!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: HomeTextStyles.sizeCaption,
                            color: HomeColors.textPrimary,
                            fontWeight: HomeTextStyles.bold,
                          ),
                        ),
                      ),
                    )
                  : null,
            ),
            if (showPriceAndRating)
              // FittedBox prevents the current and struck-through prices from
              // wrapping on narrow phones. Both remain on one baseline.
              SizedBox(
                height: 22,
                width: double.infinity,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          price,
                          maxLines: 1,
                          softWrap: false,
                          style: const TextStyle(
                            color: HomeColors.textPrimary,
                            fontSize: HomeTextStyles.sizeProduct,
                            fontWeight: HomeTextStyles.bold,
                            height: 1.1,
                          ),
                        ),
                        if (originalPrice?.trim().isNotEmpty ?? false) ...[
                          const SizedBox(width: 3),
                          Text(
                            originalPrice!,
                            maxLines: 1,
                            softWrap: false,
                            style: const TextStyle(
                              fontWeight: HomeTextStyles.regular,
                              fontSize: HomeTextStyles.sizeCaption,
                              color: HomeColors.textSecondary,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 4),
            // Two lines maximum, rather than one word on each of 3+ lines.
            SizedBox(
              height: 36,
              width: double.infinity,
              child: Text(
                name,
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: HomeColors.textPrimary,
                  fontSize: HomeTextStyles.sizeCaption,
                  height: 1.3,
                  fontWeight: HomeTextStyles.semiBold,
                ),
              ),
            ),
            SizedBox(
              height: 18,
              width: double.infinity,
              child: Text(
                weight.trim().isEmpty ? 'Weight unavailable' : weight,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: HomeTextStyles.sizeCaption,
                  fontWeight: HomeTextStyles.medium,
                  color: HomeColors.textSecondary,
                ),
              ),
            ),
            if (showPriceAndRating && rating > 0)
              SizedBox(
                height: 19,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: HomeColors.accent,
                      size: 13,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      rating.toStringAsFixed(1),
                      maxLines: 1,
                      style: const TextStyle(
                        color: HomeColors.textSecondary,
                        fontSize: HomeTextStyles.sizeCaption,
                        fontWeight: HomeTextStyles.semiBold,
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

  Widget _productImage() {
    if (imageUrl.trim().isEmpty) {
      return const Icon(Icons.image_outlined, color: HomeColors.textSecondary);
    }
    if (imageUrl.startsWith('https://') || imageUrl.startsWith('http://')) {
      return Image.network(
        imageUrl,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) =>
            const Icon(Icons.image_outlined, color: HomeColors.textSecondary),
      );
    }
    return Image.asset(
      imageUrl,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) =>
          const Icon(Icons.image_outlined, color: HomeColors.textSecondary),
    );
  }
}

// ==========================================================================
// POPULAR SEARCH
// ==========================================================================

class PopularSearchWidget extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  final ValueChanged<Map<String, dynamic>>? onProductTap;
  final VoidCallback? onViewAllTap;

  const PopularSearchWidget({
    super.key,
    required this.products,
    this.onProductTap,
    this.onViewAllTap,
  });

  static const Color _accent = HomeColors.secondary;

  static const Color _black = HomeColors.textPrimary;

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
              colors: [HomeColors.secondaryLight, HomeColors.secondaryLight],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
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
                      color: HomeColors.surface,
                      size: 18,
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      AppStrings.popularSearch,
                      style: const TextStyle(
                        fontSize: HomeTextStyles.sizeSection,
                        fontWeight: HomeTextStyles.bold,
                        color: _black,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Material(
                    color: HomeColors.disabledBackground,
                    shape: const CircleBorder(),
                    child: IconButton(
                      tooltip: 'View all popular searches',
                      onPressed: onViewAllTap,
                      icon: const Icon(
                        Icons.chevron_right_rounded,
                        color: HomeColors.textPrimary,
                        size: 24,
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
                height: 205,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const ClampingScrollPhysics(),
                  itemCount: products.length,
                  separatorBuilder: (context, index) {
                    return const SizedBox(width: _gap);
                  },
                  itemBuilder: (context, index) {
                    final product = products[index];

                    return SizedBox(
                      width: tileWidth,
                      child: _PopularSearchTile(
                        isOutOfStock: HomeProductPacks.isOutOfStock(product),
                        name: product['name']?.toString() ?? '',
                        imageUrl: product['imageUrl']?.toString() ?? '',
                        discountLabel: product['discountLabel']?.toString(),
                        weight: product['weight']?.toString() ?? '',
                        price: product['price']?.toString() ?? '',
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
  final bool isOutOfStock;
  final String weight;
  final String price;
  final String name;
  final String imageUrl;
  final String? discountLabel;
  final VoidCallback? onTap;

  const _PopularSearchTile({
    this.isOutOfStock = false,
    this.weight = '',
    this.price = '',
    required this.name,
    required this.imageUrl,
    this.discountLabel,
    this.onTap,
  });

  static const Color _accent = HomeColors.secondary;

  static const Color _black = HomeColors.textPrimary;

  static const Color _grey = HomeColors.textSecondary;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: HomeColors.surface.withValues(alpha: 0),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: HomeColors.surface,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: HomeColors.black.withValues(alpha: 0.06),
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
                    ProductStockOverlay(
                      isOutOfStock: isOutOfStock,
                      child: _buildImage(),
                    ),

                    if (!isOutOfStock &&
                        discountLabel != null &&
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
                                color: HomeColors.surface,
                              ),

                              const SizedBox(width: 1),

                              Text(
                                discountLabel!,
                                maxLines: 1,
                                overflow: TextOverflow.fade,
                                softWrap: false,
                                style: const TextStyle(
                                  color: HomeColors.surface,
                                  fontSize: HomeTextStyles.sizeCaption,
                                  fontWeight: HomeTextStyles.bold,
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
                        fontSize: HomeTextStyles.sizeCaption,
                        fontWeight: HomeTextStyles.medium,
                        color: _grey,
                        height: 1.2,
                      ),
                    ),

                    Text(
                      weight.trim().isEmpty ? 'Weight unavailable' : weight,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: HomeTextStyles.sizeCaption,
                        fontWeight: HomeTextStyles.medium,
                        color: HomeColors.textSecondary,
                      ),
                    ),
                    if (price.isNotEmpty)
                      Text(
                        price,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: HomeTextStyles.sizeSmall,
                          fontWeight: HomeTextStyles.bold,
                          color: HomeColors.textPrimary,
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
                            fontSize: HomeTextStyles.sizeCaption,
                            fontWeight: HomeTextStyles.bold,
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
        color: HomeColors.background,
        alignment: Alignment.center,
        child: const Icon(
          Icons.image_outlined,
          size: 28,
          color: HomeColors.textHint,
        ),
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

              return Container(color: HomeColors.background);
            },
        errorBuilder:
            (BuildContext context, Object error, StackTrace? stackTrace) {
              return Container(
                color: HomeColors.background,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.image_outlined,
                  size: 28,
                  color: HomeColors.textHint,
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
          color: HomeColors.background,
          alignment: Alignment.center,
          child: const Icon(
            Icons.image_outlined,
            size: 28,
            color: HomeColors.textHint,
          ),
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
  static const Color _primary = HomeColors.secondary;

  static const Color _black = HomeColors.textPrimary;

  static const Color _grey = HomeColors.textSecondary;

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
                          fontSize: HomeTextStyles.sizeSection,
                          fontWeight: HomeTextStyles.bold,
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
                    if (!mounted) {
                      return;
                    }
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
                  color: HomeColors.border,
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
        color: HomeColors.white,

        borderRadius: BorderRadius.circular(16),

        boxShadow: [
          BoxShadow(
            color: HomeColors.black.withValues(alpha: 0.08),
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
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    HomeColors.surface.withValues(alpha: 0),
                    HomeColors.black.withValues(alpha: 0.094),
                    HomeColors.black.withValues(alpha: 0.85),
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
              style: TextStyle(
                color: HomeColors.white,
                fontSize: HomeTextStyles.sizeSmall,
                fontWeight: HomeTextStyles.bold,
                height: 1.3,
                shadows: [
                  Shadow(
                    color: HomeColors.black.withValues(alpha: 0.45),
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
          color: HomeColors.background,
          alignment: Alignment.center,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image_not_supported_outlined,
                color: HomeColors.secondary,
                size: 30,
              ),

              SizedBox(height: 6),

              Text(
                'Image unavailable',
                style: TextStyle(
                  fontWeight: HomeTextStyles.regular,
                  color: HomeColors.textSecondary,
                  fontSize: HomeTextStyles.sizeCaption,
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
// HOME CHEFS
// ==========================================================================

class TestimonialWidget extends StatefulWidget {
  final ValueChanged<int>? onReviewTap;

  const TestimonialWidget({super.key, this.onReviewTap});

  @override
  State<TestimonialWidget> createState() => _TestimonialWidgetState();
}

class _TestimonialWidgetState extends State<TestimonialWidget> {
  static const Color _navy = HomeColors.secondary;

  static const Color _black = HomeColors.textPrimary;

  static const Color _grey = HomeColors.textSecondary;

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
                            fontSize: HomeTextStyles.sizeSection,
                            fontWeight: HomeTextStyles.bold,
                            color: _black,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          AppStrings.homeChefsSubtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: HomeTextStyles.sizeSmall,
                            height: 1.35,
                            color: _grey,
                            fontWeight: HomeTextStyles.medium,
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

  static const Color _navy = HomeColors.secondary;

  static const Color _black = HomeColors.textPrimary;

  static const Color _grey = HomeColors.textSecondary;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: HomeColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: HomeColors.divider, width: 1),
        boxShadow: [
          BoxShadow(
            color: HomeColors.black.withValues(alpha: 0.06),
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
                      color: HomeColors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: HomeColors.black.withValues(alpha: 0.12),
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
                      fontSize: HomeTextStyles.sizeSmall,
                      height: 1.45,
                      color: _grey,
                      fontWeight: HomeTextStyles.medium,
                    ),
                  ),

                  const Spacer(),

                  Container(
                    width: double.infinity,
                    height: 1,
                    color: HomeColors.divider,
                  ),

                  const SizedBox(height: 9),

                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: HomeTextStyles.sizeSmall,
                      fontWeight: HomeTextStyles.bold,
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

  static const Color _secondary = HomeColors.secondaryLight;

  static const Color _navy = HomeColors.secondary;

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
      backgroundColor: HomeColors.background,

      appBar: CommonAppBar(
        title: 'Added to Cart',
        backgroundColor: HomeColors.secondary,
        titleColor: HomeColors.white,
        iconColor: HomeColors.white,
        titleFontSize: HomeTextStyles.sizeSectionLarge,
        showBackButton: true,
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
        color: HomeColors.white,

        border: Border(bottom: BorderSide(color: HomeColors.divider)),
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
                    fontSize: HomeTextStyles.sizeSmall,
                    fontWeight: HomeTextStyles.semiBold,
                    color: HomeColors.textPrimary,
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
                fontSize: HomeTextStyles.sizeBody,
                color: HomeColors.secondary,
                fontWeight: HomeTextStyles.bold,
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
              backgroundColor: HomeColors.surface,
              title: Text(
                'Clear added products?',
                style: HomeTextStyles.pageTitle.copyWith(
                  color: HomeColors.textPrimary,
                ),
              ),

              content: Text(
                'All products shown in this list will be removed and the notification count will become 0.',
                style: HomeTextStyles.body.copyWith(
                  color: HomeColors.textPrimary,
                ),
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },

                  child: Text(
                    'Cancel',
                    style: HomeTextStyles.button.copyWith(
                      color: HomeColors.textSecondary,
                    ),
                  ),
                ),

                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },

                  child: const Text(
                    'Clear',

                    style: TextStyle(
                      fontWeight: HomeTextStyles.regular,
                      fontSize: HomeTextStyles.sizeBody,
                      color: HomeColors.secondary,
                    ),
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
        color: HomeColors.white,

        borderRadius: BorderRadius.circular(12),

        border: Border.all(color: HomeColors.divider),

        boxShadow: [
          BoxShadow(
            color: HomeColors.black.withValues(alpha: 0.04),

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
                    fontSize: HomeTextStyles.sizeSmall,

                    fontWeight: HomeTextStyles.bold,

                    color: HomeColors.textPrimary,

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
                      fontWeight: HomeTextStyles.regular,
                      fontSize: HomeTextStyles.sizeCaption,

                      color: HomeColors.textSecondary,
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
                          fontSize: HomeTextStyles.sizeSummaryTotal,

                          fontWeight: HomeTextStyles.bold,

                          color: HomeColors.textPrimary,
                        ),
                      ),

                    if (item.originalPrice != null)
                      Text(
                        item.originalPrice!,

                        style: const TextStyle(
                          fontWeight: HomeTextStyles.regular,
                          fontSize: HomeTextStyles.sizeCaption,

                          color: HomeColors.textSecondary,

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
                    color: HomeColors.secondary.withValues(alpha: 0.10),

                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Text(
                    'Quantity: ${item.quantity}',

                    style: const TextStyle(
                      fontSize: HomeTextStyles.sizeCaption,

                      fontWeight: HomeTextStyles.bold,

                      color: HomeColors.secondary,
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

              color: HomeColors.textSecondary,
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
        color: HomeColors.background,

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
      return const Icon(Icons.image_outlined, color: HomeColors.textHint);
    }

    final bool isNetwork =
        imageUrl.startsWith('http://') || imageUrl.startsWith('https://');

    if (isNetwork) {
      return Image.network(
        imageUrl,

        fit: BoxFit.contain,

        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.image_outlined, color: HomeColors.textHint);
        },
      );
    }

    return Image.asset(
      imageUrl,

      fit: BoxFit.contain,

      errorBuilder: (context, error, stackTrace) {
        return const Icon(Icons.image_outlined, color: HomeColors.textHint);
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

              color: HomeColors.textHint,
            ),

            SizedBox(height: 16),

            Text(
              'No added products yet',

              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: HomeTextStyles.sizeSection,

                fontWeight: HomeTextStyles.bold,

                color: HomeColors.textPrimary,
              ),
            ),

            SizedBox(height: 6),

            Text(
              'Add a product from any page. It will appear here automatically.',

              textAlign: TextAlign.center,

              style: TextStyle(
                fontWeight: HomeTextStyles.regular,
                fontSize: HomeTextStyles.sizeSmall,

                color: HomeColors.textSecondary,

                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
