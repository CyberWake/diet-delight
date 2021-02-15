import 'dart:convert';
import 'dart:ui';
import 'dart:io';
import 'package:intl/intl.dart';
import 'dart:isolate';
import 'package:date_format/date_format.dart';
import 'package:diet_delight/Models/consultationAppointmentModel.dart';
import 'package:diet_delight/Models/consultationModel.dart';
import 'package:diet_delight/Models/consultationPurchaseModel.dart';
import 'package:diet_delight/Screens/Consultation/bookConsultation.dart';
import 'package:diet_delight/konstants.dart';
import 'package:diet_delight/services/apiCalls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

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
  ReceivePort _port = ReceivePort();
  bool _permissionReady = false;

  Future<void> DownloadFile(String key, String fileName) async {
    _permissionReady = await _checkPermission();
    _checkPermission().then((hasGranted) {
      setState(() {
        _permissionReady = hasGranted;
      });
    });
    String downloadUrl1 = key;
    Directory appDocDir = await getExternalStorageDirectory();
    String appDocPath = appDocDir.path;
    print(key);
    print(downloadUrl1);
    print(appDocPath);

    final taskId = await FlutterDownloader.enqueue(
      url: downloadUrl1,
      fileName: fileName,
      savedDir: appDocPath,
      showNotification:
          true, // show download progress in status bar (for Android)
      openFileFromNotification:
          true, // click on notification to open downloaded file (for Android)
    );
  }

  Widget dataField({String fieldName, String fieldValue}) {
    return Flexible(
        fit: FlexFit.loose,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  flex: 2,
                  child: Text(fieldName, style: orderHistoryCardStyle)),
              Expanded(child: Container()),
              Expanded(
                  flex: 3,
                  child: Text(fieldValue, style: orderHistoryCardStyle)),
              Expanded(child: Container())
            ],
          ),
        ));
  }

  Widget meetingDataField({String fieldName, String fieldValue}) {
    return Flexible(
        fit: FlexFit.loose,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  flex: 2,
                  child: Text(fieldName, style: orderHistoryCardStyle)),
              Expanded(child: Container()),
              Expanded(
                  flex: 3,
                  child: GestureDetector(
                      onTap: () async {
                        if (await canLaunch(fieldValue)) {
                          await launch(fieldValue);
                        } else {
                          throw 'Could not launch $fieldName';
                        }
                      },
                      child: Text(
                        fieldValue,
                        style:
                            orderHistoryCardStyle.copyWith(color: defaultGreen),
                      ))),
              Expanded(child: Container())
            ],
          ),
        ));
  }

  getData() async {
    consultationPurchases = await _apiCall.getConsultationPurchases();
    appointments = await _apiCall.getConsultationAppointments();
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
    /*IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
    });*/
    if (mounted) {
      getData();
    }
    //FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  Future<bool> _checkPermission() async {
    if (Theme.of(context).platform == TargetPlatform.android) {
      PermissionStatus permission = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage);
      if (permission != PermissionStatus.granted) {
        Map<PermissionGroup, PermissionStatus> permissions =
            await PermissionHandler()
                .requestPermissions([PermissionGroup.storage]);
        if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
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
                                  child: Text(
                                      (consultationData[index].name)
                                              .toString() +
                                          ' Consultation Package',
                                      style: orderHistoryCardStyle.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14))),
                              Flexible(
                                  fit: FlexFit.loose,
                                  child: PopupMenuButton<int>(
                                    child: Icon(Icons.more_vert,
                                        color: Colors.black),
                                    itemBuilder: (BuildContext context) =>
                                        <PopupMenuEntry<int>>[
                                      PopupMenuItem<int>(
                                        value: 0,
                                        child: Material(
                                          color: Colors.white,
                                          child: ListTile(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          BookConsultation(
                                                            packageIndex:
                                                                packageIndex,
                                                            consultation:
                                                                consultationData,
                                                          )));
                                            },
                                            leading: Icon(
                                              Icons.autorenew,
                                              size: 24,
                                              color: Colors.black,
                                            ),
//                                            new Image.asset(
//                                              "images/renew-purchase.svg",
//                                              width: 30,
//                                              height: 30,
//                                            ),
                                            title: Text(
                                              'Renew Purchase',
                                              style: orderHistoryPopUpStyle,
                                            ),
                                          ),
                                        ),
                                      ),
                                      PopupMenuItem<int>(
                                        value: 1,
                                        child: Material(
                                          color: Colors.white,
                                          child: ListTile(
                                            onTap: () async {
                                              await DownloadFile(
                                                  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
                                                  'Dummy PDF.pdf');
                                              Navigator.pop(context);
                                            },
                                            leading: Icon(
                                              Icons.file_download,
                                              size: 24,
                                              color: Colors.black,
                                            ),
//                                            new Image.asset(
//                                                "images/download_invoice.png",
//                                                width: 20),
                                            title: Text(
                                              'Download Invoice',
                                              style: orderHistoryPopUpStyle,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        )),
                    dataField(
                      fieldName: 'Appointment:',
                      fieldValue: formatDate(appointmentDateTime, format),
                    ),
                    meetingDataField(
                      fieldName: 'Meeting Link:',
                      fieldValue: 'https://www.google.com',
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
                              Text(formatDate(createdDateTime, format),
                                  style: orderHistoryCardStyle),
                              Spacer(),
                              Text(
                                  consultationPurchases[index].amountPaid +
                                      ' BHD',
                                  style: orderHistoryCardStyle)
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
