import 'package:diet_delight/Models/mealModel.dart';
import 'package:diet_delight/Models/menuCategoryModel.dart';
import 'package:diet_delight/Models/menuModel.dart';
import 'package:diet_delight/Screens/MealPlans/mealSubscriptionPage.dart';
import 'package:diet_delight/Screens/Menu/menupage.dart';
import 'package:diet_delight/konstants.dart';
import 'package:diet_delight/services/apiCalls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MealPlanPage extends StatefulWidget {
  final MenuModel menu;
  final MealModel mealPlan;
  MealPlanPage({this.menu, this.mealPlan});
  @override
  _MealPlanPageState createState() => _MealPlanPageState();
}

class _MealPlanPageState extends State<MealPlanPage> {
  List<MenuCategoryModel> categoryItems = List();
  List<MenuCategoryModel> tempItems = List();
  final _apiCall = Api.instance;
  int menuId = 0;
  int weekSelectionIndex = 0;
  bool isLoaded = false;
  List<Widget> week = List.generate(
    2,
    (index) => Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            //colors: [white, white]
          ),
      ),
      child: Padding(
          padding: EdgeInsets.fromLTRB(15, 3, 15, 3),
          child: Text(
            index == 0 ? 'With Weekends' : 'Without Weekends',
            style: TextStyle(
              fontFamily: 'RobotoCondensedReg',
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          )),
    ),
  );

  void initState() {
    super.initState();
    menuId = widget.menu.id;
    getData();
  }

  getCategories() {
    String displayCategories = '- ';
    categoryItems.forEach((element) {
      displayCategories += element.name + ', ';
    });
    return displayCategories;
  }

  getData() async {
    await getMenuCategories(menuId);
  }

  getMenuCategories(int menuId) async {
    categoryItems = [];
    setState(() {
      isLoaded = false;
    });
    categoryItems = await _apiCall.getCategories(menuId);
    categoryItems.forEach((element) {
      if (element.parent == 0) {
        tempItems.add(element);
      }
    });
    categoryItems = [];
    categoryItems = tempItems;
    setState(() {
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: white,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.keyboard_backspace,
            size: 30.0,
            color: defaultGreen,
          ),
        ),
        title: Text('Choose your mean plan', style: appBarTextStyle),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(20, 20, 20, 150),
        padding: EdgeInsets.symmetric(horizontal: 10),
        width: double.infinity,
        height: 335,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              color: Colors.black.withAlpha(63),
              spreadRadius: 0,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0),
                child: Row(
                  children: [
                    Expanded(
                        flex: 11,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.menu.name,
                              style: selectedTab.copyWith(
                                  fontWeight: FontWeight.w400, fontSize: 20),
                            ),
                            Text(
                              widget.mealPlan.price + ' BHD',
                              style: selectedTab.copyWith(
                                  fontWeight: FontWeight.w400, fontSize: 20),
                            ),
                            DropdownButton<Widget>(
                              isExpanded: false,
                              dropdownColor: defaultGreen,
                              value: week[weekSelectionIndex],
                              elevation: 16,
                              onChanged: (Widget newValue) {
                                setState(() {
                                  print(week.indexOf(newValue));
                                  weekSelectionIndex = week.indexOf(newValue);
                                });
                              },
                              items: week.map<DropdownMenuItem<Widget>>(
                                  (Widget value) {
                                return DropdownMenuItem<Widget>(
                                  value: value,
                                  child: value,
                                );
                              }).toList(),
                            ),
                          ],
                        )),
                    Expanded(
                        flex: 9,
                        child: Column(
                          children: [
                            Expanded(
                                flex: 8,
                                child: Container(
                                    height: 80,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: Image.network(
                                        widget.mealPlan.picture))),
                            SizedBox(height: 5),
                            Expanded(
                                flex: 2,
                                child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (context) => Menu(
                                                    menu: widget.menu,
                                                  )));
                                    },
                                    child: Text(
                                      'View Menu',
                                      style: TextStyle(
                                        fontFamily: 'RobotoCondensedReg',
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        color: defaultGreen,
                                      ),
                                    )))
                          ],
                        ))
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    fit: FlexFit.loose,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 0, 10, 0),
                      child: Text(
                        getCategories(),
                        style: selectedTab.copyWith(
                            fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 0, 10, 0),
                      child: Text(
                        '- ' + widget.menu.description,
                        style: selectedTab.copyWith(
                            fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.18,
                    left: MediaQuery.of(context).size.width * 0.18,
                    bottom: 15),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: defaultGreen,
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => MealSubscriptionPage(
                                  mealPackage: widget.mealPlan,
                                  weekDaysSelected:
                                      weekSelectionIndex == 0 ? 7 : 5)));
                    },
                    child: Text(
                      'Buy Subscription',
                      style: TextStyle(
                        fontFamily: 'RobotoCondensedReg',
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: white,
                      ),
                    ),
                    style: TextButton.styleFrom(
                        backgroundColor: defaultGreen,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20)))),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
