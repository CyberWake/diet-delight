import 'package:diet_delight/Auth%20Screens/login_screen.dart';
import 'package:diet_delight/Auth%20Screens/signup_screen.dart';
import 'package:diet_delight/konstants.dart';
import 'package:diet_delight/services/obtainToken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AfterSplash extends StatefulWidget {
  @override
  _AfterSplashState createState() => new _AfterSplashState();
}

class _AfterSplashState extends State<AfterSplash>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  double conHeight = 300.0;
  final storage = FlutterSecureStorage();
  String accessToken;

  getToken() async {
    accessToken = await ObtainToken().fetchToken();
    print("This is the accessToken in main");
    print(accessToken);
  }

  @override
  void initState() {
    //getToken();
    _tabController = new TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.index == 0) {
        setState(() {
          conHeight = 300.0;
          print(conHeight);
        });
      } else if (_tabController.index == 1) {
        setState(() {
          conHeight = 600.0;
          print(conHeight);
        });
      } else {
        setState(() {
          conHeight = 300.0;
          print(conHeight);
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double devHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: [
            SizedBox(
              height: 10.0,
            ),
            Center(
                child: Image.asset(
              'images/Group 57.png',
              width: 120.0,
              height: 50.0,
            )),
            SizedBox(
              height: 25.0,
            ),
            Container(
              width: 300,
              child: TabBar(
                  labelStyle: TextStyle(
                    fontFamily: 'RobotoCondensedReg',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  indicatorColor: Colors.transparent,
                  indicatorWeight: 1.0,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelColor: defaultGreen,
                  labelPadding: EdgeInsets.symmetric(horizontal: 13),
                  unselectedLabelStyle: TextStyle(
                    fontFamily: 'RobotoCondensedReg',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelColor: inactiveGreen,
                  controller: _tabController,
                  tabs: List.generate(2, (index) {
                    return Tab(
                      child: Align(
                        alignment: index == 0
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.only(
                            bottom: 3, // space between underline and text
                          ),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                            color: _tabController.index == index
                                ? defaultGreen
                                : Colors.transparent, // Text colour here
                            width: 4.0, // Underline width
                          ))),
                          child: index == 0 ? Text('SIGN IN') : Text('SIGN UP'),
                        ),
                      ),
                    );
                  })),
            ),
            ListView(shrinkWrap: true, children: [
              Container(
                margin: EdgeInsets.all(10.0),
                width: double.infinity,
                height: 3 * devHeight / 4,
                decoration: BoxDecoration(
                  color: formBackground,
                ),
                child: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    Login(token: accessToken),
                    SignUp(token: accessToken),
                  ],
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
