import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../core/widgets/app_shimmer.dart';


// ==============================================================================
// PRODUCT IMAGE GALLERY
// ------------------------------------------------------------------------------
// Shows a large main (network) image with a strip of tappable thumbnails for
// the remaining images.
//
// Layout auto-switches:
//   - wide screens / tablets -> thumbnails as a VERTICAL strip on the side
//   - regular phones         -> thumbnails as a HORIZONTAL strip underneath
//
// If the product only has one image, the thumbnail strip is hidden entirely
// and just the main image is shown - so this widget is a drop-in upgrade for
// products that don't have multiple images yet.
// ==============================================================================

class ProductImageGallery extends StatelessWidget {
  final List<String> images;
  final int selectedIndex;
  final ValueChanged<int> onThumbnailTap;

  const ProductImageGallery({
    super.key,
    required this.images,
    required this.selectedIndex,
    required this.onThumbnailTap,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> safeImages = images.isEmpty ? [''] : images;
    final int safeIndex = selectedIndex.clamp(0, safeImages.length - 1);

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool wideLayout = constraints.maxWidth >= 420;

        final Widget mainImage = _MainImage(url: safeImages[safeIndex]);

        if (safeImages.length <= 1) {
          return mainImage;
        }

        if (wideLayout) {
          return SizedBox(
            height: 300,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ThumbnailStrip(
                  images: safeImages,
                  selectedIndex: safeIndex,
                  onTap: onThumbnailTap,
                  direction: Axis.vertical,
                ),
                const SizedBox(width: 8),
                Expanded(child: mainImage),
              ],
            ),
          );
        }

        return Column(
          children: [
            mainImage,
            const SizedBox(height: 8),
            _ThumbnailStrip(
              images: safeImages,
              selectedIndex: safeIndex,
              onTap: onThumbnailTap,
              direction: Axis.horizontal,
            ),
          ],
        );
      },
    );
  }
}

// ==============================================================================
// MAIN IMAGE
// ==============================================================================

class _MainImage extends StatelessWidget {
  final String url;

  const _MainImage({required this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      width: double.infinity,
      color: AppColors.surface,
      child: url.isEmpty
          ? const Center(
              child: Icon(
                Icons.image_not_supported,
                color: AppColors.grey,
              ),
            )
          : Image.network(
              url,
              fit: BoxFit.contain,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;

                return const AppShimmer(
                  width: double.infinity,
                  height: 280,
                  radius: 0,
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(Icons.broken_image, color: AppColors.grey),
                );
              },
            ),
    );
  }
}

// ==============================================================================
// THUMBNAIL STRIP
// ==============================================================================

class _ThumbnailStrip extends StatelessWidget {
  final List<String> images;
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final Axis direction;

  const _ThumbnailStrip({
    required this.images,
    required this.selectedIndex,
    required this.onTap,
    required this.direction,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> thumbnails = List.generate(images.length, (index) {
      final bool selected = index == selectedIndex;

      return GestureDetector(
        onTap: () => onTap(index),
        child: Container(
          margin: EdgeInsets.only(
            right: direction == Axis.horizontal ? 8 : 0,
            bottom: direction == Axis.vertical ? 8 : 0,
          ),
          width: 56,
          height: 56,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.border,
              width: selected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: images[index].isEmpty
              ? const Icon(Icons.image, size: 20, color: AppColors.grey)
              : Image.network(images[index], fit: BoxFit.contain),
        ),
      );
    });

    if (direction == Axis.horizontal) {
      return SizedBox(
        height: 64,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          children: thumbnails,
        ),
      );
    }

    return SizedBox(
      width: 64,
      child: ListView(
        padding: const EdgeInsets.all(4),
        children: thumbnails,
      ),
    );
  }
}
