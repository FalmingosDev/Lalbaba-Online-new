// import 'package:flutter/material.dart';
// import 'package:lalbaba_online/new_app/homenew.dart';

// // Keep this file alongside home_new_page.dart, or adjust this import path.

// class BottomNavigationScreen extends StatefulWidget {
//   const BottomNavigationScreen({super.key});

//   @override
//   State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
// }

// class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
//   static const Color _selectedGreen = Color(0xFF008A58);
//   static const Color _unselectedGrey = Color(0xFFB6B6B6);
//   static const Color _white = Colors.white;
//   static const Color _cartGrey = Color(0xFFB3B3B3);

//   int _selectedIndex = 0;

//   // Replace these four placeholder widgets with your actual screen classes.
//   // HomeNewPage is already connected at index 0.
//   late final List<Widget> _pages = <Widget>[
//     const HomeNewPage(),
//     const _PendingTabPage(title: 'Categories', icon: Icons.grid_view_rounded),
//     const _PendingTabPage(title: 'Cart', icon: Icons.shopping_bag_outlined),
//     const _PendingTabPage(title: 'Orders', icon: Icons.receipt_long_outlined),
//     const _PendingTabPage(title: 'Account', icon: Icons.person_outline_rounded),
//   ];

//   void _selectTab(int index) {
//     if (_selectedIndex == index) return;
//     setState(() => _selectedIndex = index);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: _white,
//       body: IndexedStack(index: _selectedIndex, children: _pages),
//       bottomNavigationBar: SafeArea(
//         top: false,
//         child: SizedBox(
//           height: 82,
//           child: Stack(
//             clipBehavior: Clip.none,
//             alignment: Alignment.bottomCenter,
//             children: <Widget>[
//               Positioned.fill(
//                 top: 8,
//                 child: DecoratedBox(
//                   decoration: BoxDecoration(
//                     color: _white,
//                     border: const Border(
//                       top: BorderSide(color: Color(0xFFEDEDED), width: 1),
//                     ),
//                     boxShadow: <BoxShadow>[
//                       BoxShadow(
//                         color: Colors.black.withValues(alpha: 0.04),
//                         blurRadius: 10,
//                         offset: const Offset(0, -3),
//                       ),
//                     ],
//                   ),
//                   child: Row(
//                     children: <Widget>[
//                       _tabItem(0, Icons.home_rounded, 'Home'),
//                       _tabItem(1, Icons.grid_view_rounded, 'Categories'),
//                       const Expanded(child: SizedBox.shrink()),
//                       _tabItem(3, Icons.receipt_long_outlined, 'Orders'),
//                       _tabItem(4, Icons.person_outline_rounded, 'Account'),
//                     ],
//                   ),
//                 ),
//               ),
//               Positioned(
//                 top: 0,
//                 child: _cartTab(),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _tabItem(int index, IconData icon, String title) {
//     final bool selected = _selectedIndex == index;
//     final Color color = selected ? _selectedGreen : _unselectedGrey;

//     return Expanded(
//       child: InkWell(
//         onTap: () => _selectTab(index),
//         borderRadius: BorderRadius.circular(12),
//         child: Semantics(
//           selected: selected,
//           button: true,
//           label: title,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             mainAxisSize: MainAxisSize.max,
//             children: <Widget>[
//               Icon(icon, size: 23, color: color),
//               const SizedBox(height: 4),
//               Text(
//                 title,
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//                 style: TextStyle(
//                   fontSize: 10,
//                   height: 1.2,
//                   fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
//                   color: color,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _cartTab() {
//     final bool selected = _selectedIndex == 2;
//     return Semantics(
//       button: true,
//       selected: selected,
//       label: 'Cart',
//       child: InkWell(
//         onTap: () => _selectTab(2),
//         customBorder: const CircleBorder(),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             Container(
//               width: 58,
//               height: 58,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: selected ? _selectedGreen : _cartGrey,
//                 border: Border.all(color: _white, width: 3),
//                 boxShadow: <BoxShadow>[
//                   BoxShadow(
//                     color: Colors.black.withValues(alpha: 0.23),
//                     blurRadius: 9,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: const Icon(
//                 Icons.shopping_bag_outlined,
//                 color: _white,
//                 size: 27,
//               ),
//             ),
//             const SizedBox(height: 2),
//             Text(
//               'Cart',
//               style: TextStyle(
//                 fontSize: 10,
//                 fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
//                 color: selected ? _selectedGreen : _unselectedGrey,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Temporary screen only. Replace with your real widgets for indices 1–4.
// class _PendingTabPage extends StatelessWidget {
//   final String title;
//   final IconData icon;

