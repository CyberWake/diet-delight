import 'package:diet_delight/Models/consultationModel.dart';
import 'package:diet_delight/Models/optionsFile.dart';
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
  List<OptionsModel> options;
  TextEditingController answer = TextEditingController();


  Future getQuestions() async {
    questions = await _apiCall.getQuestions();
    options = await _apiCall.getOptions(questions);
    consultationPackages = await _apiCall.getConsultationPackages();
    print(questions.length);
    _currentIndex = 0;

    _pageController = TabController(length: questions.length + 1, vsync: this);
    _pageController.addListener(() {
      setState(() {
        _currentIndex = _pageController.index;
      });
    });
  }
  int _currentIndex;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < questions.length+1; i++) {
      list.add(i == _currentIndex ? _indicator(true,i) : _indicator(false,i));
    }
    return list;
  }

  Widget _indicator(bool isActive,int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      height: 6.0,
      width: (MediaQuery.of(context).size.width*0.6)/questions.length,
      decoration: BoxDecoration(
        color: index <= _currentIndex ? Colors.white : Color(0xFF7B51D3),
        borderRadius: index == 0 ? BorderRadius.only(topLeft: Radius.circular(50),bottomLeft: Radius.circular(50)) :
        index == questions.length ?  BorderRadius.only(topRight: Radius.circular(50),bottomRight: Radius.circular(50)) : BorderRadius.circular(0) ,
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

  List<String> quest = [
    "How are you feeling today ?",
    "Do you feel good",
    "Do you feel bad ?"
  ];

  int indexSelected = -1;

  int optionIndex = 0;

  Widget buildOptions(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: ListView.builder(
        itemCount: questions[index].type == 1 ? 2 : questions[index].type== 2 ? options[index].option.toString().split(",").length : 1,
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        reverse: true,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int optionIndex) {
          print(optionIndex);
          return Container(
            alignment: Alignment.centerLeft,
            child: questions[index].type == 1 || questions[index].type == 2
                ? Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 4),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    show = false;
                    indexSelected = optionIndex;
                  });
                },
                child: Container(
                  height: 50,
                  width: double.infinity,
                  padding:
                  EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
                  child: Center(
                      child: Text(
                        options[index].option.toString().split(",")[optionIndex],
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
                      border: Border.all(width: 2,color: defaultGreen)
                  ),
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
                                  : defaultGreen, border: Border.all(width: 2,color: defaultGreen)
                          ),
                        ),
                      ),
                    ),
                    Expanded(flex: 3,child: Container(),),
                    Expanded(
                      flex: 9,
                      child: Container(
                        margin: EdgeInsets.only(top: 0,left: 4,right: 4),
                        child:  !show ? Container() : Container(
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
                                      indexSelected = -1;
                                      show = false;
                                    });
                                  }
                                },
                                style: authInputTextStyle,
                                keyboardType: TextInputType.text,
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

  @override
  Widget build(BuildContext context) {
    var keyboard = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
        backgroundColor: defaultGreen,
        // appBar: AppBar(
        //   automaticallyImplyLeading: false,
        //   elevation: 0.0,
        //   backgroundColor: inactiveGreen,
        //   centerTitle: true,
        //   title: Text('Questionnaire', style: appBarTextStyle),
        // ),
        body: isLoaded
            ? questions.length != 0 ? ListView(
          children: [
            Container(
              height: MediaQuery.of(context).size.height*0.96,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Let us know you better",style: TextStyle(color: Colors.white,fontSize: 18),),
                  Container(
                    height: MediaQuery.of(context).size.height*0.8,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical :8.0, horizontal: 20),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30)
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height*0.71,
                              child: TabBarView(
                                  controller: _pageController,
                                  children: List.generate(questions.length + 1, (index) {
                                    if (index == questions.length) {
                                      return Container(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text('Do you need a Consultation?',style: questionTextStyle,),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 4.0, bottom: 4),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Navigator.pushReplacement(
                                                            context,
                                                            CupertinoPageRoute(
                                                                builder: (context) => HomePage()));
                                                      },
                                                      child: Container(
                                                        width: double.infinity,
                                                        padding:
                                                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),

                                                        child: Center(child: Text('No',style: TextStyle(color: Colors.white),)),
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(50),
                                                            color: defaultGreen,
                                                            border: Border.all(width: 2,color: defaultGreen)
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 4.0, bottom: 4),
                                                    child: GestureDetector(
                                                      onTap: () {
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
                                                      child: Container(
                                                        width: double.infinity,
                                                        padding:
                                                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),

                                                        child: Center(child: Text('Yes',style: TextStyle(color: Colors.white),)),
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(50),
                                                            color: defaultGreen,
                                                            border: Border.all(width: 2,color: defaultGreen)
                                                        ),
                                                      ),
                                                    ),
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
                                            mainAxisAlignment: keyboard==null || keyboard == 0 ? MainAxisAlignment.spaceEvenly :MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                                                child: Text(
                                                    index == 0
                                                        ? "Hi ${widget.username} let us know something about yourself?\n\n" +
                                                        questions[index].question
                                                        : questions[index].question,
                                                    style: questionTextStyle
                                                ),
                                              ),
                                              buildOptions(index),
                                            ]));
                                  })),
                            ),
                            _currentIndex < questions.length ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right : 35.0,bottom:10),
                                  child: Container(
                                    alignment: Alignment.bottomRight,
                                    decoration: BoxDecoration(
                                        color: Color.fromRGBO(196, 196, 196, 0.8),
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal : 10.0,vertical: 5),
                                      child: GestureDetector(
                                        onTap: () async {
                                          // await _apiCall.sendOptionsAnswers(
                                          //     answerId: options[_pageController.index].id,
                                          //     questionId: options[_pageController.index].question_Id,
                                          //     additionalText: questions[_pageController.index].additionText,
                                          //     answer: options[_pageController.index].toString().split(",")[indexSelected],
                                          //     question: questions[_pageController.index].question,
                                          //     type: questions[_pageController.index].type,
                                          //     optionSelected: options[_pageController.index].toString().split(",")[indexSelected]
                                          // );
                                          setState(() async {

                                            show = false;
                                            indexSelected = -1;
                                            _pageController.animateTo(_pageController.index + 1);
                                          });
                                        },
                                        child: Text(
                                          "Submit",style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ) : Container()
                          ],
                        ),
                      ),
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
        ) : Center(child: Text("No questions to show"))
            : Center(child: CircularProgressIndicator()));
  }
}