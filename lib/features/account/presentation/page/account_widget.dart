// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:lalbaba_online/app/router/route_names.dart';

// import '../../../../app/config/app_config.dart';
// import '../../../../app/theme/app_colors.dart';
// import '../../../../core/widgets/app_app_bar.dart';

// import '../widgets/app_string.dart';
// import '../widgets/languange_constant.dart';

// import 'profile_page.dart';

// class AccountPage extends StatefulWidget {
//   const AccountPage({
//     super.key,
//   });

//   @override
//   State<AccountPage> createState() =>
//       _AccountPageState();
// }

// class _AccountPageState
//     extends State<AccountPage> {
//   // ============================================================
//   // PROFILE DATA
//   //
//   // Pore API/provider theke ei value gulo load korte parben.
//   // ============================================================

//   String _profileName = 'John Doe';

//   String _profileEmail =
//       'john.doe@example.com';

//   // Current code-e phone number source nei.
//   // API/login data pele ekhane set korben.
//   String _profilePhone = '';

//   String _profileAvatarUrl =
//       'https://example.com/avatar.jpg';

//   // ============================================================
//   // OPEN EXTERNAL URL
//   // ============================================================

//   Future<void> _openExternalUrl(
//     String urlString,
//   ) async {
//     final Uri url =
//         Uri.parse(urlString);

//     final bool launched =
//         await launchUrl(
//       url,
//       mode:
//           LaunchMode.externalApplication,
//     );

//     if (!launched && mounted) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(
//         const SnackBar(
//           content: Text(
//             'Unable to open page',
//           ),
//         ),
//       );
//     }
//   }

//   // ============================================================
//   // OPEN PROFILE PAGE
//   // ============================================================

//   Future<void> _openProfilePage() async {
//     await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) =>
//             ProfilePage(
//           name: _profileName,
//           email: _profileEmail,
//           phoneNumber:
//               _profilePhone,
//           avatarUrl:
//               _profileAvatarUrl,

//           // Profile page-e save korle
//           // Account page-er data-o update hobe.
//           onSaved:
//               (ProfileData data) {
//             if (!mounted) {
//               return;
//             }

//             setState(() {
//               _profileName =
//                   data.name;

//               _profileEmail =
//                   data.email;

//               // Phone editable noy.
//               _profilePhone =
//                   data.phoneNumber;

//               _profileAvatarUrl =
//                   data.avatarUrl;
//             });
//           },
//         ),
//       ),
//     );
//   }

//   // ============================================================
//   // LOGOUT
//   // ============================================================

