import 'package:flutter/material.dart';

// Replace this import only if your cart service lives elsewhere.
import 'package:lalbaba_online/core/services/cart_service.dart';

/// Design tokens shared by this product list and its filter sheet.
class ProductListStyle {
  ProductListStyle._();
  static const green = Color(0xFF008A58);
  static const deepGreen = Color(0xFF006D46);
  static const mint = Color(0xFFE6F5ED);
  static const background = Color(0xFFF7F8F7);
  static const surface = Colors.white;
  static const text = Color(0xFF202522);
  static const grey = Color(0xFF777F7A);
  static const border = Color(0xFFE5EAE6);
  static const orange = Color(0xFFFF9800);
  static const headingSize = 16.0;
  static const productNameSize = 13.0;
  static const priceSize = 17.0;
}

/// Product list accepts the same named parameters as the existing Home page call:
/// ProductListPage(sectionType: 'bestSeller', pageTitle: 'All time Best seller')
///
/// For live results, pass a list of maps in [products] from your existing API:
/// id, name, imageUrl, price, originalPrice, rating, category, weights,
/// deliveryDays. No API endpoint or pricing is invented here.
class ProductListscreen extends StatefulWidget {
  final String? sectionType;
  final String pageTitle;
  final List<Map<String, dynamic>>? products;

  const ProductListscreen({
    super.key,
    this.sectionType,
    this.pageTitle = 'Products',
    this.products,
    
  });

  @override
  State<ProductListscreen> createState() => _ProductListscreenState();
}

class _ProductListscreenState extends State<ProductListscreen> {
  final Map<String, int> _qty = {};
  final Map<String, String> _chosenWeights = {};
  final Set<String> _favorites = {};
  final Set<String> _adding = {};
  final Set<String> _added = {};
  Set<String> _selectedCategories = {};
  Set<String> _selectedWeights = {};
  RangeValues? _appliedRange;
  String _sort = 'Default';

  // These three items are an optional screenshot-based preview, NOT an API feed.
  // Pass your original API products into the [products] argument in production.
  static const List<Map<String, dynamic>> _previewProducts = [
    {
      'id': 'sample-1',
      'name': 'Lalbaba Exclusive Basmati',
      'imageUrl': '',
      'price': 119.0,
      'rating': 5.0,
      'category': 'Basmati',
      'weights': ['1 Kg', '2 Kg'],
      'deliveryDays': 4,
    },
    {
      'id': 'sample-2',
      'name': 'Lalbaba Traditional Basmati Rice',
      'imageUrl': '',
      'price': 199.0,
      'rating': 4.5,
      'category': 'Basmati',
      'weights': ['1 Kg', '2 Kg'],
      'deliveryDays': 5,
    },
    {
      'id': 'sample-3',
      'name': 'Lalbaba Jeera Kathi',
      'imageUrl': '',
      'price': 159.0,
      'rating': 4.5,
      'category': 'JEERA KATHI',
      'weights': ['1 Kg', '2 Kg'],
      'deliveryDays': 5,
    },
  ];

  List<Map<String, dynamic>> get _source => widget.products ?? _previewProducts;

  double _price(Map<String, dynamic> p) {
    final v = p['price'];
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString().replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
  }

  String _money(double value) => '₹${value.toStringAsFixed(2)}';

  String _key(Map<String, dynamic> p) =>
      (p['id'] ?? p['name'] ?? '').toString();

  List<String> _weights(Map<String, dynamic> p) {
    final raw = p['weights'];
    if (raw is List && raw.isNotEmpty) return raw.map((e) => e.toString()).toList();
    final weight = p['weight']?.toString();
    return weight == null || weight.isEmpty ? ['1 Kg'] : [weight];
  }

  List<String> get _categories {
    final result = <String>{'All', 'Minikit', 'Banskathi', 'Ratna',
      'Gobindo Bhog', 'Basmati', 'JEERA KATHI'};
    for (final p in _source) {
      final c = p['category']?.toString();
      if (c != null && c.isNotEmpty) result.add(c);
    }
    return result.toList();
  }

