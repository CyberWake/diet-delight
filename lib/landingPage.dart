import 'dart:async';
import 'dart:ui';
import 'package:diet_delight/Screens/export.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final int openPage;
  final int tabIndex;
  HomePage({this.openPage = 0, this.tabIndex = 0});
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
  List<String> drawerItems = [
    '',
    'Home',
    'Dashboard',
    'Favourites',
    'Order History',
    'Notifications',
    'Settings',
    'Contact Us',
    'Logout'
  ];

  List<List<String>> tabItemsTitle = [
    ['', ''],
    ['Profile', 'Ongoing Meal Plans'],
    [],
    ['Consultation Orders', 'Meal Plan Orders'],
    [],
    ['Security', 'Terms and Conditions', 'FAQ', 'Privacy Policy'],
    [],
  ];

  List<String> pageTitle = [
    '',
    'Dashboard',
    'Favourites',
    'Order History',
    'Notifications',
    'Settings',
    'Contact Us'
  ];

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
    if (page == 5) {
      _pageController3.index = widget.tabIndex;
    }
    initPlatformState();
  }

  drawerOnTaps(int index) async {
    if (index == page) {
      Navigator.pop(context);
    } else if (index != 7) {
      Navigator.pop(context);
      setState(() {
        page = index;
      });
      print(page);
    }
    if (index == 7) {
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
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(color: defaultGreen),
          elevation: 0.0,
          backgroundColor: white,
          centerTitle: true,
          title: page == 0
              ? Image.asset(
                  'images/Group 57.png',
                  height: 50.0,
                  fit: BoxFit.fitHeight,
                )
              : Text(pageTitle[page], style: appBarTextStyle),
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
                    width: 10,
                  ),
                  // GestureDetector(
                  //   onTap: () {
                  //     Navigator.push(
                  //         context,
                  //         CupertinoPageRoute(
                  //             builder: (BuildContext context) => CouponCode()));
                  //   },
                  //   child: Image.asset(
                  //     'images/Group 24.png',
                  //     width: 25.0,
                  //     height: 25.0,
                  //   ),
                  // ),
                  // SizedBox(
                  //   width: 10,
                  // ),
                ]
              : [],
          bottom: page == 1 || page == 3 || page == 5
              ? TabBar(
                  controller: page == 5
                      ? _pageController3
                      : page == 3
                          ? _pageController2
                          : _pageController1,
                  isScrollable: true,
                  onTap: (index) async {},
                  labelStyle: selectedTab.copyWith(
                      fontSize: 18,
                      color: defaultGreen,
                      fontWeight: FontWeight.w600),
                  indicatorColor: defaultGreen,
                  indicatorWeight: 3.0,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: defaultGreen,
                  labelPadding: EdgeInsets.symmetric(horizontal: 13),
                  unselectedLabelStyle: unSelectedTab.copyWith(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w400),
                  unselectedLabelColor: Colors.grey,
                  tabs: List.generate(tabItemsTitle[page].length, (index) {
                    return Tab(
                      text: tabItemsTitle[page][index],
                    );
                  }))
              : PreferredSize(child: Container(), preferredSize: Size(0, 0)),
        ),
        drawer: ClipRRect(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0)),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.65,
            child: Drawer(
              child: Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.01),
                child: ListView(
                    shrinkWrap: true,
                    children: List.generate(drawerItems.length, (index) {
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
                        padding: EdgeInsets.only(
                            top: index + 1 == drawerItems.length ? 50 : 0.0),
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
          ),
        ),
        body: IndexedStack(
          index: page,
          children: [
            HomeScreen(),
            TabBarView(controller: _pageController1, children: [
              DashBoardUserInfoPage(snackBarKey: _scaffoldKey),
              DashBoardOngoingOrders(),
            ]),
            FavouritesPage(),
            TabBarView(controller: _pageController2, children: [
              ConsultationOrderHistoryPage(),
              MealPlanOrderHistoryPage()
            ]),
            NotificationsPage(),
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
    );
  }
}
