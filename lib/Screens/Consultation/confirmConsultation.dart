import 'dart:ui';
import 'package:diet_delight/Models/export_models.dart';
import 'package:diet_delight/Screens/export.dart';
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
  int consultationIndex;
  int selectedIndex;

  updateSelectedConsultation(int index) {
    setState(() {
      selectedIndex = index;
      consultationIndex = index;
    });
  }

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
  void initState() {
    super.initState();
    selectedIndex = widget.package;
    consultationIndex = widget.package;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          centerTitle: false,
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
        body: Padding(
          padding: const EdgeInsets.fromLTRB(0, 30.0, 0, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    TextButton(
                      child: ddItems[consultationIndex],
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                ConsultationPopUp(
                                  selectedIndex: selectedIndex,
                                  callBackFunction: updateSelectedConsultation,
                                ));
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 15.0, 0, 0),
                      child: Text(
                        widget.consultation[consultationIndex].details,
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
              Material(
                borderRadius: BorderRadius.circular(5.0),
                shadowColor: Color(0x26000000),
                elevation: 0,
                color: Colors.white,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(color: Color(0x26000000), blurRadius: 5)
                      ],
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.white),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Scheduled Appointment',
                            style: TextStyle(
                              fontFamily: 'RobotoCondensedReg',
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text('edit',
                                style: billingTextStyle.copyWith(
                                    fontSize: 14, color: defaultGreen)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.consultationTime} on ' +
                                  DateFormat.E().format(widget.selectedDate) +
                                  ', ' +
                                  DateFormat.MMM()
                                      .add_d()
                                      .format(widget.selectedDate),
                              style: TextStyle(
                                fontFamily: 'RobotoCondensedReg',
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: timeGrid,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
//              Padding(
//                padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.start,
//                  children: [
//                    Text(
//                      'Scheduled Appointment',
//                      style: TextStyle(
//                        fontFamily: 'RobotoCondensedReg',
//                        fontSize: 20,
//                        fontWeight: FontWeight.normal,
//                        color: Colors.black,
//                      ),
//                    ),
//                    SizedBox(
//                      width: 10.0,
//                    ),
//                    GestureDetector(
//                      onTap: () {
//                        Navigator.pop(context);
//                      },
//                      child: Container(
//                        width: 50.0,
//                        decoration: BoxDecoration(
//                            color: defaultGreen,
//                            borderRadius:
//                                BorderRadius.all(Radius.elliptical(100, 50))),
//                        height: 25,
//                        child: Center(
//                          child: Text(
//                            'edit',
//                            style: TextStyle(
//                              fontFamily: 'RobotoCondensedReg',
//                              fontSize: 12,
//                              fontWeight: FontWeight.normal,
//                              color: Colors.white,
//                            ),
//                          ),
//                        ),
//                      ),
//                    ),
//                  ],
//                ),
//              ),
//              Padding(
//                padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
//                child: Text(
//                  '${widget.consultationTime} on ' +
//                      DateFormat.E().format(widget.selectedDate) +
//                      ', ' +
//                      DateFormat.MMM().add_d().format(widget.selectedDate),
//                  style: TextStyle(
//                    fontFamily: 'RobotoCondensedReg',
//                    fontSize: 20,
//                    fontWeight: FontWeight.normal,
//                    color: timeGrid,
//                  ),
//                ),
//              ),
              Material(
                borderRadius: BorderRadius.circular(5.0),
                shadowColor: Color(0x26000000),
                elevation: 0,
                color: Colors.white,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(color: Color(0x26000000), blurRadius: 5)
                      ],
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.white),
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Cost Breakdown',
                          style: TextStyle(
                            fontFamily: 'RobotoCondensedReg',
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Container(
                        width: double.infinity,
                        child: Column(
                          children: [
                            breakDownFields(
                                '${widget.consultation[consultationIndex].name} Consultancy Package',
                                '${widget.consultation[consultationIndex].price} BHD',
                                false),
                            breakDownFields('Extras', '- - BHD', false),
                            breakDownFields('Taxes', '- - BHD', false),
                            breakDownFields(
                                'Grand Total',
                                '${int.parse(widget.consultation[consultationIndex].price.substring(0, 2)) + 80} BHD',
                                true),
                          ],
                        ),
                      ),
                    ),
                  ]),
                ),
              ),

              Spacer(),
              Padding(
                padding: const EdgeInsets.fromLTRB(50, 50, 50, 30),
                child: SizedBox(
                  width: double.infinity,
                  height: 40.0,
                  child: TextButton(
                    onPressed: () {
                      print('pressed');
                      var formatter = new DateFormat('yyyy-MM-dd');
                      DateTime time =
                          DateFormat("hh:mm a").parse(widget.consultationTime);
                      ConsAppointmentModel appointment = ConsAppointmentModel(
                        userId: Api.userInfo.id,
                        consultationTime:
                            formatter.format(widget.selectedDate) +
                                ' ' +
                                DateFormat.Hms().format(time),
                      );
                      ConsPurchaseModel purchaseDetails = ConsPurchaseModel(
                          consultationName:
                              widget.consultation[consultationIndex].name,
                          consultationPackageId: widget
                              .consultation[consultationIndex].id
                              .toString(),
                          consultationPackageDuration: widget
                              .consultation[consultationIndex].duration
                              .toString(),
                          amountPaid: widget
                              .consultation[consultationIndex].price
                              .toString());
                      print(purchaseDetails.consultationPackageId);
                      print(widget.package);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PrePayment(
                                    appointment: appointment,
                                    orderDetails: purchaseDetails,
                                  )));
                    },
                    child: Text(
                      'PAY ONLINE',
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
      ),
    );
  }
}
