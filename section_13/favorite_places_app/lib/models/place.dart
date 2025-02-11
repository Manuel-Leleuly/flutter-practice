import 'dart:io';

import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Place {
  final String id;
  final String title;
  final File image;
  final PlaceLocation location;

  Place({
    required this.title,
    required this.image,
    required this.location,
    String? id,
  }) : id = id ?? uuid.v4();

  factory Place.fromJson(Map<String, dynamic> jsonData, {bool fromDB = false}) {
    if (fromDB) {
      return Place(
        id: jsonData['id'],
        title: jsonData['title'],
        image: File(jsonData['image']),
        location: PlaceLocation(
          latitude: jsonData['lat'] as double,
          longitude: jsonData['lng'] as double,
          address: jsonData['address'],
        ),
      );
    }

    return Place(
      id: jsonData['id'],
      title: jsonData['title'],
      image: File(jsonData['image']),
      location: PlaceLocation(
        latitude: jsonData['location']['lat'] as double,
        longitude: jsonData['location']['lng'] as double,
        address: jsonData['location']['address'],
      ),
    );
  }

  Map<String, dynamic> toJson({bool toDB = false}) {
    if (toDB) {
      return {
        "id": id,
        "title": title,
        "image": image.path,
        "lat": location.latitude,
        "lng": location.longitude,
        "address": location.address,
      };
    }

    return {
      "id": id,
      "title": title,
      "image": image.path,
      "location": {
        "lat": location.latitude,
        "lng": location.longitude,
        "address": location.address,
      }
    };
  }
}

class PlaceLocation {
  final double latitude;
  final double longitude;
  final String address;

  const PlaceLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
  });
}
