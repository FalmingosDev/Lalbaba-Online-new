import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lalbaba_online/new_app/policy/new_about_us.dart';
import 'package:lalbaba_online/new_app/policy/new_terms_of_use.dart';

import 'package:lalbaba_online/app/router/route_names.dart';
import 'package:lalbaba_online/app/config/app_config.dart';

import 'package:lalbaba_online/new_app/constant/constantappbar.dart';
import 'package:lalbaba_online/new_app/constant/constantcolour.dart';
import 'package:lalbaba_online/new_app/constant/new_constant_text_styles.dart';

import 'package:lalbaba_online/new_app/checkout/new_profile.dart';
import 'package:lalbaba_online/new_app/dashboard/new_wishlist.dart';
import 'package:lalbaba_online/new_app/policy/privacy_policy_page.dart';
import 'package:lalbaba_online/new_app/policy/shipping_policy_page.dart';
import 'package:lalbaba_online/new_app/policy/return_refund_policy_page.dart';

// =============================================================
// ACCOUNT PAGE STYLE
// =============================================================

class _AccountStyle {
  _AccountStyle._();

  static const double pagePadding = 16;
  static const double profileRadius = 20;
  static const double sectionRadius = 18;
  static const double iconRadius = 10;
  static const double iconBoxSize = 40;
  static const double avatarSize = 64;
  static const double menuIconSize = 20;
  static const double logoutRadius = 28;
}

// =============================================================
// NEW ACCOUNT PAGE
// =============================================================

class NewAccountPage extends StatefulWidget {
  final VoidCallback? onOrdersTap;

  final VoidCallback? onTrackOrderTap;

  final Future<void> Function()? onLogout;

  const NewAccountPage({
    super.key,
    this.onOrdersTap,
    this.onTrackOrderTap,
    this.onLogout,
  });

  @override
  State<NewAccountPage> createState() =>
      _NewAccountPageState();
}

class _NewAccountPageState extends State<NewAccountPage> {

  // ===========================================================
  // PROFILE DATA
  // ===========================================================

  String _profileName = 'John Doe';

  String _profileEmail = 'john.doe@example.com';

  String _profilePhone = '';

  String _profileAvatarUrl = '';

  String? _profileLocalImagePath;

  // ===========================================================
  // SHOW MESSAGE
  // ===========================================================

  void _showMessage(
    String message, {
    bool isError = false,
  }) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: isError
              ? HomeColors.error
              : HomeColors.secondary,

