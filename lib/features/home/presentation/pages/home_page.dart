
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../../../app/theme/app_colors.dart';
// import '../../../../core/constants/asset_constants.dart';
// import '../../../../core/services/cart_service.dart';
// import '../../../../core/widgets/app_shimmer.dart';
// import '../../../account/presentation/widgets/app_string.dart';
// import '../../../account/presentation/widgets/languange_constant.dart';
// import '../../../product/presentation/pages/product_list_page.dart';
// import 'cart_notification_page.dart';
// import '../widgets/appbar_widget.dart';
// import '../widgets/banner_widget.dart';
// import '../widgets/bestseller_widget.dart';
// import '../widgets/category_widget.dart';
// import '../widgets/homechefs_widget.dart';
// import '../widgets/popularsearch_widget.dart';
// import '../widgets/recipe_widget.dart';
// import '../widgets/search_widget.dart';
// import '../widgets/trandingproduct_widget.dart';
// import '../../../../core/helpers/snackbar_helper.dart';

// class HomePage extends ConsumerStatefulWidget {
//   const HomePage({
//     super.key,
//   });

//   @override
//   ConsumerState<HomePage> createState() =>
//       _HomePageState();
// }

// class _HomePageState
//     extends ConsumerState<HomePage> {
//   bool _isLoading = true;

//   // ===========================================================================
//   // HOME CATEGORY TABS
//   // ===========================================================================

//   final List<String> _categoryNames = [
//     'For You',
//     'Rice',
//     'Spices',
//   ];

//   // ===========================================================================
//   // SEARCH CATEGORIES
//   // ===========================================================================

//   final List<String> _searchCategories = [
//     'Minikit',
//     'Banskathi',
//     'Chamanmani',
//     'Basmati',
//     'Gobindo Bhog',
//     'Jeera Rice',
//     'Ratna',
//   ];

//   // ===========================================================================
//   // TRENDING
//   // ===========================================================================

//   final List<Map<String, dynamic>>
//       _trendingProducts = [
//     {
//       'name':
//           'Lalbaba Superior Minikit',
//       'imageUrl':
//           AssetConstants.miniket,
//       'price': '₹1,089.00',
//       'originalPrice': '₹1,299.00',
//       'discountLabel': '16% OFF',
//       'rating': 5.0,
//     },
//     {
//       'name':
//           'Lalbaba Basmati Steam',
//       'imageUrl':
//           AssetConstants.basmoti,
//       'price': '₹230.00',
//       'originalPrice': '₹270.00',
//       'discountLabel': '15% OFF',
//       'rating': 4.5,
//     },
//     {
//       'name':
//           'Lalbaba Jeer Rice',
//       'imageUrl':
//           AssetConstants.jeerrice,
//       'price': '₹650.00',
//       'originalPrice': '',
//       'discountLabel': '',
//       'rating': 4.7,
//     },
//   ];

//   // ===========================================================================
//   // POPULAR SEARCH
//   // ===========================================================================

//   final List<Map<String, dynamic>>
//       _popularSearch = [
//     {
//       'name': 'Minikit',
//       'imageUrl':
//           AssetConstants.miniket1,
//       'discountLabel': '10% OFF',
//     },
//     {
//       'name':
//           'Ratna Basmati',
//       'imageUrl':
//           AssetConstants.ratna,
//       'discountLabel': '20% OFF',
//     },
//   ];

//   // ===========================================================================
//   // BEST SELLER
//   // ===========================================================================

//   final List<Map<String, dynamic>>
//       _bestSellers = [
//     {
//       'name':
//           'Lalbaba Superior Minikit',
//       'imageUrl':
//           AssetConstants.miniket,
//       'price': '₹1,089.00',
//       'originalPrice': '₹1,299.00',
//       'discountLabel': '16% OFF',
//       'rating': 5.0,
//     },
//     {
//       'name':
//           'Lalbaba Basmati',
//       'imageUrl':
//           AssetConstants.baskati,
//       'price': '₹230.00',
//       'originalPrice': '₹275.00',
//       'discountLabel': '16% OFF',
//       'rating': 4.5,
//     },
//     {
//       'name':
//           'Lalbaba Jeer Rice',
//       'imageUrl':
//           AssetConstants.jeerrice,
//       'price': '₹650.00',
//       'originalPrice': '₹750.00',
//       'discountLabel': '13% OFF',
//       'rating': 4.6,
//     },
//   ];

