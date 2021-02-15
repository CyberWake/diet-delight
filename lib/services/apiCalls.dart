import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:io';

import 'package:diet_delight/Models/consultationAppointmentModel.dart';
import 'package:diet_delight/Models/consultationModel.dart';
import 'package:diet_delight/Models/consultationPurchaseModel.dart';
import 'package:diet_delight/Models/foodItemModel.dart';
import 'package:diet_delight/Models/loginModel.dart';
import 'package:diet_delight/Models/mealModel.dart';
import 'package:diet_delight/Models/mealPlanDurationsModel.dart';
import 'package:diet_delight/Models/mealPurchaseModel.dart';
import 'package:diet_delight/Models/menuCategoryModel.dart';
import 'package:diet_delight/Models/menuModel.dart';
import 'package:diet_delight/Models/menuOrdersModel.dart';
import 'package:diet_delight/Models/optionsFile.dart';
import 'package:diet_delight/Models/questionnaireModel.dart';
import 'package:diet_delight/Models/registrationModel.dart';
import 'package:diet_delight/Models/addFavouritesModel.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:shared_preferences/shared_preferences.dart';

var currentMealPlanCache = [];
var mealPlanCacheData = [];
var onGoingMealPurchaseCacheData = [];

class Api {
  static var client;
  static List<QuestionnaireModel> itemsQuestionnaire = List();
  static List<OptionsModel> itemsOptions = List();
  static List<ConsultationModel> itemsConsultation = List();
  static List<MenuModel> itemsMenu = List();
  static List<MealModel> itemsMeal = List();
  static List<MenuCategoryModel> itemsMenuCategory = List();
  static List<ConsPurchaseModel> itemsConsultationPurchases = List();
  static List<FoodItemModel> itemsFood = List();
  static List<MenuOrderModel> itemsOrderedFood = List();
  static List<ConsAppointmentModel> itemAppointments = List();
  static List<MealPurchaseModel> itemMealPurchases = List();
  static List<MealPurchaseModel> itemPresentMealPurchases = List();
  static List<DurationModel> itemDurations = List();
  static List<AddFavouritesModel> favouriteItems = List();
  static List<int> favouriteIds = List();
  static List<List> favourites = List();
  static List<FoodItemModel> featuredMenu = List();
  static RegModel userInfo = RegModel();
  static String token;

  String uri = 'https://dietdelight.enigmaty.com';
  Api._privateConstructor();

  static final Api instance = Api._privateConstructor();

  reset() {
    currentMealPlanCache = [];
    mealPlanCacheData = [];
    onGoingMealPurchaseCacheData = [];
  }

