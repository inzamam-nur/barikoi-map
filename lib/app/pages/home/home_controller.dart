import 'dart:convert';
import 'package:barikoi/app/data/Model/Line_Model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:http/http.dart' as http;
import '../../data/Model/Reverse_Gecoding_Response_Model.dart';
import '../../utils/dialogHelper.dart';

class HomeController extends GetxController {
  Symbol? markerSymbol;
  Line? currentLine;
  static var currentPos = Rx<LatLng>(const LatLng(23.835677, 90.380325));
  var clickedPos = Rx<LatLng>(const LatLng(23.835677, 90.380325));
  static const styleId = 'osm-liberty';
  static var apiKey = dotenv.get('API_KEY');
  static  String mapUrl = 'https://map.barikoi.com/styles/$styleId/style.json?key=$apiKey';
  MaplibreMapController? mController;
  RxBool showPanel=false.obs;
  RxBool showInfo=false.obs;
  RxBool cleanData=false.obs;
  var placeInfo=''.obs;
  RxList<List<double>> rxCoordinates = RxList.empty();


  CameraPosition initialPosition=  CameraPosition(target: LatLng(currentPos.value.latitude, currentPos.value.longitude), zoom: 12);
  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
    getCurrentPosition();
  }
  void getCurrentPosition() async {
    await getCurrentLocation().then((position) async {
      LatLng pos = LatLng(position.latitude, position.longitude);
      currentPos.value=pos;
      addMarker(pos);
      mController?.moveCamera(CameraUpdate.newLatLng(pos));
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

  Future<void> addMarker(LatLng position) async {
    SymbolOptions symbolOptions = SymbolOptions(
      geometry: position,
      iconImage: 'custom-marker',
      iconSize: .5,
      iconAnchor: 'bottom',
      textSize: 12.5,
      textOffset: Offset(0, 1.2),
      textAnchor: 'bottom',
      textColor: '#000000',
      textHaloBlur: 1,
      textHaloColor: '#ffffff',
      textHaloWidth: 0.8,
    );
    markerSymbol = await mController?.addSymbol(symbolOptions);
  }
  Future<void> lineOnMap() async {
    if (currentLine != null) {
      mController?.removeLine(currentLine!);
      currentLine = null;
    }
    if (rxCoordinates.isNotEmpty) {
      List<LatLng> lineGeometry = rxCoordinates
          .map((coOrdinates) => LatLng(coOrdinates[1], coOrdinates[0]))
          .toList();
      currentLine = await mController?.addLine(
        LineOptions(
          geometry: lineGeometry,
          lineColor: "#0088FF",
          lineWidth: 8.0,
        ),
      );
    } else {
      print("No coordinates available to draw the line.");
    }
  }
  void cleanALl(){
    addMarker(currentPos.value);
    mController?.moveCamera(CameraUpdate.newLatLng(HomeController.currentPos.value));
    updateMarker(HomeController.currentPos.value);
    if (currentLine != null) {
    mController?.removeLine(currentLine!);
    currentLine = null;
    }
    cleanData.value=false;
  }
  void updateMarker(LatLng newPosition) {
    if (markerSymbol != null) {
      SymbolOptions updatedSymbolOptions = SymbolOptions(
        geometry: newPosition,
      );
      mController?.updateSymbol(markerSymbol!, updatedSymbolOptions);
    }
  }
  Future<void> addImageFromAsset(String name, String assetName) async {
    try {
      final ByteData bytes = await rootBundle.load(assetName);
      final Uint8List list = bytes.buffer.asUint8List();
      await mController?.addImage(name, list);
    } catch (e) {
      print("Error loading image: $e");
    }
  }

  Future<void> addImageFromUrl(String name, Uri uri) async {
    var response = await http.get(uri);
    return mController!.addImage(name, response.bodyBytes);
  }
  Future<void> callReverseGeocodeApi(double latitude, double longitude) async {
    var apiKey = HomeController.apiKey;
    final url = Uri.parse(
      'https://barikoi.xyz/v2/api/search/reverse/geocode?api_key=$apiKey&longitude=$longitude&latitude=$latitude&district=true&post_code=true&country=true&sub_district=true&union=true&pauroshova=true&location_type=true&division=true&address=true&area=true&bangla=true',
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        ReverseGeoCodingResponse geoResponse = ReverseGeoCodingResponse.fromJson(data);
        print("Reverse geocoding result: ${geoResponse.place.address}");
        showPanel.value = true;
        placeInfo.value = geoResponse.place.address;
        showInfo.value=false;// Bind to the UI
      }else if(response.statusCode ==429){
        DialogHelper.showErrorDialog('Check Your APi Limit from BariKOi');
        print(429);
      }
      else {
        print("Failed to load geocoding data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error during API call: $e");
    }
  }
  Future<void> callLineApi() async {
    var apiKey = HomeController.apiKey;
    final url = Uri.parse(
        'https://barikoi.xyz/v2/api/route/${currentPos.value.longitude},${currentPos.value.latitude};${clickedPos.value.longitude},${clickedPos.value.latitude}?api_key=$apiKey&geometries=geojson'
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        LineResponseModel lineResponse = LineResponseModel.fromJson(data);
        rxCoordinates.assignAll(
          lineResponse.routes
              .expand((route) => route.geometry.coordinates)
              .toList(),
        );
        lineOnMap();
      }else if(response.statusCode ==429){
        DialogHelper.showErrorDialog('Check Your APi Limit from BariKOi');
      }
      else {
        // Handle error response
        print("Failed to load geocoding data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error during API call: $e");
    }
  }
}
