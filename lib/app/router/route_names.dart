// Centralized route name constants.
// Why: Prevent hard-coded route strings from being repeated throughout the application.
class RouteNames {
  RouteNames._();
  static const web_splash = '/splashscreen';
  static const splash = '/splash';

  static const noInternet = '/no-internet';
  static const checkout = '/checkout';

  static const update = '/update';

  static const login = '/login';

  static const bottomnavigation = '/bottomnavigation';
  static const home = '/homepage';

  static const products = '/products';
  static const productList = '/products/list';
  static const productDetails = '/products/:id';

  static const categories = '/categories';
  static const cart = '/cart';

  static const orders = '/orders';

  static const orderDetails = '/orders/:id';
  static const contact = '/contact';
 

  static const profile = '/profile';
  static const account = '/account';
  static const address = '/address';
}
