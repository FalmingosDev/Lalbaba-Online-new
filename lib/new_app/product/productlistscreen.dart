import 'package:flutter/material.dart';
import 'package:lalbaba_online/core/constants/asset_constants.dart';

import 'package:lalbaba_online/core/services/cart_service.dart';
import 'package:lalbaba_online/core/services/cart_notification_item.dart';
import 'package:lalbaba_online/core/services/wishlist_service.dart';

import 'package:lalbaba_online/features/product/presentation/model/product_models.dart';
import 'package:lalbaba_online/features/product/presentation/widgets/product_details_widget/product_repository.dart';

import 'package:lalbaba_online/new_app/constant/constantappbar.dart';
import 'package:lalbaba_online/new_app/constant/constantcolour.dart';
import 'package:lalbaba_online/new_app/constant/new_constant_text_styles.dart';
import 'package:lalbaba_online/new_app/dashboard/new_cart.dart';
import 'package:lalbaba_online/new_app/dashboard/new_wishlist.dart';
import 'package:lalbaba_online/new_app/constant/new_back_to_top_button.dart';
import 'new_product_details.dart';


// Shared pack data for Home and Product List. Demo prices are for development only.
// Replace these records with verified API/catalog prices before production.
class HomeProductPacks {
  HomeProductPacks._();

  static const Map<String, List<Map<String, dynamic>>> demoPacks = {
    'home-superior-minikit': [
      {'weight': '5 kg', 'price': 290.0, 'mrp': 320.0},
      {'weight': '10 kg', 'price': 550.0, 'mrp': 650.0},
      {'weight': '25 kg', 'price': 1089.0, 'mrp': 1299.0},
    ],
    'home-basmati-steam': [
      {'weight': '1 kg', 'price': 230.0, 'mrp': 270.0},
      {'weight': '5 kg', 'price': 1050.0, 'mrp': 1250.0},
      {'weight': '10 kg', 'price': 1990.0, 'mrp': 2400.0},
    ],
    'home-jeer-rice': [
      {'weight': '1 kg', 'price': 140.0, 'mrp': 160.0},
      {'weight': '5 kg', 'price': 650.0, 'mrp': 750.0},
      {'weight': '10 kg', 'price': 1250.0, 'mrp': 1450.0},
    ],
    'home-basmati': [
      {'weight': '1 kg', 'price': 230.0, 'mrp': 275.0},
      {'weight': '5 kg', 'price': 1050.0, 'mrp': 1280.0},
      {'weight': '10 kg', 'price': 2050.0, 'mrp': 2500.0},
    ],
    'home-ratna-basmati': [
      {'weight': '1 kg', 'price': 65.0, 'mrp': 80.0},
      {'weight': '5 kg', 'price': 300.0, 'mrp': 375.0},
      {'weight': '10 kg', 'price': 580.0, 'mrp': 725.0},
    ],
  };

