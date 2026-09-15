
import '../../model/product_models.dart';
import 'demo_product_content.dart';

// ==============================================================================
// PRODUCT REPOSITORY
// ------------------------------------------------------------------------------
// Single source of truth for the product catalogue, used by:
//   - ProductListPage         (the grid of all products)
//   - ProductDetailPage       (looks up the tapped product + its "related"
//                              items, no matter how many detail pages are
//                              already stacked on top of each other)
//   - TrendingWidget/SectionCardWidget on the details page ("You may also
//     like" is now just the existing Trending rail, reused as-is)
//
// This is what fixes the "You may also like disappears after a couple of
// taps" bug: before, each page had to be handed a `relatedProducts` list by
// whoever navigated to it, and one navigation path (tapping *inside* the
// related rail) forgot to pass it along. Now every page just asks this
// repository for "related products for X" itself - nothing to forget, no
// matter how deep the navigation stack gets.
// ==============================================================================

class ProductRepository {
  ProductRepository._();

  // ===========================================================================
  // MASTER PRODUCT LIST
  // ===========================================================================

  static final List<ProductItem> allProducts = [
    ProductItem(
      id: 'lalbaba-superior-banskathi',
      name: 'Lalbaba Superior Banskathi',
      imageUrl:
          'https://lalbabaonline.com/public/uploads/all/oAHc705alFhNrcljUs2QjIaemF95khJs5nisUpma.webp',
      rating: 5,
      reviewCount: 12,
      deliveryDays: 3,
      processedAt: genericProcessedAt,
      description: genericDescription('Lalbaba Superior Banskathi'),
      specifications: genericSpecifications('Banskathi Rice'),
      reviews: genericReviews,
      faqs: genericFaqs('Lalbaba Superior Banskathi'),
      variants: const [
        ProductVariant(weight: '1 Kg', price: 139),
        ProductVariant(weight: '5 Kg', price: 669),
        ProductVariant(weight: '10 Kg', price: 1329),
      ],
    ),

    ProductItem(
      id: 'lalbaba-gobindo-bhog',
      name: 'Lalbaba Gobindo Bhog',
      imageUrl:
          'https://lalbabaonline.com/public/uploads/all/BKEcfif3FQ8gsCt9q8Z93emvxfe0b33WSMoWs5oB.webp',
      rating: 4.5,
      reviewCount: 8,
      deliveryDays: 7,
      processedAt: genericProcessedAt,
      description: genericDescription('Lalbaba Gobindo Bhog'),
      specifications: genericSpecifications('Gobindo Bhog Rice'),
      reviews: genericReviews,
      faqs: genericFaqs('Lalbaba Gobindo Bhog'),
      variants: const [
        ProductVariant(weight: '1 Kg', price: 269),
        ProductVariant(weight: '5 Kg', price: 1299),
        ProductVariant(weight: '10 Kg', price: 2499),
      ],
    ),

    // ---- Real product photos + confirmed pricing (1kg=119, 5kg=569, 10kg=1129) ----
    ProductItem(
      id: 'lalbaba-exclusive-basmati',
      name: 'Lalbaba Exclusive Basmati',
      images: const [
        'https://lalbabaonline.com/public/uploads/all/et6fkpcUKLyLsa8nJq2UB9vEOXvkQQZxEruDttXG.jpg',
        'https://lalbabaonline.com/public/uploads/all/NPtGnXcJxtAjsIg7NqHVy2cfLAxPSicBr9jKAQ8C.jpg',
      ],
      rating: 5,
      reviewCount: 20,
      deliveryDays: 4,
      processedAt: genericProcessedAt,
      description: genericDescription('Lalbaba Exclusive Basmati'),
      specifications: genericSpecifications('Basmati Rice'),
      reviews: genericReviews,
      faqs: genericFaqs('Lalbaba Exclusive Basmati'),
      variants: const [
        ProductVariant(weight: '1 Kg', price: 119),
        ProductVariant(weight: '5 Kg', price: 569),
        ProductVariant(weight: '10 Kg', price: 1129),
      ],
    ),

    // ---- Real product photos (front/back) + confirmed pricing (1kg=199, 5kg=949, 10kg=1849) ----
    ProductItem(
      id: 'lalbaba-traditional-basmati',
      name: 'Lalbaba Traditional Basmati Rice',
      images: const [
        'https://lalbabaonline.com/public/uploads/all/jfCxsG3mPdSQSo4clKBd2dFNqTFr4af2fEZx2wkW.webp',
        'https://lalbabaonline.com/public/uploads/all/vYvpIa9eTwPlc66jf5h5Me7xAEiDEyavBxjGnO5v.webp',
        'https://lalbabaonline.com/public/uploads/all/jfCxsG3mPdSQSo4clKBd2dFNqTFr4af2fEZx2wkW.webp',
        'https://lalbabaonline.com/public/uploads/all/vYvpIa9eTwPlc66jf5h5Me7xAEiDEyavBxjGnO5v.webp',
      ],
      rating: 4.5,
      reviewCount: 15,
      deliveryDays: 5,
      processedAt: genericProcessedAt,
      description: genericDescription('Lalbaba Traditional Basmati Rice'),
      specifications: genericSpecifications('Basmati Rice'),
      reviews: genericReviews,
      faqs: genericFaqs('Lalbaba Traditional Basmati Rice'),
      variants: const [
        ProductVariant(weight: '1 Kg', price: 199),
        ProductVariant(weight: '5 Kg', price: 949),
        ProductVariant(weight: '10 Kg', price: 1849),
      ],
    ),

    ProductItem(
      id: 'lalbaba-ratna-rice',
      name: 'Lalbaba Ratna Rice',
      imageUrl:
          'https://lalbabaonline.com/public/uploads/all/jfCxsG3mPdSQSo4clKBd2dFNqTFr4af2fEZx2wkW.webp',
      rating: 4.5,
      reviewCount: 10,
      deliveryDays: 4,
      processedAt: genericProcessedAt,
      description: genericDescription('Lalbaba Ratna Rice'),
      specifications: genericSpecifications('Ratna Rice'),
      reviews: genericReviews,
      faqs: genericFaqs('Lalbaba Ratna Rice'),
      variants: const [
        ProductVariant(weight: '1 Kg', price: 129),
        ProductVariant(weight: '5 Kg', price: 619),
        ProductVariant(weight: '10 Kg', price: 1219),
      ],
    ),

    // ---- Real product photo added + confirmed pricing (1kg=159, 5kg=759, 10kg=1499) ----
    ProductItem(
      id: 'lalbaba-jeera-kathi',
      name: 'Lalbaba Jeera Kathi',
      images: const [
        'https://lalbabaonline.com/public/uploads/all/T2Abcc1fAfCuKLk4C8brHaK3qhdFIQA9yHZJy4xl.webp',
        'https://lalbabaonline.com/public/uploads/all/eiUutmmfaiSGvSWQ2y62Bym3O6SV0lv95cNeDW2x.jpg',
      ],
      rating: 4.5,
      reviewCount: jeeraKathiReviews.length,
      deliveryDays: 6,
      processedAt: jeeraKathiProcessedAt,
      shortTagline: 'JEERA KATHI',
      description: jeeraKathiDescription,
      specifications: jeeraKathiSpecifications,
      reviews: jeeraKathiReviews,
      faqs: jeeraKathiFaqs,
      variants: const [
        ProductVariant(weight: '1 Kg', price: 159),
        ProductVariant(weight: '5 Kg', price: 759),
        ProductVariant(weight: '10 Kg', price: 1499),
      ],
    ),

    ProductItem(
      id: 'lalbaba-premium-rice',
      name: 'Lalbaba Premium Rice',
      imageUrl:
          'https://lalbabaonline.com/public/uploads/all/wSzQEEq643gTAaVxi2KbaCLIBBevZDP5qgzTW8Nc.webp',
      rating: 4.5,
      reviewCount: 9,
      deliveryDays: 4,
      processedAt: genericProcessedAt,
      description: genericDescription('Lalbaba Premium Rice'),
      specifications: genericSpecifications('Premium Rice'),
      reviews: genericReviews,
      faqs: genericFaqs('Lalbaba Premium Rice'),
      variants: const [
        ProductVariant(weight: '1 Kg', price: 149),
        ProductVariant(weight: '5 Kg', price: 699),
        ProductVariant(weight: '10 Kg', price: 1379),
      ],
    ),

    ProductItem(
      id: 'lalbaba-special-rice',
      name: 'Lalbaba Special Rice',
      imageUrl:
          'https://lalbabaonline.com/public/uploads/all/w1HSz6wWKrkS08AysfcGQ3l8uoBh6kRaK5k0PBhS.jpg',
      rating: 4.5,
      reviewCount: 11,
      deliveryDays: 5,
      processedAt: genericProcessedAt,
      description: genericDescription('Lalbaba Special Rice'),
      specifications: genericSpecifications('Special Rice'),
      reviews: genericReviews,
      faqs: genericFaqs('Lalbaba Special Rice'),
      variants: const [
        ProductVariant(weight: '1 Kg', price: 169),
        ProductVariant(weight: '5 Kg', price: 799),
        ProductVariant(weight: '10 Kg', price: 1549),
      ],
    ),
  ];

