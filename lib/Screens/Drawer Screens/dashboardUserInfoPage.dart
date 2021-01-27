import 'package:diet_delight/Models/registrationModel.dart';
import 'package:diet_delight/konstants.dart';
import 'package:diet_delight/services/apiCalls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';

class DashBoardUserInfoPage extends StatefulWidget {
  @override
  _DashBoardUserInfoPageState createState() => _DashBoardUserInfoPageState();
}

class _DashBoardUserInfoPageState extends State<DashBoardUserInfoPage> {
  FocusNode fullName = FocusNode();
  FocusNode phoneNo = FocusNode();
  FocusNode mail = FocusNode();
  FocusNode addressFocus = FocusNode();
  FocusNode passCur = FocusNode();
  FocusNode passNew = FocusNode();
  FocusNode passNewConf = FocusNode();
  FocusNode updatePass = FocusNode();
  TextEditingController name = TextEditingController();
  TextEditingController mobileNo = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController addressPrimary = TextEditingController();
  TextEditingController addressSecondary = TextEditingController();
  TextEditingController curPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController newConfPassword = TextEditingController();
  String addressType = 'Home';
  String addressArea = 'Bahrain';
  String localAddress = '';
  List<String> types = ['Home', 'Work'];
  List<String> areas = ['Bahrain', 'India'];
  double _height = 300;
  int items = 4;
  RegModel info;
  final _apiCall = Api.instance;
  bool passwordUpdated = false;

  getUserInfo() async {
    info = Api.userInfo;
    name.text = info.firstName + ' ' + info.lastName;
    mobileNo.text = info.mobile;
    email.text = info.email;
    addressPrimary.text = info.address;
    addressSecondary.text = info.addressSecondary;
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
    addressFocus.addListener(() {
      if (addressFocus.hasFocus) {
        print('height increased');
        setState(() {
          items = 5;
          _height = 550;
        });
      } else if (!addressFocus.hasFocus) {
        print('height decreased');
        setState(() {
          items = 4;
          _height = 300;
        });
      }
    });
    passCur.addListener(() {
      if (passCur.hasFocus) {
        print('height increased');
        setState(() {
          items = 5;
          _height = 550;
        });
      } else if (!passCur.hasFocus) {
        print('height decreased');
        setState(() {
          items = 4;
          _height = 300;
        });
      }
    });
    passNew.addListener(() {
      if (passNew.hasFocus) {
        print('height increased');
        setState(() {
          items = 5;
          _height = 550;
        });
      } else if (!passNew.hasFocus) {
        print('height decreased');
        setState(() {
          items = 4;
          _height = 300;
        });
      }
    });
    passNewConf.addListener(() {
      if (passNewConf.hasFocus) {
        print('height increased');
        setState(() {
          items = 5;
          _height = 550;
        });
      } else if (!passNewConf.hasFocus) {
        print('height decreased');
        setState(() {
          items = 4;
          _height = 300;
        });
      }
    });
  }