//   // ===========================================================================
//   // SEARCH PRODUCTS
//   // ===========================================================================

//   List<Map<String, dynamic>>
//       get _searchProducts {
//     final Map<
//         String,
//         Map<String, dynamic>> unique = {};

//     for (final product in [
//       ..._trendingProducts,
//       ..._bestSellers,
//     ]) {
//       final String name =
//           product['name']
//                   ?.toString()
//                   .trim() ??
//               '';

//       if (name.isNotEmpty) {
//         unique[name] = product;
//       }
//     }

//     return unique.values.toList();
//   }

//   // ===========================================================================
//   // INIT
//   // ===========================================================================

//   @override
//   void initState() {
//     super.initState();

//     CartService.getCartCount();

//     _loadHomeData();
//   }

//   Future<void>
//       _loadHomeData() async {
//     await Future.delayed(
//       const Duration(
//         milliseconds: 900,
//       ),
//     );

//     if (!mounted) return;

//     setState(() {
//       _isLoading = false;
//     });
//   }

//   // ===========================================================================
//   // PRODUCT LIST
//   // ===========================================================================
// Future<void> _openProductListPage({
//   String? sectionType,
//   String title = 'Products',
// }) async {
//   // -------------------------------------------------------------
//   // HOME CATEGORY NAVIGATION BLOCK
//   // For You / Rice / Spices click korle ProductListPage open hobe na
//   // -------------------------------------------------------------

//   if (title == 'For You' ||
//       title == 'Rice' ||
//       title == 'Spices') {
//     debugPrint(
//       'Category navigation blocked: $title',
//     );

//     return;
//   }

//   // -------------------------------------------------------------
//   // OTHER NAVIGATION
//   // Trending / Best Seller / View All etc. normal bhabe open hobe
//   // -------------------------------------------------------------

//   await Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (context) => ProductListPage(
//         sectionType: sectionType,
//         pageTitle: title,
//       ),
//     ),
//   );
// }
//   // Future<void>
//   //     _openProductListPage({
//   //   String? sectionType,
//   //   String title = 'Products',
//   // }) async {
//   //   await Navigator.push(
//   //     context,
//   //     MaterialPageRoute(
//   //       builder: (
//   //         context,
//   //       ) =>
//   //           ProductListPage(
//   //         sectionType:
//   //             sectionType,
//   //         pageTitle: title,
//   //       ),
//   //     ),
//   //   );
//   // }

//   // ===========================================================================
//   // ADD TO CART
//   // ===========================================================================

// // ===========================================================================
// // ADD TO CART
// // ===========================================================================

// Future<void> _handleAddToCart(
//   Map<String, dynamic> product,
// ) async {
//   final String productName =
//       product['name']
//               ?.toString()
//               .trim() ??
//           'Product';

//   try {
//     // -----------------------------------------------------------------------
//     // ADD PRODUCT TO CENTRAL CART
//     // -----------------------------------------------------------------------

//     await CartService.postAddToCart(
//       productId:
//           product['id']
//               ?.toString(),

//       productName:
//           productName,

//       imageUrl:
//           product['imageUrl']
//               ?.toString(),

//       price:
//           product['price']
//               ?.toString(),

//       originalPrice:
//           product['originalPrice']
//               ?.toString(),

//       quantity: 1,
//     );

//     // Page already dispose hole Snackbar show korbe na.
//     if (!mounted) {
//       return;
//     }

//     // -----------------------------------------------------------------------
//     // SUCCESS SNACKBAR
//     // Design snackbar_helper.dart theke asbe.
//     // -----------------------------------------------------------------------

//     FeedbackHelper.showSuccess(
//       context,
//       '$productName added to cart',
//     );
//   } catch (error) {
//     if (!mounted) {
//       return;
//     }

//     // -----------------------------------------------------------------------
//     // ERROR SNACKBAR
//     // -----------------------------------------------------------------------