  List<String> get _allWeights {
    final weights = <String>{'1 Kg', '2 Kg'};
    for (final p in _source) {
      weights.addAll(_weights(p));
    }
    return weights.toList();
  }

  double get _minPrice {
    if (_source.isEmpty) return 0;
    final values = _source.map(_price).toList()..sort();
    return values.first;
  }

  double get _maxPrice {
    if (_source.isEmpty) return 1;
    final values = _source.map(_price).toList()..sort();
    return values.last > values.first ? values.last : values.first + 1;
  }

  List<Map<String, dynamic>> get _visibleProducts {
    final list = _source.where((p) {
      final category = p['category']?.toString() ?? '';
      if (_selectedCategories.isNotEmpty && !_selectedCategories.contains(category)) {
        return false;
      }
      final weights = _weights(p);
      if (_selectedWeights.isNotEmpty &&
          !weights.any(_selectedWeights.contains)) return false;
      final price = _price(p);
      if (_appliedRange != null &&
          (price < _appliedRange!.start || price > _appliedRange!.end)) {
        return false;
      }
      return true;
    }).toList();
    switch (_sort) {
      case 'Price: Low to High':
        list.sort((a, b) => _price(a).compareTo(_price(b)));
        break;
      case 'Price: High to Low':
        list.sort((a, b) => _price(b).compareTo(_price(a)));
        break;
      case 'Rating':
        list.sort((a, b) => (num.tryParse(b['rating'].toString()) ?? 0)
            .compareTo(num.tryParse(a['rating'].toString()) ?? 0));
        break;
    }
    return list;
  }

