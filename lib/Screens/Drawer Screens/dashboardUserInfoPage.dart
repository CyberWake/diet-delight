import 'package:diet_delight/Models/export_models.dart';
import 'package:diet_delight/Screens/export.dart';
import 'package:diet_delight/Widgets/shadow_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DashBoardUserInfoPage extends StatefulWidget {
  final GlobalKey<ScaffoldState> snackBarKey;
  DashBoardUserInfoPage({this.snackBarKey});
  @override
  _DashBoardUserInfoPageState createState() => _DashBoardUserInfoPageState();
}

class _DashBoardUserInfoPageState extends State<DashBoardUserInfoPage> {
  FocusNode fullName = FocusNode();
  TextEditingController name = TextEditingController();
  TextEditingController mobileNo = TextEditingController();
  TextEditingController email = TextEditingController();
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
            child: ShadowText(
              name.text,
              style: authInputTextStyle.copyWith(
                color: Color(0xFF303960),
                fontSize: 30,
                fontWeight: FontWeight.w700,
                fontFamily: 'RobotoReg',
              ),
              maxLines: 1,
            ),
            // child: TextField(
            //   controller: name,
            //   onSubmitted: (done) {
            //     name.text = done;
            //   },
            //   style: authInputTextStyle.copyWith(
            //       color: Color(0xFF303960),
            //       fontSize: 30,
            //       fontWeight: FontWeight.w700,
            //       fontFamily: 'RobotoReg'),
            //   textAlign: TextAlign.left,
            //   keyboardType: TextInputType.text,
            //   textInputAction: TextInputAction.next,
            //   focusNode: focusNode,
            //   decoration: InputDecoration(
            //     border: InputBorder.none,
            //     hintText: 'Username',
            //   ),
            // ),
          ),
        ],
      ),
    );
  }

  Widget generateStaticTextField({IconData fieldIcon, String fieldValue}) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 48),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 41,
            width: 41,
            child: RawMaterialButton(
                elevation: 0.0,
                onPressed: () {},
                fillColor: Color(0xffF5F5F5),
                child: Icon(fieldIcon, color: Color(0xFF303960), size: 16),
                shape: CircleBorder()),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.05,
          ),
          SizedBox(
            // width: MediaQuery.of(context).size.width * 0.4,
            child: Text(fieldValue,
                // style: selectedTab.copyWith(
                //     color: Color(0xFF303960),
                //     fontSize: 18,
                //     fontWeight: FontWeight.w400),
                style: TextStyle(
                  color: Color(0xFF303960),
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'RobotReg',
                )),
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
              ? Icons.location_on_outlined
              : Icons.add_location_alt_outlined,
          size: 16,
          color: Color(0xFF303960),
        ),
        shape: CircleBorder(),
        onPressed: () {},
      ),
    );
  }

  Widget generateOnTapFields({String fieldName, int index, Function onPress}) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 48),
      child: AddressButtonWithModal(
        index: index,
        addNewAddressOnly: true,
        callBackFunction: callback,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            index == 0
                ? primaryAddressLine1.isNotEmpty
                    ? addressMarkWidget(present: true)
                    : addressMarkWidget(present: false)
                : secondaryAddressLine1.isNotEmpty
                    ? addressMarkWidget(present: true)
                    : addressMarkWidget(present: false),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.05,
            ),
            SizedBox(
              // width: MediaQuery.of(context).size.width * 0.4,
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      index == 0
                          ? primaryAddressLine1.isNotEmpty
                              ? fieldName
                              : 'Add $fieldName'
                          : secondaryAddressLine1.isNotEmpty
                              ? fieldName
                              : 'Add $fieldName',
                      // style: selectedTab.copyWith(
                      //     fontSize: 18,
                      //     fontWeight: FontWeight.w400,
                      //     color: Color(0xFF303960)),
                      style: TextStyle(
                        color: Color(0xFF303960),
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'RobotReg',
                      ),
                    ),
                    index == 0
                        ? primaryAddressLine1.isNotEmpty
                            ? showAddress(index)
                            : Container()
                        : secondaryAddressLine1.isNotEmpty
                            ? showAddress(index)
                            : Container()
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget showAddress(int index) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10),
      child: Text(
        index == 0
            ? primaryAddressLine1 + ',\n' + primaryAddressLine2
            : secondaryAddressLine1 + ',\n' + secondaryAddressLine2,
        style: TextStyle(
            color: Color(0xFF77838F),
            fontSize: 14,
            fontWeight: FontWeight.w400,
            fontFamily: 'RobotoReg'),
      ),
    );
  }

  Widget generateInfoCard() {
    return Padding(
      padding: EdgeInsets.only(
        left: MediaQuery.of(context).size.width * 0.1,
        top: 8,
      ),
      child: Row(
        children: [
          Text(
            '${Api.userInfo.age ?? 'N/A'} yrs',
            style: TextStyle(
                color: Color(0xFF303960),
                fontWeight: FontWeight.w600,
                fontFamily: 'RobotoReg'),
          ),
          SizedBox(
            width: 30,
          ),
          Text(
            Api.userInfo.gender == 0 ? 'Male' : 'Female',
            style: TextStyle(
                color: Color(0xFF303960),
                fontWeight: FontWeight.w600,
                fontFamily: 'RobotoReg'),
          ),
          SizedBox(width: 8),
          Image.asset(
            Api.userInfo.gender == 0 ? 'images/male.png' : 'images/female.png',
            height: 18,
            width: 18,
          ),

          // FaIcon(Api.userInfo.gender == 1
          //     ? FontAwesomeIcons.female
          //     : Api.userInfo.gender == 0
          //         ? FontAwesomeIcons.male
          //         : FontAwesomeIcons.fighterJet)
        ],
      ),
    );
  }

  Widget generateStatCard() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(2, (index) {
        return Container(
          height: MediaQuery.of(context).size.width * 0.425,
          width: MediaQuery.of(context).size.width * 0.425,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Color(0xFFE5E5E5),
          ),
          child: Center(
            child: Container(
              height: MediaQuery.of(context).size.width * 0.327,
              width: MediaQuery.of(context).size.width * 0.327,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.25),
                      blurRadius: 5,
                      spreadRadius: 0,
                      offset: Offset(0, 4))
                ],
                borderRadius: BorderRadius.circular(50),
                color: Color(0xFF77838F),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.0305),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: Padding(
                        padding: EdgeInsets.only(top: index == 0 ? 8.0 : 12.0),
                        child: Text(
                          index == 0
                              ? Api.userInfo.bmi ?? 'N/A'
                              : '${Api.userInfo.recommendedCalories}',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w700,
                            color: white,
                            fontFamily: 'KalamReg',
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                        fit: FlexFit.loose,
                        child: Text(
                          index == 0
                              ? 'Your BMI'
                              : 'Recommended Calorie Intake',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: white,
                              fontFamily: 'KalamReg'),
                        ))
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget generateReCalculateButton() {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.175, vertical: 15),
      child: SizedBox(
        height: 40,
        child: TextButton(
          onPressed: () async {
            /*SharedPreferences prefs = await SharedPreferences.getInstance();
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
              Scaffold.of(context).showSnackBar(
                  SnackBar(content: Text('User Info Updated Successfully')));
            } else {
              Scaffold.of(context).showSnackBar(
                  SnackBar(content: Text('User Info Update Failed')));
            }*/
          },
          child: Text(
            updateInProgress ? 'RRecalculate BMIe' : 'Recalculate BMI',
            style: TextStyle(
                // fontFamily: 'RobotoCondensedReg',
                fontSize: 20,
                fontWeight: FontWeight.normal,
                color: Colors.white,
                fontFamily: 'RobotReg'),
          ),
          style: TextButton.styleFrom(
              backgroundColor: Color(0xFF303960),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)))),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage('images/user_dashboard_bg.jpg'),
        fit: BoxFit.cover,
      )),
      child: ListView(
        shrinkWrap: true,
        children: [
          SizedBox(height: 20),
          IgnorePointer(
              ignoring: true,
              child: generateTextField(focusNode: fullName, index: 0)),
          generateInfoCard(),
          SizedBox(height: 30),
          generateStatCard(),
          SizedBox(height: 20),
          generateReCalculateButton(),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Divider(
              thickness: 1.5,
            ),
          ),
          generateStaticTextField(
              fieldIcon: Icons.phone, fieldValue: mobileNo.text),
          generateStaticTextField(
              fieldIcon: Icons.email, fieldValue: email.text),
          generateOnTapFields(
              fieldName: 'Primary Address', index: 0, onPress: () {}),
          generateOnTapFields(
              fieldName: 'Secondary Address', index: 1, onPress: () {}),
          SizedBox(
            height: 40,
          )
        ],
      ),
    );
  }
}
