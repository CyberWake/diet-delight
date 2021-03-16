import 'package:diet_delight/Models/consultationModel.dart';
import 'package:diet_delight/Models/optionsFile.dart';
import 'package:diet_delight/Models/questionnaireModel.dart';
import 'package:diet_delight/Models/postQuestionnaireModel.dart';
import 'package:diet_delight/Models/registrationModel.dart';
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
  List<int> comment = [null, null];
  int report = 0;
  TextEditingController question1Controller = TextEditingController();
  FocusNode question1Focus;
  TextEditingController question2Controller = TextEditingController();
  FocusNode question2Focus;

  int questionNumber = 0;
  bool isLoaded = false;
  bool show = false;
  bool next = false;
  bool notAnswered = true;
  int chatLength = 0;
  List<QuestionnaireModel> questions;
  List<OptionsModel> options;
  List<PostQuestionnaire> postList;
  List<bool> postRes;
  var answer;
  int _currentIndex;

  Future getQuestions() async {
    await _apiCall.getUserInfo();
    questions = await _apiCall.getQuestions();
    postList = List<PostQuestionnaire>(questions.length);
    postRes = List<bool>();
    options = await _apiCall.getOptions(questions);
    print(questions.length);
    _currentIndex = 0;
    for (int i = 0; i < questions.length; i++) {
      print(questions[i].id);
    }
    print("printing option");
    for (int i = 0; i < options.length; i++) {
      print(options[i].question_Id);
    }
    print("done printing option");
  }

  @override
  void initState() {
    pageController = PageController(
      initialPage: questionNumber,
    );
    question1Focus = FocusNode();
    question2Focus = FocusNode();
    getQuestions().whenComplete(() {
      setState(() {
        isLoaded = true;
      });
    });
    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  //   precacheImage(question1Background.image, context);
  //   precacheImage(question2Background1.image, context);
  //   precacheImage(question2Background2.image, context);
  //   precacheImage(bmiBackground.image, context);
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    var devWidth = MediaQuery.of(context).size.width;
    var devHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: isLoaded
            ? SingleChildScrollView(
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
                                ? 'Questionnaire'
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
                          child: CarouselSlider.builder(
                            itemCount: 3,
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
                            itemBuilder: (context, carouselIndex, realIdx) {
                              return carouselIndex == 0
                                  ? Padding(
                                      padding: EdgeInsets.only(
                                          bottom: devHeight * 0.0075),
                                      child: Material(
                                          elevation: 2,
//                            shadowColor: Color(0x26000000),
                                          color: white,
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  image: question1Background,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25.0),
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
                                                          bottom:
                                                              devWidth * 0.1),
                                                      child: Text(
                                                        questions[0].question,
                                                        style:
                                                            questionnaireTitleStyle,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: ListView.builder(
                                                        itemCount:
                                                            options.length,
                                                        // mainAxisAlignment:
                                                        // MainAxisAlignment.spaceEvenly,
                                                        itemBuilder: (context,
                                                            optionsIndex) {
                                                          int pickedIndex =
                                                              null;
                                                          return GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                pickedIndex =
                                                                    optionsIndex;
                                                                PostQuestionnaire item = PostQuestionnaire(
                                                                    answerOptionId:
                                                                        options[optionsIndex]
                                                                            .id,
                                                                    questionId:
                                                                        questions[0]
                                                                            .id,
                                                                    questionAdditionalText:
                                                                        '0',
                                                                    answer: options[optionsIndex]
                                                                        .option,
                                                                    questionQuestion:
                                                                        questions[0]
                                                                            .question,
                                                                    questionType:
                                                                        questions[0]
                                                                            .type,
                                                                    answerOptionOption:
                                                                        options[optionsIndex]
                                                                            .option);
                                                                postList[0] =
                                                                    item;
                                                              });
                                                            },
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          devHeight *
                                                                              0.045),
                                                              child: (postList[
                                                                              0] !=
                                                                          null) &&
                                                                      (postList[0]
                                                                              .answerOptionId ==
                                                                          options[optionsIndex]
                                                                              .id)
                                                                  ? Container(
                                                                      decoration: BoxDecoration(
                                                                          border: Border.all(
                                                                              width:
                                                                                  2.0,
                                                                              color:
                                                                                  questionnaireSelect),
                                                                          borderRadius: BorderRadius.circular(
                                                                              25),
                                                                          color:
                                                                              white),
                                                                      padding: EdgeInsets.symmetric(
                                                                          vertical: devWidth *
                                                                              0.04,
                                                                          horizontal:
                                                                              devWidth * 0.08),
                                                                      child: Center(
                                                                          child: Text(
                                                                        options[optionsIndex]
                                                                            .option,
                                                                        style: questionnaireOptionsStyle.copyWith(
                                                                            color:
                                                                                questionnaireSelect),
                                                                      )),
                                                                    )
                                                                  : Container(
                                                                      decoration: BoxDecoration(
                                                                          border: Border.all(
                                                                              width:
                                                                                  2.0,
                                                                              color:
                                                                                  questionnaireSelect),
                                                                          borderRadius: BorderRadius.circular(
                                                                              25),
                                                                          color:
                                                                              questionnaireSelect),
                                                                      padding: EdgeInsets.symmetric(
                                                                          vertical: devWidth *
                                                                              0.04,
                                                                          horizontal:
                                                                              devWidth * 0.08),
                                                                      child: Center(
                                                                          child: Text(
                                                                        options[optionsIndex]
                                                                            .option,
                                                                        style:
                                                                            questionnaireOptionsStyle,
                                                                      )),
                                                                    ),
                                                            ),
                                                          );
                                                          // Container(
                                                          // decoration: BoxDecoration(
                                                          // borderRadius:
                                                          // BorderRadius.circular(
                                                          // 25),
                                                          // color: questionnaireSelect),
                                                          // padding: EdgeInsets.symmetric(
                                                          // vertical: devWidth * 0.04,
                                                          // horizontal:
                                                          // devWidth * 0.08),
                                                          // child: Center(
                                                          // child: Text(
                                                          // 'Lose Weight',
                                                          // style:
                                                          // questionnaireOptionsStyle,
                                                          // )),
                                                          // ),
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ))),
                                    )
                                  : carouselIndex == 1
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Material(
                                                  elevation: 2,
//                                  shadowColor: Color(0x26000000),
                                                  color: white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25.0),
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                          image:
                                                              question2Background1,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      25.0),
                                                          color: Colors.white),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                devWidth * 0.06,
                                                                devWidth * 0.0,
                                                                devWidth * 0.06,
                                                                devWidth * 0.0),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets.only(
                                                                  bottom:
                                                                      devWidth *
                                                                          0.1),
                                                              child: Text(
                                                                questions[1]
                                                                    .question,
                                                                style:
                                                                    questionnaireTitleStyle,
                                                              ),
                                                            ),
                                                            Column(
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment: comment[
                                                                              0] ==
                                                                          1
                                                                      ? MainAxisAlignment
                                                                          .spaceBetween
                                                                      : MainAxisAlignment
                                                                          .spaceAround,
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          comment[0] =
                                                                              1;
                                                                        });
                                                                      },
                                                                      child:
                                                                          Material(
                                                                        elevation: comment[0] ==
                                                                                1
                                                                            ? 2
                                                                            : 0,
                                                                        color:
                                                                            white,
                                                                        borderRadius: comment[0] ==
                                                                                1
                                                                            ? BorderRadius.only(
                                                                                topLeft: Radius.circular(25.0),
                                                                                topRight: Radius.circular(25.0),
                                                                                bottomRight: Radius.circular(0),
                                                                                bottomLeft: Radius.circular(0))
                                                                            : BorderRadius.circular(25),
                                                                        child:
                                                                            Container(
                                                                          decoration: BoxDecoration(
                                                                              border: Border.all(width: 2.0, color: comment[0] == 1 ? white : questionnaireSelect),
                                                                              borderRadius: comment[0] == 1 ? BorderRadius.only(topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0), bottomRight: Radius.circular(0), bottomLeft: Radius.circular(0)) : BorderRadius.circular(25),
//                                                                  boxShadow: [
//                                                                    BoxShadow(
//                                                                      color: Colors
//                                                                          .black
//                                                                          .withOpacity(
//                                                                              0.5),
//                                                                    ),
//                                                                  ],
                                                                              color: comment[0] == 1 ? commentChange : questionnaireSelect),
                                                                          padding: EdgeInsets.symmetric(
                                                                              vertical: devWidth * 0.04,
                                                                              horizontal: devWidth * 0.08),
                                                                          child: Center(
                                                                              child: Text(
                                                                            'YES',
                                                                            style: comment[0] == 1
                                                                                ? questionnaireOptionsStyle.copyWith(color: questionnaireSelect)
                                                                                : questionnaireOptionsStyle,
                                                                          )),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          comment[0] =
                                                                              0;
                                                                          PostQuestionnaire item = PostQuestionnaire(
                                                                              answerOptionId: 1,
                                                                              questionId: questions[1].id,
                                                                              questionAdditionalText: '0',
                                                                              answer: 'no',
                                                                              questionQuestion: questions[1].question,
                                                                              questionType: questions[1].type,
                                                                              answerOptionOption: 'no');
                                                                          postList[1] =
                                                                              item;
                                                                        });
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(25),
                                                                            border: Border.all(width: 2.0, color: questionnaireSelect),
                                                                            color: comment[0] == 0 ? white : questionnaireSelect),
                                                                        padding: EdgeInsets.symmetric(
                                                                            vertical: devWidth *
                                                                                0.04,
                                                                            horizontal:
                                                                                devWidth * 0.08),
                                                                        child: Center(
                                                                            child: Text(
                                                                          'NO',
                                                                          style:
                                                                              questionnaireOptionsStyle.copyWith(color: comment[0] == 0 ? questionnaireSelect : white),
                                                                        )),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                comment[0] == 1
                                                                    ? Material(
                                                                        elevation:
                                                                            2,
                                                                        color:
                                                                            white,
                                                                        borderRadius: BorderRadius.only(
                                                                            topLeft:
                                                                                Radius.circular(0),
                                                                            topRight: Radius.circular(25.0),
                                                                            bottomRight: Radius.circular(25.0),
                                                                            bottomLeft: Radius.circular(25.0)),
                                                                        child:
                                                                            Container(
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(0), topRight: Radius.circular(25.0), bottomRight: Radius.circular(25.0), bottomLeft: Radius.circular(25.0)),
//                                                                  boxShadow: [
//                                                                    BoxShadow(
//                                                                      color: Colors
//                                                                          .black
//                                                                          .withOpacity(
//                                                                              0.5),
//                                                                    ),
//                                                                  ],
                                                                              color: commentChange),
                                                                          padding: EdgeInsets.symmetric(
                                                                              vertical: devWidth * 0.04,
                                                                              horizontal: devWidth * 0.03),
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                'Please Specify',
                                                                                style: comment[0] == 0 ? questionnaireOptionsStyle : questionnaireOptionsStyle.copyWith(color: questionnaireSelect),
                                                                              ),
                                                                              Padding(
                                                                                padding: EdgeInsets.fromLTRB(devWidth * 0.03, 5, devWidth * 0.03, 0),
                                                                                child: Material(
                                                                                  borderRadius: BorderRadius.circular(5),
                                                                                  child: Container(
                                                                                    width: double.infinity,
                                                                                    height: 50.0,
//                                                                decoration:
//                                                                    authFieldDecoration,
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                                                                      child: TextFormField(
                                                                                          onChanged: (String account) {
                                                                                            question1Controller.text = account;
                                                                                            PostQuestionnaire item = PostQuestionnaire(answerOptionId: 0, questionId: questions[1].id, questionAdditionalText: "0", answer: question1Controller.text, questionQuestion: questions[1].question, questionType: questions[1].type, answerOptionOption: 'yes');
                                                                                            postList[1] = item;
                                                                                          },
                                                                                          onFieldSubmitted: (done) {
                                                                                            question1Controller.text = done;
                                                                                            question1Focus.unfocus();
                                                                                          },
                                                                                          autofocus: true,
                                                                                          style: authInputTextStyle,
                                                                                          maxLines: null,
                                                                                          minLines: 1,
                                                                                          keyboardType: TextInputType.text,
                                                                                          textInputAction: TextInputAction.done,
                                                                                          focusNode: question1Focus,
                                                                                          decoration: authInputFieldDecoration),
                                                                                    ),
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
                                              child: Material(
                                                  elevation: 2,
//                                  shadowColor: Color(0x26000000),
                                                  color: white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25.0),
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                          image:
                                                              question2Background2,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      25.0),
                                                          color: Colors.white),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                devWidth * 0.06,
                                                                devWidth * 0.0,
                                                                devWidth * 0.06,
                                                                devWidth * 0.0),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets.only(
                                                                  bottom:
                                                                      devWidth *
                                                                          0.1),
                                                              child: Text(
                                                                questions[2]
                                                                    .question,
                                                                style:
                                                                    questionnaireTitleStyle,
                                                              ),
                                                            ),
                                                            Column(
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment: comment[
                                                                              1] ==
                                                                          1
                                                                      ? MainAxisAlignment
                                                                          .spaceBetween
                                                                      : MainAxisAlignment
                                                                          .spaceAround,
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          comment[1] =
                                                                              1;
                                                                        });
                                                                      },
                                                                      child:
                                                                          Material(
                                                                        elevation: comment[1] ==
                                                                                1
                                                                            ? 2
                                                                            : 0,
                                                                        color:
                                                                            white,
                                                                        borderRadius: comment[1] ==
                                                                                1
                                                                            ? BorderRadius.only(
                                                                                topLeft: Radius.circular(25.0),
                                                                                topRight: Radius.circular(25.0),
                                                                                bottomRight: Radius.circular(0),
                                                                                bottomLeft: Radius.circular(0))
                                                                            : BorderRadius.circular(25),
                                                                        child:
                                                                            Container(
                                                                          decoration: BoxDecoration(
                                                                              border: Border.all(width: 2.0, color: comment[1] == 1 ? white : questionnaireSelect),
                                                                              borderRadius: comment[1] == 1 ? BorderRadius.only(topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0), bottomRight: Radius.circular(0), bottomLeft: Radius.circular(0)) : BorderRadius.circular(25),
//                                                                  boxShadow: [
//                                                                    BoxShadow(
//                                                                      color: Colors
//                                                                          .black
//                                                                          .withOpacity(
//                                                                              0.5),
//                                                                    ),
//                                                                  ],
                                                                              color: comment[1] == 1 ? commentChange : questionnaireSelect),
                                                                          padding: EdgeInsets.symmetric(
                                                                              vertical: devWidth * 0.04,
                                                                              horizontal: devWidth * 0.08),
                                                                          child: Center(
                                                                              child: Text(
                                                                            'YES',
                                                                            style: comment[1] == 1
                                                                                ? questionnaireOptionsStyle.copyWith(color: questionnaireSelect)
                                                                                : questionnaireOptionsStyle,
                                                                          )),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          comment[1] =
                                                                              0;
                                                                          PostQuestionnaire item = PostQuestionnaire(
                                                                              answerOptionId: 1,
                                                                              questionId: questions[2].id,
                                                                              questionAdditionalText: '0',
                                                                              answer: 'no',
                                                                              questionQuestion: questions[2].question,
                                                                              questionType: questions[2].type,
                                                                              answerOptionOption: 'no');
                                                                          postList[2] =
                                                                              item;
                                                                        });
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(25),
                                                                            border: Border.all(width: 2.0, color: questionnaireSelect),
                                                                            color: comment[1] == 0 ? white : questionnaireSelect),
                                                                        padding: EdgeInsets.symmetric(
                                                                            vertical: devWidth *
                                                                                0.04,
                                                                            horizontal:
                                                                                devWidth * 0.08),
                                                                        child: Center(
                                                                            child: Text(
                                                                          'NO',
                                                                          style:
                                                                              questionnaireOptionsStyle.copyWith(color: comment[1] == 0 ? questionnaireSelect : white),
                                                                        )),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                comment[1] == 1
                                                                    ? Material(
                                                                        elevation:
                                                                            2,
                                                                        color:
                                                                            white,
                                                                        borderRadius: BorderRadius.only(
                                                                            topLeft:
                                                                                Radius.circular(0),
                                                                            topRight: Radius.circular(25.0),
                                                                            bottomRight: Radius.circular(25.0),
                                                                            bottomLeft: Radius.circular(25.0)),
                                                                        child:
                                                                            Container(
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(0), topRight: Radius.circular(25.0), bottomRight: Radius.circular(25.0), bottomLeft: Radius.circular(25.0)),
//                                                                  boxShadow: [
//                                                                    BoxShadow(
//                                                                      color: Colors
//                                                                          .black
//                                                                          .withOpacity(
//                                                                              0.5),
//                                                                    ),
//                                                                  ],
                                                                              color: commentChange),
                                                                          padding: EdgeInsets.symmetric(
                                                                              vertical: devWidth * 0.04,
                                                                              horizontal: devWidth * 0.03),
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                'Please Specify',
                                                                                style: comment[1] == 0 ? questionnaireOptionsStyle : questionnaireOptionsStyle.copyWith(color: questionnaireSelect),
                                                                              ),
                                                                              Padding(
                                                                                padding: EdgeInsets.fromLTRB(devWidth * 0.03, 5, devWidth * 0.03, 0),
                                                                                child: Material(
                                                                                  borderRadius: BorderRadius.circular(5),
                                                                                  child: Container(
                                                                                    width: double.infinity,
                                                                                    height: 50.0,
//                                                                decoration:
//                                                                    authFieldDecoration,
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.fromLTRB(20, 3, 20, 7),
                                                                                      child: TextFormField(
                                                                                          onChanged: (String account) {
                                                                                            question2Controller.text = account;
                                                                                            PostQuestionnaire item = PostQuestionnaire(answerOptionId: 0, questionId: questions[2].id, questionAdditionalText: "0", answer: question2Controller.text, questionQuestion: questions[2].question, questionType: questions[2].type, answerOptionOption: 'yes');
                                                                                            postList[2] = item;
                                                                                          },
                                                                                          onFieldSubmitted: (done) {
                                                                                            question2Controller.text = done;
                                                                                            question2Focus.unfocus();
                                                                                          },
                                                                                          autofocus: true,
                                                                                          style: authInputTextStyle,
                                                                                          keyboardType: TextInputType.text,
                                                                                          maxLines: null,
                                                                                          minLines: 1,
                                                                                          textInputAction: TextInputAction.done,
                                                                                          focusNode: question2Focus,
                                                                                          decoration: authInputFieldDecoration),
                                                                                    ),
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
                                          ],
                                        )
                                      : carouselIndex == 2
                                          ? Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: devHeight * 0.0075),
                                              child: Material(
                                                  elevation: 2,
//                              shadowColor: Color(0x26000000),
                                                  color: white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                          image: bmiBackground,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.0),
                                                          color: Colors.white),
