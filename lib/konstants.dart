import 'package:flutter/material.dart';

const Color defaultGreen = Color(0xFF8BC53F);
const Color inactiveGreen = Color(0x808BC53F);
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
const TextStyle authLabelTextStyle = TextStyle(
  fontFamily: 'RobotoCondensedReg',
  fontSize: 12,
  fontWeight: FontWeight.normal,
  color: defaultGreen,
);
BoxDecoration authFieldDecoration = BoxDecoration(
    color: Colors.white,
    border: Border.all(color: formLinks, width: 1.0, style: BorderStyle.solid),
    borderRadius: BorderRadius.circular(5));
