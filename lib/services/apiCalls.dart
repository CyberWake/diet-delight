import 'dart:convert' as convert;
import 'dart:io';

import 'package:diet_delight/Models/loginModel.dart';
import 'package:diet_delight/Models/registrationModel.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:oauth2/oauth2.dart' as oauth2;

final storage = FlutterSecureStorage();

class Api {
  String token;

  Api({this.token});

  Future<bool> register(RegModel registerData) async {
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json", // or whatever
      HttpHeaders.authorizationHeader: "Bearer $token",
    };
    String body = convert.jsonEncode(registerData.toMap());
    print(body);
    final response = await http.post(
        'http://dietdelight.enigmaty.com/api/v1/register',
        headers: headers,
        body: body);
    if (response.statusCode == 200) {
      print('Success');
      print(response.body);
      return true;
    } else if (response.statusCode == 400) {
      print(response.statusCode);
      return false;
    } else {
      print(response.statusCode);
      return false;
    }
  }

  Future<bool> login(LogModel loginData) async {
    try {
      final authorizationEndpoint =
          Uri.parse('http://example.com/oauth2/authorization');
      final username = loginData.mobile ?? loginData.email;
      final password = loginData.password;

      final identifier = 'my client identifier';
      final secret = '3X7ar2wWTrdzAzRDl2rge1pGL5cFWLSQq7sVkMRV';

      var client = await oauth2.resourceOwnerPasswordGrant(
          authorizationEndpoint, username, password,
          identifier: identifier, secret: secret);

      var result =
          await client.read('http://example.com/protected-resources.txt');

      File('~/.DietDelight/credentials.json')
          .writeAsString(client.credentials.toJson());
      return true;
    } on Exception catch (e) {
      return false;
    }
  }

  getMealPlan() async {
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json", // or whatever
      HttpHeaders.authorizationHeader: "Bearer $token",
    };
    final response = await http.post(
        'http://dietdelight.enigmaty.com//api/v1/meal-plans',
        headers: headers);
    if (response.statusCode == 200) {}
  }
}
