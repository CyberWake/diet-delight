import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_format/date_format.dart';
import 'package:diet_delight/Models/mealModel.dart';
import 'package:diet_delight/Models/mealPurchaseModel.dart';
import 'package:diet_delight/Screens/Menu/placeMealMenuOrders.dart';
import 'package:diet_delight/Screens/Menu/placedMealMenuOrders.dart';
import 'package:diet_delight/konstants.dart';
import 'package:diet_delight/services/apiCalls.dart';
import 'package:flutter/cupertino.dart';
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

  getData() async {
    DateTime today = DateTime.now();
    orders = await _apiCall.getOngoingMealPurchases(today);
    for (int i = 0; i < orders.length;) {
      plans.add(await _apiCall
          .getMealPlan(orders[i].mealPlanId)
          .whenComplete(() => i++));
    }
    for (int i = 0; i < orders.length;) {
      ordersPresent.add(await _apiCall
          .getCurrentMealPlanOrders(orders[i].id)
          .whenComplete(() => i++));
    }

    setState(() {
      loaded = true;
    });
  }

  @override
  void initState() {
    getData();
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
                                builder: (BuildContext context) => PlaceMealMenuOrders(
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
