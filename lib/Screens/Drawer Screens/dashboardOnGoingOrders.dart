import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_format/date_format.dart';
import 'package:diet_delight/Models/mealModel.dart';
import 'package:diet_delight/Models/mealPurchaseModel.dart';
import 'package:diet_delight/Models/menuOrdersModel.dart';
import 'package:diet_delight/Screens/Menu/placeMealMenuOrders.dart';
import 'package:diet_delight/Screens/Menu/placedMealMenuOrders.dart';
import 'package:diet_delight/konstants.dart';
import 'package:diet_delight/services/apiCalls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';

class DashBoardOngoingOrders extends StatefulWidget {
  @override
  _DashBoardOngoingOrdersState createState() => _DashBoardOngoingOrdersState();
}

class _DashBoardOngoingOrdersState extends State<DashBoardOngoingOrders> {
  bool orderPresent = true;
  final _apiCall = Api.instance;
  List<MealPurchaseModel> orders = List();
  List<MealModel> plans = List();
  List<bool> ordersPresent = List();
  bool loaded = false;
  List<String> format = [dd, ' ', 'M', ', ', yyyy];

  getCachedData() async {
    print('getCachedCalled');
    var isCached = await FlutterSecureStorage().read(key: "onGoingOrders");

    if (isCached.toString() == 'true') {
      print('true');
      _apiCall.reset();
      var ordersTemp = await FlutterSecureStorage().read(key: 'ordersData');
      var plansDataTemp = await FlutterSecureStorage().read(key: 'plansData');
      var ordersPresentDataTemp =
          await FlutterSecureStorage().read(key: 'ordersPresentData');
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
       orders = itemPresentMealPurchases;
       print("orders done");
     });
      var decodedPlansData = jsonDecode(plansDataTemp);
      for(int i =0 ; i<decodedPlansData.length;i++){
        setState(() {
          plans.add(MealModel.fromMap(decodedPlansData[i]));
          print("plans done");
        });
      }

      var decodedOrdersPresent = jsonDecode(ordersPresentDataTemp);
      for(int i =0 ; i<decodedOrdersPresent.length;i++){
        setState(() {
          ordersPresent.add(decodedOrdersPresent[i]);
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
    List<MealPurchaseModel> ordersTemp = List();
    List<MealModel> plansTemp = List();
    List<bool> ordersPresentTemp = List();


    DateTime today = DateTime.now();
    ordersTemp = await _apiCall.getOngoingMealPurchases(today);
    for (int i = 0; i < ordersTemp.length;) {
      plansTemp.add(await _apiCall
          .getMealPlan(ordersTemp[i].mealPlanId)
          .whenComplete(() => i++));
    }
    for (int i = 0; i < ordersTemp.length;) {
      ordersPresentTemp.add(await _apiCall
          .getCurrentMealPlanOrders(ordersTemp[i].id)
          .whenComplete(() => i++));
    }

    await FlutterSecureStorage().write(key: 'onGoingOrders', value: 'true');
    setState(() {
      plans = plansTemp;
      ordersPresent = ordersPresentTemp;
      orders = ordersTemp;
      loaded = true;
    });
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
                itemCount: orders.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      if (ordersPresent[index]) {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (BuildContext context) =>
                                    PlacedMealMenuOrders(
                                        purchaseDetails: orders[index],
                                        plan: plans[index])));
                      } else {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (BuildContext context) =>
                                    PlaceMealMenuOrders(
                                        purchaseDetails: orders[index],
                                        plan: plans[index])));
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: !ordersPresent[index] ? white : defaultGreen,
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
                                        child: Text(orders[index].mealPlanName,
                                            style: selectedTab.copyWith(
                                                color: !ordersPresent[index]
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
                                            plans[index].details,
                                            style: TextStyle(
                                                color: !ordersPresent[index]
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
                                      imageUrl: plans[index].picture ??
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
                              "${orders[index].mealPlanDuration} day meal plan • " +
                                  (plans[index].type == 0
                                      ? "With Weekends"
                                      : "Without Weekends"),
                              style: TextStyle(
                                  color: !ordersPresent[index]
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
                                  orders[index].kCal,
                                  style: TextStyle(
                                      color: !ordersPresent[index]
                                          ? Colors.black
                                          : white),
                                ),
                                Spacer(),
                                Text(
                                  'Start Date - ${formatDate(DateTime.parse(orders[index].startDate), format)}',
                                  style: TextStyle(
                                      color: !ordersPresent[index]
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
                                  if (ordersPresent[index]) {
                                    Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (BuildContext context) =>
                                                PlacedMealMenuOrders(
                                                    purchaseDetails:
                                                        orders[index],
                                                    plan: plans[index])));
                                  } else {
                                    Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (BuildContext context) =>
                                                PlaceMealMenuOrders(
                                                    purchaseDetails:
                                                        orders[index],
                                                    plan: plans[index])));
                                  }
                                },
                                child: !ordersPresent[index]
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
            child: CircularProgressIndicator(),
          );
  }
}
