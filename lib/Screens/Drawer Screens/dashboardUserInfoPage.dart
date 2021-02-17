import 'package:diet_delight/Models/registrationModel.dart';
import 'package:diet_delight/Widgets/getAddressModalSheet.dart';
import 'package:diet_delight/konstants.dart';
import 'package:diet_delight/services/apiCalls.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashBoardUserInfoPage extends StatefulWidget {
  final GlobalKey<ScaffoldState> snackBarKey;
  DashBoardUserInfoPage({this.snackBarKey});
  @override
  _DashBoardUserInfoPageState createState() => _DashBoardUserInfoPageState();
}

class _DashBoardUserInfoPageState extends State<DashBoardUserInfoPage> {
  FocusNode fullName = FocusNode();
  FocusNode phoneNo = FocusNode();
  FocusNode mail = FocusNode();
  FocusNode passCur = FocusNode();
  FocusNode passNew = FocusNode();
  FocusNode passNewConf = FocusNode();
  FocusNode updatePass = FocusNode();
  TextEditingController name = TextEditingController();
  TextEditingController mobileNo = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController curPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController newConfPassword = TextEditingController();
  int items = 4;
  RegModel info;
  final _apiCall = Api.instance;
  bool passwordUpdated = false;
  bool updateInProgress = false;

  getUserInfo() async {
    info = Api.userInfo;
    name.text = info.firstName + ' ' + info.lastName;
    mobileNo.text = info.mobile;
    email.text = info.email;
  }

  callback(address) {
    setState(() {
      concatenatedAddress = address;
    });
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  Widget generateTextField({FocusNode focusNode, int index}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 3,
            child: TextField(
              controller: name,
              onSubmitted: (done) {
                name.text = done;
              },
              style: authInputTextStyle.copyWith(
                  fontSize: 30, fontWeight: FontWeight.w600),
              textAlign: TextAlign.left,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              focusNode: focusNode,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Username',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget generateStaticTextField({IconData fieldIcon, String fieldValue}) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 41,
            width: 41,
            child: RawMaterialButton(
                elevation: 0.0,
                onPressed: () {},
                fillColor: Color(0xffF5F5F5),
                child: Icon(
                  fieldIcon,
                  color: defaultGreen,
                  size: 16,
                ),
                shape: CircleBorder()),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.07,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: Text(
              fieldValue,
              style: selectedTab.copyWith(
                  fontSize: 18, fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }

  Widget addressMarkWidget({bool present}) {
    return SizedBox(
      height: 41,
      width: 41,
      child: RawMaterialButton(
        elevation: 0.0,
        fillColor: Color(0xffF5F5F5),
        child: Icon(
          present
              ? Icons.where_to_vote_rounded
              : Icons.add_location_alt_outlined,
          size: 16,
          color: defaultGreen,
        ),
        shape: CircleBorder(),
      ),
    );
  }

  Widget generateOnTapFields({String fieldName, int index, Function onPress}) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: AddressButtonWithModal(
        addNewAddressOnly: true,
        callBackFunction: callback,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            index == 0
                ? primaryAddressLine1 != null
                    ? addressMarkWidget(present: true)
                    : addressMarkWidget(present: false)
                : secondaryAddressLine1 != null
                    ? addressMarkWidget(present: true)
                    : addressMarkWidget(present: false),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.07,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    fieldName,
                    style: selectedTab.copyWith(
                        fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10),
                    child: Text(
                      index == 0
                          ? primaryAddressLine1 + ',\n' + primaryAddressLine2
                          : index == 1
                              ? secondaryAddressLine1 +
                                  ',\n' +
                                  secondaryAddressLine2
                              : 'Not available',
                      style: TextStyle(
                          color: defaultGreen,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            shrinkWrap: true,
            children: [
              generateTextField(focusNode: fullName, index: 0),
              generateStaticTextField(
                  fieldIcon: Icons.phone, fieldValue: mobileNo.text),
              generateStaticTextField(
                  fieldIcon: Icons.email, fieldValue: email.text),
              generateOnTapFields(
                  fieldName: 'Primary Address', index: 0, onPress: () {}),
              generateOnTapFields(
                  fieldName: 'Secondary Address', index: 1, onPress: () {}),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Divider(
                  thickness: 1.5,
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.width * 0.7,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(items, (index) {
                      print('working');
                      if (index == 0) {
                        return Flexible(
                          fit: FlexFit.loose,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text(
                              'Change Password',
                              style: authInputTextStyle.copyWith(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500),
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
                                    FocusScope.of(context).requestFocus(
                                        index == 0 ? passNew : passNewConf);
                                  } else {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                  }
                                },
                                style:
                                    authInputTextStyle.copyWith(fontSize: 16),
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
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.75,
            height: 40,
            child: TextButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String password = prefs.getString('password');
                setState(() {});
                List<String> nameBreak = name.text.split(' ');
                RegModel updateUserData = RegModel(
                  name: name.text,
                  firstName: nameBreak[0],
                  lastName: nameBreak[nameBreak.length - 1],
                  email: email.text,
                  mobile: mobileNo.text,
                  password: password,
                  addressLine1: primaryAddressLine1,
                  addressSecondary1: secondaryAddressLine1,
                  addressLine2: primaryAddressLine2,
                  addressSecondary2: secondaryAddressLine2,
                );
                updateUserData.show();
                bool result = await _apiCall.putUserInfo(updateUserData);
                setState(() {});
                if (result) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text('User Info Updated Successfully')));
                } else {
                  Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text('User Info Update Failed')));
                }
                if (curPassword.text.isNotEmpty) {
                  if (newPassword.text == newConfPassword.text) {
                    setState(() {
                      updateInProgress = true;
                    });
                    bool result = await _apiCall.updatePassword(
                        curPassword.text, newPassword.text);
                    if (result) {
                      getUserInfo();
                      setState(() {
                        passwordUpdated = true;
                      });
                      setState(() {
                        updateInProgress = false;
                      });
                      widget.snackBarKey.currentState.showSnackBar(SnackBar(
                          content: Text('Password updated Successfully')));
                      Navigator.pop(context);
                    } else {
                      Navigator.pop(context);
                    }
                  } else {
                    setState(() {
                      passwordUpdated = false;
                    });
                    Navigator.pop(context);
                    widget.snackBarKey.currentState.showSnackBar(
                        SnackBar(content: Text('Passwords do not match')));
                  }
                } else {
                  print(info.password);
                  setState(() {
                    passwordUpdated = false;
                  });
                  Navigator.pop(context);
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
                      borderRadius: BorderRadius.all(Radius.circular(20)))),
            ),
          ),
        )
      ],
    );
  }
}