//     FeedbackHelper.showError(
//       context,
//       'Unable to add product to cart',
//     );
//   }
// }

//   // ===========================================================================
//   // CART NOTIFICATION PAGE
//   // ===========================================================================

//   Future<void>
//       _openCartNotificationPage() async {
//     // await Navigator.push(
//     //   context,
//     //   MaterialPageRoute(
//     //     builder: (
//     //       context,
//     //     ) =>
//     //         const CartNotificationPage(),
//     //   ),
//     // );
//   }

//   // ===========================================================================
//   // SEARCH CATEGORY
//   // ===========================================================================

//   void _handleSearchCategoryTap(
//     String category,
//   ) {
//     debugPrint(
//       'Search category: $category',
//     );

//     _openProductListPage(
//       title: category,
//     );
//   }

//   // ===========================================================================
//   // SEARCH PRODUCT
//   // ===========================================================================

//   void _handleSearchProductTap(
//     Map<String, dynamic> product,
//   ) {
//     debugPrint(
//       'Search product: '
//       '${product['name']}',
//     );
//   }

//   // ===========================================================================
//   // BUILD
//   // ===========================================================================

//   @override
//   Widget build(
//     BuildContext context,
//   ) {
//     const double categoryHeight =
//         60;

//     return SafeArea(
//       child: Scaffold(
//         backgroundColor:
//             AppColors.background,

//         // =====================================================================
//         // APP BAR
//         // =====================================================================

//         appBar: LalBabaAppBar(
//           onNotificationTap:
//               _openCartNotificationPage,
//           onCartTap: () {},
//         ),

//         // =====================================================================
//         // BODY
//         // =====================================================================

//         body: _isLoading
//             ? _buildShimmerBody()
//             : CustomScrollView(
//                 physics:
//                     const AlwaysScrollableScrollPhysics(),
//                 slivers: [
//                   const SliverToBoxAdapter(
//                     child:
//                         SizedBox(
//                       height: 10,
//                     ),
//                   ),

//                   // ===========================================================
//                   // SEARCH
//                   // ===========================================================

//                   SliverToBoxAdapter(
//                     child: SearchWidget(
//                       categories:
//                           _searchCategories,
//                       products:
//                           _searchProducts,
//                       onCategoryTap:
//                           _handleSearchCategoryTap,
//                       onProductTap:
//                           _handleSearchProductTap,
//                     ),
//                   ),

//                   // ===========================================================
//                   // CATEGORY
//                   // ===========================================================

//                   SliverPersistentHeader(
//                     pinned: true,
//                     delegate:
//                         _StickyHeaderDelegate(
//                       height:
//                           categoryHeight,
//                       child:
//                           CategoryWidget(
//                         names:
//                             _categoryNames,
//                         onCategoryTap:
//                             (name) {
//                           _openProductListPage(
//                             title: name,
//                           );
//                         },
//                       ),
//                     ),
//                   ),

//                   // ===========================================================
//                   // HOME CONTENT
//                   // ===========================================================

//                   SliverToBoxAdapter(
//                     child: Padding(
//                       padding:
//                           const EdgeInsets
//                               .only(
//                         top: 8,
//                         bottom: 20,
//                       ),
//                       child: Column(
//                         children: [
//                           // ===================================================
//                           // BANNER
//                           // ===================================================

//                           const BannerWidget(),

//                           // ===================================================
//                           // TRENDING
//                           // ===================================================

//                           AnimatedBuilder(
//                             animation:
//                                 AppLanguageConstants
//                                     .instance,
//                             builder: (
//                               context,
//                               child,
//                             ) {
//                               return TrendingWidget(
//                                 products:
//                                     _trendingProducts,

//                                 onProductTap:
//                                     (product) {},

//                                 onAddToCart:
//                                     _handleAddToCart,

//                                 onViewAllTap:
//                                     () {
//                                   _openProductListPage(
//                                     sectionType:
//                                         'trending',

//                                     title:
//                                         AppStrings
//                                             .trendingThisWeek,
//                                   );
//                                 },
//                               );
//                             },
//                           ),

//                           // ===================================================
//                           // POPULAR SEARCH
//                           // ===================================================

