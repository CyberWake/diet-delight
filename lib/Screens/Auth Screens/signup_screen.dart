import 'package:diet_delight/Models/export_models.dart';
import 'package:diet_delight/Screens/export.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  final String token;
  SignUp({this.token});
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  FocusNode first = FocusNode();
  FocusNode last = FocusNode();
  FocusNode country = FocusNode();
  FocusNode mobile = FocusNode();
  FocusNode mail = FocusNode();
  FocusNode pass = FocusNode();
  FocusNode confPass = FocusNode();
  FocusNode submit = FocusNode();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController countryCode = TextEditingController();
  TextEditingController mobileNo = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPass = TextEditingController();

  var firstNameText;
  var secondNameText;
  var phoneNumberText;
  var emailText;
  var firstPasswordText;
  var confirmPassText;

  @override
  void initState() {
    super.initState();
    countryCode.text = '+973';
  }

  /*getPhoneNumbers() async {
    mobileNo.text = await _autoFill.hint;
    if (mobileNo.text.isNotEmpty) {
      countryCode.text = mobileNo.text.substring(0, 3);
      mobileNo.text = mobileNo.text.substring(3);
      FocusScope.of(context).requestFocus(mail);
    }
  }*/

  @override
  Widget build(BuildContext context) {
    double devWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 600.0,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('NAME', style: authLabelTextStyle),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8.0, 20, 0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: Material(
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              width: devWidth / 2.5,
                              height: 40.0,
                              decoration: authFieldDecoration,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 5, 20, 5),
                                child: TextFormField(

                                    onChanged: (done) {
                                      firstName.text = done;
                                    },
                                    onFieldSubmitted: (done) {
                                      first.unfocus();
                                      FocusScope.of(context).requestFocus(last);
                                    },
                                    textAlign: TextAlign.center,
                                    textDirection: TextDirection.ltr,
                                    keyboardType: TextInputType.name,
                                    focusNode: first,
                                    textInputAction: TextInputAction.next,
                                    style: authInputTextStyle,
                                    decoration: authInputFieldDecoration
                                        .copyWith(hintText: 'First Name')),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Material(
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              width: devWidth / 2.5,
                              height: 40.0,
                              decoration: authFieldDecoration,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 5, 20, 5),
                                child: TextFormField(
                                    onChanged: (done) {
                                      lastName.text = done;
                                    },
                                    onFieldSubmitted: (done) {
                                      last.unfocus();
                                      FocusScope.of(context)
                                          .requestFocus(mobile);
                                    },
                                    textAlign: TextAlign.center,
                                    textDirection: TextDirection.ltr,
                                    keyboardType: TextInputType.name,
                                    focusNode: last,
                                    textInputAction: TextInputAction.next,
                                    style: authInputTextStyle,
                                    decoration: authInputFieldDecoration
                                        .copyWith(hintText: 'Last Name')),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            //Phone number field
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 15, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('PHONE NUMBER', style: authLabelTextStyle),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8.0, 20, 0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: Material(
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              width: devWidth / 5,
                              height: 40.0,
                              decoration: authFieldDecoration,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 3, 15, 7),
                                child: TextFormField(
                                  focusNode: country,
                                  onChanged: (done) {
                                    countryCode.text = done;
                                  },
                                  onFieldSubmitted: (done) {
                                    country.unfocus();
                                    FocusScope.of(context).requestFocus(mobile);
                                  },
                                  initialValue: '+973',
                                  style: TextStyle(
                                    fontFamily: 'RobotoCondensedReg',
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: formFill,
                                  ),
                                  textAlign: TextAlign.center,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.phone,
                                  decoration: authInputFieldDecoration,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Material(
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              width: 3 * devWidth / 5,
                              height: 40.0,
                              decoration: authFieldDecoration,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 3, 20, 7),
                                child: TextFormField(
                                    controller: mobileNo,
                                    onFieldSubmitted: (done) {
                                      setState(() {
                                        mobileNo..text = done;
                                        mobile.unfocus();
                                        FocusScope.of(context)
                                            .requestFocus(mail);
                                      });
                                    },
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.phone,
                                    focusNode: mobile,
                                    textInputAction: TextInputAction.next,
                                    style: authInputTextStyle,
                                    decoration: authInputFieldDecoration),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            //email field
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 15, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('EMAIL ADDRESS', style: authLabelTextStyle),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8.0, 20, 0),
                    child: Material(
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        width: double.infinity,
                        height: 40.0,
                        decoration: authFieldDecoration,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 3, 20, 7),
                          child: TextFormField(
                              onChanged: (done) {
                                email.text = done;
                              },
                              onFieldSubmitted: (done) {
                                mail.unfocus();
                                FocusScope.of(context).requestFocus(pass);
                              },
                              style: authInputTextStyle,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              focusNode: mail,
                              decoration: authInputFieldDecoration),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //password field
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 15, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ENTER PASSWORD', style: authLabelTextStyle),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8.0, 20, 0),
                    child: Material(
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        width: double.infinity,
                        height: 40.0,
                        decoration: authFieldDecoration,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 3, 20, 7),
                          child: TextFormField(
                              onChanged: (done) {
                                password.text = done;
                              },
                              onFieldSubmitted: (done) {
                                pass.unfocus();
                                FocusScope.of(context).requestFocus(confPass);
                              },
                              style: authInputTextStyle,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              obscureText: true,
                              focusNode: pass,
                              decoration: authInputFieldDecoration),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //confirm password field
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 15, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('CONFIRM PASSWORD', style: authLabelTextStyle),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8.0, 20, 0),
                    child: Material(
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        width: double.infinity,
                        height: 40.0,
                        decoration: authFieldDecoration,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 3, 20, 7),
                          child: TextFormField(
                              focusNode: confPass,
                              onChanged: (done) {
                                confirmPass.text = done;
                              },
                              onFieldSubmitted: (done) {
                                confPass.unfocus();
                                FocusScope.of(context).requestFocus(submit);
                              },

                              style: authInputTextStyle,
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              textInputAction: TextInputAction.done,
                              decoration: authInputFieldDecoration),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //submit button
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: SizedBox(
                width: double.infinity,
                child: TextButton(
                  focusNode: submit,
                  onPressed: () async {
                    print(confirmPass.text);
                    print(password.text);
                    print(firstName.text);
                    print(lastName.text);
                    if (EmailValidator.validate(email.text)) {
                      if (confirmPass.text.toString() ==
                              (password.text).toString() &&
                          confirmPass.text.isNotEmpty &&
                          countryCode.text.isNotEmpty &&
                          password.text.isNotEmpty &&
                          firstName.text.isNotEmpty &&
                          lastName.text.isNotEmpty) {
                        RegModel signUpDetails = RegModel(
                            name: firstName.text + ' ' + lastName.text,
                            firstName: firstName.text,
                            lastName: lastName.text,
                            email: email.text,
                            password: password.text,
                            mobile: countryCode.text + mobileNo.text);
                        signUpDetails.show();
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => VerifyPhoneNumber(
                                      regDetails: signUpDetails,
                                      from: FromPage.signUp,
                                    )));
                      } else {
                        if (confirmPass.text != password.text) {
                          Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text('Passwords do not match')));
                        } else if (confirmPass.text.isEmpty) {
                          print(confirmPass.text);
                          Scaffold.of(context).showSnackBar(SnackBar(
                              content:
                                  Text('Enter the confirmation password')));
                        } else if (countryCode.text.isEmpty) {
                          Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text('Country code cannot be empty')));
                        } else if (password.text.isEmpty) {
                          Scaffold.of(context).showSnackBar(
                              SnackBar(content: Text('Enter the password')));
                        } else if (firstName.text.isEmpty) {
                          Scaffold.of(context).showSnackBar(
                              SnackBar(content: Text('Enter your first name')));
                        } else if (lastName.text.isEmpty) {
                          Scaffold.of(context).showSnackBar(
                              SnackBar(content: Text('Enter your last name')));
                        }
                      }
                    } else {
                      print(email.text);
                      print(EmailValidator.validate(email.text));
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text('Enter a valid email')));
                    }
                  },
                  child: Text(
                    'SIGN UP',
                    style: TextStyle(
                      fontFamily: 'RobotoCondensedReg',
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                  style: TextButton.styleFrom(
                      backgroundColor: defaultGreen,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)))),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    color: defaultGreen,
                    height: 1,
                    width: 130,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                    child: Text('OR', style: authLabelTextStyle),
                  ),
                  Container(
                    color: defaultGreen,
                    height: 1,
                    width: 130,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 50.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 100.0,
                    child: TextButton(
                      onPressed: () {},
                      child: Image.asset('images/Group 59.png', width: 11),
                      style: TextButton.styleFrom(
                          backgroundColor: fColor,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)))),
                    ),
                  ),
                  SizedBox(
                    width: 100.0,
                    child: TextButton(
                      onPressed: () {},
                      child: Image.asset('images/Group 58.png', width: 18),
                      style: TextButton.styleFrom(
                          backgroundColor: gColor,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)))),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