  void _openSort() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 20, 18, 12),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Align(alignment: Alignment.centerLeft,
              child: Text('Sort By', style: TextStyle(fontSize: 20,
                fontWeight: FontWeight.w700))),
            const SizedBox(height: 8),
            for (final option in ['Default', 'Price: Low to High',
              'Price: High to Low', 'Rating'])
              RadioListTile<String>(
                activeColor: ProductListStyle.green,
                title: Text(option),
                value: option,
                groupValue: _sort,
                onChanged: (value) {
                  if (value != null) setState(() => _sort = value);
                  Navigator.pop(sheetContext);
                },
              ),
          ]),
        ),
      ),
    );
  }

  void _openFilters() {
    final tempCategories = Set<String>.from(_selectedCategories);
    final tempWeights = Set<String>.from(_selectedWeights);
    RangeValues tempRange = _appliedRange ?? RangeValues(_minPrice, _maxPrice);
    final width = MediaQuery.sizeOf(context).width;
    showGeneralDialog<void>(
      context: context,
      barrierLabel: 'Close filters',
      barrierDismissible: true,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (dialogContext, _, __) => Align(
        alignment: Alignment.centerRight,
        child: Material(
          color: Colors.white,
          child: SafeArea(
            left: false,
            child: SizedBox(
              width: width * .82,
              height: double.infinity,
              child: StatefulBuilder(
                builder: (dialogContext, updateDialog) {
                  void changeCategory(String category, bool selected) {
                    updateDialog(() {
                      if (category == 'All') {
                        tempCategories.clear();
                      } else if (selected) {
                        tempCategories.add(category);
                      } else {
                        tempCategories.remove(category);
                      }
                    });
                  }
                  return Column(children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 20, 12, 16),
                      child: Row(children: [
                        const Expanded(child: Text('Filters',
                          style: TextStyle(fontSize: 23,
                            color: ProductListStyle.text,
                            fontWeight: FontWeight.w800))),
                        IconButton(
                          icon: const Icon(Icons.close, size: 26),
                          onPressed: () => Navigator.pop(dialogContext),
                        ),
                      ]),
                    ),
                    const Divider(height: 1),
                    Expanded(child: ListView(
                      padding: const EdgeInsets.fromLTRB(18, 20, 18, 24),
                      children: [
                        const _FilterHeading('Categories'),
                        for (final category in _categories)
                          CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            dense: false,
                            controlAffinity: ListTileControlAffinity.trailing,
                            activeColor: ProductListStyle.green,
                            title: Text(category,
                              style: const TextStyle(fontSize: 15,
                                color: ProductListStyle.text)),
                            value: category == 'All'
                                ? tempCategories.isEmpty
                                : tempCategories.contains(category),
                            onChanged: (v) => changeCategory(category, v ?? false),
                          ),
                        const SizedBox(height: 18),
                        const _FilterHeading('Price Range'),
                        const SizedBox(height: 15),
                        RangeSlider(
                          values: tempRange,
                          min: _minPrice,
                          max: _maxPrice,
                          activeColor: ProductListStyle.green,
                          inactiveColor: ProductListStyle.mint,
                          onChanged: (v) => updateDialog(() => tempRange = v),
                        ),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('₹${tempRange.start.round()}'),
                            Text('₹${tempRange.end.round()}'),
                          ]),
                        const SizedBox(height: 25),
                        const _FilterHeading('Weight'),
                        for (final weight in _allWeights)
                          CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            activeColor: ProductListStyle.green,
                            controlAffinity: ListTileControlAffinity.trailing,
                            title: Text(weight,
                              style: const TextStyle(fontSize: 15)),
                            value: tempWeights.contains(weight),
                            onChanged: (checked) => updateDialog(() {
                              if (checked ?? false) {
                                tempWeights.add(weight);
                              } else {
                                tempWeights.remove(weight);
                              }
                            }),
                          ),
                      ],
                    )),
                    Container(
                      padding: const EdgeInsets.fromLTRB(12, 14, 12, 18),
                      decoration: const BoxDecoration(color: Colors.white,
                        boxShadow: [BoxShadow(color: Color(0x14000000),
                          blurRadius: 10, offset: Offset(0, -2))]),
                      child: Row(children: [
                        Expanded(child: OutlinedButton(
                          onPressed: () {
                            updateDialog(() {
                              tempCategories.clear();
                              tempWeights.clear();
                              tempRange = RangeValues(_minPrice, _maxPrice);
                            });
                            setState(() {
                              _selectedCategories.clear();
                              _selectedWeights.clear();
                              _appliedRange = null;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            side: const BorderSide(color: ProductListStyle.grey),
                            shape: const StadiumBorder(),
                          ),
                          child: const Text('CLEAR', style: TextStyle(
                            color: ProductListStyle.deepGreen,
                            fontWeight: FontWeight.w700)),
                        )),
                        const SizedBox(width: 10),
                        Expanded(child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedCategories = Set.from(tempCategories);
                              _selectedWeights = Set.from(tempWeights);
                              _appliedRange = tempRange.start <= _minPrice &&
                                tempRange.end >= _maxPrice ? null : tempRange;
                            });
                            Navigator.pop(dialogContext);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ProductListStyle.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: const StadiumBorder(),
                          ),
                          child: const Text('APPLY FILTER',
                            maxLines: 1,
                            style: TextStyle(fontSize: 12,
                              fontWeight: FontWeight.w700)),
                        )),
                      ]),
                    ),
                  ]);
                },
              ),
            ),
          ),
        ),
      ),
      transitionBuilder: (context, anim, _, child) => SlideTransition(
        position: Tween(begin: const Offset(1, 0), end: Offset.zero)
          .animate(CurvedAnimation(parent: anim,
            curve: Curves.easeOutCubic)),
        child: child,
      ),
    );
  }

  Future<void> _addProduct(Map<String, dynamic> product) async {
    final key = _key(product);
    if (_adding.contains(key)) return;
    setState(() => _adding.add(key));
    try {
      // Screenshot previews have no real product ID: never send fake IDs to API.
      if (key.startsWith('sample-')) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Connect your real product API to enable Add to Cart.'),
        ));
        return;
      }
      await CartService.postAddToCart(
        productId: product['id']?.toString(),
        productName: product['name']?.toString(),
        imageUrl: product['imageUrl']?.toString(),
        price: product['price']?.toString(),
        originalPrice: product['originalPrice']?.toString(),
        quantity: _qty[key] ?? 1,
      );
      if (!mounted) return;
      setState(() => _added.add(key));
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Added to cart'),
      ));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Unable to add to cart: $error'),
      ));
    } finally {
      if (mounted) setState(() => _adding.remove(key));
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = _visibleProducts;
    return Scaffold(
      backgroundColor: ProductListStyle.background,
      appBar: AppBar(
        backgroundColor: ProductListStyle.green,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(widget.pageTitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 21,
            fontWeight: FontWeight.w700)),
      ),
      body: Column(children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(children: [
            Expanded(child: Text('${widget.pageTitle} (${products.length})',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: ProductListStyle.headingSize,
                fontWeight: FontWeight.w800,
                color: ProductListStyle.text))),
            TextButton.icon(
              onPressed: _openSort,
              icon: const Icon(Icons.sort, color: ProductListStyle.text,
                size: 22),
              label: const Text('Sort By',
                style: TextStyle(color: ProductListStyle.text,
                  fontSize: 13)),
            ),
            OutlinedButton.icon(
              onPressed: _openFilters,
              style: OutlinedButton.styleFrom(
                foregroundColor: ProductListStyle.text,
                minimumSize: const Size(0, 44),
                padding: const EdgeInsets.symmetric(horizontal: 9),
                side: const BorderSide(color: Color(0xFFC7CEC8)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7)),
              ),
              icon: const Icon(Icons.filter_list, size: 20),
              label: const Text('Filter', style: TextStyle(fontSize: 13)),
            ),
          ]),
        ),
        const Divider(height: 1, color: ProductListStyle.border),
        Expanded(child: products.isEmpty
          ? const Center(child: Text('No products match these filters'))
          : LayoutBuilder(builder: (context, constraints) {
            final width = (constraints.maxWidth - 36) / 2;
            return GridView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: products.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                mainAxisExtent: 390,
              ),
              itemBuilder: (context, index) {
                final p = products[index];
                final key = _key(p);
                return _ProductCard(
                  product: p,
                  money: _money,
                  price: _price(p),
                  quantity: _qty[key] ?? 1,
                  selectedWeight: _chosenWeights[key],
                  onWeightChanged: (value) => setState(() {
                    if (value != null) _chosenWeights[key] = value;
                  }),
                  favorite: _favorites.contains(key),
                  adding: _adding.contains(key),
                  added: _added.contains(key),
                  onFavorite: () => setState(() {
                    if (!_favorites.add(key)) _favorites.remove(key);
                  }),
                  onMinus: () => setState(() {
                    _qty[key] = ((_qty[key] ?? 1) - 1).clamp(1, 99);
                  }),
                  onPlus: () => setState(() {
                    _qty[key] = ((_qty[key] ?? 1) + 1).clamp(1, 99);
                  }),
                  onAdd: () => _addProduct(p),
                );
              },
            );
          })),
      ]),
    );
  }
}

