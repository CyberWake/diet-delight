import 'package:date_format/date_format.dart';
import 'package:diet_delight/Models/consultationAppointmentModel.dart';
import 'package:diet_delight/Models/consultationPurchaseModel.dart';
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
  List<ConsPurchaseModel> consultationPurchases;
  List<ConsAppointmentModel> appointments;
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
    print('called');
    appointments =
        await _apiCall.getAppointments().whenComplete(() => setState(() {
              loaded = true;
            }));
    print('here');
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return loaded
        ? ListView(
            shrinkWrap: true,
            children: List.generate(appointments.length, (index) {
              DateTime createdDateTime =
                  DateTime.parse(appointments[index].createdAt);
              DateTime appointmentDateTime =
                  DateTime.parse(appointments[index].consultationTime);

              print(createdDateTime);
              print(appointmentDateTime);
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
                                  child: IconButton(
                                      icon: Icon(Icons.more_vert),
                                      onPressed: () {})),
                            ],
                          ),
                        )),
                    Flexible(
                        fit: FlexFit.loose,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Consultation Package Name'),
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
                              Text('100 BHD')
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