//                           AnimatedBuilder(
//                             animation:
//                                 AppLanguageConstants
//                                     .instance,
//                             builder: (
//                               context,
//                               child,
//                             ) {
//                               return PopularSearchWidget(
//                                 products:
//                                     _popularSearch,

//                                 onProductTap:
//                                     _handleSearchProductTap,
//                               );
//                             },
//                           ),

//                           // ===================================================
//                           // BEST SELLER
//                           // ===================================================

//                           AnimatedBuilder(
//                             animation:
//                                 AppLanguageConstants
//                                     .instance,
//                             builder: (
//                               context,
//                               child,
//                             ) {
//                               return BestSellerWidget(
//                                 products:
//                                     _bestSellers,

//                                 onProductTap:
//                                     (product) {},

//                                 onAddToCart:
//                                     _handleAddToCart,

//                                 onViewAllTap:
//                                     () {
//                                   _openProductListPage(
//                                     sectionType:
//                                         'bestSeller',

//                                     title:
//                                         AppStrings
//                                             .bestSeller,
//                                   );
//                                 },
//                               );
//                             },
//                           ),

//                           // ===================================================
//                           // RECIPE
//                           // ===================================================

//                           AnimatedBuilder(
//                             animation:
//                                 AppLanguageConstants
//                                     .instance,
//                             builder: (
//                               context,
//                               child,
//                             ) {
//                               return const RecipeWidget();
//                             },
//                           ),

//                           // ===================================================
//                           // HAPPY HOME CHEFS
//                           // ===================================================

//                           AnimatedBuilder(
//                             animation:
//                                 AppLanguageConstants
//                                     .instance,
//                             builder: (
//                               context,
//                               child,
//                             ) {
//                               return const TestimonialWidget();
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }

//   // ===========================================================================
//   // SHIMMER
//   // ===========================================================================

//   Widget _buildShimmerBody() {
//     return ListView(
//       physics:
//           const AlwaysScrollableScrollPhysics(),
//       padding:
//           const EdgeInsets.symmetric(
//         horizontal: 14,
//         vertical: 12,
//       ),
//       children: [
//         const AppShimmer(
//           height: 48,
//           radius: 24,
//         ),

//         const SizedBox(
//           height: 16,
//         ),

//         SizedBox(
//           height: 36,
//           child: ListView.separated(
//             scrollDirection:
//                 Axis.horizontal,
//             physics:
//                 const NeverScrollableScrollPhysics(),
//             itemCount:
//                 _categoryNames.length,
//             separatorBuilder:
//                 (
//               context,
//               index,
//             ) {
//               return const SizedBox(
//                 width: 10,
//               );
//             },
//             itemBuilder:
//                 (
//               context,
//               index,
//             ) {
//               return const AppShimmer(
//                 width: 90,
//                 height: 36,
//                 radius: 20,
//               );
//             },
//           ),
//         ),

//         const SizedBox(
//           height: 16,
//         ),

//         const AppShimmer(
//           height: 150,
//           radius: 12,
//         ),

//         const SizedBox(
//           height: 20,
//         ),

//         const AppShimmer(
//           width: 160,
//           height: 18,
//           radius: 6,
//         ),

//         const SizedBox(
//           height: 10,
//         ),

//         SizedBox(
//           height: 260,
//           child: ListView.separated(
//             scrollDirection:
//                 Axis.horizontal,
//             itemCount: 3,
//             separatorBuilder:
//                 (
//               context,
//               index,
//             ) {
//               return const SizedBox(
//                 width: 10,
//               );
//             },
//             itemBuilder:
//                 (
//               context,
//               index,
//             ) {
//               return const SizedBox(
//                 width: 150,
//                 child:
//                     ProductShimmer(),
//               );
//             },
//           ),
//         ),

//         const SizedBox(
//           height: 20,
//         ),

//         const AppShimmer(
//           width: 160,
//           height: 18,
//           radius: 6,
//         ),

//         const SizedBox(
//           height: 10,
//         ),

