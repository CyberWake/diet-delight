import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:diet_delight/services/apiCalls.dart';
import 'package:intl/intl.dart';
import 'package:diet_delight/konstants.dart';

class CustomCalenderForBreak extends StatefulWidget {
  var daysList = [];
  var mealId;
  var status;
  var breakDays;
  bool postCall;
  var listOfAvailableDays;
  var id;
  var getDaysInBeteween;
  var primaryAndSecondary;
  CustomCalenderForBreak(
      {this.primaryAndSecondary,
      this.getDaysInBeteween,
      this.id,
      this.daysList,
      this.mealId,
      this.status,
      this.breakDays,
      this.postCall,
      this.listOfAvailableDays});
  @override
  _CustomCalenderForBreakState createState() => _CustomCalenderForBreakState(
      daysList: this.daysList, datesWhenBreakChosen: this.breakDays);
}

class _CustomCalenderForBreakState extends State<CustomCalenderForBreak> {
  var skipDays;
  int month = 1;
  int index = 1;
  int year = 2021;
  int day = 1;
  String monthVal = "January";
  var withoutDays = [];
  var varDate = DateTime.now();
  var datesWhenBreakChosen = [];
  List daysList = [];
  var totalDate = DateFormat.yMMMMd('en_US').format(DateTime.now());

  _CustomCalenderForBreakState({this.daysList, this.datesWhenBreakChosen});

