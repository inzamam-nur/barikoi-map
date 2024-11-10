import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

import '../../utils/dialogHelper.dart';

class HomeController extends GetxController {
  var currentPos = Rx<LatLng>(const LatLng(23.835677, 90.380325));
  static const styleId = 'osm-liberty'; // barikoi map style id
  static var apiKey = dotenv.get('API_KEY');// barikoi API key
  static  String mapUrl = 'https://map.barikoi.com/styles/$styleId/style.json?key=$apiKey';
  MaplibreMapController? mController;
  RxBool showPanel=false.obs;
  var placeInfo=''.obs;
  CameraPosition initialPosition= const CameraPosition(target: LatLng(23.835677, 90.380325), zoom: 12);   @override
  void onInit() {
    super.onInit();
    print("HomeController initialized");
    getCurrentLocation();
    getCurrentPosition();
  }
  Future<void> getCurrentPosition() async {
    print('clicked');
    await getCurrentLocation().then((position) async {
      LatLng pos = LatLng(position.latitude, position.longitude);
      currentPos.value=pos;
      print('-------------${currentPos.value}');
    });
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
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }





}
