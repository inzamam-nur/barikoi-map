class ReverseGeoCodingResponse {
  Place place;
  int status;

  ReverseGeoCodingResponse({
    required this.place,
    required this.status,
  });

  factory ReverseGeoCodingResponse.fromJson(Map<String, dynamic> json) => ReverseGeoCodingResponse(
    place: Place.fromJson(json["place"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "place": place.toJson(),
    "status": status,
  };
}

class Place {
  int id;
  double distanceWithinMeters;
  String address;
  String area;
  String city;
  String postCode;
  String addressBn;
  String areaBn;
  String cityBn;
  String country;
  String division;
  String district;
  dynamic subDistrict;
  dynamic pauroshova;
  dynamic union;
  String locationType;
  AddressComponents addressComponents;
  AreaComponents areaComponents;

  Place({
    required this.id,
    required this.distanceWithinMeters,
    required this.address,
    required this.area,
    required this.city,
    required this.postCode,
    required this.addressBn,
    required this.areaBn,
    required this.cityBn,
    required this.country,
    required this.division,
    required this.district,
    required this.subDistrict,
    required this.pauroshova,
    required this.union,
    required this.locationType,
    required this.addressComponents,
    required this.areaComponents,
  });

  factory Place.fromJson(Map<String, dynamic> json) => Place(
    id: json["id"],
    distanceWithinMeters: json["distance_within_meters"]?.toDouble(),
    address: json["address"],
    area: json["area"],
    city: json["city"],
    postCode: json["postCode"],
    addressBn: json["address_bn"],
    areaBn: json["area_bn"],
    cityBn: json["city_bn"],
    country: json["country"],
    division: json["division"],
    district: json["district"],
    subDistrict: json["sub_district"],
    pauroshova: json["pauroshova"],
    union: json["union"],
    locationType: json["location_type"],
    addressComponents: AddressComponents.fromJson(json["address_components"]),
    areaComponents: AreaComponents.fromJson(json["area_components"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "distance_within_meters": distanceWithinMeters,
    "address": address,
    "area": area,
    "city": city,
    "postCode": postCode,
    "address_bn": addressBn,
    "area_bn": areaBn,
    "city_bn": cityBn,
    "country": country,
    "division": division,
    "district": district,
    "sub_district": subDistrict,
    "pauroshova": pauroshova,
    "union": union,
    "location_type": locationType,
    "address_components": addressComponents.toJson(),
    "area_components": areaComponents.toJson(),
  };
}

class AddressComponents {
  dynamic placeName;
  dynamic house;
  dynamic road;

  AddressComponents({
    required this.placeName,
    required this.house,
    required this.road,
  });

  factory AddressComponents.fromJson(Map<String, dynamic> json) => AddressComponents(
    placeName: json["place_name"],
    house: json["house"],
    road: json["road"],
  );

  Map<String, dynamic> toJson() => {
    "place_name": placeName,
    "house": house,
    "road": road,
  };
}

class AreaComponents {
  String area;
  dynamic subArea;

  AreaComponents({
    required this.area,
    required this.subArea,
  });

  factory AreaComponents.fromJson(Map<String, dynamic> json) => AreaComponents(
    area: json["area"],
    subArea: json["sub_area"],
  );

  Map<String, dynamic> toJson() => {
    "area": area,
    "sub_area": subArea,
  };
}
