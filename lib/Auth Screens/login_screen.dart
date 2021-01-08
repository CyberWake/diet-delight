import 'package:diet_delight/Home%20Page/home.dart';
import 'package:diet_delight/Models/loginModel.dart';
import 'package:diet_delight/konstants.dart';
import 'package:diet_delight/services/apiCalls.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'file:///C:/Users/VK/Desktop/ritik/diet-delight-mobile/lib/Auth%20Screens/forgotPassword.dart';

class Login extends StatefulWidget {
  final String token;
  Login({this.token});
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  FocusNode mailOrMobile;
  FocusNode pass;
  FocusNode submit;
  TextEditingController emailOrMobileNo = TextEditingController();
  TextEditingController password = TextEditingController();
  final storage = new FlutterSecureStorage();
  final _apiCall = Api.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pass = FocusNode();
    mailOrMobile = FocusNode();
    submit = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.0,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 20.0, 0, 0),
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 15, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('PHONE NUMBER / EMAIL ADDRESS',
                      style: authLabelTextStyle),
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
                              onChanged: (String account) {
                                emailOrMobileNo.text = account;
                              },
                              onFieldSubmitted: (done) {
                                emailOrMobileNo.text = done;
                                mailOrMobile.unfocus();
                                FocusScope.of(context).requestFocus(pass);
                              },
                              style: authInputTextStyle,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              focusNode: mailOrMobile,
                              decoration: authInputFieldDecoration),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
                                pass.unfocus();
                                FocusScope.of(context).requestFocus(submit);
                              },
                              style: authInputTextStyle,
                              keyboardType: TextInputType.emailAddress,
                              obscureText: true,
                              focusNode: pass,
                              textInputAction: TextInputAction.done,
                              decoration: authInputFieldDecoration),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 20, 0),
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => ForgotPassword()));
                  },
                  child: Text('Forgot Password?',
                      style: TextStyle(
                        fontFamily: 'RobotoCondensedReg',
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: formFill,
                      )),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: SizedBox(
                width: double.infinity,
                child: TextButton(
                  focusNode: submit,
                  onPressed: () async {
                    if (emailOrMobileNo.text.isNotEmpty) {
                      if (password.text.isNotEmpty) {
                        try {
                          var value = double.parse(emailOrMobileNo.text);
                          var mobile = value.toStringAsFixed(0);
                          LogModel loginDetails = LogModel(
                            mobile: mobile,
                            password: password.text,
                          );
                          loginDetails.show();
                          bool result = await _apiCall.login(loginDetails);
                          if (result) {
                            Navigator.pushReplacement(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => HomePage()));
                          }
                        } on FormatException {
                          if (EmailValidator.validate(emailOrMobileNo.text)) {
                            var email = emailOrMobileNo.text;
                            LogModel loginDetails = LogModel(
                              email: email,
                              password: password.text,
                            );
                            loginDetails.show();
                            bool result = await _apiCall.login(loginDetails);
                            if (result) {
                              Navigator.pushReplacement(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => HomePage()));
                            }
                          } else {
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text('Enter a valid email'),
                            ));
                          }
                        }
                      } else {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text('Password Field can\'t be empty'),
                        ));
                      }
                    } else {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content:
                            Text('Phone number/ Email Field can\'t be empty'),
                      ));
                    }
                  },
                  child: Text(
                    'SIGN IN',
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
              padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0),
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