//   void _handleLogoutTap() {
//     showDialog(
//       context: context,
//       barrierDismissible: true,
//       builder: (
//         dialogContext,
//       ) {
//         return AlertDialog(
//           shape:
//               RoundedRectangleBorder(
//             borderRadius:
//                 BorderRadius.circular(
//               18,
//             ),
//           ),
//           title: Text(
//             AppStrings
//                 .logOutConfirmTitle,
//             style:
//                 const TextStyle(
//               fontWeight:
//                   FontWeight.w700,
//             ),
//           ),
//           content: Text(
//             AppStrings
//                 .logOutConfirmMessage,
//             style:
//                 const TextStyle(
//               fontSize: 14,
//               color:
//                   Colors.black87,
//             ),
//           ),
//           actionsPadding:
//               const EdgeInsets
//                   .fromLTRB(
//             16,
//             0,
//             16,
//             12,
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(
//                   dialogContext,
//                 ).pop();
//               },
//               child: Text(
//                 AppStrings.cancel,
//                 style:
//                     const TextStyle(
//                   color:
//                       Colors.black54,
//                   fontWeight:
//                       FontWeight.w600,
//                 ),
//               ),
//             ),

//             TextButton(
//               onPressed: () {
//                 Navigator.of(
//                   dialogContext,
//                 ).pop();

//                 // TODO:
//                 // Actual logout logic
//               },
//               child: Text(
//                 AppStrings.logOut,
//                 style: TextStyle(
//                   color: AppColors
//                       .primary,
//                   fontWeight:
//                       FontWeight.w700,
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // ============================================================
//   // BUILD
//   // ============================================================

//   @override
//   Widget build(
//     BuildContext context,
//   ) {
//     return AnimatedBuilder(
//       animation:
//           AppLanguageConstants.instance,
//       builder: (
//         context,
//         child,
//       ) {
//         return Scaffold(
//           backgroundColor:
//               const Color(
//             0xFFF6F7FB,
//           ),

//           appBar: AppAppBar(
//             title:
//                 AppStrings.account,
//           ),

//           body: SafeArea(
//             child: ListView(
//               padding:
//                   const EdgeInsets
//                       .fromLTRB(
//                 16,
//                 16,
//                 16,
//                 24,
//               ),
//               children: [
//                 // ==============================================
//                 // PROFILE HEADER
//                 // Click korle ProfilePage open hobe
//                 // ==============================================

//                 _ProfileHeader(
//                   name:
//                       _profileName,
//                   email:
//                       _profileEmail,
//                   avatarUrl:
//                       _profileAvatarUrl,

//                   onProfileTap:
//                       _openProfilePage,

//                   onEditTap:
//                       _openProfilePage,
//                 ),

//                 const SizedBox(
//                   height: 24,
//                 ),

//                 // ==============================================
//                 // ACCOUNT SECTION
//                 // ==============================================

//                 _SectionLabel(
//                   text:
//                       AppStrings.account,
//                 ),

//                 _SectionCard(
//                   children: [
//                     _LanguageDropdownTile(
//                       selected:
//                           AppLanguageConstants
//                               .current,
//                       onChanged:
//                           (value) {
//                         AppLanguageConstants
//                             .change(
//                           value,
//                         );

//                         setState(
//                           () {},
//                         );
//                       },
//                     ),

//                     _MenuTile(
//                       icon:
//                           Icons.info_outline,
//                       label:
//                           AppStrings.aboutUs,
//                       onTap: () {
//                         _openExternalUrl(
//                           'https://lalbabaonline.com/about-us',
//                         );
//                       },
//                     ),

//                     _MenuTile(
//                       icon:
//                           Icons.call_outlined,
//                       label:
//                           AppStrings.contactUs,
//                       onTap: () {},
//                     ),

//                     _MenuTile(
//                       icon:
//                           Icons.person_outline,
//                       label:
//                           AppStrings.myProfile,

//                       // Profile menu thekeo
//                       // same profile page open hobe.
//                       onTap:
//                           _openProfilePage,
//                     ),

//                     _MenuTile(
//                       icon: Icons
//                           .location_on_outlined,
//                       label:
//                           AppStrings.myAddress,
//                       onTap: () {
//                         context.push(
//                           RouteNames.address,
//                         );
//                       },
//                       showDivider:
//                           false,
//                     ),
//                   ],
//                 ),

//                 const SizedBox(
//                   height: 20,
//                 ),

//                 // ==============================================
//                 // TERMS
//                 // ==============================================

//                 _SectionLabel(
//                   text:
//                       AppStrings.termsOfUse,
//                 ),

//                 _SectionCard(
//                   children: [
//                     _MenuTile(
//                       icon: Icons
//                           .description_outlined,
//                       label:
//                           AppStrings.termsOfUse,
//                       onTap: () {
//                         _openExternalUrl(
//                           'https://lalbabaonline.com/terms',
//                         );
//                       },
//                     ),

//                     _MenuTile(
//                       icon: Icons
//                           .privacy_tip_outlined,
//                       label:
//                           AppStrings.privacyPolicy,
//                       onTap: () {
//                         _openExternalUrl(
//                           'https://lalbabaonline.com/privacy-policy',
//                         );
//                       },
//                     ),

//                     _MenuTile(
//                       icon: Icons
//                           .inventory_2_outlined,
//                       label:
//                           AppStrings.shippingPolicy,
//                       onTap: () {
//                         _openExternalUrl(
//                           'https://lalbabaonline.com/shipping-policy',
//                         );
//                       },
//                     ),

//                     _MenuTile(
//                       icon:
//                           Icons.factory_outlined,
//                       label:
//                           AppStrings.factoryLocator,
//                       onTap: () {
//                         _openExternalUrl(
//                           'https://lalbabaonline.com/factory-locator',
//                         );
//                       },
//                       showDivider:
//                           false,
//                     ),
//                   ],
//                 ),

//                 const SizedBox(
//                   height: 20,
//                 ),

//                 // ==============================================
//                 // ORDER SECTION
//                 // ==============================================

//                 _SectionLabel(
//                   text:
//                       AppStrings.myOrders,
//                 ),

//                 _SectionCard(
//                   children: [
//                     _MenuTile(
//                       icon: Icons
//                           .local_shipping_outlined,
//                       label:
//                           AppStrings.myOrders,
//                       onTap: () {},
//                     ),

//                     _MenuTile(
//                       icon:
//                           Icons.favorite_border,
//                       label:
//                           AppStrings.wishlist,
//                       onTap: () {},
//                     ),

//                     _MenuTile(
//                       icon: Icons
//                           .local_shipping_outlined,
//                       label:
//                           AppStrings.trackOrder,
//                       onTap: () {},
//                     ),

//                     _MenuTile(
//                       icon:
//                           Icons.replay_outlined,
//                       label: AppStrings
//                           .returnsAndRefund,
//                       onTap: () {
//                         _openExternalUrl(
//                           'https://lalbabaonline.com/return-policy',
//                         );
//                       },
//                       showDivider:
//                           false,
//                     ),
//                   ],
//                 ),

//                 const SizedBox(
//                   height: 28,
//                 ),

//                 _LogoutButton(
//                   label:
//                       AppStrings.logOut,
//                   onTap:
//                       _handleLogoutTap,
//                 ),

//                 const SizedBox(
//                   height: 18,
//                 ),

//                 Text(
//                   '${AppStrings.appVersion} '
//                   '${AppConfig.version}',
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Colors
//                         .grey.shade500,
//                   ),
//                   textAlign:
//                       TextAlign.center,
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// // ============================================================
// // PROFILE HEADER
// // ============================================================

// class _ProfileHeader
//     extends StatelessWidget {
//   final String name;
//   final String email;
//   final String? avatarUrl;

//   final VoidCallback?
//       onProfileTap;

//   final VoidCallback?
//       onEditTap;

//   const _ProfileHeader({
//     required this.name,
//     required this.email,
//     this.avatarUrl,
//     this.onProfileTap,
//     this.onEditTap,
//   });

//   @override
//   Widget build(
//     BuildContext context,
//   ) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap:
//             onProfileTap,
//         borderRadius:
//             BorderRadius.circular(
//           20,
//         ),
//         child: Container(
//           padding:
//               const EdgeInsets.all(
//             18,
//           ),
//           decoration:
//               BoxDecoration(
//             color: Colors.white,
//             borderRadius:
//                 BorderRadius.circular(
//               20,
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black
//                     .withOpacity(
//                   0.05,
//                 ),
//                 blurRadius: 16,
//                 offset:
//                     const Offset(
//                   0,
//                   6,
//                 ),
//               ),
//             ],
//           ),
//           child: Row(
//             children: [
//               // ================================================
//               // PROFILE IMAGE
//               // ================================================

//               Container(
//                 width: 64,
//                 height: 64,
//                 decoration:
//                     const BoxDecoration(
//                   shape:
//                       BoxShape.circle,
//                   gradient:
//                       LinearGradient(
//                     colors: [
//                       Color(
//                         0xFF7FD7C4,
//                       ),
//                       Color(
//                         0xFFE9A0BE,
//                       ),
//                     ],
//                     begin: Alignment
//                         .topLeft,
//                     end: Alignment
//                         .bottomRight,
//                   ),
//                 ),
//                 padding:
//                     const EdgeInsets
//                         .all(
//                   2.5,
//                 ),
//                 child: ClipOval(
//                   child: avatarUrl !=
//                               null &&
//                           avatarUrl!
//                               .isNotEmpty
//                       ? Image.network(
//                           avatarUrl!,
//                           fit:
//                               BoxFit.cover,
//                           errorBuilder:
//                               (
//                             context,
//                             error,
//                             stackTrace,
//                           ) {
//                             return _fallbackAvatar();
//                           },
//                         )
//                       : _fallbackAvatar(),
//                 ),
//               ),

//               const SizedBox(
//                 width: 16,
//               ),

//               // ================================================
//               // NAME + EMAIL
//               // ================================================

//               Expanded(
//                 child: Column(
//                   crossAxisAlignment:
//                       CrossAxisAlignment
//                           .start,
//                   children: [
//                     Row(
//                       children: [
//                         Flexible(
//                           child: Text(
//                             name,
//                             style:
//                                 const TextStyle(
//                               fontSize:
//                                   18,
//                               fontWeight:
//                                   FontWeight
//                                       .w700,
//                               color:
//                                   Colors.black87,
//                             ),
//                             overflow:
//                                 TextOverflow
//                                     .ellipsis,
//                           ),
//                         ),

//                         const SizedBox(
//                           width: 8,
//                         ),

//                         GestureDetector(
//                           onTap:
//                               onEditTap,
//                           child:
//                               Container(
//                             padding:
//                                 const EdgeInsets
//                                     .all(
//                               5,
//                             ),
//                             decoration:
//                                 const BoxDecoration(
//                               color: Color(
//                                 0xFFF5F5F7,
//                               ),
//                               shape: BoxShape
//                                   .circle,
//                             ),
//                             child:
//                                 const Icon(
//                               Icons
//                                   .chevron_right,
//                               size: 16,
//                               color: Colors
//                                   .black54,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),

//                     const SizedBox(
//                       height: 4,
//                     ),

//                     Text(
//                       email,
//                       style:
//                           TextStyle(
//                         fontSize: 13,
//                         color: Colors.grey
//                             .shade600,
//                       ),
//                       overflow:
//                           TextOverflow
//                               .ellipsis,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _fallbackAvatar() {
//     return Container(
//       color: Colors.white,
//       child: const Icon(
//         Icons.person,
//         color: Colors.grey,
//         size: 30,
//       ),
//     );
//   }
// }

// // ============================================================
// // SECTION LABEL
// // ============================================================

// class _SectionLabel
//     extends StatelessWidget {
//   final String text;

//   const _SectionLabel({
//     required this.text,
//   });

//   @override
//   Widget build(
//     BuildContext context,
//   ) {
//     return Padding(
//       padding:
//           const EdgeInsets.only(
//         left: 6,
//         bottom: 8,
//       ),
//       child: Text(
//         text,
//         style: TextStyle(
//           fontSize: 12.5,
//           fontWeight:
//               FontWeight.w600,
//           color:
//               Colors.grey.shade500,
//           letterSpacing: 0.4,
//         ),
//       ),
//     );
//   }
// }

// // ============================================================
// // SECTION CARD
// // ============================================================

// class _SectionCard
//     extends StatelessWidget {
//   final List<Widget> children;

//   const _SectionCard({
//     required this.children,
//   });

//   @override
//   Widget build(
//     BuildContext context,
//   ) {
//     return Container(
//       padding:
//           const EdgeInsets.symmetric(
//         horizontal: 14,
//       ),
//       decoration:
//           BoxDecoration(
//         color: Colors.white,
//         borderRadius:
//             BorderRadius.circular(
//           18,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black
//                 .withOpacity(
//               0.04,
//             ),
//             blurRadius: 12,
//             offset:
//                 const Offset(
//               0,
//               4,
//             ),
//           ),
//         ],
//       ),
//       child:
//           Column(
//         children: children,
//       ),
//     );
//   }
// }

// // ============================================================
// // LANGUAGE DROPDOWN
// // ============================================================

// class _LanguageDropdownTile
//     extends StatelessWidget {
//   final AppLanguage selected;

//   final ValueChanged<AppLanguage>
//       onChanged;

//   const _LanguageDropdownTile({
//     required this.selected,
//     required this.onChanged,
//   });

//   @override
//   Widget build(
//     BuildContext context,
//   ) {
//     return Column(
//       children: [
//         Padding(
//           padding:
//               const EdgeInsets
//                   .symmetric(
//             vertical: 10,
//           ),
//           child: Row(
//             children: [
//               Container(
//                 width: 40,
//                 height: 40,
//                 alignment:
//                     Alignment.center,
//                 decoration:
//                     BoxDecoration(
//                   color:
//                       const Color(
//                     0xFFF5F5F7,
//                   ),
//                   borderRadius:
//                       BorderRadius
//                           .circular(
//                     10,
//                   ),
//                 ),
//                 child:
//                     const Icon(
//                   Icons.language,
//                   size: 20,
//                   color:
//                       Colors.black87,
//                 ),
//               ),

//               const SizedBox(
//                 width: 14,
//               ),

//               Expanded(
//                 child: Text(
//                   AppStrings.language,
//                   style:
//                       const TextStyle(
//                     fontSize: 15,
//                     color:
//                         Colors.black87,
//                   ),
//                 ),
//               ),

//               Container(
//                 padding:
//                     const EdgeInsets
//                         .symmetric(
//                   horizontal: 10,
//                 ),
//                 decoration:
//                     BoxDecoration(
//                   color:
//                       const Color(
//                     0xFFF5F5F7,
//                   ),
//                   borderRadius:
//                       BorderRadius
//                           .circular(
//                     10,
//                   ),
//                 ),
//                 child:
//                     DropdownButtonHideUnderline(
//                   child:
//                       DropdownButton<
//                           AppLanguage>(
//                     value:
//                         selected,
//                     icon:
//                         const Icon(
//                       Icons
//                           .keyboard_arrow_down,
//                       size: 18,
//                     ),
//                     borderRadius:
//                         BorderRadius
//                             .circular(
//                       12,
//                     ),
//                     style:
//                         const TextStyle(
//                       fontSize: 14,
//                       color:
//                           Colors.black87,
//                       fontWeight:
//                           FontWeight
//                               .w500,
//                     ),
//                     items: [
//                       DropdownMenuItem(
//                         value:
//                             AppLanguage
//                                 .english,
//                         child: Text(
//                           AppStrings
//                               .englishOption,
//                         ),
//                       ),
//                       DropdownMenuItem(
//                         value:
//                             AppLanguage
//                                 .bengali,
//                         child: Text(
//                           AppStrings
//                               .bengaliOption,
//                         ),
//                       ),
//                     ],
//                     onChanged:
//                         (value) {
//                       if (value !=
//                           null) {
//                         onChanged(
//                           value,
//                         );
//                       }
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),

