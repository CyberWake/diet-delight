import 'package:diet_delight/Screens/export.dart';
import 'package:flutter/material.dart';

class SettingsFAQPage extends StatefulWidget {
  @override
  _SettingsFAQPageState createState() => _SettingsFAQPageState();
}

class _SettingsFAQPageState extends State<SettingsFAQPage> {
  ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        accentColor: Color.fromRGBO(144, 144, 144, 1),
      ),
      child: Container(
        color: Colors.white,
        child: ListView.builder(
            controller: _scrollController,
            itemCount: faqAnswers.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0.0, horizontal: 15.0),
                child: ExpansionTile(
                  onExpansionChanged: (bool expanded) {},
                  initiallyExpanded: index == 0 ? true : false,
                  tilePadding: EdgeInsets.all(10.0),
                  title: Text(faqQuestions[index],
                      style: selectedTab.copyWith(
                          fontSize: 14,
                          fontFamily: 'RobotoReg',
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.w600,
                          color: questionnaireDisabled)),
                  childrenPadding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                  children: List.generate(1, (int index) {
                    return Text(faqAnswers[index],
                        textAlign: TextAlign.justify,
                        style: selectedTab.copyWith(
                            fontSize: 14,
                            fontFamily: 'MontserratReg',
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF77838F)));
                  }),
                ),
              );
            }),
      ),
    );
  }
}
