import 'dart:ui';

import 'package:diet_delight/Models/consultationModel.dart';
import 'package:diet_delight/konstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class ConfirmConsultation extends StatefulWidget {
  int package;
  final DateTime selectedDate;
  final String consultationTime;
  final List<ConsultationModel> consultation;

  ConfirmConsultation(
      {this.package,
      this.selectedDate,
      this.consultationTime,
      this.consultation});
  @override
  _ConfirmConsultationState createState() => new _ConfirmConsultationState();
}

class _ConfirmConsultationState extends State<ConfirmConsultation> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double devWidth = MediaQuery.of(context).size.width;
    double devHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.keyboard_backspace,
              size: 30.0,
              color: defaultGreen,
            ),
          ),
          title: Text('Book an Appointment', style: appBarTextStyle),
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 30.0, 0, 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        DropdownButton<Widget>(
                          value: ddItems[widget.package],
                          elevation: 16,
                          onChanged: (Widget newValue) {
                            setState(() {
                              widget.package = ddItems.indexOf(newValue);
                            });
                          },
                          items: ddItems
                              .map<DropdownMenuItem<Widget>>((Widget value) {
                            return DropdownMenuItem<Widget>(
                              value: value,
                              child: value,
                            );
                          }).toList(),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 15.0, 0, 0),
                          child: Text(
                            widget.consultation[widget.package].details,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontFamily: 'RobotoCondensedReg',
                              fontSize: 11,
                              fontWeight: FontWeight.normal,
                              color: cardGray,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Scheduled appointment',
                          style: TextStyle(
                            fontFamily: 'RobotoCondensedReg',
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: 50.0,
                            decoration: BoxDecoration(
                                color: defaultGreen,
                                borderRadius: BorderRadius.all(
                                    Radius.elliptical(100, 50))),
                            height: 25,
                            child: Center(
                              child: Text(
                                'edit',
                                style: TextStyle(
                                  fontFamily: 'RobotoCondensedReg',
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
                    child: Text(
                      '${widget.consultationTime} on ' +
                          DateFormat.E().format(widget.selectedDate) +
                          ', ' +
                          DateFormat.MMM().add_d().format(widget.selectedDate),
                      style: TextStyle(
                        fontFamily: 'RobotoCondensedReg',
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: timeGrid,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 40, 30, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Cost Breakdown',
                          style: TextStyle(
                            fontFamily: 'RobotoCondensedReg',
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 20, 30, 0),
                    child: Container(
                      width: double.infinity,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 0.0),
                                child: Text(
                                  '${widget.consultation[widget.package].name} Consultancy Package',
                                  style: dateTabTextStyle.copyWith(
                                      color: Colors.black),
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(top: 0.0),
                                  child: Text(
                                    '${widget.consultation[widget.package].price}',
                                    style: dateTabTextStyle.copyWith(
                                        color: Colors.black),
                                  )),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                  padding: EdgeInsets.only(top: 10.0),
                                  child: Text(
                                    'Extras',
                                    style: TextStyle(
                                      fontFamily: 'RobotoCondensedReg',
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black,
                                    ),
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(top: 10.0),
                                  child: Text(
                                    '40BD',
                                    style: TextStyle(
                                      fontFamily: 'RobotoCondensedReg',
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black,
                                    ),
                                  )),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                  padding: EdgeInsets.only(top: 10.0),
                                  child: Text(
                                    'Taxes',
                                    style: TextStyle(
                                      fontFamily: 'RobotoCondensedReg',
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black,
                                    ),
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(top: 10.0),
                                  child: Text(
                                    '40BD',
                                    style: TextStyle(
                                      fontFamily: 'RobotoCondensedReg',
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black,
                                    ),
                                  )),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                  padding: EdgeInsets.only(top: 10.0),
                                  child: Text(
                                    'Grand Total',
                                    style: TextStyle(
                                      fontFamily: 'RobotoCondensedReg',
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black,
                                    ),
                                  )),
                              Padding(
                                  padding:
                                      EdgeInsets.only(top: 10.0, left: 10.0),
                                  child: Text(
                                    '${int.parse(widget.consultation[widget.package].price.substring(0, 2)) + 80}BD',
                                    style: TextStyle(
                                      fontFamily: 'RobotoCondensedReg',
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black,
                                    ),
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(50, 50, 50, 0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50.0,
                      child: TextButton(
                        onPressed: () {
                          print('pressed');
                          _scaffoldKey.currentState.showSnackBar(
                              SnackBar(content: Text('To be implemented')));
                          /*Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()));*/
                        },
                        child: Text(
                          'BOOK PACKAGE',
                          style: TextStyle(
                            fontFamily: 'RobotoCondensedReg',
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                          ),
                        ),
                        style: TextButton.styleFrom(
                            backgroundColor: defaultGreen,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)))),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
