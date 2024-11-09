// HomeController
import 'package:barikoi/app/pages/home/home.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../utils/dialogHelper.dart';

class HomeController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    print("HomeController initialized");
    getCurrentLocation();
  }
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        DialogHelper.onButtonPermissionSheet(
            Get.context!,
            Icons.location_on_sharp,
            'Location permissions are denied',
            'To get great service you need to provide this permission. You can always change permission setting',
                ()async{
              permission = await Geolocator.requestPermission();
              if(serviceEnabled|| permission == LocationPermission.deniedForever) Get.back();
            }
        );        /*return Future.error('Location permissions are denied');*/
      }
    }
    if (permission == LocationPermission.deniedForever) {
      DialogHelper.onButtonPermissionSheet(
          Get.context!,
          Icons.location_on_sharp,
          'Location Permission',
          'To get great service you need to provide this permission. You can always change permission setting',
              ()async{Geolocator.openAppSettings();/*.then((value)=>Get.back());*/});
/*      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');*/
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}