  static String normalize(String value) => value.toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]'), '');

  static String _nameKey(String value) =>
      normalize(value).replaceFirst(RegExp(r'^lalbaba'), '');

  static String? _demoKey(Map<String, dynamic> product) {
    final id = product['id']?.toString();
    if (demoPacks.containsKey(id)) return id;
    switch (_nameKey(product['name']?.toString() ?? '')) {
      case 'superiorminikit':
      case 'minikit':
      case 'miniket':
      case 'superiorminiket':
        return 'home-superior-minikit';
      case 'basmatisteam': return 'home-basmati-steam';
      case 'jeerrice':
      case 'jeerarice': return 'home-jeer-rice';
      case 'basmati': return 'home-basmati';
      case 'ratnabasmati': return 'home-ratna-basmati';
    }
    return null;
  }

  static ProductItem? resolveModel(Map<String, dynamic> product) {
    final embedded = product['_model'];
    if (embedded is ProductItem) return embedded;
    final id = product['id']?.toString().trim() ?? '';
    final name = _nameKey(product['name']?.toString() ?? '');
    final image = product['imageUrl']?.toString() ?? '';
    final all = ProductRepository.allProducts;
    final byId = all.where((p) => id.isNotEmpty && p.id == id).toList();
    if (byId.length == 1) return byId.first;
    // Only fall back for a demo home ID or an item without a real ID.
    if (id.isNotEmpty && !id.startsWith('home-')) return null;
    final byName = all.where((p) => name.isNotEmpty && _nameKey(p.name) == name).toList();
    if (byName.length == 1) return byName.first;
    final group = _demoKey(product);
    if (group != null) {
      final byGroup = all.where((p) => _demoKey({'name': p.name}) == group).toList();
      if (byGroup.length == 1) return byGroup.first;
    }
    final byImage = all.where((p) => image.isNotEmpty && p.imageUrl == image).toList();
    if (byImage.length == 1) return byImage.first;
    return null;
  }

  static double? parsePrice(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse((value?.toString() ?? '').replaceAll(RegExp(r'[^0-9.]'), ''));
  }

  static String money(num value) => '₹${value.toStringAsFixed(2)}';

  static double? _kg(String weight) {
    final match = RegExp(r'^\s*(\d+(?:\.\d+)?)\s*(kg|g|gm|grams?)\s*$', caseSensitive: false).firstMatch(weight);
    if (match == null) return null;
    final number = double.tryParse(match.group(1)!);
    if (number == null || number <= 0) return null;
    return match.group(2)!.toLowerCase() == 'kg' ? number : number / 1000;
  }

  static String formatWeight(String weight) {
    final kg = _kg(weight);
    if (kg == null) return weight.trim();
    final number = kg == kg.roundToDouble() ? kg.toStringAsFixed(0) : kg.toString();
    return '$number kg';
  }

  // Keep up to three distinct existing variants; when there are fewer, add
  // demo weights (with proportional sample prices) for development only.
  static List<Map<String, dynamic>> _threePacks(
    Map<String, dynamic> raw, ProductItem? model, String preferred,
  ) {
    final group = _demoKey(raw) ?? (model == null ? null : _demoKey({'name': model.name}));
    if (group != null) {
      return demoPacks[group]!.map((v) => Map<String, dynamic>.from(v)).toList();
    }
    final result = <Map<String, dynamic>>[];
    void add(String weight, double? price, double? mrp) {
      weight = formatWeight(weight);
      if (_kg(weight) == null || price == null || !price.isFinite || price <= 0 ||
          result.any((v) => normalize(v['weight'].toString()) == normalize(weight))) return;
      result.add({'weight': weight, 'price': price, 'mrp': mrp});
    }
    final rawVariants = raw['variants'];
    if (rawVariants is List) {
      for (final v in rawVariants) {
        if (v is Map) add(v['weight']?.toString() ?? '', parsePrice(v['price']), parsePrice(v['mrp'] ?? v['originalPrice']));
      }
    }
    if (result.isEmpty && model != null) {
      for (final v in model.variants) {
        add(v.weight, v.price.toDouble(), v.mrp?.toDouble());
      }
    }
    if (result.isEmpty && preferred.isNotEmpty) {
      add(preferred, parsePrice(raw['price']), parsePrice(raw['originalPrice']));
    }
    // If the catalog supplies a price but no usable KG label, treat that
    // price as a sample 1 kg price for the development-only demo.
    if (result.isEmpty) {
      final modelBase = model != null && model.variants.isNotEmpty
          ? model.variants[model.selectedVariant.clamp(0, model.variants.length - 1).toInt()]
          : null;
      add('1 kg', parsePrice(raw['price']) ?? modelBase?.price.toDouble(),
          parsePrice(raw['originalPrice']) ?? modelBase?.mrp?.toDouble());
    }
    // A product without any valid price must remain unavailable.
    if (result.isEmpty) return result;
    final index = result.indexWhere((v) => normalize(v['weight'].toString()) == normalize(preferred));
    final base = result[index < 0 ? 0 : index];
    if (result.length > 3) {
      final chosen = result.take(3).toList();
      if (!chosen.contains(base)) chosen[2] = base;
      return chosen;
    }
    final baseKg = _kg(base['weight'].toString()) ?? 1.0;
    final basePrice = parsePrice(base['price'])!;
    final baseMrp = parsePrice(base['mrp']);
    for (final kg in [1, 5, 10, 25]) {
      if (result.length >= 3) break;
      final samplePrice = (basePrice / baseKg * kg * 100).round() / 100;
      final sampleMrp = baseMrp == null ? null : (baseMrp / baseKg * kg * 100).round() / 100;
      add('$kg kg', samplePrice, sampleMrp);
    }
    return result;
  }

  // Home gives a preferred weight; all three options travel with the same map.
  static Map<String, dynamic> prepare(Map<String, dynamic> raw) {
    final model = resolveModel(raw);
    final group = _demoKey(raw);
    final defaultWeight = model != null && model.variants.isNotEmpty
        ? model.variants[model.selectedVariant.clamp(0, model.variants.length - 1).toInt()].weight
        : '';
    final requested = formatWeight(raw['weight']?.toString().trim().isNotEmpty == true
        ? raw['weight'].toString() : defaultWeight);
    final packs = _threePacks(raw, model, requested);
    final id = model?.id ?? group ?? raw['id'];
    if (packs.isEmpty) return {...raw, 'id': id, 'variants': <Map<String, dynamic>>[], if (model != null) '_model': model};
    final pack = packs.firstWhere((v) => normalize(v['weight'].toString()) == normalize(requested), orElse: () => packs.first);
    final price = parsePrice(pack['price'])!;
    final mrp = parsePrice(pack['mrp']);
    return {
      ...raw,
      'id': id,
      if (model != null) '_model': model,
      'weight': pack['weight'],
      'price': money(price),
      'originalPrice': mrp == null ? '' : money(mrp),
      'discountLabel': mrp != null && mrp > price ? '${((mrp - price) / mrp * 100).round()}% OFF' : '',
      'rating': raw['rating'] ?? model?.rating ?? 0.0,
      'variants': packs,
    };
  }

  // Category labels are inferred from catalog product names until an API
  // supplies explicit category metadata. Match the more specific names first.
  static String categoryOf(Map<String, dynamic> product) {
    final model = resolveModel(product);
    final value = normalize(product['category']?.toString().trim().isNotEmpty == true
        ? product['category'].toString() : (model?.name ?? product['name']?.toString() ?? ''));
    if (value.contains('jeera') || value.contains('jeerrice') || value.contains('jirakati') || value.contains('jeerkathi')) return 'Jeera Kathi';
    if (value.contains('gobindo') || value.contains('govindo') || value.contains('gobinda') || value.contains('govinda')) return 'Gobindo Bhog';
    if (value.contains('ratna')) return 'Ratna';
    if (value.contains('banskathi') || value.contains('banskati') || value.contains('baskati') || value.contains('baskathi') || value.contains('banshkathi')) return 'Banskathi';
    if (value.contains('minikit') || value.contains('miniket')) return 'Minikit';
    if (value.contains('basmati') || value.contains('basmoti')) return 'Basmati';
    return product['category']?.toString().trim() ?? '';
  }

  // Include the existing Home demo products even if they are not yet linked
  // to a repository product. Do not invent missing varieties or inventory.
  static List<Map<String, dynamic>> catalog() {
    final result = ProductRepository.allProducts.map<Map<String, dynamic>>((p) => {
      '_model': p, 'id': p.id, 'name': p.name, 'imageUrl': p.imageUrl,
      'rating': p.rating,
    }).toList();
    final home = <Map<String, dynamic>>[
      {'id': 'home-superior-minikit', 'name': 'Lalbaba Superior Minikit', 'imageUrl': AssetConstants.miniket},
      {'id': 'home-basmati-steam', 'name': 'Lalbaba Basmati Steam', 'imageUrl': AssetConstants.basmoti},
      {'id': 'home-jeer-rice', 'name': 'Lalbaba Jeer Rice', 'imageUrl': AssetConstants.jeerrice},
      {'id': 'home-basmati', 'name': 'Lalbaba Basmati', 'imageUrl': AssetConstants.baskati},
      {'id': 'home-ratna-basmati', 'name': 'Ratna Basmati', 'imageUrl': AssetConstants.ratna},
    ];
    for (final raw in home) {
      final model = resolveModel(raw);
      final exists = result.any((p) => (model?.id != null && p['id'] == model!.id) ||
          identical(p['_model'], model) && model != null ||
          _demoKey(p) == raw['id']);
      if (!exists) result.add(raw);
    }
    return result.map(prepare).map((p) => {...p, 'category': categoryOf(p)}).toList();
  }

  static String cartKey(String? id, String name, String? weight) {
    final key = id?.trim() ?? '';
    return '${key.isEmpty ? normalize(name) : key}|${normalize(formatWeight(weight ?? ''))}';
  }

  static String productCartKey(Map<String, dynamic> product) => cartKey(
    product['id']?.toString(), product['name']?.toString() ?? '', product['weight']?.toString(),
  );
}

// =============================================================
// CONSTANT STYLE
// =============================================================

