// Application navigation configuration.
// Why: Define and manage all application routes in one centralized place.
import 'package:go_router/go_router.dart';
import 'package:lalbaba_online/features/address/presentation/page/address_list_page.dart';

import '../../features/address/presentation/page/address.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/cart/presentation/pages/cart_page.dart';
import '../../features/categories/presentation/pages/categories_page.dart';
import '../../features/checkout/presentation/pages/checkout_page.dart';
import '../../features/contact/presentation/pages/contact_us_screen.dart';
import '../../features/dashboard/pages/bottom_nav_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/account/presentation/page/account_widget.dart';
import '../../features/network/presentation/pages/no_internet_page.dart';
import '../../features/order/presentation/pages/order_details_page.dart';
import '../../features/order/presentation/pages/orders_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/update/presentation/pages/update_page.dart';
import '../../webView/lalbabaWebView.dart';
import 'route_guards.dart';
import 'route_names.dart';

final appRouter = GoRouter(
  initialLocation: RouteNames.splash,
  routes: <RouteBase>[
    GoRoute(
      path: RouteNames.web_splash,
      builder: (_, __) => const SplashScreen(),
    ),
    GoRoute(
      path: RouteNames.splash,
      builder: (context, state) {
        return const SplashPage();
      },
    ),

    GoRoute(
      path: RouteNames.noInternet,
      builder: (context, state) {
        return const NoInternetPage();
      },
    ),

    GoRoute(
      path: RouteNames.update,
      builder: (context, state) {
        return const UpdatePage();
      },
    ),
    GoRoute(
      path: RouteNames.login,
      builder: (context, state) {
        final redirectUrl = state.uri.queryParameters['redirect'];
        return LoginPage(redirectUrl: redirectUrl);
      },
    ),
    GoRoute(
      path: RouteNames.bottomnavigation,
      builder: (_, __) => const BottomNavigationPage(),
    ),
    GoRoute(path: RouteNames.home, builder: (_, __) => const HomePage()),
    // GoRoute(path: RouteNames.cart, builder: (_, __) => const CartPage()),
    GoRoute(
      path: RouteNames.categories,
      builder: (_, __) => const CategoriesPage(),
    ),
    GoRoute(path: RouteNames.account, builder: (_, __) => const AccountPage()),
    GoRoute(path: RouteNames.orders, builder: (_, __) => const MyOrdersPage()),

    // ==========================================================
    // CHECKOUT
    // ==========================================================
    GoRoute(
      path: RouteNames.cart,
      redirect: (context, state) async {
        final isAuthenticated = await RouteGuards.isAuthenticated();

        if (isAuthenticated) {
          return null;
        }

        return Uri(
          path: RouteNames.login,
          queryParameters: {'redirect': state.uri.toString()},
        ).toString();
      },
      builder: (context, state) {
        return const CartPage();
      },
    ),
    //Address
    // =====================
    GoRoute(
      path: RouteNames.address,
      builder: (_, __) => const AddressListPage(),
    ),
    GoRoute(
      path: RouteNames.contact,
      builder: (_, __) => const ContactUsScreen(),
    ),
    GoRoute(
      path: RouteNames.checkout,
      builder: (_, __) => const CheckoutPage(),
    ),
  ],
);
