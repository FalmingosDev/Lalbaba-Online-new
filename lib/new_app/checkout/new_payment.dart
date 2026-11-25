// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:go_router/go_router.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:url_launcher/url_launcher.dart';

// import '../core/services/cart_notification_item.dart';
// import '../core/services/cart_service.dart';
// import 'constantappbar.dart';
// import 'constantcolour.dart';

// enum _PaymentMethod { worldline, cashOnDelivery }

// class NewPaymentPage extends StatefulWidget {
//   const NewPaymentPage({super.key});

//   @override
//   State<NewPaymentPage> createState() => _NewPaymentPageState();
// }

// class _NewPaymentPageState extends State<NewPaymentPage> {
//   static const String _instructionsKey = 'checkout_delivery_instructions';

//   final TextEditingController _instructionsController = TextEditingController();
//   final TextEditingController _pincodeController = TextEditingController();
//   _PaymentMethod _paymentMethod = _PaymentMethod.worldline;
//   bool _isSavingInstructions = false;
//   bool _instructionsSaved = false;
//   bool _agreedToTerms = false;
//   bool _isCheckingPincode = false;
//   bool _isPincodeValid = false;
//   String? _pincodeMessage;

//   @override
//   void initState() {
//     super.initState();
//     _loadInstructions();
//   }

//   @override
//   void dispose() {
//     _instructionsController.dispose();
//     _pincodeController.dispose();
//     super.dispose();
//   }

//   Future<void> _loadInstructions() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       if (!mounted) return;
//       _instructionsController.text = prefs.getString(_instructionsKey) ?? '';
//       setState(() {
//         _instructionsSaved = _instructionsController.text.isNotEmpty;
//       });
//     } catch (error) {
//       debugPrint('Delivery instruction load error: $error');
//       if (!mounted) return;
//       _showMessage('Unable to load saved delivery instructions.');
//     }
//   }

//   Future<void> _saveInstructions() async {
//     final instructions = _instructionsController.text.trim();
//     if (instructions.isEmpty) {
//       _showMessage('Write your delivery instructions before saving.');
//       return;
//     }

//     setState(() {
//       _isSavingInstructions = true;
//     });

//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString(_instructionsKey, instructions);
//       if (!mounted) return;
//       setState(() {
//         _instructionsSaved = true;
//       });
//       _showMessage('Delivery instructions saved.');
//     } catch (error) {
//       debugPrint('Delivery instruction save error: $error');
//       if (!mounted) return;
//       _showMessage('Unable to save delivery instructions.');
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isSavingInstructions = false;
//         });
//       }
//     }
//   }

//   Future<void> _checkPincode() async {
//     final pincode = _pincodeController.text.trim();
//     if (!RegExp(r'^\d{6}$').hasMatch(pincode)) {
//       setState(() {
//         _pincodeMessage = 'Enter a valid 6-digit PIN code.';
//         _isPincodeValid = false;
//       });
//       return;
//     }

//     setState(() {
//       _isCheckingPincode = true;
//       _pincodeMessage = null;
//       _isPincodeValid = false;
//     });

//     try {
//       // Serviceability needs the delivery API; until then only validate the PIN.
//       await Future<void>.delayed(const Duration(milliseconds: 300));
//       if (!mounted) return;
//       setState(() {
//         _pincodeMessage =
//             'PIN format is valid. Delivery availability needs the service API.';
//         _isPincodeValid = true;
//       });
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isCheckingPincode = false;
//         });
//       }
//     }
//   }

//   void _onPincodeChanged(String value) {
//     if (_pincodeMessage == null) return;
//     setState(() {
//       _pincodeMessage = null;
//       _isPincodeValid = false;
//     });
//   }

//   Future<void> _openPolicy(String url) async {
//     try {
//       final launched = await launchUrl(
//         Uri.parse(url),
//         mode: LaunchMode.externalApplication,
//       );
//       if (!launched && mounted) {
//         _showMessage('Unable to open this page.');
//       }
//     } catch (error) {
//       debugPrint('Policy link error: $error');
//       if (mounted) {
//         _showMessage('Unable to open this page.');
//       }
//     }
//   }

