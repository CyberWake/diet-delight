import 'package:flutter/material.dart';

const Color defaultGreen = Color(0xFF8BC53F);
const Color darkGreen = Color(0xFF079404);
const Color inactiveGreen = Color(0x808BC53F);
const Color white = Color(0xFFFFFFFF);
const Color formBackground = Color(0x8DFFFFFF);
const Color formFill = Color(0xFF808080);
const Color formLinks = Color(0xFF999999);
const fColor = Color(0xFF3C589A);
const gColor = Color(0xFFDD4B38);
const Color defaultPurple = Color(0xFF78288B);
const Color inactivePurple = Color(0x8078288B);
const Color cardGray = Color(0xFF666666);
const Color timeGrid = Color(0xFF303030);
const Color inactiveTime = Color(0xFF909090);
InputDecoration authInputFieldDecoration = InputDecoration(
  fillColor: Colors.white,
  focusedBorder: InputBorder.none,
  enabledBorder: InputBorder.none,
  errorBorder: InputBorder.none,
  disabledBorder: InputBorder.none,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(3.0),
  ),
);
const TextStyle authInputTextStyle = TextStyle(
  fontFamily: 'RobotoCondensedReg',
  fontSize: 14,
  fontWeight: FontWeight.normal,
  color: formFill,
);

const TextStyle unSelectedTab = TextStyle(
  fontFamily: 'RobotoCondensedReg',
  fontSize: 14,
  fontWeight: FontWeight.bold,
);

const TextStyle selectedTab = TextStyle(
  fontFamily: 'RobotoCondensedReg',
  fontSize: 18,
  fontWeight: FontWeight.bold,
);

const TextStyle authLabelTextStyle = TextStyle(
  fontFamily: 'RobotoCondensedReg',
  fontSize: 12,
  fontWeight: FontWeight.normal,
  color: defaultGreen,
);
const TextStyle tabTextStyle = TextStyle(
  fontFamily: 'RobotoCondensedReg',
  fontSize: 12,
  fontWeight: FontWeight.bold,
);
const TextStyle dateTabTextStyle = TextStyle(
  fontFamily: 'RobotoCondensedReg',
  fontSize: 12,
  fontWeight: FontWeight.normal,
);

const appBarTextStyle = TextStyle(
  fontFamily: 'RobotoCondensedReg',
  fontSize: 24,
  fontWeight: FontWeight.normal,
  color: Colors.black,
);

BoxDecoration authFieldDecoration = BoxDecoration(
    color: Colors.white,
    border: Border.all(color: formLinks, width: 1.0, style: BorderStyle.solid),
    borderRadius: BorderRadius.circular(5));
List<List<Color>> itemColors = [
  [
    Color(0xFF808080),
    Color(0xFFE0E0E0),
    Color(0xFFE8E8E8),
    Color(0xFFDFDFDF),
    Color(0xFF999999)
  ],
  [
    Color(0xFF8080A1),
    Color(0xFFE0E0FF),
    Color(0xFFE8E8FF),
    Color(0xFFDFDFFF),
    Color(0xFF9999BA)
  ],
  [
    Color(0xFFA3784B),
    Color(0xFFFEDF97),
    Color(0xFFFCE7B3),
    Color(0xFFFFDD8F),
    Color(0xFFBA9360)
  ],
];
List<Widget> ddItems = List.generate(
    3,
    (index) => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: itemColors[index]),
          ),
          child: Padding(
              padding: EdgeInsets.fromLTRB(15, 3, 15, 3),
              child: Text(
                index == 0
                    ? 'SILVER'
                    : index == 1
                        ? 'Platinum'
                        : 'Gold',
                style: TextStyle(
                  fontFamily: 'RobotoCondensedReg',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              )),
        ));

List<Widget> mealPlanDropdownItems = List.generate(
  5,
  (index) => Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [white, white]),
    ),
    child: Padding(
        padding: EdgeInsets.fromLTRB(15, 3, 15, 3),
        child: Text(
          'Calorie',
          style: TextStyle(
            fontFamily: 'RobotoCondensedReg',
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        )),
  ),
);
