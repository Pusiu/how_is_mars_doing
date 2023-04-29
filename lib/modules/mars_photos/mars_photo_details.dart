import 'package:flutter/material.dart';
import 'package:how_is_mars_doing/modules/mars_photos/models/rover_photos_model.dart';
import 'package:http/retry.dart';
import 'package:intl/intl.dart';

class MarsPhotoDetails extends StatefulWidget {
  const MarsPhotoDetails({super.key, required this.photo});

  final RoverPhoto photo;
  @override
  State<StatefulWidget> createState() => _MarsPhotoDetailsState();
}

class _MarsPhotoDetailsState extends State<MarsPhotoDetails> {
  Map<String, String> _metadata = <String, String>{};

  final TextStyle style = TextStyle(fontSize: 24);

  final String dateFormat = "yyyy-MM-dd";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _metadata.addAll({
      "ID:": widget.photo.id.toString(),
      "Sol:": widget.photo.sol.toString(),
      "Camera:":
          '${widget.photo.camera.fullName} (${widget.photo.camera.name})',
      "Earth date:": DateFormat(dateFormat).format(widget.photo.earthDate),
      "Rover name:": widget.photo.rover.name,
      "Rover launch date:":
          DateFormat(dateFormat).format(widget.photo.rover.launchDate),
      "Rover landing date:":
          DateFormat(dateFormat).format(widget.photo.rover.landingDate),
      "Rover status:": widget.photo.rover.status
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Expanded(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  children: [
                    Flexible(child: Image.network(widget.photo.imgSrc)),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: _metadata.length,
                  separatorBuilder: (context, index) => Divider(),
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${_metadata.keys.elementAt(index)}${_metadata.values.elementAt(index)}',
                      style: style,
                    ),
                  ),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