  _getMonth({String monthText, int monthInt, String monthValue}) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.05,
      decoration: month == monthInt
          ? BoxDecoration(
              color: Color.fromRGBO(119, 131, 143, 1),
              borderRadius: BorderRadius.circular(10),
            )
          : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
                onTap: () {
                  setState(() {
                    var firstDate = year.toString() + monthStringValue + "01";
                    var dateIs = DateTime.parse(firstDate);
                    var firstDay = DateFormat('EEEE').format(dateIs);
                    skipDays = _weekDaysFull.indexOf(firstDay);
                    month = monthInt;
                    monthVal = monthValue;
                    totalDate = monthVal +
                        " " +
                        day.toString() +
                        ", " +
                        year.toString();
                  });
                  setState(() {
                    if (month == 1) {
                      monthStringValue = "01";
                    } else if (month == 2) {
                      monthStringValue = "02";
                    } else if (month == 3) {
                      monthStringValue = "03";
                    } else if (month == 4) {
                      monthStringValue = "04";
                    } else if (month == 5) {
                      monthStringValue = "05";
                    } else if (month == 6) {
                      monthStringValue = "06";
                    } else if (month == 7) {
                      monthStringValue = "07";
                    } else if (month == 8) {
                      monthStringValue = "08";
                    } else if (month == 9) {
                      monthStringValue = "09";
                    } else if (month == 10) {
                      monthStringValue = "10";
                    } else if (month == 11) {
                      monthStringValue = "11";
                    } else if (month == 12) {
                      monthStringValue = "12";
                    }
                    var firstDate = year.toString() + monthStringValue + "01";
                    var dateIs = DateTime.parse(firstDate);
                    var firstDay = DateFormat('EEEE').format(dateIs);
                    skipDays = _weekDaysFull.indexOf(firstDay);
                    month = monthInt;
                    monthVal = monthValue;
                    totalDate = monthVal +
                        " " +
                        day.toString() +
                        ", " +
                        year.toString();
                  });
                },
                child: Text(
                  '$monthText',
                ))
          ],
        ),
      ),
    );
  }

  bool IsLeapYear(int year) {
    return year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);
  }

  bool shouldHideDay() {
    if (month == 1) {
      return false;
    } else if (month == 2) {
      return true;
    } else if (month == 3) {
      return false;
    } else if (month == 4) {
      return true;
    } else if (month == 5) {
      return false;
    } else if (month == 6) {
      return true;
    } else if (month == 7) {
      return false;
    } else if (month == 8) {
      return false;
    } else if (month == 9) {
      return true;
    } else if (month == 10) {
      return false;
    } else if (month == 11) {
      return true;
    } else if (month == 12) {
      return false;
    }
  }

  String monthStringValue =
      DateTime.now().toLocal().toString().split('-')[1].toString();

  final List<String> _weekDaysFull = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    'Saturday',
    "Sunday"
  ];

  final List<String> _weekDays = [
    'MON',
    'TUE',
    'WED',
    'THU',
    'FRI',
    'SAT',
    'SUN'
  ];

  Widget _weekDayTitle(int index) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        _weekDays[index],
        style: appBarTextStyle.copyWith(
          color: Color.fromRGBO(119, 131, 143, 1),
          fontSize: 12,
        ),
      ),
    );
  }

  setDateData() {
    setState(() {
      year = int.parse(DateTime.now().toLocal().toString().split('-')[0]);
      month = int.parse(DateTime.now().toLocal().toString().split('-')[1]);
      print(DateTime.now().toLocal().toString().split('-'));
      if (month == 1) {
        monthStringValue = "01";
      } else if (month == 2) {
        monthStringValue = "02";
      } else if (month == 3) {
        monthStringValue = "03";
      } else if (month == 4) {
        monthStringValue = "04";
      } else if (month == 5) {
        monthStringValue = "05";
      } else if (month == 6) {
        monthStringValue = "06";
      } else if (month == 7) {
        monthStringValue = "07";
      } else if (month == 8) {
        monthStringValue = "08";
      } else if (month == 9) {
        monthStringValue = "09";
      } else if (month == 10) {
        monthStringValue = "10";
      } else if (month == 11) {
        monthStringValue = "11";
      } else if (month == 12) {
        monthStringValue = "12";
      }
      day = int.parse(DateTime.now()
          .toLocal()
          .toString()
          .split('-')[2]
          .toString()
          .split(" ")[0]);
      var firstDate = year.toString() + monthStringValue + "01";
      var dateIs = DateTime.parse(firstDate);
      var firstDay = DateFormat('EEEE').format(dateIs);
      skipDays = _weekDaysFull.indexOf(firstDay);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    setDateData();
    print(widget.getDaysInBeteween);
    super.initState();
    if (!widget.listOfAvailableDays.contains('Monday')) {
      withoutDays.add(0);
    }
    if (!widget.listOfAvailableDays.contains('Tuesday')) {
      withoutDays.add(1);
    }
    if (!widget.listOfAvailableDays.contains('Wednesday')) {
      withoutDays.add(2);
    }
    if (!widget.listOfAvailableDays.contains('Thursday')) {
      withoutDays.add(3);
    }
    if (!widget.listOfAvailableDays.contains('Friday')) {
      withoutDays.add(4);
    }
    if (!widget.listOfAvailableDays.contains('Saturday')) {
      withoutDays.add(5);
    }
    if (!widget.listOfAvailableDays.contains('Sunday')) {
      withoutDays.add(6);
    }
    print("printing primary");
    print(widget.primaryAndSecondary[0]);
    print(widget.primaryAndSecondary[1]);
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder:
        (BuildContext context, StateSetter setState /*You can rename this!*/) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.68,
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            Text(
              'Breaks',
              style: appBarTextStyle.copyWith(
                  color: Color.fromRGBO(119, 131, 143, 1),
                  fontSize: 24,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.025,
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios_outlined,
                          size: 16,
                          color: Color.fromRGBO(119, 131, 149, 1),
                        ),
                        onPressed: () {
                          setState(() {
                            if (month == 1) {
                              year--;
                              month = 12;
                            } else {
                              month--;
                            }

                            monthVal = currentMonth(month);
                            monthStringValue =
                                monthIntegerValueInString(month: month);
                            var firstDate =
                                year.toString() + monthStringValue + "01";
                            var dateIs = DateTime.parse(firstDate);
                            var firstDay = DateFormat('EEEE').format(dateIs);
                            skipDays = _weekDaysFull.indexOf(firstDay);
                            totalDate = monthVal +
                                " " +
                                day.toString() +
                                ", " +
                                year.toString();
                            print(totalDate);
                          });
                        }),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Text(
                        '${currentMonth(month).toUpperCase().substring(0, 3)} $year',
                        style: appBarTextStyle.copyWith(
                            color: Color.fromRGBO(119, 131, 149, 1),
                            fontSize: 16),
                      ),
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 16,
                          color: Color.fromRGBO(119, 131, 149, 1),
                        ),
                        onPressed: () {
                          setState(() {
                            if (month == 12) {
                              year++;
                              month = 1;
                            } else {
                              month++;
                            }

                            monthVal = currentMonth(month);
                            monthStringValue =
                                monthIntegerValueInString(month: month);
                            var firstDate =
                                year.toString() + monthStringValue + "01";
                            var dateIs = DateTime.parse(firstDate);
                            var firstDay = DateFormat('EEEE').format(dateIs);
                            skipDays = _weekDaysFull.indexOf(firstDay);
                            totalDate = monthVal +
                                " " +
                                day.toString() +
                                ", " +
                                year.toString();
                            print(totalDate);
                          });
                        }),
                  ],
                ),
                SizedBox(
                  height: 13,
                ),
                Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(248, 248, 248, 1),
                          borderRadius: BorderRadius.circular(20)),
                      child: Container(
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: GridView.builder(
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: 31 + 7 + skipDays,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisSpacing: 5,
                              crossAxisCount: 7,
                              crossAxisSpacing: 20,
                            ),
                            itemBuilder: (context, i) {
                              if (!IsLeapYear(year) &&
                                  month == 2 &&
                                  i - 6 - skipDays == 29) {
                                return Container();
                              }
                              if (i - 6 - skipDays == 30 && month == 2) {
                                return Container();
                              }
                              if (i - 6 - skipDays == 31 && shouldHideDay()) {
                                return Container();
                              }
                              if (i < 7)
                                return _weekDayTitle(i);
                              else if (i - 6 - skipDays < 1) {
                                return Container();
                              } else if (i - 6 - skipDays <= 31) {
                                var dayInt = i - 6 - skipDays;
                                var dayText = (i - 6 - skipDays).toString();
                                var temp =
                                    dayText.length == 1 ? "0$dayText" : dayText;
                                String currDay =
                                    "$year-$monthStringValue-$temp";

                                return GestureDetector(
                                  onTap: () async {
                                    int counter = 1;
                                    var dayyy =
                                        (int.parse(dayText) + 1).toString();
                                    temp =
                                        dayyy.length == 1 ? "0$dayyy" : dayyy;
                                    String nextDay =
                                        "$year-$monthStringValue-$temp";
                                    setState(() {
                                      if (daysList.contains(currDay)) {
                                        var primaryList =
                                            widget.primaryAndSecondary[0];
                                        var secondaryList =
                                            widget.primaryAndSecondary[1];
                                        var totalList =
                                            widget.primaryAndSecondary[2];
                                        if (primaryList
                                            .contains(currDay + " 00:00:00")) {
                                          int count = 1;
                                          int counter = 1;
                                          var nextPossibleDay = DateTime.parse(
                                                  currDay + " 00:00:00")
                                              .add(Duration(days: count));
                                          while (!widget.listOfAvailableDays
                                              .contains(DateFormat('EEEE')
                                                  .format(nextPossibleDay))) {
                                            count++;
                                            nextPossibleDay = DateTime.parse(
                                                    currDay + " 00:00:00")
                                                .add(Duration(days: count));
                                          }

                                          var date = DateTime.parse(
                                              totalList[totalList.length - 1] +
                                                  " 00:00:00");
                                          print(date);
                                          var nextPossibleDayToAdd =
                                              new DateTime(date.year,
                                                  date.month, date.day + 1);

                                          while (!widget.listOfAvailableDays
                                              .contains(DateFormat('EEEE')
                                                  .format(
                                                      nextPossibleDayToAdd))) {
                                            print(nextPossibleDayToAdd);
                                            print(DateFormat('EEEE')
                                                .format(nextPossibleDayToAdd));
                                            nextPossibleDayToAdd = new DateTime(
                                                nextPossibleDayToAdd.year,
                                                nextPossibleDayToAdd.month,
                                                nextPossibleDayToAdd.day + 1);
                                            counter++;
                                          }
                                          print(
                                              "printing next possible day $nextPossibleDayToAdd");

                                          totalList.add(nextPossibleDayToAdd
                                              .toString()
                                              .split(" ")[0]);

                                          var nextDay = nextPossibleDay
                                                  .toString()
                                                  .split(" ")[0] +
                                              " 00:00:00";

                                          datesWhenBreakChosen.add(currDay);
                                          primaryList
                                              .remove(currDay + " 00:00:00");
                                          primaryList.add(nextPossibleDayToAdd
                                                  .toString()
                                                  .split(" ")[0] +
                                              " 00:00:00");
                                          daysList.remove(currDay);
                                          daysList.add(
                                              nextDay.toString().split(" ")[0]);

                                          widget.primaryAndSecondary[0] =
                                              primaryList;
                                          widget.primaryAndSecondary[2] =
                                              totalList;

                                          month =
                                              int.parse(nextDay.split('-')[1]);
                                          monthStringValue =
                                              monthIntegerValueInString(
                                                  month: month);
                                          day = int.parse(nextDay
                                              .split(' ')[0]
                                              .toString()
                                              .split("-")[2]);
                                        } else if (secondaryList
                                            .contains(currDay + " 00:00:00")) {
                                          print(
                                              'secondary contains break taken day');
                                          int count = 1;
                                          int counter = 1;
                                          var nextPossibleDay = DateTime.parse(
                                                  currDay + " 00:00:00")
                                              .add(Duration(days: count));
                                          while (!widget.listOfAvailableDays
                                              .contains(DateFormat('EEEE')
                                                  .format(nextPossibleDay))) {
                                            count++;
                                            nextPossibleDay = DateTime.parse(
                                                    currDay + " 00:00:00")
                                                .add(Duration(days: count));
                                          }

                                          var date = DateTime.parse(
                                              totalList[totalList.length - 1] +
                                                  " 00:00:00");
                                          print(date);
                                          var nextPossibleDayToAdd =
                                              new DateTime(date.year,
                                                  date.month, date.day + 1);

                                          while (!widget.listOfAvailableDays
                                              .contains(DateFormat('EEEE')
                                                  .format(
                                                      nextPossibleDayToAdd))) {
                                            print(nextPossibleDayToAdd);
                                            print(DateFormat('EEEE')
                                                .format(nextPossibleDayToAdd));
                                            nextPossibleDayToAdd = new DateTime(
                                                nextPossibleDayToAdd.year,
                                                nextPossibleDayToAdd.month,
                                                nextPossibleDayToAdd.day + 1);
                                            counter++;
                                          }
                                          totalList.add(nextPossibleDayToAdd
                                              .toString()
                                              .split(" ")[0]);

                                          var nextDay = nextPossibleDay
                                                  .toString()
                                                  .split(" ")[0] +
                                              " 00:00:00";

                                          datesWhenBreakChosen.add(currDay);
                                          secondaryList
                                              .remove(currDay + " 00:00:00");
                                          secondaryList.add(nextPossibleDayToAdd
                                                  .toString()
                                                  .split(" ")[0] +
                                              " 00:00:00");
                                          daysList.remove(currDay);
                                          daysList.add(
                                              nextDay.toString().split(" ")[0]);

                                          widget.primaryAndSecondary[1] =
                                              secondaryList;
                                          widget.primaryAndSecondary[2] =
                                              totalList;

                                          month =
                                              int.parse(nextDay.split('-')[1]);
                                          monthStringValue =
                                              monthIntegerValueInString(
                                                  month: month);
                                          day = int.parse(nextDay
                                              .split(' ')[0]
                                              .toString()
                                              .split("-")[2]);
                                        }
                                        print('printing total list');
                                        print(totalList);
                                        print(primaryList);
                                        print(secondaryList);
                                      } else if (datesWhenBreakChosen
                                          .contains(currDay)) {
                                        var primaryList =
                                            widget.primaryAndSecondary[0];
                                        var secondaryList =
                                            widget.primaryAndSecondary[1];
                                        var totalList =
                                            widget.primaryAndSecondary[2];
                                        print("tapped on break date");
                                        int ind = datesWhenBreakChosen
                                            .indexOf(currDay);
                                        daysList = [];
                                        daysList.add(currDay);
                                        final length =
                                            datesWhenBreakChosen.length;
                                        for (int i = ind; i < length; i++) {
                                          print('for loop called');
                                          if (primaryList.contains(
                                              totalList[totalList.length - 1] +
                                                  " 00:00:00")) {
                                            primaryList.insert(
                                                0,
                                                datesWhenBreakChosen[i] +
                                                    " 00:00:00");
                                            primaryList.remove(totalList[
                                                    totalList.length - 1] +
                                                " 00:00:00");
                                            totalList.remove(totalList[
                                                totalList.length - 1]);

                                            print('removed from primary');
                                          } else if (secondaryList.contains(
                                              totalList[totalList.length - 1] +
                                                  " 00:00:00")) {
                                            secondaryList.insert(
                                                0,
                                                datesWhenBreakChosen[i] +
                                                    " 00:00:00");
                                            secondaryList.remove(totalList[
                                                    totalList.length - 1] +
                                                " 00:00:00");
                                            totalList.remove(totalList[
                                                totalList.length - 1]);

                                            print('removed from secondary');
                                          } else {
                                            print(
                                                "ERROR\n\n\n\ None contains the last date");
                                          }
                                        }

                                        var tempDateChosen = [];
                                        for (int i = 0; i < ind; i++) {
                                          tempDateChosen.add(datesWhenBreakChosen[i]);
                                        }

                                        datesWhenBreakChosen = tempDateChosen;
                                        print(totalList);
                                        print(primaryList);
                                        print(secondaryList);
                                        print(datesWhenBreakChosen);
                                        widget.primaryAndSecondary[0] =
                                            primaryList;
                                        widget.primaryAndSecondary[1] =
                                            secondaryList;
                                        widget.primaryAndSecondary[2] =
                                            totalList;
                                      } else {
                                        print('heyyyyyyyyyyy');
                                        print(nextDay);
                                      }
                                    });
                                  },
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.04,
                                    width: MediaQuery.of(context).size.width *
                                        0.122,
                                    decoration: !widget.primaryAndSecondary[2]
                                            .contains(currDay)
                                        ? BoxDecoration(
                                            color: Color.fromRGBO(
                                                240, 240, 240, 1),
                                            borderRadius:
                                                BorderRadius.circular(100),
                                          )
                                        : daysList.contains(currDay)
                                            ? BoxDecoration(
                                                color: Color.fromRGBO(
                                                    119, 131, 143, 1),
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.25),
                                                    blurRadius: 4,
                                                    offset: Offset(0,
                                                        2), // changes position of shadow
                                                  ),
                                                ],
                                              )
                                            : null,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '$dayText',
                                          style: TextStyle(
                                              color: !widget
                                                      .primaryAndSecondary[2]
                                                      .contains(currDay)
                                                  ? Color(0xFF77838F)
                                                  : daysList.contains(currDay)
                                                      ? Colors.white
                                                      : Colors.black,
                                              fontSize: datesWhenBreakChosen
                                                      .contains(currDay)
                                                  ? 12
                                                  : 14),
                                        ),
                                        datesWhenBreakChosen.contains(currDay)
                                            ? Text(
                                                'Break',
                                                style: appBarTextStyle.copyWith(
                                                    color: Color.fromRGBO(
                                                        119, 131, 149, 1),
                                                    fontSize:
                                                        datesWhenBreakChosen
                                                                .contains(
                                                                    currDay)
                                                            ? 10
                                                            : 12),
                                              )
                                            : Container(),
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return null;
                              }
                            },
                          )),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 15,
                      child: GestureDetector(
                        onTap: () {
                          if (widget.postCall == true) {
                            Api.instance.postBreakTakenDay(
                                breakDays: datesWhenBreakChosen,
                                mealId: widget.mealId,
                                status: widget.status,
                                primaryAndSecondary:
                                    widget.primaryAndSecondary);
                            Navigator.pop(context);
                          } else {
                            Api.instance.putBreakTakenDay(
                                breakDays: datesWhenBreakChosen,
                                mealId: widget.mealId,
                                status: widget.status,
                                id: widget.id,
                                primaryAndSecondary:
                                    widget.primaryAndSecondary);
                            Navigator.pop(context);
                          }
                        },
                        child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                color: defaultGreen,
                                borderRadius: BorderRadius.circular(5000)),
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                            )),
                      ),
                    )
                  ],
                ),
              ],
            )
          ],
        ),
      );
    });
  }
}
