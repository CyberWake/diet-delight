import 'dart:ui';

import 'package:date_format/date_format.dart';
import 'package:diet_delight/Models/consultationModel.dart';
import 'package:diet_delight/Screens/Consultation/confirmConsultation.dart';
import 'package:diet_delight/Widgets/consultation_pop_up.dart';
import 'package:diet_delight/konstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:intl/intl.dart';
import 'package:diet_delight/Models/consultationAppointmentModel.dart';
import 'package:diet_delight/Models/consultationModel.dart';
import 'package:diet_delight/Screens/Consultation/bookConsultation.dart';
import 'package:diet_delight/Models/consultationPurchaseModel.dart';
import 'package:diet_delight/Screens/Consultation/prePaymentConsultation.dart';
import 'package:diet_delight/services/apiCalls.dart';

class SelectConsultationMode extends StatefulWidget {
  final int packageIndex;
  final List<ConsultationModel> consultation;

  SelectConsultationMode({this.packageIndex, this.consultation});
  @override
  _SelectConsultationModeState createState() => _SelectConsultationModeState();
}

class _SelectConsultationModeState extends State<SelectConsultationMode> {
  int consultationIndex;
  int selectedIndex;

  updateSelectedConsultation(int index) {
    setState(() {
      selectedIndex = index;
      consultationIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.packageIndex;
    consultationIndex = widget.packageIndex;
  }

  @override
  void didChangeDependencies() {
    precacheImage(selectConsultationBackgroundImage.image, context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var devWidth = MediaQuery.of(context).size.width;
    var devHeight = MediaQuery.of(context).size.height;

    return SafeArea(
        child: Container(
      decoration: BoxDecoration(
        image: selectConsultationBackgroundImage,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
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
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: devWidth * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Material(
                    elevation: 0,
                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    color: Colors.transparent,
                    child: Container(
                      height: devHeight * 0.18,
                      width: devWidth * 0.9,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(40.0)),
                        color: questionnaireDisabled.withOpacity(0.4),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: devWidth * 0.06,
                            vertical: devWidth * 0.04),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                '${widget.consultation[consultationIndex].name} Package',
                                style: consultationModeSelectStyle.copyWith(
                                  color: white,
                                )),
                            SizedBox(height: devWidth * 0.02),
                            Padding(
                              padding: EdgeInsets.only(left: devWidth * 0.03),
                              child: Text(
                                  '${widget.consultation[consultationIndex].subtitle}',
                                  style: consultationModeSelectStyle.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      color: white)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: devHeight * 0.075,
                  ),
                  Container(
                    color: questionnaireSelect.withOpacity(0.5),
                    height: 3.0,
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // SizedBox(
                  //   height: devHeight * 0.075,
                  // ),
                  GestureDetector(
                    onTap: () {
                      int consultationMode = 1;
                      ConsAppointmentModel appointment = ConsAppointmentModel(
                        userId: Api.userInfo.id,
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
                      print(consultationIndex);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PrePayment(
                                    appointment: appointment,
                                    orderDetails: purchaseDetails,
                                    package: consultationIndex,
                                    consultation: widget.consultation,
                                    consultationMode:
                                        consultationMode.toString(),
                                  )));
                    },
                    child: Material(
                      elevation: 2,
                      borderRadius: BorderRadius.all(Radius.circular(40.0)),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(40.0)),
                          color: onlineConsultation,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: devWidth * 0.06,
                              vertical: devWidth * 0.04),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Online Consultation',
                                  style: consultationModeSelectStyle),
                              SizedBox(height: devWidth * 0.02),
                              Padding(
                                padding: EdgeInsets.only(left: devWidth * 0.03),
                                child: Text(
                                    'Our consultant will get in touch with you via Whatsapp, Phone call or email. The consultation will happen via video conference.',
                                    style: consultationModeSelectStyle.copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal)),
                              ),
                              Align(
                                  alignment: Alignment.bottomRight,
                                  child: Icon(Icons.arrow_forward_ios_rounded,
                                      color: questionnaireDisabled, size: 26)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: devHeight * 0.05,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BookConsultation(
                                    packageIndex: consultationIndex,
                                    consultation: widget.consultation,
                                  )));
                    },
                    child: Material(
                      elevation: 2,
                      borderRadius: BorderRadius.all(Radius.circular(40.0)),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(40.0)),
                          color: offlineConsultation,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: devWidth * 0.06,
                              vertical: devWidth * 0.04),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Consultation at Clinic',
                                  style: consultationModeSelectStyle),
                              SizedBox(height: devWidth * 0.02),
                              Padding(
                                padding: EdgeInsets.only(left: devWidth * 0.03),
                                child: Text(
                                    'Consultation will happen in-person at our office. You can schedule the meeting and just walk-in to our clinic.',
                                    style: consultationModeSelectStyle.copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal)),
                              ),
                              Align(
                                  alignment: Alignment.bottomRight,
                                  child: Icon(Icons.arrow_forward_ios_rounded,
                                      color: questionnaireDisabled, size: 26)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
