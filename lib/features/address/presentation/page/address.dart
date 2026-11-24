

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';

// import '../../data/models/location_model.dart';
// import '../../data/services/location_service.dart';
// import '../widgets/location_dropdown.dart';

// class AddressPage extends StatefulWidget {
//   const AddressPage({super.key});

//   @override
//   State<AddressPage> createState() => _AddressPageState();
// }

// class _AddressPageState extends State<AddressPage> {
//   // ============================================================
//   // FORM
//   // ============================================================

//   final _formKey = GlobalKey<FormState>();

//   final TextEditingController nameController = TextEditingController();

//   final TextEditingController phoneController = TextEditingController();

//   final TextEditingController villageController = TextEditingController();

//   final TextEditingController pinController = TextEditingController();

//   final TextEditingController addressController = TextEditingController();

//   final TextEditingController landmarkController = TextEditingController();

//   // ============================================================
//   // COUNTRY
//   // ============================================================

//   static const String selectedCountry = 'India';

//   // ============================================================
//   // LOCATION DATA
//   // ============================================================

//   List<LocationItem> states = [];
//   List<LocationItem> cities = [];

//   String? selectedState;
//   String? selectedCity;

//   // ============================================================
//   // LOADING
//   // ============================================================

//   bool stateLoading = false;
//   bool cityLoading = false;
//   bool isGettingLocation = false;

//   // ============================================================
//   // ADDRESS TYPE
//   // ============================================================
//   final Geocoding _geocoding = Geocoding();
//   String addressType = 'Home';

//   // ============================================================
//   // INIT
//   // ============================================================

//   @override
//   void initState() {
//     super.initState();

//     _loadStates();
//   }

//   // ============================================================
//   // DISPOSE
//   // ============================================================

//   @override
//   void dispose() {
//     nameController.dispose();
//     phoneController.dispose();
//     villageController.dispose();
//     pinController.dispose();
//     addressController.dispose();
//     landmarkController.dispose();

//     super.dispose();
//   }

//   // ============================================================
//   // LOAD STATES
//   // ============================================================

//   Future<void> _loadStates() async {
//     if (stateLoading) {
//       return;
//     }

//     setState(() {
//       stateLoading = true;
//     });

//     try {
//       final result = await LocationService.getStates(selectedCountry);

//       if (!mounted) {
//         return;
//       }

//       setState(() {
//         states = _removeDuplicateLocations(result);
//       });
//     } catch (e) {
//       if (!mounted) {
//         return;
//       }

//       _showError('Unable to load states. Please try again.');
//     } finally {
//       if (mounted) {
//         setState(() {
//           stateLoading = false;
//         });
//       }
//     }
//   }

//   // ============================================================
//   // LOAD CITIES
//   // ============================================================

//   Future<void> _loadCities(String state) async {
//     if (cityLoading) {
//       return;
//     }

//     setState(() {
//       cityLoading = true;
//       cities = [];
//       selectedCity = null;
//     });

//     try {
//       final result = await LocationService.getCities(
//         country: selectedCountry,
//         state: state,
//       );

//       if (!mounted) {
//         return;
//       }

//       setState(() {
//         cities = _removeDuplicateLocations(result);
//       });
//     } catch (e) {
//       if (!mounted) {
//         return;
//       }

//       _showError('Unable to load cities. Please try again.');
//     } finally {
//       if (mounted) {
//         setState(() {
//           cityLoading = false;
//         });
//       }
//     }
//   }

//   // ============================================================
//   // REMOVE DUPLICATES
//   // ============================================================

//   List<LocationItem> _removeDuplicateLocations(List<LocationItem> items) {
//     final Map<String, LocationItem> unique = {};

//     for (final item in items) {
//       final key = item.name.trim().toLowerCase();

//       if (key.isNotEmpty) {
//         unique[key] = item;
//       }
//     }

//     return unique.values.toList();
//   }

//   // ============================================================
//   // ADD VALUE IF NOT PRESENT
//   // ============================================================

//   void _addStateIfMissing(String stateName) {
//     final exists = states.any(
//       (item) =>
//           item.name.trim().toLowerCase() == stateName.trim().toLowerCase(),
//     );

//     if (!exists) {
//       states = [...states, LocationItem(name: stateName)];
//     }
//   }

//   void _addCityIfMissing(String cityName) {
//     final exists = cities.any(
//       (item) => item.name.trim().toLowerCase() == cityName.trim().toLowerCase(),
//     );

//     if (!exists) {
//       cities = [...cities, LocationItem(name: cityName)];
//     }
//   }

//   // ============================================================
//   // CURRENT LOCATION
//   // ============================================================

//   Future<void> getCurrentLocation() async {
//     if (isGettingLocation) {
//       return;
//     }

//     // ----------------------------------------------------------
//     // CONFIRMATION
//     // ----------------------------------------------------------

//     final shouldContinue = await showDialog<bool>(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Use Current Location?'),
//           content: const Text(
//             'Your current location will be used to automatically fill your address details.',
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context, false);
//               },
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context, true);
//               },
//               child: const Text('Continue'),
//             ),
//           ],
//         );
//       },
//     );

