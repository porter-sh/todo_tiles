/// This file contains the http wrapper class that is used to make http requests
/// to the backend.

import 'dart:convert';
import 'dart:io';

import '../backend_address.dart';

/// The http wrapper class that is used to make http requests to the backend.
class API {
  /// The http client.
  static final client = HttpClient()
    ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);

  /// Get request to the API.
  static Future<dynamic> get({required String path, String? authToken}) async {
    var url = Uri.https(baseUrl, '/$path');
    var request = await client.getUrl(url);
    request.headers.add('authorization', "$authToken");
    var response = await request.close();
    var responseBody = await response.transform(utf8.decoder).join();
    return responseBody;
  }
}
