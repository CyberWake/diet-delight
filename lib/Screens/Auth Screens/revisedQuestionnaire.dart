import 'package:diet_delight/Models/consultationModel.dart';
import 'package:diet_delight/Models/optionsFile.dart';
import 'package:diet_delight/Models/questionnaireModel.dart';
import 'package:diet_delight/Screens/Consultation/bookConsultation.dart';
import 'package:diet_delight/konstants.dart';
import 'package:diet_delight/landingPage.dart';
import 'package:diet_delight/services/apiCalls.dart';
import 'package:flutter/cupertino.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:diet_delight/Screens/Drawer Screens/bmiReport.dart';

var questionNumber = 0;

class NewQuestionnaire extends StatefulWidget {
  @override
  _NewQuestionnaireState createState() => _NewQuestionnaireState();
}

class _NewQuestionnaireState extends State<NewQuestionnaire> {
  PageController pageController = PageController();
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
  List<int> comment = [0, 0];
  int report = 0;
  TextEditingController allergyComment = TextEditingController();
  FocusNode allergy;

  @override
  void initState() {
    // TODO: implement initState
    pageController = PageController(
      initialPage: questionNumber,
    );
    allergy = FocusNode();
//    pageController.addListener(() {
//      _cont.animateTo(questionNumber * 30.toDouble(),
//          duration: Duration(milliseconds: 500), curve: Curves.linear);
//    });
//    print(widget.qDetails);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var devWidth = MediaQuery.of(context).size.width;
    var devHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Container(
            height: devHeight -
                MediaQuery.of(context).padding.top -
                MediaQuery.of(context).padding.bottom,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: devHeight * 0.025),
                  child: Center(
                    child: Text(
                      questionNumber <= 1
                          ? 'Let us know about you'
                          : questionNumber == 2
                              ? 'BMI Calculator'
                              : 'BMI Report',
                      style: questionnaireTitleStyle.copyWith(
                          color: questionnaireDisabled),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: devHeight * 0.8,
                    child: CarouselSlider(
                      options: CarouselOptions(
                        height: devHeight * 0.8,
                        enableInfiniteScroll: false,
                        reverse: false,
                        autoPlay: false,
                        enlargeCenterPage: true,
                        scrollDirection: Axis.horizontal,
                        onPageChanged: (index, reason) {
                          setState(() {
                            questionNumber = index;
                          });
                        },
                      ),
                      items: [
                        Padding(
                          padding: EdgeInsets.only(bottom: devHeight * 0.0075),
                          child: Material(
                              elevation: 2,
//                            shadowColor: Color(0x26000000),
                              color: white,
                              borderRadius: BorderRadius.circular(25.0),
                              child: Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'images/question1_background.jpg'),
                                          fit: BoxFit.fitHeight),
                                      borderRadius: BorderRadius.circular(25.0),
                                      color: Colors.white),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        devWidth * 0.06,
                                        devWidth * 0.1,
                                        devWidth * 0.06,
                                        devWidth * 0.1),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              bottom: devWidth * 0.1),
                                          child: Text(
                                            'Why are you joining Diet Delight?',
                                            style: questionnaireTitleStyle,
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    color: questionnaireSelect),
                                                padding: EdgeInsets.symmetric(
                                                    vertical: devWidth * 0.04,
                                                    horizontal:
                                                        devWidth * 0.08),
                                                child: Center(
                                                    child: Text(
                                                  'Maintain healthy eating habits',
                                                  style:
                                                      questionnaireOptionsStyle,
                                                )),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    color: questionnaireSelect),
                                                padding: EdgeInsets.symmetric(
                                                    vertical: devWidth * 0.04,
                                                    horizontal:
                                                        devWidth * 0.08),
                                                child: Center(
                                                    child: Text(
                                                  'Lose Weight',
                                                  style:
                                                      questionnaireOptionsStyle,
                                                )),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        width: 2.0,
                                                        color:
                                                            questionnaireSelect),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    color: white),
                                                padding: EdgeInsets.symmetric(
                                                    vertical: devWidth * 0.04,
                                                    horizontal:
                                                        devWidth * 0.08),
                                                child: Center(
                                                    child: Text(
                                                  'Gain Muscle',
                                                  style: questionnaireOptionsStyle
                                                      .copyWith(
                                                          color:
                                                              questionnaireSelect),
                                                )),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Material(
                                  elevation: 2,
//                                  shadowColor: Color(0x26000000),
                                  color: white,
                                  borderRadius: BorderRadius.circular(25.0),
                                  child: Container(
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'images/question2_background1.jpg'),
                                              fit: BoxFit.fitHeight),
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                          color: Colors.white),
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            devWidth * 0.06,
                                            devWidth * 0.0,
                                            devWidth * 0.06,
                                            devWidth * 0.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: devWidth * 0.1),
                                              child: Text(
                                                'Do you have any allergies or dislikes?',
                                                style: questionnaireTitleStyle,
                                              ),
                                            ),
                                            Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      comment[0] == 0
                                                          ? MainAxisAlignment
                                                              .spaceAround
                                                          : MainAxisAlignment
                                                              .spaceBetween,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          comment[0] = 1;
                                                        });
                                                      },
                                                      child: Material(
                                                        elevation:
                                                            comment[0] == 0
                                                                ? 0
                                                                : 2,
                                                        color: white,
                                                        borderRadius: comment[0] ==
                                                                0
                                                            ? BorderRadius
                                                                .circular(25)
                                                            : BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        25.0),
                                                                topRight: Radius
                                                                    .circular(
                                                                        25.0),
                                                                bottomRight:
                                                                    Radius
                                                                        .circular(
                                                                            0),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        0)),
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                                  borderRadius: comment[0] ==
                                                                          0
                                                                      ? BorderRadius
                                                                          .circular(
                                                                              25)
                                                                      : BorderRadius.only(
                                                                          topLeft: Radius.circular(
                                                                              25.0),
                                                                          topRight: Radius.circular(
                                                                              25.0),
                                                                          bottomRight: Radius.circular(
                                                                              0),
                                                                          bottomLeft: Radius.circular(
                                                                              0)),
