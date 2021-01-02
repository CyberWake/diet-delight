import 'dart:convert' as convert;
import 'dart:io';

import 'package:diet_delight/Models/registrationModel.dart';
import 'package:http/http.dart' as http;

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
      return true;
    } else if (response.statusCode == 400) {
      print(response.statusCode);
      return false;
    } else {
      print(response.statusCode);
      return false;
    }
  }
}
