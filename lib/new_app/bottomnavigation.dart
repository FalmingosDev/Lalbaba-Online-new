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

import 'package:flutter/material.dart';
import 'package:lalbaba_online/new_app/homenew.dart';
import 'package:lalbaba_online/new_app/new_accountscreen.dart';
import 'package:lalbaba_online/new_app/new_category.dart';
import 'package:lalbaba_online/new_app/new_cart.dart';
import 'package:lalbaba_online/new_app/new_order.dart';
import 'package:lalbaba_online/new_app/constantcolour.dart';
import 'package:lalbaba_online/new_app/new_constant_text_styles.dart';

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
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex.clamp(0, 4).toInt();
    _showCartBackButton = widget.showCartBackButton;
    _pages = [
      const HomeNewPage(),
      const NewCategoryPage(),
      NewCartPage(showBackButton: _showCartBackButton),
      const NewOrdersPage(),
      NewAccountPage(onOrdersTap: () => _selectTab(3)),
    ];
  }

  void _selectTab(int index) {
    if (_selectedIndex == index && !_showCartBackButton) return;
    setState(() {
      _selectedIndex = index;
      _showCartBackButton = false;
      _pages[2] = const NewCartPage();
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: HomeColors.surface,
    body: IndexedStack(index: _selectedIndex, children: _pages),
    bottomNavigationBar: SafeArea(
      top: false,
      child: SizedBox(
        height: 82,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            Positioned.fill(
              top: 8,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: HomeColors.surface,
                  border: const Border(top: BorderSide(color: HomeColors.divider)),
                  boxShadow: [BoxShadow(color: HomeColors.black.withValues(alpha: .04), blurRadius: 10, offset: const Offset(0, -3))],
                ),
                child: Row(children: [
                  _tabItem(0, Icons.home_rounded, 'Home'),
                  _tabItem(1, Icons.grid_view_rounded, 'Categories'),
                  const Expanded(child: SizedBox.shrink()),
                  _tabItem(3, Icons.receipt_long_outlined, 'Orders'),
                  _tabItem(4, Icons.person_outline_rounded, 'Account'),
                ]),
              ),
            ),
            Positioned(top: 0, child: _cartTab()),
          ],
        ),
      ),
    ),
  );

  Widget _tabItem(int index, IconData icon, String title) {
    final selected = _selectedIndex == index;
    final color = selected ? HomeColors.secondary : HomeColors.disabled;
    return Expanded(child: InkWell(
      onTap: () => _selectTab(index),
      borderRadius: BorderRadius.circular(12),
      child: Semantics(
        selected: selected, button: true, label: title,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, color: color, size: 23),
          const SizedBox(height: 4),
          Text(title, maxLines: 1, overflow: TextOverflow.ellipsis,
            style: HomeTextStyles.caption.copyWith(color: color, fontWeight: selected ? HomeTextStyles.bold : HomeTextStyles.regular)),
        ]),
      ),
    ));
  }

  Widget _cartTab() {
    final selected = _selectedIndex == 2;
    return Semantics(
      selected: selected, button: true, label: 'Cart',
      child: InkWell(
        onTap: () => _selectTab(2), customBorder: const CircleBorder(),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 58, height: 58,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected ? HomeColors.secondary : HomeColors.textHint,
              border: Border.all(color: HomeColors.white, width: 3),
              boxShadow: [BoxShadow(color: HomeColors.secondary.withValues(alpha: .20), blurRadius: 14, offset: const Offset(0, 4))],
            ),
            child: const Icon(Icons.shopping_bag_outlined, color: HomeColors.white, size: 27),
          ),
          const SizedBox(height: 2),
          Text('Cart', style: HomeTextStyles.caption.copyWith(color: selected ? HomeColors.secondary : HomeColors.disabled, fontWeight: selected ? HomeTextStyles.bold : HomeTextStyles.regular)),
        ]),
      ),
    );
  }
}
