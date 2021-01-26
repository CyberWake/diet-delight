import 'package:diet_delight/Models/menuModel.dart';
import 'package:diet_delight/Screens/menupage.dart';
import 'package:diet_delight/konstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
