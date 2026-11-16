import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../app/theme/app_colors.dart';
import '../core/services/cart_service.dart';
import '../features/cart/presentation/pages/cart_page.dart';
import '../features/product/presentation/widgets/product_details_widget/product_repository.dart';
import 'new_product_details.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CartService.initialize();
  runApp(const ProviderScope(child: _ProductDetailsPreviewApp()));
}

class _ProductDetailsPreviewApp extends StatelessWidget {
  const _ProductDetailsPreviewApp();

  static final GoRouter _router = GoRouter(
    initialLocation: '/product-details-preview',
    routes: [
      GoRoute(
        path: '/product-details-preview',
        builder: (context, state) => NewProductDetailsPage(
          product: ProductRepository.allProducts.firstWhere(
            (product) => product.id == 'lalbaba-jeera-kathi',
          ),
        ),
      ),
      GoRoute(path: '/cart', builder: (context, state) => const CartPage()),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Product Details Preview',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
