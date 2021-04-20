import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:diet_delight/services/apiCalls.dart';
import 'package:intl/intl.dart';
import 'package:diet_delight/konstants.dart';

class CustomCalenderForAddress extends StatefulWidget {
  List addressTapList;
  List primaryAddress;
  List secondaryAddress;
  var listOfAvailableDays;
  bool makePostCall;
  var mealId;
  var status;
  var id;
  var dateList;
  CustomCalenderForAddress(
      {this.dateList,
      this.mealId,
      this.status,
      this.id,
      this.addressTapList,
      this.primaryAddress,
      this.secondaryAddress,
      this.listOfAvailableDays,
      this.makePostCall});
  @override
  _CustomCalenderForAddressState createState() =>
      _CustomCalenderForAddressState(
          primaryAddressDaysList: primaryAddress,
          secondayAddressDaysList: secondaryAddress);
}

class _CustomCalenderForAddressState extends State<CustomCalenderForAddress> {
  _CustomCalenderForAddressState(
      {this.primaryAddressDaysList, this.secondayAddressDaysList});
  var skipDays;
  int month = 1;
  int index = 1;
  int year = 2021;
  int day = 1;
  String monthVal = "January";
  var withoutDays = [];
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

  List primaryAddressDaysList = [];

  List secondayAddressDaysList = [];
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
  bool isDateRemoved = false;
  var removedDate;
  var nextSelectedData;

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
          color: Colors.white,
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

