

import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/asset_constants.dart';
import '../../../../core/services/cart_service.dart';


class LalBabaAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  
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
    // =====================================================================
    // GLOBAL CART COUNT LISTENER
    // =====================================================================

    return ValueListenableBuilder<int>(
      valueListenable: CartService.count,
      builder: (
        context,
        globalCount,
        child,
      ) {
        return AppBar(
          backgroundColor: AppColors.error,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          automaticallyImplyLeading: false,
          titleSpacing: 12,

          // ===============================================================
          // LOGO + BRAND
          // ===============================================================

          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 56,
                height: 56,
                child: Image.asset(
                  AssetConstants.logo,
                  fit: BoxFit.contain,
                  errorBuilder: (
                    context,
                    error,
                    stackTrace,
                  ) {
                    return const Icon(
                      Icons.rice_bowl_rounded,
                      color: AppColors.background,
                      size: 36,
                    );
                  },
                ),
              ),

              const SizedBox(width: 10),

              const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    'LalBaba',
                    style: TextStyle(
                      color:
                          AppColors.background,
                      fontSize: 19,
                      fontWeight:
                          FontWeight.w700,
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
                      fontWeight:
                          FontWeight.w500,
                      letterSpacing: 0.4,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // ===============================================================
          // ACTIONS
          // ===============================================================

          actions: [
            // NOTIFICATION
            _buildNotificationButton(
              globalCount,
            ),

            const SizedBox(width: 8),

            // Cart button currently disabled.
            //
            // Future-e enable korte chaile:
            //
            // _buildCartButton(globalCount),

            const SizedBox(width: 8),
          ],
        );
      },
    );
  }

  // =======================================================================
  // NOTIFICATION BUTTON
  // =======================================================================

  Widget _buildNotificationButton(
    int globalCount,
  ) {
    return IconButton(
      tooltip: 'Notifications',
      onPressed: onNotificationTap,
      style: IconButton.styleFrom(
        backgroundColor:
            AppColors.background.withValues(
          alpha: 0.12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(12),
        ),
      ),
      icon: Badge(
        isLabelVisible: globalCount > 0,
        label: Text(
          globalCount > 99
              ? '99+'
              : '$globalCount',
        ),
        child: const Icon(
          Icons.notifications_none_rounded,
          color: AppColors.background,
          size: 28,
        ),
      ),
    );
  }

  

  // =======================================================================
  // APP BAR HEIGHT
  // =======================================================================

  @override
  Size get preferredSize =>
      const Size.fromHeight(
        kToolbarHeight,
      );
}