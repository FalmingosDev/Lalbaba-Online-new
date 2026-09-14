import 'package:flutter/foundation.dart';

// ==============================================================================
// PRODUCT VARIANT (weight + price)
// ==============================================================================

@immutable
class ProductVariant {
  final String weight;
  final double price;

  /// Optional strike-through price (MRP). Leave null if there's no discount.
  final double? mrp;

  const ProductVariant({
    required this.weight,
    required this.price,
    this.mrp,
  });
}

// ==============================================================================
// PRODUCT SPECIFICATION ROW ("Additional information" tab table)
// ==============================================================================

@immutable
class ProductSpecification {
  final String label;
  final String value;

  const ProductSpecification({
    required this.label,
    required this.value,
  });
}

// ==============================================================================
// CUSTOMER REVIEW
// ==============================================================================

@immutable
class ProductReview {
  final String name;
  final String date;
  final double rating;
  final String comment;

  const ProductReview({
    required this.name,
    required this.date,
    required this.rating,
    required this.comment,
  });
}

// ==============================================================================
// FAQ ITEM
// ==============================================================================

@immutable
class ProductFaq {
  final String question;
  final String answer;

  const ProductFaq({
    required this.question,
    required this.answer,
  });
}

// ==============================================================================
// PRODUCT ITEM
//
// This replaces the ProductItem class that used to live directly inside
// product_list_page.dart. All the *new* fields are optional / defaulted so
// nothing on the list page breaks - the details-page-only data (description,
// specifications, reviews, faqs, processedAt, multiple images) is simply
// empty until you attach it.
// ==============================================================================

class ProductItem {
  /// Future API-ready product ID. Nullable until the real API is wired up.
  final String? id;

  final String name;

  /// All gallery images for the product details page. When only a single
  /// legacy `imageUrl` is supplied, this list will just contain that one URL.
  final List<String> images;

  /// Kept for backward compatibility with the existing list-page widgets
  /// (ProductImageHeader, etc.) - always resolves to images.first.
  String get imageUrl => images.isNotEmpty ? images.first : '';

  final double rating;
  final int reviewCount;
  final int deliveryDays;
  final List<ProductVariant> variants;

  // ---- Detail-page-only fields (all optional / defaulted) ----
  final String processedAt;
  final String shortTagline;
  final String description;
  final List<ProductSpecification> specifications;
  final List<ProductReview> reviews;
  final List<ProductFaq> faqs;

  int selectedVariant;

  ProductItem({
    this.id,
    required this.name,
    String? imageUrl,
    List<String>? images,
    required this.rating,
    this.reviewCount = 0,
    required this.deliveryDays,
    required this.variants,
    this.processedAt = '',
    this.shortTagline = '',
    this.description = '',
    this.specifications = const [],
    this.reviews = const [],
    this.faqs = const [],
    this.selectedVariant = 0,
  }) : images = images ?? (imageUrl != null ? [imageUrl] : const []);
}