//   void _showMessage(String message) {
//     ScaffoldMessenger.of(context)
//       ..hideCurrentSnackBar()
//       ..showSnackBar(SnackBar(content: Text(message)));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: HomeColors.background,
//       appBar: const CommonAppBar(
//         automaticallyImplyLeading: true,
//         showBackButton: true,
//         title: 'Payment',
//         backgroundColor: HomeColors.secondary,
//         titleColor: HomeColors.white,
//         iconColor: HomeColors.white,
//       ),
//       body: ValueListenableBuilder<List<CartNotificationItem>>(
//         valueListenable: CartService.items,
//         builder: (context, cartItems, child) {
//           return LayoutBuilder(
//             builder: (context, constraints) {
//               final instructionsAndPayment = Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   _buildInstructionsCard(),
//                   const SizedBox(height: 16),
//                   _buildPaymentMethodsCard(),
//                   const SizedBox(height: 16),
//                   if (constraints.maxWidth < 800) _buildSummaryCard(cartItems),
//                   if (constraints.maxWidth < 800) const SizedBox(height: 16),
//                 ],
//               );

//               return SingleChildScrollView(
//                 padding: const EdgeInsets.all(16),
//                 child: Center(
//                   child: ConstrainedBox(
//                     constraints: const BoxConstraints(maxWidth: 1200),
//                     child: Column(
//                       children: [
//                         if (constraints.maxWidth >= 800)
//                           Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Expanded(child: instructionsAndPayment),
//                               const SizedBox(width: 20),
//                               SizedBox(
//                                 width: 380,
//                                 child: _buildSummaryCard(cartItems),
//                               ),
//                             ],
//                           )
//                         else
//                           instructionsAndPayment,
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildInstructionsCard() {
//     return _SectionCard(
//       title: 'Any additional instructions?',
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           TextField(
//             controller: _instructionsController,
//             minLines: 5,
//             maxLines: 7,
//             onChanged: (_) {
//               if (_instructionsSaved) {
//                 setState(() {
//                   _instructionsSaved = false;
//                 });
//               }
//             },
//             decoration: const InputDecoration(
//               hintText: 'Type your text',
//               alignLabelWithHint: true,
//               border: OutlineInputBorder(),
//               focusedBorder: OutlineInputBorder(
//                 borderSide: BorderSide(color: HomeColors.secondary),
//               ),
//             ),
//           ),
//           const SizedBox(height: 12),
//           Align(
//             alignment: Alignment.centerRight,
//             child: ElevatedButton.icon(
//               onPressed: _isSavingInstructions ? null : _saveInstructions,
//               icon: _isSavingInstructions
//                   ? const SizedBox(
//                       width: 16,
//                       height: 16,
//                       child: CircularProgressIndicator(
//                         strokeWidth: 2,
//                         color: HomeColors.white,
//                       ),
//                     )
//                   : Icon(
//                       _instructionsSaved ? Icons.check : Icons.save_outlined,
//                     ),
//               label: Text(_instructionsSaved ? 'Saved' : 'Save'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: HomeColors.secondary,
//                 foregroundColor: HomeColors.white,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPaymentMethodsCard() {
//     return _SectionCard(
//       title: 'Select a payment option',
//       child: RadioGroup<_PaymentMethod>(
//         groupValue: _paymentMethod,
//         onChanged: (method) {
//           if (method == null) return;
//           setState(() {
//             _paymentMethod = method;
//           });
//         },
//         child: Wrap(
//           spacing: 12,
//           runSpacing: 12,
//           children: [
//             _PaymentMethodOption(
//               value: _PaymentMethod.worldline,
//               selected: _paymentMethod == _PaymentMethod.worldline,
//               title: 'WORLDLINE',
//               icon: Icons.language,
//               onSelected: () {
//                 setState(() {
//                   _paymentMethod = _PaymentMethod.worldline;
//                 });
//               },
//             ),
//             _PaymentMethodOption(
//               value: _PaymentMethod.cashOnDelivery,
//               selected: _paymentMethod == _PaymentMethod.cashOnDelivery,
//               title: 'Cash on Delivery',
//               icon: Icons.local_shipping_outlined,
//               onSelected: () {
//                 setState(() {
//                   _paymentMethod = _PaymentMethod.cashOnDelivery;
//                 });
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSummaryCard(List<CartNotificationItem> cartItems) {
//     final subtotal = cartItems.fold<double>(
//       0,
//       (sum, item) => sum + (_parsePrice(item.price) * item.quantity),
//     );
//     final itemCount = cartItems.fold<int>(
//       0,
//       (sum, item) => sum + item.quantity,
//     );

//     return _SectionCard(
//       title: 'Summary',
//       trailing: Text(
//         '$itemCount ${itemCount == 1 ? 'Item' : 'Items'}',
//         style: const TextStyle(
//           color: HomeColors.secondary,
//           fontWeight: FontWeight.w700,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: TextField(
//                   controller: _pincodeController,
//                   keyboardType: TextInputType.number,
//                   inputFormatters: [
//                     FilteringTextInputFormatter.digitsOnly,
//                     LengthLimitingTextInputFormatter(6),
//                   ],
//                   onChanged: _onPincodeChanged,
//                   decoration: const InputDecoration(
//                     hintText: 'Enter 6-digit delivery PIN code',
//                     isDense: true,
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 8),
//               ElevatedButton(
//                 onPressed: _isCheckingPincode ? null : _checkPincode,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: HomeColors.secondary,
//                   foregroundColor: HomeColors.white,
//                   padding: const EdgeInsets.symmetric(horizontal: 14),
//                 ),
//                 child: _isCheckingPincode
//                     ? const SizedBox(
//                         width: 18,
//                         height: 18,
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2,
//                           color: HomeColors.white,
//                         ),
//                       )
//                     : const Text('Check'),
//               ),
//             ],
//           ),
//           if (_pincodeMessage != null) ...[
//             const SizedBox(height: 8),
//             Text(
//               _pincodeMessage!,
//               style: TextStyle(
//                 color: _isPincodeValid ? HomeColors.success : HomeColors.error,
//                 fontSize: 12,
//               ),
//             ),
//           ],
//           const SizedBox(height: 16),
//           const Row(
//             children: [
//               Expanded(
//                 child: Text(
//                   'Product',
//                   style: TextStyle(fontWeight: FontWeight.w700),
//                 ),
//               ),
//               Text('Total', style: TextStyle(fontWeight: FontWeight.w700)),
//             ],
//           ),
//           const Divider(height: 20),
//           if (cartItems.isEmpty)
//             const Padding(
//               padding: EdgeInsets.symmetric(vertical: 8),
//               child: Text(
//                 'Your cart is empty.',
//                 style: TextStyle(color: HomeColors.textSecondary),
//               ),
//             )
//           else
//             ...cartItems.map(
//               (item) => Padding(
//                 padding: const EdgeInsets.only(bottom: 12),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(
//                       child: Text(
//                         '${item.name} × ${item.quantity}',
//                         style: const TextStyle(color: HomeColors.textPrimary),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Text(
//                       '₹${(_parsePrice(item.price) * item.quantity).toStringAsFixed(2)}',
//                       style: const TextStyle(fontWeight: FontWeight.w600),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           const Divider(height: 20),
//           _SummaryRow(label: 'Total Base Price', amount: subtotal),
//           _SummaryRow(label: 'Discount', amount: 0),
//           _SummaryRow(label: 'Subtotal', amount: subtotal),
//           _SummaryRow(label: 'Tax', amount: 0),
//           _SummaryRow(label: 'Total Shipping', amount: 0),
//           const Divider(height: 20),
//           _SummaryRow(label: 'Total', amount: subtotal, isEmphasized: true),
//           const SizedBox(height: 12),
//           Material(
//             color: HomeColors.surface,
//             child: CheckboxListTile(
//               contentPadding: EdgeInsets.zero,
//               controlAffinity: ListTileControlAffinity.leading,
//               value: _agreedToTerms,
//               activeColor: HomeColors.secondary,
//               onChanged: (value) {
//                 setState(() {
//                   _agreedToTerms = value ?? false;
//                 });
//               },
//               title: Wrap(
//                 children: [
//                   const Text('I agree to the '),
//                   _PolicyLink(
//                     label: 'terms and conditions',
//                     onTap: () => _openPolicy('https://lalbabaonline.com/terms'),
//                   ),
//                   const Text(', '),
//                   _PolicyLink(
//                     label: 'return policy',
//                     onTap: () =>
//                         _openPolicy('https://lalbabaonline.com/return-policy'),
//                   ),
//                   const Text(' & '),
//                   _PolicyLink(
//                     label: 'privacy policy',
//                     onTap: () =>
//                         _openPolicy('https://lalbabaonline.com/privacy-policy'),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(height: 8),
//           TextButton(
//             onPressed: () => context.pop(),
//             child: const Text(
//               'Return to shipping',
//               style: TextStyle(color: HomeColors.textSecondary),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   static double _parsePrice(String value) {
//     final normalized = value.replaceAll(RegExp(r'[^0-9.]'), '');
//     return double.tryParse(normalized) ?? 0;
//   }
// }

// class _SectionCard extends StatelessWidget {
//   const _SectionCard({required this.title, required this.child, this.trailing});

//   final String title;
//   final Widget child;
//   final Widget? trailing;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: HomeColors.surface,
//         border: Border.all(color: HomeColors.border),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     title,
//                     style: const TextStyle(
//                       color: HomeColors.textPrimary,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                 ),
//                 if (trailing != null) trailing!,
//               ],
//             ),
//           ),
//           const Divider(height: 1, color: HomeColors.divider),
//           Padding(padding: const EdgeInsets.all(16), child: child),
//         ],
//       ),
//     );
//   }
// }

// class _PaymentMethodOption extends StatelessWidget {
//   const _PaymentMethodOption({
//     required this.value,
//     required this.selected,
//     required this.title,
//     required this.icon,
//     required this.onSelected,
//   });

//   final _PaymentMethod value;
//   final bool selected;
//   final String title;
//   final IconData icon;
//   final VoidCallback onSelected;

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onSelected,
//       borderRadius: BorderRadius.circular(8),
//       child: Container(
//         width: 150,
//         height: 150,
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: HomeColors.surface,
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(
//             color: selected ? HomeColors.secondary : HomeColors.border,
//             width: selected ? 1.5 : 1,
//           ),
//         ),
//         child: Column(
//           children: [
//             Icon(icon, size: 30, color: HomeColors.secondary),
//             const SizedBox(height: 6),
//             Text(
//               title,
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 color: HomeColors.textPrimary,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const Spacer(),
//             Radio<_PaymentMethod>(
//               value: value,
//               visualDensity: VisualDensity.compact,
//               materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _SummaryRow extends StatelessWidget {
//   const _SummaryRow({
//     required this.label,
//     required this.amount,
//     this.isEmphasized = false,
//   });

//   final String label;
//   final double amount;
//   final bool isEmphasized;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         children: [
//           Expanded(
//             child: Text(
//               label,
//               style: TextStyle(
//                 color: HomeColors.textPrimary,
//                 fontWeight: isEmphasized ? FontWeight.w700 : FontWeight.w500,
//                 fontSize: isEmphasized ? 16 : 14,
//               ),
//             ),
//           ),
//           Text(
//             '₹${amount.toStringAsFixed(2)}',
//             style: TextStyle(
//               color: HomeColors.textPrimary,
//               fontWeight: isEmphasized ? FontWeight.w700 : FontWeight.w600,
//               fontSize: isEmphasized ? 16 : 14,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _PolicyLink extends StatelessWidget {
//   const _PolicyLink({required this.label, required this.onTap});

//   final String label;
//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     return Semantics(
//       link: true,
//       child: InkWell(
//         onTap: onTap,
//         child: Text(
//           label,
//           style: const TextStyle(
//             color: HomeColors.secondary,
//             decoration: TextDecoration.underline,
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/services/cart_notification_item.dart';
import '../../core/services/cart_service.dart';

import '../constant/constantcolour.dart';
import '../constant/new_constant_checkout_page.dart';

// ============================================================
// PAYMENT METHOD
// ============================================================

enum _PaymentMethod { razorpay, cashOnDelivery }

// ============================================================
// NEW PAYMENT PAGE
// ============================================================

class NewPaymentPage extends StatefulWidget {
  const NewPaymentPage({super.key});

  @override
  State<NewPaymentPage> createState() => _NewPaymentPageState();
}

class _NewPaymentPageState extends State<NewPaymentPage> {
  // ==========================================================
  // VARIABLES AND CONTROLLERS
  // ==========================================================

  static const String _instructionsKey = 'checkout_delivery_instructions';

  final TextEditingController _instructionsController = TextEditingController();

  final TextEditingController _pincodeController = TextEditingController();

  _PaymentMethod _paymentMethod = _PaymentMethod.razorpay;

  bool _isSavingInstructions = false;
  bool _instructionsSaved = false;
  bool _agreedToTerms = true;
  bool _isCheckingPincode = false;
  bool _isPincodeValid = false;

  String? _pincodeMessage;

  // ==========================================================
  // INITIALIZE
  // ==========================================================

  @override
  void initState() {
    super.initState();
    _loadInstructions();
  }

  @override
  void dispose() {
    _instructionsController.dispose();
    _pincodeController.dispose();

    super.dispose();
  }

  // ==========================================================
  // LOAD DELIVERY INSTRUCTIONS
  // ==========================================================

  Future<void> _loadInstructions() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (!mounted) return;

      _instructionsController.text = prefs.getString(_instructionsKey) ?? '';

      setState(() {
        _instructionsSaved = _instructionsController.text.isNotEmpty;
      });
    } catch (error) {
      debugPrint('Delivery instruction load error: $error');

      if (!mounted) return;

      _showMessage('Unable to load saved delivery instructions.');
    }
  }

  // ==========================================================
  // SAVE DELIVERY INSTRUCTIONS
  // ==========================================================

  Future<void> _saveInstructions() async {
    final instructions = _instructionsController.text.trim();

    if (instructions.isEmpty) {
      _showMessage('Write your delivery instructions before saving.');

      return;
    }

    setState(() {
      _isSavingInstructions = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString(_instructionsKey, instructions);

      if (!mounted) return;

      setState(() {
        _instructionsSaved = true;
      });

      _showMessage('Delivery instructions saved.');
    } catch (error) {
      debugPrint('Delivery instruction save error: $error');

      if (!mounted) return;

      _showMessage('Unable to save delivery instructions.');
    } finally {
      if (mounted) {
        setState(() {
          _isSavingInstructions = false;
        });
      }
    }
  }

  // ==========================================================
  // CHECK PIN CODE
  // ==========================================================

  Future<void> _checkPincode() async {
    final pincode = _pincodeController.text.trim();

    if (!RegExp(r'^\d{6}$').hasMatch(pincode)) {
      setState(() {
        _pincodeMessage = 'Enter a valid 6-digit PIN code.';

        _isPincodeValid = false;
      });

      return;
    }

    setState(() {
      _isCheckingPincode = true;
      _pincodeMessage = null;
      _isPincodeValid = false;
    });

    try {
      // TODO: Connect delivery service API.

      await Future<void>.delayed(const Duration(milliseconds: 300));

      if (!mounted) return;

      setState(() {
        _pincodeMessage =
            'PIN format is valid. Delivery availability needs the service API.';

        _isPincodeValid = true;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isCheckingPincode = false;
        });
      }
    }
  }

  // ==========================================================
  // PIN CODE CHANGE
  // ==========================================================

  void _onPincodeChanged(String value) {
    if (_pincodeMessage == null) return;

    setState(() {
      _pincodeMessage = null;
      _isPincodeValid = false;
    });
  }

  // ==========================================================
  // OPEN POLICY URL
  // ==========================================================

  Future<void> _openPolicy(String url) async {
    try {
      final launched = await launchUrl(
        Uri.parse(url),

        mode: LaunchMode.externalApplication,
      );

      if (!launched && mounted) {
        _showMessage('Unable to open this page.');
      }
    } catch (error) {
      debugPrint('Policy link error: $error');

      if (mounted) {
        _showMessage('Unable to open this page.');
      }
    }
  }

  // ==========================================================
  // SHOW MESSAGE
  // ==========================================================

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _placeOrder() {
    if (!_agreedToTerms) {
      _showMessage('Please agree to the terms and conditions.');
      return;
    }

    _showMessage(
      'Order placement will be available when checkout is connected.',
    );
  }

  // ==========================================================
  // MAIN BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HomeColors.background,
      bottomNavigationBar: NewCheckoutBottomBar(
        currentIndex: NewConstantCheckout.payment,
        onContinue: _agreedToTerms ? _placeOrder : null,
      ),

      // ======================================================
      // NO APP BAR IN PAYMENT PAGE
      // ======================================================
      body: SafeArea(
        child: ValueListenableBuilder<List<CartNotificationItem>>(
          valueListenable: CartService.items,

          builder: (context, cartItems, child) {
            return LayoutBuilder(
              builder: (context, constraints) {
                final instructionsAndPayment = Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,

                  children: [
                    // ADDITIONAL INSTRUCTIONS

                    _buildInstructionsCard(),

                    const SizedBox(height: 16),

                    // PAYMENT METHOD
                    _buildPaymentMethodsCard(),

                    const SizedBox(height: 16),

                    // MOBILE SUMMARY
                    if (constraints.maxWidth < 800)
                      _buildSummaryCard(cartItems),

                    if (constraints.maxWidth < 800) const SizedBox(height: 16),
                  ],
                );

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),

                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1200),

                      child: Column(
                        children: [
                          // ==================================
                          // CONSTANT CHECKOUT
                          // PAYMENT INDEX = 3
                          // ==================================

                          const NewConstantCheckout(
                            currentIndex: NewConstantCheckout.payment,
                          ),

                          const SizedBox(height: 24),

                          // ==================================
                          // DESKTOP VIEW
                          // ==================================
                          if (constraints.maxWidth >= 800)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Expanded(child: instructionsAndPayment),

                                const SizedBox(width: 20),

                                SizedBox(
                                  width: 380,

                                  child: _buildSummaryCard(cartItems),
                                ),
                              ],
                            )
                          // ==================================
                          // MOBILE VIEW
                          // ==================================
                          else
                            instructionsAndPayment,
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  // ==========================================================
  // ADDITIONAL INSTRUCTIONS CARD
  // ==========================================================

  Widget _buildInstructionsCard() {
    return _SectionCard(
      title: 'Any additional instructions?',

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,

        children: [
          // INSTRUCTIONS TEXT FIELD

          TextField(
            controller: _instructionsController,

            minLines: 5,
            maxLines: 7,

            onChanged: (_) {
              if (_instructionsSaved) {
                setState(() {
                  _instructionsSaved = false;
                });
              }
            },

            decoration: const InputDecoration(
              hintText: 'Type your text',

              alignLabelWithHint: true,

              border: OutlineInputBorder(),

              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: HomeColors.secondary),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // SAVE INSTRUCTIONS BUTTON
          Align(
            alignment: Alignment.centerRight,

            child: ElevatedButton.icon(
              onPressed: _isSavingInstructions ? null : _saveInstructions,

              icon: _isSavingInstructions
                  ? const SizedBox(
                      width: 16,
                      height: 16,

                      child: CircularProgressIndicator(
                        strokeWidth: 2,

                        color: HomeColors.white,
                      ),
                    )
                  : Icon(
                      _instructionsSaved ? Icons.check : Icons.save_outlined,
                    ),

              label: Text(_instructionsSaved ? 'Saved' : 'Save'),

              style: ElevatedButton.styleFrom(
                backgroundColor: HomeColors.secondary,

                foregroundColor: HomeColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // PAYMENT METHODS CARD
  // ==========================================================

  Widget _buildPaymentMethodsCard() {
    return _SectionCard(
      title: 'Select a payment option',

      child: RadioGroup<_PaymentMethod>(
        groupValue: _paymentMethod,

        onChanged: (method) {
          if (method == null) return;

          setState(() {
            _paymentMethod = method;
          });
        },

        child: Wrap(
          spacing: 12,
          runSpacing: 12,

          children: [
            // ================================================
            // RAZORPAY PAYMENT
            // ================================================

            _PaymentMethodOption(
              value: _PaymentMethod.razorpay,

              selected: _paymentMethod == _PaymentMethod.razorpay,

              title: '',

              image: Image.asset(
                'lib/assets/Razorpay_logo.png',
                height: 30,
                fit: BoxFit.contain,
              ),

              onSelected: () {
                setState(() {
                  _paymentMethod = _PaymentMethod.razorpay;
                });
              },
            ),

            // ================================================
            // CASH ON DELIVERY
            // ================================================
            _PaymentMethodOption(
              value: _PaymentMethod.cashOnDelivery,

              selected: _paymentMethod == _PaymentMethod.cashOnDelivery,

              title: 'Cash on Delivery',

              image: const Icon(
                Icons.local_shipping_outlined,
                size: 30,
                color: HomeColors.secondary,
              ),

              onSelected: () {
                setState(() {
                  _paymentMethod = _PaymentMethod.cashOnDelivery;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // ORDER SUMMARY CARD
  // ==========================================================

  Widget _buildSummaryCard(List<CartNotificationItem> cartItems) {
    // DYNAMIC PRODUCT SUBTOTAL

    final subtotal = cartItems.fold<double>(
      0,

      (sum, item) => sum + (_parsePrice(item.price) * item.quantity),
    );

    // TOTAL PRODUCT QUANTITY

    final itemCount = cartItems.fold<int>(
      0,

      (sum, item) => sum + item.quantity,
    );

    return _SectionCard(
      title: 'Summary',

      trailing: Text(
        '$itemCount ${itemCount == 1 ? 'Item' : 'Items'}',

        style: const TextStyle(
          color: HomeColors.secondary,

          fontWeight: FontWeight.w700,
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,

        children: [
          // ==================================================
          // DELIVERY PIN CODE FIELD
          // ==================================================

          // Row(
          //   children: [
          //     Expanded(
          //       child: TextField(
          //         controller: _pincodeController,

          //         keyboardType: TextInputType.number,

          //         inputFormatters: [
          //           FilteringTextInputFormatter.digitsOnly,

          //           LengthLimitingTextInputFormatter(6),
          //         ],

          //         onChanged: _onPincodeChanged,

          //         decoration: const InputDecoration(
          //           hintText: 'Enter 6-digit delivery PIN code',

          //           isDense: true,

          //           border: OutlineInputBorder(),
          //         ),
          //       ),
          //     ),

          //     const SizedBox(width: 8),

          //     // CHECK PIN CODE BUTTON
          //     ElevatedButton(
          //       onPressed: _isCheckingPincode ? null : _checkPincode,

          //       style: ElevatedButton.styleFrom(
          //         backgroundColor: HomeColors.secondary,

          //         foregroundColor: HomeColors.white,

          //         padding: const EdgeInsets.symmetric(horizontal: 14),
          //       ),

          //       child: _isCheckingPincode
          //           ? const SizedBox(
          //               width: 18,
          //               height: 18,

          //               child: CircularProgressIndicator(
          //                 strokeWidth: 2,

          //                 color: HomeColors.white,
          //               ),
          //             )
          //           : const Text('Check'),
          //     ),
          //   ],
          // ),

          // PIN CODE MESSAGE
          // if (_pincodeMessage != null) ...[
          //   const SizedBox(height: 8),

          //   Text(
          //     _pincodeMessage!,

          //     style: TextStyle(
          //       color: _isPincodeValid ? HomeColors.success : HomeColors.error,

          //       fontSize: 12,
          //     ),
          //   ),
          // ],
          const SizedBox(height: 16),

          // ==================================================
          // PRODUCT TABLE HEADER
          // ==================================================
          const Row(
            children: [
              Expanded(
                child: Text(
                  'Product',

                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),

              Text('Total', style: TextStyle(fontWeight: FontWeight.w700)),
            ],
          ),

          const Divider(height: 20),

          // ==================================================
          // DYNAMIC CART PRODUCTS
          // ==================================================
          if (cartItems.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),

              child: Text(
                'Your cart is empty.',

                style: TextStyle(color: HomeColors.textSecondary),
              ),
            )
          else
            ...cartItems.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),

                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Expanded(
                      child: Text(
                        '${item.name} × ${item.quantity}',

                        style: const TextStyle(color: HomeColors.textPrimary),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Text(
                      '₹${(_parsePrice(item.price) * item.quantity).toStringAsFixed(2)}',

                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),

          const Divider(height: 20),

          // ==================================================
          // PRICE SUMMARY
          // ==================================================
          _SummaryRow(label: 'Total Base Price', amount: subtotal),

          const _SummaryRow(label: 'Discount', amount: 0),

          _SummaryRow(label: 'Subtotal', amount: subtotal),

          const _SummaryRow(label: 'Tax', amount: 0),

          const _SummaryRow(label: 'Total Shipping', amount: 0),

          const Divider(height: 20),

          // ==================================================
          // GRAND TOTAL
          // ==================================================
          _SummaryRow(label: 'Total', amount: subtotal, isEmphasized: true),

          const SizedBox(height: 12),

          // ==================================================
          // TERMS AND CONDITIONS
          // ==================================================
          Material(
            color: HomeColors.surface,

            child: CheckboxListTile(
              contentPadding: EdgeInsets.zero,

              controlAffinity: ListTileControlAffinity.leading,

              value: _agreedToTerms,

              activeColor: HomeColors.secondary,

              onChanged: (value) {
                setState(() {
                  _agreedToTerms = value ?? true;
                });
              },

              title: Wrap(
                children: [
                  const Text('I agree to the '),

                  _PolicyLink(
                    label: 'terms and conditions',

                    onTap: () => _openPolicy('https://lalbabaonline.com/terms'),
                  ),

                  const Text(', '),

                  _PolicyLink(
                    label: 'return policy',

                    onTap: () =>
                        _openPolicy('https://lalbabaonline.com/return-policy'),
                  ),

                  const Text(' & '),

                  _PolicyLink(
                    label: 'privacy policy',

                    onTap: () =>
                        _openPolicy('https://lalbabaonline.com/privacy-policy'),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),

          // ==================================================
          // RETURN TO DELIVERY PAGE
          // ==================================================
          TextButton(
            onPressed: () {
              Navigator.of(context).maybePop();
            },

            child: const Text(
              'Return to delivery',

              style: TextStyle(color: HomeColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // PRICE PARSER
  // ==========================================================

  static double _parsePrice(String value) {
    final normalized = value.replaceAll(RegExp(r'[^0-9.]'), '');

    return double.tryParse(normalized) ?? 0;
  }
}

// ============================================================
// COMMON SECTION CARD
// ============================================================

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child, this.trailing});

  final String title;

  final Widget child;

  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: HomeColors.surface,

        border: Border.all(color: HomeColors.border),

        borderRadius: BorderRadius.circular(8),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,

        children: [
          // SECTION HEADER

          Padding(
            padding: const EdgeInsets.all(16),

            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,

                    style: const TextStyle(
                      color: HomeColors.textPrimary,

                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                if (trailing != null) trailing!,
              ],
            ),
          ),

          const Divider(height: 1, color: HomeColors.divider),

          // SECTION CONTENT
          Padding(padding: const EdgeInsets.all(16), child: child),
        ],
      ),
    );
  }
}

// ============================================================
// PAYMENT METHOD OPTION CARD
// ============================================================

class _PaymentMethodOption extends StatelessWidget {
  const _PaymentMethodOption({
    required this.value,
    required this.selected,
    required this.title,
    required this.image,
    required this.onSelected,
  });

  final _PaymentMethod value;

  final bool selected;

  final String title;

  final Widget image;

  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelected,

      borderRadius: BorderRadius.circular(8),

      child: Container(
        width: 150,

        height: 150,

        padding: const EdgeInsets.all(12),

        decoration: BoxDecoration(
          color: HomeColors.surface,

          borderRadius: BorderRadius.circular(8),

          border: Border.all(
            color: selected ? HomeColors.secondary : HomeColors.border,

            width: selected ? 1.5 : 1,
          ),
        ),

        child: Column(
          children: [
            // PAYMENT ICON

            SizedBox(
              height: 30,
              width: double.infinity,
              child: Center(child: image),
            ),

            const SizedBox(height: 6),

            // PAYMENT TITLE
            Text(
              title,

              maxLines: 2,

              overflow: TextOverflow.ellipsis,

              textAlign: TextAlign.center,

              style: const TextStyle(
                color: HomeColors.textPrimary,

                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            // PAYMENT RADIO BUTTON
            Radio<_PaymentMethod>(
              value: value,

              visualDensity: VisualDensity.compact,

              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// PRICE SUMMARY ROW
// ============================================================

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.amount,
    this.isEmphasized = false,
  });

  final String label;

  final double amount;

  final bool isEmphasized;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),

      child: Row(
        children: [
          // SUMMARY LABEL

          Expanded(
            child: Text(
              label,

              style: TextStyle(
                color: HomeColors.textPrimary,

                fontWeight: isEmphasized ? FontWeight.w700 : FontWeight.w500,

                fontSize: isEmphasized ? 16 : 14,
              ),
            ),
          ),

          // SUMMARY AMOUNT
          Text(
            '₹${amount.toStringAsFixed(2)}',

            style: TextStyle(
              color: HomeColors.textPrimary,

              fontWeight: isEmphasized ? FontWeight.w700 : FontWeight.w600,

              fontSize: isEmphasized ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// POLICY LINK
// ============================================================

class _PolicyLink extends StatelessWidget {
  const _PolicyLink({required this.label, required this.onTap});

  final String label;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      link: true,

      child: InkWell(
        onTap: onTap,

        child: Text(
          label,

          style: const TextStyle(
            color: HomeColors.secondary,

            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