class _FilterHeading extends StatelessWidget {
  final String title;
  const _FilterHeading(this.title);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 17,
          fontWeight: FontWeight.w800, color: ProductListStyle.text)),
        const SizedBox(height: 12),
        const Divider(height: 1, color: ProductListStyle.border),
      ]),
  );
}

class _ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final String Function(double) money;
  final double price;
  final int quantity;
  final String? selectedWeight;
  final ValueChanged<String?> onWeightChanged;
  final bool favorite;
  final bool adding;
  final bool added;
  final VoidCallback onFavorite;
  final VoidCallback onMinus;
  final VoidCallback onPlus;
  final VoidCallback onAdd;

  const _ProductCard({
    required this.product,
    required this.money,
    required this.price,
    required this.quantity,
    required this.selectedWeight,
    required this.onWeightChanged,
    required this.favorite,
    required this.adding,
    required this.added,
    required this.onFavorite,
    required this.onMinus,
    required this.onPlus,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final name = product['name']?.toString() ?? 'Product';
    final url = product['imageUrl']?.toString() ?? '';
    final rating = double.tryParse(product['rating']?.toString() ?? '') ?? 0;
    final days = product['deliveryDays'];
    final weights = (product['weights'] is List &&
        (product['weights'] as List).isNotEmpty)
      ? (product['weights'] as List).map((e) => e.toString()).toList()
      : [product['weight']?.toString() ?? '1 Kg'];
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ProductListStyle.border),
        boxShadow: const [BoxShadow(color: Color(0x09000000),
          blurRadius: 5, offset: Offset(0, 2))],
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(children: [
              SizedBox(height: 130, width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: url.isEmpty
                    ? const Icon(Icons.inventory_2_outlined,
                        color: ProductListStyle.green, size: 65)
                    : (url.startsWith('http')
                      ? Image.network(url, fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) =>
                            const Icon(Icons.image_not_supported_outlined))
                      : Image.asset(url, fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) =>
                            const Icon(Icons.image_not_supported_outlined))),
                ),
              ),
              Positioned(top: 0, right: 0,
                child: IconButton(
                  onPressed: onFavorite,
                  icon: Icon(favorite ? Icons.favorite : Icons.favorite_border,
                    color: favorite ? ProductListStyle.green :
                      const Color(0xFF9A9E9A), size: 27),
                ),
              ),
            ]),
            const SizedBox(height: 8),
            SizedBox(height: 42,
              child: Text(name, maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: ProductListStyle.productNameSize,
                  height: 1.3,
                  fontWeight: FontWeight.w700,
                  color: ProductListStyle.text))),
            Row(mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) => Icon(
                i < rating.floor()
                  ? Icons.star_rounded
                  : (rating - i >= .5 ? Icons.star_half_rounded
                      : Icons.star_border_rounded),
                color: ProductListStyle.orange, size: 19,
              ))),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              height: 38,
              padding: const EdgeInsets.symmetric(horizontal: 9),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFBCC5BF)),
                borderRadius: BorderRadius.circular(6),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: weights.contains(selectedWeight)
                    ? selectedWeight : weights.first,
                  style: const TextStyle(color: ProductListStyle.text,
                    fontSize: 12),
                  items: weights.map((w) => DropdownMenuItem<String>(
                    value: w, child: Text('$w - ${money(price)}',
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  )).toList(),
                  onChanged: onWeightChanged, // Price/variant API can be wired here.
                ),
              ),
            ),
            const SizedBox(height: 7),
            Text(money(price), maxLines: 1,
              style: const TextStyle(fontSize: ProductListStyle.priceSize,
                color: ProductListStyle.text,
                fontWeight: FontWeight.w800)),
            const SizedBox(height: 7),
            Row(children: [
              const Icon(Icons.local_shipping_outlined, size: 16,
                color: ProductListStyle.green),
              const SizedBox(width: 3),
              Expanded(child: Text(
                days == null ? 'Delivery details available at checkout'
                  : 'Delivery in $days days',
                maxLines: 1, overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: ProductListStyle.green,
                  fontSize: 10.5)),
              ),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(flex: 5,
                child: Container(
                  height: 38,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFB5BBB6)),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(onTap: onMinus,
                        child: const Icon(Icons.remove, size: 17)),
                      Text('$quantity', style: const TextStyle(
                        fontWeight: FontWeight.w700)),
                      InkWell(onTap: onPlus,
                        child: const Icon(Icons.add, size: 17)),
                    ]),
                )),
              const SizedBox(width: 5),
              Expanded(flex: 4,
                child: SizedBox(height: 38,
                  child: ElevatedButton(
                    onPressed: adding || added ? null : onAdd,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: ProductListStyle.green,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: ProductListStyle.deepGreen,
                      disabledForegroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    ),
                    child: adding
                      ? const SizedBox(height: 17, width: 17,
                          child: CircularProgressIndicator(strokeWidth: 2,
                            color: Colors.white))
                      : Text(added ? 'ADDED' : 'ADD',
                          style: const TextStyle(fontWeight: FontWeight.w800,
                            fontSize: 12)),
                  ),
                )),
            ]),
          ],
        ),
      ),
    );
  }
}
