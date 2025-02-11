import 'package:chat_app/contants/env.dart';

Uri getFirebaseUri(String path, [Map<String, String> queryParams = const {}]) {
  final uri = Uri.parse('${Env.firebaseBaseUrl}$path');
  final fullUri = uri.replace(
    queryParameters: queryParams,
  );
  String parsedUrl = fullUri.toString();

  if (parsedUrl[parsedUrl.length - 1] == '?') {
    parsedUrl = parsedUrl.substring(0, parsedUrl.length - 1);
  }

  return Uri.parse(parsedUrl);
}
