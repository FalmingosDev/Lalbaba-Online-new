
import 'package:flutter/material.dart';

import 'constantcolour.dart';

class CommonAppBar extends StatelessWidget
    implements PreferredSizeWidget {

  // ============================================================
  // APP BAR PROPERTIES
  // ============================================================

  final String? title;
  final String? subtitle;

  final Widget? titleWidget;
  final Widget? leading;

  final List<Widget>? actions;

  final Color backgroundColor;
  final Color titleColor;
  final Color iconColor;

  final double height;
  final double elevation;

  final bool showBackButton;
  final bool centerTitle;

  final VoidCallback? onBackPressed;

  final double titleFontSize;
  final double subtitleFontSize;

  final Widget? bottomWidget;
  final double bottomHeight;

  // ============================================================
  // CONSTRUCTOR
  // ============================================================

  const CommonAppBar({
    super.key,
    this.title,
    this.subtitle,
    this.titleWidget,
    this.leading,
    this.actions,
    this.backgroundColor = HomeColors.secondary,
    this.titleColor = Colors.white,
    this.iconColor = Colors.white,
    this.height = 60,
    this.elevation = 0,
    this.showBackButton = false,
    this.centerTitle = false,
    this.onBackPressed,
    this.titleFontSize = 19,
    this.subtitleFontSize = 10,
    this.bottomWidget,
    this.bottomHeight = 0, required bool automaticallyImplyLeading,
  });

  // ============================================================
  // APP BAR HEIGHT
  // ============================================================

  @override
  Size get preferredSize =>
      Size.fromHeight(height + bottomHeight);

  // ============================================================
  // BACK BUTTON
  // ============================================================

  Widget _buildBackButton(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back_ios_new_rounded,
        color: iconColor,
        size: 21,
      ),
      onPressed: () {
        if (onBackPressed != null) {
          onBackPressed!();
        } else {
          Navigator.of(context).maybePop();
        }
      },
    );
  }

  // ============================================================
  // TITLE
  // ============================================================

  Widget? _buildTitle() {
    if (titleWidget != null) {
      return titleWidget;
    }

    if (title == null && subtitle == null) {
      return null;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: centerTitle
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        if (title != null)
          Text(
            title!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: titleColor,
              fontSize: titleFontSize,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
              height: 1.1,
            ),
          ),

        if (subtitle != null) ...[
          const SizedBox(height: 3),
          Text(
            subtitle!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: titleColor.withValues(alpha: 0.80),
              fontSize: subtitleFontSize,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ],
    );
  }

  // ============================================================
  // BUILD APP BAR
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      surfaceTintColor: Colors.transparent,

      elevation: elevation,
      scrolledUnderElevation: 0,

      toolbarHeight: height,

      automaticallyImplyLeading: false,
      centerTitle: centerTitle,
      titleSpacing: 0,

      leading: leading ??
          (showBackButton
              ? _buildBackButton(context)
              : null),

      title: _buildTitle(),

      actions: actions,

      iconTheme: IconThemeData(
        color: iconColor,
        size: 24,
      ),

      bottom: bottomWidget != null
          ? PreferredSize(
              preferredSize: Size.fromHeight(
                bottomHeight,
              ),
              child: SizedBox(
                height: bottomHeight,
                child: bottomWidget,
              ),
            )
          : null,
    );
  }
}