          behavior: SnackBarBehavior.floating,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),

          content: Text(
            message,

            style: HomeTextStyles.body.copyWith(
              color: HomeColors.white,
            ),
          ),
        ),
      );
  }

  void _openPolicyPage(Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }

  // ===========================================================
  // OPEN NEW PROFILE PAGE
  // ===========================================================

  Future<void> _openProfilePage() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => NewProfilePage(
          name: _profileName,

          email: _profileEmail,

          phoneNumber: _profilePhone,

          avatarUrl: _profileAvatarUrl,

          selectedImagePath: _profileLocalImagePath,

          // PROFILE DATA UPDATED

          onSaved: (NewProfileData data) {
            if (!mounted) return;

            setState(() {
              _profileName = data.name;

              _profileEmail = data.email;

              _profilePhone = data.phoneNumber;

              _profileAvatarUrl = data.avatarUrl;

              _profileLocalImagePath =
                  data.selectedImagePath;
            });
          },
        ),
      ),
    );
  }

  // ===========================================================
  // OPEN NEW WISHLIST PAGE
  // ===========================================================

  Future<void> _openWishlistPage() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const NewWishlistPage(),
      ),
    );
  }

  // ===========================================================
  // OPEN CONTACT PAGE
  // ===========================================================

  void _openContactPage() {
    context.push(RouteNames.contact);
  }

  // ===========================================================
  // OPEN ADDRESS PAGE
  // ===========================================================

  void _openAddressPage() {
    context.push(RouteNames.address);
  }

  // ===========================================================
  // OPEN ORDERS PAGE
  // ===========================================================

  void _openOrdersPage() {
    if (widget.onOrdersTap != null) {
      widget.onOrdersTap!();
    } else {
      _showMessage(
        'Orders page is not connected yet.',
      );
    }
  }

  // ===========================================================
  // TRACK ORDER
  // ===========================================================

  void _openTrackOrderPage() {
    if (widget.onTrackOrderTap != null) {
      widget.onTrackOrderTap!();
    } else {
      _showMessage(
        'Order tracking is not connected yet.',
      );
    }
  }

  // ===========================================================
  // LOGOUT CONFIRMATION
  // ===========================================================

  Future<void> _handleLogoutTap() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,

      barrierDismissible: true,

      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: HomeColors.surface,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              _AccountStyle.sectionRadius,
            ),
          ),

          // LOGOUT TITLE

          title: Text(
            'Log Out',

            style: HomeTextStyles.pageTitle.copyWith(
              color: HomeColors.textPrimary,
            ),
          ),

          // LOGOUT MESSAGE

          content: Text(
            'Are you sure you want to log out?',

            style: HomeTextStyles.body.copyWith(
              color: HomeColors.textPrimary,
            ),
          ),

          actionsPadding: const EdgeInsets.fromLTRB(
            16,
            0,
            16,
            12,
          ),

          actions: [

            // CANCEL BUTTON

            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },

              child: Text(
                'Cancel',

                style: HomeTextStyles.button.copyWith(
                  color: HomeColors.textSecondary,
                ),
              ),
            ),

            // CONFIRM LOGOUT BUTTON

            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },

              child: Text(
                'Log Out',

                style: HomeTextStyles.button.copyWith(
                  color: HomeColors.secondary,

                  fontWeight: HomeTextStyles.bold,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    if (widget.onLogout == null) {
      _showMessage(
        'Logout service is not connected yet.',
      );

      return;
    }

    try {
      await widget.onLogout!();
    } catch (error) {
      if (!mounted) return;

      _showMessage(
        'Unable to log out. Please try again.',

        isError: true,
      );

      debugPrint('Logout Error: $error');
    }
  }

  // ===========================================================
  // MAIN BUILD
  // ===========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HomeColors.background,

      // =======================================================
      // COMMON APPBAR
      // =======================================================

      appBar: const CommonAppBar(
        title: 'Account',

        automaticallyImplyLeading: false,

        showBackButton: false,

        centerTitle: true,

        backgroundColor: HomeColors.secondary,

        titleColor: HomeColors.white,

        iconColor: HomeColors.white,
      ),

      // =======================================================
      // BODY
      // =======================================================

      body: SafeArea(
        top: false,

        bottom: false,

        child: ListView(
          physics: const ClampingScrollPhysics(),

          padding: const EdgeInsets.fromLTRB(
            _AccountStyle.pagePadding,
            16,
            _AccountStyle.pagePadding,
            24,
          ),

          children: [

            // =================================================
            // PROFILE HEADER
            // =================================================

            _AccountProfileHeader(
              name: _profileName,

              email: _profileEmail,

              avatarUrl:
                  _profileLocalImagePath ??
                  _profileAvatarUrl,

              onProfileTap: _openProfilePage,

              onEditTap: _openProfilePage,
            ),

            const SizedBox(height: 24),

            // =================================================
            // ACCOUNT SECTION
            // =================================================

            const _AccountSectionLabel(
              text: 'Account',
              color: HomeColors.secondary,
            ),

            _AccountSectionCard(
              children: [

                // MY PROFILE

                _AccountMenuTile(
                  icon: Icons.person_outline,

                  label: 'My Profile',

                  onTap: _openProfilePage,
                ),

                // MY ADDRESS

                _AccountMenuTile(
                  icon: Icons.location_on_outlined,

                  label: 'My Address',

                  onTap: _openAddressPage,
                ),

                // ABOUT US

_AccountMenuTile(
  icon: Icons.info_outline,
  label: 'About Us',
  onTap: () {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const NewAboutUsPage(
          imageUrl:
              'https://www.lalbabaonline.com/public/uploads/all/bGGGE26rwRBuaSOAcGyhqKN99wkkAfEttcudNtOb.webp',
        ),
      ),
    );
  },
),

                // CONTACT US

                _AccountMenuTile(
                  icon: Icons.call_outlined,

                  label: 'Contact Us',

                  onTap: _openContactPage,

                  showDivider: false,
                ),
              ],
            ),

            const SizedBox(height: 20),

            // =================================================
            // TERMS AND POLICIES SECTION
            // =================================================
            const _AccountSectionLabel(
              text: 'My Orders',
              color: HomeColors.secondary,
            ),

            _AccountSectionCard(
              children: [

                // MY ORDERS

                _AccountMenuTile(
                  icon: Icons.local_shipping_outlined,

                  label: 'My Orders',

                  onTap: _openOrdersPage,
                ),

                // WISHLIST

                _AccountMenuTile(
                  icon: Icons.favorite_border,

                  label: 'Wishlist',

                  onTap: _openWishlistPage,
                ),

                // TRACK ORDER

                _AccountMenuTile(
                  icon: Icons.local_shipping_outlined,

                  label: 'Track Order',

                  onTap: _openTrackOrderPage,
                ),

                // RETURNS AND REFUND

        
              ],
            ),
 const SizedBox(height: 20),
            const _AccountSectionLabel(
              text: 'Policies',
              color: HomeColors.secondary,
            ),
 
            _AccountSectionCard(
              children: [

                // TERMS OF USE

                _AccountMenuTile(
                  icon: Icons.description_outlined,

                  label: 'Terms of Use',

                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const NewTermsOfUsePage(),
                      ),
                    );
                  },
                ),

                // PRIVACY POLICY

                _AccountMenuTile(
                  icon: Icons.privacy_tip_outlined,

                  label: 'Privacy Policy',

                  onTap: () =>
                      _openPolicyPage(const PrivacyPolicyPage()),
                ),

                // SHIPPING POLICY

                _AccountMenuTile(
                  icon: Icons.inventory_2_outlined,

                  label: 'Shipping Policy',

                  onTap: () =>
                      _openPolicyPage(const ShippingPolicyPage()),
                ),

                // FACTORY LOCATOR

                _AccountMenuTile(
                  icon: Icons.factory_outlined,

                  label: 'Returns & Refund',

                  onTap: () =>
                      _openPolicyPage(const ReturnRefundPolicyPage()),

                  showDivider: false,
                ),
              ],
            ),

            const SizedBox(height: 20),

            // =================================================
            // MY ORDERS SECTION
            // =================================================

           

          

            const SizedBox(height: 28),

            // =================================================
            // LOGOUT BUTTON
            // =================================================

            _AccountLogoutButton(
              label: 'Log Out',

              onTap: _handleLogoutTap,
            ),

            const SizedBox(height: 18),

            // =================================================
            // APP VERSION
            // =================================================

            Text(
              'App Version ${AppConfig.version}',

              textAlign: TextAlign.center,

              style: HomeTextStyles.caption.copyWith(
                color: HomeColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================
// ACCOUNT PROFILE HEADER
// =============================================================

class _AccountProfileHeader extends StatelessWidget {
  final String name;

  final String email;

  final String? avatarUrl;

  final VoidCallback? onProfileTap;

  final VoidCallback? onEditTap;

  const _AccountProfileHeader({
    required this.name,
    required this.email,
    this.avatarUrl,
    this.onProfileTap,
    this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: HomeColors.surface,

        borderRadius: BorderRadius.circular(
          _AccountStyle.profileRadius,
        ),

        boxShadow: [
          BoxShadow(
            color: HomeColors.black.withValues(
              alpha: 0.05,
            ),

            blurRadius: 16,

            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Material(
        color: HomeColors.surface,

        borderRadius: BorderRadius.circular(
          _AccountStyle.profileRadius,
        ),

        child: InkWell(
          onTap: onProfileTap,

          borderRadius: BorderRadius.circular(
            _AccountStyle.profileRadius,
          ),

          child: Padding(
            padding: const EdgeInsets.all(18),

            child: Row(
              children: [

                // =============================================
                // PROFILE AVATAR
                // =============================================

                Container(
                  width: _AccountStyle.avatarSize,

                  height: _AccountStyle.avatarSize,

                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,

                    gradient: LinearGradient(
                      colors: [
                        HomeColors.secondary,
                        HomeColors.secondaryLight,
                      ],

                      begin: Alignment.topLeft,

                      end: Alignment.bottomRight,
                    ),
                  ),

                  padding: const EdgeInsets.all(2.5),

                  child: ClipOval(
                    child: _buildAvatar(),
                  ),
                ),

                const SizedBox(width: 16),

                // =============================================
                // PROFILE NAME AND EMAIL
                // =============================================

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [

                      Row(
                        children: [

                          // PROFILE NAME

                          Flexible(
                            child: Text(
                              name,

                              maxLines: 1,

                              overflow:
                                  TextOverflow.ellipsis,

                              style: HomeTextStyles
                                  .sectionTitle
                                  .copyWith(
                                    color: HomeColors
                                        .textPrimary,
                                  ),
                            ),
                          ),

                          const SizedBox(width: 8),

                          // EDIT PROFILE BUTTON

                          GestureDetector(
                            onTap: onEditTap,

                            child: Container(
                              padding:
                                  const EdgeInsets.all(5),

                              decoration:
                                  const BoxDecoration(
                                    color: HomeColors
                                        .secondaryLight,

                                    shape: BoxShape.circle,
                                  ),

                              child: const Icon(
                                Icons.chevron_right,

                                size: 16,

                                color: HomeColors.secondary,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      // PROFILE EMAIL

                      Text(
                        email,

                        maxLines: 1,

                        overflow:
                            TextOverflow.ellipsis,

                        style: HomeTextStyles.bodySmall
                            .copyWith(
                              color: HomeColors
                                  .textSecondary,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================
  // BUILD AVATAR
  // ===========================================================

  Widget _buildAvatar() {
    final String url = avatarUrl?.trim() ?? '';

    if (url.isEmpty) {
      return _fallbackAvatar();
    }

    // =========================================================
    // NETWORK IMAGE
    // =========================================================

    if (url.startsWith('https://') ||
        url.startsWith('http://')) {
      return Image.network(
        url,

        fit: BoxFit.cover,

        errorBuilder: (_, __, ___) {
          return _fallbackAvatar();
        },
      );
    }

    // =========================================================
    // ASSET IMAGE
    // =========================================================

    if (url.startsWith('assets/')) {
      return Image.asset(
        url,

        fit: BoxFit.cover,

        errorBuilder: (_, __, ___) {
          return _fallbackAvatar();
        },
      );
    }

    // =========================================================
    // CAMERA OR GALLERY IMAGE
    // =========================================================

    return Image.file(
      File(url),

      fit: BoxFit.cover,

      errorBuilder: (_, __, ___) {
        return _fallbackAvatar();
      },
    );
  }

  // ===========================================================
  // FALLBACK AVATAR
  // ===========================================================

  Widget _fallbackAvatar() {
    return Container(
      color: HomeColors.secondaryLight,

      alignment: Alignment.center,

      child: const Icon(
        Icons.person,

        color: HomeColors.secondary,

        size: 30,
      ),
    );
  }
}

// =============================================================
// ACCOUNT SECTION LABEL
// =============================================================

class _AccountSectionLabel extends StatelessWidget {
  final String text;
  final Color color;

  const _AccountSectionLabel({
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 6,

        bottom: 8,
      ),

      child: Text(
        text,

        style: HomeTextStyles.chip.copyWith(
          color: color,
          fontSize: HomeTextStyles.sizeProduct,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

// =============================================================
// ACCOUNT SECTION CARD
// =============================================================

class _AccountSectionCard extends StatelessWidget {
  final List<Widget> children;

  const _AccountSectionCard({
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
      ),

      decoration: BoxDecoration(
        color: HomeColors.surface,

        borderRadius: BorderRadius.circular(
          _AccountStyle.sectionRadius,
        ),

        boxShadow: [
          BoxShadow(
            color: HomeColors.black.withValues(
              alpha: 0.04,
            ),

            blurRadius: 12,

            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Material(
        color: HomeColors.surface,

        borderRadius: BorderRadius.circular(
          _AccountStyle.sectionRadius,
        ),

        child: Column(
          children: children,
        ),
      ),
    );
  }
}

// =============================================================
// ACCOUNT MENU TILE
// =============================================================

class _AccountMenuTile extends StatelessWidget {
  final IconData icon;

  final String label;

  final VoidCallback? onTap;

  final bool showDivider;

  const _AccountMenuTile({
    required this.icon,
    required this.label,
    this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        InkWell(
          onTap: onTap,

          borderRadius: BorderRadius.circular(12),

          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
            ),

            child: Row(
              children: [

                // =============================================
                // MENU ICON
                // =============================================

                Container(
                  width: _AccountStyle.iconBoxSize,

                  height: _AccountStyle.iconBoxSize,

                  alignment: Alignment.center,

                  decoration: BoxDecoration(
                    color: HomeColors.secondaryLight,

                    borderRadius: BorderRadius.circular(
                      _AccountStyle.iconRadius,
                    ),
                  ),

                  child: Icon(
                    icon,

                    size: _AccountStyle.menuIconSize,

                    color: HomeColors.secondary,
                  ),
                ),

                const SizedBox(width: 14),

                // =============================================
                // MENU LABEL
                // =============================================

                Expanded(
                  child: Text(
                    label,

                    style: HomeTextStyles.productTitle
                        .copyWith(
                          color: HomeColors.textPrimary,

                          fontWeight:
                              HomeTextStyles.regular,
                        ),
                  ),
                ),

                // =============================================
                // RIGHT ARROW
                // =============================================

                const Icon(
                  Icons.chevron_right,

                  size: 20,

                  color: HomeColors.textHint,
                ),
              ],
            ),
          ),
        ),

        // DIVIDER

        if (showDivider)
          const Divider(
            height: 1,

            color: HomeColors.divider,
          ),
      ],
    );
  }
}

// =============================================================
// ACCOUNT LOGOUT BUTTON
// =============================================================

class _AccountLogoutButton extends StatelessWidget {
  final String label;

  final VoidCallback? onTap;

  const _AccountLogoutButton({
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: HomeColors.secondary,

        borderRadius: BorderRadius.circular(
          _AccountStyle.logoutRadius,
        ),

        boxShadow: [
          BoxShadow(
            color: HomeColors.secondary.withValues(
              alpha: 0.35,
            ),

            blurRadius: 14,

            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Material(
        color: HomeColors.secondary,

        borderRadius: BorderRadius.circular(
          _AccountStyle.logoutRadius,
        ),

        child: InkWell(
          onTap: onTap,

          borderRadius: BorderRadius.circular(
            _AccountStyle.logoutRadius,
          ),

          child: Container(
            width: double.infinity,

            padding: const EdgeInsets.symmetric(
              vertical: 14,
            ),

            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,

              children: [

                const Icon(
                  Icons.logout,

                  size: 18,

                  color: HomeColors.white,
                ),

                const SizedBox(width: 8),

                Text(
                  label,

                  style: HomeTextStyles.button.copyWith(
                    color: HomeColors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}