  Widget generateTextField({String fieldName, FocusNode focusNode, int index}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 34, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
              flex: 2,
              child: Text(
                fieldName,
                style: selectedTab.copyWith(
                    fontSize: 18, fontWeight: FontWeight.w400),
              )),
          Flexible(
            flex: 3,
            child: Container(
              decoration: authFieldDecoration,
              child: TextFormField(
                  controller: index == 0
                      ? name
                      : index == 1
                          ? mobileNo
                          : email,
                  onFieldSubmitted: (done) {
                    switch (index) {
                      case 0:
                        name.text = done;
                        break;
                      case 1:
                        mobileNo.text = done;
                        break;
                      case 2:
                        email.text = done;
                        break;
                    }
                  },
                  style: authInputTextStyle.copyWith(fontSize: 16),
                  textAlign: TextAlign.center,
                  keyboardType: index == 0
                      ? TextInputType.text
                      : index == 1
                          ? TextInputType.phone
                          : TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  focusNode: focusNode,
                  decoration: authInputFieldDecoration),
            ),
          ),
        ],
      ),
    );
  }

  Widget generateStaticTextField({String fieldName, String fieldValue}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 40, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
              flex: 2,
              child: Text(
                fieldName,
                style: selectedTab.copyWith(
                    fontSize: 18, fontWeight: FontWeight.w400),
              )),
          Flexible(
              flex: 3,
              child: Center(
                child: Text(
                  fieldValue,
                  style: selectedTab.copyWith(
                      fontSize: 18, fontWeight: FontWeight.w400),
                ),
              )),
        ],
      ),
    );
  }

  Widget generateOnTapFields(
      {String fieldName, String text, Function onPress}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 34, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
              flex: 2,
              child: Text(
                fieldName,
                style: selectedTab.copyWith(
                    fontSize: 18, fontWeight: FontWeight.w400),
              )),
          Flexible(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: Center(
                        child: Text(
                          text,
                          style: TextStyle(
                              color: defaultGreen,
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: IconButton(
                        icon: Icon(
                          Icons.edit,
                          size: 15,
                        ),
                        onPressed: onPress),
                  )
                ],
              ))
        ],
      ),
    );
  }

  void getPassBottomSheet() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        builder: (builder) {
          return Container(
            height: _height,
            color: Colors.transparent,
            child: Container(
                padding: EdgeInsets.only(top: 30),
                child: Column(
                    children: List.generate(items, (index) {
                  if (index < 3) {
                    return Expanded(
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
                            controller: index == 0
                                ? curPassword
                                : index == 1
                                    ? newPassword
                                    : newConfPassword,
                            focusNode: index == 0
                                ? passCur
                                : index == 1
                                    ? passNew
                                    : passNewConf,
                            onFieldSubmitted: (done) {
                              index == 0
                                  ? curPassword.text = done
                                  : index == 1
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
                            style: authInputTextStyle.copyWith(fontSize: 16),
                            textAlign: TextAlign.left,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            decoration: authInputFieldDecoration.copyWith(
                              hintText: index == 0
                                  ? 'Enter Current Password'
                                  : index == 1
                                      ? 'Enter New Password'
                                      : 'Confirm New Password',
                            )),
                      ),
                    );
                  } else if (index == 3) {
                    return Expanded(
                        child: Container(
                      margin: EdgeInsets.only(top: 20),
                      color: defaultGreen,
                      child: TextButton(
                        focusNode: updatePass,
                        onPressed: () {
                          if (curPassword.text == info.password) {
                            if (newPassword.text == newConfPassword.text) {
                              setState(() {
                                passwordUpdated = true;
                              });
                              Navigator.pop(context);
                            } else {
                              setState(() {
                                passwordUpdated = false;
                              });
                              Navigator.pop(context);
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text('Passwords do not match')));
                            }
                          } else {
                            setState(() {
                              passwordUpdated = false;
                            });
                            Navigator.pop(context);
                            Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text('Incorrect Current Password')));
                          }
                        },
                        child: Center(
                            child: Text(
                          'Update',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w600),
                        )),
                      ),
                    ));
                  } else {
                    return SizedBox(
                      height: 250,
                    );
                  }
                }))),
          );
        });
  }

  void getBottomSheet({int address}) {
    if (address == 0 && addressPrimary.text.isNotEmpty) {
      var separatedAddress = addressPrimary.text.split(',');
      addressArea = separatedAddress[separatedAddress.length - 1];
      if (!areas.contains(addressArea)) {
        areas.add(addressArea);
      }
      localAddress = separatedAddress[0];
    } else if (address == 1 && addressSecondary.text.isNotEmpty) {
      var separatedAddress = addressSecondary.text.split(',');
      addressArea = separatedAddress[separatedAddress.length - 1];
      if (!areas.contains(addressArea)) {
        areas.add(addressArea);
      }
      localAddress = separatedAddress[0];
    } else {
      localAddress = '';
    }
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        builder: (builder) {
          return Container(
            height: _height,
            color: Colors.transparent,
            child: Container(
                padding: EdgeInsets.only(top: 30),
                child: Column(
                    children: List.generate(items, (index) {
                  if (index < 2) {
                    return Expanded(
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
                        child: DropDown<String>(
                          showUnderline: false,
                          items: index == 0 ? types : areas,
                          onChanged: (String choice) {
                            if (index == 0) {
                              addressType = choice;
                            } else if (index == 1) {
                              addressArea = choice;
                            }
                          },
                          initialValue: index == 0 ? addressType : addressArea,
                          isExpanded: true,
                        ),
                      ),
                    );
                  } else if (index == 2) {
                    return Expanded(
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
                            focusNode: addressFocus,
                            onFieldSubmitted: (done) {
                              localAddress = done;
                            },
                            initialValue: localAddress,
                            style: authInputTextStyle,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            decoration: authInputFieldDecoration.copyWith(
                                hintText: 'House #, House name, Street name')),
                      ),
                    );
                  } else if (index == 3) {
                    return Expanded(
                        child: GestureDetector(
                      onTap: () {
                        if (address == 0) {
                          addressPrimary.text =
                              localAddress + ',' + addressArea;
                        } else if (address == 1) {
                          addressSecondary.text =
                              localAddress + ',' + addressArea;
                        }
                        setState(() {});
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 20),
                        color: defaultGreen,
                        child: Center(
                            child: Text(
                          localAddress.length > 0 || addressArea != null
                              ? 'Update'
                              : 'ADD',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        )),
                      ),
                    ));
                  } else {
                    return SizedBox(
                      height: 250,
                    );
                  }
                }))),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            shrinkWrap: true,
            children: [
              generateTextField(
                  fieldName: 'Full Name', focusNode: fullName, index: 0),
              generateStaticTextField(
                  fieldName: 'Username', fieldValue: 'CyberWake'),
              generateOnTapFields(
                  fieldName: 'Password',
                  text: 'Change',
                  onPress: () {
                    getPassBottomSheet();
                  }),
              generateTextField(
                  fieldName: 'Phone Number', focusNode: phoneNo, index: 1),
              generateTextField(fieldName: 'Email', focusNode: mail, index: 2),
              generateOnTapFields(
                  fieldName: 'Address',
                  text: addressPrimary.text.isNotEmpty
                      ? addressPrimary.text
                      : 'Address',
                  onPress: () {
                    getBottomSheet(address: 0);
                  }),
              generateOnTapFields(
                  fieldName: 'Secondary Address',
                  text: addressSecondary.text.isNotEmpty
                      ? addressSecondary.text
                      : 'Address',
                  onPress: () {
                    getBottomSheet(address: 1);
                  }),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            List<String> nameBreak = name.text.split(' ');
            RegModel updateUserData = RegModel(
              name: name.text,
              firstName: nameBreak[0],
              lastName: nameBreak[nameBreak.length - 1],
              email: email.text,
              mobile: mobileNo.text,
              address: addressPrimary.text,
              addressSecondary: addressSecondary.text,
              password: passwordUpdated ? newConfPassword.text : info.password,
            );
            updateUserData.show();
            _apiCall.putUserInfo(updateUserData);
            Scaffold.of(context).showSnackBar(
                SnackBar(content: Text('User Info Updated Successfully')));
          },
          child: Container(
            height: 45,
            color: defaultGreen,
            child: Center(
                child: Text(
              'UPDATE',
              style: TextStyle(fontWeight: FontWeight.w600),
            )),
          ),
        )
      ],
    );
  }
}
