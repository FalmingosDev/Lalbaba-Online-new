// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:lalbaba_online/core/widgets/app_app_bar.dart';
// import 'package:lalbaba_online/features/account/presentation/widgets/app_string.dart';

// import '../../../../app/theme/app_colors.dart';
// import '../../data/models/address_model.dart';
// import '../widgets/address_card.dart';
// import 'address_form_page.dart';

// class AddressListPage extends StatefulWidget {
//   const AddressListPage({super.key});

//   @override
//   State<AddressListPage> createState() => _AddressListPageState();
// }

// class _AddressListPageState extends State<AddressListPage> {
//   // ============================================================
//   // TEMP LOCAL DATA
//   // ============================================================

//   final List<AddressModel> addresses = [

//   ];

//   // ============================================================
//   // ADD
//   // ============================================================

//   Future<void> _addAddress() async {
//     final result = await Navigator.push<AddressModel>(
//       context,
//       MaterialPageRoute(builder: (_) => const AddressFormPage()),
//     );

//     if (result == null) return;

//     setState(() {
//       addresses.add(result);
//     });
//   }

//   // ============================================================
//   // EDIT
//   // ============================================================

//   Future<void> _editAddress(AddressModel address) async {
//     final result = await Navigator.push<AddressModel>(
//       context,
//       MaterialPageRoute(builder: (_) => AddressFormPage(address: address)),
//     );

//     if (result == null) return;

//     final index = addresses.indexWhere((item) => item.id == address.id);

//     if (index == -1) return;

//     setState(() {
//       addresses[index] = result;
//     });
//   }

//   // ============================================================
//   // DELETE
//   // ============================================================

//   Future<void> _deleteAddress(AddressModel address) async {
//     final confirm = await showDialog<bool>(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Delete Address?'),
//           content: const Text('Are you sure you want to delete this address?'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context, false),
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () => Navigator.pop(context, true),
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//               child: const Text(
//                 'Delete',
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ],
//         );
//       },
//     );

//     if (confirm != true) return;

//     setState(() {
//       addresses.removeWhere((item) => item.id == address.id);
//     });
//   }

//   // ============================================================
//   // SET DEFAULT
//   // ============================================================

//   void _setDefault(AddressModel address) {
//     setState(() {
//       for (int i = 0; i < addresses.length; i++) {
//         addresses[i] = addresses[i].copyWith(
//           isDefault: addresses[i].id == address.id,
//         );
//       }
//     });
//   }

