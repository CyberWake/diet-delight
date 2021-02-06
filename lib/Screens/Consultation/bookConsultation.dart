import 'dart:ui';

import 'package:date_format/date_format.dart';
import 'package:diet_delight/Models/consultationModel.dart';
import 'package:diet_delight/Screens/Consultation/confirmConsultation.dart';
import 'package:diet_delight/konstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:intl/intl.dart';

class BookConsultation extends StatefulWidget {
  final int packageIndex;
  final List<ConsultationModel> consultation;

  BookConsultation({this.packageIndex, this.consultation});
  @override
  _BookConsultationState createState() => new _BookConsultationState();
}

class _BookConsultationState extends State<BookConsultation>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int consultationIndex;
  List<String> format = [yyyy, '-', mm, '-', dd];
  String dropdownValue = 'One';
  DateTime today;
  DateTime dateSelected;
  TabController _tabController;
  double conHeight = 300.0;
  String selectedTime = '1PM';
  String time;
  String date;
  List<List> timeChart = [
    [9, 10, 11],
    [12, 1, 2],
    [3, 4, 5]
  ];

  getSubTime(int index, int rowIndex) {
    String suffix;
    if (index == 0) {
      suffix = 'AM';
    } else {
      suffix = 'PM';
    }
    switch (rowIndex) {
      case 0:
        return ':00$suffix';
        break;
      case 1:
        return ':15$suffix';
        break;
      case 2:
        return ':30$suffix';
        break;
      case 3:
        return ':45$suffix';
        break;
    }
  }

  String showSlots(int index, int pos, int rowIndex) {
    String suffix;
    String displayTime;
    if (index == 0) {
      suffix = 'AM';
    } else {
      suffix = 'PM';
    }
    switch (rowIndex) {
      case 0:
        displayTime = '${timeChart[index][pos]}:00$suffix';
        break;
      case 1:
        displayTime = '${timeChart[index][pos]}:15$suffix';
        break;
      case 2:
        displayTime = '${timeChart[index][pos]}:30$suffix';
        break;
      case 3:
        displayTime = '${timeChart[index][pos]}:45$suffix';
        break;
      default:
        return "null";
    }
    return displayTime;
  }

  @override
  void initState() {
    super.initState();
    today = new DateTime.now().add(Duration(days: 2));
    dateSelected = today;
    date = formatDate(dateSelected, format);
    _tabController = new TabController(length: 3, vsync: this);
    consultationIndex = widget.packageIndex;
    _tabController.addListener(() {
      if (_tabController.index == 0) {
        setState(() {
          conHeight = 200.0;
          print(conHeight);
        });
      } else if (_tabController.index == 1) {
        setState(() {
          conHeight = 200.0;
          print(conHeight);
        });
      } else if (_tabController.index == 2) {
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
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
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
          title: Text('Book an Appointment', style: appBarTextStyle),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButton<Widget>(
                      value: ddItems[consultationIndex],
                      elevation: 16,
                      onChanged: (Widget newValue) {
                        setState(() {
                          print(ddItems.indexOf(newValue));
                          consultationIndex = ddItems.indexOf(newValue);
                        });
                      },
                      items:
                          ddItems.map<DropdownMenuItem<Widget>>((Widget value) {
                        return DropdownMenuItem<Widget>(
                          value: value,
                          child: value,
                        );
                      }).toList(),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 15.0, 0, 0),
                      child: Text(
                        widget.consultation[consultationIndex].details,
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
                        DateTime selectedDateTime = await showRoundedDatePicker(
                            context: context,
                            background: Colors.white,
                            styleDatePicker: MaterialRoundedDatePickerStyle(
                              textStyleMonthYearHeader: TextStyle(
                                  fontSize: 18,
                                  color: defaultPurple,
                                  fontWeight: FontWeight.normal),
                              paddingMonthHeader: EdgeInsets.only(top: 10),
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
                                caption: TextStyle(color: defaultPurple),
                              ),
                              disabledColor: formFill,
                              accentTextTheme: TextTheme(),
                            ),
                            initialDate: dateSelected ?? today,
                            firstDate: today.subtract(Duration(days: 1)));
                        setState(() {
                          dateSelected = selectedDateTime ?? dateSelected;
                          date = formatDate(dateSelected, format);
                        });
                        print(date);
                      },
                      child: Material(
                          elevation: 2.0,
                          borderRadius: BorderRadius.circular(2.0),
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              child: Container(
                                child: Text(
                                  DateFormat.E().format(dateSelected ?? today) +
                                      ', ' +
                                      DateFormat.MMM()
                                          .add_d()
                                          .format(dateSelected ?? today),
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
                padding: EdgeInsets.fromLTRB(30, 20, 30, 0),
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
                          indicatorColor: Colors.transparent,
                          indicatorWeight: 1.0,
                          indicatorSize: TabBarIndicatorSize.label,
                          labelColor: defaultGreen,
                          labelPadding: EdgeInsets.symmetric(horizontal: 13),
                          unselectedLabelColor: inactiveGreen,
                          controller: _tabController,
                          tabs: List.generate(3, (index) {
                            return Tab(
                              child: Align(
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    Material(
                                        elevation: _tabController.index == index
                                            ? 0.0
                                            : 2.0,
                                        borderRadius:
                                            BorderRadius.circular(2.0),
                                        color: _tabController.index == index
                                            ? defaultGreen
                                            : Colors.white,
                                        child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 15),
                                            child: Container(
                                              child: Text(
                                                index == 0
                                                    ? 'Morning'
                                                    : index == 1
                                                        ? 'Afternoon'
                                                        : 'Evening',
                                                style: tabTextStyle.copyWith(
                                                    color: _tabController
                                                                .index ==
                                                            index
                                                        ? Colors.white
                                                        : Color(0xFF303030)),
                                              ),
                                            ))),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                        index == 0
                                            ? '9AM to 12PM'
                                            : index == 1
                                                ? '12PM to 3PM'
                                                : '3PM to 6PM',
                                        style: dateTabTextStyle.copyWith(
                                            color: _tabController.index == index
                                                ? defaultGreen
                                                : inactiveTime)),
                                  ],
                                ),
                              ),
                            );
                          })),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: double.infinity,
                        height: 200,
                        child: TabBarView(
                            controller: _tabController,
                            children: List.generate(3, (index) {
                              return Container(
                                height: 300.0,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 20.0, 0, 0),
                                  child: ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                                    itemCount: timeChart[index].length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder:
                                        (BuildContext context, int pos) {
                                      return Column(
                                          children:
                                              List.generate(4, (rowIndex) {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 20),
                                          child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  time =
                                                      '${timeChart[index][pos]}${getSubTime(index, rowIndex)}';
                                                  print(time);
                                                });
                                              },
                                              child: Material(
                                                  elevation: 0,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          2.0),
                                                  color: time ==
                                                          showSlots(index, pos,
                                                              rowIndex)
                                                      ? defaultGreen
                                                      : Colors.white,
                                                  child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 5,
                                                              horizontal: 10),
                                                      child: Container(
                                                        width: 60.0,
                                                        child: Text(
                                                          showSlots(index, pos,
                                                              rowIndex),
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: dateTabTextStyle.copyWith(
                                                              fontSize: 12,
                                                              color: time ==
                                                                      showSlots(
                                                                          index,
                                                                          pos,
                                                                          rowIndex)
                                                                  ? Colors.white
                                                                  : Color(
                                                                      0xFF303030)),
                                                        ),
                                                      )))),
                                        );
                                      }));
                                    },
                                  ),
                                ),
                              );
                            })),
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.fromLTRB(50, 10, 50, 30),
                child: SizedBox(
                  width: double.infinity,
                  height: 50.0,
                  child: TextButton(
                    onPressed: () {
                      print('consultationIndex: $consultationIndex');
                      print('selectedDate: $date');
                      print('consultationTime: $time');
                      if (date != null && time != null) {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => ConfirmConsultation(
                                      package: consultationIndex,
                                      selectedDate: dateSelected,
                                      consultationTime: time,
                                      consultation: widget.consultation,
                                    )));
                      } else {
                        if (date == null) {
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content:
                                  Text('Please select date of appointment')));
                        } else {
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content:
                                  Text('Please select time of appointment')));
                        }
                      }
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
      ),
    );
  }
}