//     if (shouldContinue != true) {
//       return;
//     }

//     setState(() {
//       isGettingLocation = true;
//     });

//     try {
//       // --------------------------------------------------------
//       // LOCATION SERVICE
//       // --------------------------------------------------------

//       final serviceEnabled = await Geolocator.isLocationServiceEnabled();

//       if (!serviceEnabled) {
//         if (!mounted) {
//           return;
//         }

//         await _showLocationServiceDialog();
//         return;
//       }

//       // --------------------------------------------------------
//       // PERMISSION
//       // --------------------------------------------------------

//       LocationPermission permission = await Geolocator.checkPermission();

//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//       }

//       // --------------------------------------------------------
//       // DENIED
//       // --------------------------------------------------------

//       if (permission == LocationPermission.denied) {
//         if (!mounted) {
//           return;
//         }

//         await _showPermissionDeniedDialog();
//         return;
//       }

//       // --------------------------------------------------------
//       // DENIED FOREVER
//       // --------------------------------------------------------

//       if (permission == LocationPermission.deniedForever) {
//         if (!mounted) {
//           return;
//         }

//         await _showPermissionDeniedForeverDialog();
//         return;
//       }

//       // --------------------------------------------------------
//       // GET GPS
//       // --------------------------------------------------------

//       final position = await Geolocator.getCurrentPosition(
//         locationSettings: const LocationSettings(
//           accuracy: LocationAccuracy.high,
//         ),
//       );

//       // --------------------------------------------------------
//       // REVERSE GEOCODING
//       // --------------------------------------------------------

//       final placemarks = await _geocoding.placemarkFromCoordinates(
//         position.latitude,
//         position.longitude,
//       );

//       if (placemarks.isEmpty) {
//         throw Exception('Unable to detect address');
//       }

//       final place = placemarks.first;

//       final detectedCountry = place.country?.trim();

//       final detectedState = place.administrativeArea?.trim();

//       final detectedCity = place.locality?.trim();

//       final detectedArea = place.subLocality?.trim();

//       final detectedPin = place.postalCode?.trim();

//       // --------------------------------------------------------
//       // ONLY INDIA
//       // --------------------------------------------------------

//       if (detectedCountry != null &&
//           detectedCountry.isNotEmpty &&
//           detectedCountry.toLowerCase() != 'india') {
//         if (!mounted) {
//           return;
//         }

//         _showError('Current location is outside India.');

//         return;
//       }

//       // --------------------------------------------------------
//       // STATE
//       // --------------------------------------------------------

//       if (detectedState != null && detectedState.isNotEmpty) {
//         _addStateIfMissing(detectedState);

//         selectedState = detectedState;

//         // Load cities dynamically.
//         try {
//           final result = await LocationService.getCities(
//             country: selectedCountry,
//             state: detectedState,
//           );

//           cities = _removeDuplicateLocations(result);
//         } catch (_) {
//           cities = [];
//         }
//       }

//       // --------------------------------------------------------
//       // CITY
//       // --------------------------------------------------------

//       if (detectedCity != null && detectedCity.isNotEmpty) {
//         _addCityIfMissing(detectedCity);

//         selectedCity = detectedCity;
//       }

//       // --------------------------------------------------------
//       // AREA / VILLAGE
//       // --------------------------------------------------------

//       if (detectedArea != null && detectedArea.isNotEmpty) {
//         villageController.text = detectedArea;
//       }

//       // --------------------------------------------------------
//       // PIN
//       // --------------------------------------------------------

//       if (detectedPin != null && detectedPin.isNotEmpty) {
//         pinController.text = detectedPin;
//       }

//       // --------------------------------------------------------
//       // FULL ADDRESS
//       // --------------------------------------------------------

//       final addressParts = <String>[];

//       final name = place.name?.trim();
//       final street = place.street?.trim();
//       final thoroughfare = place.thoroughfare?.trim();
//       final subThoroughfare = place.subThoroughfare?.trim();

//       if (name != null && name.isNotEmpty) {
//         addressParts.add(name);
//       }

//       if (street != null &&
//           street.isNotEmpty &&
//           !addressParts.contains(street)) {
//         addressParts.add(street);
//       }

//       if (thoroughfare != null &&
//           thoroughfare.isNotEmpty &&
//           !addressParts.contains(thoroughfare)) {
//         addressParts.add(thoroughfare);
//       }

//       if (subThoroughfare != null &&
//           subThoroughfare.isNotEmpty &&
//           !addressParts.contains(subThoroughfare)) {
//         addressParts.add(subThoroughfare);
//       }

//       if (detectedArea != null &&
//           detectedArea.isNotEmpty &&
//           !addressParts.contains(detectedArea)) {
//         addressParts.add(detectedArea);
//       }

//       if (detectedCity != null &&
//           detectedCity.isNotEmpty &&
//           !addressParts.contains(detectedCity)) {
//         addressParts.add(detectedCity);
//       }

