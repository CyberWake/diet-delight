import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_format/date_format.dart';
import 'package:diet_delight/Models/export_models.dart';
import 'package:diet_delight/Screens/export.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class DashBoardOngoingOrders extends StatefulWidget {
  @override
  _DashBoardOngoingOrdersState createState() => _DashBoardOngoingOrdersState();
}

class _DashBoardOngoingOrdersState extends State<DashBoardOngoingOrders> {
  bool orderPresent = true;
  final _apiCall = Api.instance;
  List<MealPurchaseModel> activeMealPurchases = List();
  List<MealModel> activePurchaseMealPlans = List();
  List<bool> ordersInActivePlans = List();
  bool loaded = false;
  List<String> format = [dd, ' ', 'M', ', ', yyyy];
  List<DateTime> dates = [];
  DateTime startDate;

  getCachedData() async {
    print('getCachedCalled');
    var isCached = await FlutterSecureStorage().read(key: "onGoingOrders");

    if (isCached.toString() == 'true') {
      print('true');
      _apiCall.resetOnGoingMealPlanCache();
      var ordersTemp = await FlutterSecureStorage().read(key: 'ordersData');
      var plansDataTemp = await FlutterSecureStorage().read(key: 'plansData');
      var ordersPresentDataTemp =
          await FlutterSecureStorage().read(key: 'ordersPresentData');
      print("||||||||||1");
      print(ordersTemp);
      print(plansDataTemp);
      print(ordersPresentDataTemp);
      var decodedOrders = jsonDecode(ordersTemp)[0];
      List<MealPurchaseModel> itemPresentMealPurchases = List();
      decodedOrders.forEach((element) {
        MealPurchaseModel item = MealPurchaseModel.fromMap(element);
        if (item.endDate != null) {
          if (DateTime.parse(item.endDate).compareTo(DateTime.now()) > 0) {
            itemPresentMealPurchases.add(item);
          }
        }
      });
      setState(() {
        activeMealPurchases = itemPresentMealPurchases;
        print("orders done");
      });
      var decodedPlansData = jsonDecode(plansDataTemp);
      for (int i = 0; i < decodedPlansData.length; i++) {
        setState(() {
          activePurchaseMealPlans.add(MealModel.fromMap(decodedPlansData[i]));
          print("plans done");
        });
      }

      var decodedOrdersPresent = jsonDecode(ordersPresentDataTemp);
      for (int i = 0; i < decodedOrdersPresent.length; i++) {
        setState(() {
          ordersInActivePlans.add(decodedOrdersPresent[i]);
        });
        print("orders present done");
      }

      setState(() {
        loaded = true;
      });
      getData();
    } else {
      print('false');
      getData();
    }
  }



  getData() async {
    print("in get data");
    List<MealPurchaseModel> activeMealPurchasesCache = List();
    List<MealModel> activePurchaseMealPlansCache = List();
    List<bool> ordersInActivePlansCache = List();

    DateTime today = DateTime.now();
    activeMealPurchasesCache = await _apiCall.getOngoingMealPurchases(today);
    for (int i = 0; i < activeMealPurchasesCache.length;) {
      activePurchaseMealPlansCache.add(await _apiCall
          .getMealPlan(activeMealPurchasesCache[i].mealPlanId)
          .whenComplete(() => i++));
    }
    for (int i = 0; i < activeMealPurchasesCache.length;) {
      ordersInActivePlansCache.add(await _apiCall
          .getCurrentMealPlanOrdersAvailability(activeMealPurchasesCache[i].id)
          .whenComplete(() => i++));
    }

    await FlutterSecureStorage().write(key: 'onGoingOrders', value: 'true');
    if (mounted) {
      setState(() {
        activePurchaseMealPlans = activePurchaseMealPlansCache;
        ordersInActivePlans = ordersInActivePlansCache;
        activeMealPurchases = activeMealPurchasesCache;
        loaded = true;
      });
    }
  }

