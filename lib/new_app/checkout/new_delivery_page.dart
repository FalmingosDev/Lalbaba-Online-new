// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// import '../new_auth/bottomnavigation.dart';
// import '../constant/constantcolour.dart';
// import '../constant/new_constant_checkout_page.dart';
// import '../constant/new_constant_text_styles.dart';

// import '../../app/router/route_names.dart';
// import '../../features/address/data/models/address_model.dart';
// import '../../core/services/cart_notification_item.dart';
// import '../../core/services/cart_service.dart';
// import '../../core/widgets/app_shimmer.dart';

// // ============================================================
// // DELIVERY TYPE
// // ============================================================

// enum DeliveryType { homeDelivery, localPickup }

// // ============================================================
// // PICKUP POINT MODEL
// // ============================================================

// class PickupPoint {
//   final String name;
//   final String address;
//   final String phone;

//   const PickupPoint({
//     required this.name,
//     required this.address,
//     required this.phone,
//   });
// }

// // ============================================================
// // NEW DELIVERY PAGE
// // ============================================================

// class NewDeliveryPage extends StatefulWidget {
//   final AddressModel? shippingAddress;

//   final VoidCallback? onContinueToPayment;

//   final List<PickupPoint>? pickupPoints;

//   final void Function(DeliveryType deliveryType, PickupPoint? pickupPoint)?
//   onDeliverySelected;

//   const NewDeliveryPage({
//     super.key,
//     this.shippingAddress,
//     this.onContinueToPayment,
//     this.pickupPoints,
//     this.onDeliverySelected,
//   });

//   @override
//   State<NewDeliveryPage> createState() => _NewDeliveryPageState();
// }

// class _NewDeliveryPageState extends State<NewDeliveryPage> {
//   // ==========================================================
//   // VARIABLES
//   // ==========================================================

//   DeliveryType _selectedDeliveryType = DeliveryType.homeDelivery;

//   PickupPoint? _selectedPickupPoint;

//   bool _isPickupListOpen = false;
//   bool _isLoading = true;
//   bool _isUpdatingCart = false;
//   bool _hasLoadError = false;

//   final TextEditingController _searchController = TextEditingController();

//   String _searchQuery = '';

//   // ==========================================================
//   // DEFAULT PICKUP POINTS
//   // ==========================================================

//   static const List<PickupPoint> _defaultPickupPoints = [
//     PickupPoint(
//       name: 'Office Premises Store',
//       address: 'City Tower, Ground Floor 70, G.T. Road, Badamtala More',
//       phone: '9999988888',
//     ),
//     PickupPoint(
//       name: 'Main Warehouse',
//       address: 'Main Road, Kolkata, West Bengal',
//       phone: '9876543210',
//     ),
//     PickupPoint(
//       name: 'Local Pickup Store',
//       address: 'Station Road, Kolkata, West Bengal',
//       phone: '9123456789',
//     ),
//   ];

//   List<PickupPoint> get _pickupPoints {
//     return widget.pickupPoints ?? _defaultPickupPoints;
//   }

//   // ==========================================================
//   // FILTER PICKUP POINTS
//   // ==========================================================

//   List<PickupPoint> get _filteredPickupPoints {
//     final query = _searchQuery.trim().toLowerCase();

//     if (query.isEmpty) {
//       return _pickupPoints;
//     }

//     return _pickupPoints.where((point) {
//       return point.name.toLowerCase().contains(query) ||
//           point.address.toLowerCase().contains(query) ||
//           point.phone.contains(query);
//     }).toList();
//   }

//   // ==========================================================
//   // INITIALIZE
//   // ==========================================================

//   @override
//   void initState() {
//     super.initState();
//     _initializeCart();
//   }

//   // ==========================================================
//   // INITIALIZE CART
//   // ==========================================================

//   Future<void> _initializeCart() async {
//     setState(() {
//       _isLoading = true;
//       _hasLoadError = false;
//     });

//     try {
//       await CartService.initialize();

//       if (!mounted) return;

//       setState(() {
//         _isLoading = false;
//       });
//     } catch (error) {
//       if (!mounted) return;

//       setState(() {
//         _isLoading = false;
//         _hasLoadError = true;
//       });

//       debugPrint('Delivery cart loading error: $error');
//     }
//   }

//   // ==========================================================
//   // DISPOSE
//   // ==========================================================

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   // ==========================================================
//   // CONTINUE BUTTON VALIDATION
//   // ==========================================================

//   bool get _canContinue {
//     if (_isLoading ||
//         _hasLoadError ||
//         _isUpdatingCart ||
//         CartService.items.value.isEmpty) {
//       return false;
//     }

//     if (_selectedDeliveryType == DeliveryType.homeDelivery) {
//       return true;
//     }

//     return _selectedPickupPoint != null;
//   }

//   // ==========================================================
//   // SHOW MESSAGE
//   // ==========================================================

//   void _showMessage(String message, {bool isError = false}) {
//     if (!mounted) return;

//     ScaffoldMessenger.of(context)
//       ..hideCurrentSnackBar()
//       ..showSnackBar(
//         SnackBar(
//           backgroundColor: isError ? HomeColors.error : HomeColors.secondary,

//           content: Text(
//             message,

//             style: HomeTextStyles.body.copyWith(color: HomeColors.white),
//           ),
//         ),
//       );
//   }

//   // ==========================================================
//   // PRICE PARSER
//   // ==========================================================

//   double _parsePrice(dynamic value) {
//     if (value == null) return 0;

//     if (value is num) {
//       return value.toDouble();
//     }

//     final cleaned = value
//         .toString()
//         .replaceAll(',', '')
//         .replaceAll(RegExp(r'[^0-9.]'), '');

//     return double.tryParse(cleaned) ?? 0;
//   }

//   // ==========================================================
//   // PRICE FORMAT
//   // ==========================================================

//   String _formatPrice(double value) {
//     final fixed = value.toStringAsFixed(2);

//     final parts = fixed.split('.');

//     final integerPart = parts[0];

//     final decimalPart = parts.length > 1 ? parts[1] : '00';

//     final buffer = StringBuffer();

//     for (int i = 0; i < integerPart.length; i++) {
//       buffer.write(integerPart[i]);

//       final remaining = integerPart.length - i - 1;

//       if (remaining > 0 && remaining % 3 == 0) {
//         buffer.write(',');
//       }
//     }

//     return '${buffer.toString()}.$decimalPart';
//   }

//   // ==========================================================
//   // CART UPDATE
//   // ==========================================================

//   Future<void> _updateCart(Future<void> Function() action) async {
//     if (_isUpdatingCart) return;

//     setState(() {
//       _isUpdatingCart = true;
//     });

//     try {
//       await action();
//     } catch (error) {
//       _showMessage('Unable to update cart. Please try again.', isError: true);

//       debugPrint('Cart update error: $error');
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isUpdatingCart = false;
//         });
//       }
//     }
//   }

//   // ==========================================================
//   // INCREASE QUANTITY
//   // ==========================================================

//   Future<void> _increaseQuantity(CartNotificationItem item) async {
//     await _updateCart(() async {
//       await CartService.increaseItemQuantity(item);
//     });
//   }

//   // ==========================================================
//   // DECREASE QUANTITY
//   // ==========================================================

//   Future<void> _decreaseQuantity(CartNotificationItem item) async {
//     if (item.quantity <= 1) return;

//     await _updateCart(() async {
//       await CartService.decreaseItemQuantity(item);
//     });
//   }

//   // ==========================================================
//   // REMOVE PRODUCT
//   // ==========================================================

//   Future<void> _removeProduct(CartNotificationItem item) async {
//     await _updateCart(() async {
//       await CartService.removeItem(item);
//     });
//   }

//   // ==========================================================
//   // SELECT HOME DELIVERY
//   // ==========================================================

//   void _selectHomeDelivery() {
//     FocusScope.of(context).unfocus();

//     setState(() {
//       _selectedDeliveryType = DeliveryType.homeDelivery;

//       _selectedPickupPoint = null;
//       _isPickupListOpen = false;

//       _searchController.clear();
//       _searchQuery = '';
//     });
//   }

//   // ==========================================================
//   // SELECT LOCAL PICKUP
//   // ==========================================================

//   void _selectLocalPickup() {
//     FocusScope.of(context).unfocus();

//     setState(() {
//       _selectedDeliveryType = DeliveryType.localPickup;

//       _isPickupListOpen = false;
//     });
//   }

