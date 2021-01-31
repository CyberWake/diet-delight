import 'package:diet_delight/konstants.dart';
import 'package:flutter/material.dart';

class SettingsTermsAndConditionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
