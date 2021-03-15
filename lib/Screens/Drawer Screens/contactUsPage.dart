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
      child: CircleAvatar(
        backgroundColor: defaultGreen,
        child: FaIcon(
          FontAwesomeIcons.phone,
          size: 25.0,
          color: white,
        ),
      ),
    ),
    CircleAvatar(
      backgroundColor: defaultGreen,
      child: FaIcon(
        FontAwesomeIcons.whatsapp,
        size: 28.0,
        color: white,
      ),
    ),
    CircleAvatar(
      backgroundColor: defaultGreen,
      child: FaIcon(
        FontAwesomeIcons.instagram,
        size: 28.0,
        color: white,
      ),
    ),
    CircleAvatar(
      backgroundColor: defaultGreen,
      child: FaIcon(
        FontAwesomeIcons.twitter,
        size: 28.0,
        color: white,
      ),
    ),
    CircleAvatar(
      backgroundColor: defaultGreen,
      child: FaIcon(
        FontAwesomeIcons.facebook,
        size: 28.0,
        color: white,
      ),
    ),
  ];

  var emailError = false;

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

  Widget inputFieldForEmail({String hint, int index, double height}) {
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
        onChanged: (value) {
          if (value == null ||
              value.length == 0 ||
              !value.contains('@') ||
              value.length < 3) {
            setState(() {
              emailError = true;
              print('true');
            });
          } else {
            setState(() {
              emailError = false;
              print('false');
            });
          }
        },
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
          fillColor: Colors.transparent,
          child: child,
          shape: shapeWithBorder
              ? CircleBorder(side: BorderSide(color: Colors.black))
              : CircleBorder()),
    );
  }

  var commentError = false;
  var nameError = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        alignment: Alignment.center,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 20),
              child: Image.asset(
                'images/Group 57.png',
                height: 80.0,
                fit: BoxFit.fitHeight,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                inputField(
                  hint: 'Name',
                  index: 0,
                  height: MediaQuery.of(context).size.height * 0.07,
                ),
                nameError
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "Please enter your name",
                            style: TextStyle(
                              color: defaultGreen,
                            ),
                          ),
                        ),
                      )
                    : Container()
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                inputFieldForEmail(
                    hint: 'Email',
                    index: 1,
                    height: MediaQuery.of(context).size.height * 0.07),
                emailError
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "Please enter valid email address.",
                            style: TextStyle(
                              color: defaultGreen,
                            ),
                          ),
                        ),
                      )
                    : Container()
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                inputField(
                    hint: 'Comment',
                    index: 2,
                    height: MediaQuery.of(context).size.height * 0.15),
                commentError
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "Please enter comment.",
                            style: TextStyle(color: defaultGreen),
                          ),
                        ),
                      )
                    : Container()
              ],
            ),
            Row(
              children: [
                Spacer(),
                TextButton(
                  onPressed: email != null &&
                          comment.text != null &&
                          comment.text.length > 0 &&
                          name.text.length > 0 &&
                          name.text != null
                      ? () async {
                          print('called');
                          print(comment.text);
                          print(name.text);
                          await sendEmail(name.text, email.text, comment.text);
                        }
                      : () {
                          print(commentError);
                          if (email == null) {
                            setState(() {
                              emailError = true;
                            });
                          }
                          if (comment.text == null ||
                              comment.text.length <= 0) {
                            setState(() {
                              commentError = true;
                            });
                          }
                          if (name.text == null || name.text.length <= 0) {
                            setState(() {
                              nameError = true;
                            });
                          }
                        },
                  style: TextButton.styleFrom(
                      backgroundColor: defaultGreen,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)))),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: Text(
                      'Send',
                      style: TextStyle(
                        fontFamily: 'RobotoCondensedReg',
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  focusNode: submitButton,
                ),
                Spacer(),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
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
      ),
    );
  }
}