  _showDialogBox() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context,setState){
        return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0))),
            insetPadding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.02,
                horizontal: MediaQuery.of(context).size.width * 0.06),
            child: Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  //background color of box


                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 3.0, // soften the shadow
                    spreadRadius: 3.0, //extend the shadow

                  )
                ],
              ),
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 10,),
                    Text('Please add a secondary address first.',style: appBarTextStyle.copyWith(color: Colors.black,fontSize: 16),textAlign: TextAlign.center,),
                    SizedBox(height: 10,),

                  ],
                ),
              ),
            ));
      }),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    setDateData();
    super.initState();
    print(widget.listOfAvailableDays);
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
    print('primary and secondary');
    print(primaryAddressDaysList);
    print(secondayAddressDaysList);
  }

  makeApiCall(){
    if (widget.makePostCall == true) {
      Api.instance.postAddressBreakTakenDay(
          primaryDays: primaryAddressDaysList,
          secondaryDays:
          secondayAddressDaysList,
          mealId: widget.mealId,
          status: widget.status,
          dateList: widget.dateList);
      widget.makePostCall = false;
    } else {
      Api.instance.putAddressBreakTakenDay(
          primaryDays: primaryAddressDaysList,
          secondaryDays:
          secondayAddressDaysList,
          mealId: widget.mealId,
          status: widget.status,
          dateList : widget.dateList,
          id: widget.id);
    }
  }
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder:
        (BuildContext context, StateSetter setState /*You can rename this!*/) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.55,
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.0,
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
                          color: Color(0xFF979797),
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
                            color: Colors.white,
                            fontSize: 16),
                      ),
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 16,
                          color: Color(0xFF979797),
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
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20)),
                  child: Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: GridView.builder(
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: 31 + 7 + skipDays,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                            String currDay = "$year-$monthStringValue-$temp";
                            return GestureDetector(
                              onTap: () async {
                                var dayyy = (int.parse(dayText) + 1).toString();
                                temp = dayyy.length == 1 ? "0$dayyy" : dayyy;

                                if (secondaryAddressLine1 != '' && secondaryAddressLine2 != ''){
                                  if (primaryAddressDaysList
                                      .contains(currDay)) {
                                    setState((){
                                      primaryAddressDaysList.remove(currDay);
                                      secondayAddressDaysList.add(currDay);});
                                    await makeApiCall();
                                  }
                                  else if (secondayAddressDaysList
                                      .contains(currDay)) {
                                    setState((){
                                      secondayAddressDaysList.remove(currDay);
                                      primaryAddressDaysList.add(currDay);
                                    });
                                    await makeApiCall();
                                  }
                                }else{
                                  _showDialogBox();
                                }

                              },
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.04,
                                width:
                                    MediaQuery.of(context).size.width * 0.122,
                                decoration: withoutDays.contains(i % 7)
                                    ?  BoxDecoration(
                                  color: Color(0xFF77838F).withOpacity(0.5),
                                  borderRadius:
                                  BorderRadius.circular(100),
                                ) :   !primaryAddressDaysList
                                    .contains(currDay) && !secondayAddressDaysList
                                    .contains(currDay)
                                    ? BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius:
                                  BorderRadius.circular(100),

                                )
                                    : primaryAddressDaysList.contains(currDay) &&
                                            !widget.addressTapList.contains(0)
                                        ? BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.2),
                                                blurRadius: 4,
                                                offset: Offset(0,
                                                    2), // changes position of shadow
                                              ),
                                            ],
                                          )
                                        : secondayAddressDaysList.contains(currDay) &&
                                                !widget.addressTapList
                                                    .contains(1)
                                            ? BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.2),
                                                    blurRadius: 4,
                                                    offset: Offset(0,
                                                        2), // changes position of shadow
                                                  ),
                                                ],
                                              )
                                            : (primaryAddressDaysList.contains(currDay) ||
                                                        secondayAddressDaysList
                                                            .contains(
                                                                currDay)) &&
                                                    widget.addressTapList
                                                        .contains(0) &&
                                                    widget.addressTapList
                                                        .contains(1)
                                                ? BoxDecoration(
                                                    color: primaryAddressDaysList
                                                            .contains(currDay)
                                                        ? defaultGreen
                                                        : Colors.purple,
                                                    borderRadius: BorderRadius.circular(
                                                        100))
                                                : primaryAddressDaysList
                                                            .contains(currDay) &&
                                                        widget.addressTapList.contains(0)
                                                    ? BoxDecoration(
                                                        color: defaultGreen,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                      )
                                                    : secondayAddressDaysList.contains(currDay) && widget.addressTapList.contains(1)
                                                        ? BoxDecoration(
                                                            color:
                                                                Colors.purple,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100),
                                                          )
                                                        : BoxDecoration(
                                  color: Color(0xFF77838F),
                                  borderRadius:
                                  BorderRadius.circular(100),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '$dayText',
                                      style: TextStyle(
                                          color: withoutDays.contains((i % 7))
                                              ? Color(0xFFFFFFFF).withOpacity(0.2) :   !primaryAddressDaysList
                                              .contains(currDay) && !secondayAddressDaysList
                                              .contains(currDay) ? Color(0xFF77838F)
                                              : primaryAddressDaysList
                                                          .contains(currDay) &&
                                                      !widget.addressTapList
                                                          .contains(0)
                                                  ? defaultGreen
                                                  : secondayAddressDaysList
                                                              .contains(
                                                                  currDay) &&
                                                          !widget.addressTapList
                                                              .contains(1)
                                                      ? defaultPurple
                                                      : primaryAddressDaysList
                                                                  .contains(
                                                                      currDay) &&
                                                              widget
                                                                  .addressTapList
                                                                  .contains(0)
                                                          ? Colors.white
                                                          : secondayAddressDaysList
                                                                      .contains(
                                                                          currDay) &&
                                                                  widget
                                                                      .addressTapList
                                                                      .contains(
                                                                          1)
                                                              ? Colors.white
                                                              : datesWhenBreakChosen.contains(currDay)?
                                          Colors.white : Colors.white.withOpacity(0.2),
                                        fontWeight: widget.addressTapList.contains(0) && widget.addressTapList.contains(1) ? FontWeight.bold  : FontWeight.normal,
                                      ),
                                    ),
                                    datesWhenBreakChosen.contains(currDay)
                                        ? Text(
                                            'Break',
                                            style: appBarTextStyle.copyWith(
                                                color: Colors.white,
                                                fontSize: 12),
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
