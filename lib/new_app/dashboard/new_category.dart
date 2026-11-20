import 'package:flutter/material.dart';
import 'package:lalbaba_online/new_app/constant/constantappbar.dart';
import 'package:lalbaba_online/new_app/constant/constantcolour.dart';
import 'package:lalbaba_online/new_app/constant/new_constant_text_styles.dart';
import 'package:lalbaba_online/new_app/product/productlistscreen.dart';

class NewCategoryPage extends StatefulWidget {
  const NewCategoryPage({super.key});

  @override
  State<NewCategoryPage> createState() => _NewCategoryPageState();
}

class _NewCategoryPageState extends State<NewCategoryPage> {
  bool _riceSelected = true;
  static const _riceVarieties = [
    'Jeera Kathi',
    'Basmati',
    'Gobindo Bhog',
    'Ratna',
    'Banskathi',
    'Minikit',
  ];

  void _openCategory(String category) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            ProductListscreen(pageTitle: category, categoryFilter: category),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HomeColors.background,
      appBar: const CommonAppBar(
        automaticallyImplyLeading: false,
        showBackButton: false,
        title: 'Categories',
        centerTitle: true,
        backgroundColor: HomeColors.secondary,
        titleColor: HomeColors.white,
        iconColor: HomeColors.white,
        titleFontSize: HomeTextStyles.sizeTitle,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Shop by Category',
                  style: HomeTextStyles.largePrice.copyWith(
                    color: HomeColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Explore our wide range of products',
                  style: HomeTextStyles.body.copyWith(
                    color: HomeColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: HomeColors.surface,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _tab('Rice', true),
                const SizedBox(width: 12),
                _tab('Spices', false),
              ],
            ),
          ),
          Expanded(child: _riceSelected ? _riceBody() : _emptyBody()),
        ],
      ),
    );
  }

  Widget _tab(String label, bool rice) {
    final selected = rice == _riceSelected;
    return Material(
      color: HomeColors.surface,
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: () => setState(() => _riceSelected = rice),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 12),
          decoration: BoxDecoration(
            color: selected ? HomeColors.secondary : HomeColors.surface,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: selected ? HomeColors.secondary : HomeColors.border,
            ),
            boxShadow: [
              BoxShadow(
                color: selected
                    ? HomeColors.secondary.withValues(alpha: .22)
                    : HomeColors.black.withValues(alpha: .035),
                blurRadius: selected ? 12 : 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            label,
            style: HomeTextStyles.bodyEmphasis.copyWith(
              fontWeight: HomeTextStyles.bold,
              color: selected ? HomeColors.white : HomeColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _riceBody() => ListView(
    padding: const EdgeInsets.fromLTRB(16, 26, 16, 24),
    children: [
      Row(
        children: [
          Container(
            width: 4,
            height: 23,
            decoration: BoxDecoration(
              color: HomeColors.secondary,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'Rice Varient',
            style: HomeTextStyles.sectionTitle.copyWith(
              color: HomeColors.textPrimary,
            ),
          ),
        ],
      ),
      const SizedBox(height: 10),
      Padding(
        padding: const EdgeInsets.only(left: 14),
        child: Text(
          'Choose your preferred variety',
          style: HomeTextStyles.body.copyWith(color: HomeColors.textSecondary),
        ),
      ),
      const SizedBox(height: 20),
      GridView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          mainAxisExtent: 64,
        ),
        itemCount: _riceVarieties.length,
        itemBuilder: (_, index) => _categoryCard(_riceVarieties[index]),
      ),
    ],
  );

  Widget _categoryCard(String name) => Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: HomeColors.black.withValues(alpha: .035),
          blurRadius: 5,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Material(
      color: HomeColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: HomeColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _openCategory(name),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: HomeColors.secondaryLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.rice_bowl_outlined,
                  color: HomeColors.secondary,
                  size: 21,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: HomeTextStyles.bodyEmphasis.copyWith(
                    color: HomeColors.textPrimary,
                    fontWeight: HomeTextStyles.bold,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                size: 19,
                color: HomeColors.textHint,
              ),
            ],
          ),
        ),
      ),
    ),
  );

  Widget _emptyBody() => ListView(
    padding: const EdgeInsets.fromLTRB(16, 54, 16, 24),
    children: [
      Center(
        child: Container(
          width: 64,
          height: 64,
          decoration: const BoxDecoration(
            color: HomeColors.secondaryLight,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.inventory_2_outlined,
            color: HomeColors.secondary,
            size: 30,
          ),
        ),
      ),
      const SizedBox(height: 14),
      Text(
        'No products available',
        textAlign: TextAlign.center,
        style: HomeTextStyles.sectionTitle.copyWith(
          color: HomeColors.textPrimary,
        ),
      ),
    ],
  );
}
