import 'dart:io';

import 'package:favorite_places_app/helpers/db_helpers.dart';
import 'package:favorite_places_app/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class UserPlacesNotifier extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super(const []);

  Future<void> loadPlaces() async {
    final db = await getDatabase();
    final data = await db.query('user_places');
    state = data.map((row) => Place.fromJson(row, fromDB: true)).toList();
  }

  Future<void> addPlace(
    String title,
    File image,
    PlaceLocation location,
  ) async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(image.path);
    final copiedImage = await image.copy('${appDir.path}/$fileName');

    final newPlace = Place(
      title: title,
      image: copiedImage,
      location: location,
    );

    final db = await getDatabase();
    db.insert('user_places', newPlace.toJson(toDB: true));

    state = [newPlace, ...state];
  }
}

final userPlacesProvider =
    StateNotifierProvider<UserPlacesNotifier, List<Place>>(
  (ref) {
    return UserPlacesNotifier();
  },
);