//         Divider(
//           height: 1,
//           color:
//               Colors.grey.shade200,
//         ),
//       ],
//     );
//   }
// }

// // ============================================================
// // MENU TILE
// // ============================================================

// class _MenuTile
//     extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final VoidCallback? onTap;
//   final bool showDivider;

//   const _MenuTile({
//     required this.icon,
//     required this.label,
//     this.onTap,
//     this.showDivider = true,
//   });

//   @override
//   Widget build(
//     BuildContext context,
//   ) {
//     return Column(
//       children: [
//         InkWell(
//           onTap:
//               onTap,
//           borderRadius:
//               BorderRadius.circular(
//             12,
//           ),
//           child: Padding(
//             padding:
//                 const EdgeInsets
//                     .symmetric(
//               vertical: 10,
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   width: 40,
//                   height: 40,
//                   alignment:
//                       Alignment.center,
//                   decoration:
//                       BoxDecoration(
//                     color:
//                         const Color(
//                       0xFFF5F5F7,
//                     ),
//                     borderRadius:
//                         BorderRadius
//                             .circular(
//                       10,
//                     ),
//                   ),
//                   child: Icon(
//                     icon,
//                     size: 20,
//                     color:
//                         Colors.black87,
//                   ),
//                 ),

//                 const SizedBox(
//                   width: 14,
//                 ),

