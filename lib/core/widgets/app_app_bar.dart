import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_fonts.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool centerTitle;
  final bool automaticallyImplyLeading;

  const AppAppBar({
    super.key,
    required this.title,
    this.actions,
    this.centerTitle = true,
    this.automaticallyImplyLeading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AppBar(
        backgroundColor: AppColors.primary,
        automaticallyImplyLeading: false,
        leading: automaticallyImplyLeading
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                color: AppColors.primaryLight,
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.primaryLight,
            fontSize: 19,
            fontWeight: FontWeight.w700,
            height: 1.1,
            letterSpacing: 0.2,
            fontFamily: AppFonts.primary,
          ),
        ),
        centerTitle: centerTitle,
        // automaticallyImplyLeading: automaticallyImplyLeading,
        actions: actions,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
