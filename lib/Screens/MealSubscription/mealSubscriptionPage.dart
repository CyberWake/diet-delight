import 'package:diet_delight/Screens/MealSubscription/prePaymentSubscription.dart';
import 'package:diet_delight/konstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:intl/intl.dart';

class MealSubscriptionPage extends StatefulWidget {
  @override
  _MealSubscriptionPageState createState() => _MealSubscriptionPageState();
}

class _MealSubscriptionPageState extends State<MealSubscriptionPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime today;
  DateTime dateSelected;
  String date;
  int postIndex;
  List<String> selDays = List();
  List<bool> selectedDays = [false, false, false, false, false, false, false];
  List<String> days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  @override
  void initState() {
    super.initState();
    today = new DateTime.now();
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
                          setState(() {
                            selectedDays[index] = !selectedDays[index];
                          });
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
                              setState(() {
                                selectedDays[index + 4] =
                                    !selectedDays[index + 4];
                              });
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
                      Text('Change',
                          style: unSelectedTab.copyWith(color: defaultGreen)),
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
                                  selectedDays: selDays)));
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