//   // ==========================================================
//   // SELECT PICKUP POINT
//   // ==========================================================

//   void _selectPickupPoint(PickupPoint point) {
//     FocusScope.of(context).unfocus();

//     setState(() {
//       _selectedPickupPoint = point;

//       _isPickupListOpen = false;

//       _searchController.clear();

//       _searchQuery = '';
//     });
//   }

//   // ==========================================================
//   // CONTINUE TO PAYMENT
//   // ==========================================================

//   Future<void> _continueToPayment() async {
//     if (!_canContinue) return;

//     FocusScope.of(context).unfocus();

//     widget.onDeliverySelected?.call(
//       _selectedDeliveryType,
//       _selectedPickupPoint,
//     );

//     if (!mounted) return;

//     final onContinueToPayment = widget.onContinueToPayment;
//     if (onContinueToPayment != null) {
//       onContinueToPayment();
//       return;
//     }

//     await context.push<void>(RouteNames.newPayment);
//   }
//   // ==========================================================
//   // RETURN TO SHOP
//   // ==========================================================

//   void _returnToShop() {
//     FocusScope.of(context).unfocus();

//     Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
//       MaterialPageRoute<void>(builder: (_) => const BottomNavigationScreen()),
//       (route) => false,
//     );
//   }

//   // ==========================================================
//   // COMMON CARD DECORATION
//   // ==========================================================

//   BoxDecoration _cardDecoration({
//     double radius = 12,
//     Color backgroundColor = HomeColors.surface,
//     bool showShadow = false,
//   }) {
//     return BoxDecoration(
//       color: backgroundColor,

//       borderRadius: BorderRadius.circular(radius),

//       border: Border.all(color: HomeColors.border),

//       boxShadow: showShadow
//           ? [
//               BoxShadow(
//                 color: HomeColors.black.withValues(alpha: 0.05),

//                 blurRadius: 12,
                

//                 offset: const Offset(0, 4),
//               ),
//             ]
//           : null,
//     );
//   }

//   // ==========================================================
//   // MAIN BUILD
//   // ==========================================================

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: HomeColors.surface,

//       body: SafeArea(
//         child: ValueListenableBuilder<List<CartNotificationItem>>(
//           valueListenable: CartService.items,

//           builder: (context, cartItems, child) {
//             return LayoutBuilder(
//               builder: (context, constraints) {
//                 final double horizontalPadding = constraints.maxWidth <= 360
//                     ? 12
//                     : 16;

//                 return Column(
//                   children: [
//                     // ========================================
//                     // SCROLLABLE CONTENT
//                     // ========================================

//                     Expanded(
//                       child: SingleChildScrollView(
//                         keyboardDismissBehavior:
//                             ScrollViewKeyboardDismissBehavior.onDrag,

//                         padding: EdgeInsets.fromLTRB(
//                           horizontalPadding,
//                           16,
//                           horizontalPadding,
//                           30,
//                         ),

//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,

//                           children: [
//                             // ================================
//                             // CHECKOUT CONSTANT
//                             // DELIVERY INDEX = 2
//                             // ================================

//                             const NewConstantCheckout(
//                               currentIndex: NewConstantCheckout.delivery,
//                             ),

//                             const SizedBox(height: 24),

//                             // ================================
//                             // ORDER SUMMARY
//                             // ================================
//                             if (_isLoading)
//                               _buildProductShimmer()
//                             else if (_hasLoadError)
//                               _buildErrorState()
//                             else
//                               _buildOrderSummary(cartItems),

//                             const SizedBox(height: 24),

//                             // ================================
//                             // CHOOSE DELIVERY TYPE
//                             // ================================
//                             _buildDeliverySection(),

//                             const SizedBox(height: 30),
//                           ],
//                         ),
//                       ),
//                     ),

//                     // ========================================
//                     // FIXED BOTTOM CHECKOUT BUTTON
//                     // ========================================
//                     _buildBottomSection(),
//                   ],
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }

//   // ==========================================================
//   // ORDER SUMMARY
//   // ==========================================================

//   Widget _buildOrderSummary(List<CartNotificationItem> cartItems) {
//     final double subtotal = cartItems.fold<double>(
//       0,

//       (total, item) => total + (_parsePrice(item.price) * item.quantity),
//     );

//     return Container(
//       width: double.infinity,

//       decoration: _cardDecoration(radius: 16, showShadow: true),

//       clipBehavior: Clip.antiAlias,

//       child: Column(
//         mainAxisSize: MainAxisSize.min,

//         children: [
//           _buildSummaryHeader(cartItems.length),

//           const Divider(height: 1, thickness: 1, color: HomeColors.divider),

//           // EMPTY CART
//           if (cartItems.isEmpty) _buildEmptyCart(),

//           // PRODUCT LIST
//           if (cartItems.isNotEmpty)
//             Padding(
//               padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),

//               child: Column(
//                 children: List.generate(
//                   cartItems.length,

//                   (index) => Padding(
//                     padding: EdgeInsets.only(
//                       bottom: index == cartItems.length - 1 ? 0 : 12,
//                     ),

//                     child: _buildProductCard(cartItems[index]),
//                   ),
//                 ),
//               ),
//             ),

//           // SUBTOTAL
//           if (cartItems.isNotEmpty) _buildSubtotal(subtotal),
//         ],
//       ),
//     );
//   }

//   // ==========================================================
//   // ORDER SUMMARY HEADER
//   // ==========================================================

//   Widget _buildSummaryHeader(int itemCount) {
//     return Padding(
//       padding: const EdgeInsets.all(16),

//       child: Row(
//         children: [
//           Container(
//             width: 40,
//             height: 40,

//             alignment: Alignment.center,

//             decoration: BoxDecoration(
//               color: HomeColors.secondaryLight,

//               borderRadius: BorderRadius.circular(10),
//             ),

//             child: const Icon(
//               Icons.shopping_bag_outlined,
//               size: 22,
//               color: HomeColors.secondary,
//             ),
//           ),

//           const SizedBox(width: 12),

//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,

//               children: [
//                 Text(
//                   'Order Summary',

//                   style: HomeTextStyles.summaryTotalLabel.copyWith(
//                     color: HomeColors.textPrimary,
//                   ),
//                 ),

//                 const SizedBox(height: 3),

//                 Text(
//                   'Products in your cart',

//                   style: HomeTextStyles.caption.copyWith(
//                     color: HomeColors.textSecondary,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),

//             decoration: BoxDecoration(
//               color: HomeColors.disabledBackground,

//               borderRadius: BorderRadius.circular(20),
//             ),

//             child: Text(
//               '$itemCount ${itemCount == 1 ? 'Item' : 'Items'}',

//               style: HomeTextStyles.chip.copyWith(
//                 color: HomeColors.textSecondary,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ==========================================================
//   // PRODUCT CARD
//   // ==========================================================

//   Widget _buildProductCard(CartNotificationItem item) {
//     final double unitPrice = _parsePrice(item.price);

//     final double totalPrice = unitPrice * item.quantity;

//     return Container(
//       width: double.infinity,

//       padding: const EdgeInsets.all(16),

//       decoration: _cardDecoration(backgroundColor: HomeColors.background),

//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,

//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,

//             children: [
//               // PRODUCT ICON

//               Container(
//                 width: 42,
//                 height: 42,

//                 alignment: Alignment.center,

//                 decoration: _cardDecoration(radius: 10),

//                 child: const Icon(
//                   Icons.inventory_2_outlined,
//                   size: 21,
//                   color: HomeColors.textSecondary,
//                 ),
//               ),

//               const SizedBox(width: 12),

//               // PRODUCT NAME AND WEIGHT
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,

//                   children: [
//                     Text(
//                       item.name.trim(),

//                       maxLines: 2,

//                       overflow: TextOverflow.ellipsis,

//                       style: HomeTextStyles.bodyEmphasis.copyWith(
//                         height: 1.3,

//                         color: HomeColors.textPrimary,
//                       ),
//                     ),

//                     if (item.weight != null && item.weight!.trim().isNotEmpty)
//                       Padding(
//                         padding: const EdgeInsets.only(top: 4),

//                         child: Text(
//                           item.weight!.trim(),

//                           style: HomeTextStyles.caption.copyWith(
//                             color: HomeColors.textSecondary,
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//               ),

//               const SizedBox(width: 8),

//               // DELETE PRODUCT
//               _buildDeleteButton(item),
//             ],
//           ),

//           const SizedBox(height: 16),

//           const Divider(height: 1, color: HomeColors.divider),

