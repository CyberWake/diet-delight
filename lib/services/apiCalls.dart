import 'dart:convert' as convert;
import 'dart:io';

import 'package:diet_delight/Models/consultationModel.dart';
import 'package:diet_delight/Models/loginModel.dart';
import 'package:diet_delight/Models/registrationModel.dart';
import 'package:http/http.dart' as http;
import 'package:oauth2/oauth2.dart' as oauth2;

class Api {
  static var client;
  Api._privateConstructor();

  static final Api instance = Api._privateConstructor();

  Future<bool> register(RegModel registerData) async {
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
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
      LogModel loginDetails =
          LogModel(email: registerData.email, password: registerData.password);
      bool result = await login(loginDetails);
      return result;
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
      print("control in login function");
      final authorizationEndpoint =
          Uri.parse('http://dietdelight.enigmaty.com/oauth/token');
      final username = loginData.mobile ?? loginData.email;
      final password = loginData.password;
      print('is before client initialisation');
      final identifier = '2';
      final secret = '3X7ar2wWTrdzAzRDl2rge1pGL5cFWLSQq7sVkMRV';

      client = await oauth2.resourceOwnerPasswordGrant(
        authorizationEndpoint,
        username,
        password,
        identifier: identifier,
        secret: secret,
      );
      print('client initialised');
      /*var result = await client.read(
          'http://dietdelight.enigmaty.com/api/v1/questions?pageSize=20&sortOrder=desc');
      print(convert.jsonDecode(result));*/
      /*File('~/.DietDelight/credentials.json')
          .writeAsString(client.credentials.toJson());*/
      return true;
    } on Exception catch (e) {
      print(e.toString());
      return false;
    }
  }

  getConsultationPackages() async {
    //print(client.toString());
    print('called');
    final String result = await client.read(
        'http://dietdelight.enigmaty.com/api/v1/consultation-packages?pageSize=20&sortOrder=desc');
    if (result.isNotEmpty) {
      var body = convert.jsonDecode(result);
      print('body: ${body['data']}');
      List<ConsultationModel> items = List();
      List data = body['data'];
      data.forEach((element) {
        ConsultationModel item = ConsultationModel.fromMap(element);
        items.add(item);
      });
      print(items.length);
      print('data fetched');
      return items;
    } else {
      return [];
    }
  }

  getQuestions() async {
    print('called2');
    final String result = await client.read(
        'http://dietdelight.enigmaty.com/api/v1/questions?pageSize=20&sortOrder=desc');
    if (result.isNotEmpty) {
      var body = convert.jsonDecode(result);
      print('body: ${body['data']}');
      print('data received');
      return true;
    } else {
      return false;
    }
  }
}
