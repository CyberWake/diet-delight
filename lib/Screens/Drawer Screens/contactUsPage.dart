import 'dart:math';
import 'package:diet_delight/Screens/export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsPage extends StatefulWidget {
  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  FocusNode nameField = FocusNode();
  FocusNode emailField = FocusNode();
  FocusNode commentField = FocusNode();
  FocusNode submitButton = FocusNode();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController comment = TextEditingController();
  List<String> urls = [
    'tel: +917259384025',
    '',
    'https://www.instagram.com/dietdelightbh/',
    'https://twitter.com/dietdelightbh',
    'https://www.facebook.com/DietDeligh-BH'
  ];

  List<Widget> iconButtons = [
    Transform.rotate(
      angle: pi * 2.5,
      child: FaIcon(
        FontAwesomeIcons.phone,
        size: 25.0,
      ),
    ),
    FaIcon(
      FontAwesomeIcons.whatsapp,
      size: 28.0,
    ),
    FaIcon(
      FontAwesomeIcons.instagram,
      size: 28.0,
    ),
    FaIcon(
      FontAwesomeIcons.twitter,
      size: 28.0,
    ),
    FaIcon(
      FontAwesomeIcons.facebook,
      size: 28.0,
    ),
  ];

  Widget inputField({String hint, int index, double height}) {
    return Container(
      height: height,
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: Colors.black.withOpacity(0.25),
            spreadRadius: 0,
            offset: const Offset(0.0, 0.0),
          )
        ],
      ),
      child: TextField(
        decoration: authInputFieldDecoration.copyWith(hintText: hint),
        textInputAction:
            index != 2 ? TextInputAction.next : TextInputAction.done,
        keyboardType:
            index != 1 ? TextInputType.text : TextInputType.emailAddress,
        focusNode: index == 0
            ? nameField
            : index == 1
                ? emailField
                : commentField,
        controller: index == 0
            ? name
            : index == 1
                ? email
                : comment,
        onSubmitted: (done) {
          index == 0
              ? nameField.unfocus()
              : index == 1
                  ? emailField.unfocus()
                  : commentField.unfocus();
          FocusScope.of(context).requestFocus(
            index == 0
                ? emailField
                : index == 1
                    ? commentField
                    : submitButton,
          );
        },
      ),
    );
  }

  Widget bottomButtons({Widget child, Function onPress, bool shapeWithBorder}) {
    return Expanded(
      child: RawMaterialButton(
          elevation: 0.0,
          onPressed: onPress,
          fillColor: Colors.white,
          child: child,
          shape: shapeWithBorder
              ? CircleBorder(side: BorderSide(color: Colors.black))
              : CircleBorder()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 20),
            child: Image.asset(
              'images/Group 57.png',
              height: 80.0,
              fit: BoxFit.fitHeight,
            ),
          ),
          inputField(
              hint: 'Name',
              index: 0,
              height: MediaQuery.of(context).size.height * 0.07),
          inputField(
              hint: 'Email',
              index: 1,
              height: MediaQuery.of(context).size.height * 0.07),
          inputField(
              hint: 'Comment',
              index: 2,
              height: MediaQuery.of(context).size.height * 0.15),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
                backgroundColor: defaultGreen,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)))),
            child: Text(
              'Send',
              style: TextStyle(color: white),
            ),
            focusNode: submitButton,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Row(
                children: List.generate(5, (index) {
              return bottomButtons(
                onPress: () async {
                  if (index != 1) {
                    if (await canLaunch(urls[index])) {
                      await launch(
                        urls[index],
                        universalLinksOnly: true,
                      );
                    } else {
                      throw 'There was a problem to open the url: ${urls[index]}';
                    }
                  } else {
                    FlutterOpenWhatsapp.sendSingleMessage(
                        "917259384025", "Hello");
                  }
                },
                child: iconButtons[index],
                shapeWithBorder: false,
              );
            })),
          ),
        ],
      ),
    );
  }
}