//   const _PendingTabPage({required this.title, required this.icon});

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             Icon(icon, size: 44, color: const Color(0xFFB6B6B6)),
//             const SizedBox(height: 12),
//             Text(
//               title,
//               style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:lalbaba_online/new_app/dashboard/homenew.dart';
// import 'package:lalbaba_online/new_app/dashboard/new_accountscreen.dart';
// import 'package:lalbaba_online/new_app/dashboard/new_category.dart';
// import 'package:lalbaba_online/new_app/dashboard/new_cart.dart';
// import 'package:lalbaba_online/new_app/dashboard/new_order.dart';
// import 'package:lalbaba_online/new_app/constant/constantcolour.dart';
// import 'package:lalbaba_online/new_app/constant/new_constant_text_styles.dart';
// import 'package:lalbaba_online/core/services/cart_service.dart';

// class BottomNavigationScreen extends StatefulWidget {
//   final int initialIndex;
//   final bool showCartBackButton;

//   const BottomNavigationScreen({
//     super.key,
//     this.initialIndex = 0,
//     this.showCartBackButton = false,
//   });

//   @override
//   State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
// }

// class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
//   late int _selectedIndex;
//   bool _showCartBackButton = false;
//   late final List<Widget> _pages;

//   @override
//   void initState() {
//     super.initState();
//     _selectedIndex = widget.initialIndex.clamp(0, 4).toInt();
//     _showCartBackButton = widget.showCartBackButton;
//     _pages = [
//       HomeNewPage(onGoToCart: _openCartTab),
//       const NewCategoryPage(),
//       NewCartPage(showBackButton: _showCartBackButton, onBack: _handleCartBack),
//       const NewOrdersPage(),
//       NewAccountPage(onOrdersTap: () => _selectTab(3)),
//     ];
//   }

//   void _openCartTab() {
//     setState(() {
//       _selectedIndex = 2;
//       _showCartBackButton = true;
//       _pages[2] = NewCartPage(
//         showBackButton: true,
//         onBack: () => _selectTab(0),
//       );
//     });
//   }

//   void _handleCartBack() {
//     if (widget.showCartBackButton) {
//       Navigator.of(context).maybePop();
//     } else {
//       _selectTab(0);
//     }
//   }

//   void _selectTab(int index) {
//     if (_selectedIndex == index) return;
//     setState(() {
//       _selectedIndex = index;
//       _showCartBackButton = false;
//       _pages[2] = const NewCartPage();
//     });
//   }

//   @override
//   Widget build(BuildContext context) => Scaffold(
//     backgroundColor: HomeColors.surface,
//     body: IndexedStack(index: _selectedIndex, children: _pages),
//     bottomNavigationBar: SafeArea(
//       top: false,
//       child: SizedBox(
//         height: 82,
//         child: Stack(
//           clipBehavior: Clip.none,
//           alignment: Alignment.bottomCenter,
//           children: [
//             Positioned.fill(
//               top: 8,
//               child: DecoratedBox(
//                 decoration: BoxDecoration(
//                   color: HomeColors.surface,
//                   border: const Border(
//                     top: BorderSide(color: HomeColors.divider),
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: HomeColors.black.withValues(alpha: .04),
//                       blurRadius: 10,
//                       offset: const Offset(0, -3),
//                     ),
//                   ],
//                 ),
//                 child: Row(
//                   children: [
//                     _tabItem(0, Icons.home_rounded, 'Home'),
//                     _tabItem(1, Icons.grid_view_rounded, 'Categories'),
//                     const Expanded(child: SizedBox.shrink()),
//                     _tabItem(3, Icons.receipt_long_outlined, 'Orders'),
//                     _tabItem(4, Icons.person_outline_rounded, 'Account'),
//                   ],
//                 ),
//               ),
//             ),
//             Positioned(top: 0, child: _cartTab()),
//           ],
//         ),
//       ),
//     ),
//   );