  @override
  void initState() {
    getCachedData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loaded
        ? Column(
            children: [
              Expanded(
                  child: ListView.builder(
                shrinkWrap: true,
                itemCount: activeMealPurchases.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () async {
                      if (ordersInActivePlans[index]) {
                        print('placed called');
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (BuildContext context) =>
                                    PlacedMealMenuOrders(
                                        purchaseDetails:
                                            activeMealPurchases[index],
                                        plan: activePurchaseMealPlans[index])));
                      } else {
                        print('place called');
                        bool returnedBack = await Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (BuildContext context) =>
                                    PlaceMealMenuOrders(
                                        purchaseDetails:
                                            activeMealPurchases[index],
                                        plan: activePurchaseMealPlans[index])));
                        if (returnedBack) {
                          getCachedData();
                        }
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color:
                            !ordersInActivePlans[index] ? white : defaultGreen,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 4,
                            color: Colors.black.withOpacity(0.25),
                            spreadRadius: 0,
                            offset: const Offset(0.0, 0.0),
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            fit: FlexFit.loose,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  fit: FlexFit.loose,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        fit: FlexFit.loose,
                                        child: Text(
                                            activeMealPurchases[index]
                                                .mealPlanName,
                                            style: selectedTab.copyWith(
                                                color:
                                                    !ordersInActivePlans[index]
                                                        ? Colors.black
                                                        : white,
                                                fontSize: 24)),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Flexible(
                                        fit: FlexFit.loose,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Text(
                                            activePurchaseMealPlans[index]
                                                .details,
                                            style: TextStyle(
                                                color:
                                                    !ordersInActivePlans[index]
                                                        ? Colors.black
                                                        : white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 4,
                                        color: Colors.grey[500],
                                        spreadRadius: 0,
                                        offset: const Offset(0.0, 0.0),
                                      )
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    radius: 45,
                                    backgroundColor: white,
                                    child: CachedNetworkImage(
                                      imageUrl: activePurchaseMealPlans[index]
                                              .picture ??
                                          "http://via.placeholder.com/350x150",
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          color: white,
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 4,
                                              color: Colors.grey[500],
                                              spreadRadius: 0,
                                              offset: const Offset(0.0, 0.0),
                                            )
                                          ],
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              "${activeMealPurchases[index].mealPlanDuration} day meal plan • " +
                                  (activePurchaseMealPlans[index].type == 0
                                      ? "With Weekends"
                                      : "Without Weekends"),
                              style: TextStyle(
                                  color: !ordersInActivePlans[index]
                                      ? Colors.black
                                      : white),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 9.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  activeMealPurchases[index].kCal,
                                  style: TextStyle(
                                      color: !ordersInActivePlans[index]
                                          ? Colors.black
                                          : white),
                                ),
                                Spacer(),
                                Text(
                                  'Start Date - ${formatDate(DateTime.parse(activeMealPurchases[index].startDate), format)}',
                                  style: TextStyle(
                                      color: !ordersInActivePlans[index]
                                          ? Colors.black
                                          : white),
                                ),
                                Spacer()
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                                onPressed: () {
                                  if (ordersInActivePlans[index]) {
                                    Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (BuildContext context) =>
                                                PlacedMealMenuOrders(
                                                    purchaseDetails:
                                                        activeMealPurchases[
                                                            index],
                                                    plan:
                                                        activePurchaseMealPlans[
                                                            index])));
                                  } else {
                                    Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (BuildContext context) =>
                                                PlaceMealMenuOrders(
                                                    placedFoodItems: [],
                                                    purchaseDetails:
                                                        activeMealPurchases[
                                                            index],
                                                    plan:
                                                        activePurchaseMealPlans[
                                                            index])));
                                  }
                                },
                                child: !ordersInActivePlans[index]
                                    ? Text(
                                        'Select Menu',
                                        style: selectedTab.copyWith(
                                            color: defaultGreen),
                                      )
                                    : Icon(
                                        Icons.arrow_right,
                                        color: white,
                                        size: 30,
                                      )),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ))
            ],
          )
        : Center(
            child: SpinKitDoubleBounce(color: defaultGreen),
          );
  }
}
