import 'package:diet_delight/konstants.dart';
import 'package:diet_delight/services/apiCalls.dart';
import 'package:flutter/material.dart';

class SettingSecurities extends StatefulWidget {
  final GlobalKey<ScaffoldState> snackBarKey;
  SettingSecurities({this.snackBarKey});
  @override
  _SettingSecuritiesState createState() => _SettingSecuritiesState();
}

class _SettingSecuritiesState extends State<SettingSecurities> {
  final _apiCall = Api.instance;
  FocusNode passCur = FocusNode();
  FocusNode passNew = FocusNode();
  FocusNode passNewConf = FocusNode();
  FocusNode updatePass = FocusNode();
  TextEditingController curPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController newConfPassword = TextEditingController();
  bool updateInProgress = false;
  int items = 5;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width * 0.7,
      padding: EdgeInsets.only(top: 20),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(items, (index) {
            if (index == 0) {
              return Flexible(
                fit: FlexFit.loose,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'Change Password',
                      style: authInputTextStyle.copyWith(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              );
            } else if (index == 4) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 15.0, top: 20),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  height: 40,
                  child: TextButton(
                    onPressed: () async {
                      if (curPassword.text.isNotEmpty) {
                        if (newPassword.text == newConfPassword.text) {
                          setState(() {
                            updateInProgress = true;
                          });
                          bool result = await _apiCall.updatePassword(
                              curPassword.text, newPassword.text);
                          if (result) {
                            curPassword.clear();
                            newPassword.clear();
                            newConfPassword.clear();
                            setState(() {
                              updateInProgress = false;
                            });
                            widget.snackBarKey.currentState.showSnackBar(
                                SnackBar(
                                    content:
                                        Text('Password updated Successfully')));
                          } else {
                            widget.snackBarKey.currentState.showSnackBar(
                                SnackBar(
                                    content:
                                        Text('Couldn\'t update try again')));
                          }
                        } else {
                          widget.snackBarKey.currentState.showSnackBar(SnackBar(
                              content: Text('Passwords do not match')));
                        }
                      } else {
                        widget.snackBarKey.currentState.showSnackBar(SnackBar(
                            content: Text('Current Password Cannot be empty')));
                      }
                    },
                    child: Text(
                      updateInProgress ? 'UPDATING' : 'UPDATE',
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(20)))),
                  ),
                ),
              );
            } else {
              return Flexible(
                fit: FlexFit.loose,
                child: Container(
                  margin: EdgeInsets.fromLTRB(50, 10, 50, 10),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: white,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 4,
                        color: Colors.black.withOpacity(0.25),
                        spreadRadius: 0,
                        offset: const Offset(0.0, 0.0),
                      )
                    ],
                  ),
                  child: TextFormField(
                      controller: index == 1
                          ? curPassword
                          : index == 2
                              ? newPassword
                              : newConfPassword,
                      focusNode: index == 1
                          ? passCur
                          : index == 2
                              ? passNew
                              : passNewConf,
                      onFieldSubmitted: (done) {
                        index == 1
                            ? curPassword.text = done
                            : index == 2
                                ? newPassword.text = done
                                : newConfPassword.text = done;
                        if (index < 2) {
                          FocusScope.of(context)
                              .requestFocus(index == 0 ? passNew : passNewConf);
                        } else {
                          FocusScope.of(context).requestFocus(FocusNode());
                        }
                      },
                      style: authInputTextStyle.copyWith(fontSize: 16),
                      textAlign: TextAlign.left,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration: authInputFieldDecoration.copyWith(
                        hintText: index == 1
                            ? 'Enter Current Password'
                            : index == 2
                                ? 'Enter New Password'
                                : 'Confirm New Password',
                      )),
                ),
              );
            }
          })),
    );
  }
}