//                 Expanded(
//                   child: Text(
//                     label,
//                     style:
//                         const TextStyle(
//                       fontSize: 15,
//                       color:
//                           Colors.black87,
//                     ),
//                   ),
//                 ),

//                 Icon(
//                   Icons.chevron_right,
//                   size: 20,
//                   color:
//                       Colors.grey
//                           .shade400,
//                 ),
//               ],
//             ),
//           ),
//         ),

//         if (showDivider)
//           Divider(
//             height: 1,
//             color:
//                 Colors.grey.shade200,
//           ),
//       ],
//     );
//   }
// }

// // ============================================================
// // LOGOUT BUTTON
// // ============================================================

// class _LogoutButton
//     extends StatelessWidget {
//   final String label;
//   final VoidCallback? onTap;

//   const _LogoutButton({
//     required this.label,
//     this.onTap,
//   });

//   @override
//   Widget build(
//     BuildContext context,
//   ) {
//     return InkWell(
//       onTap:
//           onTap,
//       borderRadius:
//           BorderRadius.circular(
//         28,
//       ),
//       child: Container(
//         width: double.infinity,
//         padding:
//             const EdgeInsets
//                 .symmetric(
//           vertical: 14,
//         ),
//         decoration:
//             BoxDecoration(
//           color:
//               AppColors.primary,
//           borderRadius:
//               BorderRadius.circular(
//             28,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: AppColors
//                   .primary
//                   .withOpacity(
//                 0.35,
//               ),
//               blurRadius: 14,
//               offset:
//                   const Offset(
//                 0,
//                 6,
//               ),
//             ),
//           ],
//         ),
//         child: Row(
//           mainAxisAlignment:
//               MainAxisAlignment
//                   .center,
//           children: [
//             Icon(
//               Icons.logout,
//               size: 18,
//               color:
//                   AppColors.white,
//             ),

