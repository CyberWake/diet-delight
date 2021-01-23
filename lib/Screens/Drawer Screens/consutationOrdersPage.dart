import 'package:diet_delight/konstants.dart';
import 'package:flutter/material.dart';

class ConsultationOrderHistoryPage extends StatefulWidget {
  @override
  _ConsultationOrderHistoryPageState createState() =>
      _ConsultationOrderHistoryPageState();
}

class _ConsultationOrderHistoryPageState
    extends State<ConsultationOrderHistoryPage> {
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

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: List.generate(3, (index) {
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
                            fit: FlexFit.loose, child: Text('Consultation')),
                        Flexible(
                            fit: FlexFit.loose,
                            child: IconButton(
                                icon: Icon(Icons.more_vert), onPressed: () {})),
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
                fieldValue: '5pm, 12 Feb 2021',
              ),
              dataField(
                fieldName: 'Meeting Link:',
                fieldValue: 'meet.google.com....',
              ),
              dataField(
                fieldName: 'Consultant:',
                fieldValue: 'Mr. Bruh',
              ),
              Flexible(
                  fit: FlexFit.loose,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.schedule),
                        SizedBox(width: 10,),
                        Text('4:40pm 12 Jan, 2021'),
                        Spacer(),
                        Text('100 BHD')
                      ],
                    ),
                  )),
            ],
          ),
        );
      }),
    );
  }
}
