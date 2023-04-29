class RoverPhotoCollection {
  List<RoverPhoto> photos;

  RoverPhotoCollection({
    required this.photos,
  });

  factory RoverPhotoCollection.fromJson(Map<String, dynamic> json) =>
      RoverPhotoCollection(
        photos: List<RoverPhoto>.from(
            json["photos"].map((x) => RoverPhoto.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "photos": List<dynamic>.from(photos.map((x) => x.toJson())),
      };
}

class RoverPhoto {
  int id;
  int sol;
  RoverCamera camera;
  String imgSrc;
  DateTime earthDate;
  Rover rover;

  RoverPhoto({
    required this.id,
    required this.sol,
    required this.camera,
    required this.imgSrc,
    required this.earthDate,
    required this.rover,
  });

  factory RoverPhoto.fromJson(Map<String, dynamic> json) => RoverPhoto(
        id: json["id"],
        sol: json["sol"],
        camera: RoverCamera.fromJson(json["camera"]),
        imgSrc: json["img_src"],
        earthDate: DateTime.parse(json["earth_date"]),
        rover: Rover.fromJson(json["rover"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sol": sol,
        "camera": camera.toJson(),
        "img_src": imgSrc,
        "earth_date":
            "${earthDate.year.toString().padLeft(4, '0')}-${earthDate.month.toString().padLeft(2, '0')}-${earthDate.day.toString().padLeft(2, '0')}",
        "rover": rover.toJson(),
      };
}

class RoverCamera {
  int id;
  String name;
  int roverId;
  String fullName;

  RoverCamera({
    required this.id,
    required this.name,
    required this.roverId,
    required this.fullName,
  });

  factory RoverCamera.fromJson(Map<String, dynamic> json) => RoverCamera(
        id: json["id"],
        name: json["name"],
        roverId: json["rover_id"],
        fullName: json["full_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "rover_id": roverId,
        "full_name": fullName,
      };
}

class Rover {
  int id;
  String name;
  DateTime landingDate;
  DateTime launchDate;
  String status;

  Rover({
    required this.id,
    required this.name,
    required this.landingDate,
    required this.launchDate,
    required this.status,
  });

  factory Rover.fromJson(Map<String, dynamic> json) => Rover(
        id: json["id"],
        name: json["name"],
        landingDate: DateTime.parse(json["landing_date"]),
        launchDate: DateTime.parse(json["launch_date"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "landing_date":
            "${landingDate.year.toString().padLeft(4, '0')}-${landingDate.month.toString().padLeft(2, '0')}-${landingDate.day.toString().padLeft(2, '0')}",
        "launch_date":
            "${launchDate.year.toString().padLeft(4, '0')}-${launchDate.month.toString().padLeft(2, '0')}-${launchDate.day.toString().padLeft(2, '0')}",
        "status": status,
      };
}