//           const SizedBox(height: 12),

//           // ==================================================
//           // UNIT PRICE AND TOTAL
//           // ==================================================
//           Row(
//             children: [
//               Expanded(
//                 child: _buildPriceInfo(
//                   label: 'Unit Price',

//                   value: '₹${_formatPrice(unitPrice)}',
//                 ),
//               ),

//               Container(width: 1, height: 35, color: HomeColors.border),

//               const SizedBox(width: 16),

//               Expanded(
//                 child: _buildPriceInfo(
//                   label: 'Total',

//                   value: '₹${_formatPrice(totalPrice)}',

//                   isBold: true,
//                 ),
//               ),
//             ],
//           ),

//           const SizedBox(height: 12),

//           // ==================================================
//           // QUANTITY
//           // ==================================================
//           Row(
//             children: [
//               Text(
//                 'Quantity',

//                 style: HomeTextStyles.caption.copyWith(
//                   color: HomeColors.textSecondary,
//                 ),
//               ),

//               const Spacer(),

//               _buildQuantityControl(item),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   // ==========================================================
//   // PRICE INFORMATION
//   // ==========================================================

//   Widget _buildPriceInfo({
//     required String label,
//     required String value,
//     bool isBold = false,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,

//       children: [
//         Text(
//           label,

//           style: HomeTextStyles.caption.copyWith(
//             color: HomeColors.textSecondary,
//           ),
//         ),

//         const SizedBox(height: 4),

//         Text(
//           value,

//           style: HomeTextStyles.body.copyWith(
//             color: HomeColors.textPrimary,

//             fontWeight: isBold ? HomeTextStyles.bold : HomeTextStyles.semiBold,
//           ),
//         ),
//       ],
//     );
//   }

//   // ==========================================================
//   // QUANTITY CONTROL
//   // ==========================================================

//   Widget _buildQuantityControl(CartNotificationItem item) {
//     return Container(
//       height: 36,

//       decoration: _cardDecoration(radius: 8),

//       child: Row(
//         mainAxisSize: MainAxisSize.min,

//         children: [
//           // MINUS BUTTON

//           _buildQuantityButton(
//             icon: Icons.remove,

//             enabled: item.quantity > 1 && !_isUpdatingCart,

//             onTap: () => _decreaseQuantity(item),
//           ),

//           Container(width: 1, height: 22, color: HomeColors.divider),

//           // QUANTITY VALUE
//           SizedBox(
//             width: 38,

//             child: Center(
//               child: Text(
//                 '${item.quantity}',

//                 style: HomeTextStyles.bodyEmphasis.copyWith(
//                   color: HomeColors.textPrimary,
//                 ),
//               ),
//             ),
//           ),

//           Container(width: 1, height: 22, color: HomeColors.divider),

//           // PLUS BUTTON
//           _buildQuantityButton(
//             icon: Icons.add,

//             enabled: !_isUpdatingCart,

//             onTap: () => _increaseQuantity(item),
//           ),
//         ],
//       ),
//     );
//   }

//   // ==========================================================
//   // QUANTITY BUTTON
//   // ==========================================================

//   Widget _buildQuantityButton({
//     required IconData icon,
//     required VoidCallback onTap,
//     bool enabled = true,
//   }) {
//     return InkWell(
//       onTap: enabled ? onTap : null,

//       child: SizedBox(
//         width: 36,
//         height: 36,

//         child: Icon(
//           icon,

//           size: 17,

//           color: enabled ? HomeColors.textPrimary : HomeColors.disabled,
//         ),
//       ),
//     );
//   }

//   // ==========================================================
//   // DELETE PRODUCT BUTTON
//   // ==========================================================

//   Widget _buildDeleteButton(CartNotificationItem item) {
//     return Material(
//       color: HomeColors.secondaryLight,

//       borderRadius: BorderRadius.circular(9),

//       child: InkWell(
//         borderRadius: BorderRadius.circular(9),

//         onTap: _isUpdatingCart ? null : () => _removeProduct(item),

//         child: const SizedBox(
//           width: 34,
//           height: 34,

//           child: Icon(
//             Icons.delete_outline_rounded,

//             size: 19,

//             color: HomeColors.secondary,
//           ),
//         ),
//       ),
//     );
//   }

//   // ==========================================================
//   // SUBTOTAL
//   // ==========================================================

//   Widget _buildSubtotal(double subtotal) {
//     return Container(
//       width: double.infinity,

//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),

//       decoration: const BoxDecoration(
//         color: HomeColors.background,

//         border: Border(top: BorderSide(color: HomeColors.divider)),

//         borderRadius: BorderRadius.only(
//           bottomLeft: Radius.circular(16),
//           bottomRight: Radius.circular(16),
//         ),
//       ),

//       child: Row(
//         children: [
//           Expanded(
//             child: Text(
//               'Subtotal',

//               style: HomeTextStyles.button.copyWith(
//                 color: HomeColors.textSecondary,
//               ),
//             ),
//           ),

//           Text(
//             '₹${_formatPrice(subtotal)}',

//             style: HomeTextStyles.sectionTitleLarge.copyWith(
//               color: HomeColors.textPrimary,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ==========================================================
//   // EMPTY CART
//   // ==========================================================

//   Widget _buildEmptyCart() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),

//       child: Column(
//         children: [
//           const Icon(
//             Icons.shopping_cart_outlined,

//             size: 45,

//             color: HomeColors.disabled,
//           ),

//           const SizedBox(height: 10),

//           Text(
//             'Your cart is empty',

//             style: HomeTextStyles.bodyEmphasis.copyWith(
//               color: HomeColors.textSecondary,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ==========================================================
//   // DELIVERY SECTION
//   // ==========================================================

//   Widget _buildDeliverySection() {
//     return Container(
//       width: double.infinity,

//       padding: const EdgeInsets.all(16),

//       decoration: _cardDecoration(showShadow: true),

//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,

//         children: [
//           const Divider(height: 1, color: HomeColors.divider),

//           const SizedBox(height: 16),

//           Text(
//             'Choose Delivery Type',

//             style: HomeTextStyles.largePrice.copyWith(
//               color: HomeColors.textPrimary,

//               height: 1.25,
//             ),
//           ),

//           const SizedBox(height: 16),

//           // ==================================================
//           // DELIVERY TYPE OPTIONS
//           // ==================================================
//           LayoutBuilder(
//             builder: (context, constraints) {
//               final homeDeliveryCard = _buildDeliveryTypeCard(
//                 title: 'Home Delivery',

//                 selected: _selectedDeliveryType == DeliveryType.homeDelivery,

//                 onTap: _selectHomeDelivery,
//               );

//               final localPickupCard = _buildDeliveryTypeCard(
//                 title: 'Local Pickup',

//                 selected: _selectedDeliveryType == DeliveryType.localPickup,

//                 onTap: _selectLocalPickup,
//               );

//               // SMALL SCREEN

//               if (constraints.maxWidth < 340) {
//                 return Column(
//                   children: [
//                     homeDeliveryCard,

//                     const SizedBox(height: 12),

//                     localPickupCard,
//                   ],
//                 );
//               }

//               // LARGE SCREEN

//               return Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,

//                 children: [
//                   Expanded(child: homeDeliveryCard),

//                   const SizedBox(width: 12),

//                   Expanded(child: localPickupCard),
//                 ],
//               );
//             },
//           ),

//           // ==================================================
//           // LOCAL PICKUP LOCATION
//           // ==================================================
//           if (_selectedDeliveryType == DeliveryType.localPickup) ...[
//             const SizedBox(height: 16),

//             _buildPickupField(),

//             AnimatedSwitcher(
//               duration: const Duration(milliseconds: 220),

//               transitionBuilder: (child, animation) {
//                 return SizeTransition(
//                   sizeFactor: animation,

//                   axisAlignment: -1,

//                   child: FadeTransition(opacity: animation, child: child),
//                 );
//               },

//               child: _isPickupListOpen
//                   ? Padding(
//                       key: const ValueKey('pickup-list-open'),

//                       padding: const EdgeInsets.only(top: 8),

//                       child: _buildPickupDropdown(),
//                     )
//                   : const SizedBox.shrink(key: ValueKey('pickup-list-closed')),
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   // ==========================================================
//   // DELIVERY TYPE CARD
//   // ==========================================================

//   Widget _buildDeliveryTypeCard({
//     required String title,
//     required bool selected,
//     required VoidCallback onTap,
//   }) {
//     return Material(
//       color: HomeColors.surface,

