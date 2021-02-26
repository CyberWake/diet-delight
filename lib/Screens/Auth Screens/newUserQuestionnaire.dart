import 'package:carousel_slider/carousel_slider.dart';
import 'package:diet_delight/Models/export_models.dart';
import 'package:diet_delight/Screens/export.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Questionnaire extends StatefulWidget {
  final String username;
  Questionnaire({this.username});
  @override
  _QuestionnaireState createState() => _QuestionnaireState();
}

class _QuestionnaireState extends State<Questionnaire>
    with SingleTickerProviderStateMixin {
  List<ConsultationModel> consultationPackages;
  final _apiCall = Api.instance;
  CarouselController _carController = CarouselController();
  int questionNumber = 0;
  bool isLoaded = false;
  bool show = false;
  bool next = false;
  bool notAnswered = true;
  int chatLength = 0;
  List<QuestionnaireModel> questions;
  List<OptionsModel> options;
  var answer;

  Future getQuestions() async {
    //await _apiCall.getUserInfo();
    questions = await _apiCall.getQuestions();
    options = await _apiCall.getOptions(questions);
    consultationPackages = await _apiCall.getConsultationPackages();
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
    // _pageController = TabController(length: questions.length + 1, vsync: this);
    // _pageController.addListener(() {
    //   setState(() {
    //     _currentIndex = _pageController.index;
    //   });
    // });
  }

  int _currentIndex = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < questions.length + 1; i++) {
      list.add(i == _currentIndex ? _indicator(true, i) : _indicator(false, i));
    }
    return list;
  }

  Widget _indicator(bool isActive, int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      height: 6.0,
      width: (MediaQuery.of(context).size.width * 0.6) / questions.length,
      decoration: BoxDecoration(
        color: index <= _currentIndex ? Colors.white : Color(0xFF7B51D3),
        borderRadius: index == 0
            ? BorderRadius.only(
                topLeft: Radius.circular(50), bottomLeft: Radius.circular(50))
            : index == questions.length
                ? BorderRadius.only(
                    topRight: Radius.circular(50),
                    bottomRight: Radius.circular(50))
                : BorderRadius.circular(0),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getQuestions().whenComplete(() {
      setState(() {
        isLoaded = true;
      });
    });
  }

  List<String> opt = [
    "Yes",
    "No",
  ];

  int indexSelected = -1;
  int optionId;

  Widget buildOptions(int index) {
    print(questions[index].type);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: ListView.builder(
        itemCount: questions[index].type == 1
            ? 2
            : questions[index].type == 2
                ? options.length
                : 1,
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        reverse: true,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int optionIndex) {
          print(options[optionIndex].question_Id);
          print(questions[index].id);
          return Container(
            alignment: Alignment.centerLeft,
            child: questions[index].type == 1
                ? Padding(
                    padding: const EdgeInsets.only(top: 4.0, bottom: 4),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          show = false;
                          indexSelected = optionIndex;
                          optionId = 0;
                        });
                      },
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        padding:
                            EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
                        child: Center(
                            child: Text(
                          opt[optionIndex],
                          style: TextStyle(
                            color: indexSelected == optionIndex
                                ? Colors.black
                                : Colors.white,
                          ),
                        )),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: indexSelected == optionIndex
                                ? Colors.white
                                : defaultGreen,
                            border: Border.all(width: 2, color: defaultGreen)),
                      ),
                    ),
                  )
                : questions[index].type == 2 &&
                        questions[index].id == options[optionIndex].question_Id
                    ? Padding(
                        padding: const EdgeInsets.only(top: 4.0, bottom: 4),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              show = false;
                              indexSelected = optionIndex;
                              optionId = options[optionIndex].id;
                            });
                          },
                          child: Container(
                            height: 50,
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 15),
                            child: Center(
                                child: Text(
                              options[optionIndex].option,
                              style: TextStyle(
                                color: indexSelected == optionIndex
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            )),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: indexSelected == optionIndex
                                    ? Colors.white
                                    : defaultGreen,
                                border:
                                    Border.all(width: 2, color: defaultGreen)),
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 4.0, bottom: 4),
                        child: Container(
                          height: 120,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 9,
                                child: GestureDetector(
                                  onTap: () {
                                    print('tapped: $index');
                                    setState(() {
                                      show = true;
                                      indexSelected = optionIndex;
                                      optionId = 0;
                                    });
                                  },
                                  child: Container(
                                    height: 50,
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 15),
                                    child: Center(
                                      child: Text(
                                        "Please Specify",
                                        style: TextStyle(
                                          color: indexSelected == optionIndex
                                              ? Colors.black
                                              : Colors.white,
                                        ),
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: indexSelected == optionIndex
                                            ? Colors.white
                                            : defaultGreen,
                                        border: Border.all(
                                            width: 2, color: defaultGreen)),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(),
                              ),
                              Expanded(
                                flex: 9,
                                child: Container(
                                  margin: EdgeInsets.only(
                                      top: 0, left: 4, right: 4),
                                  child: !show
                                      ? Container()
                                      : Container(
                                          width: double.infinity,
                                          height: 40.0,
                                          decoration: authFieldDecoration,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                20, 3, 20, 3),
                                            child: TextFormField(
                                                onChanged: (value) {
                                                  setState(() {
                                                    answer = value;
                                                  });
                                                },
                                                onFieldSubmitted: (done) {
                                                  if (done.isNotEmpty) {
                                                    _carController.nextPage();
                                                    setState(() {
                                                      indexSelected = -1;
                                                      show = false;
                                                    });
                                                  }
                                                },
                                                style: authInputTextStyle,
                                                keyboardType:
                                                    TextInputType.text,
                                                textInputAction:
                                                    TextInputAction.done,
                                                decoration: questionNumber == 2
                                                    ? authInputFieldDecoration
                                                        .copyWith(
                                                            hintText:
                                                                "Height-Weight")
                                                    : authInputFieldDecoration),
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
          );
        },
      ),
    );
  }

  var questionTextStyle = TextStyle(
    fontFamily: 'RobotoCondensedReg',
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var keyboard = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: defaultGreen,
        // appBar: AppBar(
        //   automaticallyImplyLeading: false,
        //   elevation: 0.0,
        //   backgroundColor: inactiveGreen,
        //   centerTitle: true,
        //   title: Text('Questionnaire', style: appBarTextStyle),
        // ),
        body: isLoaded
            ? questions.length != 0
                ? ListView(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.96,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Let us know you better",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.78,
                              width: double.infinity,
                              child: Column(
                                children: [
                                  CarouselSlider(
                                      options: CarouselOptions(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.78,
                                          aspectRatio: 16 / 9,
                                          viewportFraction: 0.85,
                                          initialPage: 0,
                                          enableInfiniteScroll: false,
                                          reverse: false,
                                          autoPlay: false,
                                          autoPlayInterval:
                                              Duration(seconds: 1),
                                          autoPlayAnimationDuration:
                                              Duration(milliseconds: 800),
                                          autoPlayCurve: Curves.fastOutSlowIn,
                                          enlargeCenterPage: true,
                                          //     onPageChanged: callbackFunction,
                                          scrollDirection: Axis.horizontal,
                                          scrollPhysics:
                                              NeverScrollableScrollPhysics()),
                                      carouselController: _carController,
                                      items: List.generate(questions.length + 1,
                                          (index) {
                                        if (index == questions.length) {
                                          return Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(30)),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.71,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  'Do you need a Consultation?',
                                                  style: questionTextStyle,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 20.0,
                                                      vertical: 15.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 4.0,
                                                                bottom: 4),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            Navigator.pushReplacement(
                                                                context,
                                                                CupertinoPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            HomePage()));
                                                          },
                                                          child: Container(
                                                            width:
                                                                double.infinity,
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        8.0,
                                                                    vertical:
                                                                        15),
                                                            child: Center(
                                                                child: Text(
                                                              'No',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            )),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            50),
                                                                color:
                                                                    defaultGreen,
                                                                border: Border.all(
                                                                    width: 2,
                                                                    color:
                                                                        defaultGreen)),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 4.0,
                                                                bottom: 4),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            Navigator.pushReplacement(
                                                                context,
                                                                CupertinoPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            HomePage()));
                                                            Navigator.push(
                                                                context,
                                                                CupertinoPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            BookConsultation(
                                                                              packageIndex: 0,
                                                                              consultation: consultationPackages,
                                                                            )));
                                                          },
                                                          child: Container(
                                                            width:
                                                                double.infinity,
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        8.0,
                                                                    vertical:
                                                                        15),
                                                            child: Center(
                                                                child: Text(
                                                              'Yes',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            )),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            50),
                                                                color:
                                                                    defaultGreen,
                                                                border: Border.all(
                                                                    width: 2,
                                                                    color:
                                                                        defaultGreen)),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                        return Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(30)),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.71,
                                            padding: EdgeInsets.all(10),
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    flex: 10,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          keyboard == null ||
                                                                  keyboard == 0
                                                              ? MainAxisAlignment
                                                                  .spaceEvenly
                                                              : MainAxisAlignment
                                                                  .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      20.0,
                                                                  vertical:
                                                                      15.0),
                                                          child: Text(
                                                              index == 0
                                                                  ? "Hi ${widget.username} let us know something about yourself?\n\n" +
                                                                      questions[
                                                                              index]
                                                                          .question
                                                                  : questions[
                                                                          index]
                                                                      .question,
                                                              style:
                                                                  questionTextStyle),
                                                        ),
                                                        buildOptions(index),
                                                      ],
                                                    ),
                                                  ),
                                                  _currentIndex <
                                                          questions.length
                                                      ? Expanded(
                                                          flex: 1,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Container(
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.07,
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      right:
                                                                          20.0,
                                                                      bottom:
                                                                          10),
                                                                  child:
                                                                      Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .bottomRight,
                                                                    decoration: BoxDecoration(
                                                                        color: Color.fromRGBO(
                                                                            196,
                                                                            196,
                                                                            196,
                                                                            0.8),
                                                                        borderRadius:
                                                                            BorderRadius.circular(10)),
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          horizontal:
                                                                              10.0,
                                                                          vertical:
                                                                              8),
                                                                      child:
                                                                          GestureDetector(
                                                                        onTap: indexSelected <
                                                                                0
                                                                            ? () {
                                                                                _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Please pick an option')));
                                                                              }
                                                                            : () async {
                                                                                var orderId = questions[_currentIndex].type != 2 ? 0 : options[indexSelected].id;
                                                                                var ans = questions[_currentIndex].type == 0 || questions[_currentIndex].type == 3
                                                                                    ? answer
                                                                                    : questions[_currentIndex].type == 1
                                                                                        ? opt[indexSelected]
                                                                                        : options[indexSelected].option;
                                                                                var addText = questions[_currentIndex].additionText == null ? "0" : questions[_currentIndex].additionText;
                                                                                print(ans);
                                                                                if (ans == null) {
                                                                                  _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Please enter some value')));
                                                                                } else {
                                                                                  await _apiCall.sendOptionsAnswers(answerId: orderId, questionId: questions[_currentIndex].id, additionalText: addText, answer: ans, question: questions[_currentIndex].question, type: questions[_currentIndex].type, optionSelected: ans);
                                                                                  answer = null;
                                                                                  setState(() {
                                                                                    show = false;
                                                                                    indexSelected = -1;
                                                                                    _carController.nextPage();
                                                                                  });
                                                                                }
                                                                              },
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            "Submit",
                                                                            style:
                                                                                TextStyle(color: Colors.black),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      : Container()
                                                ]));
                                      })),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: _buildPageIndicator(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Center(child: Text("No questions to show"))
            : Center(child: SpinKitDoubleBounce(color: defaultGreen)));
  }
}