  Future autoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('accessToken');
    await getUserInfo();
  }

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
      prefs.setString('accessToken', body['accessToken']);
      prefs.setString('refreshToken', body['refreshToken']);
      prefs.setString('password', loginData.password);
      await getUserInfo();
      return true;
    } on Exception catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<RegModel> getUserInfo() async {
    try {
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
      } else {
        print(response.statusCode.toString() + 'error');
        return null;
      }
    } on Exception catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<bool> putUserInfo(RegModel user) async {
    print('logged id');
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $token"
    };
    String body = convert.jsonEncode(user.toMap());
    print(body);
    final response =
        await http.put(uri + '/api/v1/user', headers: headers, body: body);
    if (response.statusCode == 200) {
      print('Success updating user info');
      var body = convert.jsonDecode(response.body);
      userInfo = null;
      userInfo = RegModel.fromMap(body);
      return true;
    } else if (response.statusCode == 400) {
      print(response.statusCode);
      return false;
    } else {
      print(response.statusCode);
      print(response.body);
      return false;
    }
  }

  Future<bool> resetPassword(RegModel user) async {
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
    };
    String body = convert.jsonEncode(user.toMapForPassword());
    print(body);
    final response = await http.post(uri + '/api/v1/reset-password',
        headers: headers, body: body);
    if (response.statusCode == 200) {
      print('Success resetting password');
      return true;
    } else if (response.statusCode == 400) {
      print(response.statusCode);
      return false;
    } else {
      print(response.statusCode);
      print(response.body);
      return false;
    }
  }

  //Home Screen APIs
  Future<List<MenuModel>> getMenuPackages() async {
    try {
      itemsMenu = [];
      Map<String, String> headers = {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token"
      };
      final response = await http.get(uri + '/api/v1/menus?sortOrder=desc',
          headers: headers);
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
    } on Exception catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<List<DurationModel>> getDurations() async {
    try {
      Map<String, String> headers = {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token"
      };
      final response =
          await http.get(uri + '/api/v1/durations', headers: headers);
      if (response.statusCode == 200) {
        print('Success getting durations data');
        var body = convert.jsonDecode(response.body);
        List data = body['data'];
        data.forEach((element) {
          DurationModel item = DurationModel.fromMap(element);
          itemDurations.add(item);
        });
        return itemDurations;
      } else {
        print(response.statusCode);
        print(response.body);
        return null;
      }
    } on Exception catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<List<ConsultationModel>> getConsultationPackages() async {
    try {
      itemsConsultation = [];
      Map<String, String> headers = {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token"
      };
      final response = await http.get(
          uri + '/api/v1/consultation-packages?sortBy=order&sortOrder=asc',
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
    } on Exception catch (e) {
      print(e.toString());
      return [];
    }
  }

  //Show Menu Category and Items APIs
  Future<List<MenuCategoryModel>> getMenuCategories(int menuId) async {
    try {
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
    } on Exception catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<List<FoodItemModel>> getMenuCategoryFoodItems(
      String menuId, String categoryId) async {
    try {
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
    } on Exception catch (e) {
      print(e.toString());
      return [];
    }
  }

  //Show all meal plans and buy
  Future<List<MealModel>> getMealPlanWithDuration(int id) async {
    try {
      itemsMeal = [];
      Map<String, String> headers = {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token"
      };
      final response = await http.get(
          uri + '/api/v1/meal-plans?duration_id=$id&sortOrder=desc',
          headers: headers);
      if (response.statusCode == 200) {
        print('Success getting meal plans with duration $id');
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
    } on Exception catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<MealPurchaseModel> postMealPurchase(MealPurchaseModel order) async {
    try {
      Map<String, String> headers = {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token"
      };
      String body = convert.jsonEncode(order.toMap());
      print(body);
      final response = await http.post(uri + '/api/v1/my-meal-purchases',
          headers: headers, body: body);
      if (response.statusCode == 201) {
        print('meal purchase Posted');
        var body = convert.jsonDecode(response.body);
        MealPurchaseModel item = MealPurchaseModel.fromMap(body['data']);
        return item;
      } else {
        print(response.statusCode);
        print(response.body);
        return null;
      }
    } on Exception catch (e) {
      print(e.toString());
      return null;
    }
  }

  //Consultation buy
  Future<String> postConsultationPurchase(ConsPurchaseModel order) async {
    try {
      Map<String, String> headers = {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token"
      };
      String body = convert.jsonEncode(order.toMap());
      final response = await http.post(
          uri + '/api/v1/my-consultation-purchases',
          headers: headers,
          body: body);
      if (response.statusCode == 201) {
        var body = convert.jsonDecode(response.body);
        ConsPurchaseModel item = ConsPurchaseModel.fromMap(body['data']);
        return item.id;
      } else {
        print(response.statusCode);
        print(response.body);
        return null;
      }
    } on Exception catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<bool> postConsultationAppointment(
      ConsAppointmentModel appointment) async {
    try {
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
    } on Exception catch (e) {
      print(e.toString());
      return false;
    }
  }

  //Order History page for consultation
  Future<List<ConsPurchaseModel>> getConsultationPurchases() async {
    try {
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
    } on Exception catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<List<ConsAppointmentModel>> getConsultationAppointments() async {
    try {
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
        return itemAppointments;
      } else {
        print(response.statusCode);
        print(response.body);
        return itemAppointments;
      }
    } on Exception catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<ConsultationModel> getConsultationData(String consultationId) async {
    try {
      Map<String, String> headers = {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token"
      };
      final response = await http.get(
          uri + '/api/v1/consultation-packages/$consultationId',
          headers: headers);
      if (response.statusCode == 200) {
        print('Success getting consultation package');
        var body = convert.jsonDecode(response.body);
        var data = body['data'];
        ConsultationModel item = ConsultationModel.fromMap(data);
        return item;
      } else {
        print(response.statusCode);
        print(response.body);
        return null;
      }
    } on Exception catch (e) {
      print(e.toString());
      return null;
    }
  }

  //Order History page for meal purchase
  Future<List<MealPurchaseModel>> getMealPurchases() async {
    try {
      itemMealPurchases = [];
      Map<String, String> headers = {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token"
      };
      final response =
          await http.get(uri + '/api/v1/my-meal-purchases', headers: headers);
      if (response.statusCode == 200) {
        print('success getting meal purchases');
        var body = convert.jsonDecode(response.body);
        List data = body['data'];
        data.forEach((element) {
          MealPurchaseModel item = MealPurchaseModel.fromMap(element);
          itemMealPurchases.add(item);
        });
        return itemMealPurchases;
      } else {
        print(response.statusCode);
        print(response.body);
        return itemMealPurchases;
      }
    } on Exception catch (e) {
      print(e.toString());
      return [];
    }
  }

  //Show unfinished meal plans
  Future<List<MealPurchaseModel>> getOngoingMealPurchases(
      DateTime endDate) async {
    itemPresentMealPurchases = [];
    var cachedData = [];
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $token"
    };
    final response =
        await http.get(uri + '/api/v1/my-meal-purchases', headers: headers);
    if (response.statusCode == 200) {
      print('success getting present meal purchases');
      var body = convert.jsonDecode(response.body);
      List data = body['data'];
      onGoingMealPurchaseCacheData.add(data);
      await FlutterSecureStorage().write(
          key: 'ordersData',
          value: convert.jsonEncode(onGoingMealPurchaseCacheData));
      data.forEach((element) {
        MealPurchaseModel item = MealPurchaseModel.fromMap(element);
        if (item.endDate != null) {
          if (DateTime.parse(item.endDate).compareTo(endDate) > 0) {
            cachedData.add(element);
            itemPresentMealPurchases.add(item);
          }
        }
      });
      await FlutterSecureStorage().write(
          key: 'onGoingOrdersDataMain', value: convert.jsonEncode(cachedData));
      return itemPresentMealPurchases;
    } else {
      print(response.statusCode);
      print(response.body);
      return itemPresentMealPurchases;
    }
  }

  Future<MealModel> getMealPlan(String mealPlanId) async {
    try {
      MealModel meal;
      Map<String, String> headers = {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token"
      };
      final response = await http.get(uri + '/api/v1/meal-plans/' + mealPlanId,
          headers: headers);
      if (response.statusCode == 200) {
        print('Success getting meal plans');
        var body = convert.jsonDecode(response.body);
        var data = body['data'];

        mealPlanCacheData.add(data);
        await FlutterSecureStorage()
            .write(key: 'plansData', value: jsonEncode(mealPlanCacheData));

        MealModel item = MealModel.fromMap(data);
        return item;
      } else {
        print(response.statusCode);
        print(response.body);
        return meal;
      }
    } on Exception catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<bool> getCurrentMealPlanOrdersAvailability(String purchaseId) async {
    try {
      itemsOrderedFood = [];
      Map<String, String> headers = {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token"
      };
      final response = await http.get(
          uri +
              '/api/v1/my-menu-orders?meal_purchase_id=$purchaseId&sortOrder=desc',
          headers: headers);
      if (response.statusCode == 200) {
        print('Success getting menu order category items');
        var body = convert.jsonDecode(response.body);
        List data = body['data'];
        data.forEach((element) {
          MenuOrderModel item = MenuOrderModel.fromMap(element);
          itemsOrderedFood.add(item);
        });
        if (itemsOrderedFood.length > 0) {
          currentMealPlanCache.add(true);
          await FlutterSecureStorage().write(
              key: 'ordersPresentData',
              value: jsonEncode(currentMealPlanCache));
          return true;
        } else {
          currentMealPlanCache.add(false);
          await FlutterSecureStorage().write(
              key: 'ordersPresentData',
              value: jsonEncode(currentMealPlanCache));
          return false;
        }
      } else {
        print(response.statusCode);
        print(response.body);
        return false;
      }
    } on Exception catch (e) {
      print(e.toString());
      return false;
    }
  }

  //Show already placed orders for giving meal purchase
  Future<List<MenuOrderModel>> getCurrentMealCategoryOrdersFoodItems(
      String categoryId, String purchaseId) async {
    try {
      itemsOrderedFood = [];
      Map<String, String> headers = {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token"
      };
      final response = await http.get(
          uri +
              '/api/v1/my-menu-orders?menu_category_id=$categoryId&meal_purchase_id=$purchaseId&sortOrder=desc',
          headers: headers);
      if (response.statusCode == 200) {
        print('Success getting menu order category items');
        var body = convert.jsonDecode(response.body);
        List data = body['data'];
        data.forEach((element) {
          MenuOrderModel item = MenuOrderModel.fromMap(element);
          itemsOrderedFood.add(item);
        });
        return itemsOrderedFood;
      } else {
        print(response.statusCode);
        print(response.body);
        return itemsOrderedFood;
      }
    } on Exception catch (e) {
      print(e.toString());
      return [];
    }
  }

  //Add menu items to ordered food items
  Future<int> postMenuOrder(MenuOrderModel item) async {
    try {
      Map<String, String> headers = {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token"
      };
      String body = convert.jsonEncode(item.toMap());
      final response = await http.post(uri + '/api/v1/my-menu-orders',
          headers: headers, body: body);
      if (response.statusCode == 201) {
        print('Success posting meal menu order');
        var body = convert.jsonDecode(response.body);
        var data = body['data'];
        int id = data['id'];
        return id;
      } else {
        print(response.statusCode);
        print(response.body);
        return null;
      }
    } on Exception catch (e) {
      print(e.toString());
      return null;
    }
  }

  //About you
  Future<List<QuestionnaireModel>> getQuestions() async {
    try {
      itemsQuestionnaire = [];
      Map<String, String> headers = {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token"
      };
      final response = await http.get(uri + '/api/v1/questions?sortOrder=desc',
          headers: headers);
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        print('Success getting question');
        var body = convert.jsonDecode(response.body);
        List data = body['data'];
        print("||||||||||||||||||");
        print(data);
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
    } on Exception catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<void> sendOptionsAnswers(
      {answerId,
      optionSelected,
      questionId,
      answer,
      type,
      question,
      additionalText}) async {
    print("sendOptionsAnswers");
    var userId = userInfo.id;
    try {
      Map<String, String> headers = {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token"
      };
      Map<String, String> body = {
        "user_id": userId.toString(),
        "question_id": questionId.toString(),
        "answer_option_id": answerId.toString(),
        "answer": answer,
        "question_question": question,
        "question_type": type.toString(),
        "question_additional_text": additionalText,
        "answer_option_option": answer
      };
      print(body);
      String encodedBody = convert.jsonEncode(body);
      //
      // Map<String,String> body = {
      //   "user_id": userId,
      //   "question_id": questionId,
      //   "answer_option_id": answerId.toString(),
      //   "answer": answer,
      //   "question_question": question,
      //   "question_type": type.toString(),
      //   "question_additional_text": additionalText.toString(),
      //   "answer_option_option": optionSelected.toString()
      // };

      final response = await http.post(uri + '/api/v1/my-answers',
          headers: headers, body: encodedBody);
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        print('Success getting question');
      } else {
        print(response.statusCode);
        print(response.body);
        //  return itemsQuestionnaire;
      }
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  Future<List<OptionsModel>> getOptions(questions) async {
    List<OptionsModel> options = [];
    print(questions.length);
    for (int i = 0; i < questions.length; i++) {
      try {
        Map<String, String> headers = {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer $token"
        };
        int id = questions[i].id;
        if (questions[i].type == 0) {
          OptionsModel model = OptionsModel(question_Id: id);
          options.add(model);
        } else if (questions[i].type == 1) {
          OptionsModel model = OptionsModel(question_Id: id, option: "Yes,No");
          options.add(model);
        } else if (questions[i].type == 3) {
          OptionsModel model = OptionsModel(question_Id: id);
          options.add(model);
        } else {
          final response = await http.get(uri + "/api/v1/answer-options/$id",
              headers: headers);

          if (response.statusCode == 200) {
            print('Success getting Options');
            var body = convert.jsonDecode(response.body);
            var data = body['data'];
            OptionsModel model = OptionsModel.fromMap(data);
            options.add(model);
          } else {
            print(response.statusCode);
            print(response.body);
            return [];
          }
        }
      } on Exception catch (e) {
        print(e.toString());
        return [];
      }
    }
    print(options);
    return options;
  }

  Future<bool> addFavourites(AddFavouritesModel details) async {
    try {
      Map<String, String> headers = {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token"
      };
      String body = convert.jsonEncode(details.toMap());
      final response = await http.post(uri + '/api/v1/favourites',
          headers: headers, body: body);
      if (response.statusCode == 201) {
        return true;
      } else {
        print(response.statusCode);
        print(response.body);
        return false;
      }
    } on Exception catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> editFavourites(AddFavouritesModel details) async {
    try {
      Map<String, String> headers = {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token"
      };
      String body = convert.jsonEncode(details.toMap());
      final response = await http.post(uri + '/api/v1/favourites/${details.id}',
          headers: headers, body: body);
      if (response.statusCode == 201) {
        return true;
      } else {
        print(response.statusCode);
        print(response.body);
        return false;
      }
    } on Exception catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<List<List>> getFavourites() async {
    try {
      favouriteItems = [];
      favouriteIds = [];
      favourites = [];
      Map<String, String> headers = {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token"
      };
      final response = await http.get(
          uri + '/api/v1/favourites?pageSize=20&sortOrder=desc',
          headers: headers);
      if (response.statusCode == 200) {
        print('Success getting favourites');
        var body = convert.jsonDecode(response.body);
        List data = body['data'];
        data.forEach((element) {
          AddFavouritesModel item = AddFavouritesModel.fromMap(element);
          favouriteIds.add(item.menuItemId);
          favouriteItems.add(item);
        });
        print('Favourite Ids : $favouriteIds');
        print('Favourite Items : $favouriteItems');
        favourites.add(favouriteIds);
        favourites.add(favouriteItems);
        return favourites;
      } else {
        print(response.statusCode);
        print(response.body);
        return favourites;
      }
    } on Exception catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<List<FoodItemModel>> getFeaturedMenuItems() async {
    try {
      featuredMenu = [];
      Map<String, String> headers = {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token"
      };
      final response = await http.get(
          uri + '/api/v1/menu-items?pageSize=20&featured=1&sortOrder=desc',
          headers: headers);
      if (response.statusCode == 200) {
        print('Success getting featured menu items');
        var body = convert.jsonDecode(response.body);
        List data = body['data'];
        data.forEach((element) {
          FoodItemModel item = FoodItemModel.fromMap(element);
          featuredMenu.add(item);
        });
        print('featuredMenu : $featuredMenu');
        return featuredMenu;
      } else {
        print(response.statusCode);
        print(response.body);
        return featuredMenu;
      }
    } on Exception catch (e) {
      print(e.toString());
      return [];
    }
  }
}