//   Widget _tabItem(int index, IconData icon, String title) {
//     final selected = _selectedIndex == index;
//     final color = selected ? HomeColors.secondary : HomeColors.disabled;
//     return Expanded(
//       child: InkWell(
//         onTap: () => _selectTab(index),
//         borderRadius: BorderRadius.circular(12),
//         child: Semantics(
//           selected: selected,
//           button: true,
//           label: title,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(icon, color: color, size: 23),
//               const SizedBox(height: 4),
//               Text(
//                 title,
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//                 style: HomeTextStyles.caption.copyWith(
//                   color: color,
//                   fontWeight: selected
//                       ? HomeTextStyles.bold
//                       : HomeTextStyles.regular,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _cartTab() {
//     final selected = _selectedIndex == 2;
//     return ValueListenableBuilder<int>(
//       valueListenable: CartService.count,
//       builder: (context, count, child) {
//         final label = count > 0 ? 'Cart($count)' : 'Cart';
//         return Semantics(
//           selected: selected,
//           button: true,
//           label: label,
//           child: InkWell(
//             onTap: () => _selectTab(2),
//             customBorder: const CircleBorder(),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   width: 58,
//                   height: 58,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: selected
//                         ? HomeColors.secondary
//                         : HomeColors.textHint,
//                     border: Border.all(color: HomeColors.white, width: 3),
//                     boxShadow: [
//                       BoxShadow(
//                         color: HomeColors.secondary.withValues(alpha: .20),
//                         blurRadius: 14,
//                         offset: const Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   child: const Icon(
//                     Icons.shopping_bag_outlined,
//                     color: HomeColors.white,
//                     size: 27,
//                   ),
//                 ),
//                 const SizedBox(height: 2),
//                 Text.rich(
//                   TextSpan(
//                     children: [
//                       const TextSpan(text: 'Cart'),
//                       if (count > 0) ...[
//                         const TextSpan(text: ' '),
//                         TextSpan(
//                           text: '($count)',
//                           style: const TextStyle(color: Colors.red),
//                         ),
//                       ],
//                     ],
//                   ),
//                   style: HomeTextStyles.caption.copyWith(
//                     color: selected
//                         ? HomeColors.secondary
//                         : HomeColors.disabled,
//                     fontWeight: selected
//                         ? HomeTextStyles.bold
//                         : HomeTextStyles.regular,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';

import 'package:lalbaba_online/new_app/dashboard/homenew.dart';
import 'package:lalbaba_online/new_app/dashboard/new_accountscreen.dart';
import 'package:lalbaba_online/new_app/dashboard/new_category.dart';
import 'package:lalbaba_online/new_app/dashboard/new_cart.dart';
import 'package:lalbaba_online/new_app/dashboard/new_order.dart';

import 'package:lalbaba_online/new_app/constant/constantcolour.dart';
import 'package:lalbaba_online/new_app/constant/new_constant_text_styles.dart';

import 'package:lalbaba_online/core/services/cart_service.dart';
import 'package:lalbaba_online/core/services/cart_notification_item.dart';

class BottomNavigationScreen extends StatefulWidget {
  final int initialIndex;
  final bool showCartBackButton;

  const BottomNavigationScreen({
    super.key,
    this.initialIndex = 0,
    this.showCartBackButton = false,
  });

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  late int _selectedIndex;
  bool _showCartBackButton = false;
  bool _isMergingCart = false;

  late final List<Widget> _pages;

  static const Duration _animationDuration = Duration(milliseconds: 340);

  static const double _navHeight = 82;
  static const double _floatingHeight = 66;
  static const double _floatingGap = 10;

  @override
  void initState() {
    super.initState();

    _selectedIndex = widget.initialIndex.clamp(0, 4).toInt();

    _showCartBackButton = widget.showCartBackButton;

    _pages = [
      HomeNewPage(onGoToCart: _openCartTab),
      const NewCategoryPage(),
      NewCartPage(showBackButton: _showCartBackButton, onBack: _handleCartBack),
      const NewOrdersPage(),
      NewAccountPage(onOrdersTap: () => _selectTab(3)),
    ];

    CartService.initialize().catchError((Object error) {
      debugPrint('Cart initialization failed: $error');
    });
  }

  // ==========================================================
  // OPEN CART
  // ==========================================================

  void _openCartTab() {
    _animateToCart(showBackButton: true);
  }

  Future<void> _animateToCart({required bool showBackButton}) async {
    if (_selectedIndex == 2 || _isMergingCart) {
      return;
    }

    // Empty cart opens immediately.
    if (CartService.items.value.isEmpty) {
      _showCartPage(showBackButton);
      return;
    }

    setState(() {
      _isMergingCart = true;
    });

    await Future.delayed(_animationDuration);

    if (!mounted) return;

    _showCartPage(showBackButton);
  }

  void _showCartPage(bool showBackButton) {
    setState(() {
      _selectedIndex = 2;
      _showCartBackButton = showBackButton;
      _isMergingCart = false;

      _pages[2] = NewCartPage(
        showBackButton: showBackButton,
        onBack: _handleCartBack,
      );
    });
  }

