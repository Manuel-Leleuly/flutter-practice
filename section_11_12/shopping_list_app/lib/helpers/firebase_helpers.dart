import 'dart:io';

import 'package:http/http.dart';
import 'package:shopping_list_app/constants/env.dart';

Uri getFirebaseUrl(String firebaseFileName) {
  return Uri.https(
    Env.firebaseBaseUrl,
    '$firebaseFileName.json',
  );
}

bool isFetchError(Response response) {
  return response.statusCode >= HttpStatus.badRequest ||
      response.body == 'null';
}
