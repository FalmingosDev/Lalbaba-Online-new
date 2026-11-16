import 'package:flutter/material.dart';

import 'new_constant_text_styles.dart';
import 'constantcolour.dart';

class BackToTopButton extends StatelessWidget {
  const BackToTopButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xE61B1B1B),
      elevation: 3,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Back to top',
                style: HomeTextStyles.bodySmall.copyWith(
                  color: HomeColors.white,
                  fontWeight: HomeTextStyles.semiBold,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_upward_rounded,
                color: HomeColors.white,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