//                              width: devWidth * 0.9,
                                                      height: devHeight * 0.8,
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                devWidth * 0.06,
                                                                devWidth * 0.06,
                                                                devWidth * 0.06,
                                                                devWidth *
                                                                    0.06),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              children: [
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      gender =
                                                                          0;
                                                                    });
                                                                  },
                                                                  child: Material(
                                                                      elevation:
//                                                      gender == 0 ? 0 :
                                                                          2,
//                                                shadowColor: Color(0x26000000),
                                                                      borderRadius: BorderRadius.circular(20.0),
                                                                      child: Container(
                                                                          width: devWidth * 0.25,
                                                                          decoration: gender == 0
                                                                              ? BoxDecoration(boxShadow: [
                                                                                  BoxShadow(
                                                                                    blurRadius: 5,
                                                                                    spreadRadius: -10,
                                                                                  )
                                                                                ], borderRadius: BorderRadius.circular(20.0), color: defaultGreen)
                                                                              : BoxDecoration(borderRadius: BorderRadius.circular(20.0), color: Colors.white),
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
                                                                                    color: gender == 0 ? Colors.white : questionnaireDisabled,
                                                                                    size: 36,
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: devHeight * 0.00625,
                                                                                  ),
                                                                                  Text(
                                                                                    'MALE',
                                                                                    style: gender == 0 ? questionnaireDisabledStyle.copyWith(fontWeight: FontWeight.normal, color: Colors.white) : questionnaireDisabledStyle.copyWith(fontWeight: FontWeight.normal),
                                                                                  )
                                                                                ],
                                                                              )))),
                                                                ),
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      gender =
                                                                          1;
                                                                    });
                                                                  },
                                                                  child: Material(
                                                                      elevation:
//                                                      gender == 1 ? 0 :
                                                                          2,
//                                                shadowColor: Color(0x26000000),
                                                                      borderRadius: BorderRadius.circular(20.0),
                                                                      child: Container(
                                                                          width: devWidth * 0.25,
                                                                          decoration: BoxDecoration(
//                                                        boxShadow: [
//                                                          BoxShadow(
//                                                              color: Color(
//                                                                  0x26000000),
//                                                              blurRadius: 5)
//                                                        ],
                                                                              borderRadius: BorderRadius.circular(20.0),
                                                                              color: gender == 1 ? defaultPurple : Colors.white),
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
                                                                                    color: gender == 1 ? Colors.white : questionnaireDisabled,
                                                                                    size: 36,
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: devHeight * 0.00625,
                                                                                  ),
                                                                                  Text(
                                                                                    'FEMALE',
                                                                                    style: gender == 1 ? questionnaireDisabledStyle.copyWith(fontWeight: FontWeight.normal, color: Colors.white) : questionnaireDisabledStyle.copyWith(fontWeight: FontWeight.normal),
                                                                                  )
                                                                                ],
                                                                              )))),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    RotatedBox(
                                                                      quarterTurns:
                                                                          3,
                                                                      child:
                                                                          SliderTheme(
                                                                        data: SliderTheme.of(context)
                                                                            .copyWith(
                                                                          inactiveTrackColor:
                                                                              Color(0xFFEFEFEF),
                                                                          activeTrackColor: gender == 0
                                                                              ? defaultGreen
                                                                              : defaultPurple,
                                                                          thumbColor: gender == 0
                                                                              ? defaultGreen
                                                                              : defaultPurple,
                                                                          overlayColor: gender == 0
                                                                              ? defaultGreen
                                                                              : defaultPurple,
                                                                          thumbShape:
                                                                              RoundSliderThumbShape(enabledThumbRadius: 8.0),
                                                                          overlayShape:
                                                                              RoundSliderOverlayShape(overlayRadius: 8.0),
                                                                        ),
                                                                        child:
                                                                            Slider(
                                                                          value:
                                                                              height.toDouble(),
                                                                          min:
                                                                              120.0,
                                                                          max:
                                                                              220.0,
                                                                          onChanged:
                                                                              (double newValue) {
                                                                            setState(() {
                                                                              height = newValue.round();
                                                                            });
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Padding(
                                                                          padding:
                                                                              EdgeInsets.only(left: 5.0),
                                                                          child:
                                                                              Text(
                                                                            height.toString(),
                                                                            style:
                                                                                questionnaireDisabledStyle.copyWith(fontSize: 32),
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
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Text(
                                                                          weight
                                                                              .toString(),
                                                                          style:
                                                                              questionnaireDisabledStyle.copyWith(fontSize: 32),
                                                                        ),
                                                                        SliderTheme(
                                                                          data:
                                                                              SliderTheme.of(context).copyWith(
                                                                            inactiveTrackColor:
                                                                                Color(0xFFEFEFEF),
                                                                            activeTrackColor: gender == 0
                                                                                ? defaultGreen
                                                                                : defaultPurple,
                                                                            thumbColor: gender == 0
                                                                                ? defaultGreen
                                                                                : defaultPurple,
                                                                            overlayColor: gender == 0
                                                                                ? defaultGreen
                                                                                : defaultPurple,
                                                                            thumbShape:
                                                                                RoundSliderThumbShape(enabledThumbRadius: 8.0),
                                                                            overlayShape:
                                                                                RoundSliderOverlayShape(overlayRadius: 8.0),
                                                                          ),
                                                                          child:
                                                                              Slider(
                                                                            value:
                                                                                weight.toDouble(),
                                                                            min:
                                                                                40.0,
                                                                            max:
                                                                                180.0,
                                                                            onChanged:
                                                                                (double newValue) {
                                                                              setState(() {
                                                                                weight = newValue.round();
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
                                                                      height:
                                                                          devHeight *
                                                                              0.05,
                                                                    ),
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Text(
                                                                          age.toString(),
                                                                          style:
                                                                              questionnaireDisabledStyle.copyWith(fontSize: 32),
                                                                        ),
                                                                        SliderTheme(
                                                                          data:
                                                                              SliderTheme.of(context).copyWith(
                                                                            inactiveTrackColor:
                                                                                Color(0xFFEFEFEF),
                                                                            activeTrackColor: gender == 0
                                                                                ? defaultGreen
                                                                                : defaultPurple,
                                                                            thumbColor: gender == 0
                                                                                ? defaultGreen
                                                                                : defaultPurple,
                                                                            overlayColor: gender == 0
                                                                                ? defaultGreen
                                                                                : defaultPurple,
                                                                            thumbShape:
                                                                                RoundSliderThumbShape(enabledThumbRadius: 8.0),
                                                                            overlayShape:
                                                                                RoundSliderOverlayShape(overlayRadius: 8.0),
                                                                          ),
                                                                          child:
                                                                              Slider(
                                                                            value:
                                                                                age.toDouble(),
                                                                            min:
                                                                                16.0,
                                                                            max:
                                                                                100.0,
                                                                            onChanged:
                                                                                (double newValue) {
                                                                              setState(() {
                                                                                age = newValue.round();
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
                                                              padding:
                                                                  const EdgeInsets
                                                                          .fromLTRB(
                                                                      0,
                                                                      0,
                                                                      0,
                                                                      0),
                                                              child: SizedBox(
                                                                width: double
                                                                    .infinity,
                                                                height: 50.0,
                                                                child:
                                                                    TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    bmi = weight /
                                                                        (height *
                                                                            height /
                                                                            10000);
                                                                    display_bmi =
                                                                        bmi.toStringAsPrecision(
                                                                            3);
                                                                    print(
                                                                        display_bmi);
                                                                    if (bmi <
                                                                        bmi_values[
                                                                            0]) {
                                                                      report =
                                                                          0;
                                                                    } else if (bmi <
                                                                        bmi_values[
                                                                            1]) {
                                                                      report =
                                                                          1;
                                                                    } else if (bmi <
                                                                        bmi_values[
                                                                            2]) {
                                                                      report =
                                                                          2;
                                                                    } else {
                                                                      report =
                                                                          3;
                                                                    }
                                                                    print(
                                                                        'postList: $postList');
                                                                    if (postList
                                                                        .contains(
                                                                            null)) {
                                                                      Scaffold.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                              SnackBar(
                                                                        content:
                                                                            Text('Please fill out all the questions to proceed'),
                                                                      ));
                                                                    } else {
                                                                      bool
                                                                          allQuestionsSubmitted =
                                                                          true;
                                                                      postList.forEach(
                                                                          (item) async {
                                                                        bool
                                                                            res =
                                                                            await _apiCall.sendOptionsAnswers(item);
                                                                        if (res ==
                                                                            true) {
                                                                          postRes
                                                                              .add(res);
                                                                        }
                                                                      });
                                                                      if (postRes
                                                                              .length !=
                                                                          questions
                                                                              .length) {
                                                                        allQuestionsSubmitted =
                                                                            false;
                                                                      }
                                                                      // RegModel
                                                                      //     updateUserData =
                                                                      //     Api.userInfo;
                                                                      // updateUserData
                                                                      //     .setQuestionnaireStatus(1);
                                                                      // bool
                                                                      //     result =
                                                                      //     false;
                                                                      // result =
                                                                      //     await _apiCall.putUserInfo(updateUserData);
                                                                      if (allQuestionsSubmitted) {
                                                                        print(
                                                                            'Questionnaire filled Successfully');
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(builder: (context) => BmiReport(bmi: display_bmi, report: report, age: age, gender: gender, questionnaire: true)));
                                                                      } else {
                                                                        print(
                                                                            'There was an issue submitting the questionnaire');
                                                                      }
                                                                    }
                                                                  },
                                                                  child: Text(
                                                                    'NEXT',
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          'RobotoReg',
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                  style: TextButton.styleFrom(
                                                                      backgroundColor: gender ==
                                                                              0
                                                                          ? defaultGreen
                                                                          : defaultPurple,
                                                                      shape: const RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.all(Radius.circular(25)))),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ))),
                                            )
                                          : SizedBox();
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
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Center(
                child: SpinKitThreeBounce(
                  color: defaultPurple,
                  size: 32,
                ),
              ),
      ),
    );
  }
}
