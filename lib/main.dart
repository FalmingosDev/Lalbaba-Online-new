// PURPOSE:
// Application entry point.
// Use this file to initialize Flutter and start the application.
// Keep app-wide startup logic here, not feature-specific business logic.

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:lalbaba_online/app/router/app_router.dart';

// import 'features/account/presentation/widgets/languange_constant.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(const ProviderScope(child: LalbabaApp()));
// }


// class LalbabaApp extends StatelessWidget {
//   const LalbabaApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ScreenUtilInit(
//       designSize: const Size(375, 812),
//       minTextAdapt: true,
//       splitScreenMode: true,
//       builder: (context, child) {
//         return MaterialApp.router(
//           title: 'LALBABA ONLINE',
//           debugShowCheckedModeBanner: false,
//           theme: ThemeData(useMaterial3: true),
//           // home:
//           routerConfig: appRouter,
//           // RouteNames.login,
//           //LalBabaApp(),
//           //const SplashScreen(),
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:lalbaba_online/app/router/app_router.dart';

import 'core/services/cart_service.dart';

// ==========================================================
// ADD THIS IMPORT

// ==========================================================

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ========================================================
  // ADD THIS
  
  // ========================================================
  await CartService.initialize();

  runApp(
    const ProviderScope(
      child: LalbabaApp(),
    ),
  );
}

class LalbabaApp extends StatelessWidget {
  const LalbabaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'LALBABA ONLINE',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
          ),
          routerConfig: appRouter,
        );
      },
    );
  }
}