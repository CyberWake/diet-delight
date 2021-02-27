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
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/Group 7.png'),
              fit: BoxFit.cover
          )
      ),
      child: ListView.builder(
          controller: _scrollController,
          itemCount: faqAnswers.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(left: 28.0, right: 20),
              child: ExpansionTile(
                onExpansionChanged: (bool expanded) {},
                initiallyExpanded: index == 0 ? true : false,
                tilePadding: EdgeInsets.only(left: 0, bottom: 0),
                title: Text(faqQuestions[index],
                    style: selectedTab.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black)),
                childrenPadding: EdgeInsets.only(left: 0, bottom: 10),
                children: List.generate(1, (int index) {
                  return Text(faqAnswers[index],
                      style: selectedTab.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color( 0xFF77838F)));
                }),
              ),
            );
          }),
    );
  }
}
