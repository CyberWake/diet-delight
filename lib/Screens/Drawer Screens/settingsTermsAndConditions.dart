import 'package:diet_delight/Screens/export.dart';
import 'package:flutter/material.dart';

class SettingsTermsAndConditionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                termsAndConditions,
                style: appBarTextStyle.copyWith(fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
