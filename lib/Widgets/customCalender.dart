import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:diet_delight/services/apiCalls.dart';
import 'package:intl/intl.dart';
import 'package:diet_delight/konstants.dart';

class CustomCalenderForBreak extends StatefulWidget {
  @override
  _CustomCalenderForBreakState createState() => _CustomCalenderForBreakState();
}

class _CustomCalenderForBreakState extends State<CustomCalenderForBreak> {

  var skipDays;
  int month = 1;
  int index = 1;
  int year = 2021;
  int day = 1;
  String monthVal = "January";
  var withoutDays = [4,5];
  var varDate = DateTime.now();
  var datesWhenBreakChosen = [];
  var totalDate = DateFormat.yMMMMd('en_US').format(DateTime.now());

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

  List daysList = [
    '2021-02-10',
    '2021-02-23'
  ];
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
      child: Text(_weekDays[index],  style: appBarTextStyle.copyWith(
        color: Color.fromRGBO(119, 131, 143, 1),
        fontSize: 12,
      ),),
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
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (BuildContext context,
        StateSetter setState /*You can rename this!*/) {
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
              ),
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
                            if(month ==1 ){
                              year--;
                              month = 12;
                            }else{ month--; }

                            monthVal = currentMonth(month);
                            monthStringValue = monthIntegerValueInString(month: month);
                            var firstDate =
                                year.toString() + monthStringValue + "01";
                            var dateIs = DateTime.parse(firstDate);
                            var firstDay =
                            DateFormat('EEEE').format(dateIs);
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
                      padding:
                      const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Text('${currentMonth(month)} $year',style: appBarTextStyle.copyWith(
                          color: Color.fromRGBO(119, 131, 149, 1),
                          fontSize: 16
                      ),),
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 16,
                          color: Color.fromRGBO(119, 131, 149, 1),
                        ),
                        onPressed: () {
                          setState(() {
                            if(month == 12 ){
                              year++;
                              month = 1;
                            }else{ month++; }

                            monthVal = currentMonth(month);
                            monthStringValue = monthIntegerValueInString(month: month);
                            var firstDate =
                                year.toString() + monthStringValue + "01";
                            var dateIs = DateTime.parse(firstDate);
                            var firstDay =
                            DateFormat('EEEE').format(dateIs);
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
                            var dayInt =  i - 6 - skipDays;
                            var dayText =(i - 6 - skipDays).toString();
                            var temp = dayText.length == 1 ? "0$dayText" : dayText;
                            String currDay  = "$year-$monthStringValue-$temp";
                            print(daysList.contains(currDay) ? currDay : '');
                            return Container(
                              height: MediaQuery.of(context).size.height * 0.04,
                              width: MediaQuery.of(context).size.width * 0.122,
                              decoration:withoutDays.contains(i%7) ?  BoxDecoration(
                                color: Color.fromRGBO(240, 240, 240, 1),
                                borderRadius: BorderRadius.circular(100),
                              ) :  daysList.contains(currDay)
                                  ? BoxDecoration(
                                color: Color.fromRGBO(119, 131, 143, 1),
                                borderRadius: BorderRadius.circular(100),
                              )
                                  : null,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      int counter = 1;
                                      var dayyy = (int.parse(dayText) + 1).toString();
                                      temp = dayyy.length == 1 ? "0$dayyy" : dayyy;
                                      String nextDay  = "$year-$monthStringValue-$temp";
                                      setState(()  {
                                        if(daysList.contains(currDay)){

                                          while(withoutDays.contains((i+counter)%7)  || datesWhenBreakChosen.contains(nextDay)){
                                            dayyy = (int.parse(dayyy) + 1).toString();
                                            temp = dayyy.length == 1 ? "0$dayyy" : dayyy;
                                            nextDay  = "$year-$monthStringValue-$temp";
                                            counter++;
                                          }
                                          datesWhenBreakChosen.add(currDay);
                                          daysList.remove(currDay);
                                          daysList.add(nextDay);

                                          print('dayswhenBreakChosen');
                                          print(datesWhenBreakChosen);
                                          day = dayInt;
                                        }
                                        print(DateTime.parse("$currDay 00:00:00"));
                                        print(DateTime.parse("$nextDay 00:00:00"));
                                        totalDate =
                                            monthVal + " " + day.toString() + ", " + year.toString();
                                      });
                                      await Api.instance.postBreakTakenDay(breakDay : DateTime.parse("$currDay 00:00:00"), nextDate: DateTime.parse("$nextDay 00:00:00"));

                                    },
                                    child: Text('$dayText',style: TextStyle(
                                        color:    datesWhenBreakChosen.contains(currDay) ? Color.fromRGBO(119, 131, 149, 1) : withoutDays.contains(i%7) ? Color.fromRGBO(119, 131, 143, 1) : Colors.black
                                    ),),
                                  ),
                                  datesWhenBreakChosen.contains(currDay) ? Text('Break',style: appBarTextStyle.copyWith(
                                      color: Color.fromRGBO(119, 131, 149, 1),
                                      fontSize: 12
                                  ),) : Container(),
                                ],
                              ),
                            );
                          } else {
                            return null;
                          }
                        },
                      )),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            )
          ],
        ),
      );
    });
  }
}

