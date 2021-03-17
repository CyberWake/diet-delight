import 'package:date_format/date_format.dart';
import 'package:diet_delight/Models/mealModel.dart';
import 'package:diet_delight/Models/mealPurchaseModel.dart';
import 'package:diet_delight/Screens/MealPlans/mealSubscriptionPage.dart';
import 'package:diet_delight/konstants.dart';
import 'package:diet_delight/services/apiCalls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:isolate';
import 'dart:io';
import 'dart:ui';
import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MealPlanOrderHistoryPage extends StatefulWidget {
  @override
  _MealPlanOrderHistoryPageState createState() =>
      _MealPlanOrderHistoryPageState();
}

class _MealPlanOrderHistoryPageState extends State<MealPlanOrderHistoryPage> {
  List<MealPurchaseModel> purchasedMeal;
  final _apiCall = Api.instance;
  bool loaded = false;
  List<String> format = [hh, ':', nn, ' ', am, ' ', dd, ' ', 'M', ', ', yyyy];
  ReceivePort _port = ReceivePort();
  bool _permissionReady = false;
  var listOfAvailableDays = [];

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Text(fieldName, style: orderHistoryCardStyle)),
              Expanded(child: Text(fieldValue, style: orderHistoryCardStyle)),
            ],
          ),
        ));
  }

  Widget daysField({String fieldName, String fieldValue1, String fieldValue2}) {
    return Flexible(
        fit: FlexFit.loose,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Text(fieldName, style: orderHistoryCardStyle)),
              Expanded(
                  child: RichText(
                text: TextSpan(children: <TextSpan>[
                  TextSpan(
                      text: fieldValue1 + '\n', style: orderHistoryCardStyle),
                  TextSpan(
                      text: fieldValue2,
                      style: orderHistoryCardStyle.copyWith(
                          fontSize: 12, color: Color(0xFFC6C6C6))),
                ]),
              ))
//              Column(
//                mainAxisAlignment: MainAxisAlignment.start,
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: [
//                  Expanded(
//                      child: Text(fieldValue1, style: orderHistoryCardStyle)),
//                  Expanded(
//                      child: Text(fieldValue2,
//                          style: orderHistoryCardStyle.copyWith(
//                              color: Color(0xFFC6C6C6)))),
//                ],
//              ),
            ],
          ),
        ));
  }

  getPrimaryAndSecondaryWithBreak(
      {breaks, primaryList, secondaryList, purchaseDetails}) {
    if (purchaseDetails.weekdays.contains('Sun')) {
      listOfAvailableDays.add('Sunday');
    }
    if (purchaseDetails.weekdays.contains('Mon')) {
      listOfAvailableDays.add('Monday');
    }
    if (purchaseDetails.weekdays.contains('Tue')) {
      listOfAvailableDays.add('Tuesday');
    }
    if (purchaseDetails.weekdays.contains('Wed')) {
      listOfAvailableDays.add('Wednesday');
    }
    if (purchaseDetails.weekdays.contains('Thur')) {
      listOfAvailableDays.add('Thursday');
    }
    if (purchaseDetails.weekdays.contains('Fri')) {
      listOfAvailableDays.add('Friday');
    }
    if (purchaseDetails.weekdays.contains('Sat')) {
      listOfAvailableDays.add('Saturday');
    }
    print(listOfAvailableDays);

    print('with break called');

    print(breaks);

    DateTime endDate = DateTime.parse(purchaseDetails.endDate);

    DateTime startDate = DateTime.parse(purchaseDetails.startDate);

    var totalDays = [];
    print(breaks.length);
    for (int i = 0;
        i <= endDate.difference(startDate).inDays + breaks.length;
        i++) {
      if (listOfAvailableDays.contains(
          DateFormat('EEEE').format(startDate.add(Duration(days: i))))) {
        totalDays
            .add(startDate.add(Duration(days: i)).toString().split(" ")[0]);
      }
    }

    var primaryAndSecondary = [];
    print("||||||||||||||");
    print(breaks.length);
    print(primaryList);
    print(totalDays);
    primaryAndSecondary.add(primaryList);
    primaryAndSecondary.add(secondaryList);
    primaryAndSecondary.add(totalDays);
    return primaryAndSecondary;
  }

  getRemainingDays(var purchaseId) async {
    var resource = await _apiCall.getBreakTakenDay();
    var res = {};
    setState(() {
      loaded = false;
    });
    int count = 0;
    for (int i = 0; i < resource.length; i++) {
      if (resource[i]['meal_purchase_id'].toString() == purchaseId.toString()) {
        res = resource[i];
      }
    }
    print('printing res');
    print(res);
    var primaryAndSecondary = await getPrimaryAndSecondaryWithBreak(
        breaks: jsonDecode(res['date_list']),
        primaryList: jsonDecode(res['primary_address_dates']),
        secondaryList: jsonDecode(res['secondary_address_dates']));
  }

  getData() async {
    purchasedMeal = await _apiCall.getMealPurchases().whenComplete(() {
      if (mounted) {
        setState(() {
          loaded = true;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
    });
    if (mounted) {
      getData();
    }
    FlutterDownloader.registerCallback(downloadCallback);
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
        ? purchasedMeal.length == 0
            ? Center(
                child: Material(
                  elevation: 0.0,
                  color: Colors.transparent,
                  child: Container(
                    margin: EdgeInsets.all(15),
                    padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4,
                          color: Colors.black.withOpacity(0.25),
                          spreadRadius: 0,
                          offset: const Offset(0.0, 0.0),
                        )
                      ],
                    ),
                    child: Center(
                      child: Text(
                          'No Meal Plan Subscriptions have been purchased yet',
                          style: nullSafetyStyle),
                    ),
                  ),
                ),
              )
            : ListView(
                shrinkWrap: true,
                children: List.generate(purchasedMeal.length, (index) {
                  return Material(
                    elevation: 0.0,
                    color: Colors.transparent,
                    child: Container(
//                height: MediaQuery.of(context).size.height * 0.25,
                      margin: EdgeInsets.all(15),
                      padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                      decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
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
                                padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(purchasedMeal[index].mealPlanName,
                                        style: orderHistoryCardStyle.copyWith(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 15)),
                                    PopupMenuButton<int>(
                                      child: Icon(Icons.more_vert,
                                          color: questionnaireDisabled),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0))),
                                      itemBuilder: (BuildContext context) =>
                                          <PopupMenuEntry<int>>[
                                        PopupMenuItem<int>(
                                          value: 0,
                                          child: Material(
                                            color: Colors.white,
                                            child: ListTile(
                                              onTap: () async {
                                                MealModel getMealPackage =
                                                    await _apiCall.getMealPlan(
                                                        purchasedMeal[index]
                                                            .mealPlanId);
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            MealSubscriptionPage(
                                                              weekDaysSelected:
                                                                  purchasedMeal[
                                                                          index]
                                                                      .weekdays
                                                                      .length,
                                                              mealPackage:
                                                                  getMealPackage,
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
//                                         PopupMenuItem<int>(
//                                           value: 1,
//                                           child: Material(
//                                             color: Colors.white,
//                                             child: ListTile(
//                                               onTap: () async {
//                                                 await DownloadFile(
//                                                     'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
//                                                     'Dummy PDF.pdf');
//                                                 Navigator.pop(context);
//                                               },
//                                               leading: Icon(
//                                                 Icons.file_download,
//                                                 size: 24,
//                                                 color: Colors.black,
//                                               ),
// //                                            new Image.asset(
// //                                                "images/download_invoice.png",
// //                                                width: 20),
//                                               title: Text(
//                                                 'Download Invoice',
//                                                 style: orderHistoryPopUpStyle,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
                                      ],
                                    ),
                                  ],
                                ),
                              )),
                          daysField(
                            fieldName: 'Subscription:',
                            fieldValue1:
                                purchasedMeal[index].mealPlanDuration + ' Days',
                            fieldValue2: purchasedMeal[index].showWeek(),
                          ),
                          dataField(
                            fieldName: 'Remaining Days:',
                            fieldValue: '12',
                          ),
                          Flexible(
                              fit: FlexFit.loose,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(Icons.schedule,
                                        size: 16, color: timeGrid),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                        formatDate(
                                            DateTime.parse(
                                                purchasedMeal[index].createdAt),
                                            format),
                                        style: orderHistoryCardStyle.copyWith(
                                            fontSize: 12, color: timeGrid)),
                                    Spacer(),
                                    Text(
                                        purchasedMeal[index].amountPaid +
                                            ' BHD',
                                        style: orderHistoryCardStyle.copyWith(
                                          color: defaultGreen,
                                          fontWeight: FontWeight.w600,
                                        ))
                                  ],
                                ),
                              ))
                        ],
                      ),
                    ),
                  );
                }),
              )
        : Center(
            child: SpinKitThreeBounce(
              color: defaultPurple,
              size: 32,
            ),
          );
  }
}
