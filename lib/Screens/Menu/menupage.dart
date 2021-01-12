import 'package:diet_delight/konstants.dart';
import 'package:flutter/material.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController _scrollController = new ScrollController();
  final _pageController = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);
  List<String> time = ['Breakfast', 'Lunch', 'Dinner'];

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
          title: Text('Our Menu', style: appBarTextStyle),
        ),
        body: Container(
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 30),
                child: PageView.builder(
                    controller: _pageController,
                    itemCount: time.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        child: menuUi(time[index], [
                          'Veg. Burger',
                          'Chicken fajita Sandwich',
                          'Veg. Burger',
                          'Chicken fajita Sandwich',
                          'Veg. Burger',
                          'Chicken fajita Sandwich',
                          'Veg. Burger',
                          'Chicken fajita Sandwich',
                          'Veg. Burger',
                          'Chicken fajita Sandwich',
                          'Veg. Burger',
                          'Chicken fajita Sandwich'
                        ]),
                      );
                    },
                    onPageChanged: (int index) {
                      _currentPageNotifier.value = index;
                    }),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: CirclePageIndicator(
                      selectedDotColor: Colors.green,
                      dotColor: inactiveGreen,
                      itemCount: time.length,
                      currentPageNotifier: _currentPageNotifier,
                    )),
              )
            ],
          ),
        ));
  }

  Widget menuUi(String foodTime, List<String> items) {
    return Column(
      children: [
        Expanded(
            flex: 2,
            child: Center(
                child: Text(
              foodTime,
              style: appBarTextStyle,
            ))),
        Expanded(
          flex: 8,
          child: ListView.builder(
              controller: _scrollController,
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  onLongPress: () {
                    _scrollController
                        .jumpTo(_scrollController.position.maxScrollExtent);
                    showDialog<void>(
                      context: context,
                      // false = user must tap button, true = tap outside dialog
                      builder: (BuildContext dialogContext) {
                        return Material(
                          color: Colors.transparent,
                          child: Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: authFieldDecoration,
                                    child: FlutterLogo(
                                      size: double.infinity,
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.clear_sharp,
                                        size: 30,
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  leading: CircleAvatar(
                    backgroundColor: defaultGreen,
                    child: Center(
                      child: Text(
                        (index + 1).toString(),
                        style: TextStyle(color: white),
                      ),
                    ),
                  ),
                  title: Text(items[index]),
                );
              }),
        ),
      ],
    );
  }
}
