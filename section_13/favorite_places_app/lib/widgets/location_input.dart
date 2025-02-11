import 'dart:convert';

import 'package:favorite_places_app/helpers/google_map_helpers.dart';
import 'package:favorite_places_app/helpers/location_helpers.dart';
import 'package:favorite_places_app/models/place.dart';
import 'package:favorite_places_app/screens/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class LocationInput extends StatefulWidget {
  final void Function(PlaceLocation location) onSelectLocation;

  const LocationInput({
    super.key,
    required this.onSelectLocation,
  });

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _pickedLocation;
  bool _isGettingLocation = false;

  Future<void> _savePlace(double latitude, double longitude) async {
    final url = getGoogleMapUri('/maps/api/geocode', {
      'latlng': '$latitude,$longitude',
    });
    final response = await http.get(url);
    final resData = json.decode(response.body);
    final address = resData['results'][0]['formatted_address'];

    setState(() {
      _pickedLocation = PlaceLocation(
        latitude: latitude,
        longitude: longitude,
        address: address,
      );
      _isGettingLocation = false;
    });

    widget.onSelectLocation(_pickedLocation!);
  }

  void _getCurrentLocation() async {
    setState(() {
      _isGettingLocation = true;
    });

    final (_, locationData) = await getLocationService();
    final lat = locationData.latitude;
    final lng = locationData.longitude;

    if (lat == null || lng == null) return;

    _savePlace(lat, lng);
  }

  void _selectOnMap() async {
    final pickedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (ctx) {
          return const MapScreen();
        },
      ),
    );

    if (pickedLocation == null) return;

    _savePlace(pickedLocation.latitude, pickedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
            ),
          ),
          child: PreviewContent(
            isGettingLocation: _isGettingLocation,
            locationImage: getLocationImage(_pickedLocation),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.location_on),
              onPressed: _getCurrentLocation,
              label: const Text('Get current location'),
            ),
            TextButton.icon(
              icon: const Icon(Icons.map),
              onPressed: _selectOnMap,
              label: const Text('Select on Map'),
            ),
          ],
        ),
      ],
    );
  }
}

// helper widgets
class PreviewContent extends StatelessWidget {
  final bool isGettingLocation;
  final String locationImage;

  const PreviewContent({
    super.key,
    required this.isGettingLocation,
    required this.locationImage,
  });

  @override
  Widget build(BuildContext context) {
    if (isGettingLocation) {
      return const CircularProgressIndicator();
    }

    if (locationImage != '') {
      return Image.network(
        locationImage,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    return Text(
      'No location chosen',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
    );
  }
}