  void _handleCartBack() {
    if (widget.showCartBackButton) {
      Navigator.of(context).maybePop();
    } else {
      _selectTab(0);
    }
  }

  // ==========================================================
  // TAB SELECTION
  // ==========================================================

  void _selectTab(int index) {
    if (_selectedIndex == index || _isMergingCart) {
      return;
    }

    if (index == 2) {
      _animateToCart(showBackButton: false);
      return;
    }

    setState(() {
      _selectedIndex = index;
      _showCartBackButton = false;

      _pages[2] = const NewCartPage();
    });
  }

  // ==========================================================
  // PRICE CALCULATION
  // ==========================================================

  double _parsePrice(String price) {
    final clean = price.replaceAll(',', '').replaceAll(RegExp(r'[^0-9.]'), '');

    return double.tryParse(clean) ?? 0;
  }

  double _calculateTotal(List<CartNotificationItem> items) {
    return items.fold<double>(
      0,
      (total, item) => total + _parsePrice(item.price) * item.quantity,
    );
  }

  // ==========================================================
  // MAIN BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HomeColors.background,

      // Allows content behind transparent floating area.
      extendBody: true,

      body: IndexedStack(index: _selectedIndex, children: _pages),

      bottomNavigationBar: SafeArea(
        top: false,
        child: ValueListenableBuilder<List<CartNotificationItem>>(
          valueListenable: CartService.items,
          builder: (context, cartItems, child) {
            final quantity = cartItems.fold<int>(
              0,
              (sum, item) => sum + item.quantity,
            );

            final total = _calculateTotal(cartItems);

            final showFloating = cartItems.isNotEmpty && _selectedIndex != 2;

            return AnimatedSize(
              duration: _animationDuration,
              curve: Curves.easeInOutCubic,
              alignment: Alignment.bottomCenter,

              child: SizedBox(
                height: showFloating
                    ? _navHeight + _floatingHeight + _floatingGap
                    : _navHeight,

                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // =====================================
                    // BOTTOM NAVIGATION
                    // =====================================

                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,

                      child: _buildBottomNavigation(),
                    ),

                    // =====================================
                    // FLOATING CART
                    // No white background behind it.
                    // =====================================
                    if (showFloating)
                      Positioned(
                        left: 12,
                        right: 12,
                        bottom: _navHeight + _floatingGap,

                        child: AnimatedOpacity(
                          duration: _animationDuration,
                          curve: Curves.easeInOut,

                          opacity: _isMergingCart ? 0 : 1,

                          child: AnimatedSlide(
                            duration: _animationDuration,
                            curve: Curves.easeInOutCubic,

                            offset: _isMergingCart
                                ? const Offset(0, 1.1)
                                : Offset.zero,

                            child: AnimatedScale(
                              duration: _animationDuration,

                              curve: Curves.easeInOutCubic,

                              alignment: Alignment.bottomCenter,

                              scale: _isMergingCart ? 0.25 : 1,

                              child: IgnorePointer(
                                ignoring: _isMergingCart,

                                child: _buildFloatingCart(
                                  quantity: quantity,
                                  total: total,
                                  productCount: cartItems.length,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ==========================================================
  // PROFESSIONAL FLOATING CART BAR
  // ==========================================================

  Widget _buildFloatingCart({
    required int quantity,
    required double total,
    required int productCount,
  }) {
    return Material(
      color: HomeColors.surface,
      borderRadius: BorderRadius.circular(20),
      elevation: 3,
      shadowColor: HomeColors.black.withValues(alpha: 0.10),
      child: InkWell(
        onTap: _openCartTab,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 68,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: HomeColors.secondary.withValues(alpha: 0.16),
            ),
          ),
          child: Row(
            children: [
              // LEFT BASKET ICON
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: HomeColors.secondaryLight,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.shopping_basket_outlined,
                  size: 24,
                  color: HomeColors.secondary,
                ),
              ),

              const SizedBox(width: 10),

              // BASKET DETAILS
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Basket',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: HomeTextStyles.bodyEmphasis.copyWith(
                        color: HomeColors.textPrimary,
                        fontWeight: HomeTextStyles.semiBold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$quantity ${quantity == 1 ? 'item' : 'items'}'
                      ' · ₹${total.toStringAsFixed(0)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: HomeTextStyles.caption.copyWith(
                        color: HomeColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // BIGBASKET-STYLE BAG + COUNT + ARROW
              Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 13),
                decoration: BoxDecoration(
                  color: HomeColors.secondary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.shopping_bag_outlined,
                      color: HomeColors.white,
                      size: 23,
                    ),
                    const SizedBox(width: 7),
                    Text(
                      '$quantity',
                      style: HomeTextStyles.bodyEmphasis.copyWith(
                        color: HomeColors.white,
                        fontWeight: HomeTextStyles.bold,
                      ),
                    ),
                    const SizedBox(width: 9),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      color: HomeColors.white,
                      size: 21,
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

  // ==========================================================
  // ORIGINAL BOTTOM NAVIGATION
  // ==========================================================

  Widget _buildBottomNavigation() {
    return SizedBox(
      height: _navHeight,

      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,

        children: [
          Positioned.fill(
            top: 8,

            child: DecoratedBox(
              decoration: BoxDecoration(
                color: HomeColors.surface,

                border: const Border(
                  top: BorderSide(color: HomeColors.divider),
                ),

                boxShadow: [
                  BoxShadow(
                    color: HomeColors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),

              child: Row(
                children: [
                  _tabItem(0, Icons.home_rounded, 'Home'),

                  _tabItem(1, Icons.grid_view_rounded, 'Categories'),

                  const Expanded(child: SizedBox.shrink()),

                  _tabItem(3, Icons.receipt_long_outlined, 'Orders'),

                  _tabItem(4, Icons.person_outline_rounded, 'Account'),
                ],
              ),
            ),
          ),

          Positioned(top: 0, child: _cartTab()),
        ],
      ),
    );
  }

  // ==========================================================
  // NORMAL TABS
  // ==========================================================

  Widget _tabItem(int index, IconData icon, String title) {
    final selected = _selectedIndex == index;

    final color = selected ? HomeColors.secondary : HomeColors.disabled;

    return Expanded(
      child: InkWell(
        onTap: () => _selectTab(index),

        borderRadius: BorderRadius.circular(12),

        child: Semantics(
          selected: selected,
          button: true,
          label: title,

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Icon(icon, color: color, size: 23),

              const SizedBox(height: 4),

              Text(
                title,

                maxLines: 1,
                overflow: TextOverflow.ellipsis,

                style: HomeTextStyles.caption.copyWith(
                  color: color,

                  fontWeight: selected
                      ? HomeTextStyles.bold
                      : HomeTextStyles.regular,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // CENTER CART TAB
  // ==========================================================

  Widget _cartTab() {
    final selected = _selectedIndex == 2;

    return ValueListenableBuilder<int>(
      valueListenable: CartService.count,

      builder: (context, count, child) {
        final label = count > 0 ? 'Cart ($count)' : 'Cart';

        return Semantics(
          selected: selected,
          button: true,
          label: label,

          child: InkWell(
            onTap: () => _selectTab(2),
            customBorder: const CircleBorder(),

            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                AnimatedScale(
                  duration: _animationDuration,
                  curve: Curves.easeOutCubic,

                  scale: selected ? 1.06 : 1,

                  child: Container(
                    width: 58,
                    height: 58,

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,

                      color: selected
                          ? HomeColors.secondary
                          : HomeColors.textHint,

                      border: Border.all(color: HomeColors.white, width: 3),

                      boxShadow: [
                        BoxShadow(
                          color: HomeColors.black.withValues(alpha: 0.12),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),

                    child: Stack(
                      clipBehavior: Clip.none,

                      children: [
                        const Center(
                          child: Icon(
                            Icons.shopping_bag_outlined,
                            color: HomeColors.white,
                            size: 26,
                          ),
                        ),

                        if (count > 0)
                          Positioned(
                            top: -5,
                            right: -5,

                            child: Container(
                              constraints: const BoxConstraints(
                                minWidth: 22,
                                minHeight: 22,
                              ),

                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 2,
                              ),

                              decoration: BoxDecoration(
                                color: HomeColors.secondary,

                                borderRadius: BorderRadius.circular(15),

                                border: Border.all(
                                  color: HomeColors.white,
                                  width: 2,
                                ),
                              ),

                              child: Center(
                                child: Text(
                                  count > 99 ? '99+' : '$count',

                                  style: HomeTextStyles.caption.copyWith(
                                    color: HomeColors.white,
                                    fontSize: 10,
                                    fontWeight: HomeTextStyles.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  'Cart',

                  style: HomeTextStyles.caption.copyWith(
                    color: selected
                        ? HomeColors.secondary
                        : HomeColors.disabled,

                    fontWeight: selected
                        ? HomeTextStyles.bold
                        : HomeTextStyles.regular,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
