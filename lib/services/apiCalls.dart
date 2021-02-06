import 'dart:convert' as convert;
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
import 'package:diet_delight/Models/optionsFile.dart';
import 'package:diet_delight/Models/questionnaireModel.dart';
import 'package:diet_delight/Models/registrationModel.dart';
import 'package:http/http.dart' as http;
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:shared_preferences/shared_preferences.dart';

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
  static List<ConsAppointmentModel> itemAppointments = List();
  static List<MealPurchaseModel> itemMealPurchases = List();
  static List<MealPurchaseModel> itemPresentMealPurchases = List();
  static List<DurationModel> itemDurations = List();
  static RegModel userInfo = RegModel();
  static String token;

  String uri = 'https://dietdelight.enigmaty.com';
  Api._privateConstructor();

  static final Api instance = Api._privateConstructor();

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
        print(response.statusCode);
        return null;
      }
    } on Exception catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<bool> putUserInfo(RegModel user) async {
    try {
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
    } on Exception catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<List<ConsultationModel>> getConsultationPackages() async {
    //  token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIyIiwianRpIjoiMTU0NzJkNWQ0ZWMwYzIyMGFmZTZiZGE2NTZjY2Q5Nzk1NjZlNjY4ZTVmYmNmZDdlOWQwNTY0MWYxODQ1ZjdlYTk3ZDEwODRjYTM1OGE5NTEiLCJpYXQiOjE2MTI0NTAyMDcsIm5iZiI6MTYxMjQ1MDIwNywiZXhwIjoxNjQzOTg2MjA3LCJzdWIiOiIzIiwic2NvcGVzIjpbXX0.uX1UKBSQKvkN28ub5A3TXcOwgI_EvWWZ5B6FS13jqfz8vlI7UP6kEI--LofVf_2yUT7HxUUEVE2t5zIVzSzyHDvekWvCVdLsqPJQT6f0hPqeC36ODRWRrQsL7c-DhWv716HzuKUYfifnP9IBglyfRKDwkpDwyINFGPbHjdI8CaRxDj_pyCMdekSoZ9w8TQ4TgIuVekXAiIM3SttuPNK2ijuOGf6aQKs-dgbXK5YbPy_uSDIOWT4Ais_0GL8rJL4vKd4trAeQ1J96Im3smaikAmBuJRYrUeQsz44qHszFWsC2lUh8ECwgOUrEyO0w2p1BqOEd4PKiOqGpnewSgXiDsXJ1LOgZWNS-W-s5f9rcL9c__esV5WGvuw1128a2qu-iOw4iiy-8-YtBkU43XEEVeeXiMz7voJcYGMblNnDLRHPm_A9kbvT5XGdRwcx7DxaMJaJgwQLNs65z6coF5KfivNLTY7vC7gxyhyzciEp0T3kBG0SHL-J7xXZQjcoxzJCzvoimhzErbSI7hQR0vMgcJ-Jusv9MuYA7jYjoIozjfMQdAVywO7ogG0rT9qyLT43r6wOnfgr7F4CiWJdTxIPJ3nm11mPCp--E1oKbj-V_7hnzRkTZGGH_1SndpQuhsGzQAdqmy-XtWWSFIx0lgeZt4AWWpsKCN3MRGId1IxZki98";
    try {
      itemsConsultation = [];
      Map<String, String> headers = {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token"
      };
      final response = await http.get(
          uri + '/api/v1/consultation-packages?sortOrder=desc',
          headers: headers);
      print(response.body);
      print(response.statusCode);
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

  Future<List<MealModel>> getMealPlans() async {
    try {
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
    } on Exception catch (e) {
      print(e.toString());
      return [];
    }
  }

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

  Future<List<QuestionnaireModel>> getQuestions() async {
    //  token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIyIiwianRpIjoiMTU0NzJkNWQ0ZWMwYzIyMGFmZTZiZGE2NTZjY2Q5Nzk1NjZlNjY4ZTVmYmNmZDdlOWQwNTY0MWYxODQ1ZjdlYTk3ZDEwODRjYTM1OGE5NTEiLCJpYXQiOjE2MTI0NTAyMDcsIm5iZiI6MTYxMjQ1MDIwNywiZXhwIjoxNjQzOTg2MjA3LCJzdWIiOiIzIiwic2NvcGVzIjpbXX0.uX1UKBSQKvkN28ub5A3TXcOwgI_EvWWZ5B6FS13jqfz8vlI7UP6kEI--LofVf_2yUT7HxUUEVE2t5zIVzSzyHDvekWvCVdLsqPJQT6f0hPqeC36ODRWRrQsL7c-DhWv716HzuKUYfifnP9IBglyfRKDwkpDwyINFGPbHjdI8CaRxDj_pyCMdekSoZ9w8TQ4TgIuVekXAiIM3SttuPNK2ijuOGf6aQKs-dgbXK5YbPy_uSDIOWT4Ais_0GL8rJL4vKd4trAeQ1J96Im3smaikAmBuJRYrUeQsz44qHszFWsC2lUh8ECwgOUrEyO0w2p1BqOEd4PKiOqGpnewSgXiDsXJ1LOgZWNS-W-s5f9rcL9c__esV5WGvuw1128a2qu-iOw4iiy-8-YtBkU43XEEVeeXiMz7voJcYGMblNnDLRHPm_A9kbvT5XGdRwcx7DxaMJaJgwQLNs65z6coF5KfivNLTY7vC7gxyhyzciEp0T3kBG0SHL-J7xXZQjcoxzJCzvoimhzErbSI7hQR0vMgcJ-Jusv9MuYA7jYjoIozjfMQdAVywO7ogG0rT9qyLT43r6wOnfgr7F4CiWJdTxIPJ3nm11mPCp--E1oKbj-V_7hnzRkTZGGH_1SndpQuhsGzQAdqmy-XtWWSFIx0lgeZt4AWWpsKCN3MRGId1IxZki98";

    var questionOptions = [];
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
        "user_id": userId,
        "question_id": "1",
        "answer_option_id": "1",
        "answer": "My diet is ...",
        "question_question": "What is Gender?",
        "question_type": "0",
        "question_additional_text": "0",
        "answer_option_option": "Male"
      };
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
          headers: headers, body: body.toString());
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

  Future<List<MenuCategoryModel>> getCategories(int menuId) async {
    try {
      itemsMenuCategory = [];
      Map<String, String> headers = {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token"
      };
      print("||||||||||||||");
      print(token);
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

  Future<List<FoodItemModel>> getCategoryFoodItems(
      String menuId, String categoryId) async {
    try {
      itemsFood = [];
      Map<String, String> headers = {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token"
      };
      print("printing token");
      print(token);
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

  Future<bool> postAppointment(ConsAppointmentModel appointment) async {
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

  Future<List<ConsAppointmentModel>> getAppointments() async {
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

  Future<bool> postMealPurchase(MealPurchaseModel order) async {
    try {
      Map<String, String> headers = {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token"
      };
      String body = convert.jsonEncode(order.toMap());
      final response = await http.post(uri + '/api/v1/my-meal-purchases',
          headers: headers, body: body);
      if (response.statusCode == 201) {
        print('meal purchase Posted');
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

  Future<List<MealPurchaseModel>> getOngoingMealPurchases(
      DateTime endDate) async {
    /*try {

    } on Exception catch (e) {
      print(e.toString());
      return [];
    }*/
    itemPresentMealPurchases = [];
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
      //print(data);
      data.forEach((element) {
        MealPurchaseModel item = MealPurchaseModel.fromMap(element);
        print(item.endDate);
        if (item.endDate != null) {
          if (DateTime.parse(item.endDate).compareTo(endDate) > 0) {
            itemPresentMealPurchases.add(item);
          }
        }
      });
      print('present plans: ${itemPresentMealPurchases.length}');
      return itemPresentMealPurchases;
    } else {
      print(response.statusCode);
      print(response.body);
      return itemPresentMealPurchases;
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

  getMenuOrders(String menuId) async {
    try {
      Map<String, String> headers = {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token"
      };
      final response = await http.get(
          uri + '/api/v1/my-menu-orders?sortBy=menu_id&sortOrder=desc',
          headers: headers);
      if (response.statusCode == 200) {
        print('Success getting meal plans');
        var body = convert.jsonDecode(response.body);
        var data = body['data'];
        MealModel item = MealModel.fromMap(data);
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

  Future<List<OptionsModel>> getOptions(questions) async {
    List<OptionsModel> options = [];

    print(questions.length);
    for (int i = 0; i < questions.length; i++) {
      try {
        Map<String, String> headers = {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer $token"
        };
        int type = questions[i].type;
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
            print(response.statusCode);
            print(response.body);
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
}
