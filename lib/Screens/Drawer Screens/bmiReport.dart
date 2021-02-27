import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:diet_delight/konstants.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class BmiReport extends StatefulWidget {
  String bmi;
  int report;
  bool questionnaire;
  int gender;

  BmiReport({this.bmi, this.report, this.questionnaire, this.gender});
  @override
  _BmiReportState createState() => _BmiReportState();
}

class _BmiReportState extends State<BmiReport> {
  List<String> bmi_result = [
    'Underweight',
    'Normal Weight',
    'Overweight',
    'Obesity'
  ];
  List<String> calories_male = ['1600-1800', '1400', '1400', '1600'];
  List<String> calories_female = ['1400-1600', '1200', '1200', '1400'];

  @override
  Widget build(BuildContext context) {
    var devWidth = MediaQuery.of(context).size.width;
    var devHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/questionnaire_background.jpg'),
                fit: BoxFit.fitHeight),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: EdgeInsets.only(top: devHeight * 0.0),
                child: Center(
                  child: Text(
                    widget.questionnaire == true ? 'BMI Report' : 'Your BMI',
                    style: questionnaireTitleStyle.copyWith(
                        color:
                            widget.gender == 0 ? defaultGreen : defaultPurple),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(devWidth * 0.06, devWidth * 0.0,
                    devWidth * 0.06, devWidth * 0.0),
                child: Container(
                  height: devHeight * 0.8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Material(
                            elevation: 0,
//                                        shadowColor: defaultGreen,
                            color: widget.gender == 0
                                ? defaultGreen
                                : defaultPurple,
                            shape: CircleBorder(),
                            child: CircularPercentIndicator(
                              radius: 130.0,
                              lineWidth: 10.0,
                              percent: 100 / 100,
                              center: new Text(
                                '${widget.bmi}',
                                style: TextStyle(
                                    color: white,
                                    fontSize: 48,
                                    fontFamily: 'KalamReg',
                                    fontWeight: FontWeight.bold),
                              ),
                              progressColor: blurredDefaultGreen,
                              backgroundColor: Colors.transparent,
//                  fillColor: Colors.white,
                            ),
                          ),
                          SizedBox(height: devHeight * 0.01),
                          Text(
                            '${bmi_result[widget.report]}',
                            style: questionnaireTitleStyle.copyWith(
                                fontSize: 28,
                                color: widget.gender == 0
                                    ? defaultGreen
                                    : defaultPurple),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Recommended Calorie Intake',
                            style: questionnaireTitleStyle.copyWith(
                                color: questionnaireDisabled, fontSize: 24),
                          ),
                          SizedBox(height: devHeight * 0.02),
                          Center(
                              child: Text(
                                  widget.gender == 0
                                      ? '${calories_male[widget.report]} kcal'
                                      : '${calories_female[widget.report]} kcal',
                                  style: questionnaireDisabledStyle.copyWith(
                                      fontSize: 32,
                                      color: widget.gender == 0
                                          ? defaultGreen
                                          : defaultPurple))),
                        ],
                      ),
                      Column(
//                                          mainAxisAlignment:
//                                              MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Please consult a medical practitioner if you - ',
                            style: questionnaireTitleStyle.copyWith(
                                color: questionnaireDisabled, fontSize: 16),
                          ),
                          Row(
                            children: [
                              Icon(Icons.arrow_right_alt_rounded,
                                  color: widget.gender == 0
                                      ? defaultGreen
                                      : defaultPurple,
                                  size: 28),
                              Text(
                                'have a pre-existing medical condition',
                                style: questionnaireTitleStyle.copyWith(
                                    color: questionnaireDisabled,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.arrow_right_alt_rounded,
                                  color: widget.gender == 0
                                      ? defaultGreen
                                      : defaultPurple,
                                  size: 28),
                              Text(
                                'are less than 18 or more than 60 years of age',
                                style: questionnaireTitleStyle.copyWith(
                                    color: questionnaireDisabled,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.arrow_right_alt_rounded,
                                  color: widget.gender == 0
                                      ? defaultGreen
                                      : defaultPurple,
                                  size: 28),
                              Expanded(
                                child: Text(
                                  'are trying to gain weight, are an athlete or a body-builder',
                                  style: questionnaireTitleStyle.copyWith(
                                      color: questionnaireDisabled,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12),
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                          widget.gender == 0
                              ? SizedBox()
                              : Row(
                                  children: [
                                    Icon(Icons.arrow_right_alt_rounded,
                                        color: widget.gender == 0
                                            ? defaultGreen
                                            : defaultPurple,
                                        size: 28),
                                    Text(
                                      'are pregnant or a breastfeeding mother.',
                                      style: questionnaireTitleStyle.copyWith(
                                          color: questionnaireDisabled,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                      widget.questionnaire == true
                          ? Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: SizedBox(
                                width: double.infinity,
                                height: 50.0,
                                child: TextButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
//                                          CupertinoPopupSurface(
//                                        isSurfacePainted: true,
//                                        child: Container(
//                                          decoration: BoxDecoration(
//                                            image: DecorationImage(
//                                                image: AssetImage(
//                                                    'images/popup_background.jpg'),
//                                                fit: BoxFit.fill),
//                                          ),
//                                          child: CupertinoAlertDialog(
////                                                  title: new
//                                            content: Column(
//                                              crossAxisAlignment:
//                                                  CrossAxisAlignment.start,
//                                              children: [
//                                                Text(
//                                                  "Hello there!",
//                                                  style:
//                                                      questionnaireOptionsStyle
//                                                          .copyWith(
//                                                              fontWeight:
//                                                                  FontWeight
//                                                                      .w600,
//                                                              fontSize: 13),
//                                                ),
//                                                Text(
//                                                  "Are you unsure about what you need? Why not book an consultation with one of our experts to help you through the process?",
//                                                  style:
//                                                      questionnaireOptionsStyle
//                                                          .copyWith(
//                                                              fontWeight:
//                                                                  FontWeight
//                                                                      .w600,
//                                                              fontSize: 13),
//                                                ),
//                                              ],
//                                            ),
//                                            actions: <Widget>[
//                                              CupertinoDialogAction(
//                                                child: Text("NO THANKS",
//                                                    style:
//                                                        questionnaireOptionsStyle
//                                                            .copyWith(
//                                                                fontSize: 16)),
//                                                onPressed: () {
//                                                  Navigator.pop(context);
//                                                },
//                                              ),
//                                              CupertinoDialogAction(
//                                                child: Text("OKAY",
//                                                    style:
//                                                        questionnaireOptionsStyle
//                                                            .copyWith(
//                                                                fontSize: 16)),
//                                                onPressed: () {
//                                                  Navigator.pop(context);
//                                                },
//                                              )
//                                            ],
//                                          ),
//                                        ),
//                                      ),
                                            Dialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0)),
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: AssetImage(
                                                            'images/popup_background.jpg'),
                                                        fit: BoxFit.fill),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                30.0)),
                                                  ),
                                                  height: devHeight * 0.3,
                                                  child: Center(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Container(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 30,
                                                                    left: 8,
                                                                    right: 8),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: [
                                                                Text(
                                                                  "Hello there!",
                                                                  style: questionnaireOptionsStyle.copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      fontSize:
                                                                          14),
                                                                ),
                                                                Text(
                                                                  "Are you unsure about what you need? Why not book an consultation with one of our experts to help you through the process?",
                                                                  style: questionnaireOptionsStyle.copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      fontSize:
                                                                          14),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        Spacer(),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(top: 8),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: <Widget>[
                                                              Expanded(
                                                                child:
                                                                    GestureDetector(
                                                                  onTap: () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: questionnaireDisabled
                                                                          .withOpacity(
                                                                              0.5),
                                                                      borderRadius:
                                                                          BorderRadius.only(
                                                                              bottomLeft: Radius.circular(5.0)),
                                                                    ),
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .all(
                                                                          12.0),
                                                                      child:
                                                                          Center(
                                                                        child: Text(
                                                                            'NO THANKS',
                                                                            style:
                                                                                questionnaireOptionsStyle.copyWith(fontSize: 16)),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child:
                                                                    GestureDetector(
                                                                  onTap:
                                                                      () async {},
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: questionnaireDisabled
                                                                          .withOpacity(
                                                                              0.5),
                                                                      borderRadius:
                                                                          BorderRadius.only(
                                                                              bottomRight: Radius.circular(5.0)),
                                                                    ),
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .all(
                                                                          12.0),
                                                                      child:
                                                                          Center(
                                                                        child: Text(
                                                                            'OKAY',
                                                                            style:
                                                                                questionnaireOptionsStyle.copyWith(fontSize: 16)),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  )),
                                            ));
                                  },
                                  child: Text(
                                    'CONTINUE',
                                    style: TextStyle(
                                      fontFamily: 'RobotoReg',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                      backgroundColor: widget.gender == 0
                                          ? defaultGreen
                                          : defaultPurple,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25)))),
                                ),
                              ),
                            )
                          : SizedBox(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