//       borderRadius: BorderRadius.circular(6),

//       child: InkWell(
//         onTap: onTap,

//         borderRadius: BorderRadius.circular(6),

//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 180),

//           width: double.infinity,

//           constraints: const BoxConstraints(minHeight: 72),

//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),

//           decoration: BoxDecoration(
//             color: HomeColors.surface,

//             borderRadius: BorderRadius.circular(6),

//             border: Border.all(
//               color: selected ? HomeColors.secondary : HomeColors.border,

//               width: selected ? 1.5 : 1,
//             ),
//           ),

//           child: Row(
//             children: [
//               // CUSTOM RADIO BUTTON

//               Container(
//                 width: 23,
//                 height: 23,

//                 padding: const EdgeInsets.all(5),

//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,

//                   border: Border.all(
//                     color: selected ? HomeColors.secondary : HomeColors.border,

//                     width: 1.4,
//                   ),
//                 ),

//                 child: AnimatedContainer(
//                   duration: const Duration(milliseconds: 180),

//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,

//                     color: selected ? HomeColors.secondary : HomeColors.surface,
//                   ),
//                 ),
//               ),

//               const SizedBox(width: 12),

//               Expanded(
//                 child: Text(
//                   title,

//                   softWrap: true,

//                   style: HomeTextStyles.button.copyWith(
//                     color: HomeColors.textPrimary,

//                     height: 1.3,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // ==========================================================
//   // PICKUP FIELD
//   // ==========================================================

//   Widget _buildPickupField() {
//     return Material(
//       color: HomeColors.surface,

//       borderRadius: BorderRadius.circular(6),

//       child: InkWell(
//         borderRadius: BorderRadius.circular(6),

//         onTap: () {
//           FocusScope.of(context).unfocus();

//           setState(() {
//             _isPickupListOpen = !_isPickupListOpen;

//             if (_isPickupListOpen) {
//               _searchController.clear();

//               _searchQuery = '';
//             }
//           });
//         },

//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 180),

//           width: double.infinity,

//           constraints: const BoxConstraints(minHeight: 58),

//           padding: const EdgeInsets.all(12),

//           decoration: BoxDecoration(
//             color: HomeColors.surface,

//             borderRadius: BorderRadius.circular(6),

//             border: Border.all(
//               color: _isPickupListOpen
//                   ? HomeColors.secondary
//                   : HomeColors.border,

//               width: _isPickupListOpen ? 1.5 : 1,
//             ),
//           ),

//           child: Row(
//             children: [
//               Icon(
//                 Icons.store_mall_directory_outlined,

//                 size: 21,

//                 color: _selectedPickupPoint == null
//                     ? HomeColors.textSecondary
//                     : HomeColors.secondary,
//               ),

//               const SizedBox(width: 10),

//               Expanded(
//                 child: _selectedPickupPoint == null
//                     ? Text(
//                         'Select your nearest pickup point',

//                         style: HomeTextStyles.body.copyWith(
//                           color: HomeColors.textSecondary,

//                           height: 1.3,
//                         ),
//                       )
//                     : Column(
//                         mainAxisSize: MainAxisSize.min,

//                         crossAxisAlignment: CrossAxisAlignment.start,

//                         children: [
//                           Text(
//                             _selectedPickupPoint!.name,

//                             style: HomeTextStyles.bodyEmphasis.copyWith(
//                               color: HomeColors.textPrimary,

//                               fontWeight: HomeTextStyles.bold,
//                             ),
//                           ),

//                           const SizedBox(height: 4),

//                           Text(
//                             _selectedPickupPoint!.address,

//                             style: HomeTextStyles.caption.copyWith(
//                               color: HomeColors.textSecondary,

//                               height: 1.35,
//                             ),
//                           ),
//                         ],
//                       ),
//               ),

//               const SizedBox(width: 8),

//               AnimatedRotation(
//                 turns: _isPickupListOpen ? 0.5 : 0,

//                 duration: const Duration(milliseconds: 180),

//                 child: const Icon(
//                   Icons.keyboard_arrow_down_rounded,

//                   size: 27,

//                   color: HomeColors.textPrimary,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // ==========================================================
//   // PICKUP DROPDOWN
//   // ==========================================================

//   Widget _buildPickupDropdown() {
//     final filteredPoints = _filteredPickupPoints;

//     return Container(
//       width: double.infinity,

//       constraints: const BoxConstraints(maxHeight: 340),

//       decoration: _cardDecoration(radius: 6, showShadow: true),

//       clipBehavior: Clip.antiAlias,

//       child: Column(
//         mainAxisSize: MainAxisSize.min,

//         children: [
//           // ==================================================
//           // SEARCH PICKUP LOCATION
//           // ==================================================

//           Padding(
//             padding: const EdgeInsets.all(10),

//             child: TextField(
//               controller: _searchController,

//               autofocus: false,

//               cursorColor: HomeColors.secondary,

//               textInputAction: TextInputAction.search,

//               onChanged: (value) {
//                 setState(() {
//                   _searchQuery = value;
//                 });
//               },

//               style: HomeTextStyles.body.copyWith(
//                 color: HomeColors.textPrimary,
//               ),

//               decoration: InputDecoration(
//                 hintText: 'Search pickup point',

//                 hintStyle: HomeTextStyles.body.copyWith(
//                   color: HomeColors.textSecondary,
//                 ),

//                 prefixIcon: const Icon(
//                   Icons.search_rounded,

//                   size: 21,

//                   color: HomeColors.textSecondary,
//                 ),

//                 suffixIcon: _searchQuery.isEmpty
//                     ? null
//                     : IconButton(
//                         onPressed: () {
//                           _searchController.clear();

//                           setState(() {
//                             _searchQuery = '';
//                           });
//                         },

//                         icon: const Icon(
//                           Icons.close_rounded,

//                           size: 20,

//                           color: HomeColors.textSecondary,
//                         ),
//                       ),

//                 filled: true,

//                 fillColor: HomeColors.surface,

//                 contentPadding: const EdgeInsets.symmetric(
//                   horizontal: 12,

//                   vertical: 12,
//                 ),

//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(6),

//                   borderSide: const BorderSide(color: HomeColors.border),
//                 ),

//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(6),

//                   borderSide: const BorderSide(
//                     color: HomeColors.secondary,

//                     width: 1.4,
//                   ),
//                 ),
//               ),
//             ),
//           ),

//           // ==================================================
//           // DROPDOWN HEADER
//           // ==================================================
//           Container(
//             width: double.infinity,

//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),

//             color: HomeColors.secondary,

//             child: Text(
//               'Select your nearest pickup point',

//               style: HomeTextStyles.bodySmall.copyWith(
//                 fontWeight: HomeTextStyles.semiBold,

//                 color: HomeColors.white,

//                 height: 1.3,
//               ),
//             ),
//           ),

//           // ==================================================
//           // PICKUP POINT LIST
//           // ==================================================
//           Flexible(
//             child: filteredPoints.isEmpty
//                 ? Padding(
//                     padding: const EdgeInsets.all(20),

//                     child: Center(
//                       child: Text(
//                         'No pickup point found',

//                         textAlign: TextAlign.center,

//                         style: HomeTextStyles.bodySmall.copyWith(
//                           color: HomeColors.textSecondary,
//                         ),
//                       ),
//                     ),
//                   )
//                 : ListView.separated(
//                     padding: EdgeInsets.zero,

//                     shrinkWrap: true,

//                     keyboardDismissBehavior:
//                         ScrollViewKeyboardDismissBehavior.onDrag,

//                     itemCount: filteredPoints.length,

//                     separatorBuilder: (context, index) {
//                       return const Divider(
//                         height: 1,

//                         color: HomeColors.divider,
//                       );
//                     },

//                     itemBuilder: (context, index) {
//                       return _buildPickupItem(filteredPoints[index]);
//                     },
//                   ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ==========================================================
//   // PICKUP LOCATION ITEM
//   // ==========================================================

//   Widget _buildPickupItem(PickupPoint point) {
//     final bool isSelected = _selectedPickupPoint == point;

//     return Material(
//       color: isSelected ? HomeColors.secondaryLight : HomeColors.surface,

//       child: InkWell(
//         onTap: () => _selectPickupPoint(point),

//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(12, 12, 12, 13),

//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,

//             children: [
//               // STORE NAME

//               Row(
//                 children: [
//                   Expanded(
//                     child: Text(
//                       point.name,

