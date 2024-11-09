import 'package:get/get.dart';



class SplashController extends GetxController {

  var copyright='Developed and Designed by Inzamam Nur'.obs;

  @override
  void onReady() {
    super.onReady();
    _initialScreen();
  }
    _initialScreen() async {
      await Future.delayed(const Duration(seconds: 3));
      Get.offAllNamed('/home');
    }


}
