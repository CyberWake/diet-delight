import 'dart:ui';

import 'package:diet_delight/Consultation/confirmConsultation.dart';
import 'package:diet_delight/konstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:intl/intl.dart';

class BookConsultation extends StatefulWidget {
  int package;

  BookConsultation({this.package});
  @override
  _BookConsultationState createState() => new _BookConsultationState();
}

class _BookConsultationState extends State<BookConsultation>
    with SingleTickerProviderStateMixin {
  String dropdownValue = 'One';
  DateTime newDateTime;
  DateTime firstDateTime;
  TabController _tabcontroller;
  double conHeight = 300.0;
  String selectedTime = '1pm';
  List<int> chosenTime = [];
  List<List> timeChart = [
    [9, 10, 11],
    [12, 1, 2, 3, 4],
    [5, 6, 7, 8]
  ];
  List<Widget> ddItems = [
    Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFF8080A1),
              Color(0xFFE0E0FF),
              Color(0xFFE8E8FF),
              Color(0xFFDFDFFF),
              Color(0xFF9999BA)
            ]),
      ),
      child: Padding(
          padding: EdgeInsets.fromLTRB(15, 3, 15, 3),
          child: Text(
            'SILVER',
            style: TextStyle(
              fontFamily: 'RobotoCondensedReg',
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          )),
    ),
    Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFFA3784B),
              Color(0xFFFEDF97),
              Color(0xFFFCE7B3),
              Color(0xFFFFDD8F),
              Color(0xFFBA9360)
            ]),
      ),
      child: Padding(
          padding: EdgeInsets.fromLTRB(15, 3, 15, 3),
          child: Text(
            'GOLD',
            style: TextStyle(
              fontFamily: 'RobotoCondensedReg',
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          )),
    ),
    Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFF808080),
              Color(0xFFE0E0E0),
              Color(0xFFE8E8E8),
              Color(0xFFDFDFDF),
              Color(0xFF999999)
            ]),
      ),
      child: Padding(
          padding: EdgeInsets.fromLTRB(15, 3, 15, 3),
          child: Text(
            'PLATINUM',
            style: TextStyle(
              fontFamily: 'RobotoCondensedReg',
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          )),
    )
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    newDateTime = new DateTime.now();
    firstDateTime = newDateTime.add(new Duration(days: 1));
    _tabcontroller = new TabController(length: 3, vsync: this);
    _tabcontroller.addListener(() {
      if (_tabcontroller.index == 0) {
        setState(() {
          conHeight = 200.0;
          print(conHeight);
        });
      } else if (_tabcontroller.index == 1) {
        setState(() {
          conHeight = 200.0;
          print(conHeight);
        });
      } else if (_tabcontroller.index == 2) {
        setState(() {
          conHeight = 200.0;
          print(conHeight);
        });
      } else {
        setState(() {
          conHeight = 200.0;
          print(conHeight);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double devWidth = MediaQuery.of(context).size.width;
    double devHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 20.0, 0, 0),
                      child: Icon(
                        Icons.keyboard_backspace,
                        size: 30.0,
                        color: defaultGreen,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 9,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25, top: 20.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Book an Appointment',
                        style: TextStyle(
                          fontFamily: 'RobotoCondensedReg',
                          fontSize: 24,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 30.0, 0, 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownButton<Widget>(
                          value: ddItems[widget.package],
                          elevation: 16,
                          onChanged: (Widget newValue) {
                            setState(() {
                              widget.package = ddItems.indexOf(newValue);
                            });
                          },
                          items: ddItems
                              .map<DropdownMenuItem<Widget>>((Widget value) {
                            return DropdownMenuItem<Widget>(
                              value: value,
                              child: value,
                            );
                          }).toList(),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 15.0, 0, 0),
                          child: Text(
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor.\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor.',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontFamily: 'RobotoCondensedReg',
                              fontSize: 11,
                              fontWeight: FontWeight.normal,
                              color: cardGray,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 40, 30, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Select appointment date',
                          style: TextStyle(
                            fontFamily: 'RobotoCondensedReg',
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            DateTime selectedDateTime =
                                await showRoundedDatePicker(
                                    context: context,
                                    background: Colors.white,
                                    styleDatePicker:
                                        MaterialRoundedDatePickerStyle(
                                      textStyleMonthYearHeader: TextStyle(
                                          fontSize: 18,
                                          color: defaultPurple,
                                          fontWeight: FontWeight.normal),
                                      paddingMonthHeader:
                                          EdgeInsets.only(top: 10),
                                      colorArrowNext: defaultPurple,
                                      colorArrowPrevious: defaultPurple,
                                      textStyleButtonPositive: TextStyle(
                                          fontSize: 14,
                                          color: defaultPurple,
                                          fontWeight: FontWeight.bold),
                                      textStyleButtonNegative: TextStyle(
                                          fontSize: 14,
                                          color: inactivePurple,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    theme: ThemeData(
                                      primaryColor: defaultPurple,
                                      accentColor: defaultGreen,
                                      dialogBackgroundColor: Colors.white,
                                      textTheme: TextTheme(
                                        body1: TextStyle(color: defaultPurple),
                                        caption:
                                            TextStyle(color: defaultPurple),
                                      ),
                                      disabledColor: formFill,
                                      accentTextTheme: TextTheme(
                                        body2: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    initialDate: firstDateTime,
                                    firstDate: firstDateTime);
                            setState(() {
                              firstDateTime = selectedDateTime;
                            });
//                            await makeRequest1(newDateTime);
                          },
                          child: Material(
                              elevation: 2.0,
                              borderRadius: BorderRadius.circular(2.0),
                              child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  child: Container(
                                    child: Text(
                                      DateFormat.E().format(firstDateTime) +
                                          ', ' +
                                          DateFormat.MMM()
                                              .add_d()
                                              .format(firstDateTime),
                                      style: TextStyle(
                                          fontFamily: 'RobotoCondensedReg',
                                          fontSize: 12,
                                          color: Color(0xFF303030)),
                                    ),
                                  ))),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Select preferred time slot',
                          style: TextStyle(
                            fontFamily: 'RobotoCondensedReg',
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
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
                            controller: _tabcontroller,
                            tabs: <Widget>[
                              Tab(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      Material(
                                          elevation: _tabcontroller.index == 0
                                              ? 0
                                              : 2.0,
                                          borderRadius:
                                              BorderRadius.circular(2.0),
                                          color: _tabcontroller.index == 0
                                              ? defaultGreen
                                              : Colors.white,
                                          child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5, horizontal: 15),
                                              child: Container(
                                                child: Text(
                                                  'Morning',
                                                  style: TextStyle(
                                                      fontFamily:
                                                          'RobotoCondensedReg',
                                                      fontSize: 12,
                                                      color: _tabcontroller
                                                                  .index ==
                                                              0
                                                          ? Colors.white
                                                          : Color(0xFF303030)),
                                                ),
                                              ))),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        '9am to 12pm',
                                        style: TextStyle(
                                            fontFamily: 'RobotoCondensedReg',
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal,
                                            color: _tabcontroller.index == 0
                                                ? defaultGreen
                                                : inactiveTime),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Tab(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      Material(
                                          elevation: _tabcontroller.index == 1
                                              ? 0
                                              : 2.0,
                                          borderRadius:
                                              BorderRadius.circular(2.0),
                                          color: _tabcontroller.index == 1
                                              ? defaultGreen
                                              : Colors.white,
                                          child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5, horizontal: 15),
                                              child: Container(
                                                child: Text(
                                                  'Afternoon',
                                                  style: TextStyle(
                                                      fontFamily:
                                                          'RobotoCondensedReg',
                                                      fontSize: 12,
                                                      color: _tabcontroller
                                                                  .index ==
                                                              1
                                                          ? Colors.white
                                                          : Color(0xFF303030)),
                                                ),
                                              ))),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        '12pm to 5pm',
                                        style: TextStyle(
                                            fontFamily: 'RobotoCondensedReg',
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal,
                                            color: _tabcontroller.index == 1
                                                ? defaultGreen
                                                : inactiveTime),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Tab(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      Material(
                                          elevation: _tabcontroller.index == 2
                                              ? 0
                                              : 2.0,
                                          borderRadius:
                                              BorderRadius.circular(2.0),
                                          color: _tabcontroller.index == 2
                                              ? defaultGreen
                                              : Colors.white,
                                          child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5, horizontal: 15),
                                              child: Container(
                                                child: Text(
                                                  'Evening',
                                                  style: TextStyle(
                                                      fontFamily:
                                                          'RobotoCondensedReg',
                                                      fontSize: 12,
                                                      color: _tabcontroller
                                                                  .index ==
                                                              2
                                                          ? Colors.white
                                                          : Color(0xFF303030)),
                                                ),
                                              ))),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        '5pm to 9pm',
                                        style: TextStyle(
                                            fontFamily: 'RobotoCondensedReg',
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal,
                                            color: _tabcontroller.index == 2
                                                ? defaultGreen
                                                : inactiveTime),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            width: double.infinity,
                            height: 200,
                            child: TabBarView(
                              controller: _tabcontroller,
                              children: <Widget>[
                                Container(
                                  height: 300.0,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        0, 20.0, 0, 0),
                                    child: ListView.builder(
                                      padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                                      itemCount: timeChart[0].length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder:
                                          (BuildContext context, int pos) {
                                        return Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.all(10),
                                              child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      chosenTime = [0, pos, 0];
                                                      selectedTime =
                                                          '${timeChart[0][pos]}pm';
                                                    });
                                                    print(selectedTime);
                                                    print(chosenTime);
                                                  },
                                                  child: Material(
                                                      elevation: 0,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              2.0),
                                                      color: listEquals(
                                                              chosenTime,
                                                              [0, pos, 0])
                                                          ? defaultGreen
                                                          : Colors.white,
//                                                  child:
//                                              InkWell(
//                                                      splashColor: defaultGreen
//                                                          .withAlpha(30),
//                                                      onTap: () {
//                                                        setState(() {
//                                                          chosenTime = [
//                                                            0,
//                                                            pos,
//                                                            0
//                                                          ];
//                                                          selectedTime =
//                                                              '${timeChart[0][pos]}pm';
//                                                        });
//                                                        print(selectedTime);
//                                                      },
                                                      child: Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 5,
                                                                  horizontal:
                                                                      10),
                                                          child: Container(
                                                            width: 40.0,
                                                            child: Text(
                                                              '${timeChart[0][pos]}pm',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'RobotoCondensedReg',
                                                                  fontSize: 11,
                                                                  color: listEquals(
                                                                          chosenTime,
                                                                          [
                                                                        0,
                                                                        pos,
                                                                        0
                                                                      ])
                                                                      ? Colors
                                                                          .white
                                                                      : Color(
                                                                          0xFF303030)),
                                                            ),
                                                          )))),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(10),
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    chosenTime = [0, pos, 1];
                                                    selectedTime =
                                                        '${timeChart[0][pos]}:15pm';
                                                  });
                                                },
                                                child: Material(
                                                    elevation: 0,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2.0),
                                                    color: listEquals(
                                                            chosenTime,
                                                            [0, pos, 1])
                                                        ? defaultGreen
                                                        : Colors.white,
                                                    child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 5,
                                                                horizontal: 10),
                                                        child: Container(
                                                          width: 40.0,
                                                          child: Text(
                                                            '${timeChart[0][pos]}:15pm',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'RobotoCondensedReg',
                                                                fontSize: 11,
                                                                color: listEquals(
                                                                        chosenTime,
                                                                        [
                                                                      0,
                                                                      pos,
                                                                      1
                                                                    ])
                                                                    ? Colors
                                                                        .white
                                                                    : Color(
                                                                        0xFF303030)),
                                                          ),
                                                        ))),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(10),
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    chosenTime = [0, pos, 2];
                                                    selectedTime =
                                                        '${timeChart[0][pos]}:30pm';
                                                  });
                                                },
                                                child: Material(
                                                    elevation: 0,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2.0),
                                                    color: listEquals(
                                                            chosenTime,
                                                            [0, pos, 2])
                                                        ? defaultGreen
                                                        : Colors.white,
                                                    child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 5,
                                                                horizontal: 10),
                                                        child: Container(
                                                          width: 40,
                                                          child: Text(
                                                            '${timeChart[0][pos]}:30pm',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'RobotoCondensedReg',
                                                                fontSize: 11,
                                                                color: listEquals(
                                                                        chosenTime,
                                                                        [
                                                                      0,
                                                                      pos,
                                                                      2
                                                                    ])
                                                                    ? Colors
                                                                        .white
                                                                    : Color(
                                                                        0xFF303030)),
                                                          ),
                                                        ))),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(10),
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    chosenTime = [0, pos, 3];
                                                    selectedTime =
                                                        '${timeChart[0][pos]}:45pm';
                                                  });
                                                },
                                                child: Material(
                                                    elevation: 0,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2.0),
                                                    color: listEquals(
                                                            chosenTime,
                                                            [0, pos, 3])
                                                        ? defaultGreen
                                                        : Colors.white,
                                                    child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 5,
                                                                horizontal: 10),
                                                        child: Container(
                                                          width: 40,
                                                          child: Text(
                                                            '${timeChart[0][pos]}:45pm',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'RobotoCondensedReg',
                                                                fontSize: 11,
                                                                color: listEquals(
                                                                        chosenTime,
                                                                        [
                                                                      0,
                                                                      pos,
                                                                      3
                                                                    ])
                                                                    ? Colors
                                                                        .white
                                                                    : Color(
                                                                        0xFF303030)),
                                                          ),
                                                        ))),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 300.0,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        0, 20.0, 0, 0),
                                    child: ListView.builder(
                                      padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                                      itemCount: timeChart[1].length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder:
                                          (BuildContext context, int pos) {
                                        return Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.all(10),
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    chosenTime = [1, pos, 0];
                                                    selectedTime =
                                                        '${timeChart[1][pos]}pm';
                                                  });
                                                },
                                                child: Material(
                                                    elevation: 0,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2.0),
                                                    color: listEquals(
                                                            chosenTime,
                                                            [1, pos, 0])
                                                        ? defaultGreen
                                                        : Colors.white,
                                                    child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 5,
                                                                horizontal: 10),
                                                        child: Container(
                                                          width: 40,
                                                          child: Text(
                                                            '${timeChart[1][pos]}pm',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'RobotoCondensedReg',
                                                                fontSize: 11,
                                                                color: listEquals(
                                                                        chosenTime,
                                                                        [
                                                                      1,
                                                                      pos,
                                                                      0
                                                                    ])
                                                                    ? Colors
                                                                        .white
                                                                    : Color(
                                                                        0xFF303030)),
                                                          ),
                                                        ))),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(10),
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    chosenTime = [1, pos, 1];
                                                    selectedTime =
                                                        '${timeChart[1][pos]}:15pm';
                                                  });
                                                },
                                                child: Material(
                                                    elevation: 0,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2.0),
                                                    color: listEquals(
                                                            chosenTime,
                                                            [1, pos, 1])
                                                        ? defaultGreen
                                                        : Colors.white,
                                                    child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 5,
                                                                horizontal: 10),
                                                        child: Container(
                                                          width: 40,
                                                          child: Text(
                                                            '${timeChart[1][pos]}:15pm',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'RobotoCondensedReg',
                                                                fontSize: 11,
                                                                color: listEquals(
                                                                        chosenTime,
                                                                        [
                                                                      1,
                                                                      pos,
                                                                      1
                                                                    ])
                                                                    ? Colors
                                                                        .white
                                                                    : Color(
                                                                        0xFF303030)),
                                                          ),
                                                        ))),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(10),
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    chosenTime = [1, pos, 2];
                                                    selectedTime =
                                                        '${timeChart[1][pos]}:30pm';
                                                  });
                                                },
                                                child: Material(
                                                    elevation: 0,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2.0),
                                                    color: listEquals(
                                                            chosenTime,
                                                            [1, pos, 2])
                                                        ? defaultGreen
                                                        : Colors.white,
                                                    child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 5,
                                                                horizontal: 10),
                                                        child: Container(
                                                          width: 40,
                                                          child: Text(
                                                            '${timeChart[1][pos]}:30pm',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'RobotoCondensedReg',
                                                                fontSize: 11,
                                                                color: listEquals(
                                                                        chosenTime,
                                                                        [
                                                                      1,
                                                                      pos,
                                                                      2
                                                                    ])
                                                                    ? Colors
                                                                        .white
                                                                    : Color(
                                                                        0xFF303030)),
                                                          ),
                                                        ))),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(10),
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    chosenTime = [1, pos, 3];
                                                    selectedTime =
                                                        '${timeChart[1][pos]}:45pm';
                                                  });
                                                },
                                                child: Material(
                                                    elevation: 0,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2.0),
                                                    color: listEquals(
                                                            chosenTime,
                                                            [1, pos, 3])
                                                        ? defaultGreen
                                                        : Colors.white,
                                                    child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 5,
                                                                horizontal: 10),
                                                        child: Container(
                                                          width: 40,
                                                          child: Text(
                                                            '${timeChart[1][pos]}:45pm',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'RobotoCondensedReg',
                                                                fontSize: 11,
                                                                color: listEquals(
                                                                        chosenTime,
                                                                        [
                                                                      1,
                                                                      pos,
                                                                      3
                                                                    ])
                                                                    ? Colors
                                                                        .white
                                                                    : Color(
                                                                        0xFF303030)),
                                                          ),
                                                        ))),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 300.0,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        0, 20.0, 0, 0),
                                    child: ListView.builder(
                                      padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                                      itemCount: timeChart[2].length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder:
                                          (BuildContext context, int pos) {
                                        return Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.all(10),
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    chosenTime = [2, pos, 0];
                                                    selectedTime =
                                                        '${timeChart[2][pos]}pm';
                                                  });
                                                },
                                                child: Material(
                                                    elevation: 0,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2.0),
                                                    color: listEquals(
                                                            chosenTime,
                                                            [2, pos, 0])
                                                        ? defaultGreen
                                                        : Colors.white,
                                                    child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 5,
                                                                horizontal: 10),
                                                        child: Container(
                                                          width: 40,
                                                          child: Text(
                                                            '${timeChart[2][pos]}pm',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'RobotoCondensedReg',
                                                                fontSize: 11,
                                                                color: listEquals(
                                                                        chosenTime,
                                                                        [
                                                                      2,
                                                                      pos,
                                                                      0
                                                                    ])
                                                                    ? Colors
                                                                        .white
                                                                    : Color(
                                                                        0xFF303030)),
                                                          ),
                                                        ))),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(10),
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    chosenTime = [2, pos, 1];
                                                    selectedTime =
                                                        '${timeChart[2][pos]}:15pm';
                                                  });
                                                },
                                                child: Material(
                                                    elevation: 0,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2.0),
                                                    color: listEquals(
                                                            chosenTime,
                                                            [2, pos, 1])
                                                        ? defaultGreen
                                                        : Colors.white,
                                                    child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 5,
                                                                horizontal: 10),
                                                        child: Container(
                                                          width: 40,
                                                          child: Text(
                                                            '${timeChart[2][pos]}:15pm',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'RobotoCondensedReg',
                                                                fontSize: 11,
                                                                color: listEquals(
                                                                        chosenTime,
                                                                        [
                                                                      2,
                                                                      pos,
                                                                      1
                                                                    ])
                                                                    ? Colors
                                                                        .white
                                                                    : Color(
                                                                        0xFF303030)),
                                                          ),
                                                        ))),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(10),
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    chosenTime = [2, pos, 2];
                                                    selectedTime =
                                                        '${timeChart[2][pos]}:30pm';
                                                  });
                                                },
                                                child: Material(
                                                    elevation: 0,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2.0),
                                                    color: listEquals(
                                                            chosenTime,
                                                            [2, pos, 2])
                                                        ? defaultGreen
                                                        : Colors.white,
                                                    child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 5,
                                                                horizontal: 10),
                                                        child: Container(
                                                          width: 40,
                                                          child: Text(
                                                            '${timeChart[2][pos]}:30pm',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'RobotoCondensedReg',
                                                                fontSize: 11,
                                                                color: listEquals(
                                                                        chosenTime,
                                                                        [
                                                                      2,
                                                                      pos,
                                                                      2
                                                                    ])
                                                                    ? Colors
                                                                        .white
                                                                    : Color(
                                                                        0xFF303030)),
                                                          ),
                                                        ))),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(10),
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    chosenTime = [2, pos, 3];
                                                    selectedTime =
                                                        '${timeChart[2][pos]}:45pm';
                                                  });
                                                },
                                                child: Material(
                                                    elevation: 0,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2.0),
                                                    color: listEquals(
                                                            chosenTime,
                                                            [2, pos, 3])
                                                        ? defaultGreen
                                                        : Colors.white,
                                                    child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 5,
                                                                horizontal: 10),
                                                        child: Container(
                                                          width: 40,
                                                          child: Text(
                                                            '${timeChart[2][pos]}:45pm',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'RobotoCondensedReg',
                                                                fontSize: 11,
                                                                color: listEquals(
                                                                        chosenTime,
                                                                        [
                                                                      2,
                                                                      pos,
                                                                      3
                                                                    ])
                                                                    ? Colors
                                                                        .white
                                                                    : Color(
                                                                        0xFF303030)),
                                                          ),
                                                        ))),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ),
//                                  Container(
//                                    height: 600.0,
//                                    child: Padding(
//                                      padding: const EdgeInsets.fromLTRB(
//                                          0, 20, 0, 0),
//                                      child: ListView(
//                                        shrinkWrap: true,
//                                        children: [],
//                                      ),
//                                    ),
//                                  ),
//                                  SizedBox(
//                                    height: 300.0,
//                                  ),
//                                  SizedBox(
//                                    height: 300.0,
//                                  ),
//                                  SizedBox(
//                                    height: 600.0,
//                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(50, 40, 50, 0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50.0,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ConfirmConsultation(
                                        package: widget.package,
                                        selectedDate: firstDateTime,
                                        consultationTime: selectedTime,
                                      )));
                        },
                        child: Text(
                          'NEXT',
                          style: TextStyle(
                            fontFamily: 'RobotoCondensedReg',
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                          ),
                        ),
                        style: TextButton.styleFrom(
                            backgroundColor: defaultGreen,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)))),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
