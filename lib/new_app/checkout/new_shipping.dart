// import 'package:flutter/material.dart';

// import 'constantappbar.dart';
// import 'constantcolour.dart';
// import '../features/address/data/models/address_model.dart';
// import '../features/address/data/services/address_storage.dart';
// import '../features/address/presentation/page/address_form_page.dart';

// class NewShippingPage extends StatefulWidget {
//   const NewShippingPage({super.key});

//   @override
//   State<NewShippingPage> createState() => _NewShippingPageState();
// }

// class _NewShippingPageState extends State<NewShippingPage> {
//   List<AddressModel> _addresses = [];
//   String? _selectedAddressId;
//   bool _isLoading = true;
//   String? _loadError;

//   @override
//   void initState() {
//     super.initState();
//     _loadAddresses();
//   }

//   Future<void> _loadAddresses({String? preferredAddressId}) async {
//     setState(() {
//       _isLoading = true;
//       _loadError = null;
//     });

//     try {
//       final addresses = await AddressStorage.loadAddresses();
//       final storedAddressId = await AddressStorage.loadSelectedAddressId();
//       final selectedAddressId = _findSelection(
//         addresses,
//         preferredAddressId ?? storedAddressId,
//       );

//       if (selectedAddressId != storedAddressId) {
//         await AddressStorage.saveSelectedAddressId(selectedAddressId);
//       }

