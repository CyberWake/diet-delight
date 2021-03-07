import 'package:cached_network_image/cached_network_image.dart';
import 'package:diet_delight/Models/addFavouritesModel.dart';
import 'package:diet_delight/Models/consultationModel.dart';
import 'package:diet_delight/Models/foodItemModel.dart';
import 'package:diet_delight/Models/mealModel.dart';
import 'package:diet_delight/Models/mealPlanDurationsModel.dart';
import 'package:diet_delight/Models/menuModel.dart';
import 'package:diet_delight/Screens/Consultation/selectConsultationMode.dart';
import 'package:diet_delight/Screens/MealPlans/mealPlanSelectionScreen.dart';
import 'package:diet_delight/Screens/Menu/menupage.dart';
import 'package:diet_delight/konstants.dart';
import 'package:diet_delight/services/apiCalls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  final bool consultationScroll;

  HomeScreen({this.consultationScroll});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _apiCall = Api.instance;
  List<ConsultationModel> consultationPackages = List();
  List<DurationModel> durations = List();
  List<MenuModel> menus = List();
  List<FoodItemModel> featuredMenu = List();
  List<List<MealModel>> mealPackages = List();
  List<List> favourites = List();
  List<int> favPressed = List();
  bool isLoaded = false;
  bool favEnabled = true;
  ScrollController _scrollController = new ScrollController();

  Future testApiData() async {
    consultationPackages = await _apiCall.getConsultationPackages();
    featuredMenu = await _apiCall.getFeaturedMenuItems();
    favourites = await _apiCall.getFavourites();
    menus = await _apiCall.getMenuPackages();
    durations = await _apiCall.getDurations();
    for (int i = 0; i < durations.length;) {
      List<MealModel> meal = await _apiCall
          .getMealPlanWithDuration(durations[i].id)
          .whenComplete(() => i++);
      mealPackages.add(meal);
    }
  }

  getFavourites() async {
    favourites = await _apiCall.getFavourites();
  }

  @override
  void initState() {
    super.initState();
    // if (widget.consultationScroll == true) {
    //   _scrollController.animateTo(_scrollController.position.maxScrollExtent,
    //       duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
    // }
    testApiData().whenComplete(() {
      if (mounted) {
        setState(() {
          isLoaded = true;
        });
      }
    });
  }

  Widget menuItemCard(int pos) {
    return Padding(
      padding: EdgeInsets.only(right: 15.0),
      child: Material(
        elevation: 0.0,
        shadowColor: Colors.white,
        child: InkWell(
          splashColor: defaultGreen.withAlpha(30),
          onTap: () {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => Menu(
                          menu: menus[pos],
                        )));

            print('success getting menu screen');
          },
          child: Container(
            color: Colors.white,
            width: 130,
            height: 250,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    child: CachedNetworkImage(
                      imageUrl: menus[pos].picture ??
                          "http://via.placeholder.com/350x150",
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) => SpinKitChasingDots(
                        color: defaultPurple,
                        size: 32,
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      menus[pos].name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'RobotoCondensedReg',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: defaultPurple,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 3, 0, 0),
                      child: Container(
                        width: 40,
                        height: 2,
                        color: defaultGreen,
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    menus[pos].description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'RobotoCondensedReg',
                      fontSize: 11,
                      fontWeight: FontWeight.normal,
                      color: cardGray,
                    ),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: defaultGreen,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    height: 25,
                    child: Center(
                      child: Text(
                        'VIEW MENU',
                        style: TextStyle(
                          fontFamily: 'RobotoCondensedReg',
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
  }

  Widget mealPlanDurationCategoryCard(int pos) {
    return Padding(
      padding: EdgeInsets.only(right: 15.0),
      child: Material(
        elevation: 0.0,
        shadowColor: Colors.white,
        child: InkWell(
          splashColor: defaultGreen.withAlpha(30),
          onTap: () {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => MealPlanPage(
                        menus: menus, mealPlans: mealPackages[pos])));
            print('success getting meal details page');
          },
          child: Container(
            color: defaultGreen,
            width: 120,
            height: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0,left: 10,right: 10),
                    child: Text(
                      durations[pos].title,
                      style: TextStyle(
                        fontFamily: 'RobotoCondensedReg',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    )),
                durations[pos].subTitle == null
                    ? SizedBox()
                    : Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          durations[pos].subTitle ?? 'Not Provided',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'RobotoCondensedReg',
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                Flexible(
                  fit: FlexFit.loose,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(5, 10.0, 5, 0),
                    child: Text(
                      durations[pos].details,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'RobotoCondensedReg',
                        fontSize: 11,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 15),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    height: 25,
                    child: Center(
                      child: Text(
                        'SUBSCRIPTION',
                        style: TextStyle(
                          fontFamily: 'RobotoCondensedReg',
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: defaultGreen,
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
  }

  Widget consultationItemCard(int pos) {
    return Padding(
      padding: EdgeInsets.only(right: 15.0),
      child: Material(
        elevation: 0.0,
        shadowColor: Colors.white,
        child: InkWell(
          splashColor: defaultGreen.withAlpha(30),
          onTap: () {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => SelectConsultationMode(
                          packageIndex: pos,
                          consultation: consultationPackages,
                        )));
            print('success getting consultation package screen');
          },
          child: Container(
            width: 140,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 2.0, color: defaultGreen)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                    padding: EdgeInsets.only(bottom: 15, top: 15),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: itemColors[pos]),
                      ),
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(15, 3, 15, 3),
                          child: Text(
                            consultationPackages[pos].name,
                            style: TextStyle(
                              fontFamily: 'RobotoCondensedReg',
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          )),
                    )),
                Padding(
                  padding: EdgeInsets.fromLTRB(10.0, 0, 10, 0),
                  child: Column(
//                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        consultationPackages[pos].subtitle,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: 'RobotoCondensedReg',
                          fontSize: 11,
                          fontWeight: FontWeight.normal,
                          color: cardGray,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        consultationPackages[pos].details,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: 'RobotoCondensedReg',
                          fontSize: 11,
                          fontWeight: FontWeight.normal,
                          color: cardGray,
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Padding(
                  padding: EdgeInsets.fromLTRB(5.0, 0, 5, 0),
                  child: Text(
                    consultationPackages[pos].price + ' BHD',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'RobotoCondensedReg',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: defaultGreen,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 15),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: defaultGreen,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    height: 25,
                    child: Center(
                      child: Text(
                        'BOOK YOUR APPOINTMENT',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'RobotoCondensedReg',
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
  }

  @override
  Widget build(BuildContext context) {
    double devWidth = MediaQuery.of(context).size.width;
    double devHeight = MediaQuery.of(context).size.height;
    widget.consultationScroll == true
        ? Timer(
            Duration(milliseconds: 100),
            () => _scrollController
                .jumpTo(_scrollController.position.maxScrollExtent))
        : null;
    return isLoaded
        ? ListView(
            shrinkWrap: true,
            controller: _scrollController,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 20.0),
                child: Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('images/banner.jpg'),
                        fit: BoxFit.fitWidth),
                    color: formBackground,
                    border: Border(
                        bottom: BorderSide(width: 1.0, color: formLinks)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        color: defaultPurple,
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(18.0, 3.0, 3.0, 3.0),
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
                        padding: const EdgeInsets.fromLTRB(18, 10, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'FAMILY \nPACKAGE',
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
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                      child: Container(
                        height: 0.65 * devWidth,
                        child: ListView.builder(
                            itemCount: menus.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: menuItemCard(index),
                              );
                            }),
                      ),
                    )
                  ],
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
                  padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 10.0),
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
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                        child: Container(
                          height: 0.55 * devWidth,
                          child: ListView.builder(
                              itemCount: durations.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: mealPlanDurationCategoryCard(index),
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
                  padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 10.0),
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
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                        child: Container(
                          height: 0.49 * devWidth,
                          child: ListView.builder(
                              itemCount: featuredMenu.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int pos) {
                                return Padding(
                                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Material(
                                    elevation: 0.0,
                                    shadowColor: Colors.white,
                                    child: Card(
                                      child: InkWell(
                                        splashColor: defaultGreen.withAlpha(30),
                                        onTap: () {
                                          print('Card tapped.');
                                        },
                                        child: Container(
                                          color: Colors.white,
                                          width: 0.43 * devWidth,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(5),
                                                child: CachedNetworkImage(
                                                  imageUrl: featuredMenu[pos]
                                                          .picture ??
                                                      "http://via.placeholder.com/350x150",
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      Container(
                                                    width: (0.43 * devWidth),
                                                    height:
                                                        (0.44 * devWidth) / 2,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.rectangle,
                                                      image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  placeholder: (context, url) =>
                                                      SpinKitChasingDots(
                                                          size: 32,
                                                          color: defaultPurple),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          FlutterLogo(
                                                    size: 60,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(5),
                                                child: Text(
                                                  featuredMenu[pos].foodName,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'RobotoCondensedReg',
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.bold,
                                                    color: defaultGreen,
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.adjust,
                                                    size: 18,
                                                    color: defaultPurple,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  favPressed.contains(
                                                              featuredMenu[
                                                                      pos]
                                                                  .id) ||
                                                          favourites[0]
                                                              .contains(
                                                                  featuredMenu[
                                                                          pos]
                                                                      .id)
                                                      ? IconButton(
                                                          onPressed:
                                                              favEnabled ==
                                                                      false
                                                                  ? null
                                                                  : () async {
                                                                      int removeIndex =
                                                                          favourites[0].indexOf(featuredMenu[pos].id);
                                                                      setState(
                                                                          () {
                                                                        favEnabled =
                                                                            false;
                                                                        favPressed
                                                                            .remove(featuredMenu[pos].id);
                                                                      });
//                                                              print(favourites[
//                                                                      0]
//                                                                  .indexWhere((f) => f
//                                                                      .featuredMenu[
//                                                                          pos]
//                                                                      .id));
                                                                      await _apiCall.deleteFavourites(favourites[1]
                                                                          [
                                                                          removeIndex]);
                                                                      setState(
                                                                          () {
                                                                        getFavourites();
                                                                        favEnabled =
                                                                            true;
                                                                      });
                                                                    },
                                                          icon: Icon(
                                                              Icons.favorite,
                                                              size: 18,
                                                              color:
                                                                  defaultPurple))
                                                      : IconButton(
                                                          onPressed:
                                                              favEnabled ==
                                                                      false
                                                                  ? null
                                                                  : () async {
                                                                      setState(
                                                                          () {
                                                                        favEnabled =
                                                                            false;
                                                                        favPressed
                                                                            .add(featuredMenu[pos].id);
                                                                      });
                                                                      int userId = int.parse(Api
                                                                          .userInfo
                                                                          .id);
                                                                      AddFavouritesModel
                                                                          details =
                                                                          AddFavouritesModel(
                                                                        menuItemId:
                                                                            featuredMenu[pos].id,
                                                                        userId:
                                                                            userId,
                                                                      );
                                                                      await _apiCall
                                                                          .addFavourites(details);
                                                                      setState(
                                                                          () {
                                                                        getFavourites();
                                                                        favEnabled =
                                                                            true;
                                                                      });
                                                                    },
                                                          icon: Icon(
                                                            Icons
                                                                .favorite_border,
                                                            size: 18,
                                                            color:
                                                                defaultPurple,
                                                          )),
                                                ],
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
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
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
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: Container(
                              height: 0.37 * devHeight,
                              child: ListView.builder(
                                itemCount: consultationPackages.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: consultationItemCard(index),
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
        : Center(
            child: SpinKitThreeBounce(
              color: defaultPurple,
              size: 32,
            ),
          );
  }
}