//       if (detectedState != null &&
//           detectedState.isNotEmpty &&
//           !addressParts.contains(detectedState)) {
//         addressParts.add(detectedState);
//       }

//       if (detectedPin != null &&
//           detectedPin.isNotEmpty &&
//           !addressParts.contains(detectedPin)) {
//         addressParts.add(detectedPin);
//       }

//       addressController.text = addressParts.join(', ');

//       // --------------------------------------------------------
//       // SUCCESS
//       // --------------------------------------------------------

//       if (!mounted) {
//         return;
//       }

//       setState(() {});

//       _showSuccess('Current location detected successfully.');
//     } catch (e) {
//       if (!mounted) {
//         return;
//       }

//       _showError('Unable to detect your current location.');
//     } finally {
//       if (mounted) {
//         setState(() {
//           isGettingLocation = false;
//         });
//       }
//     }
//   }

//   // ============================================================
//   // LOCATION SERVICE OFF
//   // ============================================================

//   Future<void> _showLocationServiceDialog() async {
//     final openSettings = await showDialog<bool>(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Location is Disabled'),
//           content: const Text(
//             'Please turn on Location Services to use your current location.',
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context, false);
//               },
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context, true);
//               },
//               child: const Text('Open Settings'),
//             ),
//           ],
//         );
//       },
//     );

//     if (openSettings == true) {
//       await Geolocator.openLocationSettings();
//     }
//   }

//   // ============================================================
//   // PERMISSION DENIED
//   // ============================================================

//   Future<void> _showPermissionDeniedDialog() async {
//     final openSettings = await showDialog<bool>(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Location Permission Required'),
//           content: const Text(
//             'Location permission was denied. Please allow location permission from app settings to use your current location.',
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context, false);
//               },
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context, true);
//               },
//               child: const Text('Open Settings'),
//             ),
//           ],
//         );
//       },
//     );

//     if (openSettings == true) {
//       await Geolocator.openAppSettings();
//     }
//   }

//   // ============================================================
//   // PERMISSION DENIED FOREVER
//   // ============================================================

//   Future<void> _showPermissionDeniedForeverDialog() async {
//     final openSettings = await showDialog<bool>(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Location Permission Blocked'),
//           content: const Text(
//             'Location permission has been permanently denied. Please enable Location permission from App Settings.',
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context, false);
//               },
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context, true);
//               },
//               child: const Text('Open Settings'),
//             ),
//           ],
//         );
//       },
//     );

//     if (openSettings == true) {
//       await Geolocator.openAppSettings();
//     }
//   }

//   // ============================================================
//   // SAVE ADDRESS
//   // ============================================================

//   void _saveAddress() {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }

//     final addressData = {
//       'name': nameController.text.trim(),
//       'phone': phoneController.text.trim(),
//       'country': selectedCountry,
//       'state': selectedState,
//       'city': selectedCity,
//       'village_area': villageController.text.trim(),
//       'pin': pinController.text.trim(),
//       'address': addressController.text.trim(),
//       'landmark': landmarkController.text.trim(),
//       'address_type': addressType,
//     };

//     debugPrint('ADDRESS DATA: $addressData');

//     _showSuccess('Address saved successfully.');

//     // ----------------------------------------------------------
//     // এখানে তোমার API / Provider / Repository call করবে
//     // ----------------------------------------------------------
//   }

//   // ============================================================
//   // SUCCESS
//   // ============================================================

//   void _showSuccess(String message) {
//     if (!mounted) {
//       return;
//     }

//     ScaffoldMessenger.of(context)
//       ..hideCurrentSnackBar()
//       ..showSnackBar(
//         SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
//       );
//   }

//   // ============================================================
//   // ERROR
//   // ============================================================

//   void _showError(String message) {
//     if (!mounted) {
//       return;
//     }

//     ScaffoldMessenger.of(context)
//       ..hideCurrentSnackBar()
//       ..showSnackBar(
//         SnackBar(
//           content: Text(message),
//           behavior: SnackBarBehavior.floating,
//           backgroundColor: Colors.red,
//         ),
//       );
//   }

//   // ============================================================
//   // TEXT FIELD
//   // ============================================================

//   Widget _textField({
//     required String label,
//     required String hint,
//     required IconData icon,
//     required TextEditingController controller,
//     TextInputType? keyboardType,
//     int maxLines = 1,
//     String? Function(String?)? validator,
//   }) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: 14.h),
//       child: TextFormField(
//         controller: controller,
//         keyboardType: keyboardType,
//         maxLines: maxLines,
//         validator: validator,
//         decoration: InputDecoration(
//           labelText: label,
//           hintText: hint,
//           prefixIcon: Icon(icon),
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
//         ),
//       ),
//     );
//   }

