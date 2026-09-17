


// // // import 'dart:async';

// // // import 'package:flutter/material.dart';

// // // import '../../../../core/widgets/app_shimmer.dart';

// // // class RecipeWidget extends StatefulWidget {
// // //   final ValueChanged<int>? onRecipeTap;

// // //   const RecipeWidget({
// // //     super.key,
// // //     this.onRecipeTap,
// // //   });

// // //   @override
// // //   State<RecipeWidget> createState() => _RecipeWidgetState();
// // // }

// // // class _RecipeWidgetState extends State<RecipeWidget> {
// // //   static const Color _primary = Color(0xFFF70707);
// // //   static const Color _secondary = Color(0xFFEEE4E4);
// // //   static const Color _black = Color(0xFF000000);

// // //   static const List<Map<String, String>> _recipes = [
// // //     {
// // //       'imageUrl':
// // //           'https://lalbabaonline.com/public/uploads/all/y4NE0in0SBidT7FjYc9OkOWMDt9PelZi9U4wEHA6.webp',
// // //       'title': 'Basmati Mixed Fried Rice (Indo-Chinese Style)',
// // //     },
// // //     {
// // //       'imageUrl':
// // //           'https://lalbabaonline.com/public/uploads/all/tyyWmiCV2vMtiFKPeYq43STzLh6LhjGAuPakXxGo.webp',
// // //       'title': 'Vegetable Pulao (Light & Fragrant)',
// // //     },
// // //     {
// // //       'imageUrl':
// // //           'https://lalbabaonline.com/public/uploads/all/00D3pqgepFevSrA9fvG42scBArhC8QkSU41HmDQJ.webp',
// // //       'title': 'Classic Chicken Biryani',
// // //     },
// // //     {
// // //       'imageUrl':
// // //           'https://lalbabaonline.com/public/uploads/all/SuNZxBfg7s4Mx4XxK6N4wqcG9qCrOYxDmuPdm6td.webp',
// // //       'title': 'Lemon Rice (South Indian Style)',
// // //     },
// // //     {
// // //       'imageUrl':
// // //           'https://lalbabaonline.com/public/uploads/all/dS7re1Qz0FvnooB5aLCN1HumVF5qwmOcaHnnuN10.webp',
// // //       'title': 'Coconut Rice (Kerala Style)',
// // //     },
// // //   ];

// // //   late final PageController _pageController;
// // //   Timer? _autoScrollTimer;
// // //   late final int _initialPage;

// // //   int get _recipeCount => _recipes.length;

// // //   @override
// // //   void initState() {
// // //     super.initState();

// // //     _initialPage =
// // //         _recipeCount > 0 ? 10000 - (10000 % _recipeCount) : 0;

// // //     _pageController = PageController(
// // //       initialPage: _initialPage,
// // //       viewportFraction: 0.74,
// // //     );

// // //     if (_recipeCount > 1) {
// // //       _autoScrollTimer = Timer.periodic(
// // //         const Duration(seconds: 3),
// // //         (_) => _goToNext(),
// // //       );
// // //     }
// // //   }

// // //   void _goToNext() {
// // //     if (!_pageController.hasClients || _recipeCount <= 1) {
// // //       return;
// // //     }

// // //     final int currentPage =
// // //         _pageController.page?.round() ?? _initialPage;

// // //     _pageController.animateToPage(
// // //       currentPage + 1,
// // //       duration: const Duration(milliseconds: 550),
// // //       curve: Curves.easeInOutCubic,
// // //     );
// // //   }