//         SizedBox(
//           height: 90,
//           child: ListView.separated(
//             scrollDirection:
//                 Axis.horizontal,
//             itemCount: 2,
//             separatorBuilder:
//                 (
//               context,
//               index,
//             ) {
//               return const SizedBox(
//                 width: 10,
//               );
//             },
//             itemBuilder:
//                 (
//               context,
//               index,
//             ) {
//               return const AppShimmer(
//                 width: 140,
//                 height: 90,
//                 radius: 10,
//               );
//             },
//           ),
//         ),

//         const SizedBox(
//           height: 20,
//         ),

//         const AppShimmer(
//           width: 160,
//           height: 18,
//           radius: 6,
//         ),

//         const SizedBox(
//           height: 10,
//         ),

//         SizedBox(
//           height: 260,
//           child: ListView.separated(
//             scrollDirection:
//                 Axis.horizontal,
//             itemCount: 3,
//             separatorBuilder:
//                 (
//               context,
//               index,
//             ) {
//               return const SizedBox(
//                 width: 10,
//               );
//             },
//             itemBuilder:
//                 (
//               context,
//               index,
//             ) {
//               return const SizedBox(
//                 width: 150,
//                 child:
//                     ProductShimmer(),
//               );
//             },
//           ),
//         ),

//         const SizedBox(
//           height: 20,
//         ),

//         const AppShimmer(
//           height: 160,
//           radius: 12,
//         ),

//         const SizedBox(
//           height: 20,
//         ),

//         const AppShimmer(
//           height: 120,
//           radius: 12,
//         ),

//         const SizedBox(
//           height: 20,
//         ),
//       ],
//     );
//   }
// }

// // =============================================================================
// // STICKY HEADER
// // =============================================================================

// class _StickyHeaderDelegate
//     extends SliverPersistentHeaderDelegate {
//   final double height;

//   final Widget child;

//   _StickyHeaderDelegate({
//     required this.height,
//     required this.child,
//   });

//   @override
//   double get minExtent =>
//       height;

//   @override
//   double get maxExtent =>
//       height;

//   @override
//   Widget build(
//     BuildContext context,
//     double shrinkOffset,
//     bool overlapsContent,
//   ) {
//     return Material(
//       color: Colors.white,
//       elevation:
//           overlapsContent ? 2 : 0,
//       shadowColor:
//           Colors.black.withValues(
//         alpha: 0.08,
//       ),
//       child: child,
//     );
//   }

//   @override
//   bool shouldRebuild(
//     covariant _StickyHeaderDelegate
//         oldDelegate,
//   ) {
//     return oldDelegate.height !=
//             height ||
//         oldDelegate.child != child;
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/asset_constants.dart';
import '../../../../core/helpers/snackbar_helper.dart';
import '../../../../core/services/cart_service.dart';
import '../../../../core/widgets/app_shimmer.dart';

import '../../../account/presentation/widgets/app_string.dart';
import '../../../account/presentation/widgets/languange_constant.dart';
import '../../../product/presentation/pages/product_list_page.dart';

