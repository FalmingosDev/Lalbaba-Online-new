import 'package:flutter/material.dart';

import '../../features/product/presentation/model/product_models.dart';

class WishlistService {
  WishlistService._();

  // ===========================================================================
  // GLOBAL WISHLIST
  // ===========================================================================

  static final ValueNotifier<List<ProductItem>>
      productsNotifier =
      ValueNotifier<List<ProductItem>>(
    <ProductItem>[],
  );

  // ===========================================================================
  // PRODUCTS
  // ===========================================================================

  static List<ProductItem> get products =>
      List<ProductItem>.unmodifiable(
        productsNotifier.value,
      );

  // ===========================================================================
  // UNIQUE PRODUCT KEY
  // ===========================================================================

  static String _productKey(
    ProductItem product,
  ) {
    final String? id =
        product.id?.toString().trim();

    if (id != null && id.isNotEmpty) {
      return 'id:$id';
    }

    return '${product.name.trim().toLowerCase()}'
        '|${product.imageUrl.trim()}';
  }

  // ===========================================================================
  // CHECK WISHLIST
  // ===========================================================================

  static bool contains(
    ProductItem product,
  ) {
    final String key =
        _productKey(product);

    return productsNotifier.value.any(
      (item) =>
          _productKey(item) == key,
    );
  }

  // ===========================================================================
  // ADD
  // ===========================================================================

  static void add(
    ProductItem product,
  ) {
    if (contains(product)) {
      return;
    }

    productsNotifier.value = [
      ...productsNotifier.value,
      product,
    ];
  }

  // ===========================================================================
  // REMOVE
  // ===========================================================================

  static void remove(
    ProductItem product,
  ) {
    final String key =
        _productKey(product);

    productsNotifier.value =
        productsNotifier.value
            .where(
              (item) =>
                  _productKey(item) !=
                  key,
            )
            .toList();
  }

  // ===========================================================================
  // TOGGLE
  // ===========================================================================

  static bool toggle(
    ProductItem product,
  ) {
    if (contains(product)) {
      remove(product);

      return false;
    }

    add(product);

    return true;
  }

  // ===========================================================================
  // CLEAR
  // ===========================================================================

  static void clear() {
    productsNotifier.value =
        <ProductItem>[];
  }
}