//                                                                  boxShadow: [
//                                                                    BoxShadow(
//                                                                      color: Colors
//                                                                          .black
//                                                                          .withOpacity(
//                                                                              0.5),
//                                                                    ),
//                                                                  ],
                                                                  color: comment[
                                                                              0] ==
                                                                          0
                                                                      ? questionnaireSelect
                                                                      : commentChange),
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical:
                                                                      devWidth *
                                                                          0.04,
                                                                  horizontal:
                                                                      devWidth *
                                                                          0.08),
                                                          child: Center(
                                                              child: Text(
                                                            'YES',
                                                            style: comment[0] ==
                                                                    0
                                                                ? questionnaireOptionsStyle
                                                                : questionnaireOptionsStyle
                                                                    .copyWith(
                                                                        color:
                                                                            questionnaireSelect),
                                                          )),
                                                        ),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          comment[0] = 0;
                                                        });
                                                      },
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        25),
                                                            color:
                                                                questionnaireSelect),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical:
                                                                    devWidth *
                                                                        0.04,
                                                                horizontal:
                                                                    devWidth *
                                                                        0.08),
                                                        child: Center(
                                                            child: Text(
                                                          'NO',
                                                          style:
                                                              questionnaireOptionsStyle,
                                                        )),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                comment[0] == 1
                                                    ? Material(
                                                        elevation: 2,
                                                        color: white,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topLeft:
                                                                    Radius
                                                                        .circular(
                                                                            0),
                                                                topRight: Radius
                                                                    .circular(
                                                                        25.0),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        25.0),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        25.0)),
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                                  borderRadius: BorderRadius.only(
                                                                      topLeft: Radius
                                                                          .circular(
                                                                              0),
                                                                      topRight:
                                                                          Radius.circular(
                                                                              25.0),
                                                                      bottomRight:
                                                                          Radius.circular(
                                                                              25.0),
                                                                      bottomLeft:
                                                                          Radius.circular(
                                                                              25.0)),
