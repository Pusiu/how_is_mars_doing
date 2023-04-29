import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:how_is_mars_doing/api_key.dart';
import 'package:how_is_mars_doing/modules/mars_photos/mars_photo_details.dart';
import 'package:how_is_mars_doing/modules/mars_photos/models/rover_photos_model.dart';
import 'package:how_is_mars_doing/modules/mars_photos/utils/rover_definitions.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class MarsPhotosView extends StatefulWidget {
  const MarsPhotosView({super.key});

  State<MarsPhotosView> createState() => _MarsPhotosViewState();
}

class _MarsPhotosViewState extends State<MarsPhotosView> {
  final List<RoverDefinition> rovers = RoverDefinition.getRoverDefinitions();

  final String ROVER_BASE_URL = "api.nasa.gov";
  //"https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?earth_date=2015-6-3&api_key=DEMO_KEY";

  final String ROVERS_ENDPOINT = "/mars-photos/api/v1/rovers";
  final String ROVER_PHOTOS_ENDPOINT = "photos";

  int _currentRoverIndex = 0;
  String currentSelectedCamera = "All";
  List<String> _currentRoverCameraOptions = [];
  DateTime? _pickedDate = DateTime(2015, 5, 28);
  TextEditingController _dateTextController = TextEditingController();

  Future<RoverPhotoCollection> fetchRoverPhoto() async {
    Map<String, String> params = <String, String>{};

    if (_pickedDate != null) {
      params.addAll(
          {"earth_date": DateFormat("yyyy-MM-dd").format(_pickedDate!)});
    }

    if (currentSelectedCamera != "All") {
      params.addAll({"camera": currentSelectedCamera.toLowerCase()});
    }
    params.addAll({"api_key": apiKey});

    var uri = Uri.https(
        ROVER_BASE_URL,
        '$ROVERS_ENDPOINT/${rovers[_currentRoverIndex].name.toLowerCase()}/$ROVER_PHOTOS_ENDPOINT',
        params);

    print("Sending request: $uri");
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return RoverPhotoCollection.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load photos');
    }
  }

  void getRoverPhotos() {
    futurePhotoCollection = fetchRoverPhoto();
  }

  late Future<RoverPhotoCollection> futurePhotoCollection;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRoverPhotos();
    _currentRoverCameraOptions = [...rovers[_currentRoverIndex].cameras];
    _currentRoverCameraOptions.insert(0, "All");
    _dateTextController.text = DateFormat("yyyy-MM-dd").format(_pickedDate!);
  }

  void setCurrentRover(int idx) {
    setState(() {
      _currentRoverIndex = idx;
      _currentRoverCameraOptions = [...rovers[_currentRoverIndex].cameras];
      _currentRoverCameraOptions.insert(0, "All");
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Current rover index is $_currentRoverIndex");

    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    const Text("Rover:"),
                    DropdownButton(
                        value: rovers[_currentRoverIndex].name,
                        onChanged: (value) {
                          setCurrentRover(rovers
                              .map((e) => e.name)
                              .toList()
                              .indexOf(value!));
                          getRoverPhotos();
                        },
                        items: rovers
                            .map((key) => DropdownMenuItem(
                                value: key.name, child: Text(key.name)))
                            .toList()),
                  ],
                ),
                Row(
                  children: [
                    const Text("Camera:"),
                    DropdownButton(
                      onChanged: (value) {
                        setState(() {
                          currentSelectedCamera = value!;
                          getRoverPhotos();
                        });
                      },
                      items: _currentRoverCameraOptions.map((e) {
                        return DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        );
                      }).toList(),
                      value: currentSelectedCamera,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Row(children: [
                        const Text("Date:"),
                        Expanded(
                          child: TextField(
                            controller: _dateTextController,
                            readOnly: true,
                            onTap: () async {
                              _pickedDate = await showDatePicker(
                                  initialDate:
                                      _pickedDate ?? DateTime(2015, 6, 3),
                                  context: context,
                                  firstDate: DateTime(1970),
                                  lastDate: DateTime(2030));

                              setState(() {
                                _dateTextController.text = _pickedDate != null
                                    ? DateFormat("yyyy-MM-dd")
                                        .format(_pickedDate!)
                                    : "";
                                getRoverPhotos();
                              });
                            },
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                _dateTextController.text = "";
                              });
                            },
                            icon: const Icon(Icons.cancel))
                      ]),
                    ),
                  ],
                )
              ],
            ),
          ),
          FutureBuilder<RoverPhotoCollection>(
            future: futurePhotoCollection,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                if (snapshot.data?.photos.length == 0) {
                  return const Expanded(
                      child:
                          Center(child: Text("No photos found on given date")));
                }
                return Expanded(
                  child: Scrollbar(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GridView.count(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        children: snapshot.data!.photos
                            .map((e) => GestureDetector(
                                  child: Image.network(
                                    e.imgSrc,
                                    loadingBuilder: (context, child,
                                            loadingProgress) =>
                                        loadingProgress == null
                                            ? child
                                            : Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                              ),
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(Icons.error),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MarsPhotoDetails(photo: e)));
                                  },
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Expanded(
                    child: Center(child: Text('${snapshot.error}')));
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ],
      ),
    );
  }
}
