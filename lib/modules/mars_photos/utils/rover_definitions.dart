import 'package:flutter/material.dart';
import 'package:how_is_mars_doing/modules/mars_photos/models/rover_photos_model.dart';

class RoverDefinition {
  final String name;
  final List<String> cameras;

  const RoverDefinition({required this.name, required this.cameras});

  static List<RoverDefinition> getRoverDefinitions() {
    var rovers = [
      RoverDefinition(name: "Curiosity", cameras: [
        "FHAZ",
        "RHAZ",
        "MAST",
        "CHEMCAM",
        "MAHLI",
        "MARDI",
        "NAVCAM"
      ]),
      RoverDefinition(
          name: "Opportunity",
          cameras: ["FHAZ", "RHAZ", "NAVCAM", "PANCAM", "MINITES"]),
      RoverDefinition(
          name: "Spirit",
          cameras: ["FHAZ", "RHAZ", "NAVCAM", "PANCAM", "MINITES"])
    ];

    return rovers;
  }
}
