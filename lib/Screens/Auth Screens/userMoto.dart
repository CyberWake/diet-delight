import 'package:bubble/bubble.dart';
import 'package:diet_delight/Models/questionnaireModel.dart';
import 'file:///C:/Users/VK/Desktop/ritik/diet-delight-mobile/lib/Screens/landingPage.dart';
import 'package:diet_delight/konstants.dart';
import 'package:diet_delight/services/apiCalls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Questionnaire extends StatefulWidget {
  final String username;
  Questionnaire({this.username});
  @override
  _QuestionnaireState createState() => _QuestionnaireState();
}

class _QuestionnaireState extends State<Questionnaire> {
  ScrollController _scrollController = new ScrollController();
  final _apiCall = Api.instance;
  int questionNumber = 0;
  bool isLoaded = false;
  bool show = false;
  bool notAnswered = true;
  int chatLength = 0;
  List _data = [];
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
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
        itemBuilder: (BuildContext context, int optionIndex) {
          return Container(
            alignment: Alignment.centerLeft,
            child: !options[index][optionIndex].contains("Please specify:")
                ? ActionChip(
                    elevation: 8.0,
                    padding: EdgeInsets.all(2.0),
                    avatar: CircleAvatar(
                      backgroundColor: Colors.redAccent,
                      child: Icon(
                        Icons.mode_comment,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    label: Text(options[index][optionIndex]),
                    onPressed: () {
                      print('tapped: $index');
                      insertSingleItem(options[index][optionIndex]);
                      index++;
                      setState(() {
                        questionNumber++;
                      });
                      if (questionNumber == 2) {
                        setState(() {
                          show = true;
                        });
                      }
                      if (index < questions.length) {
                        insertSingleItem(
                            questions[index].question + "<question>");
                      }
                      _scrollController
                          .jumpTo(_scrollController.position.maxScrollExtent);
                    },
                    backgroundColor: Colors.grey[200],
                    shape: StadiumBorder(
                        side: BorderSide(
                      width: 1,
                      color: Colors.redAccent,
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
                              backgroundColor: Colors.redAccent,
                              child: Icon(
                                Icons.mode_comment,
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
                              color: Colors.redAccent,
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
                                              setState(() {
                                                show = false;
                                              });
                                              print('tapped: $index');
                                              print(done);
                                              if (questionNumber != 2) {
                                                insertSingleItem(options[index]
                                                            [optionIndex]
                                                        .replaceAll(
                                                            "Please specify:",
                                                            "") +
                                                    ' $done');
                                              } else {
                                                List values = done.split('-');
                                                insertSingleItem(
                                                    'Height: ${values[0]}  Weight: ${values[1]}');
                                              }
                                              index++;
                                              setState(() {
                                                questionNumber++;
                                              });
                                              if (index < questions.length) {
                                                insertSingleItem(
                                                    questions[index].question +
                                                        "<question>");
                                              }
                                              _scrollController.jumpTo(
                                                  _scrollController.position
                                                      .maxScrollExtent);
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

  Widget buildItem(String item, Animation animation, int index) {
    bool isQuestion = item.endsWith("<question>");
    return SizeTransition(
      sizeFactor: animation,
      child: Padding(
        padding: EdgeInsets.only(top: 10),
        child: Container(
          alignment: isQuestion ? Alignment.center : Alignment.center,
          child: Bubble(
            nip: BubbleNip
                .no, //isQuestion ? BubbleNip.leftTop : BubbleNip.rightTop,
            child: Text(
              item.replaceAll("<question>", ""),
              style: TextStyle(color: isQuestion ? Colors.white : Colors.black),
            ),
            color: isQuestion ? Colors.grey : Colors.blue,
            padding: BubbleEdges.all(10),
          ),
        ),
      ),
    );
  }

  insertSingleItem(String message) {
    _data.add(message);
    _listKey.currentState.insertItem(_data.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoaded && chatLength == 0) {
      _data.add('Hi ${widget.username}<question>');
      _data.add(questions[0].question + "<question>");
      chatLength++;
    }
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0.0,
          backgroundColor: inactiveGreen,
          centerTitle: true,
          title: Text('Questionnaire', style: appBarTextStyle),
        ),
        body: isLoaded
            ? Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 10, left: 10, bottom: 100, top: 10),
                    child: AnimatedList(
                      key: _listKey,
                      controller: _scrollController,
                      initialItemCount: _data.length,
                      itemBuilder: (BuildContext context, int index,
                          Animation animation) {
                        return buildItem(_data[index], animation, index);
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: questionNumber < questions.length
                        ? buildOptions(questionNumber)
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 10),
                            child: SizedBox(
                              height: 60,
                              width: double.infinity,
                              child: TextButton(
                                onPressed: () async {
                                  print('submitter');
                                  Navigator.pushReplacement(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) => HomePage()));
                                },
                                child: Text(
                                  'All set lets login',
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)))),
                              ),
                            ),
                          ),
                  )
                ],
              )
            : Center(child: CircularProgressIndicator()));
  }
}
