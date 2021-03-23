import 'dart:core';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:diet_delight/Screens/export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  Widget item({String notifications, String des, String time, String date}) {
    return InkWell(
      onTap: () {},
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 22.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  margin: EdgeInsets.only(right: 20),
                  child: Material(
                    elevation: 2,
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    child: CachedNetworkImage(
                      imageUrl:
                          "https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
                      imageBuilder: (context, imageProvider) => Container(
                        height: MediaQuery.of(context).size.width * 0.2,
                        constraints: BoxConstraints(),
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) => SpinKitChasingDots(
                        color: defaultPurple,
                        size: 32,
                      ),
                      errorWidget: (context, url, error) => FlutterLogo(
                        size: 60,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 8,
                child: Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notifications,
                        style: appBarTextStyle.copyWith(
                            fontSize: 14, fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        des,
                        style: appBarTextStyle.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(144, 144, 144, 1)),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Container(
                        alignment: Alignment.bottomRight,
                        padding: EdgeInsets.only(right: 10),
                        child: Text(
                          DateFormat.yMMMMd('en_US')
                              .format(DateTime.now().toLocal())
                              .toString(),
                          style: appBarTextStyle.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color.fromRGBO(144, 144, 144, 1)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 18.0, left: 25, right: 20),
            child: item(
                notifications: "You won 1 Coupons",
                des: "You get 50% off on your next meal plan subscription"),
          ),
        ],
      ),
    );
  }
}