  // ===========================================================================
  // LOOKUP BY ID
  // ===========================================================================

  static ProductItem? findById(String? id) {
    if (id == null) return null;

    for (final product in allProducts) {
      if (product.id == id) return product;
    }
    return null;
  }

  // ===========================================================================
  // RELATED PRODUCTS ("Trending this week" rail reused as "You may also like")
  // ===========================================================================

  static List<ProductItem> relatedTo(ProductItem product, {int limit = 6}) {
    return allProducts.where((p) => p.id != product.id).take(limit).toList();
  }

  // ===========================================================================
  // MAP CONVERSION
  // ------------------------------------------------------------------------------
  // TrendingWidget / SectionCardWidget / ProductCardWidget (the home-page
  // widgets) work with `Map<String, dynamic>` products, not the `ProductItem`
  // model used by the list & details pages. These converters bridge the two
  // so the exact same widgets can be reused unmodified on the details page.
  // ===========================================================================

  static Map<String, dynamic> toCardMap(ProductItem product) {
    final ProductVariant variant = product.variants[product.selectedVariant];

    return {
      'id': product.id,
      'name': product.name,
      'imageUrl': product.imageUrl,
      'price': '₹${variant.price.toStringAsFixed(2)}',
      'originalPrice': '',
      'discountLabel': '',
      'rating': product.rating,
    };
  }

  static List<Map<String, dynamic>> toCardMaps(List<ProductItem> products) {
    return products.map(toCardMap).toList();
  }
}
