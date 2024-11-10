import 'package:barikoi/app/pages/home/home.dart';
import 'package:barikoi/app/pages/home/home_bindings.dart';
import 'package:barikoi/app/pages/splash/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

import 'app/pages/splash/splash_binding.dart';

Future<void> main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Bari Koi Map',
      debugShowCheckedModeBanner: false,
      initialRoute: initRoute,
      getPages: routeList,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
  static const initRoute = "/splashScreen";
  static final  routeList = [
    GetPage(
      name: '/splashScreen',
      page: () => const SplashScreenView(),
      binding: SplashScreenBinding(),
    ),
    GetPage(
      name: '/home',
      page: () =>  HomeView(),
      binding: HomeBindings(),
    ),
  ];
}




