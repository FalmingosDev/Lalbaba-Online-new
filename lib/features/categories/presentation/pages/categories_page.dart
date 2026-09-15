
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/app_app_bar.dart';
import '../../../account/presentation/widgets/app_string.dart';
import '../../../account/presentation/widgets/languange_constant.dart';
import '../../../home/presentation/widgets/category_widget.dart';
import '../../../product/presentation/pages/product_list_page.dart';
import '../widgets/sub_categories_widgets.dart';

class CategoriesPage extends ConsumerStatefulWidget {
  const CategoriesPage({super.key});

  @override
  ConsumerState<CategoriesPage> createState() =>
      _CategoriesPageState();
}

class _CategoriesPageState
    extends ConsumerState<CategoriesPage> {
  int _selectedCategoryIndex = 0;

  // ============================================================
  // MAIN CATEGORIES
  // Always English
  // ============================================================

  final List<String> _categories = const [
    'Rice',
    'Spices',
  ];

  // ============================================================
  // SUB CATEGORIES
  // Always English
  // ============================================================

  final Map<String, List<String>> _subCategories = const {
    'Rice': [
      'Jeera Kathi',
      'Basmati',
      'Gobindo Bhog',
      'Ratna',
      'Banskathi',
      'Minikit',
    ],

    'Spices': [],
  };

  // ============================================================
  // SELECTED CATEGORY
  // ============================================================

  String get _selectedCategory {
    return _categories[_selectedCategoryIndex];
  }

  // ============================================================
  // SELECTED SUB CATEGORIES
  // ============================================================

  List<String> get _selectedSubCategories {
    return _subCategories[_selectedCategory] ?? [];
  }

  // ============================================================
  // OPEN PRODUCT LIST
  // ============================================================

  void _openProductList(
    String subCategory,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ProductListPage(
          pageTitle: subCategory,
          initialCategory: subCategory,
        ),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    return AnimatedBuilder(
      animation:
          AppLanguageConstants.instance,
      builder: (
        context,
        child,
      ) {
        return Scaffold(
          backgroundColor:
              const Color(0xFFFDFDFD),

          // ====================================================
          // APP BAR
          // ====================================================

          appBar: AppAppBar(
            title: AppStrings.categories,
            centerTitle: true,
          ),

          // ====================================================
          // BODY
          // ====================================================

          body: SafeArea(
            child:
                SingleChildScrollView(
              physics:
                  const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 18,
                  ),

                  // ============================================
                  // MAIN HEADING
                  // English / Bengali
                  // ============================================

                  Padding(
                    padding:
                        const EdgeInsets
                            .symmetric(
                      horizontal: 16,
                    ),
                    child: Text(
                      AppStrings
                          .shopByCategory,
                      style:
                          Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                fontSize:
                                    22,
                                fontWeight:
                                    FontWeight
                                        .w700,
                                color:
                                    const Color(
                                  0xFF212121,
                                ),
                              ),
                    ),
                  ),

                  const SizedBox(
                    height: 6,
                  ),

                  // ============================================
                  // SUB HEADING
                  // English / Bengali
                  // ============================================

                  Padding(
                    padding:
                        const EdgeInsets
                            .symmetric(
                      horizontal: 16,
                    ),
                    child: Text(
                      AppStrings
                          .exploreOurWideRangeOfProducts,
                      style:
                          Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                fontSize:
                                    14,
                                color:
                                    Colors
                                        .grey
                                        .shade600,
                              ),
                    ),
                  ),

                  const SizedBox(
                    height: 14,
                  ),

                  // ============================================
                  // MAIN CATEGORY
                  //
                  // Rice / Spices
                  // Always English
                  // ============================================

                  CategoryWidget(
                    names: _categories,
                    selectedIndex:
                        _selectedCategoryIndex,
                    onCategoryTap:
                        (categoryName) {
                      final int index =
                          _categories.indexOf(
                        categoryName,
                      );

                      if (index != -1) {
                        setState(() {
                          _selectedCategoryIndex =
                              index;
                        });
                      }

                      debugPrint(
                        'Selected Category: '
                        '$categoryName',
                      );
                    },
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  // ============================================
                  // SUB CATEGORY
                  //
                  // Jeera Kathi
                  // Basmati
                  // Gobindo Bhog
                  // Ratna
                  // Banskathi
                  // Minikit
                  //
                  // Always English
                  // ============================================

                  SubCategoryWidget(
                    selectedCategory:
                        _selectedCategory,
                    items:
                        _selectedSubCategories,
                    onItemTap:
                        (itemName) {
                      debugPrint(
                        'Selected Product Type: '
                        '$itemName',
                      );

                      _openProductList(
                        itemName,
                      );
                    },
                  ),

                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}