//   // ============================================================
//   // BUILD
//   // ============================================================

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppAppBar(
//         title: AppStrings.myAddress,
//         automaticallyImplyLeading: true,
//       ),

//       //AppBar(title: Text(AppStrings.myAddress)),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: _addAddress,
//         backgroundColor: AppColors.primary,
//         icon: const Icon(Icons.add_location_alt_outlined, color: Colors.white),
//         label: Text(
//           AppStrings.addAddress,
//           style: TextStyle(color: Colors.white),
//         ),
//       ),

//       body: addresses.isEmpty
//           ? _buildEmptyState()
//           : ListView.builder(
//               padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 100.h),
//               itemCount: addresses.length,
//               itemBuilder: (context, index) {
//                 final address = addresses[index];

//                 return AddressCard(
//                   address: address,
//                   onEdit: () => _editAddress(address),
//                   onDelete: () => _deleteAddress(address),
//                   onSetDefault: () => _setDefault(address),
//                 );
//               },
//             ),
//     );
//   }

//   // ============================================================
//   // EMPTY STATE
//   // ============================================================

//   Widget _buildEmptyState() {
//     return Center(
//       child: Padding(
//         padding: EdgeInsets.all(30.w),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               width: 85.w,
//               height: 85.w,
//               decoration: BoxDecoration(
//                 color: AppColors.primary.withValues(alpha: 0.08),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 Icons.location_on_outlined,
//                 size: 42.sp,
//                 color: AppColors.primary,
//               ),
//             ),

//             SizedBox(height: 18.h),

//             Text(
//               AppStrings.noAddressAdded,
//               style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
//             ),

//             SizedBox(height: 7.h),

//             Text(
//               AppStrings.addDeliveryAddressToContinue,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 13.sp,
//                 height: 1.4,
//                 color: Colors.grey.shade600,
//               ),
//             ),

//             // SizedBox(height: 20.h),

//             // SizedBox(
//             //   height: 46.h,
//             //   child: ElevatedButton.icon(
//             //     onPressed: _addAddress,
//             //     icon: const Icon(Icons.add),
//             //     label: const Text('Add New Address'),
//             //     style: ElevatedButton.styleFrom(
//             //       backgroundColor: AppColors.primary,
//             //       foregroundColor: Colors.white,
//             //       shape: RoundedRectangleBorder(
//             //         borderRadius: BorderRadius.circular(12.r),
//             //       ),
//             //     ),
//             //   ),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lalbaba_online/core/widgets/app_app_bar.dart';
import 'package:lalbaba_online/features/account/presentation/widgets/app_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../app/theme/app_colors.dart';
import '../../data/models/address_model.dart';
import '../widgets/address_card.dart';
import 'address_form_page.dart';

class AddressListPage extends StatefulWidget {
  const AddressListPage({super.key});

  @override
  State<AddressListPage> createState() => _AddressListPageState();
}

class _AddressListPageState extends State<AddressListPage> {
  // ============================================================
  // SHARED PREFERENCE KEY
  // ============================================================

  static const String _addressStorageKey = 'saved_addresses';

  // ============================================================
  // ADDRESS LIST
  // ============================================================

  final List<AddressModel> addresses = [];

  bool _isLoading = true;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    _loadAddresses();
  }

  // ============================================================
  // LOAD ADDRESS FROM SHARED PREFERENCES
  // ============================================================

  Future<void> _loadAddresses() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final String? savedData = prefs.getString(_addressStorageKey);

      if (savedData != null && savedData.isNotEmpty) {
        final List<dynamic> decodedData = jsonDecode(savedData);

        final List<AddressModel> loadedAddresses = decodedData
            .map(
              (item) => AddressModel.fromJson(
                Map<String, dynamic>.from(item),
              ),
            )
            .toList();

        if (!mounted) return;

        setState(() {
          addresses.clear();
          addresses.addAll(loadedAddresses);
        });
      }
    } catch (e) {
      debugPrint('Address load error: $e');
    }

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });
  }

  // ============================================================
  // SAVE ADDRESS TO SHARED PREFERENCES
  // ============================================================

  Future<void> _saveAddresses() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final List<Map<String, dynamic>> addressJsonList =
          addresses.map((address) => address.toJson()).toList();

      final String encodedData = jsonEncode(addressJsonList);

      await prefs.setString(
        _addressStorageKey,
        encodedData,
      );

      debugPrint('Addresses saved successfully');
    } catch (e) {
      debugPrint('Address save error: $e');
    }
  }

  // ============================================================
  // ADD
  // ============================================================

  Future<void> _addAddress() async {
    final result = await Navigator.push<AddressModel>(
      context,
      MaterialPageRoute(
        builder: (_) => const AddressFormPage(),
      ),
    );

    if (result == null) return;

    setState(() {
      addresses.add(result);
    });

    // Save in SharedPreferences
    await _saveAddresses();
  }

  // ============================================================
  // EDIT
  // ============================================================

  Future<void> _editAddress(AddressModel address) async {
    final result = await Navigator.push<AddressModel>(
      context,
      MaterialPageRoute(
        builder: (_) => AddressFormPage(
          address: address,
        ),
      ),
    );

    if (result == null) return;

    final index = addresses.indexWhere(
      (item) => item.id == address.id,
    );

    if (index == -1) return;

    setState(() {
      addresses[index] = result;
    });

    // Save updated list
    await _saveAddresses();
  }

  // ============================================================
  // DELETE
  // ============================================================

  Future<void> _deleteAddress(AddressModel address) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Delete Address?',
          ),
          content: const Text(
            'Are you sure you want to delete this address?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  false,
                );
              },
              child: const Text(
                'Cancel',
              ),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  true,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    setState(() {
      addresses.removeWhere(
        (item) => item.id == address.id,
      );
    });

    // Save updated list
    await _saveAddresses();
  }

  // ============================================================
  // SET DEFAULT
  // ============================================================

  Future<void> _setDefault(AddressModel address) async {
    setState(() {
      for (int i = 0; i < addresses.length; i++) {
        addresses[i] = addresses[i].copyWith(
          isDefault: addresses[i].id == address.id,
        );
      }
    });

    // Save default address
    await _saveAddresses();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        title: AppStrings.myAddress,
        automaticallyImplyLeading: true,
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addAddress,
        backgroundColor: AppColors.primary,
        icon: const Icon(
          Icons.add_location_alt_outlined,
          color: Colors.white,
        ),
        label: Text(
          AppStrings.addAddress,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),

      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : addresses.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: EdgeInsets.fromLTRB(
                    16.w,
                    16.h,
                    16.w,
                    100.h,
                  ),
                  itemCount: addresses.length,
                  itemBuilder: (context, index) {
                    final address = addresses[index];

                    return AddressCard(
                      address: address,
                      onEdit: () {
                        _editAddress(address);
                      },
                      onDelete: () {
                        _deleteAddress(address);
                      },
                      onSetDefault: () {
                        _setDefault(address);
                      },
                    );
                  },
                ),
    );
  }

  // ============================================================
  // EMPTY STATE
  // ============================================================

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(30.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 85.w,
              height: 85.w,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(
                  alpha: 0.08,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.location_on_outlined,
                size: 42.sp,
                color: AppColors.primary,
              ),
            ),

            SizedBox(
              height: 18.h,
            ),

            Text(
              AppStrings.noAddressAdded,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
            ),

            SizedBox(
              height: 7.h,
            ),

            Text(
              AppStrings.addDeliveryAddressToContinue,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                height: 1.4,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}