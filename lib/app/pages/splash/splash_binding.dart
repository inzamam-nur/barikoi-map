import 'package:barikoi/app/pages/splash/splash_controller.dart';
import 'package:get/get.dart';


class SplashScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(
          () => SplashController(),
    );
  }
}