// // //   @override
// // //   void dispose() {
// // //     _autoScrollTimer?.cancel();
// // //     _pageController.dispose();
// // //     super.dispose();
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     if (_recipeCount == 0) {
// // //       return const SizedBox.shrink();
// // //     }

// // //     return Column(
// // //       crossAxisAlignment: CrossAxisAlignment.start,
// // //       children: [
// // //         const Padding(
// // //           padding: EdgeInsets.symmetric(horizontal: 16),
// // //           child: Text(
// // //             'Recipes You\'ll Love',
// // //             style: TextStyle(
// // //               fontSize: 17,
// // //               fontWeight: FontWeight.bold,
// // //               color: _black,
// // //             ),
// // //           ),
// // //         ),

// // //         const SizedBox(height: 12),

// // //         SizedBox(
// // //           height: 190,
// // //           child: PageView.builder(
// // //             controller: _pageController,
// // //             itemCount: 100000,
// // //             itemBuilder: (context, pageIndex) {
// // //               final int index = pageIndex % _recipeCount;
// // //               final recipe = _recipes[index];

// // //               return AnimatedBuilder(
// // //                 animation: _pageController,
// // //                 builder: (context, child) {
// // //                   double scale = 1.0;

// // //                   if (_pageController.hasClients &&
// // //                       _pageController.position.haveDimensions) {
// // //                     final double page =
// // //                         _pageController.page ??
// // //                             _initialPage.toDouble();

// // //                     scale =
// // //                         (1 -
// // //                                 ((page - pageIndex).abs() *
// // //                                     0.08))
// // //                             .clamp(
// // //                               0.92,
// // //                               1.0,
// // //                             );
// // //                   }

// // //                   return Transform.scale(
// // //                     scale: scale,
// // //                     child: child,
// // //                   );
// // //                 },

// // //                 child: Padding(
// // //                   padding: const EdgeInsets.symmetric(
// // //                     horizontal: 6,
// // //                   ),
// // //                   child: GestureDetector(
// // //                     onTap: () {
// // //                       widget.onRecipeTap?.call(index);
// // //                     },
// // //                     child: ClipRRect(
// // //                       borderRadius:
// // //                           BorderRadius.circular(16),
// // //                       child: DecoratedBox(
// // //                         decoration: BoxDecoration(
// // //                           boxShadow: [
// // //                             BoxShadow(
// // //                               color: _black.withValues(
// // //                                 alpha: 0.10,
// // //                               ),
// // //                               blurRadius: 10,
// // //                               offset: const Offset(0, 4),
// // //                             ),
// // //                           ],
// // //                         ),
// // //                         child: Stack(
// // //                           fit: StackFit.expand,
// // //                           children: [
// // //                             // IMAGE
// // //                             _RecipeImage(
// // //                               imageUrl:
// // //                                   recipe['imageUrl']!,
// // //                             ),

// // //                             // GRADIENT
// // //                             const Positioned.fill(
// // //                               child: DecoratedBox(
// // //                                 decoration: BoxDecoration(
// // //                                   gradient:
// // //                                       LinearGradient(
// // //                                     begin:
// // //                                         Alignment.topCenter,
// // //                                     end:
// // //                                         Alignment.bottomCenter,
// // //                                     colors: [
// // //                                       Colors.transparent,
// // //                                       Color(0xB3000000),
// // //                                     ],
// // //                                     stops: [
// // //                                       0.45,
// // //                                       1.0,
// // //                                     ],
// // //                                   ),
// // //                                 ),
// // //                               ),
// // //                             ),

// // //                             // TITLE
// // //                             Positioned(
// // //                               left: 14,
// // //                               right: 14,
// // //                               bottom: 14,
// // //                               child: Text(
// // //                                 recipe['title']!
// // //                                     .toUpperCase(),
// // //                                 maxLines: 2,
// // //                                 overflow:
// // //                                     TextOverflow.ellipsis,
// // //                                 style:
// // //                                     const TextStyle(
// // //                                   color: Colors.white,
// // //                                   fontSize: 14.5,
// // //                                   fontWeight:
// // //                                       FontWeight.w800,
// // //                                   height: 1.25,
// // //                                   letterSpacing: 0.1,
// // //                                   shadows: [
// // //                                     Shadow(
// // //                                       color:
// // //                                           Colors.black54,
// // //                                       blurRadius: 6,
// // //                                       offset:
// // //                                           Offset(0, 1),
// // //                                     ),
// // //                                   ],
// // //                                 ),
// // //                               ),
// // //                             ),
// // //                           ],
// // //                         ),
// // //                       ),
// // //                     ),
// // //                   ),
// // //                 ),
// // //               );
// // //             },
// // //           ),
// // //         ),
// // //       ],
// // //     );
// // //   }
// // // }

// // // class _RecipeImage extends StatelessWidget {
// // //   final String imageUrl;

// // //   const _RecipeImage({
// // //     required this.imageUrl,
// // //   });

// // //   static const Color _secondary =
// // //       Color(0xFFEEE4E4);

// // //   static const Color _primary =
// // //       Color(0xFFF70707);

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Image.network(
// // //       imageUrl,
// // //       fit: BoxFit.cover,
// // //       width: double.infinity,
// // //       height: double.infinity,

// // //       // SHIMMER WHILE IMAGE LOADS
// // //       loadingBuilder: (
// // //         BuildContext context,
// // //         Widget child,
// // //         ImageChunkEvent? progress,
// // //       ) {
// // //         if (progress == null) {
// // //           return child;
// // //         }

// // //         return const AppShimmer(
// // //           width: double.infinity,
// // //           height: double.infinity,
// // //           radius: 16,
// // //         );
// // //       },

// // //       // IMAGE ERROR
// // //       errorBuilder: (
// // //         BuildContext context,
// // //         Object error,
// // //         StackTrace? stackTrace,
// // //       ) {
// // //         return Container(
// // //           width: double.infinity,
// // //           height: double.infinity,
// // //           color: _secondary,
// // //           alignment: Alignment.center,
// // //           child: const Icon(
// // //             Icons.image_not_supported_outlined,
// // //             color: _primary,
// // //             size: 26,
// // //           ),
// // //         );
// // //       },
// // //     );
// // //   }
// // // }
// // import 'dart:async';

// // import 'package:flutter/material.dart';

// // import '../../../../core/widgets/app_shimmer.dart';
// // import '../../../account/presentation/widgets/app_string.dart';

// // class RecipeWidget
// //     extends StatefulWidget {
// //   final ValueChanged<int>? onRecipeTap;

// //   const RecipeWidget({
// //     super.key,
// //     this.onRecipeTap,
// //   });

// //   @override
// //   State<RecipeWidget> createState() =>
// //       _RecipeWidgetState();
// // }

// // class _RecipeWidgetState
// //     extends State<RecipeWidget> {
// //   static const Color _primary =
// //       Color(0xFFF70707);

// //   static const Color _secondary =
// //       Color(0xFFEEE4E4);

// //   static const Color _black =
// //       Color(0xFF000000);

// //   static const List<Map<String, String>>
// //       _recipes = [
// //     {
// //       'imageUrl':
// //           'https://lalbabaonline.com/public/uploads/all/y4NE0in0SBidT7FjYc9OkOWMDt9PelZi9U4wEHA6.webp',
// //       'title':
// //           'Basmati Mixed Fried Rice (Indo-Chinese Style)',
// //     },
// //     {
// //       'imageUrl':
// //           'https://lalbabaonline.com/public/uploads/all/tyyWmiCV2vMtiFKPeYq43STzLh6LhjGAuPakXxGo.webp',
// //       'title':
// //           'Vegetable Pulao (Light & Fragrant)',
// //     },
// //     {
// //       'imageUrl':
// //           'https://lalbabaonline.com/public/uploads/all/00D3pqgepFevSrA9fvG42scBArhC8QkSU41HmDQJ.webp',
// //       'title':
// //           'Classic Chicken Biryani',
// //     },
// //     {
// //       'imageUrl':
// //           'https://lalbabaonline.com/public/uploads/all/SuNZxBfg7s4Mx4XxK6N4wqcG9qCrOYxDmuPdm6td.webp',
// //       'title':
// //           'Lemon Rice (South Indian Style)',
// //     },
// //     {
// //       'imageUrl':
// //           'https://lalbabaonline.com/public/uploads/all/dS7re1Qz0FvnooB5aLCN1HumVF5qwmOcaHnnuN10.webp',
// //       'title':
// //           'Coconut Rice (Kerala Style)',
// //     },
// //   ];

// //   late final PageController
// //       _pageController;

// //   Timer? _autoScrollTimer;

// //   late final int _initialPage;

// //   int get _recipeCount =>
// //       _recipes.length;

// //   @override
// //   void initState() {
// //     super.initState();

// //     _initialPage = _recipeCount > 0
// //         ? 10000 -
// //             (10000 % _recipeCount)
// //         : 0;

// //     _pageController =
// //         PageController(
// //       initialPage: _initialPage,
// //       viewportFraction: 0.74,
// //     );

// //     if (_recipeCount > 1) {
// //       _autoScrollTimer =
// //           Timer.periodic(
// //         const Duration(seconds: 3),
// //         (_) => _goToNext(),
// //       );
// //     }
// //   }

// //   void _goToNext() {
// //     if (!_pageController
// //             .hasClients ||
// //         _recipeCount <= 1) {
// //       return;
// //     }

// //     final int currentPage =
// //         _pageController.page?.round() ??
// //             _initialPage;

// //     _pageController.animateToPage(
// //       currentPage + 1,
// //       duration:
// //           const Duration(
// //         milliseconds: 550,
// //       ),
// //       curve:
// //           Curves.easeInOutCubic,
// //     );
// //   }

// //   @override
// //   void dispose() {
// //     _autoScrollTimer?.cancel();
// //     _pageController.dispose();

// //     super.dispose();
// //   }

// //   @override
// //   Widget build(
// //     BuildContext context,
// //   ) {
// //     if (_recipeCount == 0) {
// //       return const SizedBox.shrink();
// //     }

// //     return Column(
// //       crossAxisAlignment:
// //           CrossAxisAlignment.start,
// //       children: [
// //         Padding(
// //           padding:
// //               const EdgeInsets
// //                   .symmetric(
// //             horizontal: 16,
// //           ),
// //           child: Text(
// //             AppStrings
// //                 .recipesYoullLove,
// //             style:
// //                 const TextStyle(
// //               fontSize: 17,
// //               fontWeight:
// //                   FontWeight.bold,
// //               color: _black,
// //             ),
// //           ),
// //         ),

// //         const SizedBox(
// //           height: 12,
// //         ),

// //         SizedBox(
// //           height: 190,
// //           child: PageView.builder(
// //             controller:
// //                 _pageController,
// //             itemCount: 100000,
// //             itemBuilder: (
// //               context,
// //               pageIndex,
// //             ) {
// //               final int index =
// //                   pageIndex %
// //                       _recipeCount;

// //               final recipe =
// //                   _recipes[index];

// //               return AnimatedBuilder(
// //                 animation:
// //                     _pageController,
// //                 builder: (
// //                   context,
// //                   child,
// //                 ) {
// //                   double scale = 1.0;

// //                   if (_pageController
// //                           .hasClients &&
// //                       _pageController
// //                           .position
// //                           .haveDimensions) {
// //                     final double page =
// //                         _pageController
// //                                 .page ??
// //                             _initialPage
// //                                 .toDouble();

// //                     scale =
// //                         (1 -
// //                                 ((page -
// //                                             pageIndex)
// //                                         .abs() *
// //                                     0.08))
// //                             .clamp(
// //                       0.92,
// //                       1.0,
// //                     );
// //                   }

// //                   return Transform.scale(
// //                     scale: scale,
// //                     child: child,
// //                   );
// //                 },
// //                 child: Padding(
// //                   padding:
// //                       const EdgeInsets
// //                           .symmetric(
// //                     horizontal: 6,
// //                   ),
// //                   child:
// //                       GestureDetector(
// //                     onTap: () {
// //                       widget
// //                           .onRecipeTap
// //                           ?.call(index);
// //                     },
// //                     child: ClipRRect(
// //                       borderRadius:
// //                           BorderRadius
// //                               .circular(
// //                         16,
// //                       ),
// //                       child:
// //                           DecoratedBox(
// //                         decoration:
// //                             BoxDecoration(
// //                           boxShadow: [
// //                             BoxShadow(
// //                               color: _black
// //                                   .withValues(
// //                                 alpha:
// //                                     0.10,
// //                               ),
// //                               blurRadius:
// //                                   10,
// //                               offset:
// //                                   const Offset(
// //                                 0,
// //                                 4,
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                         child: Stack(
// //                           fit: StackFit
// //                               .expand,
// //                           children: [
// //                             _RecipeImage(
// //                               imageUrl:
// //                                   recipe[
// //                                       'imageUrl']!,
// //                             ),

// //                             const Positioned
// //                                 .fill(
// //                               child:
// //                                   DecoratedBox(
// //                                 decoration:
// //                                     BoxDecoration(
// //                                   gradient:
// //                                       LinearGradient(
// //                                     begin:
// //                                         Alignment
// //                                             .topCenter,
// //                                     end:
// //                                         Alignment
// //                                             .bottomCenter,
// //                                     colors: [
// //                                       Colors
// //                                           .transparent,
// //                                       Color(
// //                                         0xB3000000,
// //                                       ),
// //                                     ],
// //                                     stops: [
// //                                       0.45,
// //                                       1.0,
// //                                     ],
// //                                   ),
// //                                 ),
// //                               ),
// //                             ),

// //                             Positioned(
// //                               left: 14,
// //                               right: 14,
// //                               bottom: 14,
// //                               child: Text(
// //                                 recipe[
// //                                         'title']!
// //                                     .toUpperCase(),
// //                                 maxLines: 2,
// //                                 overflow:
// //                                     TextOverflow
// //                                         .ellipsis,
// //                                 style:
// //                                     const TextStyle(
// //                                   color:
// //                                       Colors.white,
// //                                   fontSize:
// //                                       14.5,
// //                                   fontWeight:
// //                                       FontWeight
// //                                           .w800,
// //                                   height:
// //                                       1.25,
// //                                   letterSpacing:
// //                                       0.1,
// //                                   shadows: [
// //                                     Shadow(
// //                                       color:
// //                                           Colors
// //                                               .black54,
// //                                       blurRadius:
// //                                           6,
// //                                       offset:
// //                                           Offset(
// //                                         0,
// //                                         1,
// //                                       ),
// //                                     ),
// //                                   ],
// //                                 ),
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               );
// //             },
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }

// // class _RecipeImage
// //     extends StatelessWidget {
// //   final String imageUrl;

// //   const _RecipeImage({
// //     required this.imageUrl,
// //   });

// //   static const Color _secondary =
// //       Color(0xFFEEE4E4);

// //   static const Color _primary =
// //       Color(0xFFF70707);

// //   @override
// //   Widget build(
// //     BuildContext context,
// //   ) {
// //     return Image.network(
// //       imageUrl,
// //       fit: BoxFit.cover,
// //       width: double.infinity,
// //       height: double.infinity,
// //       loadingBuilder: (
// //         BuildContext context,
// //         Widget child,
// //         ImageChunkEvent? progress,
// //       ) {
// //         if (progress == null) {
// //           return child;
// //         }

// //         return const AppShimmer(
// //           width: double.infinity,
// //           height: double.infinity,
// //           radius: 16,
// //         );
// //       },
// //       errorBuilder: (
// //         BuildContext context,
// //         Object error,
// //         StackTrace? stackTrace,
// //       ) {
// //         return Container(
// //           width: double.infinity,
// //           height: double.infinity,
// //           color: _secondary,
// //           alignment:
// //               Alignment.center,
// //           child: const Icon(
// //             Icons
// //                 .image_not_supported_outlined,
// //             color: _primary,
// //             size: 26,
// //           ),
// //         );
// //       },
// //     );
// //   }
// // }

// import 'dart:async';

// import 'package:flutter/material.dart';

// import '../../../../core/widgets/app_shimmer.dart';
// import '../../../account/presentation/widgets/app_string.dart';
// import '../../../account/presentation/widgets/languange_constant.dart';

// class RecipeWidget extends StatefulWidget {
//   final ValueChanged<int>? onRecipeTap;

//   const RecipeWidget({
//     super.key,
//     this.onRecipeTap,
//   });

//   @override
//   State<RecipeWidget> createState() => _RecipeWidgetState();
// }

// class _RecipeWidgetState extends State<RecipeWidget> {
//   static const Color _primary = Color(0xFFF70707);
//   static const Color _secondary = Color(0xFFEEE4E4);
//   static const Color _black = Color(0xFF000000);

//   static const List<Map<String, String>> _recipes = [
//     {
//       'imageUrl':
//           'https://lalbabaonline.com/public/uploads/all/y4NE0in0SBidT7FjYc9OkOWMDt9PelZi9U4wEHA6.webp',
//       'title': 'Basmati Mixed Fried Rice (Indo-Chinese Style)',
//     },
//     {
//       'imageUrl':
//           'https://lalbabaonline.com/public/uploads/all/tyyWmiCV2vMtiFKPeYq43STzLh6LhjGAuPakXxGo.webp',
//       'title': 'Vegetable Pulao (Light & Fragrant)',
//     },
//     {
//       'imageUrl':
//           'https://lalbabaonline.com/public/uploads/all/00D3pqgepFevSrA9fvG42scBArhC8QkSU41HmDQJ.webp',
//       'title': 'Classic Chicken Biryani',
//     },
//     {
//       'imageUrl':
//           'https://lalbabaonline.com/public/uploads/all/SuNZxBfg7s4Mx4XxK6N4wqcG9qCrOYxDmuPdm6td.webp',
//       'title': 'Lemon Rice (South Indian Style)',
//     },
//     {
//       'imageUrl':
//           'https://lalbabaonline.com/public/uploads/all/dS7re1Qz0FvnooB5aLCN1HumVF5qwmOcaHnnuN10.webp',
//       'title': 'Coconut Rice (Kerala Style)',
//     },
//   ];

//   late final PageController _pageController;

//   Timer? _autoScrollTimer;

//   late final int _initialPage;

//   int get _recipeCount => _recipes.length;

//   @override
//   void initState() {
//     super.initState();

//     _initialPage = _recipeCount > 0
//         ? 10000 - (10000 % _recipeCount)
//         : 0;

//     _pageController = PageController(
//       initialPage: _initialPage,
//       viewportFraction: 0.74,
//     );

//     if (_recipeCount > 1) {
//       _autoScrollTimer = Timer.periodic(
//         const Duration(seconds: 3),
//         (_) => _goToNext(),
//       );
//     }
//   }

//   void _goToNext() {
//     if (!_pageController.hasClients || _recipeCount <= 1) {
//       return;
//     }

//     final int currentPage =
//         _pageController.page?.round() ?? _initialPage;

//     _pageController.animateToPage(
//       currentPage + 1,
//       duration: const Duration(
//         milliseconds: 550,
//       ),
//       curve: Curves.easeInOutCubic,
//     );
//   }

//   @override
//   void dispose() {
//     _autoScrollTimer?.cancel();
//     _pageController.dispose();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_recipeCount == 0) {
//       return const SizedBox.shrink();
//     }

//     // ================================================================
//     // LANGUAGE LISTENER
//     // BottomNavigationPage-er moto same pattern
//     // ================================================================

//     return AnimatedBuilder(
//       animation: AppLanguageConstants.instance,
//       builder: (context, child) {
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // ========================================================
//             // TITLE
//             // ========================================================

//             Padding(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 16,
//               ),
//               child: Text(
//                 AppStrings.recipesYoullLove,
//                 style: const TextStyle(
//                   fontSize: 17,
//                   fontWeight: FontWeight.bold,
//                   color: _black,
//                 ),
//               ),
//             ),

//             const SizedBox(
//               height: 12,
//             ),

//             // ========================================================
//             // RECIPE CAROUSEL
//             // ========================================================

//             SizedBox(
//               height: 190,
//               child: PageView.builder(
//                 controller: _pageController,
//                 itemCount: 100000,
//                 itemBuilder: (
//                   context,
//                   pageIndex,
//                 ) {
//                   final int index =
//                       pageIndex % _recipeCount;

//                   final recipe = _recipes[index];

//                   return AnimatedBuilder(
//                     animation: _pageController,
//                     builder: (
//                       context,
//                       child,
//                     ) {
//                       double scale = 1.0;

//                       if (_pageController.hasClients &&
//                           _pageController
//                               .position
//                               .haveDimensions) {
//                         final double page =
//                             _pageController.page ??
//                                 _initialPage.toDouble();

//                         scale = (1 -
//                                 ((page - pageIndex).abs() *
//                                     0.08))
//                             .clamp(
//                           0.92,
//                           1.0,
//                         );
//                       }

//                       return Transform.scale(
//                         scale: scale,
//                         child: child,
//                       );
//                     },
//                     child: Padding(
//                       padding:
//                           const EdgeInsets.symmetric(
//                         horizontal: 6,
//                       ),
//                       child: GestureDetector(
//                         onTap: () {
//                           widget.onRecipeTap?.call(
//                             index,
//                           );
//                         },
//                         child: ClipRRect(
//                           borderRadius:
//                               BorderRadius.circular(
//                             16,
//                           ),
//                           child: DecoratedBox(
//                             decoration: BoxDecoration(
//                               boxShadow: [
//                                 BoxShadow(
//                                   color:
//                                       _black.withValues(
//                                     alpha: 0.10,
//                                   ),
//                                   blurRadius: 10,
//                                   offset:
//                                       const Offset(
//                                     0,
//                                     4,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             child: Stack(
//                               fit: StackFit.expand,
//                               children: [
//                                 // ================================
//                                 // IMAGE
//                                 // ================================

//                                 _RecipeImage(
//                                   imageUrl:
//                                       recipe['imageUrl']!,
//                                 ),

//                                 // ================================
//                                 // DARK GRADIENT
//                                 // ================================

//                                 const Positioned.fill(
//                                   child: DecoratedBox(
//                                     decoration:
//                                         BoxDecoration(
//                                       gradient:
//                                           LinearGradient(
//                                         begin:
//                                             Alignment
//                                                 .topCenter,
//                                         end:
//                                             Alignment
//                                                 .bottomCenter,
//                                         colors: [
//                                           Colors
//                                               .transparent,
//                                           Color(
//                                             0xB3000000,
//                                           ),
//                                         ],
//                                         stops: [
//                                           0.45,
//                                           1.0,
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),

