
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:barikoi/app/pages/home/home_controller.dart';

import '../../data/Model/Reverse_Gecoding_Response_Model.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  Symbol? markerSymbol;

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
            controller.currentPos.value = LatLng(latLng.latitude, latLng.longitude);
            _updateMarker(latLng);
            controller.showPanel.value=true;
            await _callReverseGeocodeApi(latLng.latitude, latLng.longitude);

          },
          onStyleLoadedCallback: () async {
            await addImageFromAsset("custom-marker", "assets/marker.png");
            print("Image loaded successfully");
            await _addMarker(controller.currentPos.value);
          },
          styleString:HomeController.mapUrl, // barikoi map style URL
        ),
      Obx((){
       return controller.showPanel.value?
           Positioned(
               bottom: 0,
               left: 0,
               right: 0,
               child: Container(
                 height: 150,
                 margin: const EdgeInsets.all(10),
                 padding: const EdgeInsets.all(10),
                 decoration: BoxDecoration(
                     color: Colors.white,
                     borderRadius: BorderRadius.circular(8),
                     boxShadow: [
                       BoxShadow(
                         color: Colors.black.withOpacity(0.2),
                         spreadRadius: 4,
                         blurRadius: 10,
                         offset: const Offset(0, 3),
                       ),
                     ]
                 ),
                 child:  Center(
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.center,
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Text(controller.placeInfo.value ,
                       ),
                       const Icon(Icons.directions,size: 50,)
                     ],
                   ),
                 ),
               )):const SizedBox();
      })
        ]
      ),
    );
  }

  Future<void> _addMarker(LatLng position) async {
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
    markerSymbol = await controller.mController?.addSymbol(symbolOptions);
  }

  // Update the marker position when the map is clicked
  void _updateMarker(LatLng newPosition) {
    if (markerSymbol != null) {
      SymbolOptions updatedSymbolOptions = SymbolOptions(
        geometry: newPosition, // New position for the symbol
      );
      controller.mController?.updateSymbol(markerSymbol!, updatedSymbolOptions); // Update the symbol on the map
    }
  }

  // Adds an image from the asset to the map
  Future<void> addImageFromAsset(String name, String assetName) async {
    try {
      final ByteData bytes = await rootBundle.load(assetName);
      final Uint8List list = bytes.buffer.asUint8List();
      await controller.mController?.addImage(name, list);
    } catch (e) {
      print("Error loading image: $e");
    }
  }

  // Adds an image from a URL to the map (not used here but can be useful)
  Future<void> addImageFromUrl(String name, Uri uri) async {
    var response = await http.get(uri);
    return controller.mController!.addImage(name, response.bodyBytes);
  }

  Future<void> _callReverseGeocodeApi(double latitude, double longitude) async {
    var apiKey = HomeController.apiKey; // Use the API key from the controller
    final url = Uri.parse(
      'https://barikoi.xyz/v2/api/search/reverse/geocode?api_key=$apiKey&longitude=$longitude&latitude=$latitude&district=true&post_code=true&country=true&sub_district=true&union=true&pauroshova=true&location_type=true&division=true&address=true&area=true&bangla=true',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Parse the data into a model
        ReverseGeoCodingResponse geoResponse = ReverseGeoCodingResponse.fromJson(data);

        // Display the address or any other information in the UI
        print("Reverse geocoding result: ${geoResponse.place.address}");

        // Update the controller or state with the parsed data
        controller.showPanel.value = true;
        controller.placeInfo.value = geoResponse.place.address;  // Bind to the UI

      } else {
        // Handle error response
        print("Failed to load geocoding data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error during API call: $e");
    }
  }
}