//             const SizedBox(
//               width: 8,
//             ),

//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: 15,
//                 fontWeight:
//                     FontWeight.w600,
//                 color:
//                     AppColors.white,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lalbaba_online/app/router/route_names.dart';

import '../../../../app/config/app_config.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/app_app_bar.dart';

import '../widgets/app_string.dart';
import '../widgets/languange_constant.dart';

import 'profile_page.dart';
import 'wishlist_page.dart';

// =============================================================================
// ACCOUNT PAGE
// =============================================================================

class AccountPage
    extends StatefulWidget {
  const AccountPage({
    super.key,
  });

  @override
  State<AccountPage> createState() =>
      _AccountPageState();
}

class _AccountPageState
    extends State<AccountPage> {
  // ===========================================================================
  // PROFILE DATA
  // ===========================================================================

  String _profileName =
      'John Doe';

  String _profileEmail =
      'john.doe@example.com';

  String _profilePhone = '';

  String _profileAvatarUrl =
      'https://example.com/avatar.jpg';

  // ===========================================================================
  // EXTERNAL URL
  // ===========================================================================

  Future<void> _openExternalUrl(
    String urlString,
  ) async {
    final Uri url =
        Uri.parse(
      urlString,
    );

    final bool launched =
        await launchUrl(
      url,
      mode:
          LaunchMode.externalApplication,
    );

    if (!launched &&
        mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to open page',
          ),
        ),
      );
    }
  }

  // ===========================================================================
  // PROFILE PAGE
  // ===========================================================================

  Future<void>
      _openProfilePage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (
          context,
        ) =>
                ProfilePage(
          name:
              _profileName,
          email:
              _profileEmail,
          phoneNumber:
              _profilePhone,
          avatarUrl:
              _profileAvatarUrl,

          onSaved:
              (
            ProfileData data,
          ) {
            if (!mounted) {
              return;
            }

            setState(() {
              _profileName =
                  data.name;

              _profileEmail =
                  data.email;

              _profilePhone =
                  data.phoneNumber;

              _profileAvatarUrl =
                  data.avatarUrl;
            });
          },
        ),
      ),
    );
  }

  // ===========================================================================
  // WISHLIST
  // ===========================================================================

  Future<void>
      _openWishlistPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (
          context,
        ) =>
                const WishlistPage(),
      ),
    );
  }

  // ===========================================================================
  // LOGOUT
  // ===========================================================================

  void _handleLogoutTap() {
    showDialog(
      context: context,
      barrierDismissible:
          true,
      builder:
          (
        dialogContext,
      ) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius
                    .circular(
              18,
            ),
          ),

          title: Text(
            AppStrings
                .logOutConfirmTitle,
            style:
                const TextStyle(
              fontWeight:
                  FontWeight.w700,
            ),
          ),

          content: Text(
            AppStrings
                .logOutConfirmMessage,
            style:
                const TextStyle(
              fontSize: 14,
              color:
                  Colors.black87,
            ),
          ),

          actionsPadding:
              const EdgeInsets
                  .fromLTRB(
            16,
            0,
            16,
            12,
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop();
              },

              child: Text(
                AppStrings.cancel,
                style:
                    const TextStyle(
                  color:
                      Colors.black54,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
            ),

            TextButton(
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop();

                // TODO:
                // Actual logout logic.
              },

              child: Text(
                AppStrings.logOut,
                style:
                    TextStyle(
                  color:
                      AppColors.primary,
                  fontWeight:
                      FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    return AnimatedBuilder(
      animation:
          AppLanguageConstants
              .instance,

      builder:
          (
        context,
        child,
      ) {
        return Scaffold(
          backgroundColor:
              const Color(
            0xFFF6F7FB,
          ),

          // ===================================================================
          // APP BAR
          // ===================================================================

          appBar: AppAppBar(
            title:
                AppStrings.account,
          ),

          // ===================================================================
          // BODY
          // ===================================================================

          body: SafeArea(
            child: ListView(
              padding:
                  const EdgeInsets
                      .fromLTRB(
                16,
                16,
                16,
                24,
              ),

              children: [
                // =============================================================
                // PROFILE HEADER
                // =============================================================

                _ProfileHeader(
                  name:
                      _profileName,

                  email:
                      _profileEmail,

                  avatarUrl:
                      _profileAvatarUrl,

                  onProfileTap:
                      _openProfilePage,

                  onEditTap:
                      _openProfilePage,
                ),

                const SizedBox(
                  height: 24,
                ),

                // =============================================================
                // ACCOUNT
                // =============================================================

                _SectionLabel(
                  text:
                      AppStrings.account,
                ),

                _SectionCard(
                  children: [
                    // ---------------------------------------------------------
                    // LANGUAGE
                    // ---------------------------------------------------------

                    _LanguageDropdownTile(
                      selected:
                          AppLanguageConstants
                              .current,

                      onChanged:
                          (
                        value,
                      ) {
                        AppLanguageConstants
                            .change(
                          value,
                        );

                        setState(
                          () {},
                        );
                      },
                    ),

                    // ---------------------------------------------------------
                    // ABOUT
                    // ---------------------------------------------------------

                    _MenuTile(
                      icon:
                          Icons.info_outline,

                      label:
                          AppStrings.aboutUs,

                      onTap: () {
                        _openExternalUrl(
                          'https://lalbabaonline.com/about-us',
                        );
                      },
                    ),

                    // ---------------------------------------------------------
                    // CONTACT
                    // ---------------------------------------------------------

                    _MenuTile(
                      icon:
                          Icons.call_outlined,

                      label:
                          AppStrings.contactUs,
<<<<<<< Updated upstream
                      onTap: () {
                         context.push(
                          RouteNames.contact,
                        );
                      },
=======

                      onTap: () {},
>>>>>>> Stashed changes
                    ),

                    // ---------------------------------------------------------
                    // PROFILE
                    // ---------------------------------------------------------

                    _MenuTile(
                      icon:
                          Icons.person_outline,

                      label:
                          AppStrings.myProfile,

                      onTap:
                          _openProfilePage,
                    ),

                    // ---------------------------------------------------------
                    // ADDRESS
                    // ---------------------------------------------------------

                    _MenuTile(
                      icon:
                          Icons.location_on_outlined,

                      label:
                          AppStrings.myAddress,

                      onTap: () {
                        context.push(
                          RouteNames.address,
                        );
                      },

                      showDivider:
                          false,
                    ),
                  ],
                ),

                const SizedBox(
                  height: 20,
                ),

                // =============================================================
                // TERMS
                // =============================================================

                _SectionLabel(
                  text:
                      AppStrings.termsOfUse,
                ),

                _SectionCard(
                  children: [
                    _MenuTile(
                      icon:
                          Icons.description_outlined,

                      label:
                          AppStrings.termsOfUse,

                      onTap: () {
                        _openExternalUrl(
                          'https://lalbabaonline.com/terms',
                        );
                      },
                    ),

                    _MenuTile(
                      icon:
                          Icons.privacy_tip_outlined,

                      label:
                          AppStrings.privacyPolicy,

                      onTap: () {
                        _openExternalUrl(
                          'https://lalbabaonline.com/privacy-policy',
                        );
                      },
                    ),

                    _MenuTile(
                      icon:
                          Icons.inventory_2_outlined,

                      label:
                          AppStrings.shippingPolicy,

                      onTap: () {
                        _openExternalUrl(
                          'https://lalbabaonline.com/shipping-policy',
                        );
                      },
                    ),

                    _MenuTile(
                      icon:
                          Icons.factory_outlined,

                      label:
                          AppStrings.factoryLocator,

                      onTap: () {
                        _openExternalUrl(
                          'https://lalbabaonline.com/factory-locator',
                        );
                      },

                      showDivider:
                          false,
                    ),
                  ],
                ),

                const SizedBox(
                  height: 20,
                ),

                // =============================================================
                // ORDER SECTION
                // =============================================================

                _SectionLabel(
                  text:
                      AppStrings.myOrders,
                ),

                _SectionCard(
                  children: [
                    // ---------------------------------------------------------
                    // MY ORDERS
                    // ---------------------------------------------------------

                    _MenuTile(
                      icon:
                          Icons.local_shipping_outlined,

                      label:
                          AppStrings.myOrders,

                      onTap: () {},
                    ),

                    // ---------------------------------------------------------
                    // WISHLIST
                    // ---------------------------------------------------------

                    _MenuTile(
                      icon:
                          Icons.favorite_border,

                      label:
                          AppStrings.wishlist,

                      onTap:
                          _openWishlistPage,
                    ),

                    // ---------------------------------------------------------
                    // TRACK ORDER
                    // ---------------------------------------------------------

                    _MenuTile(
                      icon:
                          Icons.local_shipping_outlined,

                      label:
                          AppStrings.trackOrder,

                      onTap: () {},
                    ),

                    // ---------------------------------------------------------
                    // RETURN
                    // ---------------------------------------------------------

                    _MenuTile(
                      icon:
                          Icons.replay_outlined,

                      label:
                          AppStrings
                              .returnsAndRefund,

                      onTap: () {
                        _openExternalUrl(
                          'https://lalbabaonline.com/return-policy',
                        );
                      },

                      showDivider:
                          false,
                    ),
                  ],
                ),

                const SizedBox(
                  height: 28,
                ),

                // =============================================================
                // LOGOUT
                // =============================================================

                _LogoutButton(
                  label:
                      AppStrings.logOut,

                  onTap:
                      _handleLogoutTap,
                ),

                const SizedBox(
                  height: 18,
                ),

                // =============================================================
                // VERSION
                // =============================================================

                Text(
                  '${AppStrings.appVersion} '
                  '${AppConfig.version}',
                  style:
                      TextStyle(
                    fontSize: 12,
                    color: Colors.grey
                        .shade500,
                  ),
                  textAlign:
                      TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// =============================================================================
// PROFILE HEADER
// =============================================================================

class _ProfileHeader
    extends StatelessWidget {
  final String name;

  final String email;

  final String? avatarUrl;

  final VoidCallback?
      onProfileTap;

  final VoidCallback?
      onEditTap;

  const _ProfileHeader({
    required this.name,
    required this.email,
    this.avatarUrl,
    this.onProfileTap,
    this.onEditTap,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Material(
      color:
          Colors.transparent,

      child: InkWell(
        onTap:
            onProfileTap,

        borderRadius:
            BorderRadius.circular(
          20,
        ),

        child: Container(
          padding:
              const EdgeInsets.all(
            18,
          ),

          decoration:
              BoxDecoration(
            color:
                Colors.white,

            borderRadius:
                BorderRadius.circular(
              20,
            ),

            boxShadow: [
              BoxShadow(
                color:
                    Colors.black
                        .withValues(
                  alpha: 0.05,
                ),
                blurRadius:
                    16,
                offset:
                    const Offset(
                  0,
                  6,
                ),
              ),
            ],
          ),

          child: Row(
            children: [
              // ===============================================================
              // AVATAR
              // ===============================================================

              Container(
                width: 64,
                height: 64,

                decoration:
                    const BoxDecoration(
                  shape:
                      BoxShape.circle,

                  gradient:
                      LinearGradient(
                    colors: [
                      Color(
                        0xFF7FD7C4,
                      ),
                      Color(
                        0xFFE9A0BE,
                      ),
                    ],
                    begin:
                        Alignment.topLeft,
                    end:
                        Alignment.bottomRight,
                  ),
                ),

                padding:
                    const EdgeInsets
                        .all(
                  2.5,
                ),

                child: ClipOval(
                  child: avatarUrl !=
                              null &&
                          avatarUrl!
                              .isNotEmpty
                      ? Image.network(
                          avatarUrl!,
                          fit:
                              BoxFit.cover,

                          errorBuilder:
                              (
                            context,
                            error,
                            stackTrace,
                          ) {
                            return _fallbackAvatar();
                          },
                        )
                      : _fallbackAvatar(),
                ),
              ),

              const SizedBox(
                width: 16,
              ),

              // ===============================================================
              // NAME + EMAIL
              // ===============================================================

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            name,
                            overflow:
                                TextOverflow
                                    .ellipsis,
                            style:
                                const TextStyle(
                              fontSize:
                                  18,
                              fontWeight:
                                  FontWeight
                                      .w700,
                              color:
                                  Colors
                                      .black87,
                            ),
                          ),
                        ),

                        const SizedBox(
                          width: 8,
                        ),

                        GestureDetector(
                          onTap:
                              onEditTap,

                          child:
                              Container(
                            padding:
                                const EdgeInsets
                                    .all(
                              5,
                            ),

                            decoration:
                                const BoxDecoration(
                              color:
                                  Color(
                                0xFFF5F5F7,
                              ),
                              shape:
                                  BoxShape
                                      .circle,
                            ),

                            child:
                                const Icon(
                              Icons
                                  .chevron_right,
                              size: 16,
                              color:
                                  Colors
                                      .black54,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 4,
                    ),

                    Text(
                      email,
                      overflow:
                          TextOverflow
                              .ellipsis,
                      style:
                          TextStyle(
                        fontSize: 13,
                        color: Colors
                            .grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fallbackAvatar() {
    return Container(
      color:
          Colors.white,
      child:
          const Icon(
        Icons.person,
        color:
            Colors.grey,
        size:
            30,
      ),
    );
  }
}

// =============================================================================
// SECTION LABEL
// =============================================================================

class _SectionLabel
    extends StatelessWidget {
  final String text;

  const _SectionLabel({
    required this.text,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(
        left: 6,
        bottom: 8,
      ),

      child: Text(
        text,
        style:
            TextStyle(
          fontSize: 12.5,
          fontWeight:
              FontWeight.w600,
          color:
              Colors.grey.shade500,
          letterSpacing:
              0.4,
        ),
      ),
    );
  }
}

// =============================================================================
// SECTION CARD
// =============================================================================

class _SectionCard
    extends StatelessWidget {
  final List<Widget> children;

  const _SectionCard({
    required this.children,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 14,
      ),

      decoration:
          BoxDecoration(
        color:
            Colors.white,

        borderRadius:
            BorderRadius.circular(
          18,
        ),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black
                    .withValues(
              alpha:
                  0.04,
            ),
            blurRadius:
                12,
            offset:
                const Offset(
              0,
              4,
            ),
          ),
        ],
      ),

      child: Column(
        children:
            children,
      ),
    );
  }
}

// =============================================================================
// LANGUAGE DROPDOWN
// =============================================================================

class _LanguageDropdownTile
    extends StatelessWidget {
  final AppLanguage selected;

  final ValueChanged<AppLanguage>
      onChanged;

  const _LanguageDropdownTile({
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets
                  .symmetric(
            vertical: 10,
          ),

          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment:
                    Alignment.center,

                decoration:
                    BoxDecoration(
                  color:
                      const Color(
                    0xFFF5F5F7,
                  ),
                  borderRadius:
                      BorderRadius
                          .circular(
                    10,
                  ),
                ),

                child:
                    const Icon(
                  Icons.language,
                  size: 20,
                  color:
                      Colors.black87,
                ),
              ),

              const SizedBox(
                width: 14,
              ),

              Expanded(
                child: Text(
                  AppStrings.language,
                  style:
                      const TextStyle(
                    fontSize: 15,
                    color:
                        Colors.black87,
                  ),
                ),
              ),

              Container(
                padding:
                    const EdgeInsets
                        .symmetric(
                  horizontal: 10,
                ),

                decoration:
                    BoxDecoration(
                  color:
                      const Color(
                    0xFFF5F5F7,
                  ),
                  borderRadius:
                      BorderRadius
                          .circular(
                    10,
                  ),
                ),

                child:
                    DropdownButtonHideUnderline(
                  child:
                      DropdownButton<
                          AppLanguage>(
                    value:
                        selected,

                    icon:
                        const Icon(
                      Icons
                          .keyboard_arrow_down,
                      size: 18,
                    ),

                    borderRadius:
                        BorderRadius
                            .circular(
                      12,
                    ),

                    style:
                        const TextStyle(
                      fontSize: 14,
                      color:
                          Colors.black87,
                      fontWeight:
                          FontWeight.w500,
                    ),

                    items: [
                      DropdownMenuItem(
                        value:
                            AppLanguage
                                .english,
                        child: Text(
                          AppStrings
                              .englishOption,
                        ),
                      ),

                      DropdownMenuItem(
                        value:
                            AppLanguage
                                .bengali,
                        child: Text(
                          AppStrings
                              .bengaliOption,
                        ),
                      ),
                    ],

                    onChanged:
                        (
                      value,
                    ) {
                      if (value !=
                          null) {
                        onChanged(
                          value,
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),

        Divider(
          height: 1,
          color:
              Colors.grey.shade200,
        ),
      ],
    );
  }
}

// =============================================================================
// MENU TILE
// =============================================================================

class _MenuTile
    extends StatelessWidget {
  final IconData icon;

  final String label;

  final VoidCallback? onTap;

  final bool showDivider;

  const _MenuTile({
    required this.icon,
    required this.label,
    this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Column(
      children: [
        InkWell(
          onTap:
              onTap,

          borderRadius:
              BorderRadius.circular(
            12,
          ),

          child: Padding(
            padding:
                const EdgeInsets
                    .symmetric(
              vertical: 10,
            ),

            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,

                  alignment:
                      Alignment.center,

                  decoration:
                      BoxDecoration(
                    color:
                        const Color(
                      0xFFF5F5F7,
                    ),
                    borderRadius:
                        BorderRadius
                            .circular(
                      10,
                    ),
                  ),

                  child: Icon(
                    icon,
                    size: 20,
                    color:
                        Colors.black87,
                  ),
                ),

                const SizedBox(
                  width: 14,
                ),

                Expanded(
                  child: Text(
                    label,
                    style:
                        const TextStyle(
                      fontSize: 15,
                      color:
                          Colors.black87,
                    ),
                  ),
                ),

                Icon(
                  Icons
                      .chevron_right,
                  size: 20,
                  color: Colors.grey
                      .shade400,
                ),
              ],
            ),
          ),
        ),

        if (showDivider)
          Divider(
            height: 1,
            color:
                Colors.grey.shade200,
          ),
      ],
    );
  }
}

// =============================================================================
// LOGOUT BUTTON
// =============================================================================

class _LogoutButton
    extends StatelessWidget {
  final String label;

  final VoidCallback? onTap;

  const _LogoutButton({
    required this.label,
    this.onTap,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return InkWell(
      onTap:
          onTap,

      borderRadius:
          BorderRadius.circular(
        28,
      ),

      child: Container(
        width:
            double.infinity,

        padding:
            const EdgeInsets
                .symmetric(
          vertical: 14,
        ),

        decoration:
            BoxDecoration(
          color:
              AppColors.primary,

          borderRadius:
              BorderRadius.circular(
            28,
          ),

          boxShadow: [
            BoxShadow(
              color: AppColors.primary
                  .withValues(
                alpha: 0.35,
              ),
              blurRadius:
                  14,
              offset:
                  const Offset(
                0,
                6,
              ),
            ),
          ],
        ),

        child: Row(
          mainAxisAlignment:
              MainAxisAlignment
                  .center,

          children: [
            Icon(
              Icons.logout,
              size: 18,
              color:
                  AppColors.white,
            ),

            const SizedBox(
              width: 8,
            ),

            Text(
              label,
              style:
                  TextStyle(
                fontSize: 15,
                fontWeight:
                    FontWeight.w600,
                color:
                    AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}