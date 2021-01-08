import 'package:diet_delight/Models/questionnaireModel.dart';
import 'package:diet_delight/Screens/Home%20Page/home.dart';
import 'package:diet_delight/konstants.dart';
import 'package:diet_delight/services/apiCalls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Questionnaire extends StatefulWidget {
  @override
  _QuestionnaireState createState() => _QuestionnaireState();
}

class _QuestionnaireState extends State<Questionnaire> {
  final _apiCall = Api.instance;
  bool isLoaded = false;
  List<QuestionnaireModel> questions;
  TextEditingController answer = TextEditingController();
  bool isChecked = false;
  List<List<bool>> checkIndex = [
    [false, false, false, false],
    [false, false],
    [],
    [false, false],
    [false, false],
    [false, false],
  ];
  List<List<String>> options = [
    [
      'Weight Loss',
      'Weight Gain/Bodybuilding',
      'Medical Reason',
      'Healthy Lifestyle/Food Convenience'
    ],
    ['YES. Please specify:', 'NO'],
    [''],
    ['YES', 'NO'],
    ['YES. Please specify:', 'NO'],
    ['YES. Please specify:', 'NO'],
  ];

  Future getQuestions() async {
    questions = await _apiCall.getQuestions();
    questions.forEach((element) {
      element.show();
    });
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

  Widget buildQuestion(int index) {
    return ListTile(
      title: Text('${index + 1}. ${questions[index].question}'),
    );
  }

  Widget buildOptions(int index) {
    if (index == 2) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 8.0, 20, 0),
        child: Material(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            width: double.infinity,
            height: 40.0,
            decoration: authFieldDecoration,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 3, 20, 7),
              child: TextFormField(
                  onChanged: (String pass) {
                    answer.text = pass;
                  },
                  onFieldSubmitted: (done) {
                    answer.text = done;
                  },
                  style: authInputTextStyle,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  decoration: authInputFieldDecoration),
            ),
          ),
        ),
      );
    }
    return Wrap(
      direction: Axis.horizontal,
      spacing: 10.0,
      runSpacing: 0.0,
      children: List.generate(options[index].length, (optionIndex) {
        return CheckboxListTile(
            checkColor: Colors.black,
            title: options[index][optionIndex] != 'YES. Please specify:'
                ? Text(options[index][optionIndex])
                : Container(
                    width: 80,
                    child: Row(
                      children: [
                        Text(options[index][optionIndex]),
                        Container(
                            width: 120,
                            child: Material(
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                width: double.infinity,
                                height: 40.0,
                                decoration: authFieldDecoration,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 20, 8),
                                  child: TextFormField(
                                      onChanged: (String pass) {
                                        answer.text = pass;
                                      },
                                      onFieldSubmitted: (done) {
                                        answer.text = done;
                                      },
                                      style: authInputTextStyle,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.done,
                                      decoration: authInputFieldDecoration),
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
            controlAffinity: ListTileControlAffinity.leading,
            value: checkIndex[index][optionIndex],
            activeColor: defaultGreen,
            onChanged: (value) {
              setState(() {
                isChecked = value;
                if (index == 0 ||
                    index == 1 ||
                    index == 3 ||
                    index == 4 ||
                    index == 5) {
                  if (checkIndex[index].contains(true)) {
                    int trueAt = checkIndex[index].indexOf(true);
                    checkIndex[index][trueAt] = !checkIndex[index][trueAt];
                  }
                }
                checkIndex[index][optionIndex] =
                    !checkIndex[index][optionIndex];
              });
              print(checkIndex);
            });
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text('Questionnaire', style: appBarTextStyle),
        ),
        body: isLoaded
            ? ListView(
                children: [
                  buildQuestion(0),
                  buildOptions(0),
                  buildQuestion(1),
                  buildOptions(1),
                  buildQuestion(2),
                  buildOptions(2),
                  buildQuestion(3),
                  buildOptions(3),
                  buildQuestion(4),
                  buildOptions(4),
                  buildQuestion(5),
                  buildOptions(5),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: TextButton(
                        onPressed: () async {
                          int count = 0;
                          checkIndex.forEach((listIndex) {
                            if (listIndex.contains(true)) {
                              count++;
                            }
                          });
                          print(count);
                          if (count == 5) {
                            Navigator.pushReplacement(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => HomePage()));
                          }
                        },
                        child: Text(
                          'Submit',
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
                  ),
                ],
              )
            : Center(child: CircularProgressIndicator()));
  }
}
