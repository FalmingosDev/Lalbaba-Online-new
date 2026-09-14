import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/cart_service.dart';
import 'product_models.dart';


// ==============================================================================
// TAB ENUM
// ==============================================================================

enum ProductDetailTab { description, additionalInfo, reviews }

// ==============================================================================
// STATE
// ==============================================================================

@immutable
class ProductDetailState {
  final bool isLoading;
  final int selectedImageIndex;
  final int selectedVariantIndex;
  final int quantity;
  final ProductDetailTab activeTab;
  final int? expandedFaqIndex;
  final String pincode;
  final bool isCheckingPincode;
  final String? pincodeMessage;
  final bool pincodeServiceable;
  final bool isAddingToCart;

  const ProductDetailState({
    this.isLoading = true,
    this.selectedImageIndex = 0,
    this.selectedVariantIndex = 0,
    this.quantity = 1,
    this.activeTab = ProductDetailTab.description,
    this.expandedFaqIndex,
    this.pincode = '',
    this.isCheckingPincode = false,
    this.pincodeMessage,
    this.pincodeServiceable = false,
    this.isAddingToCart = false,
  });

  ProductDetailState copyWith({
    bool? isLoading,
    int? selectedImageIndex,
    int? selectedVariantIndex,
    int? quantity,
    ProductDetailTab? activeTab,
    int? expandedFaqIndex,
    bool clearExpandedFaq = false,
    String? pincode,
    bool? isCheckingPincode,
    String? pincodeMessage,
    bool clearPincodeMessage = false,
    bool? pincodeServiceable,
    bool? isAddingToCart,
  }) {
    return ProductDetailState(
      isLoading: isLoading ?? this.isLoading,
      selectedImageIndex: selectedImageIndex ?? this.selectedImageIndex,
      selectedVariantIndex:
          selectedVariantIndex ?? this.selectedVariantIndex,
      quantity: quantity ?? this.quantity,
      activeTab: activeTab ?? this.activeTab,
      expandedFaqIndex: clearExpandedFaq
          ? null
          : (expandedFaqIndex ?? this.expandedFaqIndex),
      pincode: pincode ?? this.pincode,
      isCheckingPincode: isCheckingPincode ?? this.isCheckingPincode,
      pincodeMessage:
          clearPincodeMessage ? null : (pincodeMessage ?? this.pincodeMessage),
      pincodeServiceable: pincodeServiceable ?? this.pincodeServiceable,
      isAddingToCart: isAddingToCart ?? this.isAddingToCart,
    );
  }
}

// ==============================================================================
// CONTROLLER
// ==============================================================================

class ProductDetailController extends StateNotifier<ProductDetailState> {
  final ProductItem product;

  ProductDetailController(this.product) : super(const ProductDetailState()) {
    _load();
  }

  // ---------------------------------------------------------------------------
  // INITIAL "LOAD"
  // ---------------------------------------------------------------------------
  //
  // Same 800ms shimmer-then-content pattern used on the product list page.
  // Replace this with a real product-detail API call later; just resolve
  // `state = state.copyWith(isLoading: false)` once the data has arrived.
  // ---------------------------------------------------------------------------
  Future<void> _load() async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    state = state.copyWith(isLoading: false);
  }

  // ---------------------------------------------------------------------------
  // IMAGE GALLERY
  // ---------------------------------------------------------------------------
  void selectImage(int index) {
    state = state.copyWith(selectedImageIndex: index);
  }

  // ---------------------------------------------------------------------------
  // VARIANT / WEIGHT
  // ---------------------------------------------------------------------------
  void selectVariant(int index) {
    state = state.copyWith(selectedVariantIndex: index, quantity: 1);
  }

  // ---------------------------------------------------------------------------
  // QUANTITY (No. of Bags)
  // ---------------------------------------------------------------------------
  void incrementQuantity() {
    state = state.copyWith(quantity: state.quantity + 1);
  }

  void decrementQuantity() {
    if (state.quantity <= 1) return;
    state = state.copyWith(quantity: state.quantity - 1);
  }

  // ---------------------------------------------------------------------------
  // TABS (Description / Additional information / Customer Reviews)
  // ---------------------------------------------------------------------------
  void setTab(ProductDetailTab tab) {
    state = state.copyWith(activeTab: tab);
  }

  // ---------------------------------------------------------------------------
  // FAQ ACCORDION - single item open at a time, same as the screenshots
  // ---------------------------------------------------------------------------
  void toggleFaq(int index) {
    if (state.expandedFaqIndex == index) {
      state = state.copyWith(clearExpandedFaq: true);
    } else {
      state = state.copyWith(expandedFaqIndex: index);
    }
  }

  // ---------------------------------------------------------------------------
  // DELIVERY PINCODE CHECK
  // ---------------------------------------------------------------------------
  void setPincode(String value) {
    state = state.copyWith(pincode: value, clearPincodeMessage: true);
  }

  Future<void> checkPincode() async {
    if (state.pincode.trim().length != 6) {
      state = state.copyWith(
        pincodeMessage: 'Enter a valid 6-digit pincode',
        pincodeServiceable: false,
      );
      return;
    }

    state = state.copyWith(isCheckingPincode: true, clearPincodeMessage: true);

    // TODO: replace with a real delivery-serviceability API call.
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;

    state = state.copyWith(
      isCheckingPincode: false,
      pincodeServiceable: true,
      pincodeMessage: 'Delivery available at this pincode',
    );
  }

  // ---------------------------------------------------------------------------
  // ADD TO CART
  // ---------------------------------------------------------------------------
  Future<void> addToCart() async {
    state = state.copyWith(isAddingToCart: true);

    await CartService.postAddToCart(
      productId: product.id,
      quantity: state.quantity,
    );

    if (!mounted) return;
    state = state.copyWith(isAddingToCart: false, quantity: 1);
  }
}

// ==============================================================================
// PROVIDER
// ==============================================================================
//
// Keyed by the ProductItem instance itself (family). Since the same instance
// is passed down from the list page -> detail page, identity equality is
// enough here and keeps things simple without needing Equatable/freezed on
// ProductItem.
// ==============================================================================

final productDetailControllerProvider = StateNotifierProvider.family<
    ProductDetailController, ProductDetailState, ProductItem>(
  (ref, product) => ProductDetailController(product),
);
