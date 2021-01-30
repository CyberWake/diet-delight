import 'package:diet_delight/Models/consultationAppointmentModel.dart';
import 'package:diet_delight/Models/consultationPurchaseModel.dart';
import 'package:diet_delight/konstants.dart';
import 'package:diet_delight/services/apiCalls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PrePayment extends StatefulWidget {
  final ConsAppointmentModel appointment;
  final ConsPurchaseModel orderDetails;
  PrePayment({this.orderDetails, this.appointment});
  @override
  _PrePaymentState createState() => _PrePaymentState();
}

class _PrePaymentState extends State<PrePayment> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Api _apiCall = Api.instance;
  ConsAppointmentModel _appointment;
  ConsPurchaseModel order;
  int consultationIndex = 0;
  @override
  void initState() {
    super.initState();
    order = widget.orderDetails;
    _appointment = widget.appointment;
  }


  AddressOverlay() {
    return StatefulBuilder(builder: (context, setState) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))), //this right here
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                child: Material(
                  borderRadius: BorderRadius.circular(3),
                  shadowColor: Color(0x26000000),
                  child: Container(
                    width: 250.0,
                    height: MediaQuery.of(context).size.height*0.05,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Color(0x26000000), blurRadius: 1),
                        ],
                        borderRadius: BorderRadius.circular(3)),
                    child: Padding(
                      padding: const EdgeInsets.only(left : 11.0),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<Widget>(
                          value: addressItems[consultationIndex],
                          elevation: 16,
                          onChanged: (Widget newValue) {
                            setState(() {
                              print(addressItems.indexOf(newValue));
                              consultationIndex = addressItems.indexOf(newValue);
                            });
                          },
                          items:
                          addressItems.map<DropdownMenuItem<Widget>>((Widget value) {
                            return DropdownMenuItem<Widget>(
                              value: value,
                              child: value,
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                child: Material(
                  borderRadius: BorderRadius.circular(3),
                  shadowColor: Color(0x26000000),
                  child: Container(
                    width: 250.0,
                    height: MediaQuery.of(context).size.height*0.05,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Color(0x26000000), blurRadius: 1),
                        ],
                        borderRadius: BorderRadius.circular(3)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      child: TextFormField(

                        style: TextStyle(
                          fontFamily: 'MontserratReg',
                        ),
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(3.0),
                          ),
                          hintText: 'House #, House name,Street name',
                          hintStyle: authLabelTextStyle.copyWith(color: Colors.black,fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                child: Material(
                  borderRadius: BorderRadius.circular(3),
                  shadowColor: Color(0x26000000),
                  child: Container(
                    width: 250.0,
                    height: MediaQuery.of(context).size.height*0.05,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Color(0x26000000), blurRadius: 1),
                        ],
                        borderRadius: BorderRadius.circular(3)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      child: TextFormField(

                        style: TextStyle(
                          fontFamily: 'MontserratReg',
                        ),
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(3.0),
                          ),
                          hintText: 'Area name',
                          hintStyle: authLabelTextStyle.copyWith(color: Colors.black,fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
SizedBox(height: 10,),
              Container(

                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.07,
                decoration: BoxDecoration(
                    color: defaultGreen,
                    boxShadow: [
                      BoxShadow(color: Color(0x26000000), blurRadius: 1),
                    ],
                    borderRadius: BorderRadius.circular(3)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: GestureDetector(
                    onTap: () {Navigator.pop(context);},
                    child: Center(child: Text("ADD",style: appBarTextStyle.copyWith(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),)),
                  ),
                ),
              ),

            ],
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: white,
        centerTitle: true,
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
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                'Billing Address',
                style: selectedTab.copyWith(fontStyle: FontStyle.italic),
              ),
            ),
            Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 0.1,
                      color: Colors.black.withOpacity(0.25),
                      spreadRadius: 0,
                      offset: const Offset(0.0, 0.0),
                    )
                  ],
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(width: 0.05, color: Colors.grey),
                  color: white),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Jane Doe',
                        style: selectedTab,
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AddressOverlay();
                              });
                        },
                        child: Text('Change',
                            style: unSelectedTab.copyWith(color: defaultGreen)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          '3 NewBridge Court\nChino Hills, CA 91709, United States',
                          style: unSelectedTab)
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 20.0,right: 35),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Payment',
                    style: selectedTab,
                  ),
                  Text('Change',
                      style: unSelectedTab.copyWith(color: defaultGreen)),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 0.1,
                      color: Colors.black.withOpacity(0.25),
                      spreadRadius: 0,
                      offset: const Offset(0.0, 0.0),
                    )
                  ],
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(width: 0.05, color: Colors.grey),
                  color: white),
              child: Column(
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 55,
                        width: 75,
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey)),
                        child: Image.asset(
                          'images/card.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                      Text('**** **** **** 3947', style: unSelectedTab),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0,top: 10),
              child: Text(
                'Cost breakdown',
                style: selectedTab.copyWith(),
              ),
            ),
            Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 0.1,
                      color: Colors.black.withOpacity(0.25),
                      spreadRadius: 0,
                      offset: const Offset(0.0, 0.0),
                    )
                  ],
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(width: 0.05, color: Colors.grey),
                  color: white),
              child: Column(
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Silver Consultancy Package",style: appBarTextStyle.copyWith(fontSize: 14,fontWeight: FontWeight.normal),),
                      Text("40 BD",style: appBarTextStyle.copyWith(fontSize: 14,fontWeight: FontWeight.normal),),
                    ],
                  ),
                  SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: 25,),
                      Text("First Appointment - 2pm, 22 Dec 2020",style: appBarTextStyle.copyWith(fontSize: 14,fontWeight: FontWeight.normal),),
                    ],
                  ),      SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Extras",style: appBarTextStyle.copyWith(fontSize: 14,fontWeight: FontWeight.normal),),
                      Text("40 BD",style: appBarTextStyle.copyWith(fontSize: 14,fontWeight: FontWeight.normal),),
                    ],
                  ),      SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Taxes",style: appBarTextStyle.copyWith(fontSize: 14,fontWeight: FontWeight.normal),),
                      Text("40 BD",style: appBarTextStyle.copyWith(fontSize: 14,fontWeight: FontWeight.normal),),
                    ],
                  ),      SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Grand Total  120 BD",style: appBarTextStyle.copyWith(fontSize: 14,fontWeight: FontWeight.normal),),
                  ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 50, 30, 30),
              child: SizedBox(
                width: double.infinity,
                height: 50.0,
                child: TextButton(
                  onPressed: () async {
                    print('pressed');
                    order.setUserPaymentDetails(
                        userId: Api.userInfo.id, paymentId: '11487');
                    String id = await _apiCall.postConsultationPurchase(order);
                    if (id != null) {
                      _appointment.putId(packagePurchaseId: id);
                      bool success =
                          await _apiCall.postAppointment(_appointment);
                      if (success) {
                        _scaffoldKey.currentState.showSnackBar(
                            SnackBar(content: Text('Appointment Added')));
                      }
                      _scaffoldKey.currentState.showSnackBar(
                          SnackBar(content: Text('Purchase Successful')));
                    } else {
                      _scaffoldKey.currentState.showSnackBar(
                          SnackBar(content: Text('Something went wrong')));
                    }
                  },
                  child: Text(
                    'Pay Now',
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
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