//                                                                  boxShadow: [
//                                                                    BoxShadow(
//                                                                      color: Colors
//                                                                          .black
//                                                                          .withOpacity(
//                                                                              0.5),
//                                                                    ),
//                                                                  ],
                                                                  color:
                                                                      commentChange),
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical:
                                                                      devWidth *
                                                                          0.04,
                                                                  horizontal:
                                                                      devWidth *
                                                                          0.08),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                'Please Specify',
                                                                style: comment[
                                                                            0] ==
                                                                        0
                                                                    ? questionnaireOptionsStyle
                                                                    : questionnaireOptionsStyle
                                                                        .copyWith(
                                                                            color:
                                                                                questionnaireSelect),
                                                              ),
                                                              Material(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                child:
                                                                    Container(
                                                                  width: double
                                                                      .infinity,
                                                                  height: 40.0,
//                                                                decoration:
//                                                                    authFieldDecoration,
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets.fromLTRB(
                                                                            20,
                                                                            3,
                                                                            20,
                                                                            7),
                                                                    child: TextFormField(
                                                                        onChanged: (String account) {
                                                                          allergyComment.text =
                                                                              account;
                                                                        },
                                                                        onFieldSubmitted: (done) {
                                                                          allergyComment.text =
                                                                              done;
                                                                          allergy
                                                                              .unfocus();
                                                                        },
                                                                        style: authInputTextStyle,
                                                                        keyboardType: TextInputType.text,
                                                                        textInputAction: TextInputAction.done,
                                                                        focusNode: allergy,
                                                                        decoration: authInputFieldDecoration),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    : SizedBox(),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ))),
                            ),
                            SizedBox(height: devHeight * 0.05),
                            Expanded(
                              child: Padding(
                                padding:
                                    EdgeInsets.only(bottom: devHeight * 0.0075),
                                child: Material(
                                    elevation: 2,
//                                  shadowColor: Color(0x26000000),
                                    color: white,
                                    borderRadius: BorderRadius.circular(25.0),
                                    child: Container(
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    'images/question2_background2.jpg'),
                                                fit: BoxFit.fitHeight),
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                            color: Colors.white),
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              devWidth * 0.06,
                                              devWidth * 0.1,
                                              devWidth * 0.06,
                                              devWidth * 0.1),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: devWidth * 0.1),
                                                child: Text(
                                                  'Do you currently have any medical condition?',
                                                  style:
                                                      questionnaireTitleStyle,
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                        color:
                                                            questionnaireSelect),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical:
                                                                devWidth * 0.04,
                                                            horizontal:
                                                                devWidth *
                                                                    0.08),
                                                    child: Center(
                                                        child: Text(
                                                      'YES',
                                                      style:
                                                          questionnaireOptionsStyle,
                                                    )),
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                        color:
                                                            questionnaireSelect),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical:
                                                                devWidth * 0.04,
                                                            horizontal:
                                                                devWidth *
                                                                    0.08),
                                                    child: Center(
                                                        child: Text(
                                                      'NO',
                                                      style:
                                                          questionnaireOptionsStyle,
                                                    )),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ))),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: devHeight * 0.0075),
                          child: Material(
                              elevation: 2,
//                              shadowColor: Color(0x26000000),
                              color: white,
                              borderRadius: BorderRadius.circular(20.0),
                              child: Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'images/questionnaire_background.jpg'),
                                          fit: BoxFit.fitHeight),
                                      borderRadius: BorderRadius.circular(20.0),
                                      color: Colors.white),