//   // ============================================================
//   // BUILD
//   // ============================================================

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Add Address')),
//       body: SafeArea(
//         child: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             padding: EdgeInsets.all(16.w),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // =================================================
//                 // CURRENT LOCATION
//                 // =================================================
//                 SizedBox(
//                   width: double.infinity,
//                   child: OutlinedButton.icon(
//                     onPressed: isGettingLocation ? null : getCurrentLocation,
//                     icon: isGettingLocation
//                         ? SizedBox(
//                             width: 18.w,
//                             height: 18.w,
//                             child: const CircularProgressIndicator(
//                               strokeWidth: 2,
//                             ),
//                           )
//                         : const Icon(Icons.my_location),
//                     label: Text(
//                       isGettingLocation
//                           ? 'Detecting Location...'
//                           : 'Use Current Location',
//                     ),
//                   ),
//                 ),

//                 SizedBox(height: 20.h),

//                 // =================================================
//                 // FULL NAME
//                 // =================================================
//                 _textField(
//                   label: 'Full Name',
//                   hint: 'Enter full name',
//                   icon: Icons.person_outline,
//                   controller: nameController,
//                   validator: (value) {
//                     if (value == null || value.trim().isEmpty) {
//                       return 'Please enter full name';
//                     }

//                     return null;
//                   },
//                 ),

//                 // =================================================
//                 // PHONE
//                 // =================================================
//                 _textField(
//                   label: 'Phone Number',
//                   hint: 'Enter phone number',
//                   icon: Icons.phone_outlined,
//                   controller: phoneController,
//                   keyboardType: TextInputType.phone,
//                   validator: (value) {
//                     if (value == null || value.trim().isEmpty) {
//                       return 'Please enter phone number';
//                     }

//                     if (value.trim().length != 10) {
//                       return 'Enter valid 10 digit phone number';
//                     }

//                     return null;
//                   },
//                 ),

//                 // =================================================
//                 // COUNTRY
//                 // =================================================
//                 LocationDropdown(
//                   label: 'Country',
//                   hint: 'India',
//                   icon: Icons.public,
//                   items: const [LocationItem(name: 'India')],
//                   value: selectedCountry,
//                   enabled: false,
//                   loading: false,
//                   onChanged: (_) {},
//                 ),

//                 // =================================================
//                 // STATE
//                 // =================================================
//                 LocationDropdown(
//                   label: 'State',
//                   hint: stateLoading ? 'Loading states...' : 'Select state',
//                   icon: Icons.location_city_outlined,
//                   items: states,
//                   value: selectedState,
//                   loading: stateLoading,
//                   enabled: !stateLoading && states.isNotEmpty,
//                   onChanged: (value) {
//                     if (value == null || value.isEmpty) {
//                       return;
//                     }

//                     setState(() {
//                       selectedState = value;
//                       selectedCity = null;
//                       cities = [];
//                     });

//                     _loadCities(value);
//                   },
//                 ),

//                 // =================================================
//                 // CITY / DISTRICT
//                 // =================================================
//                 LocationDropdown(
//                   label: 'City / District',
//                   hint: selectedState == null
//                       ? 'Select state first'
//                       : cityLoading
//                       ? 'Loading cities...'
//                       : 'Select city / district',
//                   icon: Icons.location_on_outlined,
//                   items: cities,
//                   value: selectedCity,
//                   loading: cityLoading,
//                   enabled:
//                       selectedState != null &&
//                       !cityLoading &&
//                       cities.isNotEmpty,
//                   onChanged: (value) {
//                     if (value == null || value.isEmpty) {
//                       return;
//                     }

//                     setState(() {
//                       selectedCity = value;
//                     });
//                   },
//                 ),

//                 // =================================================
//                 // VILLAGE / AREA
//                 // =================================================
//                 _textField(
//                   label: 'Village / Area',
//                   hint: 'Enter village or area',
//                   icon: Icons.home_work_outlined,
//                   controller: villageController,
//                   validator: (value) {
//                     if (value == null || value.trim().isEmpty) {
//                       return 'Please enter village / area';
//                     }

//                     return null;
//                   },
//                 ),

//                 // =================================================
//                 // PIN
//                 // =================================================
//                 _textField(
//                   label: 'PIN Code',
//                   hint: 'Enter PIN code',
//                   icon: Icons.pin_drop_outlined,
//                   controller: pinController,
//                   keyboardType: TextInputType.number,
//                   validator: (value) {
//                     if (value == null || value.trim().isEmpty) {
//                       return 'Please enter PIN code';
//                     }

//                     if (value.trim().length != 6) {
//                       return 'Enter valid 6 digit PIN code';
//                     }

//                     return null;
//                   },
//                 ),

//                 // =================================================
//                 // FULL ADDRESS
//                 // =================================================
//                 _textField(
//                   label: 'Full Address',
//                   hint: 'Enter full address',
//                   icon: Icons.location_on_outlined,
//                   controller: addressController,
//                   maxLines: 3,
//                   validator: (value) {
//                     if (value == null || value.trim().isEmpty) {
//                       return 'Please enter full address';
//                     }

//                     return null;
//                   },
//                 ),

//                 // =================================================
//                 // LANDMARK
//                 // =================================================
//                 _textField(
//                   label: 'Nearby Landmark',
//                   hint: 'Enter nearby landmark',
//                   icon: Icons.place_outlined,
//                   controller: landmarkController,
//                 ),