import '../widgets/appbar_widget.dart';
import '../widgets/banner_widget.dart';
import '../widgets/bestseller_widget.dart';
import '../widgets/category_widget.dart';
import '../widgets/homechefs_widget.dart';
import '../widgets/popularsearch_widget.dart';
import '../widgets/recipe_widget.dart';
import '../widgets/search_widget.dart';
import '../widgets/trandingproduct_widget.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  ConsumerState<HomePage> createState() =>
      _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  bool _isLoading = true;

  // ===========================================================================
  // HOME CATEGORY TABS
  // ===========================================================================

  final List<String> _categoryNames = [
    'For You',
    'Rice',
    'Spices',
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

    for (final product in [
      ..._trendingProducts,
      ..._bestSellers,
    ]) {
      final String name =
          product['name']?.toString().trim() ?? '';

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
    await Future.delayed(
      const Duration(
        milliseconds: 900,
      ),
    );

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

    if (title == 'For You' ||
        title == 'Rice' ||
        title == 'Spices') {
      debugPrint(
        'Category navigation blocked: $title',
      );

      return;
    }

    // -------------------------------------------------------------------------
    // OTHER NAVIGATION
    // -------------------------------------------------------------------------

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductListPage(
          sectionType: sectionType,
          pageTitle: title,
        ),
      ),
    );
  }

  // ===========================================================================
  // ADD TO CART
  // ===========================================================================

  Future<void> _handleAddToCart(
    Map<String, dynamic> product,
  ) async {
    final String productName =
        product['name']?.toString().trim() ??
            'Product';

    try {
      await CartService.postAddToCart(
        productId:
            product['id']?.toString(),
        productName:
            productName,
        imageUrl:
            product['imageUrl']?.toString(),
        price:
            product['price']?.toString(),
        originalPrice:
            product['originalPrice']?.toString(),
        quantity: 1,
      );

      if (!mounted) {
        return;
      }

      FeedbackHelper.showSuccess(
        context,
        '$productName added to cart',
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
  // NOTIFICATION
  // ===========================================================================

  Future<void> _openCartNotificationPage() async {
    debugPrint(
      'Notification clicked',
    );
  }

  // ===========================================================================
  // SEARCH CATEGORY
  // ===========================================================================

  void _handleSearchCategoryTap(
    String category,
  ) {
    debugPrint(
      'Search category: $category',
    );

    _openProductListPage(
      title: category,
    );
  }

  // ===========================================================================
  // SEARCH PRODUCT
  // ===========================================================================

  void _handleSearchProductTap(
    Map<String, dynamic> product,
  ) {
    debugPrint(
      'Search product: ${product['name']}',
    );
  }

  // ===========================================================================
  // RECIPE TAP
  // ===========================================================================

  void _handleRecipeTap(
    int index,
  ) {
    debugPrint(
      'Recipe clicked: $index',
    );
  }

  // ===========================================================================
  // REVIEW TAP
  // ===========================================================================

  void _handleReviewTap(
    int index,
  ) {
    debugPrint(
      'Review clicked: $index',
    );
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    const double categoryHeight = 60;

    return SafeArea(
      child: Scaffold(
        backgroundColor:
            AppColors.background,

        // =====================================================================
        // APP BAR
        // =====================================================================

        appBar: LalBabaAppBar(
          onNotificationTap:
              _openCartNotificationPage,
          onCartTap: () {},
        ),

        // =====================================================================
        // BODY
        // =====================================================================

        body: _isLoading
            ? _buildShimmerBody()
            : CustomScrollView(
                physics:
                    const AlwaysScrollableScrollPhysics(),

                slivers: [
                  // ===========================================================
                  // TOP SPACE
                  // ===========================================================

                  const SliverToBoxAdapter(
                    child: SizedBox(
                      height: 10,
                    ),
                  ),

                  // ===========================================================
                  // SEARCH
                  // ===========================================================

                  SliverToBoxAdapter(
                    child: SearchWidget(
                      categories:
                          _searchCategories,
                      products:
                          _searchProducts,
                      onCategoryTap:
                          _handleSearchCategoryTap,
                      onProductTap:
                          _handleSearchProductTap,
                    ),
                  ),

                  // ===========================================================
                  // CATEGORY
                  // ===========================================================

                  SliverPersistentHeader(
                    pinned: true,
                    delegate:
                        _StickyHeaderDelegate(
                      height:
                          categoryHeight,

                      child:
                          CategoryWidget(
                        names:
                            _categoryNames,

                        onCategoryTap:
                            (name) {
                          _openProductListPage(
                            title: name,
                          );
                        },
                      ),
                    ),
                  ),

                  // ===========================================================
                  // MAIN HOME CONTENT
                  // ===========================================================

                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .stretch,

                      children: [
                        const SizedBox(
                          height: 8,
                        ),

                        // =====================================================
                        // BANNER
                        // =====================================================

                        const BannerWidget(),

                        // =====================================================
                        // TRENDING
                        // =====================================================

                        AnimatedBuilder(
                          animation:
                              AppLanguageConstants
                                  .instance,

                          builder: (
                            context,
                            child,
                          ) {
                            return TrendingWidget(
                              products:
                                  _trendingProducts,

                              onProductTap:
                                  (
                                product,
                              ) {
                                debugPrint(
                                  'Trending Product: '
                                  '${product['name']}',
                                );
                              },

                              onAddToCart:
                                  _handleAddToCart,

                              onViewAllTap:
                                  () {
                                _openProductListPage(
                                  sectionType:
                                      'trending',

                                  title:
                                      AppStrings
                                          .trendingThisWeek,
                                );
                              },
                            );
                          },
                        ),

                        // =====================================================
                        // POPULAR SEARCH
                        // =====================================================

                        AnimatedBuilder(
                          animation:
                              AppLanguageConstants
                                  .instance,

                          builder: (
                            context,
                            child,
                          ) {
                            return PopularSearchWidget(
                              products:
                                  _popularSearch,

                              onProductTap:
                                  _handleSearchProductTap,
                            );
                          },
                        ),

                        // =====================================================
                        // BEST SELLER
                        // =====================================================

                        AnimatedBuilder(
                          animation:
                              AppLanguageConstants
                                  .instance,

                          builder: (
                            context,
                            child,
                          ) {
                            return BestSellerWidget(
                              products:
                                  _bestSellers,

                              onProductTap:
                                  (
                                product,
                              ) {
                                debugPrint(
                                  'Best Seller Product: '
                                  '${product['name']}',
                                );
                              },

                              onAddToCart:
                                  _handleAddToCart,

                              onViewAllTap:
                                  () {
                                _openProductListPage(
                                  sectionType:
                                      'bestSeller',

                                  title:
                                      AppStrings
                                          .bestSeller,
                                );
                              },
                            );
                          },
                        ),

                        // =====================================================
                        // RECIPE
                        // =====================================================

                        RecipeWidget(
                          onRecipeTap:
                              _handleRecipeTap,
                        ),

                        // =====================================================
                        // HAPPY HOME CHEFS
                        // =====================================================

                        TestimonialWidget(
                          onReviewTap:
                              _handleReviewTap,
                        ),

                        // =====================================================
                        // SMALL BOTTOM GAP
                        //
                        // Age 110 chilo.
                        // Ekhon 24 kora holo.
                        // =====================================================

                        const SizedBox(
                          height: 24,
                        ),
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
      physics:
          const AlwaysScrollableScrollPhysics(),

      padding:
          const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),

      children: [
        // =====================================================================
        // SEARCH SHIMMER
        // =====================================================================

        const AppShimmer(
          height: 48,
          radius: 24,
        ),

        const SizedBox(
          height: 16,
        ),

        // =====================================================================
        // CATEGORY SHIMMER
        // =====================================================================

        SizedBox(
          height: 36,

          child: ListView.separated(
            scrollDirection:
                Axis.horizontal,

            physics:
                const NeverScrollableScrollPhysics(),

            itemCount:
                _categoryNames.length,

            separatorBuilder: (
              context,
              index,
            ) {
              return const SizedBox(
                width: 10,
              );
            },

            itemBuilder: (
              context,
              index,
            ) {
              return const AppShimmer(
                width: 90,
                height: 36,
                radius: 20,
              );
            },
          ),
        ),

        const SizedBox(
          height: 16,
        ),

        // =====================================================================
        // BANNER SHIMMER
        // =====================================================================

        const AppShimmer(
          height: 150,
          radius: 12,
        ),

        const SizedBox(
          height: 20,
        ),

        // =====================================================================
        // TRENDING TITLE
        // =====================================================================

        const AppShimmer(
          width: 160,
          height: 18,
          radius: 6,
        ),

        const SizedBox(
          height: 10,
        ),

        // =====================================================================
        // TRENDING PRODUCTS
        // =====================================================================

        SizedBox(
          height: 260,

          child: ListView.separated(
            scrollDirection:
                Axis.horizontal,

            itemCount: 3,

            separatorBuilder: (
              context,
              index,
            ) {
              return const SizedBox(
                width: 10,
              );
            },

            itemBuilder: (
              context,
              index,
            ) {
              return const SizedBox(
                width: 150,

                child:
                    ProductShimmer(),
              );
            },
          ),
        ),

        const SizedBox(
          height: 20,
        ),

        // =====================================================================
        // POPULAR SEARCH TITLE
        // =====================================================================

        const AppShimmer(
          width: 160,
          height: 18,
          radius: 6,
        ),

        const SizedBox(
          height: 10,
        ),

        // =====================================================================
        // POPULAR SEARCH
        // =====================================================================

        SizedBox(
          height: 90,

          child: ListView.separated(
            scrollDirection:
                Axis.horizontal,

            itemCount: 2,

            separatorBuilder: (
              context,
              index,
            ) {
              return const SizedBox(
                width: 10,
              );
            },

            itemBuilder: (
              context,
              index,
            ) {
              return const AppShimmer(
                width: 140,
                height: 90,
                radius: 10,
              );
            },
          ),
        ),

        const SizedBox(
          height: 20,
        ),

        // =====================================================================
        // BEST SELLER TITLE
        // =====================================================================

        const AppShimmer(
          width: 160,
          height: 18,
          radius: 6,
        ),

        const SizedBox(
          height: 10,
        ),

        // =====================================================================
        // BEST SELLER PRODUCTS
        // =====================================================================

        SizedBox(
          height: 260,

          child: ListView.separated(
            scrollDirection:
                Axis.horizontal,

            itemCount: 3,

            separatorBuilder: (
              context,
              index,
            ) {
              return const SizedBox(
                width: 10,
              );
            },

            itemBuilder: (
              context,
              index,
            ) {
              return const SizedBox(
                width: 150,

                child:
                    ProductShimmer(),
              );
            },
          ),
        ),

        const SizedBox(
          height: 28,
        ),

        // =====================================================================
        // RECIPE HEADER SHIMMER
        // =====================================================================

        Row(
          children: [
            const AppShimmer(
              width: 4,
              height: 34,
              radius: 4,
            ),

            const SizedBox(
              width: 10,
            ),

            const AppShimmer(
              width: 170,
              height: 20,
              radius: 5,
            ),

            const Spacer(),

            const AppShimmer(
              width: 36,
              height: 36,
              radius: 18,
            ),
          ],
        ),

        const SizedBox(
          height: 14,
        ),

        // =====================================================================
        // RECIPE CARD SHIMMER
        // =====================================================================

        const AppShimmer(
          height: 210,
          radius: 16,
        ),

        const SizedBox(
          height: 28,
        ),

        const Divider(
          height: 1,
        ),

        const SizedBox(
          height: 24,
        ),

        // =====================================================================
        // HOME CHEFS HEADER SHIMMER
        // =====================================================================

        Row(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            const AppShimmer(
              width: 4,
              height: 48,
              radius: 4,
            ),

            const SizedBox(
              width: 10,
            ),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  const AppShimmer(
                    width: 170,
                    height: 20,
                    radius: 5,
                  ),

                  const SizedBox(
                    height: 7,
                  ),

                  const AppShimmer(
                    width: 220,
                    height: 12,
                    radius: 4,
                  ),
                ],
              ),
            ),

            const AppShimmer(
              width: 36,
              height: 36,
              radius: 18,
            ),
          ],
        ),

        const SizedBox(
          height: 14,
        ),

        // =====================================================================
        // TESTIMONIAL SHIMMER
        // =====================================================================

        const AppShimmer(
          height: 285,
          radius: 16,
        ),

        // =====================================================================
        // SMALL BOTTOM GAP
        // =====================================================================

        const SizedBox(
          height: 24,
        ),
      ],
    );
  }
}

// =============================================================================
// STICKY HEADER
// =============================================================================

class _StickyHeaderDelegate
    extends SliverPersistentHeaderDelegate {
  final double height;

  final Widget child;

  _StickyHeaderDelegate({
    required this.height,
    required this.child,
  });

  @override
  double get minExtent =>
      height;

  @override
  double get maxExtent =>
      height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Material(
      color:
          Colors.white,

      elevation:
          overlapsContent
              ? 2
              : 0,

      shadowColor:
          Colors.black.withValues(
        alpha: 0.08,
      ),

      child:
          child,
    );
  }

  @override
  bool shouldRebuild(
    covariant _StickyHeaderDelegate
        oldDelegate,
  ) {
    return oldDelegate.height !=
            height ||
        oldDelegate.child !=
            child;
  }
}