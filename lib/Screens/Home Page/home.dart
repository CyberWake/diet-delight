import 'dart:async';
import 'dart:ui';

import 'package:diet_delight/Models/consultationModel.dart';
import 'package:diet_delight/Models/mealModel.dart';
import 'package:diet_delight/Models/menuModel.dart';
import 'package:diet_delight/Screens/Auth%20Screens/login_signup_form.dart';
import 'package:diet_delight/Screens/Consultation/bookConsultation.dart';
import 'package:diet_delight/Screens/MealSubscription/mealPlanScreen.dart';
import 'package:diet_delight/Screens/MealSubscription/mealSelection.dart';
import 'package:diet_delight/konstants.dart';
import 'package:diet_delight/services/apiCalls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'file:///C:/Users/VK/Desktop/ritik/diet-delight-mobile/lib/Screens/menupage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoaded = false;
  int page = 0;
  final _apiCall = Api.instance;
  List<ConsultationModel> consultationPackages;
  List<MenuModel> menus;
  List<MealModel> mealPackages;
  List<String> drawerItems = [
    '',
    'Home',
    'Dashboard',
    'Settings',
    'Order History',
    'Logout'
  ];

  Future testApiData() async {
    consultationPackages = await _apiCall.getConsultationPackages();

    mealPackages = await _apiCall.getMealPlans();
    print('mealPlans: ${mealPackages.length}');
    menus = await _apiCall.getMenuPackages();
  }

  @override
  void initState() {
    testApiData().whenComplete(() {
      setState(() {
        isLoaded = true;
      });
    });
    super.initState();
  }

  drawerOnTaps(int index) async {
    print(index);
    if (index == page) {
      Navigator.pop(context);
    } else if (index != 4) {
      Navigator.pop(context);
      setState(() {
        page = index;
      });
      print(page);
    }
    if (index == 4) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool result = await prefs.clear();
      if (result) {
        Navigator.of(context).pushReplacement(CupertinoPageRoute(
            builder: (BuildContext context) => AfterSplash()));
      } else {
        print('fdsuf');
      }
    }
  }

  getMenu(int mealPlanIndex) {
    MenuModel menu;
    menus.forEach((eachMenu) {
      if (eachMenu.id == mealPackages[mealPlanIndex].menuId) {
        menu = eachMenu;
      }
    });
    return menu;
  }

  @override
  Widget build(BuildContext context) {
    double devWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        drawer: Drawer(
          child: Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
            child: ListView(
                children: List.generate(6, (index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Image.asset(
                    'images/Group 57.png',
                    height: 80.0,
                    fit: BoxFit.fitHeight,
                  ),
                );
              }
              return Padding(
                padding: EdgeInsets.only(top: 5.0),
                child: ListTile(
                    onTap: () {
                      drawerOnTaps(index - 1);
                    },
                    title: Center(
                        child: Text(
                      drawerItems[index],
                      style: selectedTab.copyWith(
                          fontWeight: FontWeight.normal, fontSize: 28),
                    ))),
              );
            })),
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          iconTheme: IconThemeData(color: defaultGreen),
          title: Image.asset(
            'images/Group 57.png',
            height: 50.0,
            fit: BoxFit.fitHeight,
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (BuildContext context) => MealPlan(
                              planDuration: mealPackages[0].duration,
                              mealPlanName: mealPackages[0].name,
                              mealPlanDisc: mealPackages[0].details,
                              index: 0,
                            )));
              },
              child: Image.asset(
                'images/Group 22.png',
                width: 25.0,
                height: 25.0,
              ),
            ),
            SizedBox(
              width: 20,
            ),
            GestureDetector(
              onTap: () {
                //Navigator.pop(context);
              },
              child: Image.asset(
                'images/Group 24.png',
                width: 25.0,
                height: 25.0,
              ),
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
        body: IndexedStack(
          index: page,
          children: [
            isLoaded
                ? ListView(
                    shrinkWrap: true,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 30.0, 0, 20.0),
                        child: Container(
                          height: 125,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: formBackground,
                            border: Border(
                                bottom:
                                    BorderSide(width: 1.0, color: formLinks)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                color: defaultPurple,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      18.0, 3.0, 3.0, 3.0),
                                  child: Text(
                                    'SPECIAL OFFER',
                                    style: TextStyle(
                                      fontFamily: 'RobotoCondensedReg',
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(18, 10, 0, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'FAMILY PACKAGE',
                                      style: TextStyle(
                                          fontFamily: 'RobotoCondensedReg',
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          shadows: [
                                            Shadow(
                                                // bottomLeft
                                                offset: Offset(0.75, 0.75),
                                                color: Colors.black),
                                            Shadow(
                                                // bottomRight
                                                offset: Offset(0.75, 0.75),
                                                color: Colors.black),
                                            Shadow(
                                                // topRight
                                                offset: Offset(0.75, 0.75),
                                                color: Colors.black),
                                            Shadow(
                                                // topLeft
                                                offset: Offset(0.75, 0.75),
                                                color: Colors.black),
                                          ]),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'OUR MENU PACKAGE',
                                    style: TextStyle(
                                      fontFamily: 'RobotoCondensedReg',
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: defaultPurple,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                    child: Container(
                                      width: 60,
                                      height: 3,
                                      color: defaultGreen,
                                    ),
                                  )
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(20, 20, 10, 10),
                                child: Container(
                                  height: 0.6 * devWidth,
                                  child: ListView.builder(
                                      itemCount: menus.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder:
                                          (BuildContext context, int pos) {
                                        return Padding(
                                          padding: EdgeInsets.only(right: 15.0),
                                          child: Material(
                                            elevation: 0.0,
                                            shadowColor: Colors.white,
                                            child: InkWell(
                                              splashColor:
                                                  defaultGreen.withAlpha(30),
                                              onTap: () {
                                                print('Card tapped.');
                                                Navigator.push(
                                                    context,
                                                    CupertinoPageRoute(
                                                        builder: (context) =>
                                                            Menu(
                                                              menu: menus[pos],
                                                            )));
                                              },
                                              child: Container(
                                                color: Colors.white,
                                                width: 110,
                                                height: 220,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          bottom: 10.0),
                                                      child: CircleAvatar(
                                                        radius: 35,
                                                        child: Image.asset(
                                                          'images/Ellipse 3.png',
                                                        ),
                                                        backgroundColor:
                                                            Colors.white,
                                                      ),
                                                    ),
                                                    Column(
                                                      children: [
                                                        Text(
                                                          menus[pos].name,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'RobotoCondensedReg',
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                defaultPurple,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  0, 3, 0, 0),
                                                          child: Container(
                                                            width: 40,
                                                            height: 2,
                                                            color: defaultGreen,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 10.0),
                                                      child: Text(
                                                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor.',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'RobotoCondensedReg',
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: cardGray,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          20, 20, 20, 10),
                                                      child: Container(
                                                        width: double.infinity,
                                                        decoration: BoxDecoration(
                                                            color: defaultGreen,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            5))),
                                                        height: 25,
                                                        child: Center(
                                                          child: Text(
                                                            'VIEW MENU',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'RobotoCondensedReg',
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        decoration: new BoxDecoration(
                          image: new DecorationImage(
                            image: new AssetImage('images/Group 7.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'CHOOSE YOUR MEAL PLAN',
                                    style: TextStyle(
                                      fontFamily: 'RobotoCondensedReg',
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: defaultPurple,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                    child: Container(
                                      width: 60,
                                      height: 3,
                                      color: defaultGreen,
                                    ),
                                  )
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(15, 20, 10, 10),
                                child: Container(
                                  height: 0.48 * devWidth,
                                  child: ListView.builder(
                                      itemCount: mealPackages.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder:
                                          (BuildContext context, int pos) {
                                        return Padding(
                                          padding: EdgeInsets.only(right: 15.0),
                                          child: Material(
                                            elevation: 0.0,
                                            shadowColor: Colors.white,
                                            child: InkWell(
                                              splashColor:
                                                  defaultGreen.withAlpha(30),
                                              onTap: () {
                                                print(
                                                    'Card tapped: ${mealPackages[pos].menuId}');
                                                MenuModel pass = getMenu(pos);
                                                if (pass != null) {
                                                  Navigator.push(
                                                      context,
                                                      CupertinoPageRoute(
                                                          builder: (context) =>
                                                              MealPlanPage(
                                                                  menu: pass,
                                                                  mealPlan:
                                                                      mealPackages[
                                                                          pos])));
                                                }
                                              },
                                              child: Container(
                                                color: defaultGreen,
                                                width: 120,
                                                height: 220,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 10.0,
                                                                bottom: 10.0),
                                                        child: Text(
                                                          mealPackages[pos]
                                                                  .duration
                                                                  .toString() +
                                                              ' days',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'RobotoCondensedReg',
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
                                                          ),
                                                        )),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          bottom: 10.0),
                                                      child: Text(
                                                        mealPackages[pos].name,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'RobotoCondensedReg',
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 10.0),
                                                      child: Text(
                                                        mealPackages[pos]
                                                            .subtitle,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'RobotoCondensedReg',
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          20, 20, 20, 10),
                                                      child: Container(
                                                        width: double.infinity,
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            5))),
                                                        height: 25,
                                                        child: Center(
                                                          child: Text(
                                                            'SUBSCRIPTION',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'RobotoCondensedReg',
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  defaultGreen,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              ),
                              SizedBox(
                                height: 50,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'FEATURED MENU OF THE WEEK',
                                    style: TextStyle(
                                      fontFamily: 'RobotoCondensedReg',
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: defaultPurple,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                    child: Container(
                                      width: 60,
                                      height: 3,
                                      color: defaultGreen,
                                    ),
                                  )
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(20, 20, 10, 10),
                                child: Container(
                                  height: 0.45 * devWidth,
                                  child: ListView.builder(
                                      itemCount: 5,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder:
                                          (BuildContext context, int pos) {
                                        return Padding(
                                          padding: EdgeInsets.only(right: 15.0),
                                          child: Material(
                                            elevation: 0.0,
                                            shadowColor: Colors.white,
                                            child: Card(
                                              child: InkWell(
                                                splashColor:
                                                    defaultGreen.withAlpha(30),
                                                onTap: () {
                                                  print('Card tapped.');
                                                },
                                                child: Container(
                                                  color: Colors.white,
                                                  width: 0.4 * devWidth,
                                                  height: 220,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                5.0,
                                                                5.0,
                                                                5.0,
                                                                5.0),
                                                        child: Image.asset(
                                                          'images/Group 26.png',
                                                          width:
                                                              (0.4 * devWidth),
                                                          height:
                                                              (0.4 * devWidth) /
                                                                  2,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                5.0, 0, 5.0, 0),
                                                        child: Text(
                                                          'Honey garlic Chicken Stir Fry',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'RobotoCondensedReg',
                                                            fontSize: 11,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: defaultGreen,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 20.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                              Icons.adjust,
                                                              size: 15,
                                                              color:
                                                                  defaultPurple,
                                                            ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Icon(
                                                              Icons
                                                                  .favorite_border,
                                                              size: 15,
                                                              color:
                                                                  defaultPurple,
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        decoration: new BoxDecoration(
                          image: new DecorationImage(
                            image: new AssetImage('images/Group 4.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'CONSULTATION PACKAGE',
                                    style: TextStyle(
                                      fontFamily: 'RobotoCondensedReg',
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: defaultPurple,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                    child: Container(
                                      width: 60,
                                      height: 3,
                                      color: defaultGreen,
                                    ),
                                  )
                                ],
                              ),
                              Padding(
                                  padding: EdgeInsets.fromLTRB(20, 20, 10, 0),
                                  child: Container(
                                      height: 0.525 * devWidth,
                                      child: ListView.builder(
                                        itemCount: consultationPackages.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Padding(
                                            padding:
                                                EdgeInsets.only(right: 15.0),
                                            child: Material(
                                              elevation: 0.0,
                                              shadowColor: Colors.white,
                                              child: InkWell(
                                                splashColor:
                                                    defaultGreen.withAlpha(30),
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      CupertinoPageRoute(
                                                          builder: (context) =>
                                                              BookConsultation(
                                                                packageIndex:
                                                                    index,
                                                                consultation:
                                                                    consultationPackages,
                                                              )));
                                                },
                                                child: Container(
                                                  width: 110,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(
                                                          width: 2.0,
                                                          color: defaultGreen)),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  bottom: 10.0,
                                                                  top: 10),
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              gradient: LinearGradient(
                                                                  begin: Alignment
                                                                      .centerLeft,
                                                                  end: Alignment
                                                                      .centerRight,
                                                                  colors:
                                                                      itemColors[
                                                                          index]),
                                                            ),
                                                            child: Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .fromLTRB(
                                                                            15,
                                                                            3,
                                                                            15,
                                                                            3),
                                                                child: Text(
                                                                  consultationPackages[
                                                                          index]
                                                                      .name,
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'RobotoCondensedReg',
                                                                    fontSize:
                                                                        11,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                )),
                                                          )),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                5.0, 10, 5, 0),
                                                        child: Text(
                                                          consultationPackages[
                                                                  index]
                                                              .details,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'RobotoCondensedReg',
                                                            fontSize: 11,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color: cardGray,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                5.0, 10, 5, 0),
                                                        child: Text(
                                                          consultationPackages[
                                                                  index]
                                                              .price,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'RobotoCondensedReg',
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: defaultGreen,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                20, 10, 20, 10),
                                                        child: Container(
                                                          width:
                                                              double.infinity,
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  defaultGreen,
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          5))),
                                                          height: 25,
                                                          child: Center(
                                                            child: Text(
                                                              'BOOK YOUR APPOINTMENT',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'RobotoCondensedReg',
                                                                fontSize: 8,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ))),
                              SizedBox(
                                height: 100.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : Center(child: CircularProgressIndicator()),
            Container(
              color: Colors.red,
            ),
            Container(
              color: Colors.red,
            ),
            Container(
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
