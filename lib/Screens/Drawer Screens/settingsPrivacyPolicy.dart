import 'package:flutter/material.dart';

class SettingsPrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/Group 7.png'),
              fit: BoxFit.cover
          )
      ),
      child: Center(
        child: Text("Nothing to display",style: TextStyle(
        color: Color.fromRGBO(144, 144, 144, 1),
          fontFamily: 'MontserratMed',
          fontWeight: FontWeight.w700,
          fontSize: 14),),
      ),
    );
  }
}
