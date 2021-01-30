import 'package:cached_network_image/cached_network_image.dart';
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
  final List<MenuModel> menus;
  final List<MealModel> mealPlans;
  MealPlanPage({this.menus, this.mealPlans});
  @override
  _MealPlanPageState createState() => _MealPlanPageState();
}

class _MealPlanPageState extends State<MealPlanPage> {
  List<List<MenuCategoryModel>> categoryItems = List();
  List<List<MenuCategoryModel>> tempItems = List();
  List<MenuCategoryModel> temp = List();
  List<MenuModel> menus = List();
  final _apiCall = Api.instance;
  int menuId = 0;
  int weekSelectionIndex = 0;
  bool isLoaded = false;

  void initState() {
    super.initState();
    linkMealWithMenu();
  }

  linkMealWithMenu() {
    for (int j = 0; j < widget.mealPlans.length; j++) {
      for (int i = 0; i < widget.menus.length; i++) {
        if (widget.menus[i].id == widget.mealPlans[j].menuId) {
          menus.add(widget.menus[i]);
        }
      }
    }
    getMenuData().whenComplete(() {
      setState(() {
        isLoaded = true;
      });
    });
  }

  Future getMenuData() async {
    for (int i = 0; i < menus.length;) {
      categoryItems.insert(
          i, await _apiCall.getCategories(menus[i].id).whenComplete(() => i++));
    }
    for (int i = 0; i < categoryItems.length; i++) {
      temp = [];
      for (int j = 0; j < categoryItems[i].length; j++) {
        if (categoryItems[i][j].parent == 0) {
          temp.add(categoryItems[i][j]);
        }
      }
      tempItems.insert(i, temp);
    }
    categoryItems = tempItems;
    return true;
  }

  getCategories(index) {
    String displayCategories = '- ';
    categoryItems[index].forEach((element) {
      displayCategories += element.name + ', ';
    });
    return displayCategories;
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
      body: isLoaded
          ? ListView.builder(
              itemCount: widget.mealPlans.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  height: 355,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        widget.mealPlans[index].name,
                                        style: selectedTab.copyWith(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 20),
                                      ),
                                      Text(
                                        widget.mealPlans[index].price + ' BHD',
                                        style: selectedTab.copyWith(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 20),
                                      ),
                                      Text(widget.mealPlans[index].type == 0
                                          ? 'With Weekends'
                                          : 'Without Weekends'),
                                    ],
                                  )),
                              Expanded(
                                  flex: 9,
                                  child: Column(
                                    children: [
                                      Expanded(
                                          flex: 8,
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                widget.mealPlans[index].picture,
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              height: 30,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            placeholder: (context, url) =>
                                                CircularProgressIndicator(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                          )),
                                      SizedBox(height: 5),
                                      Expanded(
                                          flex: 2,
                                          child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    CupertinoPageRoute(
                                                        builder: (context) =>
                                                            Menu(
                                                              menu:
                                                                  menus[index],
                                                            )));
                                              },
                                              child: Text(
                                                'View Menu',
                                                style: TextStyle(
                                                  fontFamily:
                                                      'RobotoCondensedReg',
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
                                padding:
                                    const EdgeInsets.fromLTRB(10.0, 0, 10, 0),
                                child: Text(
                                  getCategories(index),
                                  style: selectedTab.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                            Flexible(
                              fit: FlexFit.loose,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10.0, 0, 10, 0),
                                child: Text(
                                  '- ' + menus[index].description,
                                  style: selectedTab.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          child: Center(
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) =>
                                            MealSubscriptionPage(
                                                categories: getCategories(index)
                                                    .toString()
                                                    .substring(1),
                                                mealPackage:
                                                    widget.mealPlans[index],
                                                weekDaysSelected: widget
                                                            .mealPlans[index]
                                                            .type ==
                                                        0
                                                    ? 7
                                                    : 5)));
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
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20)))),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}