//       if (!mounted) return;
//       setState(() {
//         _addresses = addresses;
//         _selectedAddressId = selectedAddressId;
//       });
//     } catch (error) {
//       debugPrint('Shipping address load error: $error');
//       if (!mounted) return;
//       setState(() {
//         _loadError = 'Unable to load saved addresses. Please try again.';
//       });
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   String? _findSelection(
//     List<AddressModel> addresses,
//     String? requestedId,
//   ) {
//     if (addresses.isEmpty) return null;

//     for (final address in addresses) {
//       if (address.id == requestedId) return address.id;
//     }

//     for (final address in addresses) {
//       if (address.isDefault) return address.id;
//     }

//     return addresses.first.id;
//   }

//   Future<void> _selectAddress(AddressModel address) async {
//     try {
//       await AddressStorage.saveSelectedAddressId(address.id);
//       if (!mounted) return;
//       setState(() {
//         _selectedAddressId = address.id;
//       });
//     } catch (error) {
//       debugPrint('Shipping address selection error: $error');
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Unable to save your address selection.')),
//       );
//     }
//   }

//   Future<void> _addAddress() async {
//     final address = await Navigator.of(context).push<AddressModel>(
//       MaterialPageRoute<AddressModel>(
//         builder: (_) => const AddressFormPage(),
//       ),
//     );

//     if (address == null || !mounted) return;

//     try {
//       await AddressStorage.upsertAddress(address);
//       await _loadAddresses(preferredAddressId: address.id);
//     } catch (error) {
//       debugPrint('Shipping address save error: $error');
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Unable to save the new address.')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: HomeColors.background,
//       appBar: const CommonAppBar(
//         automaticallyImplyLeading: true,
//         showBackButton: true,
//         title: 'Shipping Address',
//         backgroundColor: HomeColors.secondary,
//         titleColor: HomeColors.white,
//         iconColor: HomeColors.white,
//       ),
//       body: _isLoading
//           ? const Center(
//               child: CircularProgressIndicator(color: HomeColors.secondary),
//             )
//           : _loadError != null
//           ? Center(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     _loadError!,
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(color: HomeColors.textSecondary),
//                   ),
//                   const SizedBox(height: 12),
//                   TextButton(
//                     onPressed: _loadAddresses,
//                     child: const Text(
//                       'Retry',
//                       style: TextStyle(color: HomeColors.secondary),
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           : RadioGroup<String>(
//               groupValue: _selectedAddressId,
//               onChanged: (addressId) {
//                 if (addressId == null) return;
//                 for (final address in _addresses) {
//                   if (address.id == addressId) {
//                     _selectAddress(address);
//                     return;
//                   }
//                 }
//               },
//               child: ListView(
//                 padding: const EdgeInsets.all(16),
//                 children: [
//                   Text(
//                     'Choose a delivery address',
//                     style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                       color: HomeColors.textPrimary,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                   const SizedBox(height: 6),
//                   const Text(
//                     'Your saved addresses are stored on this device until API sync is available.',
//                     style: TextStyle(color: HomeColors.textSecondary),
//                   ),
//                   const SizedBox(height: 16),
//                   if (_addresses.isEmpty)
//                     const Padding(
//                       padding: EdgeInsets.symmetric(vertical: 24),
//                       child: Text(
//                         'No saved addresses yet. Add one to continue.',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(color: HomeColors.textSecondary),
//                       ),
//                     )
//                   else
//                     ..._addresses.map(_buildAddressCard),
//                   const SizedBox(height: 12),
//                   OutlinedButton.icon(
//                     onPressed: _addAddress,
//                     icon: const Icon(Icons.add, color: HomeColors.secondary),
//                     label: const Text(
//                       'Add New Address',
//                       style: TextStyle(color: HomeColors.secondary),
//                     ),
//                     style: OutlinedButton.styleFrom(
//                       minimumSize: const Size.fromHeight(54),
//                       side: const BorderSide(color: HomeColors.border),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }

//   Widget _buildAddressCard(AddressModel address) {
//     final selected = address.id == _selectedAddressId;
//     final addressLines = [
//       address.address,
//       address.villageArea,
//       address.city,
//       address.state,
//       address.pin,
//     ].where((part) => part.trim().isNotEmpty).join(', ');

//     return Card(
//       margin: const EdgeInsets.only(bottom: 12),
//       color: HomeColors.surface,
//       elevation: 0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//         side: BorderSide(
//           color: selected ? HomeColors.secondary : HomeColors.border,
//           width: selected ? 1.5 : 1,
//         ),
//       ),
//       child: InkWell(
//         onTap: () => _selectAddress(address),
//         borderRadius: BorderRadius.circular(10),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Radio<String>(
//                 value: address.id,
//                 activeColor: HomeColors.secondary,
//               ),
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.only(top: 10, right: 8),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Text(
//                               address.addressType,
//                               style: const TextStyle(
//                                 color: HomeColors.textPrimary,
//                                 fontWeight: FontWeight.w700,
//                               ),
//                             ),
//                           ),
//                           if (address.isDefault)
//                             const Text(
//                               'DEFAULT',
//                               style: TextStyle(
//                                 color: HomeColors.secondary,
//                                 fontSize: 11,
//                                 fontWeight: FontWeight.w700,
//                               ),
//                             ),
//                         ],
//                       ),
//                       const SizedBox(height: 6),
//                       Text(
//                         address.name,
//                         style: const TextStyle(
//                           color: HomeColors.textSecondary,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         addressLines,
//                         style: const TextStyle(
//                           color: HomeColors.textSecondary,
//                           height: 1.4,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         'Phone: ${address.phone}',
//                         style: const TextStyle(
//                           color: HomeColors.textSecondary,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lalbaba_online/new_app/constant/new_constant_checkout_page.dart';

import '../constant/constantcolour.dart';
import '../constant/new_constant_text_styles.dart';

import '../../app/router/route_names.dart';
import '../../core/services/cart_service.dart';
import '../../core/services/cart_notification_item.dart';

import '../../features/address/data/models/address_model.dart';
import '../../features/address/data/services/address_storage.dart';
import '../../features/address/presentation/page/address_form_page.dart';

// ============================================================
// NEW SHIPPING PAGE
// ============================================================

class NewShippingPage extends StatefulWidget {
  const NewShippingPage({super.key});

  @override
  State<NewShippingPage> createState() => _NewShippingPageState();
}

class _NewShippingPageState extends State<NewShippingPage> {
  // ==========================================================
  // VARIABLES
  // ==========================================================

  List<AddressModel> _addresses = [];

  String? _selectedAddressId;

  bool _isLoading = true;
  bool _isSavingAddress = false;

  String? _loadError;

  // ==========================================================
  // INITIALIZE
  // ==========================================================

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  // ==========================================================
  // LOAD SAVED ADDRESSES
  // ==========================================================

  Future<void> _loadAddresses({String? preferredAddressId}) async {
    setState(() {
      _isLoading = true;
      _loadError = null;
    });

    try {
      final addresses = await AddressStorage.loadAddresses();

      final storedAddressId = await AddressStorage.loadSelectedAddressId();

      final selectedAddressId = _findSelection(
        addresses,
        preferredAddressId ?? storedAddressId,
      );

      if (selectedAddressId != storedAddressId) {
        await AddressStorage.saveSelectedAddressId(selectedAddressId);
      }

      if (!mounted) return;

      setState(() {
        _addresses = addresses;

        _selectedAddressId = selectedAddressId;
      });
    } catch (error) {
      debugPrint('Shipping address load error: $error');

      if (!mounted) return;

      setState(() {
        _loadError = 'Unable to load saved addresses. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // ==========================================================
  // FIND SELECTED ADDRESS
  // ==========================================================

  String? _findSelection(List<AddressModel> addresses, String? requestedId) {
    if (addresses.isEmpty) return null;

    for (final address in addresses) {
      if (address.id == requestedId) {
        return address.id;
      }
    }

    for (final address in addresses) {
      if (address.isDefault) {
        return address.id;
      }
    }

    return addresses.first.id;
  }

  // ==========================================================
  // SELECT ADDRESS
  // ==========================================================

  Future<void> _selectAddress(AddressModel address) async {
    if (_isSavingAddress || _isLoading) return;

    setState(() {
      _isSavingAddress = true;
    });

    try {
      await AddressStorage.saveSelectedAddressId(address.id);

      if (!mounted) return;

      setState(() {
        _selectedAddressId = address.id;
      });
    } catch (error) {
      debugPrint('Shipping address selection error: $error');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to save your address selection.')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSavingAddress = false;
        });
      }
    }
  }

  // ==========================================================
  // ADD NEW ADDRESS
  // ==========================================================

  Future<void> _addAddress() async {
    if (_isSavingAddress || _isLoading) return;

    final address = await Navigator.of(context).push<AddressModel>(
      MaterialPageRoute<AddressModel>(builder: (_) => const AddressFormPage()),
    );

    if (address == null || !mounted) return;

    setState(() {
      _isSavingAddress = true;
    });

    try {
      await AddressStorage.upsertAddress(address);

      if (!mounted) return;

      await _loadAddresses(preferredAddressId: address.id);
    } catch (error) {
      debugPrint('Shipping address save error: $error');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to save the new address.')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSavingAddress = false;
        });
      }
    }
  }

  // ==========================================================
  // GET SELECTED ADDRESS
  // ==========================================================

  AddressModel? get _selectedAddress {
    for (final address in _addresses) {
      if (address.id == _selectedAddressId) {
        return address;
      }
    }

    return null;
  }

  // ==========================================================
  // CONTINUE TO DELIVERY
  // ==========================================================

  Future<void> _continueToDelivery() async {
    final address = _selectedAddress;

    if (_isLoading ||
        _isSavingAddress ||
        _loadError != null ||
        address == null ||
        CartService.items.value.isEmpty) {
      return;
    }

    FocusScope.of(context).unfocus();

    await context.push<void>(RouteNames.newDelivery, extra: address);
  }

  // ==========================================================
  // MAIN BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HomeColors.background,

      // ======================================================
      // NO APP BAR IN SHIPPING PAGE
      // ======================================================
      body: SafeArea(
        child: Column(
          children: [
            // ================================================
            // CHECKOUT CONSTANT
            // SHIPPING INDEX = 1
            // ================================================

            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 0),

              child: NewConstantCheckout(
                currentIndex: NewConstantCheckout.shipping,
              ),
            ),

            const SizedBox(height: 8),

            // ================================================
            // SCROLLABLE ADDRESS SECTION
            // ================================================
            Expanded(
              child: _isLoading
                  // LOADING
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: HomeColors.secondary,
                      ),
                    )
                  // ERROR
                  : _loadError != null
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,

                        children: [
                          Text(
                            _loadError!,

                            textAlign: TextAlign.center,

                            style: HomeTextStyles.body.copyWith(
                              color: HomeColors.textSecondary,
                            ),
                          ),

                          const SizedBox(height: 12),

                          TextButton(
                            onPressed: _loadAddresses,

                            child: Text(
                              'Retry',

                              style: HomeTextStyles.button.copyWith(
                                color: HomeColors.secondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  // ADDRESS LIST
                  : RadioGroup<String>(
                      groupValue: _selectedAddressId,

                      onChanged: (addressId) {
                        if (addressId == null) return;

                        for (final address in _addresses) {
                          if (address.id == addressId) {
                            _selectAddress(address);
                            return;
                          }
                        }
                      },

                      child: ListView(
                        padding: const EdgeInsets.all(16),

                        children: [
                          // =================================
                          // ADDRESS SECTION TITLE
                          // =================================

                          Text(
                            'Choose a delivery address',

                            style: HomeTextStyles.sectionTitle.copyWith(
                              color: HomeColors.textPrimary,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            'Your saved addresses are stored on this device until API sync is available.',

                            style: HomeTextStyles.body.copyWith(
                              color: HomeColors.textSecondary,
                            ),
                          ),

                          const SizedBox(height: 16),

                          // =================================
                          // SAVED ADDRESSES
                          // =================================
                          if (_addresses.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24),

                              child: Text(
                                'No saved addresses yet. Add one to continue.',

                                textAlign: TextAlign.center,

                                style: HomeTextStyles.body.copyWith(
                                  color: HomeColors.textSecondary,
                                ),
                              ),
                            )
                          else
                            ..._addresses.map(_buildAddressCard),

                          const SizedBox(height: 12),

                          // =================================
                          // ADD NEW ADDRESS BUTTON
                          // =================================
                          OutlinedButton.icon(
                            onPressed: _isSavingAddress ? null : _addAddress,

                            icon: const Icon(
                              Icons.add,
                              color: HomeColors.secondary,
                            ),

                            label: Text(
                              'Add New Address',

                              style: HomeTextStyles.button.copyWith(
                                color: HomeColors.secondary,
                              ),
                            ),

                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(54),

                              side: const BorderSide(color: HomeColors.border),

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),

            // ================================================
            // FIXED COMMON CHECKOUT BOTTOM BUTTON
            // CONTINUE TO DELIVERY
            // ================================================
            ValueListenableBuilder<List<CartNotificationItem>>(
              valueListenable: CartService.items,

              builder: (context, items, child) {
                return NewCheckoutBottomBar(
                  currentIndex: NewConstantCheckout.shipping,

                  onContinue:
                      !_isLoading &&
                          !_isSavingAddress &&
                          _loadError == null &&
                          _selectedAddress != null &&
                          items.isNotEmpty
                      ?
                       _continueToDelivery
                      : null,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // SAVED ADDRESS CARD
  // ==========================================================

  Widget _buildAddressCard(AddressModel address) {
    final selected = address.id == _selectedAddressId;

    final addressLines = [
      address.address,
      address.villageArea,
      address.city,
      address.state,
      address.pin,
    ].where((part) => part.trim().isNotEmpty).join(', ');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),

      color: HomeColors.surface,

      elevation: 0,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),

        side: BorderSide(
          color: selected ? HomeColors.secondary : HomeColors.border,

          width: selected ? 1.5 : 1,
        ),
      ),

      child: InkWell(
        onTap: () => _selectAddress(address),

        borderRadius: BorderRadius.circular(10),

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),

          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // ==============================================
              // RADIO BUTTON
              // ==============================================

              Radio<String>(
                value: address.id,

                activeColor: HomeColors.secondary,
              ),

              // ==============================================
              // ADDRESS INFORMATION
              // ==============================================
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, right: 8),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      // ADDRESS TYPE

                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              address.addressType,

                              style: HomeTextStyles.body.copyWith(
                                color: HomeColors.textPrimary,

                                fontWeight: HomeTextStyles.bold,
                              ),
                            ),
                          ),

                          // DEFAULT ADDRESS LABEL
                          if (address.isDefault)
                            Text(
                              'DEFAULT',

                              style: HomeTextStyles.caption.copyWith(
                                color: HomeColors.secondary,

                                fontWeight: HomeTextStyles.bold,
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      // CUSTOMER NAME
                      Text(
                        address.name,

                        style: HomeTextStyles.bodyEmphasis.copyWith(
                          color: HomeColors.textSecondary,
                        ),
                      ),

                      const SizedBox(height: 4),

                      // FULL ADDRESS
                      Text(
                        addressLines,

                        style: HomeTextStyles.body.copyWith(
                          color: HomeColors.textSecondary,

                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 4),

                      // PHONE NUMBER
                      Text(
                        'Phone: ${address.phone}',

                        style: HomeTextStyles.body.copyWith(
                          color: HomeColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
