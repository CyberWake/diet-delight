import 'package:diet_delight/Models/mealModel.dart';
import 'package:diet_delight/Screens/MealPlans/prePaymentMealPlan.dart';
import 'package:diet_delight/konstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:intl/intl.dart';

class MealSubscriptionPage extends StatefulWidget {
  final MealModel mealPackage;
  final int weekDaysSelected;
  MealSubscriptionPage({this.mealPackage, this.weekDaysSelected});
  @override
  _MealSubscriptionPageState createState() => _MealSubscriptionPageState();
}

class _MealSubscriptionPageState extends State<MealSubscriptionPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime today;
  DateTime dateSelected;
  String date;
  int postIndex;
  int count = 0;
  List<String> selDays = List();
  List<bool> selectedDays = [false, false, false, false, false, false, false];
  List<String> days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  TextEditingController addressPrimary = TextEditingController();
  TextEditingController addressSecondary = TextEditingController();
  FocusNode addressFocus = FocusNode();
  String addressArea = 'Bahrain';
  String localAddress = '';
  double _height = 350;
  int items = 4;
  int selectedAddress = -1;
  List<String> types = ['Home', 'Work'];
  List<String> areas = ['Bahrain', 'India'];
  List<String> areas2 = ['Bahrain', 'India'];
  String addressType = 'Home';

  @override
  void initState() {
    super.initState();
    today = new DateTime.now();
    widget.weekDaysSelected == 7
        ? selectedDays = [
            true,
            true,
            true,
            true,
            true,
            true,
            true,
          ]
        : selectedDays = [true, true, true, true, true, false, false];
    addressFocus.addListener(() {
      if (addressFocus.hasFocus) {
        setState(() {
          items = 5;
          _height = 600;
        });
      } else if (!addressFocus.hasFocus) {
        setState(() {
          items = 4;
          _height = 350;
        });
      }
    });
  }

  void addAddress({int address}) {
    if (address == 0 && addressPrimary.text.isNotEmpty) {
      var separatedAddress = addressPrimary.text.split(',');
      addressArea = separatedAddress[separatedAddress.length - 1];
      localAddress = separatedAddress[0];
    } else if (address == 1 && addressSecondary.text.isNotEmpty) {
      var separatedAddress = addressSecondary.text.split(',');
      addressArea = separatedAddress[separatedAddress.length - 1];
      localAddress = separatedAddress[0];
    } else {
      localAddress = '';
    }
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        builder: (builder) {
          return StatefulBuilder(builder:
              (BuildContext context, StateSetter addressModalStateUpdate) {
            return Container(
              height: _height,
              color:
                  Colors.transparent, //could change this to Color(0xFF737373),
              //so you don't have to change MaterialApp canvasColor
              child: Container(
                  padding: EdgeInsets.only(top: 30),
                  child: Column(
                      children: List.generate(items, (index) {
                    if (index < 2) {
                      return Expanded(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(50, 10, 50, 10),
                          padding: EdgeInsets.symmetric(horizontal: 20),
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
                          child: DropDown<String>(
                            showUnderline: false,
                            items: index == 0 ? types : areas,
                            onChanged: (String choice) {
                              if (index == 0) {
                                addressType = choice;
                              } else if (index == 1) {
                                addressArea = choice;
                              }
                              print(choice);
                              addressModalStateUpdate(() {});
                            },
                            isExpanded: true,
                          ),
                        ),
                      );
                    } else if (index == 2) {
                      return Expanded(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(50, 10, 50, 10),
                          padding: EdgeInsets.symmetric(horizontal: 20),
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
                              controller: address == 0
                                  ? addressPrimary
                                  : addressSecondary,
                              focusNode: addressFocus,
                              onFieldSubmitted: (done) {
                                localAddress = done;
                              },
                              style: authInputTextStyle,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              decoration: authInputFieldDecoration.copyWith(
                                  hintText:
                                      'House #, House name, Street name')),
                        ),
                      );
                    } else if (index == 3) {
                      return Expanded(
                          child: GestureDetector(
                        onTap: () {
                          print(addressArea);
                          if (address == 0) {
                            addressPrimary.text += ', ' + addressArea;
                            print(addressPrimary.text);
                          } else if (address == 1) {
                            addressSecondary.text += ', ' + addressArea;
                          }
                          setState(() {});
                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 20),
                          color: defaultGreen,
                          child: Center(
                              child: Text(
                            localAddress.length > 0 || addressArea != null
                                ? 'Update'
                                : 'ADD',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          )),
                        ),
                      ));
                    } else {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.35,
                      );
                    }
                  }))),
            );
          });
        });
  }

  void getBottomSheet() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        builder: (builder) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter modalStateUpdate) {
            return Container(
              height: 380,
              color: Colors.transparent,
              child: Container(
                  padding: EdgeInsets.only(top: 10),
                  child: Column(
                      children: List.generate(3, (index) {
                    if (index == 2) {
                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 20),
                            color: defaultGreen,
                            child: Center(
                                child: Text(
                              'Done',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            )),
                          ),
                        ),
                      );
                    }
                    if (index == 0 && addressPrimary.text.isNotEmpty) {
                      var separatedAddress = addressPrimary.text.split(',');
                      addressArea =
                          separatedAddress[separatedAddress.length - 1];
                      localAddress = separatedAddress[0];
                    } else if (index == 1 && addressSecondary.text.isNotEmpty) {
                      var separatedAddress = addressSecondary.text.split(',');
                      addressArea =
                          separatedAddress[separatedAddress.length - 1];
                      localAddress = separatedAddress[0];
                    } else {
                      localAddress = '';
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, bottom: 10),
                            child: Text(
                              index == 0
                                  ? 'Primary Address'
                                  : 'Secondary Address',
                              style: selectedTab.copyWith(
                                  color:
                                      index == 0 ? defaultGreen : Colors.black,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (index == 0) {
                                if (addressPrimary.text.isNotEmpty) {
                                  modalStateUpdate(() {
                                    selectedAddress = index;
                                  });
                                }
                              } else if (index == 1) {
                                if (addressSecondary.text.isNotEmpty) {
                                  modalStateUpdate(() {
                                    selectedAddress = index;
                                  });
                                }
                              }
                            },
                            child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                    color: selectedAddress == index
                                        ? defaultGreen
                                        : white,
                                    border: Border.all(color: defaultGreen),
                                    borderRadius: BorderRadius.circular(15)),
                                child: localAddress.length > 0
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(15.0),
                                                child: Text(
                                                  localAddress +
                                                      ',\n' +
                                                      addressArea,
                                                  style: selectedTab.copyWith(
                                                      color: selectedAddress ==
                                                              index
                                                          ? white
                                                          : defaultGreen,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    : Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              TextButton(
                                                child: Text('Add',
                                                    style: TextStyle(
                                                      color: darkGreen,
                                                    )),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  addAddress(address: index);
                                                },
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [Text('Not Available')],
                                          )
                                        ],
                                      )),
                          )
                        ],
                      ),
                    );
                  }))),
            );
          });
        });
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
        title: Text('Subscribe your meal plan', style: appBarTextStyle),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Meal Plan Name',
                          style: selectedTab.copyWith(fontSize: 28)),
                      Text('sgasdfjijadfigfadjfvadsfiluH\nFIUDSBFSADIUAGFIGF'),
                      Text('Breakfast, lunch, dinner')
                    ],
                  ),
                ),
                Container(
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
                    backgroundColor: Color(0xffC4C4C4),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 20),
              child: Text(
                'Days of the week',
                style: selectedTab,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 50, bottom: 20),
              child: Text(
                'Days of the week you want your food to be delivered.',
                style: selectedTab.copyWith(color: Colors.grey, fontSize: 14),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                  4,
                  (index) => GestureDetector(
                        onTap: () {
                          if (selectedDays[index] == true) {
                            print('unmarking');
                            setState(() {
                              selectedDays[index] = false;
                              count--;
                            });
                          } else if (selectedDays[index] == false) {
                            if (count < widget.weekDaysSelected) {
                              print('marking');
                              setState(() {
                                selectedDays[index] = true;
                                count++;
                              });
                            } else {
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text(
                                      'Change the Meal Subscription plan to with weekends or change the week days selected')));
                            }
                          }
                        },
                        child: Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: selectedDays[index] ? defaultGreen : white,
                              border: Border.all(
                                  color: selectedDays[index]
                                      ? white
                                      : defaultGreen)),
                          child: Center(
                            child: Text(
                              days[index],
                              style: TextStyle(
                                  fontSize: 18,
                                  color: selectedDays[index]
                                      ? Colors.white
                                      : defaultGreen),
                            ),
                          ),
                        ),
                      )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 45.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                    3,
                    (index) => Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: GestureDetector(
                            onTap: () {
                              if (selectedDays[index + 4] == true) {
                                print('unmarking');
                                setState(() {
                                  selectedDays[index + 4] = false;
                                  count--;
                                });
                              } else if (selectedDays[index + 4] == false) {
                                if (count < widget.weekDaysSelected) {
                                  print('marking');
                                  setState(() {
                                    selectedDays[index + 4] = true;
                                    count++;
                                  });
                                } else {
                                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                                      content: Text(
                                          'Change the Meal Subscription plan to with weekends or change the week days selected')));
                                }
                              }
                            },
                            child: Container(
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: selectedDays[index + 4]
                                      ? defaultGreen
                                      : white,
                                  border: Border.all(
                                      color: selectedDays[index + 4]
                                          ? white
                                          : defaultGreen)),
                              child: Center(
                                child: Text(
                                  days[index + 4],
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: selectedDays[index + 4]
                                          ? Colors.white
                                          : defaultGreen),
                                ),
                              ),
                            ),
                          ),
                        )),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Starting date',
                    style: selectedTab,
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
                        dateSelected = selectedDateTime;
                        date =
                            '${dateSelected.year.toString()}-${dateSelected.month.toString().padLeft(2, '0')}-${dateSelected.day.toString().padLeft(2, '0')}';
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
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                'Shipping Address',
                style: selectedTab,
              ),
            ),
            Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 4,
                      color: Colors.black.withOpacity(0.25),
                      spreadRadius: 0,
                      offset: const Offset(0.0, 0.0),
                    )
                  ],
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(width: 1, color: Colors.grey),
                  color: white),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Jane Doe',
                        style: selectedTab,
                      ),
                      GestureDetector(
                        onTap: getBottomSheet,
                        child: Text('Change',
                            style: unSelectedTab.copyWith(color: defaultGreen)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          '3 NewBridge Court\nChino Hills, CA 91709, United States',
                          style: unSelectedTab)
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: SizedBox(
                width: double.infinity,
                height: 50.0,
                child: TextButton(
                  onPressed: () {
                    print('pressed');
                    if (date != null) {
                      selDays = [];
                      for (int i = 0; i < selectedDays.length; i++) {
                        if (selectedDays[i]) {
                          selDays.add(days[i]);
                        }
                      }
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => PrePaymentMealPlan(
                                    selectedDate: dateSelected,
                                    selectedDays: selDays,
                                    mealPlan: widget.mealPackage,
                                  )));
                    } else {
                      _scaffoldKey.currentState.showSnackBar(
                          SnackBar(content: Text('Select a date first.')));
                    }
                  },
                  child: Text(
                    'Pay Now',
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
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
