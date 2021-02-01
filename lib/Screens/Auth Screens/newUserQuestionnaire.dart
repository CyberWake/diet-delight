import 'package:diet_delight/Models/consultationModel.dart';
import 'package:diet_delight/Models/questionnaireModel.dart';
import 'package:diet_delight/Screens/Consultation/bookConsultation.dart';
import 'package:diet_delight/konstants.dart';
import 'package:diet_delight/landingPage.dart';
import 'package:diet_delight/services/apiCalls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  TabController _pageController;
  int questionNumber = 0;
  bool isLoaded = false;
  bool show = false;
  bool next = false;
  bool notAnswered = true;
  int chatLength = 0;
  List<QuestionnaireModel> questions;
  TextEditingController answer = TextEditingController();
  List<List<String>> options = [
    [
      'Weight Loss',
      'Weight Gain/Bodybuilding',
      'Medical Reason',
      'Healthy Lifestyle/Food Convenience'
    ],
    ['YES. Please specify:', 'NO'],
    ['Please specify:'],
    ['YES', 'NO'],
    ['YES. Please specify:', 'NO'],
    ['YES. Please specify:', 'NO'],
  ];

  Future getQuestions() async {
    questions = await _apiCall.getQuestions();
    consultationPackages = await _apiCall.getConsultationPackages();
    _pageController = TabController(length: questions.length, vsync: this);
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

  Widget buildOptions(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: ListView.builder(
        itemCount: options[index].length,
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        reverse: true,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int optionIndex) {
          return Container(
            alignment: Alignment.centerLeft,
            child: !options[index][optionIndex].contains("Please specify:")
                ? ActionChip(
                    elevation: 8.0,
                    padding: EdgeInsets.all(2.0),
                    avatar: CircleAvatar(
                      backgroundColor: defaultGreen,
                      child: Icon(
                        Icons.circle,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    label: Text(options[index][optionIndex]),
                    onPressed: () {
                      _pageController.animateTo(_pageController.index + 1);
                      setState(() {});
                    },
                    backgroundColor: Colors.grey[200],
                    shape: StadiumBorder(
                        side: BorderSide(
                      width: 1,
                      color: defaultGreen,
                    )),
                  )
                : Container(
                    height: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 7,
                          child: ActionChip(
                            elevation: 8.0,
                            padding: EdgeInsets.all(2.0),
                            avatar: CircleAvatar(
                              backgroundColor: defaultGreen,
                              child: Icon(
                                Icons.circle,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            label: Text(options[index][optionIndex]),
                            onPressed: () {
                              print('tapped: $index');
                              setState(() {
                                show = true;
                              });
                            },
                            backgroundColor: Colors.grey[200],
                            shape: StadiumBorder(
                                side: BorderSide(
                              width: 1,
                              color: defaultGreen,
                            )),
                          ),
                        ),
                        Expanded(
                          flex: 9,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
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
                                          onFieldSubmitted: (done) {
                                            if (done.isNotEmpty) {
                                              _pageController.animateTo(
                                                  _pageController.index + 1);
                                              setState(() {
                                                show = false;
                                              });
                                            }
                                          },
                                          style: authInputTextStyle,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.done,
                                          decoration: questionNumber == 2
                                              ? authInputFieldDecoration
                                                  .copyWith(
                                                      hintText: "Height-Weight")
                                              : authInputFieldDecoration),
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0.0,
          backgroundColor: inactiveGreen,
          centerTitle: true,
          title: Text('Questionnaire', style: appBarTextStyle),
        ),
        body: isLoaded
            ? TabBarView(
                controller: _pageController,
                children: List.generate(questions.length + 1, (index) {
                  if (index == questions.length) {
                    return Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('Do you need a Consultation?'),
                          Flexible(
                            fit: FlexFit.loose,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ActionChip(
                                  elevation: 8.0,
                                  padding: EdgeInsets.all(2.0),
                                  avatar: CircleAvatar(
                                    backgroundColor: defaultGreen,
                                    child: Icon(
                                      Icons.circle,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  label: Text('No'),
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (context) =>
                                                HomePage()));
                                  },
                                  backgroundColor: Colors.grey[200],
                                  shape: StadiumBorder(
                                      side: BorderSide(
                                        width: 1,
                                        color: defaultGreen,
                                      )),
                                ),
                                ActionChip(
                                  elevation: 8.0,
                                  padding: EdgeInsets.all(2.0),
                                  avatar: CircleAvatar(
                                    backgroundColor: defaultGreen,
                                    child: Icon(
                                      Icons.circle,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  label: Text('Yes'),
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (context) => HomePage()));
                                    Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (context) =>
                                                BookConsultation(
                                                  packageIndex: 0,
                                                  consultation:
                                                  consultationPackages,
                                                )));
                                  },
                                  backgroundColor: Colors.grey[200],
                                  shape: StadiumBorder(
                                      side: BorderSide(
                                        width: 1,
                                        color: defaultGreen,
                                      )),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  }
                  return Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              index == 0
                                  ? "Hi ${widget.username} let us know something about yourself?\n\n" +
                                      questions[index].question
                                  : questions[index].question,
                              style: TextStyle(
                                fontFamily: 'RobotoCondensedReg',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            buildOptions(index),
                          ]));
                }))
            : Center(child: CircularProgressIndicator()));
  }
}