//                                 // ================================
//                                 // RECIPE TITLE
//                                 // ================================

//                                 Positioned(
//                                   left: 14,
//                                   right: 14,
//                                   bottom: 14,
//                                   child: Text(
//                                     recipe['title']!
//                                         .toUpperCase(),
//                                     maxLines: 2,
//                                     overflow:
//                                         TextOverflow
//                                             .ellipsis,
//                                     style:
//                                         const TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 14.5,
//                                       fontWeight:
//                                           FontWeight
//                                               .w800,
//                                       height: 1.25,
//                                       letterSpacing:
//                                           0.1,
//                                       shadows: [
//                                         Shadow(
//                                           color: Colors
//                                               .black54,
//                                           blurRadius: 6,
//                                           offset: Offset(
//                                             0,
//                                             1,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// class _RecipeImage extends StatelessWidget {
//   final String imageUrl;

//   const _RecipeImage({
//     required this.imageUrl,
//   });

//   static const Color _secondary =
//       Color(0xFFEEE4E4);

//   static const Color _primary =
//       Color(0xFFF70707);

//   @override
//   Widget build(BuildContext context) {
//     return Image.network(
//       imageUrl,
//       fit: BoxFit.cover,
//       width: double.infinity,
//       height: double.infinity,
//       loadingBuilder: (
//         BuildContext context,
//         Widget child,
//         ImageChunkEvent? progress,
//       ) {
//         if (progress == null) {
//           return child;
//         }

