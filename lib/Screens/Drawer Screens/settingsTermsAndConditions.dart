import 'package:diet_delight/Screens/export.dart';
import 'package:flutter/material.dart';

class SettingsTermsAndConditionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/Group 7.png'),
              fit: BoxFit.cover
          )
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: ListView(
          children: [
            Text(
              termsAndConditions,
              style: appBarTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}
