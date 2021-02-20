import 'package:diet_delight/Screens/export.dart';
import 'package:diet_delight/konstants.dart';
import 'package:flutter/material.dart';

class AfterSplash extends StatefulWidget {
  @override
  _AfterSplashState createState() => new _AfterSplashState();
}

class _AfterSplashState extends State<AfterSplash>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  double conHeight = 300.0;
  String accessToken;

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double devHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: _tabController.index == 0 ? false : true,
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
                  indicatorColor: defaultGreen,
                  //indicatorPadding: EdgeInsets.symmetric(horizontal: 50),
                  indicatorWeight: 3.0,
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
                        child: index == 0 ? Text('SIGN IN') : Text('SIGN UP'));
                  })),
            ),
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
          ],
        ),
      ),
    );
  }
}
