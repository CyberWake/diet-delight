import 'package:diet_delight/Auth%20Screens/verifyPhoneNumber.dart';
import 'package:diet_delight/Models/registrationModel.dart';
import 'package:diet_delight/konstants.dart';
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
  FocusNode country;
  FocusNode mobile;
  FocusNode mail;
  FocusNode pass;
  FocusNode confPass;
  FocusNode submit;
  TextEditingController countryCode = TextEditingController();
  TextEditingController mobileNo = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPass = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    country = FocusNode();
    mobile = FocusNode();
    mail = FocusNode();
    pass = FocusNode();
    confPass = FocusNode();
    submit = FocusNode();
    countryCode.text = '+91';
  }

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
            //Phone number field
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
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
                                    const EdgeInsets.fromLTRB(20, 3, 20, 7),
                                child: TextFormField(
                                  focusNode: country,
                                  onChanged: (String code) {
                                    countryCode.text = code;
                                  },
                                  onFieldSubmitted: (done) {
                                    countryCode.text = done;
                                    country.unfocus();
                                    FocusScope.of(context).requestFocus(mobile);
                                  },
                                  initialValue: '+91',
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
                                    onChanged: (String mobile) {
                                      mobileNo.text = mobile;
                                    },
                                    onFieldSubmitted: (done) {
                                      mobileNo.text = done;
                                      mobile.unfocus();
                                      FocusScope.of(context).requestFocus(mail);
                                    },
                                    textAlign: TextAlign.center,
                                    textDirection: TextDirection.ltr,
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
                          padding: const EdgeInsets.fromLTRB(20, 3, 20, 7),
                          child: TextFormField(
                              onChanged: (String mail) {
                                email.text = mail;
                              },
                              onFieldSubmitted: (done) {
                                email.text = done;
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
                              onChanged: (String pass) {
                                password.text = pass;
                              },
                              onFieldSubmitted: (done) {
                                password.text = done;
                                mail.unfocus();
                                FocusScope.of(context).requestFocus(confPass);
                              },
                              style: authInputTextStyle,
                              keyboardType: TextInputType.emailAddress,
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
                              onChanged: (String passConfirm) {
                                confirmPass.text = passConfirm;
                              },
                              onFieldSubmitted: (done) {
                                confirmPass.text = done;
                                confPass.unfocus();
                                FocusScope.of(context).requestFocus(submit);
                              },
                              style: authInputTextStyle,
                              keyboardType: TextInputType.emailAddress,
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
                    if (EmailValidator.validate(email.text)) {
                      if (confirmPass.text == password.text &&
                          countryCode.text.isNotEmpty &&
                          confirmPass.text.isNotEmpty &&
                          password.text.isNotEmpty) {
                        RegModel signUpDetails = RegModel(
                            email: email.text,
                            password: password.text,
                            mobile: countryCode.text + ' ' + mobileNo.text);
                        //signUpDetails.show();
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => VerifyPhoneNumber(
                                      regDetails: signUpDetails,
                                    )));
                      } else {
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text('Passwords do not match')));
                      }
                    } else {
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
