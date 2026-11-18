import 'package:flutter/material.dart';

import '../../../../new_app/constantappbar.dart';
import '../../../../new_app/constantcolour.dart';
import '../../data/models/address_model.dart';
import '../../data/services/address_storage.dart';
import 'address_form_page.dart';

class NewShippingPage extends StatefulWidget {
  const NewShippingPage({super.key});

  @override
  State<NewShippingPage> createState() => _NewShippingPageState();
}

class _NewShippingPageState extends State<NewShippingPage> {
  List<AddressModel> _addresses = [];
  String? _selectedAddressId;
  bool _isLoading = true;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

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

  String? _findSelection(List<AddressModel> addresses, String? requestedId) {
    if (addresses.isEmpty) return null;

    for (final address in addresses) {
      if (address.id == requestedId) return address.id;
    }

    for (final address in addresses) {
      if (address.isDefault) return address.id;
    }

    return addresses.first.id;
  }

  Future<void> _selectAddress(AddressModel address) async {
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
    }
  }

  Future<void> _addAddress() async {
    final address = await Navigator.of(context).push<AddressModel>(
      MaterialPageRoute<AddressModel>(builder: (_) => const AddressFormPage()),
    );

    if (address == null || !mounted) return;

    try {
      await AddressStorage.upsertAddress(address);
      await _loadAddresses(preferredAddressId: address.id);
    } catch (error) {
      debugPrint('Shipping address save error: $error');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to save the new address.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HomeColors.background,
      appBar: const CommonAppBar(
        automaticallyImplyLeading: true,
        showBackButton: true,
        title: 'Shipping Address',
        backgroundColor: HomeColors.secondary,
        titleColor: HomeColors.white,
        iconColor: HomeColors.white,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: HomeColors.secondary),
            )
          : _loadError != null
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _loadError!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: HomeColors.textSecondary),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: _loadAddresses,
                    child: const Text(
                      'Retry',
                      style: TextStyle(color: HomeColors.secondary),
                    ),
                  ),
                ],
              ),
            )
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
                  Text(
                    'Choose a delivery address',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: HomeColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Your saved addresses are stored on this device until API sync is available.',
                    style: TextStyle(color: HomeColors.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  if (_addresses.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        'No saved addresses yet. Add one to continue.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: HomeColors.textSecondary),
                      ),
                    )
                  else
                    ..._addresses.map(_buildAddressCard),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: _addAddress,
                    icon: const Icon(Icons.add, color: HomeColors.secondary),
                    label: const Text(
                      'Add New Address',
                      style: TextStyle(color: HomeColors.secondary),
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
    );
  }

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
              Radio<String>(
                value: address.id,
                activeColor: HomeColors.secondary,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, right: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              address.addressType,
                              style: const TextStyle(
                                color: HomeColors.textPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          if (address.isDefault)
                            const Text(
                              'DEFAULT',
                              style: TextStyle(
                                color: HomeColors.secondary,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        address.name,
                        style: const TextStyle(
                          color: HomeColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        addressLines,
                        style: const TextStyle(
                          color: HomeColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Phone: ${address.phone}',
                        style: const TextStyle(color: HomeColors.textSecondary),
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
