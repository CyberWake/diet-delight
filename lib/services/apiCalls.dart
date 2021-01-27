import 'dart:convert' as convert;
import 'dart:io';

import 'package:diet_delight/Models/consultationAppointmentModel.dart';
import 'package:diet_delight/Models/consultationModel.dart';
import 'package:diet_delight/Models/consultationPurchaseModel.dart';
import 'package:diet_delight/Models/foodItemModel.dart';
import 'package:diet_delight/Models/loginModel.dart';
import 'package:diet_delight/Models/mealModel.dart';
import 'package:diet_delight/Models/menuCategoryModel.dart';
import 'package:diet_delight/Models/menuModel.dart';
import 'package:diet_delight/Models/questionnaireModel.dart';
import 'package:diet_delight/Models/registrationModel.dart';
import 'package:http/http.dart' as http;
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  static var client;
  static List<QuestionnaireModel> itemsQuestionnaire = List();
  static List<ConsultationModel> itemsConsultation = List();
  static List<MenuModel> itemsMenu = List();
  static List<MealModel> itemsMeal = List();
  static List<MenuCategoryModel> itemsMenuCategory = List();
  static List<ConsPurchaseModel> itemsConsultationPurchases = List();
  static List<FoodItemModel> itemsFood = List();
  static List<ConsAppointmentModel> itemAppointments = List();
  static RegModel userInfo = RegModel();
  static String token;
  String uri = 'http://dietdelight.enigmaty.com';
  Api._privateConstructor();

  static final Api instance = Api._privateConstructor();

  Future<bool> register(RegModel registerData) async {
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
    };
    String body = convert.jsonEncode(registerData.toMap());
    print(body);
    final response =
        await http.post(uri + '/api/v1/register', headers: headers, body: body);
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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final authorizationEndpoint = Uri.parse(uri + '/oauth/token');
      final username = loginData.mobile ?? loginData.email;
      final password = loginData.password;
      final identifier = '2';
      final secret = '3X7ar2wWTrdzAzRDl2rge1pGL5cFWLSQq7sVkMRV';
      client = await oauth2.resourceOwnerPasswordGrant(
        authorizationEndpoint,
        username,
        password,
        identifier: identifier,
        secret: secret,
      );
      var body = convert.jsonDecode(client.credentials.toJson());
      token = body['accessToken'];
      prefs.setString('email', loginData.email);
      prefs.setString('mobile', loginData.mobile);
      prefs.setString('password', loginData.password);
      prefs.setString('accessToken', body['accessToken']);
      prefs.setString('refreshToken', body['refreshToken']);
      await getUserInfo();
      return true;
    } on Exception catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<RegModel> getUserInfo() async {
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $token"
    };
    final response = await http.get(uri + '/api/v1/user', headers: headers);
    if (response.statusCode == 200) {
      print('Success getting user info');
      var body = convert.jsonDecode(response.body);
      userInfo = RegModel.fromMap(body);
      return userInfo;
    } else if (response.statusCode == 400) {
      print(response.statusCode);
      return null;
    } else {
      print(response.statusCode);
      return null;
    }
  }

  Future<bool> putUserInfo(RegModel user) async {
    final String result = await client.write(
      uri + '/api/v1/menus?sortOrder=desc',
    );
    if (result.isNotEmpty) {
      var body = convert.jsonDecode(result);
      List data = body['data'];
      data.forEach((element) {
        MenuModel item = MenuModel.fromMap(element);
        itemsMenu.add(item);
      });
      print('data received menu');
      return true;
    } else {
      return false;
    }
  }

  Future<List<ConsultationModel>> getConsultationPackages() async {
    itemsConsultation = [];
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $token"
    };
    final response = await http.get(
        uri + '/api/v1/consultation-packages?sortOrder=desc',
        headers: headers);
    if (response.statusCode == 200) {
      print('Success getting consultation packages');
      var body = convert.jsonDecode(response.body);
      List data = body['data'];
      data.forEach((element) {
        ConsultationModel item = ConsultationModel.fromMap(element);
        itemsConsultation.add(item);
      });
      return itemsConsultation;
    } else {
      print(response.statusCode);
      print(response.body);
      return itemsConsultation;
    }
  }

  Future<List<MenuModel>> getMenuPackages() async {
    itemsMenu = [];
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $token"
    };
    final response =
        await http.get(uri + '/api/v1/menus?sortOrder=desc', headers: headers);
    if (response.statusCode == 200) {
      print('Success getting menus');
      var body = convert.jsonDecode(response.body);
      List data = body['data'];
      data.forEach((element) {
        MenuModel item = MenuModel.fromMap(element);
        itemsMenu.add(item);
      });
      return itemsMenu;
    } else {
      print(response.statusCode);
      print(response.body);
      return itemsMenu;
    }
  }

  Future<List<MealModel>> getMealPlans() async {
    itemsMeal = [];
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $token"
    };
    final response = await http.get(uri + '/api/v1/meal-plans?sortOrder=desc',
        headers: headers);
    if (response.statusCode == 200) {
      print('Success getting meal plans');
      var body = convert.jsonDecode(response.body);
      List data = body['data'];
      data.forEach((element) {
        MealModel item = MealModel.fromMap(element);
        itemsMeal.add(item);
      });
      return itemsMeal;
    } else {
      print(response.statusCode);
      print(response.body);
      return itemsMeal;
    }
  }

  Future<List<QuestionnaireModel>> getQuestions() async {
    itemsQuestionnaire = [];
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $token"
    };
    final response = await http.get(uri + '/api/v1/questions?sortOrder=desc',
        headers: headers);
    if (response.statusCode == 200) {
      print('Success getting question');
      var body = convert.jsonDecode(response.body);
      List data = body['data'];
      data.forEach((element) {
        QuestionnaireModel item = QuestionnaireModel.fromMap(element);
        itemsQuestionnaire.add(item);
      });
      return itemsQuestionnaire;
    } else {
      print(response.statusCode);
      print(response.body);
      return itemsQuestionnaire;
    }
  }

  Future<List<MenuCategoryModel>> getCategories(int menuId) async {
    itemsMenuCategory = [];
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $token"
    };
    final response = await http.get(
        uri + '/api/v1/menu-categories?menu_id=$menuId&sortOrder=desc',
        headers: headers);
    if (response.statusCode == 200) {
      print('Success getting menu categories');
      var body = convert.jsonDecode(response.body);
      List data = body['data'];
      data.forEach((element) {
        MenuCategoryModel item = MenuCategoryModel.fromMap(element);
        itemsMenuCategory.add(item);
      });
      return itemsMenuCategory;
    } else {
      print(response.statusCode);
      print(response.body);
      return itemsMenuCategory;
    }
  }

  Future<List<FoodItemModel>> getCategoryFoodItems(
      String menuId, String categoryId) async {
    itemsFood = [];
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $token"
    };
    final response = await http.get(
        uri +
            '/api/v1/menu-items?menu_id=$menuId&menu_category_id=$categoryId&sortOrder=desc',
        headers: headers);
    if (response.statusCode == 200) {
      print('Success getting menu category items');
      var body = convert.jsonDecode(response.body);
      List data = body['data'];
      data.forEach((element) {
        FoodItemModel item = FoodItemModel.fromMap(element);
        itemsFood.add(item);
      });
      return itemsFood;
    } else {
      print(response.statusCode);
      print(response.body);
      return itemsFood;
    }
  }

  Future<String> postConsultationPurchase(ConsPurchaseModel order) async {
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $token"
    };
    String body = convert.jsonEncode(order.toMap());
    final response = await http.post(uri + '/api/v1/my-consultation-purchases',
        headers: headers, body: body);
    if (response.statusCode == 201) {
      var body = convert.jsonDecode(response.body);
      ConsPurchaseModel item = ConsPurchaseModel.fromMap(body['data']);
      return item.id;
    } else {
      print(response.statusCode);
      print(response.body);
      return null;
    }
  }

  Future<List<ConsPurchaseModel>> getConsultationPurchases() async {
    itemsConsultationPurchases = [];
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $token"
    };
    final response = await http.get(
        uri + '/api/v1/my-consultation-purchases?sortOrder=desc',
        headers: headers);
    if (response.statusCode == 200) {
      print('Success getting menu category items');
      var body = convert.jsonDecode(response.body);
      List data = body['data'];
      data.forEach((element) {
        ConsPurchaseModel item = ConsPurchaseModel.fromMap(element);
        itemsConsultationPurchases.add(item);
      });
      return itemsConsultationPurchases;
    } else {
      print(response.statusCode);
      print(response.body);
      return itemsConsultationPurchases;
    }
  }

  Future<bool> postAppointment(ConsAppointmentModel appointment) async {
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $token"
    };
    String body = convert.jsonEncode(appointment.toMap());
    final response = await http.post(uri + '/api/v1/my-consultations',
        headers: headers, body: body);
    if (response.statusCode == 201) {
      print('appointment Posted');
      return true;
    } else {
      print(response.statusCode);
      print(response.body);
      return false;
    }
  }

  Future<List<ConsAppointmentModel>> getAppointments() async {
    itemAppointments = [];
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $token"
    };
    final response =
        await http.get(uri + '/api/v1/my-consultations', headers: headers);
    if (response.statusCode == 200) {
      var body = convert.jsonDecode(response.body);
      List data = body['data'];
      data.forEach((element) {
        ConsAppointmentModel item = ConsAppointmentModel.fromMap(element);
        itemAppointments.add(item);
      });
      print(itemAppointments.length);
      return itemAppointments;
    } else {
      print(response.statusCode);
      print(response.body);
      return itemAppointments;
    }
  }
}
