import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';



// ==============================================================================
// DESCRIPTION TAB
// ==============================================================================

class DescriptionTab extends StatelessWidget {
  final String description;

  const DescriptionTab({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    if (description.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(14),
        child: Text('No description available for this product yet.'),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(14),
      child: Text(
        description,
        style: const TextStyle(
          fontSize: 13,
          height: 1.5,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
