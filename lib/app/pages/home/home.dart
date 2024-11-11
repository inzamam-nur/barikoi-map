import 'dart:math';
import 'package:barikoi/app/utils/app_colors.dart';
import 'package:barikoi/app/utils/dialogHelper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:barikoi/app/pages/home/home_controller.dart';
import 'package:shimmer/shimmer.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MaplibreMap(
          initialCameraPosition: controller.initialPosition, // set map initial location
          onMapCreated: (MaplibreMapController mapController) {
            controller.mController = mapController;
          },
          onMapClick: (Point<double> point, LatLng latLng) async {
            print("Clicked at: Latitude: ${latLng.latitude}, Longitude: ${latLng.longitude}");
            controller.clickedPos.value = LatLng(latLng.latitude, latLng.longitude);
            controller.updateMarker(latLng);
            controller.showPanel.value=true;
            DialogHelper.onDefaultButtonSheet(bottomBar(),dialogHeight: 150);
            await controller.callReverseGeocodeApi(latLng.latitude, latLng.longitude);
          },
          onStyleLoadedCallback: () async {
            await controller.addImageFromAsset("custom-marker", "assets/marker.png");
            print("Image loaded successfully");
          },
          styleString:HomeController.mapUrl,
        ),
        ]
      ),
    );
  }
  Widget bottomBar() {
    return Obx(() {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.only(left: 10, right: 10, top: 40),
        height: 200,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: controller.placeInfo.value.isEmpty
                  ? Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 14,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      height: 14,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 150,
                      height: 14,
                      color: Colors.white,
                    ),
                  ],
                ),
              )
                  : Text(
                controller.placeInfo.value,
                overflow: TextOverflow.ellipsis,
                maxLines: 4,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            GestureDetector(
              onTap: () {
                controller.callLineApi();
                Get.back();
              },
              child: const Icon(Icons.directions, size: 50,color: AppColors.accentPrimary2,),
            ),
          ],
        ),
      );
    });
  }
}
