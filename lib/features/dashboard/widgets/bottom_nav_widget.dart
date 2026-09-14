import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_sizes.dart';
import '../../account/presentation/widgets/app_string.dart';

class NavItemData {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const NavItemData({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

class BottomNavWidget extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final int cartCount;

  const BottomNavWidget({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.cartCount = 0,
  });

  static const int homeIndex = 0;
  static const int categoriesIndex = 1;
  static const int cartIndex = 2;
  static const int ordersIndex = 3;
  static const int accountIndex = 4;

  static const double _barHeight = 65;
  static const double _cartSize = 58;
  static const double _cartTop = -32;
  static const double _topRadius = 26;

  static const Color _barColor = Colors.white;

  Color get _inactiveColor => AppColors.grey.withValues(alpha: 0.70);

  List<NavItemData> get _items => [
    NavItemData(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: AppStrings.home,
    ),
    NavItemData(
      icon: Icons.grid_view_outlined,
      activeIcon: Icons.grid_view_rounded,
      label: AppStrings.categories,
    ),
    NavItemData(
      icon: Icons.receipt_long_outlined,
      activeIcon: Icons.receipt_long_rounded,
      label: AppStrings.orders,
    ),
    NavItemData(
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: AppStrings.account,
    ),
  ];

  Widget _buildNavItem({
    required NavItemData item,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final Color color = selected ? AppColors.primary : _inactiveColor;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        splashColor: AppColors.primary.withValues(alpha: 0.06),
        highlightColor: Colors.transparent,
        child: SizedBox(
          height: _barHeight,
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AnimatedScale(
                    scale: selected ? 1.08 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOutBack,
                    child: Icon(
                      selected ? item.activeIcon : item.icon,
                      color: color,
                      size: selected
                          ? AppSizes.iconMedium + 1
                          : AppSizes.iconMedium,
                    ),
                  ),
                  const SizedBox(height: 3),
                  SizedBox(
                    height: 15,
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeOut,
                      style: TextStyle(
                        color: color,
                        fontSize: 11,
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        height: 1.1,
                      ),
                      child: Text(
                        item.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 3),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCartItem() {
    final bool selected = currentIndex == cartIndex;

    final Color color = selected ? AppColors.primary : _inactiveColor;

    return Expanded(
      child: InkWell(
        onTap: () => onTap(cartIndex),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: SizedBox(
          height: _barHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Spacer(),
              SizedBox(
                height: 15,
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
                  style: TextStyle(
                    color: color,
                    fontSize: 11,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    height: 1.1,
                  ),
                  child: Text(
                    AppStrings.cart,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingCart() {
    final bool selected = currentIndex == cartIndex;

    return Positioned(
      top: _cartTop,
      left: 0,
      right: 0,
      child: Center(
        child: GestureDetector(
          onTap: () => onTap(cartIndex),
          behavior: HitTestBehavior.opaque,
          child: AnimatedScale(
            scale: selected ? 1.04 : 1.0,
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutBack,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: _cartSize,
                  height: _cartSize,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _barColor,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.18),
                        blurRadius: 18,
                        spreadRadius: 2,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: selected ? AppColors.primary : AppColors.grey,
                    ),
                    child: Center(
                      child: AnimatedScale(
                        scale: selected ? 1.08 : 1.0,
                        duration: const Duration(milliseconds: 180),
                        child: const Icon(
                          Icons.shopping_bag_outlined,
                          color: Colors.white,
                          size: 27,
                        ),
                      ),
                    ),
                  ),
                ),
                if (cartCount > 0)
                  Positioned(
                    right: -1,
                    top: -2,
                    child: Container(
                      constraints: const BoxConstraints(
                        minWidth: 21,
                        minHeight: 21,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          cartCount > 99 ? '99+' : cartCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar({required double bottomInset}) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(_topRadius),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            height: _barHeight + bottomInset,
            padding: EdgeInsets.only(bottom: bottomInset),
            decoration: BoxDecoration(
              color: _barColor.withValues(alpha: 0.78),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(_topRadius),
              ),
              border: Border(
                top: BorderSide(
                  color: Colors.white.withValues(alpha: 0.75),
                  width: 1,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.07),
                  blurRadius: 18,
                  spreadRadius: 0,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              children: [
                _buildNavItem(
                  item: _items[0],
                  selected: currentIndex == homeIndex,
                  onTap: () => onTap(homeIndex),
                ),
                _buildNavItem(
                  item: _items[1],
                  selected: currentIndex == categoriesIndex,
                  onTap: () => onTap(categoriesIndex),
                ),
                _buildCartItem(),
                _buildNavItem(
                  item: _items[2],
                  selected: currentIndex == ordersIndex,
                  onTap: () => onTap(ordersIndex),
                ),
                _buildNavItem(
                  item: _items[3],
                  selected: currentIndex == accountIndex,
                  onTap: () => onTap(accountIndex),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double bottomInset = MediaQuery.paddingOf(context).bottom;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: MediaQuery.textScalerOf(
          context,
        ).clamp(maxScaleFactor: 1.15),
      ),
      child: SizedBox(
        width: double.infinity,
        height: _barHeight + bottomInset,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            _buildBottomBar(bottomInset: bottomInset),
            _buildFloatingCart(),
          ],
        ),
      ),
    );
  }
}