//                              width: devWidth * 0.9,
                                  height: devHeight * 0.8,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        devWidth * 0.06,
                                        devWidth * 0.06,
                                        devWidth * 0.06,
                                        devWidth * 0.06),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
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
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  child: Container(
                                                      width: devWidth * 0.25,
                                                      decoration: gender == 0
                                                          ? BoxDecoration(
                                                              boxShadow: [
                                                                  BoxShadow(
                                                                    blurRadius:
                                                                        5,
                                                                    spreadRadius:
                                                                        -10,
                                                                  )
                                                                ],
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20.0),
                                                              color:
                                                                  defaultGreen)
                                                          : BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20.0),
                                                              color:
                                                                  Colors.white),
                                                      child: Padding(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                            devWidth * 0.05,
                                                            devWidth * 0.05,
                                                            devWidth * 0.05,
                                                            devWidth * 0.05,
                                                          ),
                                                          child: Column(
                                                            children: [
                                                              Icon(
                                                                FontAwesomeIcons
                                                                    .mars,
                                                                color: gender ==
                                                                        0
                                                                    ? Colors
                                                                        .white
                                                                    : questionnaireDisabled,
                                                                size: 36,
                                                              ),
                                                              SizedBox(
                                                                height:
                                                                    devHeight *
                                                                        0.00625,
                                                              ),
                                                              Text(
                                                                'MALE',
                                                                style: gender ==
                                                                        0
                                                                    ? questionnaireDisabledStyle.copyWith(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .normal,
                                                                        color: Colors
                                                                            .white)
                                                                    : questionnaireDisabledStyle
                                                                        .copyWith(
                                                                            fontWeight:
                                                                                FontWeight.normal),
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
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  child: Container(
                                                      width: devWidth * 0.25,
                                                      decoration: BoxDecoration(
//                                                        boxShadow: [
//                                                          BoxShadow(
//                                                              color: Color(
//                                                                  0x26000000),
//                                                              blurRadius: 5)
//                                                        ],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.0),
                                                          color: gender == 1
                                                              ? defaultPurple
                                                              : Colors.white),
                                                      child: Padding(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                            devWidth * 0.05,
                                                            devWidth * 0.05,
                                                            devWidth * 0.05,
                                                            devWidth * 0.05,
                                                          ),
                                                          child: Column(
                                                            children: [
                                                              Icon(
                                                                FontAwesomeIcons
                                                                    .venus,
                                                                color: gender ==
                                                                        1
                                                                    ? Colors
                                                                        .white
                                                                    : questionnaireDisabled,
                                                                size: 36,
                                                              ),
                                                              SizedBox(
                                                                height:
                                                                    devHeight *
                                                                        0.00625,
                                                              ),
                                                              Text(
                                                                'FEMALE',
                                                                style: gender ==
                                                                        1
                                                                    ? questionnaireDisabledStyle.copyWith(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .normal,
                                                                        color: Colors
                                                                            .white)
                                                                    : questionnaireDisabledStyle
                                                                        .copyWith(
                                                                            fontWeight:
                                                                                FontWeight.normal),
                                                              )
                                                            ],
                                                          )))),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                RotatedBox(
                                                  quarterTurns: 3,
                                                  child: SliderTheme(
                                                    data:
                                                        SliderTheme.of(context)
                                                            .copyWith(
                                                      inactiveTrackColor:
                                                          Color(0xFFEFEFEF),
                                                      activeTrackColor:
                                                          gender == 0
                                                              ? defaultGreen
                                                              : defaultPurple,
                                                      thumbColor: gender == 0
                                                          ? defaultGreen
                                                          : defaultPurple,
                                                      overlayColor: gender == 0
                                                          ? defaultGreen
                                                          : defaultPurple,
                                                      thumbShape:
                                                          RoundSliderThumbShape(
                                                              enabledThumbRadius:
                                                                  8.0),
                                                      overlayShape:
                                                          RoundSliderOverlayShape(
                                                              overlayRadius:
                                                                  8.0),
                                                    ),
                                                    child: Slider(
                                                      value: height.toDouble(),
                                                      min: 120.0,
                                                      max: 220.0,
                                                      onChanged:
                                                          (double newValue) {
                                                        setState(() {
                                                          height =
                                                              newValue.round();
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 5.0),
                                                      child: Text(
                                                        height.toString(),
                                                        style:
                                                            questionnaireDisabledStyle
                                                                .copyWith(
                                                                    fontSize:
                                                                        32),
                                                      ),
                                                    ),
                                                    Text(
                                                      'HEIGHT (cm)',
                                                      style:
                                                          questionnaireDisabledStyle,
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      weight.toString(),
                                                      style:
                                                          questionnaireDisabledStyle
                                                              .copyWith(
                                                                  fontSize: 32),
                                                    ),
                                                    SliderTheme(
                                                      data: SliderTheme.of(
                                                              context)
                                                          .copyWith(
                                                        inactiveTrackColor:
                                                            Color(0xFFEFEFEF),
                                                        activeTrackColor:
                                                            gender == 0
                                                                ? defaultGreen
                                                                : defaultPurple,
                                                        thumbColor: gender == 0
                                                            ? defaultGreen
                                                            : defaultPurple,
                                                        overlayColor:
                                                            gender == 0
                                                                ? defaultGreen
                                                                : defaultPurple,
                                                        thumbShape:
                                                            RoundSliderThumbShape(
                                                                enabledThumbRadius:
                                                                    8.0),
                                                        overlayShape:
                                                            RoundSliderOverlayShape(
                                                                overlayRadius:
                                                                    8.0),
                                                      ),
                                                      child: Slider(
                                                        value:
                                                            weight.toDouble(),
                                                        min: 40.0,
                                                        max: 180.0,
                                                        onChanged:
                                                            (double newValue) {
                                                          setState(() {
                                                            weight = newValue
                                                                .round();
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    Text(
                                                      'WEIGHT (kg)',
                                                      style:
                                                          questionnaireDisabledStyle,
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: devHeight * 0.05,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      age.toString(),
                                                      style:
                                                          questionnaireDisabledStyle
                                                              .copyWith(
                                                                  fontSize: 32),
                                                    ),
                                                    SliderTheme(
                                                      data: SliderTheme.of(
                                                              context)
                                                          .copyWith(
                                                        inactiveTrackColor:
                                                            Color(0xFFEFEFEF),
                                                        activeTrackColor:
                                                            gender == 0
                                                                ? defaultGreen
                                                                : defaultPurple,
                                                        thumbColor: gender == 0
                                                            ? defaultGreen
                                                            : defaultPurple,
                                                        overlayColor:
                                                            gender == 0
                                                                ? defaultGreen
                                                                : defaultPurple,
                                                        thumbShape:
                                                            RoundSliderThumbShape(
                                                                enabledThumbRadius:
                                                                    8.0),
                                                        overlayShape:
                                                            RoundSliderOverlayShape(
                                                                overlayRadius:
                                                                    8.0),
                                                      ),
                                                      child: Slider(
                                                        value: age.toDouble(),
                                                        min: 16.0,
                                                        max: 100.0,
                                                        onChanged:
                                                            (double newValue) {
                                                          setState(() {
                                                            age = newValue
                                                                .round();
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    Text(
                                                      'AGE',
                                                      style:
                                                          questionnaireDisabledStyle,
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 0, 0),
                                          child: SizedBox(
                                            width: double.infinity,
                                            height: 50.0,
                                            child: TextButton(
                                              onPressed: () {
                                                bmi = weight /
                                                    (height * height / 10000);
                                                display_bmi =
                                                    bmi.toStringAsPrecision(3);
                                                print(display_bmi);
                                                if (bmi < bmi_values[0]) {
                                                  report = 0;
                                                } else if (bmi <
                                                    bmi_values[1]) {
                                                  report = 1;
                                                } else if (bmi <
                                                    bmi_values[2]) {
                                                  report = 2;
                                                } else {
                                                  report = 3;
                                                }
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            BmiReport(
                                                                bmi:
                                                                    display_bmi,
                                                                report: report,
                                                                gender: gender,
                                                                questionnaire:
                                                                    true)));
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
                                                  backgroundColor: gender == 0
                                                      ? defaultGreen
                                                      : defaultPurple,
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          25)))),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))),
                        ),
//                    Material(
//                        elevation: 2,
//                        shadowColor: Color(0x26000000),
//                        borderRadius: BorderRadius.circular(5.0),
//                        child: Container(
//                            decoration: BoxDecoration(
//                                boxShadow: [
//                                  BoxShadow(
//                                      color: Color(0x26000000), blurRadius: 5)
//                                ],
//                                borderRadius: BorderRadius.circular(25.0),
//                                color: Colors.white),
//                            child: Padding(
//                              padding: EdgeInsets.fromLTRB(
//                                  devWidth * 0.06,
//                                  devWidth * 0.1,
//                                  devWidth * 0.06,
//                                  devWidth * 0.1),
//                              child: Column(
//                                mainAxisAlignment:
//                                    MainAxisAlignment.spaceAround,
//                                children: [
//                                  Column(
//                                    crossAxisAlignment:
//                                        CrossAxisAlignment.center,
//                                    children: [
//                                      Material(
//                                        elevation: 0,
////                                        shadowColor: defaultGreen,
//                                        color: gender == 0
//                                            ? defaultGreen
//                                            : defaultPurple,
//                                        shape: CircleBorder(),
//                                        child: CircularPercentIndicator(
//                                          radius: 130.0,
//                                          lineWidth: 10.0,
//                                          percent: 100 / 100,
//                                          center: new Text(
//                                            '$display_bmi',
//                                            style: TextStyle(
//                                                color: white,
//                                                fontSize: 48,
//                                                fontFamily: 'KalamReg',
//                                                fontWeight: FontWeight.bold),
//                                          ),
//                                          progressColor: blurredDefaultGreen,
//                                          backgroundColor: Colors.transparent,
////                  fillColor: Colors.white,
//                                        ),
//                                      ),
//                                      SizedBox(height: devHeight * 0.005),
//                                      Text(
//                                        '${bmi_result[report]}',
//                                        style: questionnaireTitleStyle.copyWith(
//                                            fontSize: 28,
//                                            color: gender == 0
//                                                ? defaultGreen
//                                                : defaultPurple),
//                                      ),
//                                    ],
//                                  ),
//                                  Column(
//                                    children: [
//                                      Align(
//                                        alignment: Alignment.centerLeft,
//                                        child: Text(
//                                          'Recommended Calorie Intake',
//                                          style: questionnaireTitleStyle
//                                              .copyWith(fontSize: 20),
//                                        ),
//                                      ),
//                                      SizedBox(height: devHeight * 0.02),
//                                      Center(
//                                          child: Text(
//                                              gender == 0
//                                                  ? '${calories_male[report]} kcal'
//                                                  : '${calories_female[report]} kcal',
//                                              style: questionnaireDisabledStyle
//                                                  .copyWith(
//                                                      fontSize: 24,
//                                                      color: gender == 0
//                                                          ? defaultGreen
//                                                          : defaultPurple))),
//                                    ],
//                                  ),
//                                  Column(
////                                          mainAxisAlignment:
////                                              MainAxisAlignment.spaceEvenly,
//                                    children: [
//                                      Text(
//                                        'Please consult a medical practitioner if you - ',
//                                        style: questionnaireTitleStyle.copyWith(
//                                            fontSize: 16),
//                                      ),
//                                      Row(
//                                        children: [
//                                          Icon(Icons.arrow_right_alt,
//                                              color: gender == 0
//                                                  ? defaultGreen
//                                                  : defaultPurple,
//                                              size: 28),
//                                          Text(
//                                            'have a pre-existing medical condition',
//                                            style: questionnaireTitleStyle
//                                                .copyWith(
//                                                    fontWeight: FontWeight.w400,
//                                                    fontSize: 12),
//                                          ),
//                                        ],
//                                      ),
//                                      Row(
//                                        children: [
//                                          Icon(Icons.arrow_right_alt,
//                                              color: gender == 0
//                                                  ? defaultGreen
//                                                  : defaultPurple,
//                                              size: 28),
//                                          Text(
//                                            'are less than 18 or more than 60 years of age',
//                                            style: questionnaireTitleStyle
//                                                .copyWith(
//                                                    fontWeight: FontWeight.w400,
//                                                    fontSize: 12),
//                                          ),
//                                        ],
//                                      ),
//                                      Row(
//                                        children: [
//                                          Icon(Icons.arrow_right_alt,
//                                              color: gender == 0
//                                                  ? defaultGreen
//                                                  : defaultPurple,
//                                              size: 28),
//                                          Expanded(
//                                            child: Text(
//                                              'are trying to gain weight, are an athlete or a body-builder',
//                                              style: questionnaireTitleStyle
//                                                  .copyWith(
//                                                      fontWeight:
//                                                          FontWeight.w400,
//                                                      fontSize: 12),
//                                              maxLines: 2,
//                                            ),
//                                          ),
//                                        ],
//                                      ),
//                                      gender == 0
//                                          ? SizedBox()
//                                          : Row(
//                                              children: [
//                                                Icon(Icons.arrow_right_alt,
//                                                    color: gender == 0
//                                                        ? defaultGreen
//                                                        : defaultPurple,
//                                                    size: 28),
//                                                Text(
//                                                  'are pregnant or a breastfeeding mother.',
//                                                  style: questionnaireTitleStyle
//                                                      .copyWith(
//                                                          fontWeight:
//                                                              FontWeight.w400,
//                                                          fontSize: 12),
//                                                ),
//                                              ],
//                                            ),
//                                    ],
//                                  ),
//                                  Padding(
//                                    padding:
//                                        const EdgeInsets.fromLTRB(0, 0, 0, 0),
//                                    child: SizedBox(
//                                      width: double.infinity,
//                                      height: 50.0,
//                                      child: TextButton(
//                                        onPressed: () {},
//                                        child: Text(
//                                          'CONTINUE',
//                                          style: TextStyle(
//                                            fontFamily: 'RobotoReg',
//                                            fontSize: 18,
//                                            fontWeight: FontWeight.bold,
//                                            color: Colors.white,
//                                          ),
//                                        ),
//                                        style: TextButton.styleFrom(
//                                            backgroundColor: gender == 0
//                                                ? defaultGreen
//                                                : defaultPurple,
//                                            shape: const RoundedRectangleBorder(
//                                                borderRadius: BorderRadius.all(
//                                                    Radius.circular(25)))),
//                                      ),
//                                    ),
//                                  ),
//                                ],
//                              ),
//                            ))),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
