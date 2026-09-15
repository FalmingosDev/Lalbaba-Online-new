import 'package:flutter/material.dart';

// ==============================================================================
// FULLSCREEN PRODUCT IMAGE ZOOM VIEWER
// ------------------------------------------------------------------------------
// Opened by tapping the main product image on the details page. Lets the
// user swipe between every photo of the product (front / back / all angles)
// and pinch-to-zoom in on each one - e.g. to read the fine print on the
// rice packet.
// ==============================================================================

Future<void> showProductImageZoomViewer(
  BuildContext context, {
  required List<String> images,
  required int initialIndex,
}) {
  return Navigator.of(context).push(
    PageRouteBuilder(
      opaque: false,
      barrierColor: Colors.black,
      pageBuilder: (context, animation, secondaryAnimation) {
        return FadeTransition(
          opacity: animation,
          child: _ProductImageZoomPage(
            images: images,
            initialIndex: initialIndex,
          ),
        );
      },
    ),
  );
}

class _ProductImageZoomPage extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const _ProductImageZoomPage({
    required this.images,
    required this.initialIndex,
  });

  @override
  State<_ProductImageZoomPage> createState() => _ProductImageZoomPageState();
}

class _ProductImageZoomPageState extends State<_ProductImageZoomPage> {
  late final PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // ---------------------------------------------------------------
            // SWIPE BETWEEN IMAGES, PINCH TO ZOOM EACH ONE
            // ---------------------------------------------------------------
            PageView.builder(
              controller: _pageController,
              itemCount: widget.images.length,
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
              },
              itemBuilder: (context, index) {
                final String url = widget.images[index];

                return InteractiveViewer(
                  minScale: 1,
                  maxScale: 5,
                  boundaryMargin: const EdgeInsets.all(80),
                  child: Center(
                    child: url.isEmpty
                        ? const Icon(
                            Icons.image_not_supported,
                            color: Colors.white54,
                            size: 48,
                          )
                        : Image.network(
                            url,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.broken_image,
                                color: Colors.white54,
                                size: 48,
                              );
                            },
                          ),
                  ),
                );
              },
            ),

            // ---------------------------------------------------------------
            // CLOSE BUTTON
            // ---------------------------------------------------------------
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close, color: Colors.white, size: 28),
              ),
            ),

            // ---------------------------------------------------------------
            // IMAGE COUNTER (only when there's more than one photo)
            // ---------------------------------------------------------------
            if (widget.images.length > 1)
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_currentIndex + 1} / ${widget.images.length}',
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
                ),
              ),

            // ---------------------------------------------------------------
            // HINT
            // ---------------------------------------------------------------
            Positioned(
              bottom: widget.images.length > 1 ? 54 : 20,
              left: 0,
              right: 0,
              child: const Center(
                child: Text(
                  'Pinch to zoom',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
