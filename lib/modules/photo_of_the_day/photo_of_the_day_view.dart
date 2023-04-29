import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:how_is_mars_doing/api_key.dart';
import 'package:how_is_mars_doing/modules/photo_of_the_day/models/photo_of_the_day_model.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class PhotoOfTheDayView extends StatefulWidget {
  const PhotoOfTheDayView({super.key});

  @override
  State<StatefulWidget> createState() => _PhotoOfTheDayViewState();
}

class _PhotoOfTheDayViewState extends State<PhotoOfTheDayView> {
  Future<PhotoOfTheDay> fetchPOTD() async {
    var uri = Uri.https(
        "api.nasa.gov", "/planetary/apod", <String, String>{"api_key": apiKey});

    print("Requesting $uri");
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return PhotoOfTheDay.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Cannot load Photo Of The Day");
    }
  }

  late Future<PhotoOfTheDay> potd;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    potd = fetchPOTD();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(children: [
        FutureBuilder<PhotoOfTheDay>(
          future: potd,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Expanded(
                child: Column(
                  children: [
                    Image.network(snapshot.data!.url),
                    Text(
                      snapshot.data!.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24),
                    ),
                    Text(
                      DateFormat("yyyy-MM-dd").format(snapshot.data!.date),
                      textAlign: TextAlign.center,
                    ),
                    Expanded(
                      child: Scrollbar(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: ListView(
                            clipBehavior: Clip.antiAlias,
                            children: [
                              Text(
                                snapshot.data!.explanation,
                                style: TextStyle(fontSize: 18, height: 1.75),
                                textAlign: TextAlign.justify,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return const Text("Failed to load POTD");
            }

            return const CircularProgressIndicator();
          },
        )
      ]),
    );
  }
}
