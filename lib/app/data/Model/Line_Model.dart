class LineResponseModel {
  String code;
  List<Route> routes;

  LineResponseModel({
    required this.code,
    required this.routes,
  });

  factory LineResponseModel.fromJson(Map<String, dynamic> json) => LineResponseModel(
    code: json["code"],
    routes: List<Route>.from(json["routes"].map((x) => Route.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "routes": List<dynamic>.from(routes.map((x) => x.toJson())),
  };
}

class Route {
  Geometry geometry;

  Route({
    required this.geometry,
  });

  factory Route.fromJson(Map<String, dynamic> json) => Route(
    geometry: Geometry.fromJson(json["geometry"]),
  );

  Map<String, dynamic> toJson() => {
    "geometry": geometry.toJson(),
  };
}

class Geometry {
  List<List<double>> coordinates;

  Geometry({
    required this.coordinates,
  });

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
    coordinates: List<List<double>>.from(json["coordinates"].map((x) => List<double>.from(x.map((x) => x?.toDouble())))),
  );

  Map<String, dynamic> toJson() => {
    "coordinates": List<dynamic>.from(coordinates.map((x) => List<dynamic>.from(x.map((x) => x)))),
  };
}
