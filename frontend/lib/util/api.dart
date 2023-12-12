/// This file contains the http wrapper class that is used to make http requests
/// to the backend.

import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'dart:io';

import '../backend_address.dart';

/// The http wrapper class that is used to make http requests to the backend.
class API {
  /// The http client.
  static final client = HttpClient()
    ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);

  static final accessToken = FirebaseAuth.instance.currentUser!.getIdToken();

  /// Get request to the API.
  static dynamic get({
    required String path,
    Map<String, dynamic>? queryParameters,
  }) async {
    var url = Uri.https(baseUrl, '/$path', queryParameters);
    var request = await client.getUrl(url);
    request.headers.add('authorization', "${await accessToken}");
    var response = await request.close();
    var responseBody = await response.transform(utf8.decoder).join();
    var responseJson = json.decode(responseBody);
    return responseJson;
  }

  /// Post request to the API.
  static Future<dynamic> post(
      {required String path, required Map<String, dynamic> body}) async {
    var url = Uri.https(baseUrl, '/$path');
    var request = await client.postUrl(url);
    request.headers.add('authorization', "${await accessToken}");
    request.headers.add('content-type', 'application/json');
    request.add(utf8.encode(json.encode(body)));
    var response = await request.close();
    var responseBody = await response.transform(utf8.decoder).join();
    return responseBody;
  }

  /// Put request to the API.
  static Future<dynamic> put(
      {required String path, required Map<String, dynamic> body}) async {
    var url = Uri.https(baseUrl, '/$path');
    var request = await client.putUrl(url);
    request.headers.add('authorization', "${await accessToken}");
    request.headers.add('content-type', 'application/json');
    request.add(utf8.encode(json.encode(body)));
    var response = await request.close();
    var responseBody = await response.transform(utf8.decoder).join();
    return responseBody;
  }

  /// Delete request to the API.
  static Future<dynamic> delete(
      {required String path, Map<String, dynamic>? queryParameters}) async {
    var url = Uri.https(baseUrl, '/$path', queryParameters);
    var request = await client.deleteUrl(url);
    request.headers.add('authorization', "${await accessToken}");
    var response = await request.close();
    var responseBody = await response.transform(utf8.decoder).join();
    return responseBody;
  }

  /// Patch request to the API.
  static Future<dynamic> patch(
      {required String path, required Map<String, dynamic> body}) async {
    var url = Uri.https(baseUrl, '/$path');
    var request = await client.patchUrl(url);
    request.headers.add('authorization', "${await accessToken}");
    request.headers.add('content-type', 'application/json');
    request.add(utf8.encode(json.encode(body)));
    var response = await request.close();
    var responseBody = await response.transform(utf8.decoder).join();
    return responseBody;
  }
}
