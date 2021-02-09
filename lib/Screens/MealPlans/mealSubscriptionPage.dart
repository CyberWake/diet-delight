import 'package:cached_network_image/cached_network_image.dart';
import 'package:diet_delight/Models/mealModel.dart';
import 'package:diet_delight/Screens/MealPlans/prePaymentMealPlan.dart';
import 'package:diet_delight/Widgets/getAddressModalSheet.dart';
import 'package:diet_delight/konstants.dart';
import 'package:diet_delight/services/apiCalls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:intl/intl.dart';

class MealSubscriptionPage extends StatefulWidget {
  String description;
  String categories;
  final MealModel mealPackage;
  final int weekDaysSelected;
  MealSubscriptionPage(
      {this.description,
      this.mealPackage,
      this.weekDaysSelected,
      this.categories});
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
  List<String> days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thur', 'Fri', 'Sat'];

  @override
  void initState() {
    super.initState();
    concatenatedAddress = '';
    isAddressSelected = false;
    selectedAddressIndex = -1;
    if (widget.categories == null) {
      widget.categories = 'Breakfast, Lunch, Dinner';
      widget.description = 'aiduhFIUOYARHOCWYJFIOWEGFCNINYRFAESOITCUBQW';
    }
    today = new DateTime.now();
    count = widget.weekDaysSelected;
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
  }

  callback(address) {
    setState(() {
      concatenatedAddress = address;
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
        padding: const EdgeInsets.only(left: 30.0, right: 20),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              fit: FlexFit.loose,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    flex: 15,
                    fit: FlexFit.loose,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            flex: 2,
                            fit: FlexFit.loose,
                            child: Text(widget.mealPackage.name,
                                style: selectedTab.copyWith(fontSize: 18)),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Flexible(
                              flex: 2,
                              fit: FlexFit.tight,
                              child: Text(
                                widget.mealPackage.details,
                                style: descriptionTextStyle,
                                maxLines: 4,
                              )),
                          Flexible(
                              flex: 1, child: Text(widget.categories.trim())),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 5,
                    fit: FlexFit.loose,
                    child: CachedNetworkImage(
                      imageUrl: widget.mealPackage.picture ??
                          "http://via.placeholder.com/350x150",
                      imageBuilder: (context, imageProvider) => Container(
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Days of the week',
              style: selectedTab,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, top: 5, right: 0, bottom: 20),
              child: Text(
                'Days of the week you want your food to be delivered.',
                style: selectedTab.copyWith(color: Colors.grey, fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 0.0, right: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                    4,
                    (index) => GestureDetector(
                          onTap: () {
                            if (selectedDays[index] == true) {
                              setState(() {
                                selectedDays[index] = false;
                                count--;
                              });
                              print('unmarking $count');
                            } else if (selectedDays[index] == false) {
                              if (count < widget.weekDaysSelected) {
                                setState(() {
                                  selectedDays[index] = true;
                                  count++;
                                });
                                print('marking $count');
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
                                color:
                                    selectedDays[index] ? defaultGreen : white,
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
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 45.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                    3,
                    (index) => Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: GestureDetector(
                            onTap: () {
                              if (selectedDays[index + 4] == true) {
                                setState(() {
                                  selectedDays[index + 4] = false;
                                  count--;
                                });
                                print('unmarking $count');
                              } else if (selectedDays[index + 4] == false) {
                                if (count < widget.weekDaysSelected) {
                                  setState(() {
                                    selectedDays[index + 4] = true;
                                    count++;
                                  });
                                  print('marking $count');
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
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
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
                          initialDate:
                              dateSelected ?? today.add(Duration(days: 2)),
                          firstDate: today.add(Duration(days: 2)));
                      if (selectedDateTime != null) {
                        setState(() {
                          dateSelected = selectedDateTime;
                          date =
                              '${dateSelected.year.toString()}-${dateSelected.month.toString().padLeft(2, '0')}-${dateSelected.day.toString().padLeft(2, '0')}';
                        });
                      }
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
                                DateFormat.E().format(dateSelected ??
                                        today.add(Duration(days: 2))) +
                                    ', ' +
                                    DateFormat.MMM().add_d().format(
                                        dateSelected ??
                                            today.add(Duration(days: 2))),
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
            Text(
              'Shipping Address',
              style: selectedTab.copyWith(fontStyle: FontStyle.italic),
            ),
            Container(
              margin: EdgeInsets.only(top: 20, bottom: 20),
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
              child: isAddressSelected
                  ? Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              Api.userInfo.firstName +
                                  ' ' +
                                  Api.userInfo.lastName,
                              style: selectedTab,
                            ),
                            AddressButtonWithModal(
                              callBackFunction: callback,
                              child: Text('Change',
                                  style: unSelectedTab.copyWith(
                                      color: defaultGreen)),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(concatenatedAddress, style: unSelectedTab)
                          ],
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AddressButtonWithModal(
                              callBackFunction: callback,
                              child: Text('Select',
                                  style: unSelectedTab.copyWith(
                                      color: defaultGreen)),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('Select An Address', style: unSelectedTab)
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
            ),
            SizedBox(
              width: double.infinity,
              height: 50.0,
              child: TextButton(
                onPressed: () {
                  print('pressed');
                  if (isAddressSelected) {
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
                                    categories: widget.categories,
                                    selectedDate: dateSelected,
                                    selectedDays: selDays,
                                    mealPlan: widget.mealPackage,
                                  )));
                    } else {
                      _scaffoldKey.currentState.showSnackBar(
                          SnackBar(content: Text('Select a date first.')));
                    }
                  } else {
                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text('Select a Shipping address first')));
                  }
                },
                child: Text(
                  'Continue',
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
          ],
        ),
      ),
    );
  }
}
