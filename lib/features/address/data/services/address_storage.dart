import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/address_model.dart';

class AddressStorage {
  AddressStorage._();

  static const String _addressesKey = 'saved_addresses';
  static const String selectedAddressIdKey = 'selected_shipping_address_id';

  static Future<List<AddressModel>> loadAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString(_addressesKey);

    if (savedData == null || savedData.isEmpty) {
      return [];
    }

    final decoded = jsonDecode(savedData);
    if (decoded is! List) {
      throw const FormatException('Saved addresses must be a list.');
    }

    return decoded.map((item) {
      if (item is! Map) {
        throw const FormatException('A saved address is invalid.');
      }

      return AddressModel.fromJson(Map<String, dynamic>.from(item));
    }).toList();
  }

  static Future<void> saveAddresses(List<AddressModel> addresses) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(
      addresses.map((address) => address.toJson()).toList(),
    );
    await prefs.setString(_addressesKey, encoded);
  }

  static Future<void> upsertAddress(AddressModel address) async {
    final addresses = await loadAddresses();
    final index = addresses.indexWhere((item) => item.id == address.id);

    if (index == -1) {
      addresses.add(address);
    } else {
      addresses[index] = address;
    }

    await saveAddresses(addresses);
  }

  static Future<String?> loadSelectedAddressId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(selectedAddressIdKey);
  }

  static Future<void> saveSelectedAddressId(String? addressId) async {
    final prefs = await SharedPreferences.getInstance();

    if (addressId == null) {
      await prefs.remove(selectedAddressIdKey);
    } else {
      await prefs.setString(selectedAddressIdKey, addressId);
    }
  }
}