class ProductListStyle {
  ProductListStyle._();

  static const cardRadius = 12.0;
  static const cardHeight = 410.0;
}

// =============================================================
// PRODUCT LIST PAGE
// =============================================================

class ProductListPage extends StatefulWidget {
  final String? sectionType;
  final String? categoryFilter;
  final String pageTitle;
  final List<Map<String, dynamic>>? products;

  const ProductListPage({
    super.key,
    this.sectionType,
    this.categoryFilter,
    this.pageTitle = 'Products',
    this.products,
  });

  @override
  State<ProductListPage> createState() =>
      _ProductListPageState();
}

// BOTH CLASS NAMES SUPPORTED

class ProductListscreen extends ProductListPage {
  const ProductListscreen({
    super.key,
    super.sectionType,
    super.categoryFilter,
    super.pageTitle,
    super.products,
  });
}

class _ProductListPageState extends State<ProductListPage> {

  // ===========================================================
  // VARIABLES
  // ===========================================================

  final Map<String, String> _chosenWeights = {};
  final Map<String, int> _selectedQuantities = {};
  final Set<String> _busy = {};

  final ScrollController _scrollController =
      ScrollController();

  bool _showBackToTop = false;
  bool _cartReady = false;

  String? _cartError;

  static const double _backToTopThreshold = 350;

  Set<String> _selectedCategories = {};
  Set<String> _selectedWeights = {};

  RangeValues? _appliedRange;

  String _sort = 'Rating';

