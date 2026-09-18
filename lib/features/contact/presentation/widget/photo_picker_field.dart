import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_text_styles.dart';
import '../../../../../core/constants/app_sizes.dart';

/// Lets the user attach photos to a ticket — either multiple images
/// picked from the gallery, or a single live photo from the camera.
class PhotoPickerField extends StatelessWidget {
  const PhotoPickerField({
    super.key,
    required this.photos,
    required this.onPickFromGallery,
    required this.onPickFromCamera,
    required this.onRemove,
  });

  final List<XFile> photos;
  final VoidCallback onPickFromGallery;
  final VoidCallback onPickFromCamera;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Photo', style: AppTextStyles.label),
        SizedBox(height: AppSizes.spacingSmall_8),
        Row(
          children: [
            _PickerButton(
              icon: Icons.photo_library_outlined,
              label: 'Gallery',
              onTap: onPickFromGallery,
            ),
            SizedBox(width: AppSizes.spacingSmall_8),
            _PickerButton(
              icon: Icons.camera_alt_outlined,
              label: 'Camera',
              onTap: onPickFromCamera,
            ),
          ],
        ),
        if (photos.isNotEmpty) ...[
          SizedBox(height: AppSizes.spacingMedium_12),
          SizedBox(
            height: AppSizes.productImageSize_64,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: photos.length,
              separatorBuilder: (_, __) =>
                  SizedBox(width: AppSizes.spacingSmall_8),
              itemBuilder: (context, index) {
                final photo = photos[index];
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(AppSizes.radiusMedium_10),
                      child: Image.file(
                        File(photo.path),
                        width: AppSizes.productImageSize_64,
                        height: AppSizes.productImageSize_64,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: -6,
                      right: -6,
                      child: GestureDetector(
                        onTap: () => onRemove(index),
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: AppColors.error,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 14,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}

class _PickerButton extends StatelessWidget {
  const _PickerButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: AppSizes.iconSmall_18),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.border),
          padding: EdgeInsets.symmetric(vertical: AppSizes.spacingMedium_12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium_10),
          ),
        ),
      ),
    );
  }
}
