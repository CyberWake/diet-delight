import 'package:cached_network_image/cached_network_image.dart';
import 'package:diet_delight/Models/export_models.dart';
import 'package:diet_delight/Screens/export.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:intl/intl.dart';

class MealSubscriptionPage extends StatefulWidget {
  int durationId;
  String description;
  String categories;
  final MealModel mealPackage;
  final int weekDaysSelected;
  MealSubscriptionPage(
      {this.durationId,this.description,
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
  List<String> days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  TextEditingController addressPrimaryLine1 = TextEditingController();
  TextEditingController addressSecondaryLine1 = TextEditingController();
  TextEditingController addressPrimaryLine2 = TextEditingController();
  TextEditingController addressSecondaryLine2 = TextEditingController();
  String name;

  getUserInfo() async {
    await _apiCall.getUserInfo();
    name = "${Api.userInfo.firstName ?? ''} ${Api.userInfo.lastName ?? ''}";
    if (Api.userInfo.addressLine1 != null) {
      addressPrimaryLine1.text = Api.userInfo.addressLine1;
    }
    if (Api.userInfo.addressLine2 != null) {
      addressPrimaryLine2.text = Api.userInfo.addressLine2;
    }
    if (Api.userInfo.addressSecondary1 != null) {
      addressSecondaryLine1.text = Api.userInfo.addressSecondary1;
    }
    if (Api.userInfo.addressSecondary2 != null) {
      addressSecondaryLine2.text = Api.userInfo.addressSecondary2;
    }
    selectedAddressLine1 = addressPrimaryLine1.text;
    selectedAddressLine2 = addressPrimaryLine2.text;
    concatenatedAddress =
        addressPrimaryLine1.text + '\n' + addressPrimaryLine2.text;
    isAddressSelected = true;

    selectedAddressIndex = 0;
    var val = await _apiCall.getAfternoonValue();
    setState(() {
      afterNoonValue = val;
    });
    setState(() {});
  }

  int afterNoonValue = 0;

  @override
  void initState() {
    super.initState();

    var temp = DateTime.now().toLocal();
    dateSelected = temp.add(Duration(days: 2));
    date =
        '${dateSelected.year.toString()}-${dateSelected.month.toString().padLeft(2, '0')}-${dateSelected.day.toString().padLeft(2, '0')}';
    getUserInfo();

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

  final _apiCall = Api.instance;

  callback(address) {
    setState(() {
      concatenatedAddress = address;
    });
  }

  var deliveryTimeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/bg8.jpg'), fit: BoxFit.fitHeight)),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 5.0,
          backgroundColor: white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0))),
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
          title: Text('Subscribe your meal plan',
              style: appBarTextStyle.copyWith(color: defaultGreen)),
        ),
        body: Container(
          padding: const EdgeInsets.only(left: 30.0, right: 20),
          child: ListView(
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          Text(widget.mealPackage.name,
                              style: selectedTab.copyWith(fontSize: 18)),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            selDays.contains("Sun") && selDays.contains("Sat")
                                ? widget.mealPackage.duration.toString() +
                                    " day meal plan\nwith weekend"
                                : widget.mealPackage.duration.toString() +
                                    " day meal plan\nwithout weekend",
                            style: descriptionTextStyle,
                            maxLines: 4,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            widget.categories.trim(),
                            style: descriptionTextStyle,
                          ),
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
                        height: 130,
                        width: 130,
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
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Container(
                  decoration: BoxDecoration(
                      color: formBackground,
                      borderRadius: BorderRadius.circular(30)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Days of the week',
                          style: selectedTab,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, top: 10, right: 0, bottom: 25),
                          child: Text(
                            'Days of the week you want your food to be delivered.',
                            style: selectedTab.copyWith(
                                color: Colors.grey, fontSize: 14),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 0.0, right: 0, bottom: 5),
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
                                        } else if (selectedDays[index] ==
                                            false) {
                                          if (count < widget.weekDaysSelected) {
                                            setState(() {
                                              selectedDays[index] = true;
                                              count++;
                                            });
                                            print('marking $count');
                                          } else {
                                            _scaffoldKey.currentState
                                                .showSnackBar(SnackBar(
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
                                          color: selectedDays[index]
                                              ? defaultGreen
                                              : white,
                                          /*   border: Border.all(
                                              color: selectedDays[index]
                                                  ? white
                                                  : Color.fromRGBO(
                                                          144, 144, 144, 1)
                                                      .withOpacity(0.5)), */
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius:
                                                  selectedDays[index] ? 0 : 4,
                                              color: Colors.black
                                                  .withOpacity(0.25),
                                              spreadRadius: 0,
                                              offset: selectedDays[index]
                                                  ? const Offset(0, 0)
                                                  : const Offset(0, 4),
                                            )
                                          ],
                                        ),
                                        child: Center(
                                          child: Text(
                                            days[index],
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 35.0, vertical: 5),
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
                                          } else if (selectedDays[index + 4] ==
                                              false) {
                                            if (count <
                                                widget.weekDaysSelected) {
                                              setState(() {
                                                selectedDays[index + 4] = true;
                                                count++;
                                              });
                                              print('marking $count');
                                            } else {
                                              _scaffoldKey.currentState
                                                  .showSnackBar(SnackBar(
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
                                            /* border: Border.all(
                                                color: selectedDays[index + 4]
                                                    ? white
                                                    : Color.fromRGBO(
                                                            144, 144, 144, 1)
                                                        .withOpacity(0.5)), */
                                            boxShadow: [
                                              BoxShadow(
                                                blurRadius:
                                                    selectedDays[index + 4]
                                                        ? 0
                                                        : 4,
                                                color: Colors.black
                                                    .withOpacity(0.25),
                                                spreadRadius: 0,
                                                offset: selectedDays[index + 4]
                                                    ? const Offset(0, 0)
                                                    : const Offset(0, 4),
                                              )
                                            ],
                                          ),
                                          child: Center(
                                            child: Text(
                                              days[index + 4],
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
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
                        SizedBox(height: 20),
                        Container(
                          height: 40,
                          margin: EdgeInsets.symmetric(horizontal: 30),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 2,
                                offset:
                                    Offset(0, 0), // changes position of shadow
                              ),
                            ],
                          ),
                          width: double.infinity,
                          child: GestureDetector(
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
                                      initialDate: dateSelected ??
                                          today.add(Duration(days: 2)),
                                      firstDate: DateTime.now()
                                          .toLocal()
                                          .add(Duration(days: 1)));
                              if (selectedDateTime != null) {
                                setState(() {
                                  dateSelected = selectedDateTime;
                                  date =
                                      '${dateSelected.year.toString()}-${dateSelected.month.toString().padLeft(2, '0')}-${dateSelected.day.toString().padLeft(2, '0')}';
                                });
                              }
                              print(date);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "First Delivery",
                                  style: appBarTextStyle.copyWith(
                                      color: defaultGreen, fontSize: 18),
                                ),
                                Text(
                                  DateFormat.E().format(dateSelected ??
                                          today.add(Duration(days: 2))) +
                                      ', ' +
                                      DateFormat.MMM().add_d().format(
                                          dateSelected ??
                                              today.add(Duration(days: 2))),
                                  style: TextStyle(
                                      fontFamily: 'RobotoCondensedReg',
                                      fontSize: 18,
                                      color: defaultGreen),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin:
                    EdgeInsets.only(top: 30, bottom: 20, left: 0, right: 00),
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                decoration: BoxDecoration(
                  color: formBackground,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Shipping Address',
                          style: selectedTab.copyWith(),
                        ),
                        isAddressSelected ?? false
                            ? AddressButtonWithModal(
                                callBackFunction: callback,
                                child: Text('CHANGE',
                                    style: unSelectedTab.copyWith(
                                        color: defaultGreen, fontSize: 18)),
                              )
                            : AddressButtonWithModal(
                                callBackFunction: callback,
                                child: Text('ADD',
                                    style: unSelectedTab.copyWith(
                                        color: defaultGreen, fontSize: 18)),
                              ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    isAddressSelected
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${Api.userInfo.firstName ?? ''} ${Api.userInfo.lastName ?? ''}",
                                style: selectedTab.copyWith(
                                    fontWeight: FontWeight.w400),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Text(concatenatedAddress,
                                    style: unSelectedTab.copyWith(
                                        height: 1.5,
                                        fontWeight: FontWeight.w400)),
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text('Select An Address',
                                      style: unSelectedTab)
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30, bottom: 20, left: 0, right: 0),
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                decoration: BoxDecoration(
                  color: formBackground,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Delivery Time',
                          style: selectedTab.copyWith(),
                        ),
                        GestureDetector(
                          onTap: () async {
                            showModalBottomSheet(
                                context: context,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(50.0),
                                      topRight: Radius.circular(50.0)),
                                ),
                                isScrollControlled: false,
                                builder: (BuildContext context) {
                                  return StatefulBuilder(
                                      builder: (context, setState) {
                                    return Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.43,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20.0),
                                              topRight: Radius.circular(20.0)),
                                          image: DecorationImage(
                                              image:
                                                  AssetImage('images/bg7.jpg'),
                                              fit: BoxFit.cover)),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 30, vertical: 20),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Delivery Time",
                                                  style: billingTextStyle
                                                      .copyWith(color: white),
                                                ),
                                                SizedBox(
                                                  height: 40,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        print(
                                                            deliveryTimeIndex);
                                                        setState(() {
                                                          deliveryTimeIndex = 0;
                                                        });
                                                      },
                                                      child: Stack(
                                                        children: [
                                                          Container(
                                                            height: 105,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.375,
                                                            decoration: BoxDecoration(
                                                                color: deliveryTimeIndex ==
                                                                        0
                                                                    ? defaultGreen
                                                                    : Color(0xFF77838F)
                                                                        .withOpacity(
                                                                            0.3),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15)),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top:
                                                                          22.0),
                                                              child: Text(
                                                                "Morning\n6am - 12pm",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'RobotoReg',
                                                                    fontSize:
                                                                        16,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                          ),
                                                          Positioned(
                                                              bottom: 10,
                                                              right: 10,
                                                              child: Text(
                                                                "Cost 0 BHD",
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'RobotoReg',
                                                                    fontSize:
                                                                        11,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ))
                                                        ],
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        print(
                                                            deliveryTimeIndex);
                                                        setState(() {
                                                          deliveryTimeIndex = 1;
                                                        });
                                                      },
                                                      child: Stack(
                                                        children: [
                                                          Container(
                                                            height: 105,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.375,
                                                            decoration: BoxDecoration(
                                                                color: deliveryTimeIndex ==
                                                                        1
                                                                    ? defaultGreen
                                                                    : Color(0xFF77838F)
                                                                        .withOpacity(
                                                                            0.3),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15)),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top:
                                                                          22.0),
                                                              child: Text(
                                                                "Afternoon\n1pm - 6pm",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'RobotoReg',
                                                                    fontSize:
                                                                        16,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                          ),
                                                          Positioned(
                                                              bottom: 10,
                                                              right: 10,
                                                              child: Text(
                                                                "Cost ${afterNoonValue} BHD",
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'RobotoReg',
                                                                    fontSize:
                                                                        11,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ))
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.6),
                                              height: 50,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(20.0)),
                                                color: questionnaireDisabled
                                                    .withOpacity(0.7),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "DONE",
                                                  style: TextStyle(
                                                      fontFamily: 'RobotoReg',
                                                      fontSize: 20,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  });
                                });
                          },
                          child: Text('CHANGE',
                              style: unSelectedTab.copyWith(
                                  color: defaultGreen, fontSize: 18)),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0),
                      child: Text(
                        deliveryTimeIndex == 0
                            ? 'Morning - 6am - 12pm'
                            : "Afternoon - 1pm - 6pm",
                        style: selectedTab.copyWith(
                            fontWeight: FontWeight.w500, fontSize: 15),
                      ),
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
                                  durationId:widget.durationId,
                                      afterNoonPrice: deliveryTimeIndex == 1
                                          ? afterNoonValue
                                          : 0,
                                      categories: widget.categories,
                                      selectedDate: dateSelected,
                                      selectedDays: selDays,
                                      addressIndex: selectedAddressIndex,
                                      mealPlan: widget.mealPackage,
                                      shippingAddressLine1:
                                          selectedAddressLine1,
                                      shippingAddressLine2:
                                          selectedAddressLine2,
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
                    'CONTINUE',
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
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
