import 'package:diet_delight/Models/foodItemModel.dart';
import 'package:diet_delight/konstants.dart';
import 'package:flutter/material.dart';

class MealPlan extends StatefulWidget {
  final int planDuration;
  MealPlan({this.planDuration});
  @override
  _MealPlanState createState() => _MealPlanState();
}

class _MealPlanState extends State<MealPlan>
    with SingleTickerProviderStateMixin {
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
    // TODO: implement initState
    super.initState();
    _pageController = TabController(length: widget.planDuration, vsync: this);
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
                          Text(
                            'Immune Booster',
                            style: TextStyle(
                              fontFamily: 'RobotoCondensedReg',
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
                  isScrollable: true,
                  controller: _pageController,
                  onTap: (index) {},
                  labelStyle: selectedTab,
                  indicatorColor: defaultGreen,
                  indicatorWeight: 3.0,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelColor: defaultGreen,
                  labelPadding: EdgeInsets.symmetric(horizontal: 10),
                  unselectedLabelStyle: unSelectedTab,
                  unselectedLabelColor: inactiveGreen,
                  tabs: List.generate(widget.planDuration, (index) {
                    return Tab(
                      text: 'Day ${(index + 1).toString()}',
                    );
                  }),
                ),
              ),
            ),
            Expanded(
              flex: 9,
              child: TabBarView(
                  controller: _pageController,
                  children: List.generate(widget.planDuration, (index) {
                    return Container(
                      child: menuUi(),
                    );
                  })),
            )
          ]),
        ));
  }

  Widget menuUi() {
    return ListView.separated(
      controller: _scrollController,
      shrinkWrap: true,
      itemCount: category.length,
      itemBuilder: (BuildContext context, int index) {
        List<FoodItemModel> items = category[index];
        return ExpansionTile(
          title: Text(
            time[index],
            style: selectedTab.copyWith(fontSize: 28),
          ),
          children: List.generate(items.length, (index) {
            return Container(
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
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: items[index].isVeg
                                    ? Colors.green
                                    : Colors.red[900],
                              ),
                            ),
                            child: Center(
                              child: CircleAvatar(
                                radius: 5,
                                backgroundColor: items[index].isVeg
                                    ? Colors.green
                                    : Colors.red[900],
                              ),
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
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0.0,
                          left: 0.0,
                          child: Container(
                              margin: EdgeInsets.only(right: 20),
                              decoration: authFieldDecoration,
                              child: FlutterLogo(
                                size: 80,
                              )),
                        ),
                        Positioned(
                          top: 70.0,
                          left: 8.0,
                          child: SizedBox(
                            width: 65,
                            height: 33,
                            child: TextButton(
                              onPressed: () async {},
                              child: Text('Select',
                                  style: selectedTab.copyWith(
                                      color: Colors.black)),
                              style: TextButton.styleFrom(
                                  backgroundColor: defaultGreen,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5)))),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          }),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          thickness: 1.5,
          color: Colors.black12,
        );
      },
    );
  }
}
