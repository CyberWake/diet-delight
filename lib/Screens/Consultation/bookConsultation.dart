import 'dart:ui';

import 'package:date_format/date_format.dart';
import 'package:diet_delight/Models/consultationModel.dart';
import 'package:diet_delight/konstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:intl/intl.dart';
import 'package:diet_delight/Models/consultationAppointmentModel.dart';
import 'package:diet_delight/Models/consultationPurchaseModel.dart';
import 'package:diet_delight/Screens/Consultation/prePaymentConsultation.dart';
import 'package:diet_delight/services/apiCalls.dart';

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
  int consultationMode = 0;
  List<String> format = [yyyy, '-', mm, '-', dd];
  String dropdownValue = 'One';
  DateTime today;
  DateTime dateSelected;
  TabController _tabController;
  double conHeight = 300.0;
  String selectedTime = '1PM';
  String time;
  String date;
//  List<bool> isSelected = [true, false];
  List<List> timeChart = [
    [9, 10, 11],
    [12, 1, 2],
    [3, 4, 5]
  ];
  int selectedIndex;

  updateSelectedConsultation(int index) {
    setState(() {
      selectedIndex = index;
      consultationIndex = index;
    });
  }

  getSubTime(int index, int rowIndex) {
    String suffix;
    if (index == 0) {
      suffix = 'AM';
    } else {
      suffix = 'PM';
    }
    switch (rowIndex) {
      case 0:
        return ':00 $suffix';
        break;
      case 1:
        return ':15 $suffix';
        break;
      case 2:
        return ':30 $suffix';
        break;
      case 3:
        return ':45 $suffix';
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
        displayTime = '${timeChart[index][pos]}:00 $suffix';
        break;
      case 1:
        displayTime = '${timeChart[index][pos]}:15 $suffix';
        break;
      case 2:
        displayTime = '${timeChart[index][pos]}:30 $suffix';
        break;
      case 3:
        displayTime = '${timeChart[index][pos]}:45 $suffix';
        break;
      default:
        return "null";
    }
    return displayTime;
  }

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.packageIndex;
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
  void didChangeDependencies() {
    precacheImage(consultationBackground.image, context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var devWidth = MediaQuery.of(context).size.width;
    var devHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          image: consultationBackground,
        ),
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            centerTitle: false,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.keyboard_backspace,
                size: 30.0,
                color: questionnaireSelect,
              ),
            ),
            title: Text('Book an Appointment',
                style: appBarTextStyle.copyWith(
                    fontFamily: 'RobotoReg',
                    color: questionnaireSelect,
                    fontWeight: FontWeight.bold)),
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      devWidth * 0.075, 0, devWidth * 0.075, 0),
                  child: Material(
                    elevation: 0,
                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    color: Colors.transparent,
                    child: Container(
                      height: devHeight * 0.18,
                      width: devWidth * 0.85,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(40.0)),
                        color: questionnaireDisabled.withOpacity(0.4),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: devWidth * 0.06,
                            vertical: devWidth * 0.04),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                '${widget.consultation[consultationIndex].name} Package',
                                style: consultationModeSelectStyle.copyWith(
                                  color: white,
                                  fontWeight: FontWeight.w600,
                                )),
                            SizedBox(height: devWidth * 0.02),
                            Padding(
                              padding: EdgeInsets.only(left: devWidth * 0.03),
                              child: Text(
                                  '${widget.consultation[consultationIndex].subtitle}',
                                  style: consultationModeSelectStyle.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: white)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          devWidth * 0.075, 20, devWidth * 0.075, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Select appointment date',
                            style: TextStyle(
                              fontFamily: 'RobotoReg',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: questionnaireSelect,
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
                                          caption:
                                              TextStyle(color: defaultPurple),
                                        ),
                                        disabledColor: formFill,
                                        accentTextTheme: TextTheme(),
                                      ),
                                      initialDate: dateSelected ?? today,
                                      firstDate:
                                          today.subtract(Duration(days: 1)));
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
                                        DateFormat.E()
                                                .format(dateSelected ?? today) +
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
                      padding: EdgeInsets.fromLTRB(
                          MediaQuery.of(context).size.width * 0.075,
                          20,
                          MediaQuery.of(context).size.width * 0.075,
                          0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Preferred time slot',
                            style: TextStyle(
                              fontFamily: 'RobotoReg',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: questionnaireSelect,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          MediaQuery.of(context).size.width * 0.025,
                          25,
                          MediaQuery.of(context).size.width * 0.025,
                          0),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            child: TabBar(
                                indicatorColor: Colors.transparent,
                                indicatorWeight: 0.01,
                                indicatorSize: TabBarIndicatorSize.label,
                                labelColor: defaultGreen,
                                labelPadding:
                                    EdgeInsets.symmetric(horizontal: 13),
                                unselectedLabelColor: questionnaireDisabled,
                                controller: _tabController,
                                tabs: List.generate(3, (index) {
                                  return Tab(
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Column(
                                        children: [
                                          Material(
                                              elevation:
                                                  _tabController.index == index
                                                      ? 0.0
                                                      : 2.0,
                                              borderRadius:
                                                  BorderRadius.circular(2.0),
                                              color:
                                                  _tabController.index == index
                                                      ? defaultGreen
                                                      : Colors.white,
                                              child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 15),
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
                                                              : questionnaireDisabled),
                                                    ),
                                                  ))),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          Text(
                                              index == 0
                                                  ? '9 AM to 12 PM'
                                                  : index == 1
                                                      ? '12 PM to 3 PM'
                                                      : '3 PM to 6 PM',
                                              style: dateTabTextStyle.copyWith(
                                                  color: _tabController.index ==
                                                          index
                                                      ? defaultGreen
                                                      : questionnaireDisabled)),
                                        ],
                                      ),
                                    ),
                                  );
                                })),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10.0, 10, 10, 0),
                            child: Container(
                              width: double.infinity,
                              height: devHeight * 0.27,
                              child: TabBarView(
                                  controller: _tabController,
                                  children: List.generate(3, (index) {
                                    return Container(
                                      height: devHeight * 0.25,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0.0, 0, 0),
                                        child: ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 0, 0),
                                          itemCount: timeChart[index].length,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder:
                                              (BuildContext context, int pos) {
                                            return Column(
                                                children: List.generate(4,
                                                    (rowIndex) {
                                              return Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.05,
                                                    10,
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.05,
                                                    10),
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
                                                            BorderRadius
                                                                .circular(2.0),
                                                        color: time ==
                                                                showSlots(
                                                                    index,
                                                                    pos,
                                                                    rowIndex)
                                                            ? defaultGreen
                                                            : Colors.white,
                                                        child: Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical: 5,
                                                                    horizontal:
                                                                        10),
                                                            child: Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.15,
                                                              child: Text(
                                                                showSlots(
                                                                    index,
                                                                    pos,
                                                                    rowIndex),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: dateTabTextStyle.copyWith(
                                                                    fontSize:
                                                                        12,
                                                                    color: time ==
                                                                            showSlots(
                                                                                index,
                                                                                pos,
                                                                                rowIndex)
                                                                        ? Colors
                                                                            .white
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
                  ],
                ),
//                  : SizedBox(),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(50, 0, 50, 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 40.0,
                    child: TextButton(
                      onPressed: () {
                        print('consultationIndex: $consultationIndex');
                        print('selectedDate: $date');
                        print('consultationTime: $time');
                        if (
//                      isSelected[1] == true &&
                            date != null && time != null) {
                          var formatter = new DateFormat('yyyy-MM-dd');
                          DateTime finalTime =
                              DateFormat("hh:mm a").parse(time);
                          ConsAppointmentModel appointment =
                              ConsAppointmentModel(
                            userId: Api.userInfo.id,
                            consultationTime: formatter.format(dateSelected) +
                                ' ' +
                                DateFormat.Hms().format(finalTime),
                          );
                          ConsPurchaseModel purchaseDetails = ConsPurchaseModel(
                              consultationName:
                                  widget.consultation[consultationIndex].name,
                              consultationPackageId: widget
                                  .consultation[consultationIndex].id
                                  .toString(),
                              consultationPackageDuration: widget
                                  .consultation[consultationIndex].duration
                                  .toString(),
                              amountPaid: widget
                                  .consultation[consultationIndex].price
                                  .toString());
                          print(purchaseDetails.consultationPackageId);
                          print(consultationIndex);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PrePayment(
                                        appointment: appointment,
                                        orderDetails: purchaseDetails,
                                        package: consultationIndex,
                                        consultation: widget.consultation,
                                        consultationMode:
                                            consultationMode.toString(),
                                      )));
                        }
                        else {
                          if (date == null) {
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                                content:
                                    Text('Please select date of appointment')));
                          } else if (time == null) {
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                                content:
                                    Text('Please select time of appointment')));
                          }
                        }
                      },
                      child: Text(
                        'NEXT',
                        style: TextStyle(
                          fontFamily: 'RobotoReg',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
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
      ),
    );
  }
}
