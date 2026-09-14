import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/app_app_bar.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../model/product_detail_provider.dart';
import '../model/product_models.dart';
import '../widgets/product_details_widget/additional_info_tab.dart';
import '../widgets/product_details_widget/contact_support_widget.dart';
import '../widgets/product_details_widget/customer_reviews_tab.dart';
import '../widgets/product_details_widget/delivery_pincode_widget.dart';
import '../widgets/product_details_widget/description_tab.dart';
import '../widgets/product_details_widget/faq_section_widget.dart';
import '../widgets/product_details_widget/product_image_gallery.dart';
import '../widgets/product_details_widget/product_tabs_section.dart';
import '../widgets/product_details_widget/product_title_section.dart';
import '../widgets/product_details_widget/qty_actions_widget.dart';
import '../widgets/product_details_widget/related_products_widget.dart';
import '../widgets/product_details_widget/weight_selector_widget.dart';

// ==============================================================================
// PRODUCT DETAIL PAGE
// ==============================================================================
//
// Riverpod-driven product details screen:
//   - image gallery (main image + thumbnails)
//   - title / processed-at / rating
//   - weight selector
//   - qty stepper + Add to Cart / Buy Now
//   - delivery pincode check
//   - Description / Additional information / Customer Reviews tabs
//     (content scrolls with the page - tapping a tab just swaps which
//     section is shown)
//   - FAQ accordion
//   - "You May Also like" related products
//   - contact / support footer
//
// All interactive state (selected image, selected weight, quantity, active
// tab, expanded FAQ, pincode) lives in `ProductDetailController` via
// `productDetailControllerProvider`, keyed by the ProductItem itself.
// ==============================================================================

class ProductDetailPage extends ConsumerStatefulWidget {
  final ProductItem product;
  final List<ProductItem> relatedProducts;

  const ProductDetailPage({
    super.key,
    required this.product,
    this.relatedProducts = const [],
  });

  @override
  ConsumerState<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends ConsumerState<ProductDetailPage> {
  @override
  Widget build(BuildContext context) {
    final ProductDetailState state =
        ref.watch(productDetailControllerProvider(widget.product));

    final ProductDetailController controller = ref.read(
      productDetailControllerProvider(widget.product).notifier,
    );

    final variant = widget.product.variants[state.selectedVariantIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(
        title: widget.product.name,
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: state.isLoading
          ? const _ProductDetailShimmer()
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: AppColors.surface,
                    child: ProductImageGallery(
                      images: widget.product.images,
                      selectedIndex: state.selectedImageIndex,
                      onThumbnailTap: controller.selectImage,
                    ),
                  ),

                  Container(
                    color: AppColors.surface,
                    child: ProductTitleSection(
                      name: widget.product.name,
                      processedAt: widget.product.processedAt,
                      tagline: widget.product.shortTagline,
                      rating: widget.product.rating,
                      reviewCount: widget.product.reviewCount,
                    ),
                  ),

                  Container(
                    color: AppColors.surface,
                    child: WeightSelectorWidget(
                      variants: widget.product.variants,
                      selectedIndex: state.selectedVariantIndex,
                      onSelected: controller.selectVariant,
                    ),
                  ),

                  Container(
                    color: AppColors.surface,
                    child: QtyActionsWidget(
                      quantity: state.quantity,
                      onIncrement: controller.incrementQuantity,
                      onDecrement: controller.decrementQuantity,
                      isAddingToCart: state.isAddingToCart,
                      onAddToCart: () async {
                        await controller.addToCart();
                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              content: Text(
                                '${widget.product.name} (${variant.weight}) added to cart',
                              ),
                              duration: const Duration(milliseconds: 900),
                            ),
                          );
                      },
                      onBuyNow: () async {
                        await controller.addToCart();
                        if (!context.mounted) return;

                        // TODO: navigate to the checkout page once it exists.
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            const SnackBar(
                              content: Text('Proceeding to checkout...'),
                              duration: Duration(milliseconds: 900),
                            ),
                          );
                      },
                    ),
                  ),

                  Container(
                    color: AppColors.surface,
                    padding: const EdgeInsets.only(bottom: 8),
                    child: DeliveryPincodeWidget(
                      pincode: state.pincode,
                      isChecking: state.isCheckingPincode,
                      message: state.pincodeMessage,
                      isServiceable: state.pincodeServiceable,
                      onChanged: controller.setPincode,
                      onApply: controller.checkPincode,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Container(
                    color: AppColors.surface,
                    child: ProductTabsBar(
                      activeTab: state.activeTab,
                      onTabSelected: controller.setTab,
                    ),
                  ),

                  Container(
                    color: AppColors.surface,
                    child: _buildTabContent(state.activeTab),
                  ),

                  FaqSectionWidget(
                    faqs: widget.product.faqs,
                    expandedIndex: state.expandedFaqIndex,
                    onToggle: controller.toggleFaq,
                  ),

                  RelatedProductsWidget(products: widget.relatedProducts),

                  const SizedBox(height: 8),

                  const ContactSupportWidget(),
                ],
              ),
            ),
    );
  }

  Widget _buildTabContent(ProductDetailTab tab) {
    switch (tab) {
      case ProductDetailTab.description:
        return DescriptionTab(description: widget.product.description);
      case ProductDetailTab.additionalInfo:
        return AdditionalInfoTab(
          specifications: widget.product.specifications,
        );
      case ProductDetailTab.reviews:
        return CustomerReviewsTab(reviews: widget.product.reviews);
    }
  }
}

// ==============================================================================
// SHIMMER PLACEHOLDER WHILE THE PRODUCT DETAIL IS "LOADING"
// Reuses the AppShimmer widget you already have for the list page.
// ==============================================================================

class _ProductDetailShimmer extends StatelessWidget {
  const _ProductDetailShimmer();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(14),
      children: const [
        AppShimmer(height: 260, radius: 8),
        SizedBox(height: 14),
        AppShimmer(width: 220, height: 18),
        SizedBox(height: 8),
        AppShimmer(width: 140, height: 14),
        SizedBox(height: 18),
        AppShimmer(width: 100, height: 14),
        SizedBox(height: 8),
        Row(
          children: [
            AppShimmer(width: 70, height: 36),
            SizedBox(width: 10),
            AppShimmer(width: 70, height: 36),
          ],
        ),
        SizedBox(height: 20),
        AppShimmer(height: 44),
        SizedBox(height: 20),
        AppShimmer(height: 44),
        SizedBox(height: 20),
        AppShimmer(height: 200, radius: 8),
      ],
    );
  }
}