//                       style: HomeTextStyles.bodyEmphasis.copyWith(
//                         fontWeight: HomeTextStyles.bold,

//                         color: HomeColors.textPrimary,

//                         height: 1.3,
//                       ),
//                     ),
//                   ),

//                   if (isSelected)
//                     const Icon(
//                       Icons.check_circle_rounded,

//                       size: 19,

//                       color: HomeColors.secondary,
//                     ),
//                 ],
//               ),

//               const SizedBox(height: 8),

//               // STORE ADDRESS
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,

//                 children: [
//                   const Icon(
//                     Icons.location_on_outlined,

//                     size: 19,

//                     color: HomeColors.textSecondary,
//                   ),

//                   const SizedBox(width: 6),

//                   Expanded(
//                     child: Text(
//                       point.address,

//                       style: HomeTextStyles.bodySmall.copyWith(
//                         color: HomeColors.textSecondary,

//                         height: 1.4,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 7),

//               // STORE PHONE NUMBER
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,

//                 children: [
//                   const Icon(
//                     Icons.phone_outlined,

//                     size: 18,

//                     color: HomeColors.textSecondary,
//                   ),

//                   const SizedBox(width: 6),

//                   Expanded(
//                     child: Text(
//                       point.phone,

//                       style: HomeTextStyles.bodySmall.copyWith(
//                         color: HomeColors.textSecondary,

//                         height: 1.3,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // ==========================================================
//   // COMMON FIXED BOTTOM CHECKOUT BUTTON
//   // ==========================================================

//   Widget _buildBottomSection() {
//     return NewCheckoutBottomBar(
//       currentIndex: NewConstantCheckout.delivery,

//       onContinue: _canContinue ? _continueToPayment : null,

//       onReturnToShop: _returnToShop,
//     );
//   }

//   // ==========================================================
//   // PRODUCT LOADING SHIMMER
//   // ==========================================================

//   Widget _buildProductShimmer() {
//     return Container(
//       width: double.infinity,

//       padding: const EdgeInsets.all(16),

//       decoration: _cardDecoration(radius: 16),

//       child: const Column(
//         crossAxisAlignment: CrossAxisAlignment.start,

//         children: [
//           Row(
//             children: [
//               AppShimmer(width: 40, height: 40, radius: 10),

//               SizedBox(width: 12),

//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,

//                   children: [
//                     AppShimmer(width: 140, height: 15, radius: 6),

//                     SizedBox(height: 4),

//                     AppShimmer(width: 90, height: 11, radius: 6),
//                   ],
//                 ),
//               ),

//               AppShimmer(width: 50, height: 20, radius: 12),
//             ],
//           ),

//           SizedBox(height: 24),

//           AppShimmer(height: 110, radius: 12),

//           SizedBox(height: 12),

//           AppShimmer(height: 110, radius: 12),

//           SizedBox(height: 12),

//           Row(
//             children: [
//               AppShimmer(width: 80, height: 16, radius: 6),

//               Spacer(),

//               AppShimmer(width: 90, height: 20, radius: 6),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   // ==========================================================
//   // ERROR STATE
//   // ==========================================================

//   Widget _buildErrorState() {
//     return Container(
//       width: double.infinity,

//       padding: const EdgeInsets.all(24),

//       decoration: _cardDecoration(radius: 16),

//       child: Column(
//         children: [
//           const Icon(Icons.error_outline, size: 40, color: HomeColors.error),

//           const SizedBox(height: 12),

//           Text(
//             'Something went wrong while loading your cart.',

//             textAlign: TextAlign.center,

//             style: HomeTextStyles.body.copyWith(
//               color: HomeColors.textSecondary,
//             ),
//           ),

//           const SizedBox(height: 12),

//           TextButton(
//             onPressed: _initializeCart,

//             child: Text(
//               'Retry',

//               style: HomeTextStyles.button.copyWith(
//                 color: HomeColors.secondary,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }





import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../new_auth/bottomnavigation.dart';
import '../constant/constantcolour.dart';
import '../constant/new_constant_checkout_page.dart';
import '../constant/new_constant_text_styles.dart';

import '../../app/router/route_names.dart';
import '../../features/address/data/models/address_model.dart';
import '../../core/services/cart_notification_item.dart';
import '../../core/services/cart_service.dart';
import '../../core/widgets/app_shimmer.dart';

// ============================================================
// DELIVERY TYPE
// ============================================================

enum DeliveryType {
  homeDelivery,
  localPickup,
}

// ============================================================
// PICKUP POINT MODEL
// ============================================================

class PickupPoint {
  final String name;
  final String address;
  final String phone;

  const PickupPoint({
    required this.name,
    required this.address,
    required this.phone,
  });
}

// ============================================================
// NEW DELIVERY PAGE
// ============================================================

class NewDeliveryPage extends StatefulWidget {
  final AddressModel? shippingAddress;

  final VoidCallback? onContinueToPayment;

  final List<PickupPoint>? pickupPoints;

  final void Function(
    DeliveryType deliveryType,
    PickupPoint? pickupPoint,
  )? onDeliverySelected;

  const NewDeliveryPage({
    super.key,
    this.shippingAddress,
    this.onContinueToPayment,
    this.pickupPoints,
    this.onDeliverySelected,
  });

  @override
  State<NewDeliveryPage> createState() =>
      _NewDeliveryPageState();
}

// ============================================================
// DELIVERY PAGE STATE
// ============================================================