//                 // =================================================
//                 // ADDRESS TYPE
//                 // =================================================
//                 Text(
//                   'Address Type',
//                   style: TextStyle(
//                     fontSize: 14.sp,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),

//                 SizedBox(height: 8.h),

//                 Row(
//                   children: [
//                     _addressTypeOption('Home', Icons.home_outlined),
//                     SizedBox(width: 8.w),
//                     _addressTypeOption('Work', Icons.work_outline),
//                     SizedBox(width: 8.w),
//                     _addressTypeOption('Other', Icons.location_on_outlined),
//                   ],
//                 ),

//                 SizedBox(height: 24.h),

//                 // =================================================
//                 // SAVE
//                 // =================================================
//                 SizedBox(
//                   width: double.infinity,
//                   height: 50.h,
//                   child: ElevatedButton(
//                     onPressed: _saveAddress,
//                     child: const Text('Save Address'),
//                   ),
//                 ),

//                 SizedBox(height: 20.h),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // ============================================================
//   // ADDRESS TYPE OPTION
//   // ============================================================

//   Widget _addressTypeOption(String type, IconData icon) {
//     final selected = addressType == type;

//     return Expanded(
//       child: InkWell(
//         onTap: () {
//           setState(() {
//             addressType = type;
//           });
//         },
//         borderRadius: BorderRadius.circular(12.r),
//         child: Container(
//           padding: EdgeInsets.symmetric(vertical: 12.h),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12.r),
//             border: Border.all(
//               color: selected
//                   ? Theme.of(context).colorScheme.primary
//                   : Colors.grey.shade300,
//             ),
//           ),
//           child: Column(
//             children: [
//               Icon(
//                 icon,
//                 color: selected
//                     ? Theme.of(context).colorScheme.primary
//                     : Colors.grey,
//               ),
//               SizedBox(height: 4.h),
//               Text(
//                 type,
//                 style: TextStyle(
//                   fontSize: 12.sp,
//                   fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
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
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:geolocator/geolocator.dart';

import '../../data/models/location_model.dart';
import '../../data/services/location_service.dart';

