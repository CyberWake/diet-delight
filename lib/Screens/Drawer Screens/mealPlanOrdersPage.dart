import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:date_format/date_format.dart';
import 'package:diet_delight/Models/mealModel.dart';
import 'package:diet_delight/Models/mealPurchaseModel.dart';
import 'package:diet_delight/Screens/MealPlans/mealSubscriptionPage.dart';
import 'package:diet_delight/konstants.dart';
import 'package:diet_delight/services/apiCalls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class MealPlanOrderHistoryPage extends StatefulWidget {
  @override
  _MealPlanOrderHistoryPageState createState() =>
      _MealPlanOrderHistoryPageState();
}

class _MealPlanOrderHistoryPageState extends State<MealPlanOrderHistoryPage> {
  List<MealPurchaseModel> purchasedMeal;
  final _apiCall = Api.instance;
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Text(fieldName, style: orderHistoryCardStyle)),
              Expanded(child: Text(fieldValue, style: orderHistoryCardStyle)),
            ],
          ),
        ));
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
            ? Center(child: Text('No Consultation Purchase Available'))
            : ListView(
                shrinkWrap: true,
                children: List.generate(purchasedMeal.length, (index) {
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: Text(
                                        purchasedMeal[index].mealPlanName,
                                        style: orderHistoryCardStyle.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14)),
                                  ),
                                  Flexible(
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
                          fieldName: 'Subscription:',
                          fieldValue: purchasedMeal[index].mealPlanDuration +
                              ' Days\n' +
                              purchasedMeal[index].showWeek(),
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
                                  Icon(Icons.schedule),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                      formatDate(
                                          DateTime.parse(
                                              purchasedMeal[index].createdAt),
                                          format),
                                      style: orderHistoryCardStyle),
                                  Spacer(),
                                  Text(purchasedMeal[index].amountPaid + ' BHD',
                                      style: orderHistoryCardStyle)
                                ],
                              ),
                            ))
                      ],
                    ),
                  );
                }),
              )
        : Center(child: SpinKitDoubleBounce(color: defaultGreen));
  }
}