//         return const AppShimmer(
//           width: double.infinity,
//           height: double.infinity,
//           radius: 16,
//         );
//       },
//       errorBuilder: (
//         BuildContext context,
//         Object error,
//         StackTrace? stackTrace,
//       ) {
//         return Container(
//           width: double.infinity,
//           height: double.infinity,
//           color: _secondary,
//           alignment: Alignment.center,
//           child: const Icon(
//             Icons.image_not_supported_outlined,
//             color: _primary,
//             size: 26,
//           ),
//         );
//       },
//     );
//   }
// }

import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/widgets/app_shimmer.dart';
import '../../../account/presentation/widgets/app_string.dart';
import '../../../account/presentation/widgets/languange_constant.dart';

class RecipeWidget extends StatefulWidget {
  final ValueChanged<int>? onRecipeTap;

  const RecipeWidget({
    super.key,
    this.onRecipeTap,
  });

  @override
  State<RecipeWidget> createState() =>
      _RecipeWidgetState();
}

class _RecipeWidgetState
    extends State<RecipeWidget> {
  static const Color _primary =
      Color(0xFFF70707);

  static const Color _black =
      Color(0xFF212121);

  static const Color _grey =
      Color(0xFF777777);

  // ===========================================================================
  // RECIPE DATA
  // ===========================================================================

  static const List<Map<String, String>>
      _recipes = [
    {
      'imageUrl':
          'https://lalbabaonline.com/public/uploads/all/y4NE0in0SBidT7FjYc9OkOWMDt9PelZi9U4wEHA6.webp',
      'title':
          'Basmati Mixed Fried Rice (Indo-Chinese Style)',
    },
    {
      'imageUrl':
          'https://lalbabaonline.com/public/uploads/all/tyyWmiCV2vMtiFKPeYq43STzLh6LhjGAuPakXxGo.webp',
      'title':
          'Vegetable Pulao (Light & Fragrant)',
    },
    {
      'imageUrl':
          'https://lalbabaonline.com/public/uploads/all/00D3pqgepFevSrA9fvG42scBArhC8QkSU41HmDQJ.webp',
      'title':
          'Classic Chicken Biryani',
    },
    {
      'imageUrl':
          'https://lalbabaonline.com/public/uploads/all/SuNZxBfg7s4Mx4XxK6N4wqcG9qCrOYxDmuPdm6td.webp',
      'title':
          'Lemon Rice (South Indian Style)',
    },
    {
      'imageUrl':
          'https://lalbabaonline.com/public/uploads/all/dS7re1Qz0FvnooB5aLCN1HumVF5qwmOcaHnnuN10.webp',
      'title':
          'Coconut Rice (Kerala Style)',
    },
  ];

  // ===========================================================================
  // PAGE CONTROLLER
  // ===========================================================================

  late final PageController _pageController;

  Timer? _autoScrollTimer;

  int _currentPage = 0;

  int get _recipeCount =>
      _recipes.length;

  // ===========================================================================
  // INIT
  // ===========================================================================

  @override
  void initState() {
    super.initState();

    _pageController =
        PageController(
      initialPage: 0,

      // Next card-er halka preview dekhabe
      // kintu section-er baire jabe na
      viewportFraction: 0.90,
    );

    if (_recipeCount > 1) {
      _autoScrollTimer =
          Timer.periodic(
        const Duration(
          seconds: 4,
        ),
        (_) {
          _goToNext();
        },
      );
    }
  }

  // ===========================================================================
  // AUTO NEXT
  // ===========================================================================

  void _goToNext() {
    if (!_pageController
        .hasClients) {
      return;
    }

    if (_recipeCount <= 1) {
      return;
    }

    int nextPage =
        _currentPage + 1;

    // Last recipe-er por abar first recipe
    if (nextPage >=
        _recipeCount) {
      nextPage = 0;
    }

    _pageController.animateToPage(
      nextPage,
      duration:
          const Duration(
        milliseconds: 500,
      ),
      curve:
          Curves.easeInOutCubic,
    );
  }

  // ===========================================================================
  // DISPOSE
  // ===========================================================================

  @override
  void dispose() {
    _autoScrollTimer
        ?.cancel();

    _pageController
        .dispose();

    super.dispose();
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    if (_recipes.isEmpty) {
      return const SizedBox
          .shrink();
    }

    return AnimatedBuilder(
      animation:
          AppLanguageConstants
              .instance,
      builder: (
        context,
        child,
      ) {
        return Container(
          width:
              double.infinity,

          // Recipe section-er nijer space
          margin:
              const EdgeInsets.only(
            top: 20,
          ),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment
                    .start,
            children: [
              // ===============================================================
              // RECIPE HEADER
              // ===============================================================

              Padding(
                padding:
                    const EdgeInsets
                        .symmetric(
                  horizontal: 16,
                ),
                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .center,
                  children: [
                    // ---------------------------------------------------------
                    // RED LINE
                    // ---------------------------------------------------------

                    Container(
                      width: 4,
                      height: 34,
                      decoration:
                          BoxDecoration(
                        color:
                            _primary,
                        borderRadius:
                            BorderRadius
                                .circular(
                          10,
                        ),
                      ),
                    ),

                    const SizedBox(
                      width: 10,
                    ),

                    // ---------------------------------------------------------
                    // TITLE
                    // ---------------------------------------------------------

                    Expanded(
                      child: Text(
                        AppStrings
                            .recipesYoullLove,
                        style:
                            const TextStyle(
                          fontSize:
                              17,
                          fontWeight:
                              FontWeight
                                  .bold,
                          color:
                              _black,
                        ),
                      ),
                    ),

                    // ---------------------------------------------------------
                    // ICON
                    // ---------------------------------------------------------

                    Container(
                      width: 36,
                      height: 36,
                      decoration:
                          BoxDecoration(
                        color:
                            _primary
                                .withValues(
                          alpha:
                              0.08,
                        ),
                        shape:
                            BoxShape
                                .circle,
                      ),
                      alignment:
                          Alignment
                              .center,
                      child:
                          const Icon(
                        Icons
                            .restaurant_menu_rounded,
                        size: 20,
                        color:
                            _primary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 14,
              ),

              // ===============================================================
              // RECIPE CAROUSEL
              // ===============================================================

              SizedBox(
                height: 210,
                width:
                    double.infinity,
                child:
                    PageView.builder(
                  controller:
                      _pageController,

                  itemCount:
                      _recipeCount,

                  // Card section-er baire berobe na
                  clipBehavior:
                      Clip.hardEdge,

                  onPageChanged:
                      (
                    index,
                  ) {
                    _currentPage =
                        index;
                  },

                  itemBuilder:
                      (
                    context,
                    index,
                  ) {
                    final recipe =
                        _recipes[
                            index];

                    return Padding(
                      padding:
                          EdgeInsets
                              .only(
                        left:
                            index == 0
                                ? 16
                                : 6,
                        right:
                            10,
                      ),
                      child:
                          GestureDetector(
                        onTap:
                            () {
                          widget
                              .onRecipeTap
                              ?.call(
                            index,
                          );
                        },
                        child:
                            _RecipeCard(
                          imageUrl:
                              recipe[
                                  'imageUrl']!,
                          title:
                              recipe[
                                  'title']!,
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(
                height: 28,
              ),

              // ===============================================================
              // SECTION DIVIDER
              // Recipe ar Happy Home Chef clearly separate korbe
              // ===============================================================

              Padding(
                padding:
                    const EdgeInsets
                        .symmetric(
                  horizontal: 16,
                ),
                child:
                    Container(
                  height: 1,
                  width:
                      double.infinity,
                  color:
                      const Color(
                    0xFFE8E8E8,
                  ),
                ),
              ),

              const SizedBox(
                height: 4,
              ),
            ],
          ),
        );
      },
    );
  }
}

// =============================================================================
// RECIPE CARD
// =============================================================================

class _RecipeCard
    extends StatelessWidget {
  final String imageUrl;
  final String title;

  const _RecipeCard({
    required this.imageUrl,
    required this.title,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      decoration:
          BoxDecoration(
        color:
            Colors.white,

        borderRadius:
            BorderRadius
                .circular(
          16,
        ),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black
                    .withValues(
              alpha:
                  0.08,
            ),
            blurRadius:
                10,
            offset:
                const Offset(
              0,
              4,
            ),
          ),
        ],
      ),

      clipBehavior:
          Clip.antiAlias,

      child:
          Stack(
        fit:
            StackFit.expand,
        children: [
          // ===================================================================
          // IMAGE
          // ===================================================================

          _RecipeImage(
            imageUrl:
                imageUrl,
          ),

          // ===================================================================
          // DARK GRADIENT
          // ===================================================================

          const Positioned.fill(
            child:
                DecoratedBox(
              decoration:
                  BoxDecoration(
                gradient:
                    LinearGradient(
                  begin:
                      Alignment
                          .topCenter,
                  end:
                      Alignment
                          .bottomCenter,
                  colors: [
                    Colors
                        .transparent,
                    Color(
                      0x18000000,
                    ),
                    Color(
                      0xD9000000,
                    ),
                  ],
                  stops: [
                    0,
                    0.55,
                    1,
                  ],
                ),
              ),
            ),
          ),

          // ===================================================================
          // RECIPE TITLE
          // ===================================================================

          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child:
                Text(
              title,
              maxLines:
                  2,
              overflow:
                  TextOverflow
                      .ellipsis,
              style:
                  const TextStyle(
                color:
                    Colors.white,
                fontSize:
                    14,
                fontWeight:
                    FontWeight
                        .w800,
                height:
                    1.3,
                shadows: [
                  Shadow(
                    color:
                        Colors.black45,
                    blurRadius:
                        4,
                    offset:
                        Offset(
                      0,
                      1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// RECIPE IMAGE
// =============================================================================

class _RecipeImage
    extends StatelessWidget {
  final String imageUrl;

  const _RecipeImage({
    required this.imageUrl,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Image.network(
      imageUrl,

      fit:
          BoxFit.cover,

      width:
          double.infinity,

      height:
          double.infinity,

      // =======================================================================
      // IMAGE LOADING
      // =======================================================================

      loadingBuilder:
          (
        context,
        child,
        progress,
      ) {
        if (progress ==
            null) {
          return child;
        }

        return const AppShimmer(
          width:
              double.infinity,
          height:
              double.infinity,
          radius:
              16,
        );
      },

      // =======================================================================
      // IMAGE ERROR
      // =======================================================================

      errorBuilder:
          (
        context,
        error,
        stackTrace,
      ) {
        return Container(
          color:
              const Color(
            0xFFF4F4F4,
          ),
          alignment:
              Alignment.center,
          child:
              const Column(
            mainAxisAlignment:
                MainAxisAlignment
                    .center,
            children: [
              Icon(
                Icons
                    .image_not_supported_outlined,
                color:
                    Color(
                  0xFFF70707,
                ),
                size:
                    30,
              ),

              SizedBox(
                height:
                    6,
              ),

              Text(
                'Image unavailable',
                style:
                    TextStyle(
                  color:
                      Color(
                    0xFF777777,
                  ),
                  fontSize:
                      11,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}