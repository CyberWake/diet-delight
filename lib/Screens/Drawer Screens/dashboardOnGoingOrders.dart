import 'package:diet_delight/Screens/MealSubscription/mealSelection.dart';
import 'package:diet_delight/Screens/myOngoingMealMenu.dart';
import 'package:diet_delight/konstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DashBoardOngoingOrders extends StatefulWidget {
  @override
  _DashBoardOngoingOrdersState createState() => _DashBoardOngoingOrdersState();
}

class _DashBoardOngoingOrdersState extends State<DashBoardOngoingOrders> {
  bool firstVisit = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: ListView.builder(
          shrinkWrap: true,
          itemCount: 2,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                if (firstVisit) {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (BuildContext context) => MealPlan(
                                planDuration: 14,
                                mealPlanName: 'One meal plan',
                                mealPlanDisc:
                                    'fajbfiahOIWJRCQRHNEWOCRHESNROEWTHCIEWNXEHCRBNEWIOTCNXGTCUEWIYOUQH',
                                index: 0,
                              )));
                  setState(() {
                    firstVisit = false;
                  });
                } else {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (BuildContext context) => MyMealMenu(
                                planDuration: 14,
                                mealPlanName: 'One meal plan',
                                mealPlanDisc:
                                    'fajbfiahOIWJRCQRHNEWOCRHESNROEWTHCIEWNXEHCRBNEWIOTCNXGTCUEWIYOUQH',
                                index: 0,
                              )));
                }
              },
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: firstVisit ? white : defaultGreen,
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  fit: FlexFit.loose,
                                  child: Text("Meal plan name",
                                      style: selectedTab.copyWith(
                                          color:
                                              firstVisit ? Colors.black : white,
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
                                      'sgasdfjijadfigfadjfvadsfiluHFriuagesfwilyfgveasoeufhbewgorcfqevwidcrewiytvrbgtncbikevwqiIUAGFIGF',
                                      style: TextStyle(
                                          color: firstVisit
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
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        "10 day meal plan • without weekends",
                        style:
                            TextStyle(color: firstVisit ? Colors.black : white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Calorie",
                            style: TextStyle(
                                color: firstVisit ? Colors.black : white),
                          ),
                          Spacer(),
                          Text(
                            'Start Date - 22 Jun 2021',
                            style: TextStyle(
                                color: firstVisit ? Colors.black : white),
                          ),
                          Spacer(),
                          TextButton(
                              onPressed: () {
                                if (firstVisit) {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (BuildContext context) =>
                                              MealPlan(
                                                planDuration: 14,
                                                mealPlanName: 'One meal plan',
                                                mealPlanDisc:
                                                    'fajbfiahOIWJRCQRHNEWOCRHESNROEWTHCIEWNXEHCRBNEWIOTCNXGTCUEWIYOUQH',
                                                index: 0,
                                              )));
                                  setState(() {
                                    firstVisit = false;
                                  });
                                } else {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (BuildContext context) =>
                                              MyMealMenu(
                                                planDuration: 14,
                                                mealPlanName: 'One meal plan',
                                                mealPlanDisc:
                                                    'fajbfiahOIWJRCQRHNEWOCRHESNROEWTHCIEWNXEHCRBNEWIOTCNXGTCUEWIYOUQH',
                                                index: 0,
                                              )));
                                }
                              },
                              child: firstVisit
                                  ? Text(
                                      'Select Menu',
                                      style: selectedTab.copyWith(
                                          color: defaultGreen),
                                    )
                                  : Icon(
                                      Icons.arrow_right,
                                      color: white,
                                      size: 30,
                                    ))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ))
      ],
    );
  }
}
