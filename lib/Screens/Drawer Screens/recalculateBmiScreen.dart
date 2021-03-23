import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:diet_delight/konstants.dart';
import 'package:diet_delight/Models/registrationModel.dart';
import 'package:diet_delight/services/apiCalls.dart';
import 'package:diet_delight/landingPage.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:diet_delight/Screens/Drawer Screens/bmiReport.dart';

class RecalculateBmi extends StatefulWidget {
  @override
  _RecalculateBmiState createState() => _RecalculateBmiState();
}

class _RecalculateBmiState extends State<RecalculateBmi> {
  final _apiCall = Api.instance;
  int gender = 0;
  int height = 180;
  int weight = 60;
  int age = 20;
  double bmi;
  String display_bmi = '0';
  List<double> bmi_values = [18.5, 25, 30];
  List<String> bmi_result = [
    'Underweight',
    'Normal Weight',
    'Overweight',
    'Obesity'
  ];
  List<String> calories_male = ['1600-1800', '1400', '1400', '1600'];
  List<String> calories_female = ['1400-1600', '1200', '1200', '1400'];
  int report = 0;

  @override
  Widget build(BuildContext context) {
    var devWidth = MediaQuery.of(context).size.width;
    var devHeight = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Container(
      decoration: BoxDecoration(image: bmiBackground, color: Colors.white),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.keyboard_backspace,
              size: 30.0,
              color: defaultGreen,
            ),
          ),
          centerTitle: true,
          title: Text(
            'BMI Calculator',
            style: questionnaireTitleStyle.copyWith(
                color: gender == 0 ? defaultGreen : defaultPurple),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(devWidth * 0.06, devWidth * 0.06,
              devWidth * 0.06, devWidth * 0.06),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        gender = 0;
                      });
                    },
                    child: Material(
                        elevation:
//                                                      gender == 0 ? 0 :
                            2,
//                                                shadowColor: Color(0x26000000),
                        borderRadius: BorderRadius.circular(20.0),
                        child: Container(
                            width: devWidth * 0.35,
                            decoration: gender == 0
                                ? BoxDecoration(
                                    boxShadow: [
                                        BoxShadow(
                                          blurRadius: 5,
                                          spreadRadius: -10,
                                        )
                                      ],
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: defaultGreen)
                                : BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: Colors.white),
                            child: Padding(
                                padding: EdgeInsets.fromLTRB(
                                  devWidth * 0.0,
                                  devWidth * 0.05,
                                  devWidth * 0.0,
                                  devWidth * 0.05,
                                ),
                                child: Column(
                                  children: [
                                    ImageIcon(
                                      AssetImage('images/male.png'),
                                      color: gender == 0
                                          ? Colors.white
                                          : questionnaireDisabled,
                                      size: 36,
                                    ),
                                    SizedBox(
                                      height: devHeight * 0.00625,
                                    ),
                                    Text(
                                      'MALE',
                                      style: gender == 0
                                          ? questionnaireDisabledStyle.copyWith(
                                              fontWeight: FontWeight.normal,
                                              color: Colors.white)
                                          : questionnaireDisabledStyle.copyWith(
                                              fontWeight: FontWeight.normal),
                                    )
                                  ],
                                )))),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        gender = 1;
                      });
                    },
                    child: Material(
                        elevation:
//                                                      gender == 1 ? 0 :
                            2,
//                                                shadowColor: Color(0x26000000),
                        borderRadius: BorderRadius.circular(20.0),
                        child: Container(
                            width: devWidth * 0.35,
                            decoration: BoxDecoration(
//                                                        boxShadow: [
//                                                          BoxShadow(
//                                                              color: Color(
//                                                                  0x26000000),
//                                                              blurRadius: 5)
//                                                        ],
                                borderRadius: BorderRadius.circular(20.0),
                                color:
                                    gender == 1 ? defaultPurple : Colors.white),
                            child: Padding(
                                padding: EdgeInsets.fromLTRB(
                                  devWidth * 0.0,
                                  devWidth * 0.05,
                                  devWidth * 0.0,
                                  devWidth * 0.05,
                                ),
                                child: Column(
                                  children: [
                                    ImageIcon(
                                      AssetImage('images/female.png'),
                                      color: gender == 1
                                          ? Colors.white
                                          : questionnaireDisabled,
                                      size: 36,
                                    ),
                                    SizedBox(
                                      height: devHeight * 0.00625,
                                    ),
                                    Text(
                                      'FEMALE',
                                      style: gender == 1
                                          ? questionnaireDisabledStyle.copyWith(
                                              fontWeight: FontWeight.normal,
                                              color: Colors.white)
                                          : questionnaireDisabledStyle.copyWith(
                                              fontWeight: FontWeight.normal),
                                    )
                                  ],
                                )))),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      RotatedBox(
                        quarterTurns: 3,
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            inactiveTrackColor: Color(0xFFEFEFEF),
                            activeTrackColor:
                                gender == 0 ? defaultGreen : defaultPurple,
                            thumbColor:
                                gender == 0 ? defaultGreen : defaultPurple,
                            overlayColor:
                                gender == 0 ? defaultGreen : defaultPurple,
                            thumbShape:
                                RoundSliderThumbShape(enabledThumbRadius: 12.0),
                            overlayShape:
                                RoundSliderOverlayShape(overlayRadius: 12.0),
                          ),
                          child: Slider(
                            value: height.toDouble(),
                            min: 120.0,
                            max: 220.0,
                            onChanged: (double newValue) {
                              setState(() {
                                height = newValue.round();
                              });
                            },
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 5.0),
                            child: Text(
                              height.toString(),
                              style: questionnaireDisabledStyle.copyWith(
                                  fontSize: 32),
                            ),
                          ),
                          Text(
                            'HEIGHT (cm)',
                            style: questionnaireDisabledStyle,
                          )
                        ],
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            weight.toString(),
                            style: questionnaireDisabledStyle.copyWith(
                                fontSize: 32),
                          ),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              inactiveTrackColor: Color(0xFFEFEFEF),
                              activeTrackColor:
                                  gender == 0 ? defaultGreen : defaultPurple,
                              thumbColor:
                                  gender == 0 ? defaultGreen : defaultPurple,
                              overlayColor:
                                  gender == 0 ? defaultGreen : defaultPurple,
                              thumbShape: RoundSliderThumbShape(
                                  enabledThumbRadius: 12.0),
                              overlayShape:
                                  RoundSliderOverlayShape(overlayRadius: 12.0),
                            ),
                            child: Slider(
                              value: weight.toDouble(),
                              min: 40.0,
                              max: 180.0,
                              onChanged: (double newValue) {
                                setState(() {
                                  weight = newValue.round();
                                });
                              },
                            ),
                          ),
                          Text(
                            'WEIGHT (kg)',
                            style: questionnaireDisabledStyle,
                          )
                        ],
                      ),
                      SizedBox(
                        height: devHeight * 0.05,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            age.toString(),
                            style: questionnaireDisabledStyle.copyWith(
                                fontSize: 32),
                          ),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              inactiveTrackColor: Color(0xFFEFEFEF),
                              activeTrackColor:
                                  gender == 0 ? defaultGreen : defaultPurple,
                              thumbColor:
                                  gender == 0 ? defaultGreen : defaultPurple,
                              overlayColor:
                                  gender == 0 ? defaultGreen : defaultPurple,
                              thumbShape: RoundSliderThumbShape(
                                  enabledThumbRadius: 12.0),
                              overlayShape:
                                  RoundSliderOverlayShape(overlayRadius: 12.0),
                            ),
                            child: Slider(
                              value: age.toDouble(),
                              min: 16.0,
                              max: 100.0,
                              onChanged: (double newValue) {
                                setState(() {
                                  age = newValue.round();
                                });
                              },
                            ),
                          ),
                          Text(
                            'AGE',
                            style: questionnaireDisabledStyle,
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50.0,
                  child: TextButton(
                    onPressed: () {
                      bmi = weight / (height * height / 10000);
                      display_bmi = bmi.toStringAsPrecision(3);
                      print(display_bmi);
                      if (bmi < bmi_values[0]) {
                        report = 0;
                      } else if (bmi < bmi_values[1]) {
                        report = 1;
                      } else if (bmi < bmi_values[2]) {
                        report = 2;
                      } else {
                        report = 3;
                      }
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BmiReport(
                                  bmi: display_bmi,
                                  report: report,
                                  age: age,
                                  gender: gender,
                                  questionnaire: false)));
                    },
                    child: Text(
                      'NEXT',
                      style: TextStyle(
                        fontFamily: 'RobotoReg',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: TextButton.styleFrom(
                        backgroundColor:
                            gender == 0 ? defaultGreen : defaultPurple,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25)))),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
