import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_format/date_format.dart';
import 'package:diet_delight/Models/export_models.dart';
import 'package:diet_delight/Screens/export.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class PlacedMealMenuOrders extends StatefulWidget {
  final MealPurchaseModel purchaseDetails;
  final MealModel plan;
  PlacedMealMenuOrders({this.purchaseDetails, this.plan});
  @override
  _PlacedMealMenuOrdersState createState() => _PlacedMealMenuOrdersState();
}

class _PlacedMealMenuOrdersState extends State<PlacedMealMenuOrders>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController _scrollController = new ScrollController();
  final _apiCall = Api.instance;
  TabController _pageController;
  List<DateTime> dates = [];
  List<String> format = [dd, ' ', 'M', ', ', yyyy];
  bool isLoaded = false;
  DateTime startDate;
  int menuId = 0;
  int primary = 0;
  int secondary = 1;
  int selected = -1;
  List<DateTime> breakDates = List();
  List<DateTime> planSelectedOffDays = List();
  List<DateTime> deliverPrimary = List();
  List<DateTime> deliverSecondary = List();
  List<DateTime> blackoutsAddressCalendar = List();
  List<MenuModel> menuItems = List();
  List<MenuCategoryModel> categoryItems = List();
  List<MenuCategoryModel> mainCategoryItems = List();
  List<MenuCategoryModel> tempCategoryItems = List();
  List<List<MenuCategoryModel>> subCategoryItems = List();
  List<List<MenuOrderModel>> foodItems = List();
  List<MenuOrderModel> itemsFood = List();
  List<MenuOrderModel> expansionFoodItems = List();

  @override
  void initState() {
    super.initState();
    selectedAddressIndex = -1;
    menuId = widget.plan.menuId;
    _pageController = TabController(
        length: int.parse(widget.purchaseDetails.mealPlanDuration),
        vsync: this);
    getDates();
    getData();
  }

  callback(address) {
    setState(() {
      concatenatedAddress = address;
    });
  }

  var listOfAvailableDays = [];
  var primaryDaysList = [];
  var secondaryDaysList = [];



  getData() async {
    categoryItems = [];
    foodItems = [];
    setState(() {
      isLoaded = false;
    });
    categoryItems = await _apiCall.getMenuCategories(menuId);
    for (int i = 0; i < categoryItems.length; i++) {
      if (categoryItems[i].parent == 0) {
        mainCategoryItems.add(categoryItems[i]);
        tempCategoryItems = [];
        if (i + 1 < categoryItems.length) {
          if (categoryItems[i + 1].parent == 0) {
            subCategoryItems.add(tempCategoryItems);
          }
        }
        if (i + 1 == categoryItems.length) {
          subCategoryItems.add(tempCategoryItems);
        }
      } else {
        tempCategoryItems.add(categoryItems[i]);
        if (i + 1 < categoryItems.length) {
          if (categoryItems[i].parent != categoryItems[i + 1].parent) {
            subCategoryItems.add(tempCategoryItems);
            tempCategoryItems = [];
          } else {
            continue;
          }
        }
        if (i + 1 == categoryItems.length) {
          subCategoryItems.add(tempCategoryItems);
          tempCategoryItems = [];
        }
      }
    }
    if (categoryItems.isNotEmpty) {
      for (int i = 0; i < categoryItems.length;) {
        foodItems.add(await _apiCall
            .getCurrentMealCategoryOrdersFoodItems(
                categoryItems[i].id.toString(), widget.purchaseDetails.id)
            .whenComplete(() => i++));
      }
    }
    if (mounted) {
      setState(() {
        isLoaded = true;
      });
    }

    if(widget.purchaseDetails.weekdays.contains('Sun')){
      listOfAvailableDays.add('Sunday');
    }
    if(widget.purchaseDetails.weekdays.contains('Mon')){
      listOfAvailableDays.add('Monday');
    }
    if(widget.purchaseDetails.weekdays.contains('Tue')){
      listOfAvailableDays.add('Tuesday');
    }
    if(widget.purchaseDetails.weekdays.contains('Wed')){
      listOfAvailableDays.add('Wednesday');
    }
    if(widget.purchaseDetails.weekdays.contains('Thur')){
      listOfAvailableDays.add('Thursday');
    }
    if(widget.purchaseDetails.weekdays.contains('Fri')){
      listOfAvailableDays.add('Friday');
    }
    if(widget.purchaseDetails.weekdays.contains('Sat')){
      listOfAvailableDays.add('Saturday');
    }
    print(listOfAvailableDays);
    getDaysInBeteween();

  }

  getDates() {
    dates = [];
    int count = 0;
    startDate = DateTime.parse(widget.purchaseDetails.startDate);
    DateTime date;
    startDate = DateTime(
        startDate.year, startDate.month, startDate.day, 00, 00, 00, 000);
    List days = widget.purchaseDetails.weekdays;
    if (days.contains('Thu')) {
      days.remove('Thu');
      days.add('Thur');
    }
    for (int i = 0;
        i < int.parse(widget.purchaseDetails.mealPlanDuration);
        i++) {
      date = startDate.add(Duration(days: (count)));
      while (!days.contains(formatDate(date, [D])) ||
          ((breakDates != null) ? (breakDates.contains(date)) : false)) {
        if (!days.contains(formatDate(date, [D]))) {
          planSelectedOffDays.add(date);
        }
        count++;
        date = startDate.add(Duration(days: count));
      }
      dates.insert(i, date);
      print(date);
      count++;
    }
    DateTime today = DateTime.now();
    today = DateTime.parse(formatDate(today, [yyyy, '-', mm, '-', dd]));
    print(today);
    for (int i = 0; i < dates.length; i++) {
      if (dates[i] == today) {
        _pageController.index = i;
        print(_pageController.index);
        break;
      }
    }
    blackoutsAddressCalendar = breakDates + planSelectedOffDays;
    blackoutsAddressCalendar = blackoutsAddressCalendar.toSet().toList();
    widget.purchaseDetails.setEndDate(date.toString());
    print('end Date: ${widget.purchaseDetails.endDate}');
  }

  List addressTapList = [];
  void _onSelectionChangedForAddress(
      DateRangePickerSelectionChangedArgs args, int address) {
    if (address == 0) {
      deliverPrimary = args.value;
      if (args.value == null) {
        deliverPrimary = [];
      }
    } else if (address == 1) {
      deliverSecondary = args.value;
      if (args.value == null) {
        deliverSecondary = [];
      }
    }
    print('primary: $deliverPrimary');
    print('secondary: $deliverSecondary');
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    print(args.value);
    breakDates = [];
    breakDates = args.value;
  }

  Widget addressCard(
      {String whichAddress, int addressIndex, StateSetter update}) {
    bool addressPresent;
    if (addressIndex == 0) {
      if (primaryAddressLine1 == '' || primaryAddressLine2 == '') {
        update(() {
          addressPresent = false;
        });
      } else {
        update(() {
          addressPresent = true;
        });
      }
    } else if (addressIndex == 1) {
      if (secondaryAddressLine1 == '' || secondaryAddressLine2 == '') {
        update(() {
          addressPresent = false;
        });
      } else {
        update(() {
          addressPresent = true;
        });
      }
    }
    updateCallback(address) {
      setState(() {
        concatenatedAddress = address;
      });
      update(() {
        concatenatedAddress = address;
      });
    }
    var col ;
    if(primary ==  addressIndex){
      if(addressTapList.contains(0)){
        col = defaultGreen;
      }else{
        col = Color(0xFFC6C6C6);
      }
    }else{
      if(addressTapList.contains(1)){
        col = Color.fromRGBO(120, 40, 139, 1);
      }else{
        col = Color.fromRGBO(198, 198, 198, 1);
      }
    }
    return addressPresent
        ? GestureDetector(
      onTap: () {
        if (addressPresent) {
          update(() {
            selected = addressIndex;
            if (addressTapList.contains(addressIndex)) {
              addressTapList.remove(addressIndex);
            } else {
              addressTapList.add(addressIndex);
            }
          });
        }
      },
          child: Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      height: MediaQuery.of(context).size.height * 0.15,
      width: MediaQuery.of(context).size.width * 0.4,
      decoration: BoxDecoration(
       color: col,   borderRadius: BorderRadius.circular(15),),
      child: Padding(
          padding: const EdgeInsets.only(left: 6.0, top: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    whichAddress,
                    style: adressCardTextStyle.copyWith(
                      fontWeight: addressTapList.contains(addressIndex)
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  addressPresent
                      ? Padding(
                          padding: EdgeInsets.only(left: 10.0, top: 5),
                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                addressIndex == 0
                                    ? primaryAddressLine1
                                    : secondaryAddressLine1,
                                style: adressCardTextStyle.copyWith(
                                  fontWeight: addressTapList
                                          .contains(addressIndex)
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                addressIndex == 0
                                    ? primaryAddressLine2
                                    : secondaryAddressLine2,
                                style: adressCardTextStyle.copyWith(
                                  fontWeight: addressTapList
                                          .contains(addressIndex)
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Center(
                          child: Text(
                            'Not Available',
                            style: adressCardTextStyle.copyWith(
                              fontWeight:
                                  addressTapList.contains(addressIndex)
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                            ),
                          ),
                        ),
                ],
              ),
            ],
          ),
      )

    ),
        ) : AddressButtonWithModal(
      callBackFunction: updateCallback,
      addNewAddressOnly: true,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.15,
        width: MediaQuery.of(context).size.width * 0.4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              'Not Available',
              style: adressCardTextStyle.copyWith(
                fontWeight: addressTapList.contains(addressIndex)
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
            Text(
              'Add',
              style: adressCardTextStyle.copyWith(
                fontWeight: addressTapList.contains(addressIndex)
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List days = [];
  getDaysInBeteween() {
    print("getDaysInBetween");
    DateTime endDate = DateTime.parse((widget.purchaseDetails.endDate));

    DateTime startDate = DateTime.parse((widget.purchaseDetails.startDate));

    print(startDate);
    print(endDate);

    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      setState(() {
        days.add(startDate.add(Duration(days: i)).toString().split(" ")[0].toString());
      });
    }

    print(days);

  }


  showBreakCalendar(datesBreakList,breakDays,putCall,id,primaryAndSecondary) {
    print("|||||||");
    print(primaryAndSecondary);

    print(datesBreakList);
    Future<bool> done = showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        ),
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Container(

            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topRight: Radius.circular(25),topLeft: Radius.circular(25)),
              image: DecorationImage(
                image: AssetImage('images/popup_background.jpg'),
                fit: BoxFit.cover
              )
            ),
              child: CustomCalenderForBreak(primaryAndSecondary : primaryAndSecondary,breakDays : breakDays,daysList: datesBreakList, mealId : widget.purchaseDetails.id,status : widget.plan.status,postCall: !putCall,listOfAvailableDays : listOfAvailableDays,id: id,getDaysInBeteween : days));
        });
    done.then((value) {
      getDates();
      setState(() {
        print(breakDates);
      });
    });
  }

  showAddressCalendar({bool addressCalendar, id,breakList,pList,sList}) async {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40), topRight: Radius.circular(40)),
        ),
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter updateBottomSheet) {
            updateBottomSheet(() {});
            return Container(
                height: MediaQuery.of(context).size.height * 0.8,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topRight: Radius.circular(25),topLeft: Radius.circular(25)),
                    image: DecorationImage(
                        image: AssetImage('images/popup_background.jpg'),
                        fit: BoxFit.cover
                    )
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          addressCard(
                              whichAddress: 'Primary Address',
                              addressIndex: 0,
                              update: updateBottomSheet),
                          addressCard(
                              whichAddress: 'Secondary Address',
                              addressIndex: 1,
                              update: updateBottomSheet),
                        ],
                      ),
                      CustomCalenderForAddress(listOfAvailableDays : listOfAvailableDays,addressTapList: addressTapList,primaryAddress: primaryDaysList,secondaryAddress: secondaryDaysList,makePostCall : makePostAddressCall,mealId : widget.purchaseDetails.id,status : widget.plan.status,id: id,dateList : breakList)
                    ]));
          });
        });
  }

  var makePostAddressCall = false;

  var isPrimary;

  getInitialPrimaryAndSecondary(){


    var billingAddress1 = widget.purchaseDetails.billingAddressLine1;
    var billingAddress2 = widget.purchaseDetails.billingAddressLine2;
    var ship1 = widget.purchaseDetails.shippingAddressLine1;
    var ship2 = widget.purchaseDetails.shippingAddressLine2;
    if(primaryAddressLine1 == ship1 && primaryAddressLine2 == ship2){
      setState(() {
        isPrimary = true;
        print('primary is selected');
      });
    }else if(secondaryAddressLine1 == ship1 && secondaryAddressLine1 == ship2){
      setState(() {
        isPrimary = false;
        print('secondary is selected');
      });
    }

    DateTime endDate = DateTime.parse((widget.purchaseDetails.endDate));

    DateTime startDate = DateTime.parse((widget.purchaseDetails.startDate));

    var primaryList = [];
    var secondaryList = [];
    var totalDays = [];

    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      if(listOfAvailableDays.contains( DateFormat('EEEE').format(startDate.add(Duration(days: i)))))
      {

        isPrimary ? primaryList.add(startDate.add(Duration(days: i)).toString().split(" ")[0].toString()+" 00:00:00")
            : secondaryList.add(startDate.add(Duration(days: i)).toString().split(" ")[0].toString()+" 00:00:00");
        totalDays.add(startDate.add(Duration(days: i)).toString().split(" ")[0].toString());
      }
    }

    var primaryAndSecondary = [];
    print("||||||||||||||||");
    print(primaryList);
    print(totalDays);
    primaryAndSecondary.add(primaryList);
    primaryAndSecondary.add([]);
    primaryAndSecondary.add(totalDays);

    print(primaryAndSecondary);

    return primaryAndSecondary;

  }

  getPrimaryAndSecondaryWithBreak({breaks,primaryList,secondaryList}){
    print('with break called');

    print(breaks);

    DateTime endDate = DateTime.parse((widget.purchaseDetails.endDate));

    DateTime startDate = DateTime.parse((widget.purchaseDetails.startDate));

    var totalDays = [];
    print(breaks.length);
    for (int i = 0; i <= endDate.difference(startDate).inDays+breaks.length; i++) {
      if(listOfAvailableDays.contains( DateFormat('EEEE').format(startDate.add(Duration(days: i)))))
      {
          totalDays.add(startDate.add(Duration(days: i)).toString().split(" ")[0]);
      }
    }

    var primaryAndSecondary = [];
    print("||||||||||||||");
    print(breaks.length);
    print(primaryList);
    print(totalDays);
    primaryAndSecondary.add(primaryList);
    primaryAndSecondary.add(secondaryList);
    primaryAndSecondary.add(totalDays);
    return primaryAndSecondary;
  }


  var isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        accentColor:  Color.fromRGBO(144, 144, 144, 1),
      ),
      child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: white,
          appBar: AppBar(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0))),
            backgroundColor: white,
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
            title: Text('Placed Meal Orders', style: appBarTextStyle.copyWith(color: defaultGreen)),
          ),
          body: Container(
            padding: EdgeInsets.only(top: 10),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        children: [
                          Flexible(
                            fit: FlexFit.loose,
                            flex: 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  flex: 7,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          widget.purchaseDetails.mealPlanName,
                                      style: selectedTab.copyWith(fontSize: 18,color: Colors.black)
                            ),
                                      ),
                                      SizedBox(height: 10,),
                                      Flexible(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 6),
                                          child: Text(
                                            widget.plan.details,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontFamily: 'RobotoCondensedReg',
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xFF77838F)
                                              ),
                                              maxLines: 3
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Flexible(
                                    flex: 3,
                                    child: Container(
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
                                        backgroundColor: Colors.white,
                                        child: CachedNetworkImage(
                                          imageUrl: widget.plan.picture ??
                                              "http://via.placeholder.com/350x150",
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          placeholder: (context, url) =>
                                              CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 30.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Text(
                                "${widget.purchaseDetails.mealPlanDuration} day meal plan • " +
                                    (widget.plan.type == 0
                                        ? "With Weekends"
                                        : "Without Weekends"),
                                  style: selectedTab.copyWith(
                                      fontSize: 13, fontWeight: FontWeight.normal,color: Color(0xFF909090))
                              ),
                            ),
                            Flexible(
                              fit: FlexFit.loose,
                              child: Text(
                                "${widget.purchaseDetails.kCal} Calorie",
                                  style: selectedTab.copyWith(
                                      fontSize: 13, fontWeight: FontWeight.normal,color: Color(0xFF909090))
                              ),
                            ),
                            Flexible(
                              child: Text(
                                'Start Date - ${formatDate(DateTime.parse(widget.purchaseDetails.startDate), format)}',
                                  style: selectedTab.copyWith(
                                      fontSize: 13, fontWeight: FontWeight.normal,color: Color(0xFF909090))
                              ),
                            ),
                          ],
                        ),
                      )),
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextButton(
                            onPressed: () async {
                              setState(() {
                                addressTapList.add(0);
                                isLoading = true;
                              });
                              var resource = await _apiCall.getBreakTakenDay();
                              var res = {};
                              setState(() {
                                isLoading = false;
                              });
                              for(int i =0;i<resource.length;i++){
                                if(resource[i]['meal_purchase_id'].toString() == widget.purchaseDetails.id.toString()){
                                  res = resource[i];
                                }
                              }
                              print(res);

                              if(res != null && res['primary_address_dates'] !=null && res['secondary_address_dates'] != null){
                                print('both address');
                                primaryDaysList = jsonDecode(res['primary_address_dates']);
                                for(int  i =0;i<primaryDaysList.length;i++){
                                  primaryDaysList[i] = primaryDaysList[i].toString().split(' ')[0];
                                }
                                secondaryDaysList = jsonDecode(res['secondary_address_dates']);
                                for(int  i =0;i<secondaryDaysList.length;i++){
                                  secondaryDaysList[i] = secondaryDaysList[i].toString().split(' ')[0];
                                }
                                makePostAddressCall = false;
                              }else if(res != null && res['primary_address_dates'] !=null){
                                primaryDaysList = jsonDecode(res['primary_address_dates']);
                                for(int  i =0;i<primaryDaysList.length;i++){
                                  primaryDaysList[i] = primaryDaysList[i].toString().split(' ')[0];
                                }
                                makePostAddressCall = false;
                              }else if(res != null && res['secondary_address_dates'] !=null){
                                secondaryDaysList = jsonDecode(res['secondary_address_dates']);
                                for(int  i =0;i<secondaryDaysList.length;i++){
                                  secondaryDaysList[i] = secondaryDaysList[i].toString().split(' ')[0];
                                }
                                makePostAddressCall = false;
                              }else{
                                makePostAddressCall = true;
                                print('yup called');
                                var primaryAndSecondary = getInitialPrimaryAndSecondary();
                                primaryDaysList = primaryAndSecondary[0];
                                secondaryDaysList = primaryAndSecondary[1];
                                for(int i =0;i<primaryDaysList.length;i++){
                                  primaryDaysList[i] = primaryDaysList[i].toString().split(' ')[0];
                                }
                                for(int i =0;i<secondaryDaysList.length;i++){
                                  secondaryDaysList[i] = secondaryDaysList[i].toString().split(' ')[0];
                                }
                              }

                              await showAddressCalendar(addressCalendar: true,id : res['id'],breakList : res['date_list'],pList: primaryDaysList,sList: secondaryDaysList);
                            },
                            child: Text(
                              'Address',
                              style: TextStyle(
                                color: darkGreen,
                                decoration: TextDecoration.underline,
                              ),
                            )),
                        TextButton(
                            onPressed: () async {
                              print(isLoaded);

                              setState(() {
                                isLoading = true;
                              });
                              var resource = await _apiCall.getBreakTakenDay();
                              var res = {};
                              setState(() {
                                isLoading = false;
                              });
                              int count = 0;
                              for(int i =0;i<resource.length;i++){
                                if(resource[i]['meal_purchase_id'].toString() == widget.purchaseDetails.id.toString()){
                                  res = resource[i];
                                }
                              }
                              print('printing res');
                              print(res);
                              var dateBreakList = [];
                              var breakDays = [];
                              if(res == null || res.length == 0){
                                var primaryAndSecondary = getInitialPrimaryAndSecondary();
                                dateBreakList = primaryAndSecondary[0]+primaryAndSecondary[1];
                                for(int i =0;i<dateBreakList.length;i++){
                                  dateBreakList[i] = dateBreakList[i].toString().split(' ')[0];
                                }

                                await showBreakCalendar(dateBreakList,breakDays,false,res['id'],primaryAndSecondary);
                              }else{
                                if(res['date_list'] == null || jsonDecode(res['date_list']).length == 0){
                                  print('break list is empty');
                                  var primaryAndSecondary = getInitialPrimaryAndSecondary();

                                  var primary = res['primary_address_dates'];
                                  var secondary = res['secondary_address_dates'];

                                  if(primary == null && secondary == null){
                                    var primaryList = primaryAndSecondary[0];
                                    var secondaryList = primaryAndSecondary[1];
                                  }else{
                                    var primaryList = res['primary_address_dates'] !=null ? jsonDecode(res['primary_address_dates']) : [];
                                    var secondaryList = res['secondary_address_dates'] != null ? jsonDecode(res['secondary_address_dates']) : [];
                                    primaryAndSecondary[0] = primaryList;
                                    primaryAndSecondary[1] = secondaryList;
                                  }

                                  dateBreakList = primaryAndSecondary[0]+primaryAndSecondary[1];
                                  for(int i =0;i<dateBreakList.length;i++){
                                    dateBreakList[i] = dateBreakList[i].toString().split(' ')[0];
                                  }

                                  await showBreakCalendar(dateBreakList,[],true,res['id'],primaryAndSecondary);

                                }else{
                                  print('else condition is called');
                                  var listOfDate = jsonDecode(res['date_list']);
                                  for(int i =0 ;i<listOfDate.length;i++){
                                    print(listOfDate[i]);
                                    breakDays.add(listOfDate[i].toString().split(" ")[0]);
                                  }
                                  var primaryAndSecondary = await getPrimaryAndSecondaryWithBreak(
                                      breaks: jsonDecode(res['date_list']),
                                      primaryList  : jsonDecode(res['primary_address_dates']),
                                      secondaryList : jsonDecode(res['secondary_address_dates'])
                                  );
                                  var breaks = jsonDecode(res['date_list']);
                                  print('printing break days');
                                  print(breaks);
                                  var lastBreak = breaks[breaks.length-1].toString().split(" ")[0];
                                  var ind = primaryAndSecondary[2].indexOf(lastBreak);
                                  print('printing break days');
                                  print(breakDays);
                                  dateBreakList = primaryAndSecondary[0]+primaryAndSecondary[1];
                                  for(int i =0;i<dateBreakList.length;i++){
                                    dateBreakList[i] = dateBreakList[i].toString().split(' ')[0];
                                  }

                                  await showBreakCalendar(dateBreakList,breakDays,true,res['id'],primaryAndSecondary);
                                }

                              }

                            },
                            child: Text(
                              'Breaks',
                              style: TextStyle(
                                color: darkGreen,
                                decoration: TextDecoration.underline,
                              ),
                            )),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
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
                      child: TabBar(
                        isScrollable: true,
                        controller: _pageController,
                        onTap: (index) {},
                        labelStyle: selectedTab.copyWith(
                            color: Colors.black, fontSize: 14),
                        indicatorColor: Colors.transparent,
                        indicatorWeight: 3.0,
                        indicatorSize: TabBarIndicatorSize.label,
                        labelColor: Colors.black,
                        labelPadding: EdgeInsets.symmetric(horizontal: 10),
                        unselectedLabelStyle:
                            unSelectedTab.copyWith(color: Colors.grey),
                        unselectedLabelColor: Colors.grey,
                        tabs: List.generate(
                            int.parse(widget.purchaseDetails.mealPlanDuration),
                            (index) {
                          return Tab(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Day ${(index + 1).toString()}',style:  TextStyle(
                                    color: Colors.black,
                                    fontSize: 12
                                ),),
                                Text(formatDate(dates[index], [dd, '/', mm]),style:  TextStyle(
                                    color: Color(0xFF909090),
                                    fontSize: 12,fontWeight: FontWeight.w400
                                ),)
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 16,
                    child: !isLoading ? isLoaded
                        ? TabBarView(
                            controller: _pageController,
                            children: List.generate(
                                int.parse(
                                    widget.purchaseDetails.mealPlanDuration),
                                (index) {
                              return Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      child: menuUi(day: index + 1),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      bool returnedBack = await Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (BuildContext context) =>
                                                  PlaceMealMenuOrders(
                                                      dates: dates,
                                                      placedFoodItems: foodItems,
                                                      plan: widget.plan,
                                                      purchaseDetails: widget
                                                          .purchaseDetails)));
                                      if (returnedBack) {
                                        getData();
                                      }
                                    },
                                    child: Container(
                                      height: 50,
                                      margin: EdgeInsets.only(top: 20),
                                      color: defaultGreen,
                                      child: Center(
                                          child: Text(
                                        'Edit Plan',
                                        style: selectedTab.copyWith(color: white),
                                      )),
                                    ),
                                  ),
                                ],
                              );
                            }))
                        : Center(child: SpinKitDoubleBounce(color: defaultGreen))  : Center(child: SpinKitDoubleBounce(color: defaultGreen)),
                  )
                ]),
          ) ),
    );
  }

  Widget foodItemCard(MenuOrderModel item) {
    return Container(
      height: 123,
      margin: EdgeInsets.symmetric(horizontal: 13),
      child: Row(
        children: [
          Expanded(
            flex: 8,
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Container(
                  //   height: 13,
                  //   width: 13,
                  //   child: Image.asset(
                  //     item.isVeg ? 'images/veg.png' : 'images/nonVeg.png',
                  //     fit: BoxFit.fitHeight,
                  //     scale: 0.5,
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 8,
                  // ),
                  Text(
                    item.foodItemName ?? "Food Name",
                    style: appBarTextStyle.copyWith(
                        fontSize: 13, fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    padding: EdgeInsets.only(right: 10),
                    child: IconButton(
                        onPressed: () {}, icon: Icon(Icons.favorite_border)),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                Positioned(
                    top: 0.0,
                    left: 0.0,
                    child: Container(
                      margin: EdgeInsets.only(right: 20),
                      height: 85,
                      width: 82,
                      decoration: authFieldDecoration,
                      child: CachedNetworkImage(
                        imageUrl: "http://via.placeholder.com/350x150",
                        imageBuilder: (context, imageProvider) => Container(
                          height: 60,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => FlutterLogo(
                          size: 60,
                        ),
                      ),
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget menuUi({int day}) {
    return ListView.separated(
      controller: _scrollController,
      shrinkWrap: true,
      itemCount: mainCategoryItems.length,
      itemBuilder: (BuildContext context, int indexMajor) {
        itemsFood = foodItems[indexMajor];
        return ExpansionTile(
            title: Text(
              mainCategoryItems[indexMajor].name,
              style: selectedTab.copyWith(fontSize: 18,fontWeight: FontWeight.w500,color: Colors.black),
            ),
            initiallyExpanded: indexMajor == 0 ? true : false,
            children: subCategoryItems[indexMajor].length == 0
                ? List.generate(itemsFood.length, (index) {
                    if (itemsFood[index].menuItemDay == day) {
                      return foodItemCard(itemsFood[index]);
                    }
                    return Container();
                  })
                : List.generate(subCategoryItems[indexMajor].length,
                    (int indexMinor) {
                    if (indexMajor == 2 && indexMinor == 0) {
                      itemsFood = foodItems[4];
                    } else if (indexMajor == 2 && indexMinor == 1) {
                      itemsFood = foodItems[5];
                    } else if (indexMajor == 4 && indexMinor == 0) {
                      itemsFood = foodItems[7];
                    } else if (indexMajor == 4 && indexMinor == 1) {
                      itemsFood = foodItems[8];
                    }
                    return ExpansionTile(
                        title: Text(
                          subCategoryItems[indexMajor][indexMinor].name,
                          style: selectedTab.copyWith(fontSize: 20),
                        ),
                        initiallyExpanded: indexMinor == 0 ? true : false,
                        children: List.generate(itemsFood.length, (index) {
                          if (itemsFood[index].menuItemDay == day) {
                            return foodItemCard(itemsFood[index]);
                          }
                          return Container();
                        }));
                  }));
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          thickness: 1.5,
          color: Colors.black12,
        );
      },
    );
  }

}

class CustomWeekdayLabelsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: Text("M", textAlign: TextAlign.center)),
        Expanded(child: Text("T", textAlign: TextAlign.center)),
        Expanded(child: Text("W", textAlign: TextAlign.center)),
        Expanded(child: Text("T", textAlign: TextAlign.center)),
        Expanded(child: Text("F", textAlign: TextAlign.center)),
        Expanded(child: Text("S", textAlign: TextAlign.center)),
        Expanded(child: Text("S", textAlign: TextAlign.center)),
      ],
    );
  }
}
