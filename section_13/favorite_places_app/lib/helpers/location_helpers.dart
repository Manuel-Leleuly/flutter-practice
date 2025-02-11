import 'package:favorite_places_app/helpers/google_map_helpers.dart';
import 'package:favorite_places_app/models/place.dart';
import 'package:location/location.dart';

Future<(Location, LocationData)> getLocationService() async {
  Location location = Location();
  LocationData locationData;

  // TODO: use try catch
  if (!(await _checkLocationPermission(location))) {
    throw Exception('Location permission is not granted');
  }

  locationData = await location.getLocation();

  return (location, locationData);
}

Future<bool> _checkLocationPermission(Location location) async {
  bool serviceEnabled;
  PermissionStatus permissionGranted;

  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      return false;
    }
  }

  permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return false;
    }
  }

  return true;
}

String getLocationImage(PlaceLocation? pickedLocation) {
  if (pickedLocation == null) return '';
  final lat = pickedLocation.latitude;
  final lng = pickedLocation.longitude;

  return getGoogleMapUri('/maps/api/staticmap', {
    'center': '$lat,$lng',
    'zoom': '16',
    'size': '600x300',
    'mapType': 'roadmap',
    'markers': 'color:red|label:A|$lat,$lng',
  }).toString();
}