  // ===========================================================
  // INIT STATE
  // ===========================================================

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_handleScroll);

    CartService.items.addListener(_refresh);

    WishlistService.productsNotifier.addListener(
      _refresh,
    );

    _initializeCart();
  }

  // ===========================================================
  // INITIALIZE CART
  // ===========================================================

  Future<void> _initializeCart() async {
    try {
      await CartService.initialize();

      if (!mounted) return;

      setState(() {
        _cartReady = true;
        _cartError = null;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _cartError = error.toString();
      });
    }
  }

  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  // ===========================================================
  // BACK TO TOP
  // ===========================================================

  void _handleScroll() {
    final shouldShow =
        _scrollController.hasClients &&
        _scrollController.offset >
            _backToTopThreshold;

    if (mounted && shouldShow != _showBackToTop) {
      setState(() {
        _showBackToTop = shouldShow;
      });
    }
  }

  void _scrollToTop() {
    if (!_scrollController.hasClients) return;

    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
    );
  }

  // ===========================================================
  // DISPOSE
  // ===========================================================

  @override
  void dispose() {
    CartService.items.removeListener(_refresh);

    WishlistService.productsNotifier.removeListener(
      _refresh,
    );

    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();

    super.dispose();
  }

  // ===========================================================
  // PRODUCT MODEL MATCHING
  // ===========================================================

  ProductItem? _model(Map<String, dynamic> product) =>
      HomeProductPacks.resolveModel(product);

  // ===========================================================
  // PRODUCT SOURCE
  // ===========================================================

  List<Map<String, dynamic>> get _source {
    final List<Map<String, dynamic>> source;
    if (widget.products != null) {
      source = widget.products!.map(HomeProductPacks.prepare)
          .map((p) => {...p, 'category': HomeProductPacks.categoryOf(p)}).toList();
    } else if (widget.sectionType?.isNotEmpty == true && widget.categoryFilter == null) {
      source = [];
    } else {
      source = HomeProductPacks.catalog();
    }
    final category = widget.categoryFilter;
    if (category == null || category.trim().isEmpty || category == 'All') return source;
    return source.where((p) => HomeProductPacks.normalize(p['category']?.toString() ?? '') ==
        HomeProductPacks.normalize(category)).toList();
  }

  // ===========================================================
  // PRICE
  // ===========================================================

  double? _parsePrice(dynamic value) {
    if (value == null) return null;

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
      value.toString().replaceAll(
        RegExp(r'[^0-9.]'),
        '',
      ),
    );
  }

  String _money(double value) {
    return '₹${value.toStringAsFixed(2)}';
  }

  String _key(Map<String, dynamic> product) {
    return (
      _model(product)?.id ??
      product['id'] ??
      _model(product)?.name ??
      product['name'] ??
      ''
    ).toString();
  }

  // ===========================================================
  // PRODUCT VARIANTS
  // ===========================================================

  List<_ListVariant> _variants(
    Map<String, dynamic> product,
  ) {
    final rawVariants = product['variants'];

    if (rawVariants is List) {
      final result = <_ListVariant>[];

      for (final item in rawVariants) {
        if (item is Map) {
          final weight =
              item['weight']?.toString().trim() ?? '';

          final price = _parsePrice(item['price']);

          if (weight.isNotEmpty &&
              price != null &&
              price > 0) {
            result.add(
              _ListVariant(
                weight,
                price,
                _parsePrice(
                  item['mrp'] ?? item['originalPrice'],
                ),
              ),
            );
          }
        }
      }

      return result.take(3).toList();
    }

    final model = _model(product);

    if (model != null && model.variants.isNotEmpty) {
      return model.variants.map((variant) {
        return _ListVariant(
          variant.weight,
          variant.price.toDouble(),
          variant.mrp?.toDouble(),
        );
      }).take(3).toList();
    }

    final price = _parsePrice(product['price']);

    if (price == null || price <= 0) {
      return [];
    }

    return [
      _ListVariant(
        product['weight']?.toString() ?? '',
        price,
        _parsePrice(product['originalPrice']),
      ),
    ];
  }

  // ===========================================================
  // SELECTED VARIANT
  // ===========================================================

  _ListVariant? _selectedVariant(
    Map<String, dynamic> product,
  ) {
    final variants = _variants(product);

    if (variants.isEmpty) return null;

    final selectedWeight = _chosenWeights[_selectionKey(product)] ??
        product['weight']?.toString();

    for (final variant in variants) {
      if (variant.weight == selectedWeight) {
        return variant;
      }
    }

    final index = (_model(product)?.selectedVariant ?? 0)
        .clamp(0, variants.length - 1)
        .toInt();

    return variants[index];
  }

  double _price(Map<String, dynamic> product) {
    return _selectedVariant(product)?.price ?? 0;
  }

  List<String> _weights(
    Map<String, dynamic> product,
  ) {
    return _variants(product)
        .map((variant) => variant.weight)
        .where((weight) => weight.isNotEmpty)
        .toList();
  }

  // ===========================================================
  // FIND PRODUCT IN CART
  // ===========================================================

  CartNotificationItem? _cartItem(
    Map<String, dynamic> product,
    _ListVariant variant,
  ) {
    final model = _model(product);

    final id = (
      model?.id ?? product['id']?.toString()
    )?.trim();

    final name = (
      model?.name ??
      product['name']?.toString() ??
      ''
    ).trim().toLowerCase();

    for (final item in CartService.items.value) {
      final sameProduct =
          id != null && id.isNotEmpty
          ? item.productId?.trim() == id
          : item.name.trim().toLowerCase() == name;

      final sameWeight =
          (item.weight?.trim().toLowerCase() ?? '') ==
          variant.weight.trim().toLowerCase();

      if (sameProduct && sameWeight) {
        return item;
      }
    }

    return null;
  }

  // ===========================================================
  // SELECT QUANTITY KEY
  // ===========================================================

  String _selectionKey(Map<String, dynamic> product) =>
      '${_key(product)}|${product['weight'] ?? ''}';

  String _quantityKey(Map<String, dynamic> product) {
    final variant = _selectedVariant(product);

    return '${_selectionKey(product)}|${variant?.weight ?? ''}';
  }

  int _getQuantity(Map<String, dynamic> product) {
    return _selectedQuantities[
      _quantityKey(product)
    ] ?? 1;
  }

  // ===========================================================
  // INCREASE QUANTITY
  // ===========================================================

  void _increaseQuantity(
    Map<String, dynamic> product,
  ) {
    if (_busy.contains(_key(product))) return;

    final key = _quantityKey(product);

    setState(() {
      _selectedQuantities[key] =
          ((_selectedQuantities[key] ?? 1) + 1)
              .clamp(1, 99)
              .toInt();
    });
  }

  // ===========================================================
  // DECREASE QUANTITY
  // ===========================================================

  void _decreaseQuantity(
    Map<String, dynamic> product,
  ) {
    if (_busy.contains(_key(product))) return;

    final key = _quantityKey(product);

    setState(() {
      _selectedQuantities[key] =
          ((_selectedQuantities[key] ?? 1) - 1)
              .clamp(1, 99)
              .toInt();
    });
  }

  // ===========================================================
  // ADD TO CART
  // ===========================================================

  Future<void> _addToCart(
    Map<String, dynamic> product,
  ) async {
    final variant = _selectedVariant(product);
    final key = _key(product);
    final quantityKey = _quantityKey(product);

    if (!_cartReady ||
        variant == null ||
        variant.weight.trim().isEmpty ||
        _busy.contains(key)) {
      return;
    }

    final model = _model(product);
    final quantity = _getQuantity(product);

    final productName =
        model?.name ??
        product['name']?.toString() ??
        'Product';

    setState(() {
      _busy.add(key);
    });

    try {
      final existingItem = _cartItem(
        product,
        variant,
      );

      // FIRST TIME ADD TO CART

      if (existingItem == null) {
        await CartService.postAddToCart(
          productId:
              model?.id ??
              product['id']?.toString(),

          productName: productName,

          imageUrl:
              model?.imageUrl ??
              product['imageUrl']?.toString(),

          price: _money(variant.price),

          originalPrice: variant.mrp == null
              ? null
              : _money(variant.mrp!),

          weight: variant.weight,

          quantity: quantity,
        );
      }

      // PRODUCT ALREADY EXISTS IN CART

      else {
        for (int i = 0; i < quantity; i++) {
          final currentItem = _cartItem(
            product,
            variant,
          );

          if (currentItem == null) {
            throw StateError(
              'Cart item is no longer available.',
            );
          }

          await CartService.increaseItemQuantity(
            currentItem,
          );
        }
      }

      if (!mounted) return;

      setState(() {
        _selectedQuantities[quantityKey] = 1;
      });

      _message(
        '$quantity × $productName added to cart.',
        action: SnackBarAction(
          label: 'VIEW CART',
          onPressed: _openCart,
        ),
      );
    } catch (error) {
      _message(
        'Unable to complete cart update. Please check your cart.',
      );

      debugPrint('Cart Error: $error');
    } finally {
      if (mounted) {
        setState(() {
          _busy.remove(key);
        });
      }
    }
  }

  // ===========================================================
  // OPEN CART PAGE
  // ===========================================================

  void _openCart() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const NewCartPage(),
      ),
    );
  }

  void _openProductDetails(Map<String, dynamic> product) {
    final catalogProduct = _model(product);
    final variants = _variants(product)
        .map(
          (variant) => ProductVariant(
            weight: variant.weight,
            price: variant.price,
            mrp: variant.mrp,
          ),
        )
        .toList();
    final selectedWeight =
        _chosenWeights[_selectionKey(product)] ??
        product['weight']?.toString();
    final selectedVariant = variants.indexWhere(
      (variant) => variant.weight == selectedWeight,
    );
    final rawRating = product['rating'];
    final rating = rawRating is num
        ? rawRating.toDouble()
        : double.tryParse(rawRating?.toString() ?? '') ?? 0;
    final rawDeliveryDays = product['deliveryDays'];
    final deliveryDays = rawDeliveryDays is num
        ? rawDeliveryDays.toInt()
        : int.tryParse(rawDeliveryDays?.toString() ?? '') ?? 3;
    final detailProduct =
        catalogProduct ??
        ProductItem(
          id: product['id']?.toString(),
          name: product['name']?.toString().trim().isNotEmpty == true
              ? product['name'].toString().trim()
              : 'Product',
          imageUrl: product['imageUrl']?.toString() ?? '',
          rating: rating,
          deliveryDays: deliveryDays,
          variants: variants,
          discountLabel: product['discountLabel']?.toString() ?? '',
          selectedVariant: selectedVariant < 0 ? 0 : selectedVariant,
        );

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => NewProductDetailsPage(product: detailProduct),
      ),
    );
  }

  // ===========================================================
  // WISHLIST
  // ===========================================================

  void _toggleWishlist(
    Map<String, dynamic> product,
  ) {
    final item = _model(product);

    if (item == null) {
      _message(
        'Product is not linked to the product catalog.',
      );

      return;
    }

    final added = WishlistService.toggle(item);

    _message(
      added
          ? 'Saved to wishlist.'
          : 'Removed from wishlist.',

      action: added
          ? SnackBarAction(
              label: 'VIEW ALL',
              onPressed: _openWishlist,
            )
          : null,
    );
  }

  // ===========================================================
  // OPEN WISHLIST PAGE
  // ===========================================================

  void _openWishlist() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const NewWishlistPage(),
      ),
    );
  }

  // ===========================================================
  // SNACKBAR
  // ===========================================================

  void _message(
    String text, {
    SnackBarAction? action,
  }) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            text,
            style: HomeTextStyles.body.copyWith(
              color: HomeColors.white,
            ),
          ),
          action: action,
        ),
      );
  }

  // ===========================================================
  // FILTER CATEGORIES
  // ===========================================================

  List<String> get _categories {
    final result = <String>{'All'};

    for (final product in _source) {
      final category = product['category']?.toString();

      if (category != null && category.isNotEmpty) {
        result.add(category);
      }
    }

    return result.toList();
  }

  List<String> get _allWeights {
    final weights = <String>{};

    for (final product in _source) {
      weights.addAll(_weights(product));
    }

    return weights.toList();
  }

  double get _minPrice {
    final values = _source
        .expand(_variants)
        .map((variant) => variant.price)
        .toList()
      ..sort();

    return values.isEmpty ? 0 : values.first;
  }

  double get _maxPrice {
    final values = _source
        .expand(_variants)
        .map((variant) => variant.price)
        .toList()
      ..sort();

    if (values.isEmpty) return 1;

    return values.last > values.first
        ? values.last
        : values.first + 1;
  }

  // ===========================================================
  // FILTERED PRODUCTS
  // ===========================================================

  List<Map<String, dynamic>> get _visibleProducts {
    final products = _source.where((product) {
      final category =
          product['category']?.toString() ?? '';

      if (_selectedCategories.isNotEmpty &&
          !_selectedCategories.contains(category)) {
        return false;
      }

      final weights = _weights(product);

      if (_selectedWeights.isNotEmpty &&
          !weights.any(_selectedWeights.contains)) {
        return false;
      }

      if (_appliedRange != null &&
          !_variants(product).any(
            (variant) =>
                variant.price >= _appliedRange!.start &&
                variant.price <= _appliedRange!.end &&
                (_selectedWeights.isEmpty ||
                    _selectedWeights.contains(
                      variant.weight,
                    )),
          )) {
        return false;
      }

      return true;
    }).toList();

    switch (_sort) {
      case 'Price: Low to High':
        products.sort(
          (a, b) => _price(a).compareTo(_price(b)),
        );
        break;

      case 'Price: High to Low':
        products.sort(
          (a, b) => _price(b).compareTo(_price(a)),
        );
        break;

      case 'Rating':
        products.sort(
          (a, b) =>
              (num.tryParse(b['rating'].toString()) ?? 0)
                  .compareTo(
                    num.tryParse(a['rating'].toString()) ??
                        0,
                  ),
        );
        break;
    }

    return products;
  }

  Widget _sortChip(String label, String value) {
    final isSelected = _sort == value;

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      showCheckmark: false,
      visualDensity: VisualDensity.compact,
      labelPadding: const EdgeInsets.symmetric(horizontal: 6),
      backgroundColor: HomeColors.background,
      selectedColor: HomeColors.secondary,
      side: BorderSide(
        color: isSelected ? HomeColors.secondary : HomeColors.border,
      ),
      shape: const StadiumBorder(),
      labelStyle: HomeTextStyles.caption.copyWith(
        color: isSelected ? HomeColors.white : HomeColors.textPrimary,
        fontWeight: isSelected ? HomeTextStyles.bold : HomeTextStyles.medium,
      ),
      onSelected: (_) {
        setState(() {
          _sort = value;
        });
      },
    );
  }

  // ===========================================================
  // FILTER DRAWER
  // ===========================================================

  void _openFilters() {
    final tempCategories =
        Set<String>.from(_selectedCategories);

    final tempWeights =
        Set<String>.from(_selectedWeights);

    RangeValues tempRange =
        _appliedRange ??
        RangeValues(_minPrice, _maxPrice);

    final width = MediaQuery.sizeOf(context).width;

    showGeneralDialog<void>(
      context: context,

      barrierLabel: 'Close filters',
      barrierDismissible: true,

      barrierColor:
          HomeColors.black.withValues(alpha: 0.54),

      transitionDuration:
          const Duration(milliseconds: 280),

      pageBuilder: (dialogContext, _, __) {
        return Align(
          alignment: Alignment.centerRight,

          child: Material(
            color: HomeColors.surface,

            child: SafeArea(
              left: false,

              child: SizedBox(
                width: width * .82,
                height: double.infinity,

                child: StatefulBuilder(
                  builder: (dialogContext, updateDialog) {
                    return Column(
                      children: [
                        // FILTER TITLE

                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(
                                18, 20, 12, 16,
                              ),

                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Filters',

                                  style: HomeTextStyles
                                      .largePrice
                                      .copyWith(
                                        color: HomeColors
                                            .textPrimary,
                                      ),
                                ),
                              ),

                              IconButton(
                                onPressed: () {
                                  Navigator.pop(
                                    dialogContext,
                                  );
                                },

                                icon: const Icon(
                                  Icons.close,
                                  color: HomeColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Divider(
                          height: 1,
                          color: HomeColors.divider,
                        ),

                        Expanded(
                          child: ListView(
                            padding:
                                const EdgeInsets.all(18),

                            children: [
                              // CATEGORIES

                              const _FilterHeading(
                                'Categories',
                              ),

                              for (final category
                                  in _categories)
                                CheckboxListTile(
                                  contentPadding:
                                      EdgeInsets.zero,

                                  activeColor:
                                      HomeColors.secondary,

                                  checkColor:
                                      HomeColors.white,

                                  controlAffinity:
                                      ListTileControlAffinity
                                          .trailing,

                                  title: Text(
                                    category,

                                    style: HomeTextStyles.body
                                        .copyWith(
                                          color: HomeColors
                                              .textPrimary,
                                        ),
                                  ),

                                  value: category == 'All'
                                      ? tempCategories.isEmpty
                                      : tempCategories.contains(
                                          category,
                                        ),

                                  onChanged: (value) {
                                    updateDialog(() {
                                      if (category == 'All') {
                                        tempCategories.clear();
                                      } else if (value == true) {
                                        tempCategories.add(
                                          category,
                                        );
                                      } else {
                                        tempCategories.remove(
                                          category,
                                        );
                                      }
                                    });
                                  },
                                ),

                              const SizedBox(height: 20),

                              // PRICE RANGE

                              const _FilterHeading(
                                'Price Range',
                              ),

                              RangeSlider(
                                values: tempRange,

                                min: _minPrice,
                                max: _maxPrice,

                                activeColor:
                                    HomeColors.secondary,

                                inactiveColor:
                                    HomeColors.secondaryLight,

                                onChanged: (value) {
                                  updateDialog(() {
                                    tempRange = value;
                                  });
                                },
                              ),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,

                                children: [
                                  Text(
                                    '₹${tempRange.start.round()}',

                                    style: HomeTextStyles.body
                                        .copyWith(
                                          color: HomeColors
                                              .textPrimary,
                                        ),
                                  ),

                                  Text(
                                    '₹${tempRange.end.round()}',

                                    style: HomeTextStyles.body
                                        .copyWith(
                                          color: HomeColors
                                              .textPrimary,
                                        ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 25),

                              // WEIGHT

                              const _FilterHeading(
                                'Weight',
                              ),

                              for (final weight in _allWeights)
                                CheckboxListTile(
                                  contentPadding:
                                      EdgeInsets.zero,

                                  activeColor:
                                      HomeColors.secondary,

                                  checkColor:
                                      HomeColors.white,

                                  title: Text(
                                    weight,

                                    style: HomeTextStyles.body
                                        .copyWith(
                                          color: HomeColors
                                              .textPrimary,
                                        ),
                                  ),

                                  controlAffinity:
                                      ListTileControlAffinity
                                          .trailing,

                                  value: tempWeights.contains(
                                    weight,
                                  ),

                                  onChanged: (value) {
                                    updateDialog(() {
                                      if (value == true) {
                                        tempWeights.add(weight);
                                      } else {
                                        tempWeights.remove(
                                          weight,
                                        );
                                      }
                                    });
                                  },
                                ),
                            ],
                          ),
                        ),

                        // CLEAR AND APPLY

                        Container(
                          padding:
                              const EdgeInsets.fromLTRB(
                                12, 14, 12, 18,
                              ),

                          decoration: BoxDecoration(
                            color: HomeColors.surface,

                            boxShadow: [
                              BoxShadow(
                                color: HomeColors.black
                                    .withValues(alpha: 0.08),

                                blurRadius: 10,

                                offset: const Offset(0, -2),
                              ),
                            ],
                          ),

                          child: Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    updateDialog(() {
                                      tempCategories.clear();
                                      tempWeights.clear();

                                      tempRange = RangeValues(
                                        _minPrice,
                                        _maxPrice,
                                      );
                                    });

                                    setState(() {
                                      _selectedCategories.clear();
                                      _selectedWeights.clear();
                                      _appliedRange = null;
                                    });
                                  },

                                  style:
                                      OutlinedButton.styleFrom(
                                        foregroundColor:
                                            HomeColors.secondary,

                                        textStyle:
                                            HomeTextStyles
                                                .compactButton,

                                        padding:
                                            const EdgeInsets
                                                .symmetric(
                                              vertical: 15,
                                            ),

                                        shape:
                                            const StadiumBorder(),
                                      ),

                                  child: const Text('CLEAR'),
                                ),
                              ),

                              const SizedBox(width: 10),

                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _selectedCategories =
                                          Set.from(
                                            tempCategories,
                                          );

                                      _selectedWeights =
                                          Set.from(
                                            tempWeights,
                                          );

                                      _appliedRange =
                                          tempRange.start <=
                                                  _minPrice &&
                                              tempRange.end >=
                                                  _maxPrice
                                          ? null
                                          : tempRange;
                                    });

                                    Navigator.pop(
                                      dialogContext,
                                    );
                                  },

                                  style:
                                      ElevatedButton.styleFrom(
                                        backgroundColor:
                                            HomeColors.secondary,

                                        foregroundColor:
                                            HomeColors.white,

                                        textStyle:
                                            HomeTextStyles
                                                .caption,

                                        padding:
                                            const EdgeInsets
                                                .symmetric(
                                              vertical: 15,
                                            ),

                                        shape:
                                            const StadiumBorder(),
                                      ),

                                  child: const Text(
                                    'APPLY FILTER',
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },

      transitionBuilder:
          (context, animation, _, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                ),
              ),

              child: child,
            );
          },
    );
  }

  // ===========================================================
  // MAIN BUILD
  // ===========================================================

  @override
  Widget build(BuildContext context) {
    final products = _visibleProducts;

    return Scaffold(
      backgroundColor: HomeColors.background,

      // =======================================================
      // COMMON APP BAR
      // =======================================================

      appBar: CommonAppBar(
        automaticallyImplyLeading: false,

        showBackButton: true,

        centerTitle: true,

        backgroundColor: HomeColors.secondary,

        title: widget.pageTitle,

        actions: [
          ValueListenableBuilder<
              List<CartNotificationItem>>(
            valueListenable: CartService.items,

            builder: (context, items, _) {
              final count = items.fold<int>(
                0,
                (sum, item) => sum + item.quantity,
              );

              return IconButton(
                tooltip: 'Cart',

                onPressed: _openCart,

                icon: Badge(
                  isLabelVisible: count > 0,

                  backgroundColor: HomeColors.error,

                  textColor: HomeColors.white,

                  label: Text(
                    count > 99 ? '99+' : '$count',

                    style: HomeTextStyles.caption.copyWith(
                      color: HomeColors.white,
                    ),
                  ),

                  child: const Icon(
                    Icons.shopping_cart_outlined,
                    color: HomeColors.white,
                    size: 27,
                  ),
                ),
              );
            },
          ),

          const SizedBox(width: 8),
        ],
      ),

      // =======================================================
      // BODY
      // =======================================================

      body: Column(
        children: [
          // PRODUCT COUNT, SORT, FILTER

          Container(
            color: HomeColors.surface,

            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${widget.pageTitle} (${products.length})',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: HomeTextStyles.price.copyWith(
                          color: HomeColors.textPrimary,
                        ),
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: _openFilters,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: HomeColors.textPrimary,
                        textStyle: HomeTextStyles.bodySmall,
                        minimumSize: const Size(0, 40),
                        padding: const EdgeInsets.symmetric(horizontal: 9),
                        side: const BorderSide(color: HomeColors.border),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                      icon: const Icon(Icons.filter_list, size: 20),
                      label: const Text('Filter'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
               
                    _sortChip('Popularity', 'Rating'),
                    _sortChip('Price: Low to High', 'Price: Low to High'),
                    _sortChip('Price: High to Low', 'Price: High to Low'),
                  ],
                ),
              ],
            ),
          ),

          const Divider(
            height: 1,
            color: HomeColors.divider,
          ),

          if (_cartError != null)
            TextButton(
              onPressed: _initializeCart,

              child: Text(
                'Cart unavailable — retry',

                style: HomeTextStyles.body.copyWith(
                  color: HomeColors.error,
                ),
              ),
            ),

          // ===================================================
          // PRODUCT GRID
          // ===================================================

          Expanded(
            child: Stack(
              children: [
                if (products.isEmpty)
                  Center(
                    child: Text(
                      'No products match these filters',

                      style: HomeTextStyles.body.copyWith(
                        color: HomeColors.textSecondary,
                      ),
                    ),
                  )
                else
                  GridView.builder(
                    controller: _scrollController,

                    physics:
                        const ClampingScrollPhysics(),

                    padding:
                        const EdgeInsets.all(12),

                    itemCount: products.length,

                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,

                          mainAxisExtent:
                              ProductListStyle.cardHeight,
                        ),

                    itemBuilder: (context, index) {
                      final product = products[index];

                      final key = _key(product);
                      final model = _model(product);
                      final variant =
                          _selectedVariant(product);

                      return _ProductCard(
                        product: product,

                        money: _money,

                        variants: _variants(product),

                        selected: variant,

                        quantity: _getQuantity(product),

                        favorite: model != null &&
                            WishlistService.contains(
                              model,
                            ),

                        adding: _busy.contains(key),

                        enabled:
                            _cartReady && variant != null,

                        onOpenDetails: () {
                          _openProductDetails(product);
                        },

                        onWeightChanged: (value) {
                          if (value == null) return;

                          setState(() {
                            _chosenWeights[_selectionKey(product)] = value;
                          });
                        },

                        onFavorite: () {
                          _toggleWishlist(product);
                        },

                        onMinus: () {
                          _decreaseQuantity(product);
                        },

                        onPlus: () {
                          _increaseQuantity(product);
                        },

                        onAdd: () {
                          _addToCart(product);
                        },
                      );
                    },
                  ),

                // BACK TO TOP BUTTON

                if (_showBackToTop &&
                    products.isNotEmpty)
                  Positioned(
                    top: 12,
                    left: 0,
                    right: 0,

                    child: Center(
                      child: BackToTopButton(
                        onPressed: _scrollToTop,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================
// FILTER HEADING
// =============================================================

class _FilterHeading extends StatelessWidget {
  final String title;

  const _FilterHeading(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            title,

            style: HomeTextStyles.summaryTotalLabel.copyWith(
              color: HomeColors.textPrimary,
            ),
          ),

          const SizedBox(height: 12),

          const Divider(
            height: 1,
            color: HomeColors.divider,
          ),
        ],
      ),
    );
  }
}

// =============================================================
// PRODUCT VARIANT MODEL
// =============================================================

class _ListVariant {
  final String weight;
  final double price;
  final double? mrp;

  const _ListVariant(
    this.weight,
    this.price,
    this.mrp,
  );
}

// =============================================================
// PRODUCT CARD
// =============================================================

class _ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;

  final String Function(double) money;

  final List<_ListVariant> variants;

  final _ListVariant? selected;

  final int quantity;

  final bool favorite;
  final bool adding;
  final bool enabled;

  final ValueChanged<String?> onWeightChanged;

  final VoidCallback onFavorite;
  final VoidCallback onOpenDetails;
  final VoidCallback onMinus;
  final VoidCallback onPlus;
  final VoidCallback onAdd;

  const _ProductCard({
    required this.product,
    required this.money,
    required this.variants,
    required this.selected,
    required this.quantity,
    required this.favorite,
    required this.adding,
    required this.enabled,
    required this.onWeightChanged,
    required this.onFavorite,
    required this.onOpenDetails,
    required this.onMinus,
    required this.onPlus,
    required this.onAdd,
  });

  // ===========================================================
  // PRODUCT IMAGE
  // ===========================================================

  Widget _buildImage(String url) {
    if (url.isEmpty) {
      return const Center(
        child: Icon(
          Icons.inventory_2_outlined,
          color: HomeColors.secondary,
          size: 60,
        ),
      );
    }

    if (url.startsWith('http://') ||
        url.startsWith('https://')) {
      return Image.network(
        url,

        fit: BoxFit.contain,

        errorBuilder: (_, __, ___) {
          return const Center(
            child: Icon(
              Icons.image_not_supported_outlined,
              color: HomeColors.textHint,
              size: 40,
            ),
          );
        },
      );
    }

    return Image.asset(
      url,

      fit: BoxFit.contain,

      errorBuilder: (_, __, ___) {
        return const Center(
          child: Icon(
            Icons.image_not_supported_outlined,
            color: HomeColors.textHint,
            size: 40,
          ),
        );
      },
    );
  }

  // ===========================================================
  // BUILD PRODUCT CARD
  // ===========================================================

  @override
  Widget build(BuildContext context) {
    final name =
        product['name']?.toString() ?? 'Product';

    final url =
        product['imageUrl']?.toString() ?? '';

    final rating = double.tryParse(
          product['rating']?.toString() ?? '',
        ) ??
        0;

    final days = product['deliveryDays'];

    final options = <String, _ListVariant>{
      for (final variant in variants)
        variant.weight: variant,
    };

    return GestureDetector(
      onTap: onOpenDetails,
      child: Container(
        decoration: BoxDecoration(
          color: HomeColors.surface,

          borderRadius: BorderRadius.circular(
            ProductListStyle.cardRadius,
          ),

          border: Border.all(
            color: HomeColors.border,
          ),

          boxShadow: [
            BoxShadow(
              color: HomeColors.black
                  .withValues(alpha: 0.035),

              blurRadius: 5,

              offset: const Offset(0, 2),
            ),
          ],
        ),

        clipBehavior: Clip.antiAlias,

        child: Padding(
          padding: const EdgeInsets.all(10),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // =================================================
            // PRODUCT IMAGE
            // =================================================

            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      width: double.infinity,

                      padding: const EdgeInsets.all(8),

                      alignment: Alignment.center,

                      child: _buildImage(url),
                    ),
                  ),

                  // WISHLIST HEART

                  Positioned(
                    top: 0,
                    right: 0,

                    child: IconButton(
                      tooltip: favorite
                          ? 'Remove from wishlist'
                          : 'Add to wishlist',

                      onPressed: onFavorite,

                      icon: Icon(
                        favorite
                            ? Icons.favorite
                            : Icons.favorite_border,

                        color: favorite
                            ? HomeColors.secondary
                            : HomeColors.textHint,

                        size: 25,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // =================================================
            // PRODUCT NAME
            // =================================================

            SizedBox(
              height: 38,

              width: double.infinity,

              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  name,

                  maxLines: 2,

                  overflow: TextOverflow.ellipsis,

                  style: HomeTextStyles.productCardTitle.copyWith(
                    height: 1.3,

                    fontWeight: HomeTextStyles.bold,

                    color: HomeColors.textPrimary,
                  ),
                ),
              ),
            ),

            // =================================================
            // STAR RATING
            // =================================================

            Row(
              mainAxisAlignment: MainAxisAlignment.center,

              children: List.generate(
                5,

                (index) {
                  return Icon(
                    index < rating.floor()
                        ? Icons.star_rounded
                        : rating - index >= .5
                            ? Icons.star_half_rounded
                            : Icons.star_border_rounded,

                    color: HomeColors.accent,

                    size: 18,
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            // =================================================
            // WEIGHT AND PRICE DROPDOWN
            // =================================================

            Container(
              width: double.infinity,

              height: 38,

              padding: const EdgeInsets.symmetric(
                horizontal: 8,
              ),

              decoration: BoxDecoration(
                color: HomeColors.surface,

                border: Border.all(
                  color: HomeColors.border,
                ),

                borderRadius: BorderRadius.circular(6),
              ),

              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,

                  value: options.containsKey(
                    selected?.weight,
                  )
                      ? selected?.weight
                      : null,

                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,

                    size: 20,

                    color: HomeColors.textPrimary,
                  ),

                  borderRadius:
                      BorderRadius.circular(10),

                  dropdownColor: HomeColors.surface,

                  hint: Text(
                    'No variant available',

                    style: HomeTextStyles.caption.copyWith(
                      color: HomeColors.textHint,
                    ),
                  ),

                  style: HomeTextStyles.caption.copyWith(
                    color: HomeColors.textPrimary,

                    fontWeight: HomeTextStyles.medium,
                  ),

                  items: options.values.map((variant) {
                    return DropdownMenuItem<String>(
                      value: variant.weight,

                      child: Text(
                        variant.weight.isEmpty
                            ? money(variant.price)
                            : '${variant.weight} - '
                              '${money(variant.price)}',

                        maxLines: 1,

                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),

                  onChanged: adding || options.isEmpty
                      ? null
                      : onWeightChanged,
                ),
              ),
            ),

            const SizedBox(height: 8),

            // =================================================
            // PRODUCT PRICE
            // =================================================

            Text(
              selected == null
                  ? 'Price unavailable'
                  : money(selected!.price),

              maxLines: 1,

              overflow: TextOverflow.ellipsis,

              style: HomeTextStyles.summaryTotalLabel.copyWith(
                color: HomeColors.textPrimary,
              ),
            ),

            // ORIGINAL PRICE

            SizedBox(
              height: 18,

              child: selected?.mrp != null &&
                      selected!.mrp! > selected!.price
                  ? Text(
                      money(selected!.mrp!),

                      style: HomeTextStyles.caption.copyWith(
                        color: HomeColors.textSecondary,

                        decoration:
                            TextDecoration.lineThrough,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            const SizedBox(height: 4),

            // =================================================
            // DELIVERY DETAILS
            // =================================================

            Row(
              children: [
                const Icon(
                  Icons.local_shipping_outlined,

                  size: 16,

                  color: HomeColors.secondary,
                ),

                const SizedBox(width: 4),

                Expanded(
                  child: Text(
                    days == null
                        ? 'Delivery details at checkout'
                        : 'Delivery in $days days',

                    maxLines: 1,

                    overflow: TextOverflow.ellipsis,

                    style: HomeTextStyles.caption.copyWith(
                      color: HomeColors.secondary,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // =================================================
            // QUANTITY AND ADD BUTTON
            // =================================================

            Row(
              children: [
                // LEFT SIDE QUANTITY CONTROL

                Expanded(
                  flex: 5,

                  child: Container(
                    height: 38,

                    decoration: BoxDecoration(
                      color: HomeColors.surface,

                      border: Border.all(
                        color: HomeColors.disabled,
                      ),

                      borderRadius:
                          BorderRadius.circular(6),
                    ),

                    child: Row(
                      children: [
                        // MINUS BUTTON

                        Expanded(
                          child: InkWell(
                            onTap: !enabled ||
                                    adding ||
                                    quantity <= 1
                                ? null
                                : onMinus,

                            child: SizedBox(
                              height: 38,

                              child: Center(
                                child: Icon(
                                  Icons.remove,

                                  size: 17,

                                  color: quantity <= 1 ||
                                          !enabled ||
                                          adding
                                      ? HomeColors.textSecondary
                                      : HomeColors.textPrimary,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // QUANTITY TEXT

                        Expanded(
                          child: Center(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,

                              child: Text(
                                '$quantity',

                                style: HomeTextStyles
                                    .bodySmall
                                    .copyWith(
                                      color: HomeColors
                                          .textPrimary,

                                      fontWeight:
                                          HomeTextStyles.bold,
                                    ),
                              ),
                            ),
                          ),
                        ),

                        // PLUS BUTTON

                        Expanded(
                          child: InkWell(
                            onTap: !enabled ||
                                    adding ||
                                    quantity >= 99
                                ? null
                                : onPlus,

                            child: SizedBox(
                              height: 38,

                              child: Center(
                                child: Icon(
                                  Icons.add,

                                  size: 17,

                                  color: !enabled ||
                                          adding ||
                                          quantity >= 99
                                      ? HomeColors.textSecondary
                                      : HomeColors.textPrimary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 5),

                // RIGHT SIDE ADD BUTTON

                Expanded(
                  flex: 4,

                  child: SizedBox(
                    height: 38,

                    child: ElevatedButton(
                      onPressed: !enabled || adding
                          ? null
                          : onAdd,

                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            HomeColors.secondary,

                        foregroundColor:
                            HomeColors.white,

                        disabledBackgroundColor:
                            HomeColors.secondary
                                .withValues(alpha: 0.50),

                        disabledForegroundColor:
                            HomeColors.white,

                        textStyle: HomeTextStyles
                            .compactButton
                            .copyWith(
                              fontWeight:
                                  HomeTextStyles.bold,
                            ),

                        elevation: 0,

                        padding: EdgeInsets.zero,

                        minimumSize: Size.zero,

                        tapTargetSize:
                            MaterialTapTargetSize.shrinkWrap,

                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(6),
                        ),
                      ),

                      child: adding
                          ? const SizedBox(
                              height: 17,

                              width: 17,

                              child:
                                  CircularProgressIndicator(
                                    strokeWidth: 2,

                                    color: HomeColors.white,
                                  ),
                            )
                          : const Text(
                              'ADD',
                              maxLines: 1,
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        ),
      ),
    );
  }
}