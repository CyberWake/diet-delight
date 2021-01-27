import 'dart:ui';

import 'package:diet_delight/Models/consultationAppointmentModel.dart';
import 'package:diet_delight/Models/consultationModel.dart';
import 'package:diet_delight/Models/consultationPurchaseModel.dart';
import 'package:diet_delight/Screens/prepayment.dart';
import 'package:diet_delight/konstants.dart';
import 'package:diet_delight/services/apiCalls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
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
  Widget breakDownFields(String disc, String price, bool isGrandTotal) {
    return Row(
      mainAxisAlignment:
          isGrandTotal ? MainAxisAlignment.end : MainAxisAlignment.spaceBetween,
      children: [
        Padding(
            padding: isGrandTotal
                ? EdgeInsets.only(top: 10.0, right: 10)
                : EdgeInsets.only(top: 10.0),
            child: Text(
              disc,
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
              price,
              style: TextStyle(
                fontFamily: 'RobotoCondensedReg',
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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
                          breakDownFields(
                              '${widget.consultation[widget.package].name} Consultancy Package',
                              '${widget.consultation[widget.package].price}',
                              false),
                          breakDownFields('Extras', '- - USD', false),
                          breakDownFields('Taxes', '- - USD', false),
                          breakDownFields(
                              'Grand Total',
                              '${int.parse(widget.consultation[widget.package].price.substring(0, 2)) + 80} USD',
                              true),
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
                          var formatter = new DateFormat('yyyy-MM-dd');
                          DateTime time = DateFormat("hh:mma")
                              .parse(widget.consultationTime);
                          ConsAppointmentModel appointment =
                              ConsAppointmentModel(
                            userId: Api.userInfo.id,
                            consultationTime:
                                formatter.format(widget.selectedDate) +
                                    ' ' +
                                    DateFormat.Hms().format(time),
                          );
                          ConsPurchaseModel purchaseDetails = ConsPurchaseModel(
                              consultationName:
                                  widget.consultation[widget.package].name,
                              consultationPackageId: widget
                                  .consultation[widget.package].id
                                  .toString(),
                              consultationPackageDuration: widget
                                  .consultation[widget.package].duration
                                  .toString(),
                              amountPaid: widget
                                  .consultation[widget.package].price
                                  .toString());
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PrePayment(
                                        appointment: appointment,
                                        orderDetails: purchaseDetails,
                                      )));
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
