import 'package:date_format/date_format.dart';
import 'package:diet_delight/Models/mealPurchaseModel.dart';
import 'package:diet_delight/konstants.dart';
import 'package:diet_delight/services/apiCalls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MealPlanOrderHistoryPage extends StatefulWidget {
  @override
  _MealPlanOrderHistoryPageState createState() =>
      _MealPlanOrderHistoryPageState();
}

class _MealPlanOrderHistoryPageState extends State<MealPlanOrderHistoryPage> {
  List<MealPurchaseModel> purchasedMeal;
  final _apiCall = Api.instance;
  bool loaded = false;
  List<String> format = [hh, ':', nn, ' ', am, dd, ' ', 'M', ', ', yyyy];

  Widget dataField({String fieldName, String fieldValue}) {
    return Flexible(
        fit: FlexFit.loose,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Text(fieldName)),
              Expanded(child: Text(fieldValue)),
            ],
          ),
        ));
  }

  getData() async {
    purchasedMeal =
        await _apiCall.getMealPurchases().whenComplete(() => setState(() {
              loaded = true;
            }));
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return loaded
        ? ListView(
            shrinkWrap: true,
            children: List.generate(purchasedMeal.length, (index) {
              return Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                decoration: BoxDecoration(
                  color: white,
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                        fit: FlexFit.loose,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(child: Text('Menu Plan')),
                              Flexible(
                                  child: IconButton(
                                      icon: Icon(Icons.more_vert),
                                      onPressed: () {})),
                            ],
                          ),
                        )),
                    Flexible(
                        fit: FlexFit.loose,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(purchasedMeal[index].mealPlanName),
                        )),
                    dataField(
                      fieldName: 'Subscription:',
                      fieldValue: purchasedMeal[index].mealPlanDuration +
                          ' Days\n' +
                          purchasedMeal[index].showWeek(),
                    ),
                    dataField(
                      fieldName: 'Remaining Days:',
                      fieldValue: '12',
                    ),
                    Flexible(
                        fit: FlexFit.loose,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.schedule),
                              SizedBox(
                                width: 10,
                              ),
                              Text(formatDate(
                                  DateTime.parse(
                                      purchasedMeal[index].createdAt),
                                  format)),
                              Spacer(),
                              Text(purchasedMeal[index].amountPaid)
                            ],
                          ),
                        ))
                  ],
                ),
              );
            }),
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}
