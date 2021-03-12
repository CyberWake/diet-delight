import 'dart:async';
import 'dart:ui';

import 'package:diet_delight/Screens/Auth%20Screens/login_signup_form.dart';
import 'package:diet_delight/Screens/Drawer%20Screens/consutationOrdersPage.dart';
import 'package:diet_delight/Screens/Drawer%20Screens/contactUsPage.dart';
import 'package:diet_delight/Screens/Drawer%20Screens/dashboardOnGoingOrders.dart';
import 'package:diet_delight/Screens/Drawer%20Screens/dashboardUserInfoPage.dart';
import 'package:diet_delight/Screens/Drawer%20Screens/favouritesPage.dart';
import 'package:diet_delight/Screens/Drawer%20Screens/homePage.dart';
import 'package:diet_delight/Screens/Drawer%20Screens/mealPlanOrdersPage.dart';
import 'package:diet_delight/Screens/Drawer%20Screens/notificationsPage.dart';
import 'package:diet_delight/Screens/Drawer%20Screens/settingsFAQs.dart';
import 'package:diet_delight/Screens/Drawer%20Screens/settingsPrivacyPolicy.dart';
import 'package:diet_delight/Screens/Drawer%20Screens/settingsSecuritiesPage.dart';
import 'package:diet_delight/Screens/Drawer%20Screens/settingsTermsAndConditions.dart';
import 'package:diet_delight/Screens/coupon_code.dart';
import 'package:diet_delight/konstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final int openPage;
  final int tabIndex;
  final bool consultationScroll;
  HomePage(
      {this.openPage = 0, this.tabIndex = 0, this.consultationScroll = false});
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TabController _pageController1;
  TabController _pageController2;
  TabController _pageController3;

  int page = 0;
  String _platformVersion = 'Unknown';
  int selectedIndex = 0;
  List<String> drawerItems = [
    '',
    'Home',
    'Dashboard',
    'Favourites',
    'Order History',
    // 'Notifications',
    'Settings',
    'Contact Us',
    'Logout'
  ];
  List<Icon> drawerIcons = [
    Icon(Icons.roofing, size: 24, color: defaultGreen),
    Icon(Icons.dashboard, size: 24, color: defaultGreen),
    Icon(Icons.favorite, size: 24, color: defaultGreen),
    Icon(Icons.history, size: 24, color: defaultGreen),
    // Icon(Icons.notifications, size: 24, color: defaultGreen),
    Icon(Icons.settings, size: 24, color: defaultGreen),
    Icon(Icons.email, size: 24, color: defaultGreen),
    Icon(Icons.logout, size: 24, color: questionnaireSelect),
  ];

  List<List<String>> tabItemsTitle = [
    ['', ''],
    ['Profile', 'Ongoing Meal Plans'],
    [],
    ['Consultation Orders', 'Meal Plan Orders'],
    //[],
    [
      'Security',
      'Terms and Conditions',
      'FAQ',
      'Privacy Policy',
    ],
    [],
  ];

  List<String> pageTitle = [
    '',
    'Dashboard',
    'Favourites',
    'Order History',
    // 'Notifications',
    'Settings',
    'Contact Us'
  ];

  Size _textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion = await FlutterOpenWhatsapp.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    if (!mounted) return;
    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  void initState() {
    super.initState();
    page = widget.openPage;
    _pageController1 = TabController(length: 2, vsync: this);
    if (page == 1) {
      _pageController1.index = widget.tabIndex;
    }
    _pageController2 = TabController(length: 2, vsync: this);
    if (page == 3) {
      _pageController2.index = widget.tabIndex;
    }
    _pageController3 = TabController(length: 4, vsync: this);
    if (page == 4) {
      _pageController3.index = widget.tabIndex;
    }
    initPlatformState();
  }

  drawerOnTaps(int index) async {
    if (index == page) {
      Navigator.pop(context);
    } else if (index != 6) {
      Navigator.pop(context);
      setState(() {
        page = index;
      });
      print(page);
    }
    if (index == 6) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool result = await prefs.clear();
      if (result) {
        Navigator.of(context).pushReplacement(CupertinoPageRoute(
            builder: (BuildContext context) => AfterSplash()));
      } else {
        _scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text('Something went wrong')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: page == 3
            ? BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/order_history.jpg'),
                    fit: BoxFit.fitHeight),
              )
            : page == 2 || page == 4 || page == 5 || page == 1
                ? BoxDecoration(
                    image: DecorationImage(
                        image:
                            AssetImage('images/questionnaire_background.jpg'),
                        fit: BoxFit.fitHeight))
                : BoxDecoration(),
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor:
              page == 2 || page == 3 || page == 4 || page == 5 || page == 1
                  ? Colors.transparent
                  : white,
          appBar: AppBar(
            iconTheme: IconThemeData(
                color: page == 0 || page == 1 || page == 3 || page == 4
                    ? defaultGreen
                    : white),
            elevation: 2.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0))),
            bottomOpacity: 1,
            shadowColor: page == 1 || page == 3 || page == 4
                ? (Color(0x26000000))
                : Colors.transparent,
            backgroundColor: page == 0 || page == 1 || page == 3 || page == 4
                ? white
                : defaultGreen,
            centerTitle: page == 0 ? true : false,
            title: page == 0
                ? Image.asset(
                    'images/Group 57.png',
                    height: 50.0,
                    fit: BoxFit.fitHeight,
                  )
                : Text(pageTitle[page],
                    style: appBarTextStyle.copyWith(
                        fontFamily: 'RobotoReg',
                        color: page == 1 || page == 3 || page == 4
                            ? defaultGreen
                            : white,
                        fontWeight: FontWeight.bold)),
            leading: IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => _scaffoldKey.currentState.openDrawer(),
            ),
            actions: page == 0
                ? [
                    GestureDetector(
                      onTap: () {
                        FlutterOpenWhatsapp.sendSingleMessage(
                            "917259384025", "Hello");
                      },
                      child: Image.asset(
                        'images/Group 22.png',
                        width: 28.0,
                        height: 28.0,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (BuildContext context) =>
                                    CouponCode()));
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
                  ]
                : [],
            bottom: page == 1 || page == 3 || page == 4
                ? TabBar(
                    controller: page == 4
                        ? _pageController3
                        : page == 3
                            ? _pageController2
                            : _pageController1,
                    isScrollable: true,
                    onTap: (index) async {},
                    labelStyle: selectedTab.copyWith(
                        fontSize: 16,
                        color: defaultPurple,
                        fontWeight: FontWeight.w600),
                    indicatorColor: defaultGreen,
                    indicatorWeight: 3.0,
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: defaultPurple,
                    labelPadding: page == 3
                        ? EdgeInsets.symmetric(horizontal: 25)
                        : page == 1
                            ? EdgeInsets.symmetric(horizontal: 30)
                            : EdgeInsets.symmetric(horizontal: 15),
                    unselectedLabelStyle: unSelectedTab.copyWith(
                        fontSize: 16,
                        color: questionnaireDisabled,
                        fontWeight: FontWeight.w400),
                    unselectedLabelColor: questionnaireDisabled,
                    tabs: List.generate(tabItemsTitle[page].length, (index) {
                      return Tab(
                        text: tabItemsTitle[page][index],
                      );
                    }))
                : PreferredSize(child: Container(), preferredSize: Size(0, 0)),
            // bottom: page == 1 || page == 3 || page == 5
            //     ? TabBar(
            //         controller: page == 5
            //             ? _pageController3
            //             : page == 3
            //                 ? _pageController2
            //                 : _pageController1,
            //         isScrollable: true,
            //         onTap: (index) => setState(() => selectedIndex = index),
            //         labelStyle: selectedTab.copyWith(
            //             fontSize: 18,
            //             color: defaultPurple,
            //             fontWeight: FontWeight.w600),
            //         indicatorColor: white,
            //         indicatorWeight: 1.0,
            //         indicatorSize: TabBarIndicatorSize.tab,
            //         labelColor: defaultPurple,
            //         labelPadding: EdgeInsets.symmetric(horizontal: 13),
            //         unselectedLabelStyle: unSelectedTab.copyWith(
            //             fontSize: 18,
            //             color: questionnaireDisabled,
            //             fontWeight: FontWeight.w400),
            //         unselectedLabelColor: questionnaireDisabled,
            //         tabs: List.generate(tabItemsTitle[page].length, (index) {
            //           return Row(
            //             children: [
            //               Tab(
            //                 // text: tabItemsTitle[page][index],
            //
            //                 // text: tabItemsTitle[page][index],
            //                 child: Column(
            //                   children: [
            //                     SizedBox(height: 8),
            //                     Text(
            //                       tabItemsTitle[page][index],
            //                       style: TextStyle(fontSize: 16),
            //                     ),
            //                     SizedBox(height: 8),
            //                     selectedIndex == index
            //                         ? Container(
            //                             width: _textSize(
            //                                         tabItemsTitle[page][index],
            //                                         TextStyle(fontSize: 16))
            //                                     .width +
            //                                 4,
            //                             height: 3,
            //                             color: defaultGreen,
            //                           )
            //                         : Container(),
            //                   ],
            //                 ),
            //               ),
            //               SizedBox(
            //                   width: double.parse(index.toString()) !=
            //                           double.parse(
            //                               (tabItemsTitle[page].length - 1)
            //                                   .toString())
            //                       ? 100
            //                       : 0),
            //             ],
            //           );
            //         }))
            // ? TabBar(
            // controller: page == 5
            //     ? _pageController3
            //     : page == 3
            //     ? _pageController2
            //     : _pageController1,
            // isScrollable: true,
            // onTap: (index) async {},
            // labelStyle: selectedTab.copyWith(
            //     fontSize: 18,
            //     color: defaultPurple,
            //     fontWeight: FontWeight.w600),
            // indicatorColor: defaultGreen,
            // indicatorWeight: 3.0,
            // indicatorSize: TabBarIndicatorSize.tab,
            // labelColor: defaultPurple,
            // labelPadding: EdgeInsets.symmetric(horizontal: 13),
            // unselectedLabelStyle: unSelectedTab.copyWith(
            //     fontSize: 18,
            //     color: questionnaireDisabled,
            //     fontWeight: FontWeight.w400),
            // unselectedLabelColor: questionnaireDisabled,
            // tabs: List.generate(tabItemsTitle[page].length, (index) {
            //   return Tab(
            //     text: tabItemsTitle[page][index],
            //   );
            // }))
            // : PreferredSize(child: Container(), preferredSize: Size(0, 0)),
          ),
          drawer: ClipRRect(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0)),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.75,
              child: Drawer(
                child: Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.01),
                  child: ListView(
                      shrinkWrap: true,
                      children: List.generate(drawerItems.length, (index) {
                        if (index == 0) {
                          print('called');
                          return Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.03,
                                bottom:
                                    MediaQuery.of(context).size.height * 0.05),
                            child: Image.asset(
                              'images/Group 57.png',
                              height: 80.0,
                              fit: BoxFit.fitHeight,
                            ),
                          );
                        } else if (index == drawerItems.length - 1) {
                          return Padding(
                              padding: EdgeInsets.only(
                                  top: index + 1 == drawerItems.length
                                      ? MediaQuery.of(context).size.height * 0.1
                                      : 0.0),
                              child: ListTile(
                                  onTap: () {
                                    drawerOnTaps(index - 1);
                                  },
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        drawerItems[index],
                                        style: drawerItemsStyle,
                                      ),
                                      SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.02),
                                      drawerIcons[index - 1],
                                    ],
                                  )));
                        }
                        return Padding(
                          padding: EdgeInsets.only(
                              top: index + 1 == drawerItems.length ? 50 : 0.0),
                          child: ListTile(
                              onTap: () {
                                drawerOnTaps(index - 1);
                              },
                              leading: drawerIcons[index - 1],
                              title: Text(
                                drawerItems[index],
                                style: drawerItemsStyle,
                              )),
                        );
                      })),
                ),
              ),
            ),
          ),
          body: IndexedStack(
            index: page,
            children: [
              HomeScreen(consultationScroll: widget.consultationScroll),
              TabBarView(controller: _pageController1, children: [
                DashBoardUserInfoPage(snackBarKey: _scaffoldKey),
                DashBoardOngoingOrders(),
              ]),
              FavouritesPage(),
              TabBarView(controller: _pageController2, children: [
                ConsultationOrderHistoryPage(),
                MealPlanOrderHistoryPage()
              ]),
              // NotificationsPage(),
              TabBarView(
                controller: _pageController3,
                children: [
                  SettingSecurities(snackBarKey: _scaffoldKey),
                  SettingsTermsAndConditionsPage(),
                  SettingsFAQPage(),
                  SettingsPrivacyPolicyPage(),
                ],
              ),
              ContactUsPage(),
            ],
          ),
        ),
      ),
    );
  }
}
