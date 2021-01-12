import 'package:diet_delight/Models/foodItemModel.dart';
import 'package:diet_delight/konstants.dart';
import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController _scrollController = new ScrollController();
  TabController _pageController;
  List<String> time = ['Breakfast', 'Lunch', 'Dinner'];
  List<List<FoodItemModel>> category = [
    [
      FoodItemModel(isVeg: true, foodName: 'Crunchy Chickpea Salad'),
      FoodItemModel(isVeg: true, foodName: 'Crunchy Chickpea Salad'),
      FoodItemModel(isVeg: true, foodName: 'Crunchy Chickpea Salad'),
    ],
    [
      FoodItemModel(isVeg: false, foodName: 'Crunchy Chickpea Salad'),
      FoodItemModel(isVeg: false, foodName: 'Crunchy Chickpea Salad'),
      FoodItemModel(isVeg: false, foodName: 'Crunchy Chickpea Salad'),
    ],
    [
      FoodItemModel(isVeg: false, foodName: 'Crunchy Chickpea Salad'),
      FoodItemModel(isVeg: true, foodName: 'Crunchy Chickpea Salad'),
      FoodItemModel(isVeg: false, foodName: 'Crunchy Chickpea Salad'),
    ]
  ];

  void initState() {
    super.initState();
    _pageController = TabController(length: time.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.grey[300],
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
          title: Text('Menu Packages', style: appBarTextStyle),
        ),
        body: Container(
          child: Column(children: [
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 7,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Immune Booster',
                              style: selectedTab.copyWith(fontSize: 28)),
                          Text(
                              'sgasdfjijadfigfadjfvadsfiluHFIUDSBFS\nADIUAGFIGF')
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 3,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 10,
                              color: Colors.grey[500],
                              spreadRadius: 1,
                              offset: const Offset(5.0, 10.0),
                            )
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 45,
                        ),
                      ))
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: TabBar(
                  controller: _pageController,
                  onTap: (index) {},
                  labelStyle: selectedTab.copyWith(fontSize: 24),
                  indicatorColor: defaultGreen,
                  indicatorWeight: 3.0,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelColor: defaultGreen,
                  labelPadding: EdgeInsets.symmetric(horizontal: 13),
                  unselectedLabelStyle: unSelectedTab.copyWith(fontSize: 20),
                  unselectedLabelColor: inactiveGreen,
                  tabs: List.generate(3, (index) {
                    return Tab(
                      text: time[index],
                    );
                  }),
                ),
              ),
            ),
            Expanded(
              flex: 9,
              child: TabBarView(
                  controller: _pageController,
                  children: List.generate(time.length, (index) {
                    return Container(
                      child: menuUi(category[index]),
                    );
                  })),
            )
          ]),
        ));
  }

  Widget menuUi(List<FoodItemModel> items) {
    return ListView.builder(
        controller: _scrollController,
        shrinkWrap: true,
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {},
            child: Container(
              height: 120,
              child: Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: items[index].isVeg
                                      ? Colors.green
                                      : Colors.red[900]),
                            ),
                            child: Center(
                              child: CircleAvatar(
                                  radius: 7,
                                  backgroundColor: items[index].isVeg
                                      ? Colors.green
                                      : Colors.red[900]),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            items[index].foodName,
                            style: appBarTextStyle,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Container(
                            alignment: Alignment.bottomRight,
                            padding: EdgeInsets.only(right: 10),
                            child: IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.favorite_border)),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                        margin: EdgeInsets.only(right: 20),
                        decoration: authFieldDecoration,
                        child: FlutterLogo(
                          size: 60,
                        )),
                  )
                ],
              ),
            ),
          );
        });
  }
}
