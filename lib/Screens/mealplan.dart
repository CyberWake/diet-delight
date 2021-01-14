import 'package:diet_delight/Models/foodItemModel.dart';
import 'package:diet_delight/konstants.dart';
import 'package:flutter/material.dart';

class MealPlan extends StatefulWidget {
  final int planDuration;
  final int index;
  final String mealPlanName;
  final String mealPlanDisc;
  MealPlan(
      {this.index, this.planDuration, this.mealPlanDisc, this.mealPlanName});
  @override
  _MealPlanState createState() => _MealPlanState();
}

class _MealPlanState extends State<MealPlan>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController _scrollController = new ScrollController();
  TabController _pageController;
  int planIndex = 0;
  List<String> time = ['Breakfast', 'Lunch', 'Dinner'];
  List<List<FoodItemModel>> category = [
    [
      FoodItemModel(
          isVeg: true, foodName: 'Crunchy Chickpea Salad', isSelected: true),
      FoodItemModel(
          isVeg: true, foodName: 'Crunchy Chickpea Salad', isSelected: false),
      FoodItemModel(
          isVeg: true, foodName: 'Crunchy Chickpea Salad', isSelected: false),
    ],
    [
      FoodItemModel(
          isVeg: true, foodName: 'Crunchy Chickpea Salad', isSelected: false),
      FoodItemModel(
          isVeg: true, foodName: 'Crunchy Chickpea Salad', isSelected: true),
      FoodItemModel(
          isVeg: true, foodName: 'Crunchy Chickpea Salad', isSelected: false),
    ],
    [
      FoodItemModel(
          isVeg: true, foodName: 'Crunchy Chickpea Salad', isSelected: false),
      FoodItemModel(
          isVeg: true, foodName: 'Crunchy Chickpea Salad', isSelected: false),
      FoodItemModel(
          isVeg: true, foodName: 'Crunchy Chickpea Salad', isSelected: true),
    ]
  ];

  void initState() {
    super.initState();
    planIndex = widget.index;
    _pageController = TabController(length: widget.planDuration, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: white,
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
          title: Text('Meal Plan', style: appBarTextStyle),
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
                            widget.mealPlanName,
                            style: TextStyle(
                              fontFamily: 'RobotoCondensedReg',
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.mealPlanDisc,
                            style: authInputTextStyle.copyWith(
                                fontSize: 20, color: Colors.black),
                          )
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
                              blurRadius: 4,
                              color: Colors.grey[500],
                              spreadRadius: 0,
                              offset: const Offset(0.0, 0.0),
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
              child: DropdownButton<Widget>(
                value: mealPlanDropdownItems[planIndex],
                elevation: 16,
                onChanged: (Widget newValue) {
                  setState(() {
                    print(mealPlanDropdownItems.indexOf(newValue));
                    planIndex = mealPlanDropdownItems.indexOf(newValue);
                  });
                },
                items: mealPlanDropdownItems
                    .map<DropdownMenuItem<Widget>>((Widget value) {
                  return DropdownMenuItem<Widget>(
                    value: value,
                    child: value,
                  );
                }).toList(),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 4,
                      color: Colors.black.withOpacity(0.25),
                      spreadRadius: 0,
                      offset: const Offset(0.0, 0.0),
                    )
                  ],
                ),
                child: TabBar(
                  isScrollable: true,
                  controller: _pageController,
                  onTap: (index) {},
                  labelStyle: selectedTab.copyWith(color: Colors.black),
                  indicatorColor: Colors.transparent,
                  indicatorWeight: 3.0,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelColor: Colors.black,
                  labelPadding: EdgeInsets.symmetric(horizontal: 10),
                  unselectedLabelStyle:
                      unSelectedTab.copyWith(color: Colors.grey),
                  unselectedLabelColor: Colors.grey,
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
      itemBuilder: (BuildContext context, int indexMajor) {
        List<FoodItemModel> items = category[indexMajor];
        return ExpansionTile(
          title: Text(
            time[indexMajor],
            style: selectedTab.copyWith(fontSize: 28),
          ),
          children: List.generate(items.length + 1, (index) {
            if (index == 3) {
              return Column(
                children: [
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      'Let us know if there is something you’d want us to know about your menu, we’ll pass it on to the chef.',
                      style: authInputTextStyle.copyWith(
                          fontSize: 20, color: Colors.black),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.all(15),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      height: MediaQuery.of(context).size.height * 0.15,
                      decoration: BoxDecoration(
                        color: white,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 4,
                            color: Colors.black.withOpacity(0.25),
                            spreadRadius: 0,
                            offset: const Offset(0.0, 0.0),
                          )
                        ],
                      ),
                      child: TextFormField(
                        decoration: authInputFieldDecoration.copyWith(
                            hintText: 'Enter your note here'),
                      )),
                ],
              );
            }
            return Container(
              height: 110,
              margin: EdgeInsets.symmetric(horizontal: 10),
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
                            height: 15,
                            width: 15,
                            child: Image.asset(
                              items[index].isVeg
                                  ? 'images/veg.png'
                                  : 'images/nonVeg.png',
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            items[index].foodName,
                            style: appBarTextStyle.copyWith(fontSize: 20),
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
                          left: 3.5,
                          child: SizedBox(
                            width: 75,
                            height: 33,
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 4,
                                    color: Colors.black.withOpacity(0.25),
                                    spreadRadius: 0,
                                    offset: const Offset(0.0, 0.0),
                                  )
                                ],
                              ),
                              child: TextButton(
                                onPressed: () async {
                                  for (int i = 0; i < items.length; i++) {
                                    category[indexMajor][i].change(false);
                                  }
                                  setState(() {
                                    category[indexMajor][index].change(true);
                                  });
                                },
                                child: Text(
                                    items[index].isSelected
                                        ? 'Selected'
                                        : 'Select',
                                    style: selectedTab.copyWith(
                                        color: items[index].isSelected
                                            ? white
                                            : defaultGreen,
                                        fontSize: 16)),
                                style: TextButton.styleFrom(
                                  backgroundColor: items[index].isSelected
                                      ? defaultGreen
                                      : white,
                                ),
                              ),
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
