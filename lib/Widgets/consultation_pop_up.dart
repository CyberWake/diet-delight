import 'package:flutter/material.dart';
import 'package:diet_delight/konstants.dart';

class ConsultationPopUp extends StatefulWidget {
  final Function(int) callBackFunction;
  final int selectedIndex;
  ConsultationPopUp({this.callBackFunction,this.selectedIndex});

  @override
  _ConsultationPopUpState createState() => _ConsultationPopUpState();
}

class _ConsultationPopUpState extends State<ConsultationPopUp> {
  List<String> opt = ['Silver', 'Gold', 'Platinum'];
  int selectedIndex;
  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)), //this right here
      child: Container(
        height: opt.length.toDouble() * 56,
        width: MediaQuery.of(context).size.width * 0.5,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                GestureDetector(
                  onTap: () {
                    widget.callBackFunction(0);
                    setState(() {
                      selectedIndex = 0;
                    });
                    Navigator.pop(context);
                  },
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 60.0,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: itemColors[0]),
                              borderRadius:
                              BorderRadius.all(Radius.elliptical(100, 70))),
                          height: 40,
                        ),
                        SizedBox(height: 3.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              opt[0],
                              style: consultationSelectStyle,
                            ),
                            selectedIndex == 0
                                ? Icon(
                              Icons.check_circle_outline,
                              size: 22,
                              color: defaultGreen,
                            )
                                : SizedBox()
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    widget.callBackFunction(2);
                    setState(() {
                      selectedIndex = 2;
                    });
                    Navigator.pop(context);
                  },
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 60.0,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: itemColors[2]),
                              borderRadius:
                              BorderRadius.all(Radius.elliptical(100, 70))),
                          height: 40,
                        ),
                        SizedBox(height: 3.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              opt[2],
                              style: consultationSelectStyle,
                            ),
                            selectedIndex == 2
                                ? Icon(
                              Icons.check_circle_outline,
                              size: 22,
                              color: defaultGreen,
                            )
                                : SizedBox()
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      widget.callBackFunction(1);
                      setState(() {
                        selectedIndex = 1;
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 60.0,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: itemColors[1]),
                                borderRadius: BorderRadius.all(
                                    Radius.elliptical(100, 70))),
                            height: 40,
                          ),
                          SizedBox(height: 3.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                opt[1],
                                style: consultationSelectStyle,
                              ),
                              selectedIndex == 1
                                  ? Icon(
                                Icons.check_circle_outline,
                                size: 22,
                                color: defaultGreen,
                              )
                                  : SizedBox()
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