class _NewDeliveryPageState
    extends State<NewDeliveryPage> {

  // ==========================================================
  // DELIVERY STATE
  // ==========================================================

  DeliveryType _selectedDeliveryType =
      DeliveryType.homeDelivery;

  PickupPoint? _selectedPickupPoint;

  bool _isPickupListOpen = false;
  bool _isLoading = true;
  bool _isUpdatingCart = false;
  bool _hasLoadError = false;

  final TextEditingController _searchController =
      TextEditingController();

  String _searchQuery = '';

  // ==========================================================
  // DEFAULT PICKUP POINTS
  // ==========================================================

  static const List<PickupPoint> _defaultPickupPoints = [
    PickupPoint(
      name: 'Office Premises Store',
      address:
          'City Tower, Ground Floor 70, G.T. Road, Badamtala More',
      phone: '9999988888',
    ),
    PickupPoint(
      name: 'Main Warehouse',
      address: 'Main Road, Kolkata, West Bengal',
      phone: '9876543210',
    ),
    PickupPoint(
      name: 'Local Pickup Store',
      address: 'Station Road, Kolkata, West Bengal',
      phone: '9123456789',
    ),
  ];

  List<PickupPoint> get _pickupPoints {
    return widget.pickupPoints ?? _defaultPickupPoints;
  }

  // ==========================================================
  // FILTER PICKUP POINTS
  // ==========================================================

  List<PickupPoint> get _filteredPickupPoints {
    final String query =
        _searchQuery.trim().toLowerCase();

    if (query.isEmpty) {
      return _pickupPoints;
    }

    return _pickupPoints.where((point) {
      return point.name.toLowerCase().contains(query) ||
          point.address.toLowerCase().contains(query) ||
          point.phone.contains(query);
    }).toList();
  }

  // ==========================================================
  // INIT
  // ==========================================================

  @override
  void initState() {
    super.initState();
    _initializeCart();
  }

  // ==========================================================
  // DISPOSE
  // ==========================================================

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ==========================================================
  // INITIALIZE CART
  // ==========================================================

  Future<void> _initializeCart() async {
    setState(() {
      _isLoading = true;
      _hasLoadError = false;
    });

    try {
      await CartService.initialize();

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      debugPrint(
        'Delivery cart loading error: $error',
      );

      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _hasLoadError = true;
      });
    }
  }

  // ==========================================================
  // CONTINUE VALIDATION
  // ==========================================================

  bool get _canContinue {
    if (_isLoading ||
        _hasLoadError ||
        _isUpdatingCart ||
        CartService.items.value.isEmpty) {
      return false;
    }

    if (_selectedDeliveryType ==
        DeliveryType.homeDelivery) {
      return true;
    }

    return _selectedPickupPoint != null;
  }

  // ==========================================================
  // SHOW MESSAGE
  // ==========================================================

  void _showMessage(
    String message, {
    bool isError = false,
  }) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: isError
              ? HomeColors.error
              : HomeColors.secondary,
          behavior: SnackBarBehavior.floating,
          content: Text(
            message,
            style: HomeTextStyles.body.copyWith(
              color: HomeColors.white,
            ),
          ),
        ),
      );
  }

  // ==========================================================
  // PRICE PARSER
  // ==========================================================

  double _parsePrice(dynamic value) {
    if (value == null) return 0;

    if (value is num) {
      return value.toDouble();
    }

    final cleaned = value
        .toString()
        .replaceAll(',', '')
        .replaceAll(RegExp(r'[^0-9.]'), '');

    return double.tryParse(cleaned) ?? 0;
  }

  // ==========================================================
  // PRICE FORMAT
  // ==========================================================

  String _formatPrice(double value) {
    final String fixed = value.toStringAsFixed(2);

    final List<String> parts = fixed.split('.');

    final String integerPart = parts[0];

    final String decimalPart =
        parts.length > 1 ? parts[1] : '00';

    final buffer = StringBuffer();

    for (int i = 0; i < integerPart.length; i++) {
      buffer.write(integerPart[i]);

      final remaining = integerPart.length - i - 1;

      if (remaining > 0 && remaining % 3 == 0) {
        buffer.write(',');
      }
    }

    return '${buffer.toString()}.$decimalPart';
  }

  // ==========================================================
  // CART UPDATE
  // ==========================================================

  Future<void> _updateCart(
    Future<void> Function() action,
  ) async {
    if (_isUpdatingCart) return;

    setState(() {
      _isUpdatingCart = true;
    });

    try {
      await action();
    } catch (error) {
      debugPrint('Cart update error: $error');

      _showMessage(
        'Unable to update cart. Please try again.',
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUpdatingCart = false;
        });
      }
    }
  }

  // ==========================================================
  // INCREASE QUANTITY
  // ==========================================================

  Future<void> _increaseQuantity(
    CartNotificationItem item,
  ) async {
    await _updateCart(() async {
      await CartService.increaseItemQuantity(item);
    });
  }

  // ==========================================================
  // DECREASE QUANTITY
  // ==========================================================

  Future<void> _decreaseQuantity(
    CartNotificationItem item,
  ) async {
    if (item.quantity <= 1) return;

    await _updateCart(() async {
      await CartService.decreaseItemQuantity(item);
    });
  }

  // ==========================================================
  // DELETE PRODUCT
  // ==========================================================

  Future<void> _removeProduct(
    CartNotificationItem item,
  ) async {
    await _updateCart(() async {
      await CartService.removeItem(item);
    });
  }

  // ==========================================================
  // SELECT HOME DELIVERY
  // ==========================================================

  void _selectHomeDelivery() {
    FocusScope.of(context).unfocus();

    setState(() {
      _selectedDeliveryType =
          DeliveryType.homeDelivery;

      _selectedPickupPoint = null;
      _isPickupListOpen = false;

      _searchController.clear();
      _searchQuery = '';
    });
  }

  // ==========================================================
  // SELECT LOCAL PICKUP
  // ==========================================================

  void _selectLocalPickup() {
    FocusScope.of(context).unfocus();

    setState(() {
      _selectedDeliveryType =
          DeliveryType.localPickup;

      _isPickupListOpen = false;
    });
  }

  // ==========================================================
  // SELECT PICKUP POINT
  // ==========================================================

  void _selectPickupPoint(PickupPoint point) {
    FocusScope.of(context).unfocus();

    setState(() {
      _selectedPickupPoint = point;
      _isPickupListOpen = false;

      _searchController.clear();
      _searchQuery = '';
    });
  }

  // ==========================================================
  // CONTINUE TO PAYMENT
  // ==========================================================

  Future<void> _continueToPayment() async {
    if (!_canContinue) return;

    FocusScope.of(context).unfocus();

    widget.onDeliverySelected?.call(
      _selectedDeliveryType,
      _selectedPickupPoint,
    );

    if (!mounted) return;

    final callback = widget.onContinueToPayment;

    if (callback != null) {
      callback();
      return;
    }

    await context.push<void>(
      RouteNames.newPayment,
    );
  }

  // ==========================================================
  // RETURN TO SHOP
  // ==========================================================

  void _returnToShop() {
    FocusScope.of(context).unfocus();

    Navigator.of(
      context,
      rootNavigator: true,
    ).pushAndRemoveUntil(
      MaterialPageRoute<void>(
        builder: (_) =>
            const BottomNavigationScreen(),
      ),
      (route) => false,
    );
  }

  // ==========================================================
  // COMMON CARD DECORATION
  // ==========================================================

  BoxDecoration _cardDecoration({
    double radius = 16,
    bool showShadow = true,
    bool showBorder = false,
  }) {
    return BoxDecoration(
      color: HomeColors.surface,

      borderRadius: BorderRadius.circular(radius),

      border: showBorder
          ? Border.all(
              color: HomeColors.border,
              width: 1,
            )
          : null,

      boxShadow: showShadow
          ? [
              BoxShadow(
                color: HomeColors.black.withValues(
                  alpha: 0.06,
                ),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ]
          : null,
    );
  }

  // ==========================================================
  // MAIN BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HomeColors.background,

      body: SafeArea(
        child: ValueListenableBuilder<
            List<CartNotificationItem>>(
          valueListenable: CartService.items,

          builder: (context, cartItems, child) {
            return LayoutBuilder(
              builder: (context, constraints) {
                final horizontalPadding =
                    constraints.maxWidth <= 360
                        ? 12.0
                        : 16.0;

                return Column(
                  children: [
                    // ======================================
                    // SCROLLABLE CONTENT
                    // ======================================

                    Expanded(
                      child: SingleChildScrollView(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior
                                .onDrag,

                        padding: EdgeInsets.fromLTRB(
                          horizontalPadding,
                          16,
                          horizontalPadding,
                          30,
                        ),

                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [
                            // CHECKOUT PROGRESS
                            const NewConstantCheckout(
                              currentIndex:
                                  NewConstantCheckout.delivery,
                            ),

                            const SizedBox(height: 22),

                            // ORDER SUMMARY
                            if (_isLoading)
                              _buildProductShimmer()
                            else if (_hasLoadError)
                              _buildErrorState()
                            else
                              _buildOrderSummary(
                                cartItems,
                              ),

                            const SizedBox(height: 20),

                            // DELIVERY TYPE
                            _buildDeliverySection(),

                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),

                    // ======================================
                    // FIXED BOTTOM BUTTONS
                    // ======================================

                    _buildBottomSection(),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  // ==========================================================
  // ORDER SUMMARY CARD
  // ==========================================================

  Widget _buildOrderSummary(
    List<CartNotificationItem> cartItems,
  ) {
    final double subtotal = cartItems.fold<double>(
      0,
      (total, item) {
        return total +
            (_parsePrice(item.price) * item.quantity);
      },
    );

    return Container(
      width: double.infinity,

      clipBehavior: Clip.antiAlias,

      decoration: _cardDecoration(
        radius: 18,
        showShadow: true,
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,

        children: [
          // HEADER
          _buildSummaryHeader(cartItems.length),

          // EMPTY CART
          if (cartItems.isEmpty)
            _buildEmptyCart()
          else
            Padding(
              padding: const EdgeInsets.fromLTRB(
                15,
                4,
                15,
                16,
              ),

              child: Column(
                children: [
                  // PRODUCTS
                  ...List.generate(
                    cartItems.length,
                    (index) {
                      return Column(
                        children: [
                          _buildProductCard(
                            cartItems[index],
                          ),

                          if (index !=
                              cartItems.length - 1)
                            const Divider(
                              height: 1,
                              thickness: 1,
                              color: HomeColors.divider,
                            ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 10),

                  // SUBTOTAL
                  _buildSubtotal(subtotal),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // ==========================================================
  // ORDER SUMMARY HEADER
  // ==========================================================

  Widget _buildSummaryHeader(int itemCount) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 18,
      ),

      decoration: const BoxDecoration(
        color: HomeColors.secondary,
      ),

      child: Row(
        children: [
          // SHOPPING BAG ICON
          Container(
            width: 43,
            height: 43,

            alignment: Alignment.center,

            decoration: BoxDecoration(
              color: HomeColors.white.withValues(
                alpha: 0.16,
              ),

              borderRadius: BorderRadius.circular(12),
            ),

            child: const Icon(
              Icons.shopping_bag_outlined,
              color: HomeColors.white,
              size: 24,
            ),
          ),

          const SizedBox(width: 12),

          // TITLE
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  'Order Summary',

                  style: HomeTextStyles
                      .summaryTotalLabel
                      .copyWith(
                    color: HomeColors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'Your selected products',

                  style: HomeTextStyles.caption.copyWith(
                    color: HomeColors.white.withValues(
                      alpha: 0.85,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ITEM COUNT
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 11,
              vertical: 7,
            ),

            decoration: BoxDecoration(
              color: HomeColors.white.withValues(
                alpha: 0.18,
              ),

              borderRadius: BorderRadius.circular(20),
            ),

            child: Text(
              '$itemCount ${itemCount == 1 ? 'Item' : 'Items'}',

              style: HomeTextStyles.chip.copyWith(
                color: HomeColors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // PRODUCT ROW
  // ==========================================================

  Widget _buildProductCard(
    CartNotificationItem item,
  ) {
    final double unitPrice =
        _parsePrice(item.price);

    final double totalPrice =
        unitPrice * item.quantity;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 17,
      ),

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          // ======================================
          // PRODUCT ICON
          // ======================================

          Container(
            width: 62,
            height: 66,

            alignment: Alignment.center,

            decoration: BoxDecoration(
              color: HomeColors.secondaryLight,

              borderRadius: BorderRadius.circular(12),
            ),

            child: const Icon(
              Icons.inventory_2_outlined,
              color: HomeColors.secondary,
              size: 29,
            ),
          ),

          const SizedBox(width: 12),

          // ======================================
          // PRODUCT DETAILS
          // ======================================

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                // PRODUCT NAME / DELETE
                Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    Expanded(
                      child: Text(
                        item.name.trim(),

                        maxLines: 2,
                        overflow:
                            TextOverflow.ellipsis,

                        style: HomeTextStyles
                            .bodyEmphasis
                            .copyWith(
                          color: HomeColors.textPrimary,
                          fontWeight: FontWeight.w700,
                          height: 1.35,
                        ),
                      ),
                    ),

                    const SizedBox(width: 5),

                    _buildDeleteButton(item),
                  ],
                ),

                // PACK WEIGHT
                if (item.weight != null &&
                    item.weight!.trim().isNotEmpty) ...[
                  const SizedBox(height: 6),

                  Text(
                    item.weight!.trim(),

                    style: HomeTextStyles.caption.copyWith(
                      color: HomeColors.textSecondary,
                    ),
                  ),
                ],

                const SizedBox(height: 14),

                // PRICE AND QUANTITY
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '₹${_formatPrice(unitPrice)}',

                        maxLines: 1,
                        overflow:
                            TextOverflow.ellipsis,

                        style: HomeTextStyles
                            .bodyEmphasis
                            .copyWith(
                          color: HomeColors.secondary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    _buildQuantityControl(item),
                  ],
                ),

                // TOTAL IF QUANTITY > 1
                if (item.quantity > 1) ...[
                  const SizedBox(height: 8),

                  Align(
                    alignment: Alignment.centerRight,

                    child: Text(
                      'Total ₹${_formatPrice(totalPrice)}',

                      style: HomeTextStyles.caption.copyWith(
                        color: HomeColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // DELETE PRODUCT BUTTON
  // ==========================================================

  Widget _buildDeleteButton(
    CartNotificationItem item,
  ) {
    return Material(
      color: HomeColors.surface,

      borderRadius: BorderRadius.circular(8),

      child: InkWell(
        onTap: _isUpdatingCart
            ? null
            : () => _removeProduct(item),

        borderRadius: BorderRadius.circular(8),

        child: const SizedBox(
          width: 30,
          height: 30,

          child: Icon(
            Icons.delete_outline_rounded,
            color: HomeColors.error,
            size: 20,
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // QUANTITY CONTROL
  // ==========================================================

  Widget _buildQuantityControl(
    CartNotificationItem item,
  ) {
    return Container(
      height: 36,

      decoration: BoxDecoration(
        color: HomeColors.surface,

        borderRadius: BorderRadius.circular(9),

        border: Border.all(
          color: HomeColors.border,
        ),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          // MINUS
          _buildQuantityButton(
            icon: Icons.remove,

            enabled:
                item.quantity > 1 &&
                !_isUpdatingCart,

            onTap: () => _decreaseQuantity(item),
          ),

          // QUANTITY
          SizedBox(
            width: 32,

            child: Center(
              child: Text(
                '${item.quantity}',

                style: HomeTextStyles
                    .bodyEmphasis
                    .copyWith(
                  color: HomeColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          // PLUS
          _buildQuantityButton(
            icon: Icons.add,

            enabled: !_isUpdatingCart,

            onTap: () => _increaseQuantity(item),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // QUANTITY BUTTON
  // ==========================================================

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onTap,
    bool enabled = true,
  }) {
    return InkWell(
      onTap: enabled ? onTap : null,

      borderRadius: BorderRadius.circular(8),

      child: SizedBox(
        width: 32,
        height: 36,

        child: Icon(
          icon,
          size: 18,

          color: enabled
              ? HomeColors.secondary
              : HomeColors.disabled,
        ),
      ),
    );
  }

  // ==========================================================
  // SUBTOTAL
  // ==========================================================

  Widget _buildSubtotal(double subtotal) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),

      decoration: BoxDecoration(
        color: HomeColors.secondary,

        borderRadius: BorderRadius.circular(12),
      ),

      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  'Total Cart Value',

                  style: HomeTextStyles.caption.copyWith(
                    color: HomeColors.white.withValues(
                      alpha: 0.85,
                    ),
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'Subtotal',

                  style: HomeTextStyles.button.copyWith(
                    color: HomeColors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          Text(
            '₹${_formatPrice(subtotal)}',

            style: HomeTextStyles
                .sectionTitleLarge
                .copyWith(
              color: HomeColors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // EMPTY CART
  // ==========================================================

  Widget _buildEmptyCart() {
    return Padding(
      padding: const EdgeInsets.all(30),

      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,

            decoration: const BoxDecoration(
              color: HomeColors.secondaryLight,
              shape: BoxShape.circle,
            ),

            child: const Icon(
              Icons.shopping_cart_outlined,
              color: HomeColors.secondary,
              size: 35,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            'Your cart is empty',

            style: HomeTextStyles
                .bodyEmphasis
                .copyWith(
              color: HomeColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // DELIVERY SECTION
  // ==========================================================

  Widget _buildDeliverySection() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(16),

      decoration: _cardDecoration(
        radius: 18,
        showShadow: true,
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          // ======================================
          // HEADING
          // ======================================

          Row(
            children: [
              Container(
                width: 40,
                height: 40,

                alignment: Alignment.center,

                decoration: BoxDecoration(
                  color: HomeColors.secondaryLight,

                  borderRadius: BorderRadius.circular(11),
                ),

                child: const Icon(
                  Icons.local_shipping_outlined,
                  color: HomeColors.secondary,
                  size: 22,
                ),
              ),

              const SizedBox(width: 11),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    Text(
                      'Choose Delivery Type',

                      style: HomeTextStyles
                          .summaryTotalLabel
                          .copyWith(
                        color: HomeColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      'Select how to receive your order',

                      style: HomeTextStyles.caption.copyWith(
                        color: HomeColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ======================================
          // HOME DELIVERY
          // ======================================

          _buildDeliveryTypeCard(
            title: 'Home Delivery',

            subtitle:
                'Convenient doorstep delivery',

            icon:
                Icons.local_shipping_outlined,

            selected:
                _selectedDeliveryType ==
                    DeliveryType.homeDelivery,

            onTap: _selectHomeDelivery,
          ),

          const SizedBox(height: 11),

          // ======================================
          // LOCAL PICKUP
          // ======================================

          _buildDeliveryTypeCard(
            title: 'Local Pickup',

            subtitle:
                'Collect from a nearby store',

            icon:
                Icons.storefront_outlined,

            selected:
                _selectedDeliveryType ==
                    DeliveryType.localPickup,

            onTap: _selectLocalPickup,
          ),

          // ======================================
          // PICKUP LOCATION
          // ======================================

          if (_selectedDeliveryType ==
              DeliveryType.localPickup) ...[
            const SizedBox(height: 18),

            _buildPickupField(),

            AnimatedSwitcher(
              duration: const Duration(
                milliseconds: 220,
              ),

              transitionBuilder:
                  (child, animation) {
                return SizeTransition(
                  sizeFactor: animation,
                  axisAlignment: -1,

                  child: FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                );
              },

              child: _isPickupListOpen
                  ? Padding(
                      key: const ValueKey(
                        'pickup-open',
                      ),

                      padding: const EdgeInsets.only(
                        top: 10,
                      ),

                      child: _buildPickupDropdown(),
                    )
                  : const SizedBox.shrink(
                      key: ValueKey(
                        'pickup-closed',
                      ),
                    ),
            ),
          ],
        ],
      ),
    );
  }

  // ==========================================================
  // DELIVERY TYPE CARD
  // ==========================================================

  Widget _buildDeliveryTypeCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: HomeColors.surface,

      borderRadius: BorderRadius.circular(12),

      child: InkWell(
        onTap: onTap,

        borderRadius: BorderRadius.circular(12),

        child: AnimatedContainer(
          duration: const Duration(
            milliseconds: 180,
          ),

          width: double.infinity,

          padding: const EdgeInsets.symmetric(
            horizontal: 13,
            vertical: 15,
          ),

          decoration: BoxDecoration(
            color: selected
                ? HomeColors.secondaryLight
                : HomeColors.surface,

            borderRadius: BorderRadius.circular(12),

            border: Border.all(
              color: selected
                  ? HomeColors.secondary
                  : HomeColors.border,

              width: selected ? 1.5 : 1,
            ),
          ),

          child: Row(
            children: [
              // RADIO
              Icon(
                selected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,

                size: 22,

                color: selected
                    ? HomeColors.secondary
                    : HomeColors.textHint,
              ),

              const SizedBox(width: 13),

              // TITLE
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    Text(
                      title,

                      style: HomeTextStyles
                          .bodyEmphasis
                          .copyWith(
                        color: HomeColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      subtitle,

                      style: HomeTextStyles.caption.copyWith(
                        color: HomeColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              Icon(
                icon,
                size: 25,

                color: selected
                    ? HomeColors.secondary
                    : HomeColors.textHint,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // PICKUP LOCATION FIELD
  // ==========================================================

  Widget _buildPickupField() {
    return Material(
      color: HomeColors.surface,

      borderRadius: BorderRadius.circular(12),

      child: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();

          setState(() {
            _isPickupListOpen =
                !_isPickupListOpen;

            if (_isPickupListOpen) {
              _searchController.clear();
              _searchQuery = '';
            }
          });
        },

        borderRadius: BorderRadius.circular(12),

        child: Container(
          width: double.infinity,

          padding: const EdgeInsets.all(14),

          decoration: BoxDecoration(
            color: HomeColors.surface,

            borderRadius: BorderRadius.circular(12),

            border: Border.all(
              color: _isPickupListOpen
                  ? HomeColors.secondary
                  : HomeColors.border,

              width: _isPickupListOpen ? 1.5 : 1,
            ),
          ),

          child: Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: HomeColors.secondary,
                size: 24,
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _selectedPickupPoint == null
                    ? Text(
                        'Select pickup location',

                        style: HomeTextStyles.body.copyWith(
                          color: HomeColors.textSecondary,
                        ),
                      )
                    : Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [
                          Text(
                            _selectedPickupPoint!.name,

                            style: HomeTextStyles
                                .bodyEmphasis
                                .copyWith(
                              color: HomeColors.textPrimary,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            _selectedPickupPoint!
                                .address,

                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,

                            style: HomeTextStyles
                                .caption
                                .copyWith(
                              color: HomeColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
              ),

              AnimatedRotation(
                turns: _isPickupListOpen ? 0.5 : 0,

                duration: const Duration(
                  milliseconds: 180,
                ),

                child: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: HomeColors.secondary,
                  size: 27,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // PICKUP DROPDOWN
  // ==========================================================

  Widget _buildPickupDropdown() {
    final filteredPoints =
        _filteredPickupPoints;

    return Container(
      width: double.infinity,

      constraints: const BoxConstraints(
        maxHeight: 340,
      ),

      decoration: BoxDecoration(
        color: HomeColors.surface,

        borderRadius: BorderRadius.circular(12),

        border: Border.all(
          color: HomeColors.border,
        ),

        boxShadow: [
          BoxShadow(
            color: HomeColors.black.withValues(
              alpha: 0.05,
            ),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      clipBehavior: Clip.antiAlias,

      child: Column(
        mainAxisSize: MainAxisSize.min,

        children: [
          // ======================================
          // SEARCH
          // ======================================

          Padding(
            padding: const EdgeInsets.all(10),

            child: TextField(
              controller: _searchController,

              cursorColor: HomeColors.secondary,

              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },

              style: HomeTextStyles.body.copyWith(
                color: HomeColors.textPrimary,
              ),

              decoration: InputDecoration(
                hintText: 'Search pickup point',

                hintStyle: HomeTextStyles.body.copyWith(
                  color: HomeColors.textSecondary,
                ),

                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: HomeColors.secondary,
                ),

                suffixIcon: _searchQuery.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          _searchController.clear();

                          setState(() {
                            _searchQuery = '';
                          });
                        },

                        icon: const Icon(
                          Icons.close_rounded,
                          color: HomeColors.textSecondary,
                        ),
                      ),

                filled: true,
                fillColor: HomeColors.background,

                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(9),

                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // ======================================
          // PICKUP LIST
          // ======================================

          Flexible(
            child: filteredPoints.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(20),

                    child: Center(
                      child: Text(
                        'No pickup point found',

                        style: HomeTextStyles
                            .bodySmall
                            .copyWith(
                          color: HomeColors.textSecondary,
                        ),
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: EdgeInsets.zero,

                    shrinkWrap: true,

                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior
                            .onDrag,

                    itemCount: filteredPoints.length,

                    separatorBuilder:
                        (context, index) {
                      return const Divider(
                        height: 1,
                        color: HomeColors.divider,
                      );
                    },

                    itemBuilder: (context, index) {
                      return _buildPickupItem(
                        filteredPoints[index],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // PICKUP LIST ITEM
  // ==========================================================

  Widget _buildPickupItem(PickupPoint point) {
    final bool isSelected =
        _selectedPickupPoint == point;

    return Material(
      color: isSelected
          ? HomeColors.secondaryLight
          : HomeColors.surface,

      child: InkWell(
        onTap: () => _selectPickupPoint(point),

        child: Padding(
          padding: const EdgeInsets.all(14),

          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              const Icon(
                Icons.storefront_outlined,
                color: HomeColors.secondary,
                size: 23,
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    Text(
                      point.name,

                      style: HomeTextStyles
                          .bodyEmphasis
                          .copyWith(
                        color: HomeColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      point.address,

                      style: HomeTextStyles
                          .bodySmall
                          .copyWith(
                        color: HomeColors.textSecondary,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      point.phone,

                      style: HomeTextStyles
                          .caption
                          .copyWith(
                        color: HomeColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              if (isSelected)
                const Icon(
                  Icons.check_circle_rounded,
                  color: HomeColors.secondary,
                  size: 21,
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // FIXED BOTTOM CHECKOUT BAR
  // ==========================================================

  Widget _buildBottomSection() {
    return NewCheckoutBottomBar(
      currentIndex: NewConstantCheckout.delivery,

      onContinue:
          _canContinue ? _continueToPayment : null,

      onReturnToShop: _returnToShop,
    );
  }

  // ==========================================================
  // PRODUCT SHIMMER
  // ==========================================================

  Widget _buildProductShimmer() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(16),

      decoration: _cardDecoration(),

      child: const Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          AppShimmer(
            height: 65,
            radius: 12,
          ),

          SizedBox(height: 18),

          AppShimmer(
            height: 80,
            radius: 12,
          ),

          SizedBox(height: 12),

          AppShimmer(
            height: 80,
            radius: 12,
          ),

          SizedBox(height: 18),

          AppShimmer(
            height: 58,
            radius: 12,
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // ERROR STATE
  // ==========================================================

  Widget _buildErrorState() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(24),

      decoration: _cardDecoration(),

      child: Column(
        children: [
          const Icon(
            Icons.error_outline,
            size: 42,
            color: HomeColors.error,
          ),

          const SizedBox(height: 12),

          Text(
            'Unable to load your cart.',

            style: HomeTextStyles
                .bodyEmphasis
                .copyWith(
              color: HomeColors.textPrimary,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Please try again to continue checkout.',

            textAlign: TextAlign.center,

            style: HomeTextStyles
                .bodySmall
                .copyWith(
              color: HomeColors.textSecondary,
            ),
          ),

          const SizedBox(height: 15),

          TextButton(
            onPressed: _initializeCart,

            child: const Text(
              'Retry',

              style: TextStyle(
                color: HomeColors.secondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
