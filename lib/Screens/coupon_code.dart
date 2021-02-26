import 'package:diet_delight/Screens/export.dart';
import 'package:flutter/material.dart';
import 'package:ticketview/ticketview.dart';

class CouponCode extends StatefulWidget {
  CouponCode({Key key}) : super(key: key);

  @override
  _CouponCodeState createState() => _CouponCodeState();
}

class _CouponCodeState extends State<CouponCode> {
  List<bool> showCouponDetails = [false, false, false];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          backgroundColor: white,
          elevation: 0.0,
          title: Text(
            'APPLY COUPONS',
            style: TextStyle(color: Colors.black),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(children: [
          Flexible(
            flex: 2,
            fit: FlexFit.loose,
            child: Container(
              color: Colors.grey[200],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Material(
                    borderRadius: BorderRadius.circular(5.0),
                    shadowColor: Color(0x26000000),
                    elevation: 0,
                    color: Colors.grey[200],
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: white,
                        boxShadow: [
                          BoxShadow(color: Color(0x26000000), blurRadius: 5)
                        ],
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                      child: TextFormField(
                          onChanged: (value) {
                            print(value);
                          },
                          onFieldSubmitted: (done) {
                            print(done);
                          },
                          textAlignVertical: TextAlignVertical.center,
                          style: authInputTextStyle,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              suffixIcon: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical:
                                        MediaQuery.of(context).size.height *
                                            0.025),
                                child: InkWell(
                                  onTap: () {
                                    print('applying');
                                  },
                                  child: Text(
                                    'APPLY',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.deepOrangeAccent),
                                  ),
                                ),
                              ),
                              hintText: 'Enter Coupon Code')),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.05),
                    child: Text(
                      'AVAILABLE COUPONS',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              ),
            ),
          ),
          Flexible(
            flex: 8,
            fit: FlexFit.loose,
            child: Container(
              child: ListView.separated(
                  itemBuilder: (BuildContext context, int index) {
                    return couponCard(index);
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider(
                      thickness: 2.0,
                      color: Colors.grey[200],
                    );
                  },
                  itemCount: 3),
            ),
          ),
        ]));
  }

  Widget couponCard(int index) {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.39,
                height: 40,
                child: TicketView(
                  backgroundPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                  backgroundColor: white,
                  contentBackgroundColor: Colors.orange[100],
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                  drawArc: false,
                  triangleAxis: Axis.horizontal,
                  borderRadius: 1,
                  drawDivider: true,
                  drawShadow: false,
                  drawBorder: true,
                  dividerStrokeWidth: 1.0,
                  trianglePos: .275,
                  triangleSize: Size(10, 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FlutterLogo(
                        size: 30,
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Text(
                            'COUPONCODE',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  print('Hello');
                },
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'APPLY',
                    style: TextStyle(
                        color: Colors.deepOrangeAccent,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
          Text(
            'Coupon Code short description of it',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          Divider(
            thickness: 1.0,
            color: Colors.grey[200],
          ),
          Container(
            child: Text(
                'Descriptive details about the coupon code and how to redeem it for thr current purchase'),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
            child: InkWell(
                onTap: () {
                  setState(() {
                    showCouponDetails[index] = !showCouponDetails[index];
                  });
                  print(showCouponDetails[index]);
                },
                child: Text(
                  !showCouponDetails[index] ? '+ MORE' : '- LESS',
                  style: TextStyle(color: Colors.blue),
                )),
          ),
          showCouponDetails[index]
              ? Container(
                  height: 40,
                  margin: EdgeInsets.only(top: 10),
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: Text('Coupon Terms of use'),
                )
              : Container()
        ],
      ),
    );
  }
}