// ============================================================
// ADDRESS PAGE
// ============================================================

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  // ==========================================================
  // FORM
  // ==========================================================

  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();

  final TextEditingController nameController =
      TextEditingController();

  final TextEditingController phoneController =
      TextEditingController();

  final TextEditingController villageController =
      TextEditingController();

  final TextEditingController pinController =
      TextEditingController();

  final TextEditingController addressController =
      TextEditingController();

  final TextEditingController landmarkController =
      TextEditingController();

  // ==========================================================
  // GEOCODING 5.x - CORRECT API
  // ==========================================================

  final geo.Geocoding _geocoding = geo.Geocoding();

  // ==========================================================
  // COUNTRY, STATE, CITY
  // ==========================================================

  static const String selectedCountry = 'India';

  List<LocationItem> states = [];
  List<LocationItem> cities = [];

  String? selectedState;
  String? selectedCity;

  bool stateLoading = false;
  bool cityLoading = false;
  bool isGettingLocation = false;

  String? stateError;
  String? cityError;

  int _cityRequestId = 0;

  String addressType = 'Home';

  // ==========================================================
  // INIT
  // ==========================================================

  @override
  void initState() {
    super.initState();
    _loadStates();
  }

  // ==========================================================
  // DISPOSE
  // ==========================================================

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

  // ==========================================================
  // REMOVE DUPLICATE LOCATIONS
  // ==========================================================

  List<LocationItem> _removeDuplicates(
    List<LocationItem> items,
  ) {
    final Map<String, LocationItem> unique = {};

    for (final item in items) {
      final name = item.name.trim();

      if (name.isEmpty) continue;

      unique.putIfAbsent(
        name.toLowerCase(),
        () => LocationItem(name: name),
      );
    }

    final result = unique.values.toList();

    result.sort(
      (a, b) => a.name.toLowerCase().compareTo(
        b.name.toLowerCase(),
      ),
    );

    return result;
  }

  // ==========================================================
  // LOAD STATES
  // ==========================================================

  Future<void> _loadStates() async {
    if (stateLoading) return;

    setState(() {
      stateLoading = true;
      stateError = null;
    });

    try {
      final result = await LocationService.getStates(
        selectedCountry,
      );

      if (!mounted) return;

      setState(() {
        states = _removeDuplicates(result);

        if (states.isEmpty) {
          stateError = 'Unable to find states.';
        }
      });
    } catch (error) {
      debugPrint('STATE ERROR: $error');

      if (!mounted) return;

      setState(() {
        stateError = 'Unable to load states.';
      });
    } finally {
      if (mounted) {
        setState(() {
          stateLoading = false;
        });
      }
    }
  }

  // ==========================================================
  // LOAD CITIES
  // ==========================================================

  Future<void> _loadCities(String state) async {
    final requestId = ++_cityRequestId;

    setState(() {
      cityLoading = true;
      cityError = null;
      cities = [];
      selectedCity = null;
    });

    try {
      final result = await LocationService.getCities(
        country: selectedCountry,
        state: state,
      );

      if (!mounted || requestId != _cityRequestId) {
        return;
      }

      setState(() {
        cities = _removeDuplicates(result);

        if (cities.isEmpty) {
          cityError = 'No cities available.';
        }
      });
    } catch (error) {
      debugPrint('CITY ERROR: $error');

      if (!mounted || requestId != _cityRequestId) {
        return;
      }

      setState(() {
        cityError = 'Unable to load cities.';
      });
    } finally {
      if (mounted && requestId == _cityRequestId) {
        setState(() {
          cityLoading = false;
        });
      }
    }
  }

  // ==========================================================
  // SELECT STATE
  // ==========================================================

  void _onStateChanged(String? value) {
    if (value == null || value.isEmpty) return;

    setState(() {
      selectedState = value;
      selectedCity = null;
      cities = [];
      cityError = null;
    });

    _loadCities(value);
  }

  // ==========================================================
  // SELECT CITY
  // ==========================================================

  void _onCityChanged(String? value) {
    if (value == null || value.isEmpty) return;

    setState(() {
      selectedCity = value;
    });
  }

  // ==========================================================
  // ADD STATE FROM GPS
  // ==========================================================

  void _addStateIfMissing(String name) {
    if (name.trim().isEmpty) return;

    final exists = states.any(
      (item) =>
          item.name.toLowerCase() ==
          name.toLowerCase(),
    );

    if (!exists) {
      states.add(LocationItem(name: name));
    }
  }

  // ==========================================================
  // ADD CITY FROM GPS
  // ==========================================================

  void _addCityIfMissing(String name) {
    if (name.trim().isEmpty) return;

    final exists = cities.any(
      (item) =>
          item.name.toLowerCase() ==
          name.toLowerCase(),
    );

    if (!exists) {
      cities.add(LocationItem(name: name));
    }
  }

  // ==========================================================
  // CURRENT LOCATION
  // ==========================================================

  Future<void> getCurrentLocation() async {
    if (isGettingLocation) return;

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Use Current Location?'),
          content: const Text(
            'Allow the app to detect your current '
            'location and fill your address.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );

    if (!mounted || confirmed != true) return;

    setState(() {
      isGettingLocation = true;
    });

    try {
      // ========================================================
      // CHECK LOCATION SERVICE
      // ========================================================

      final enabled =
          await Geolocator.isLocationServiceEnabled();

      if (!enabled) {
        if (!mounted) return;

        final openSettings =
            await _showSettingsDialog(
          title: 'Location Disabled',
          message:
              'Please enable your device location service.',
        );

        if (openSettings) {
          await Geolocator.openLocationSettings();
        }

        return;
      }

      // ========================================================
      // CHECK PERMISSION
      // ========================================================

      LocationPermission permission =
          await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission =
            await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission ==
              LocationPermission.deniedForever) {
        if (!mounted) return;

        final openSettings =
            await _showSettingsDialog(
          title: 'Location Permission Required',
          message:
              'Please allow location permission in app settings.',
        );

        if (openSettings) {
          await Geolocator.openAppSettings();
        }

        return;
      }

      // ========================================================
      // GET GPS POSITION
      // ========================================================

      final Position position =
          await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      // ========================================================
      // REVERSE GEOCODING - GEOCODING 5.x FIX
      // ========================================================

      final List<geo.Placemark> placemarks =
          await _geocoding.placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isEmpty) {
        throw Exception('Address not found');
      }

      final geo.Placemark place = placemarks.first;

      final String detectedCountry =
          place.country?.trim() ?? '';

      final String detectedState =
          place.administrativeArea?.trim() ?? '';

      final String detectedCity =
          place.locality?.trim() ?? '';

      final String detectedArea =
          place.subLocality?.trim() ?? '';

      final String detectedPin =
          place.postalCode?.trim() ?? '';

      // ========================================================
      // COUNTRY VALIDATION
      // ========================================================

      if (detectedCountry.isNotEmpty &&
          detectedCountry.toLowerCase() !=
              'india') {
        if (!mounted) return;

        _showError(
          'Current location is outside India.',
        );

        return;
      }

      // ========================================================
      // GET CITIES FOR DETECTED STATE
      // ========================================================

      List<LocationItem> detectedCities = [];

      if (detectedState.isNotEmpty) {
        try {
          detectedCities =
              await LocationService.getCities(
            country: selectedCountry,
            state: detectedState,
          );
        } catch (error) {
          debugPrint(
            'GPS CITY LOAD ERROR: $error',
          );
        }
      }

      if (!mounted) return;

      // Ignore any older city request.
      _cityRequestId++;

      // ========================================================
      // UPDATE STATE & CITY
      // ========================================================

      setState(() {
        if (detectedState.isNotEmpty) {
          _addStateIfMissing(detectedState);
          selectedState = detectedState;
        }

        cities = _removeDuplicates(
          detectedCities,
        );

        if (detectedCity.isNotEmpty) {
          _addCityIfMissing(detectedCity);
          selectedCity = detectedCity;
        } else {
          selectedCity = null;
        }

        cityLoading = false;
        cityError = null;
      });

      // ========================================================
      // FILL AREA AND PIN
      // ========================================================

      if (detectedArea.isNotEmpty) {
        villageController.text = detectedArea;
      }

      if (detectedPin.isNotEmpty) {
        pinController.text = detectedPin;
      }

      // ========================================================
      // GENERATE FULL ADDRESS
      // ========================================================

      final List<String> addressParts = [];

      final parts = [
        place.name?.trim() ?? '',
        place.street?.trim() ?? '',
        place.thoroughfare?.trim() ?? '',
        place.subThoroughfare?.trim() ?? '',
        detectedArea,
        detectedCity,
        detectedState,
        detectedPin,
      ];

      for (final part in parts) {
        if (part.isEmpty) continue;

        if (!addressParts.any(
          (existing) =>
              existing.toLowerCase() ==
              part.toLowerCase(),
        )) {
          addressParts.add(part);
        }
      }

      addressController.text =
          addressParts.join(', ');

      _showSuccess(
        'Current location detected successfully.',
      );
    } catch (error) {
      debugPrint('LOCATION ERROR: $error');

      if (!mounted) return;

      _showError(
        'Unable to detect current location.',
      );
    } finally {
      if (mounted) {
        setState(() {
          isGettingLocation = false;
        });
      }
    }
  }

  // ==========================================================
  // SETTINGS DIALOG
  // ==========================================================

  Future<bool> _showSettingsDialog({
    required String title,
    required String message,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Open Settings'),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  // ==========================================================
  // SAVE ADDRESS
  // ==========================================================

  void _saveAddress() {
    if (!(_formKey.currentState?.validate() ??
        false)) {
      return;
    }

    final Map<String, dynamic> addressData = {
      'name': nameController.text.trim(),
      'phone': phoneController.text.trim(),
      'country': selectedCountry,
      'state': selectedState,
      'city': selectedCity,
      'village_area':
          villageController.text.trim(),
      'pin': pinController.text.trim(),
      'address': addressController.text.trim(),
      'landmark':
          landmarkController.text.trim(),
      'address_type': addressType,
    };

    debugPrint(
      'ADDRESS DATA: $addressData',
    );

    // Connect address save API here.
    // Currently form data is only validated locally.

    _showSuccess(
      'Address validated successfully.',
    );
  }

  // ==========================================================
  // SUCCESS MESSAGE
  // ==========================================================

  void _showSuccess(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  // ==========================================================
  // ERROR MESSAGE
  // ==========================================================

  void _showError(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  // ==========================================================
  // TEXT FIELD
  // ==========================================================

  Widget _textField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    TextInputType? keyboardType,
    int maxLines = 1,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        inputFormatters: inputFormatters,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(12.r),
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // LOCATION DROPDOWN
  // FULL BOX AND ARROW CLICKABLE
  // ==========================================================

  Widget _locationDropdown({
    required String label,
    required String hint,
    required IconData icon,
    required List<String> options,
    required String? value,
    required ValueChanged<String?> onChanged,
    bool loading = false,
    String? Function(String?)? validator,
  }) {
    final Map<String, String> unique = {};

    for (final item in options) {
      final name = item.trim();

      if (name.isNotEmpty) {
        unique.putIfAbsent(
          name.toLowerCase(),
          () => name,
        );
      }
    }

    final names = unique.values.toList();

    final String? selectedValue =
        value != null && names.contains(value)
            ? value
            : null;

    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: DropdownButtonFormField<String>(
        key: ValueKey(
          '$label-$selectedValue-${names.join("|")}',
        ),
        initialValue: selectedValue,
        isExpanded: true,
        menuMaxHeight: 320,
        borderRadius: BorderRadius.circular(12),
        icon: loading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
            : const Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 27,
              ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          contentPadding:
              const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 16,
          ),
        ),
        items: names.map((name) {
          return DropdownMenuItem<String>(
            value: name,
            child: Text(
              name,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
        onChanged:
            loading || names.isEmpty
                ? null
                : onChanged,
        validator: validator,
      ),
    );
  }

  // ==========================================================
  // RETRY LOCATION API
  // ==========================================================

  Widget _retryButton({
    required String message,
    required VoidCallback onRetry,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(
              Icons.refresh,
              size: 18,
            ),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // BUILD PAGE
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Address'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                // ============================================
                // CURRENT LOCATION
                // ============================================

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: isGettingLocation
                        ? null
                        : getCurrentLocation,
                    icon: isGettingLocation
                        ? SizedBox(
                            width: 18.w,
                            height: 18.w,
                            child:
                                const CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(
                            Icons.my_location,
                          ),
                    label: Text(
                      isGettingLocation
                          ? 'Detecting Location...'
                          : 'Use Current Location',
                    ),
                  ),
                ),

                SizedBox(height: 20.h),

                // ============================================
                // FULL NAME
                // ============================================

                _textField(
                  label: 'Full Name',
                  hint: 'Enter full name',
                  icon: Icons.person_outline,
                  controller: nameController,
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Please enter full name';
                    }

                    return null;
                  },
                ),

                // ============================================
                // PHONE NUMBER
                // ============================================

                _textField(
                  label: 'Phone Number',
                  hint: 'Enter phone number',
                  icon: Icons.phone_outlined,
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  validator: (value) {
                    final phone = value?.trim() ?? '';

                    if (phone.length != 10) {
                      return 'Enter valid 10 digit phone number';
                    }

                    return null;
                  },
                ),

                // ============================================
                // COUNTRY
                // ============================================

                _locationDropdown(
                  label: 'Country',
                  hint: 'Select Country',
                  icon: Icons.public,
                  options: const ['India'],
                  value: selectedCountry,
                  onChanged: (_) {},
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty) {
                      return 'Please select country';
                    }

                    return null;
                  },
                ),

                // ============================================
                // STATE
                // ============================================

                _locationDropdown(
                  label: 'State',
                  hint: stateLoading
                      ? 'Loading states...'
                      : 'Select State',
                  icon: Icons.location_city_outlined,
                  options: states
                      .map((item) => item.name)
                      .toList(),
                  value: selectedState,
                  loading: stateLoading,
                  onChanged: _onStateChanged,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty) {
                      return 'Please select state';
                    }

                    return null;
                  },
                ),

                if (stateError != null && !stateLoading)
                  _retryButton(
                    message: stateError!,
                    onRetry: _loadStates,
                  ),

                // ============================================
                // CITY / DISTRICT
                // ============================================

                _locationDropdown(
                  label: 'City / District',
                  hint: selectedState == null
                      ? 'Select state first'
                      : cityLoading
                          ? 'Loading cities...'
                          : 'Select City / District',
                  icon: Icons.location_on_outlined,
                  options: cities
                      .map((item) => item.name)
                      .toList(),
                  value: selectedCity,
                  loading: cityLoading,
                  onChanged: _onCityChanged,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty) {
                      return 'Please select city / district';
                    }

                    return null;
                  },
                ),

                if (cityError != null &&
                    !cityLoading &&
                    selectedState != null)
                  _retryButton(
                    message: cityError!,
                    onRetry: () {
                      if (selectedState != null) {
                        _loadCities(selectedState!);
                      }
                    },
                  ),

                // ============================================
                // VILLAGE / AREA
                // ============================================

                _textField(
                  label: 'Village / Area',
                  hint: 'Enter village or area',
                  icon: Icons.home_work_outlined,
                  controller: villageController,
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Please enter village / area';
                    }

                    return null;
                  },
                ),

                // ============================================
                // PIN CODE
                // ============================================

                _textField(
                  label: 'PIN Code',
                  hint: 'Enter PIN code',
                  icon: Icons.pin_drop_outlined,
                  controller: pinController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6),
                  ],
                  validator: (value) {
                    if ((value?.trim().length ?? 0) != 6) {
                      return 'Enter valid 6 digit PIN code';
                    }

                    return null;
                  },
                ),

                // ============================================
                // FULL ADDRESS
                // ============================================

                _textField(
                  label: 'Full Address',
                  hint: 'Enter full address',
                  icon: Icons.location_on_outlined,
                  controller: addressController,
                  maxLines: 3,
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Please enter full address';
                    }

                    return null;
                  },
                ),

                // ============================================
                // LANDMARK
                // ============================================

                _textField(
                  label: 'Nearby Landmark',
                  hint: 'Enter nearby landmark',
                  icon: Icons.place_outlined,
                  controller: landmarkController,
                ),

                // ============================================
                // ADDRESS TYPE
                // ============================================

                Text(
                  'Address Type',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(height: 8.h),

                Row(
                  children: [
                    _addressTypeOption(
                      'Home',
                      Icons.home_outlined,
                    ),
                    SizedBox(width: 8.w),
                    _addressTypeOption(
                      'Work',
                      Icons.work_outline,
                    ),
                    SizedBox(width: 8.w),
                    _addressTypeOption(
                      'Other',
                      Icons.location_on_outlined,
                    ),
                  ],
                ),

                SizedBox(height: 24.h),

                // ============================================
                // SAVE ADDRESS
                // ============================================

                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: _saveAddress,
                    child: const Text('Save Address'),
                  ),
                ),

                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // ADDRESS TYPE BUTTON
  // ==========================================================

  Widget _addressTypeOption(
    String type,
    IconData icon,
  ) {
    final bool selected = addressType == type;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            addressType = type;
          });
        },
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 12.h,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: selected
                  ? Theme.of(context)
                      .colorScheme
                      .primary
                  : Colors.grey.shade300,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: selected
                    ? Theme.of(context)
                        .colorScheme
                        .primary
                    : Colors.grey,
              ),

              SizedBox(height: 4.h),

              Text(
                type,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: selected
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
