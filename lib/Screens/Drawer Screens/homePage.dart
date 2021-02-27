import 'package:cached_network_image/cached_network_image.dart';
import 'package:diet_delight/Models/export_models.dart';
import 'package:diet_delight/Screens/export.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:page_transition/page_transition.dart';

class HomeScreen extends StatefulWidget {
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

  @override
  void initState() {
    super.initState();
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
            print('called');
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                child:  Menu(
                  menu: menus[pos],
                ),
              ),
            );
            // Navigator.push(
            //     context,
            //     CupertinoPageRoute(
            //         builder: (context) => Menu(
            //               menu: menus[pos],
            //             )));

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
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
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
              PageTransition(
                type: PageTransitionType.fade,
                child:  MealPlanPage(
                    menus: menus, mealPlans: mealPackages[pos])
              ),
            );
            // Navigator.push(
            //     context,
            //     CupertinoPageRoute(
            //         builder: (context) => MealPlanPage(
            //             menus: menus, mealPlans: mealPackages[pos])));
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
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'RobotoCondensedReg',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
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
              PageTransition(
                  type: PageTransitionType.fade,
                  child:  BookConsultation(
                    packageIndex: pos,
                    consultation: consultationPackages,
                  ))
            );


            print('success getting consultation package screen');
          },
          child: Container(
            width: 130,
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
                  padding: EdgeInsets.fromLTRB(5.0, 0, 5, 0),
                  child: Text(
                    consultationPackages[pos].subtitle,
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
    return isLoaded
        ? ListView(
            shrinkWrap: true,
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
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical : 10.0),
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
                        padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                        child: Container(
                          height: 0.65 * devWidth,
                          child: ListView.builder(
                              itemCount: menus.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                return menuItemCard(index);
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
                        padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                        child: Container(
                          height: 0.55 * devWidth,
                          child: ListView.builder(
                              itemCount: durations.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                return mealPlanDurationCategoryCard(index);
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
                        padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                        child: Container(
                          height: 0.48 * devWidth,
                          child: ListView.builder(
                              itemCount: featuredMenu.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int pos) {
                                return Padding(
                                  padding: EdgeInsets.only(right: 15.0),
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
                                          width: 0.5 * devWidth,
                                          height: 220,
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
                                                    width: (0.5 * devWidth),
                                                    height:
                                                        (0.5 * devWidth) / 2,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.rectangle,
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
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 5),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.adjust,
                                                      size: 15,
                                                      color: defaultPurple,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    IconButton(
                                                        onPressed: () async {
                                                          setState(() {
                                                            favPressed.add(
                                                                featuredMenu[
                                                                        pos]
                                                                    .id);
                                                          });
                                                          int userId =
                                                              int.parse(Api
                                                                  .userInfo.id);
                                                          AddFavouritesModel
                                                              details =
                                                              AddFavouritesModel(
                                                            menuItemId:
                                                                featuredMenu[
                                                                        pos]
                                                                    .id,
                                                            userId: userId,
                                                          );
                                                          await _apiCall
                                                              .addFavourites(
                                                                  details);
                                                        },
                                                        icon: favourites[0].contains(
                                                                    featuredMenu[
                                                                            pos]
                                                                        .id) ||
                                                                favPressed.contains(
                                                                    featuredMenu[
                                                                            pos]
                                                                        .id)
                                                            ? Icon(
                                                                Icons.favorite,
                                                                size: 15,
                                                                color:
                                                                    defaultPurple,
                                                              )
                                                            : Icon(
                                                                Icons
                                                                    .favorite_border,
                                                                size: 15,
                                                                color:
                                                                    defaultPurple,
                                                              )),
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
                  padding: EdgeInsets.symmetric(vertical : 10.0,horizontal: 10),
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
                          padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                          child: Container(
                              height: 0.525 * devWidth,
                              child: ListView.builder(
                                itemCount: consultationPackages.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext context, int index) {
                                  return consultationItemCard(index);
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
        : Center(child: SpinKitDoubleBounce(color: defaultGreen));
  }
}
