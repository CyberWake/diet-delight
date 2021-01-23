import 'package:diet_delight/Models/menuModel.dart';
import 'package:diet_delight/Screens/menupage.dart';
import 'package:diet_delight/konstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';

class MealPlanOrderHistoryPage extends StatefulWidget {
  @override
  _MealPlanOrderHistoryPageState createState() =>
      _MealPlanOrderHistoryPageState();
}

class _MealPlanOrderHistoryPageState extends State<MealPlanOrderHistoryPage> {
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
  String addressType = 'Home';
  PersistentBottomSheetController _controller;

  Widget dataField({String fieldName, String fieldValue}) {
    return Flexible(
        fit: FlexFit.loose,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Text(fieldName)),
              Expanded(child: Text(fieldValue)),
            ],
          ),
        ));
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
                            },
                            initialValue:
                                index == 0 ? addressType : addressArea,
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
                              focusNode: addressFocus,
                              onFieldSubmitted: (done) {
                                localAddress = done;
                              },
                              initialValue: localAddress,
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
                          if (address == 0) {
                            addressPrimary.text =
                                localAddress + ',' + addressArea;
                          } else if (address == 1) {
                            addressSecondary.text =
                                localAddress + ',' + addressArea;
                          }
                          addressModalStateUpdate(() {});
                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 20),
                          color: defaultGreen,
                          child: Center(
                              child: Text(
                            localAddress.length > 0 && addressArea != null
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

  void getBottomSheet({int address}) {
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
                                child: index == 0
                                    ? addressPrimary.text.isNotEmpty
                                        ? Center(
                                            child: Text(
                                            addressPrimary.text,
                                            style: selectedTab.copyWith(
                                                color: selectedAddress == index
                                                    ? white
                                                    : defaultGreen,
                                                fontWeight: FontWeight.w400),
                                          ))
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
                                                      addAddress(
                                                          address: index);
                                                    },
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text('Not Available')
                                                ],
                                              )
                                            ],
                                          )
                                    : addressSecondary.text.isNotEmpty
                                        ? Center(
                                            child: Text(
                                            addressPrimary.text,
                                            style: selectedTab.copyWith(
                                                color: selectedAddress == index
                                                    ? white
                                                    : defaultGreen,
                                                fontWeight: FontWeight.w400),
                                          ))
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
                                                      addAddress(
                                                          address: index);
                                                    },
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text('Not Available')
                                                ],
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
  void initState() {
    super.initState();
    addressFocus.addListener(() {
      if (addressFocus.hasFocus) {
        print('height increased');
        setState(() {
          items = 5;
          _height = 600;
        });
      } else if (!addressFocus.hasFocus) {
        print('height decreased');
        setState(() {
          items = 4;
          _height = 350;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: List.generate(3, (index) {
        return Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                  fit: FlexFit.loose,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(child: Text('Menu Plan')),
                        Flexible(
                            child: IconButton(
                                icon: Icon(Icons.more_vert), onPressed: () {})),
                      ],
                    ),
                  )),
              Flexible(
                  fit: FlexFit.loose,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Meal Plan Name'),
                  )),
              dataField(
                fieldName: 'Subscription:',
                fieldValue: '2 Weeks\nMon, Tue, Wed, Fri, Sun',
              ),
              dataField(
                fieldName: 'Remaining Days:',
                fieldValue: '12',
              ),
              Flexible(
                  fit: FlexFit.loose,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                            onPressed: () {
                              MenuModel menu =
                                  MenuModel(id: 1, name: 'One Meal Plan');
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (BuildContext context) => Menu(
                                            menu: menu,
                                          )));
                            },
                            child: Text(
                              'Menu',
                              style: TextStyle(
                                color: darkGreen,
                                decoration: TextDecoration.underline,
                              ),
                            )),
                        TextButton(
                            onPressed: () {},
                            child: Text(
                              'Breaks',
                              style: TextStyle(
                                color: darkGreen,
                                decoration: TextDecoration.underline,
                              ),
                            )),
                        TextButton(
                            onPressed: () {
                              getBottomSheet();
                            },
                            child: Text(
                              'Address',
                              style: TextStyle(
                                color: darkGreen,
                                decoration: TextDecoration.underline,
                              ),
                            )),
                      ],
                    ),
                  )),
              Flexible(
                  fit: FlexFit.loose,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.schedule),
                        SizedBox(
                          width: 10,
                        ),
                        Text('4:40pm 12 Jan, 2021'),
                        Spacer(),
                        Text('100 BHD')
                      ],
                    ),
                  ))
            ],
          ),
        );
      }),
    );
  }
}
