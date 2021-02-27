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
        padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10),
        child: ListView(
          children: [
            Container(color: Color(0xFFC4C4C4).withOpacity(0.4),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  termsAndConditions,
                  style: appBarTextStyle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
