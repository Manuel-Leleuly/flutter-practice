import 'package:favorite_places_app/constants/env.dart';

Uri getGoogleMapUri(String path, Map<String, String> queryParams) {
  final uri = Uri.parse('${Env.googleMapsBaseUrl}$path');
  final fullUri = uri.replace(
    queryParameters: {
      'key': Env.googleMapsApiKey,
      ...queryParams,
    },
  );
  String parsedUrl = fullUri.toString();

  if (parsedUrl[parsedUrl.length - 1] == '?') {
    parsedUrl = parsedUrl.substring(0, parsedUrl.length - 1);
  }

  return Uri.parse(parsedUrl);
}
