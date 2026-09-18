import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lalbaba_online/features/account/presentation/widgets/app_string.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../core/widgets/app_app_bar.dart';
import '../../data/models/address_model.dart';
import '../../data/models/location_model.dart';
import '../../data/services/location_service.dart';
import '../widgets/address_type_selector.dart';
import '../widgets/location_dropdown.dart';

class AddressFormPage extends StatefulWidget {
  final AddressModel? address;

  const AddressFormPage({super.key, this.address});

  bool get isEdit => address != null;

  @override
  State<AddressFormPage> createState() => _AddressFormPageState();
}

class _AddressFormPageState extends State<AddressFormPage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final villageController = TextEditingController();
  final pinController = TextEditingController();
  final addressController = TextEditingController();
  final landmarkController = TextEditingController();

  final Geocoding _geocoding = Geocoding();

  static const String country = 'India';

  List<LocationItem> states = [];
  List<LocationItem> cities = [];

  String? selectedState;
  String? selectedCity;

  String addressType = 'Home';

  bool stateLoading = false;
  bool cityLoading = false;
  bool isGettingLocation = false;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    _initializeForm();
  }

  // ============================================================
  // INITIALIZE
  // ============================================================

  void _initializeForm() {
    final address = widget.address;

    if (address != null) {
      nameController.text = address.name;
      phoneController.text = address.phone;
      villageController.text = address.villageArea;
      pinController.text = address.pin;
      addressController.text = address.address;
      landmarkController.text = address.landmark;

      selectedState = address.state;
      selectedCity = address.city;
      addressType = address.addressType;
    }

    _loadStates(selectedState: selectedState);
  }

  // ============================================================
  // LOAD STATES
  // ============================================================

  Future<void> _loadStates({String? selectedState}) async {
    if (stateLoading) return;

    setState(() {
      stateLoading = true;
    });

    try {
      final result = await LocationService.getStates(country);

      if (!mounted) return;

      final unique = _removeDuplicateLocations(result);

      if (selectedState != null && selectedState.trim().isNotEmpty) {
        _addLocationIfMissing(unique, selectedState);
      }

      setState(() {
        states = unique;
      });

      if (selectedState != null && selectedState.trim().isNotEmpty) {
        await _loadCities(selectedState, selectedCity: this.selectedCity);
      }
    } catch (e) {
      if (!mounted) return;

      _showError('Unable to load states.');
    } finally {
      if (mounted) {
        setState(() {
          stateLoading = false;
        });
      }
    }
  }

  // ============================================================
  // LOAD CITIES
  // ============================================================

  Future<void> _loadCities(String state, {String? selectedCity}) async {
    if (cityLoading) return;

    setState(() {
      cityLoading = true;
      cities = [];
    });

    try {
      final result = await LocationService.getCities(
        country: country,
        state: state,
      );

      if (!mounted) return;

      final unique = _removeDuplicateLocations(result);

      if (selectedCity != null && selectedCity.trim().isNotEmpty) {
        _addLocationIfMissing(unique, selectedCity);
      }

      setState(() {
        cities = unique;

        if (selectedCity != null && selectedCity.trim().isNotEmpty) {
          this.selectedCity = selectedCity;
        }
      });
    } catch (e) {
      if (!mounted) return;

      _showError('Unable to load cities.');
    } finally {
      if (mounted) {
        setState(() {
          cityLoading = false;
        });
      }
    }
  }

  // ============================================================
  // LOCATION HELPERS
  // ============================================================

  List<LocationItem> _removeDuplicateLocations(List<LocationItem> items) {
    final Map<String, LocationItem> unique = {};

    for (final item in items) {
      final key = item.name.trim().toLowerCase();

      if (key.isNotEmpty) {
        unique[key] = item;
      }
    }

    return unique.values.toList();
  }

  void _addLocationIfMissing(List<LocationItem> list, String value) {
    final exists = list.any(
      (item) => item.name.trim().toLowerCase() == value.trim().toLowerCase(),
    );

    if (!exists) {
      list.add(LocationItem(name: value));
    }
  }

  // ============================================================
  // CURRENT LOCATION
  // ============================================================

  Future<void> getCurrentLocation() async {
    if (isGettingLocation) return;

    final confirmed = await _showCurrentLocationConfirmation();

    if (confirmed != true) return;

    setState(() {
      isGettingLocation = true;
    });

    try {
      // --------------------------------------------------------
      // LOCATION SERVICE
      // --------------------------------------------------------

      final serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        if (!mounted) return;

        await _showLocationServiceDialog();
        return;
      }

      // --------------------------------------------------------
      // PERMISSION
      // --------------------------------------------------------

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        if (!mounted) return;

        await _showPermissionDeniedDialog();
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        if (!mounted) return;

        await _showPermissionDeniedForeverDialog();
        return;
      }

      // --------------------------------------------------------
      // GET POSITION
      // --------------------------------------------------------

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      // --------------------------------------------------------
      // REVERSE GEOCODING
      // --------------------------------------------------------

      final placemarks = await _geocoding.placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isEmpty) {
        throw Exception('Address not found');
      }

      final place = placemarks.first;

      final detectedCountry = place.country?.trim();

      final detectedState = place.administrativeArea?.trim();

      final detectedCity = place.locality?.trim();

      final detectedArea = place.subLocality?.trim();

      final detectedPin = place.postalCode?.trim();

      // --------------------------------------------------------
      // COUNTRY CHECK
      // --------------------------------------------------------

      if (detectedCountry != null &&
          detectedCountry.isNotEmpty &&
          detectedCountry.toLowerCase() != 'india') {
        if (!mounted) return;

        _showError('Current location is outside India.');

        return;
      }

      // --------------------------------------------------------
      // STATE + CITY
      // --------------------------------------------------------

      if (detectedState != null && detectedState.isNotEmpty) {
        _addLocationIfMissing(states, detectedState);

        selectedState = detectedState;

        try {
          final result = await LocationService.getCities(
            country: country,
            state: detectedState,
          );

          cities = _removeDuplicateLocations(result);
        } catch (_) {
          cities = [];
        }

        if (detectedCity != null && detectedCity.isNotEmpty) {
          _addLocationIfMissing(cities, detectedCity);

          selectedCity = detectedCity;
        }
      }

      // --------------------------------------------------------
      // AREA
      // --------------------------------------------------------

      if (detectedArea != null && detectedArea.isNotEmpty) {
        villageController.text = detectedArea;
      }

      // --------------------------------------------------------
      // PIN
      // --------------------------------------------------------

      if (detectedPin != null && detectedPin.isNotEmpty) {
        pinController.text = detectedPin;
      }

      // --------------------------------------------------------
      // FULL ADDRESS
      // --------------------------------------------------------
      // --------------------------------------------------------
      // FULL ADDRESS
      // --------------------------------------------------------

      final addressParts = <String>[];

      void addUniquePart(String? value) {
        final text = value?.trim();

        if (text == null || text.isEmpty) return;

        final exists = addressParts.any(
          (item) => item.toLowerCase() == text.toLowerCase(),
        );

        if (!exists) {
          addressParts.add(text);
        }
      }

      addUniquePart(detectedArea);
      addUniquePart(detectedCity);
      addUniquePart(detectedState);
      addUniquePart(detectedPin);

      addressController.text = addressParts.join(', ');
      if (!mounted) return;

      setState(() {});

      _showSuccess('Current location detected successfully.');
    } catch (e) {
      if (!mounted) return;

      _showError('Unable to detect current location.');
    } finally {
      if (mounted) {
        setState(() {
          isGettingLocation = false;
        });
      }
    }
  }

  // ============================================================
  // CONFIRMATION
  // ============================================================

  Future<bool?> _showCurrentLocationConfirmation() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Use Current Location',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
          ),
          content: Text(
            'We will use your current location to automatically fill your address details.',
            style: TextStyle(fontSize: 14.sp, height: 1.4),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // LOCATION SERVICE DIALOG
  // ============================================================

  Future<void> _showLocationServiceDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Location is Disabled'),
          content: const Text(
            'Please turn on Location Services to use your current location.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Open Settings'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      await Geolocator.openLocationSettings();
    }
  }

  // ============================================================
  // PERMISSION DENIED
  // ============================================================

  Future<void> _showPermissionDeniedDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Location Permission Required'),
          content: const Text(
            'Location permission was denied. Please allow location permission from app settings.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Open Settings'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      await Geolocator.openAppSettings();
    }
  }

  // ============================================================
  // DENIED FOREVER
  // ============================================================

  Future<void> _showPermissionDeniedForeverDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Location Permission Blocked'),
          content: const Text(
            'Location permission has been permanently denied. Please enable it from App Settings.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Open Settings'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      await Geolocator.openAppSettings();
    }
  }

  // ============================================================
  // SAVE
  // ============================================================

  Future<void> _saveAddress() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (selectedState == null || selectedState!.trim().isEmpty) {
      _showError('Please select state.');
      return;
    }

    if (selectedCity == null || selectedCity!.trim().isEmpty) {
      _showError('Please select city / district.');
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      final address = AddressModel(
        id:
            widget.address?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
        country: country,
        state: selectedState!,
        city: selectedCity!,
        villageArea: villageController.text.trim(),
        pin: pinController.text.trim(),
        address: addressController.text.trim(),
        landmark: landmarkController.text.trim(),
        addressType: addressType,
        isDefault: widget.address?.isDefault ?? false,
      );

      debugPrint('ADDRESS: ${address.name}');

      // ========================================================
      // TODO:
      // API / Repository / Riverpod Provider
      // ========================================================

      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;

      Navigator.pop(context, address);
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  // ============================================================
  // TEXT FIELD
  // ============================================================

  Widget _textField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    TextInputType? keyboardType,
    int maxLines = 1,
    int minLines = 1,

    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15.h),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        minLines: minLines,
        validator: validator,
        autofocus: false,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          // prefixIcon: Icon(icon),
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.r),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.r),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.r),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SUCCESS
  // ============================================================

  void _showSuccess(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
  }

  // ============================================================
  // ERROR
  // ============================================================

  void _showError(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    villageController.dispose();
    pinController.dispose();
    addressController.dispose();
    landmarkController.dispose();

    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.isEdit;

    return Scaffold(
      appBar: AppAppBar(
        title: isEdit ? AppStrings.updateAddress : AppStrings.addAddress,
        automaticallyImplyLeading: true,
      ),

      //  AppBar(
      //   title:
      //   Text(
      //     isEdit ? 'Update Address' : 'Add Address',
      //     style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
      //   ),
      // ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },

        child: SafeArea(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(AppSizes.screenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // =================================================
                  // CURRENT LOCATION CARD
                  // =================================================
                  _CurrentLocationCard(
                    loading: isGettingLocation,
                    onTap: getCurrentLocation,
                  ),

                  SizedBox(height: 20.h),

                  // =================================================
                  // PERSONAL DETAILS
                  // =================================================
                  _SectionTitle(
                    title: AppStrings.personalDetails,
                    icon: Icons.person_outline,
                  ),

                  SizedBox(height: 12.h),

                  _textField(
                    label: AppStrings.fullName,
                    hint: AppStrings.enterFullName,
                    icon: Icons.person_outline,
                    controller: nameController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return AppStrings.enterFullName;
                      }
                      return null;
                    },
                  ),

                  _textField(
                    label: AppStrings.phoneNumber,
                    hint: AppStrings.enterPhoneNumber,
                    icon: Icons.phone_outlined,
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return AppStrings.phoneNumber;
                      }

                      if (value.trim().length != 10) {
                        return 'Enter valid 10 digit phone number';
                      }

                      return null;
                    },
                  ),

                  // =================================================
                  // LOCATION
                  // =================================================
                  SizedBox(height: 5.h),

                  _SectionTitle(
                    title: AppStrings.location,
                    icon: Icons.location_on_outlined,
                  ),

                  SizedBox(height: 12.h),

                  // COUNTRY
                  LocationDropdown(
                    label: AppStrings.country,
                    hint: 'India',
                    icon: Icons.public,
                    items: const [LocationItem(name: 'India')],
                    value: country,
                    enabled: false,
                    onChanged: (_) {},
                  ),

                  // STATE
                  LocationDropdown(
                    label: AppStrings.state,
                    hint: stateLoading
                        ? 'Loading states...'
                        : AppStrings.selectState,
                    icon: Icons.location_city_outlined,
                    items: states,
                    value: selectedState,
                    loading: stateLoading,
                    enabled: !stateLoading && states.isNotEmpty,
                    onChanged: (value) {
                      if (value == null || value.isEmpty) {
                        return;
                      }

                      setState(() {
                        selectedState = value;
                        selectedCity = null;
                        cities = [];
                      });

                      _loadCities(value);
                    },
                  ),

                  // CITY
                  LocationDropdown(
                    label: AppStrings.cityDistrict,
                    hint: selectedState == null
                        ? AppStrings.selectStateFirst
                        : cityLoading
                        ? 'Loading cities...'
                        : AppStrings.selectCityDistrict,
                    icon: Icons.location_on_outlined,
                    items: cities,
                    value: selectedCity,
                    loading: cityLoading,
                    enabled:
                        selectedState != null &&
                        !cityLoading &&
                        cities.isNotEmpty,
                    onChanged: (value) {
                      if (value == null || value.isEmpty) {
                        return;
                      }

                      setState(() {
                        selectedCity = value;
                      });
                    },
                  ),

                  _textField(
                    label: AppStrings.villageArea,
                    hint: AppStrings.villageOrArea,
                    icon: Icons.home_work_outlined,
                    controller: villageController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return AppStrings.selectVillageOrArea;
                      }

                      return null;
                    },
                  ),

                  _textField(
                    label: AppStrings.pinCode,
                    hint: AppStrings.enterPinCode,
                    icon: Icons.pin_drop_outlined,
                    controller: pinController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return AppStrings.enterPinCode;
                      }

                      if (value.trim().length != 6) {
                        return 'Enter valid 6 digit PIN code';
                      }

                      return null;
                    },
                  ),

                  // =================================================
                  // ADDRESS
                  // =================================================
                  SizedBox(height: 5.h),

                  // _SectionTitle(
                  //   title: 'Address Details',
                  //   icon: Icons.home_outlined,
                  // ),
                  // SizedBox(height: 12.h),
                  _textField(
                    label: AppStrings.address,
                    hint: AppStrings.enterAddress,
                    icon: Icons.home_outlined,
                    controller: addressController,
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return AppStrings.deliveryAddressSubtitle;
                      }

                      return null;
                    },
                  ),

                  _textField(
                    label: AppStrings.nearbyLandmark,
                    hint: AppStrings.nearbyLandmarkHint,
                    icon: Icons.place_outlined,
                    controller: landmarkController,
                  ),

                  // =================================================
                  // ADDRESS TYPE
                  // =================================================
                  SizedBox(height: 3.h),

                  _SectionTitle(
                    title: AppStrings.addressType,
                    icon: Icons.place_outlined,
                  ),

                  SizedBox(height: 12.h),

                  AddressTypeSelector(
                    value: addressType,
                    onChanged: (value) {
                      setState(() {
                        addressType = value;
                      });
                    },
                  ),

                  SizedBox(height: 25.h),

                  // =================================================
                  // SAVE / UPDATE
                  // =================================================
                  SizedBox(
                    width: double.infinity,
                    height: 52.h,
                    child: ElevatedButton(
                      onPressed: isSaving ? null : _saveAddress,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),
                      child: isSaving
                          ? SizedBox(
                              width: 21.w,
                              height: 21.w,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              isEdit
                                  ? AppStrings.updateAddress
                                  : AppStrings.saveAddress,
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),

                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ================================================================
// SECTION TITLE
// ================================================================

class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionTitle({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Icon(icon, size: 19.sp, color: AppColors.primary),
        // SizedBox(width: 7.w),
        Text(
          title,
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

// ================================================================
// CURRENT LOCATION CARD
// ================================================================

class _CurrentLocationCard extends StatelessWidget {
  final bool loading;
  final VoidCallback onTap;

  const _CurrentLocationCard({required this.loading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: loading ? null : onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(15.w),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.18)),
        ),
        child: Row(
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: loading
                  ? Padding(
                      padding: EdgeInsets.all(12.w),
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.my_location, color: Colors.white),
            ),

            SizedBox(width: 12.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loading
                        ? AppStrings.detectingLocation
                        : AppStrings.useCurrentLocation,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  SizedBox(height: 3.h),

                  Text(
                    loading
                        ? 'Please wait while we detect your address'
                        : 'Automatically fill your address details using GPS',
                    style: TextStyle(
                      fontSize: 11.5.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            if (!loading)
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 15.sp,
                color: AppColors.primary,
              ),
          ],
        ),
      ),
    );
  }
}
