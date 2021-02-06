import 'package:date_format/date_format.dart';
import 'package:diet_delight/Models/consultationAppointmentModel.dart';
import 'package:diet_delight/Models/consultationModel.dart';
import 'package:diet_delight/Models/consultationPurchaseModel.dart';
import 'package:diet_delight/Screens/Consultation/bookConsultation.dart';
import 'package:diet_delight/konstants.dart';
import 'package:diet_delight/services/apiCalls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ConsultationOrderHistoryPage extends StatefulWidget {
  @override
  _ConsultationOrderHistoryPageState createState() =>
      _ConsultationOrderHistoryPageState();
}

class _ConsultationOrderHistoryPageState
    extends State<ConsultationOrderHistoryPage> {
  Api _apiCall = Api.instance;
  List<ConsPurchaseModel> consultationPurchases = List();
  List<ConsultationModel> consultationData = List();
  List<ConsAppointmentModel> appointments = List();
  bool loaded = false;
  List<String> format = [hh, ':', nn, ' ', am, '\n', dd, ' ', 'M', ', ', yyyy];

  Widget dataField({String fieldName, String fieldValue}) {
    return Flexible(
        fit: FlexFit.loose,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(flex: 2, child: Text(fieldName)),
              Expanded(child: Container()),
              Expanded(flex: 3, child: Text(fieldValue)),
              Expanded(child: Container())
            ],
          ),
        ));
  }

  getData() async {
    consultationPurchases = await _apiCall.getConsultationPurchases();
    appointments = await _apiCall.getAppointments();
    for (int i = 0; i < consultationPurchases.length;) {
      consultationData.add(await _apiCall
          .getConsultationData(consultationPurchases[i].consultationPackageId)
          .whenComplete(() {
        i++;
        if (i == consultationPurchases.length) {
          if (mounted) {
            setState(() {
              loaded = true;
            });
          }
        }
      }));
    }
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      getData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return loaded
        ? ListView(
            shrinkWrap: true,
            children: List.generate(appointments.length, (index) {
              String name = (consultationData[index].name).toString();
              DateTime createdDateTime =
                  DateTime.parse(appointments[index].createdAt);
              DateTime appointmentDateTime =
                  DateTime.parse(appointments[index].consultationTime);
              int packageIndex = name.contains("SILVER")
                  ? 0
                  : name.contains("GOLD")
                      ? 2
                      : 1;
              return Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                decoration: BoxDecoration(
                  color: white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 4,
                      color: Colors.black.withOpacity(0.25),
                      spreadRadius: 0,
                      offset: const Offset(0.0, 0.0),
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                        fit: FlexFit.loose,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                  fit: FlexFit.loose,
                                  child: Text('Consultation')),
                              Flexible(
                                  fit: FlexFit.loose,
                                  child: FlatButton(
                                      child: Text(
                                        "Re-Buy",
                                        style: selectedTab.copyWith(
                                            color: Colors.green),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        BookConsultation(
                                                          packageIndex:
                                                              packageIndex,
                                                          consultation:
                                                              consultationData,
                                                        )));
                                      })),
                            ],
                          ),
                        )),
                    Flexible(
                        fit: FlexFit.loose,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                              Text((consultationData[index].name).toString()),
                        )),
                    dataField(
                      fieldName: 'Appointment:',
                      fieldValue: formatDate(appointmentDateTime, format),
                    ),
                    dataField(
                      fieldName: 'Meeting Link:',
                      fieldValue: 'meet.google.com....',
                    ),
                    dataField(
                      fieldName: 'Consultant:',
                      fieldValue: appointments[index].consultantName,
                    ),
                    Flexible(
                        fit: FlexFit.loose,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.schedule),
                              SizedBox(
                                width: 10,
                              ),
                              Text(formatDate(createdDateTime, format)),
                              Spacer(),
                              Text(consultationPurchases[index].amountPaid +
                                  ' BHD')
                            ],
                          ),
                        )),
                  ],
                ),
              );
            }),
          )
        : Center(child: CircularProgressIndicator());
  }
}
