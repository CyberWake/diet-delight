import 'package:flutter/material.dart';

import '../../konstants.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with SingleTickerProviderStateMixin {

  static TabController _pageController;
  static ScrollController _scrollController = new ScrollController();
  List<String> mainCategoryItems = [
    "Terms and Conditions",
    "FAQ",
    "Privacy Policy"
  ];

  var termsAndConditions = "\n\n\nDiet Delight Phone Apps\n\n\nTERMS & CONDITION\n\n\nThese Terms & Condition apply to the Diet Delight application including, without limitation, Diet Delight iOS app, Android app or web app (collectively, the ‘App”). As used in these Terms & Condition, ”Diet Delight” ,”us” or “we” refers to Diet Delight Restaurant WLL and its subsidiaries and affiliates.\n\n\nYOUR USED OF THE APP IS GOVERNED BY THESE TERMS & CONDITIONS\n\nBY ACCESSING OR OTHERWISE USING THE APP, YOU AGREE TO THESE TERMS & CONDITION IN THEIR ENTIRETY. Any person or entity who interacts with the Apps through the use of crawlers, robots, browsers, data mining or extraction tools or other functionality, whether such functionality is installed or placed by such person or entity or a third party, is deemed to be using the app and bound by these Terms & Condition. If at any time you do not accept all these Terms & Condition, you must immediately stop using all or any part of the App.\n\n\nONLINE ORDERING\n\nIf you placed and order through the App, you are responsible for ensuring that your order is correct and you have designated the proper address for delivery and or pick up details. You may only place order if you are at least 18 years old.\n\n\nGENERAL TERMS AND CONDITION\n\nIf you have completed the online sign up forms, this means you have agreed to our terms and conditions. We will not be able to accommodate you and we will unfortunately refuse you as a client if you: CANNOT EAT RAW FOOD CANNOT HAVE COOKED ONION AND GARLIC IN FOOD. CANNOT HAVE COOKED TOMATO OR TOMATO SAUCE ARE A CELIAC PATIENT OR HAVE SEVERE NUT ALLERGY (our kitchen is not gluten-free nor nut-free certified). An additional Bd per month is charged to your subscription in order to accommodate more than 3 intolerance, allergies or dislike CANCELLATION You may cancel your subscription up to 2 hours after the subscription has been placed in order to get refunded. After receiving the first delivery, you can pause your subscription and resume it at later date within six months of the subscription date. PRE-AUTHORIZATION IF YOU ARE PAYING BY CREDIT CARD, WE WILL PRE-AUTHORIZE YOUR CREDIT CARD TO VERIFY AVAILABILITY OF FUNDS, in either case, if the holder is modified prior to pick-pup or delivery, any overage will be charged to your credit card. DELIVERY POLICY We will attempt to deliver your order as soon as possible. We reserve the right not to deliver if outside designated delivery times; if outside our delivery zone: in inclement weather or dangerous driving condition: to minors; to customer on public establishment; or in those instances in which we believe our delivery would conflict with, compromise or affect our business. Take note that our delivery timings are in between 6 AM till 12 NOON daily, there will be no special delivery timing request. If we are unable to deliver your order because you provided an inaccurate address, you will be charged for your order. Even if we are unable to deliver your order. If you request that your order be left at your door or another location, you will be charged, and we will have no further liability for loss of product, spoilage, theft, infestation or damaged cause by others, for any delivery left in the specific location. If you request that your order be delivered to you personally and we are unable to locate you at the address provided, we will attempt to contact you by phone or SMS. If you are not at the designated location at the time of delivery and are unable to contact you, you will be charge for the day order. FOOD TEMPERATURE Upon receiving of your meal, we recommend to store it on temperature between 2 to 5 degree centigrade to maintained its freshness. MEAL SUBSCRIPTION SERVICE SUBCRIPTION We offer packages according to what is your requirements, from weekly or monthly subscription plan in which you will receive a specified number of meals each day. The fees for your subscription plan will depend on the number of meals you specify and will be shown on the order page. PRICES All prices shown on the App are subject to 5% government Tax and subject to change at any time without notice. The price available through the Apps reflects the price available at the current time. In your current market area, and supersedes any and all prior prices for any product or plan. We may offer promotional pricing, frequency discount, loyalty discount and other alternative pricing structure for some or all of our subscriptions plans to some or all of our customers from time to time in our discretion. We reserve the right to discontinue, or extend pricing in our discretion without any prior notice to you. PAYMENT When you registered for a subscription plan, you agree that Diet Delight or its third party payment processor is authorized to charge you for a subscription plan that you chose, In advance plus any taxes or other applicable charges, for as long as your subscription plan continues. All plans are continuous subscription plans and your subscription plan will continue until you pause it or we suspend or cancel your account. ALL PAYMENT WILL BE CHARGE AUTOMATICALLY THE DAY THE ORDER WAS BEEN SHIPPED. PAUSING AND CANCELLATION If you are a subscriber thru Mobile APPs or our Web Apps , you may pause or cancel your subscription plan,  To pause or cancel your subscription plan, choose the option provided in the APP or contact Diet Delight at info@dietdelightbh.com or thru WhatsApp 36999556 You are responsible for any meals order prior to the pausing or cancellation of your subscription meal plan. You acknowledge that, even after you have paused or cancelled your meal plan, or while your meal plan is suspended. REFUND POLICY If you are a subscriber thru APPs and you cancel your subscription, Diet Delight has no obligation to refund any amount paid prior to the time of cancellation. If you are a subscriber or you pre-order two(2) days ahead and you cancel your order on the day of the delivery. Diet Delight may, at its option, credit the amount of the order to you in Diet Delight Credits instead of crediting the amount of the order to your accounts. CANCELLATION, SKIPPING, RESCHEDULLING OR EDITING ORDERS You can pause your order, skip delivery, re schedule a delivery or edit your meals 48 hours any time prior to midday (12 NOON) one day before your meal plan schedule delivery. For example, if your meal plan was schedule to be deliver or received by Monday, you should cancel, skip, reschedule or edit any time prior to 11 :59 am SUNDAY. WEIGHT LOSS AND HEALTH CLAIMS Diet Delight provides information regarding its product for informational purposes only. Any weight loss and health result mentioned on the App, whether by Diet Delight or others, are not guaranteed.  Your result may vary considerably from those described through App. You expressly acknowledge that Diet Delight App does not make any express or implied claims or guarantees that you will achieve or maintain any specific results through your use of DD subscription service. Diet Delight does not refund any payments or agree to cancel your participation in a subscription plan based on your failure to achieve your desire result. DD subscription plans are not medically supervised. You should seek the advice of our clinical dietitian thru assessment before starting any dietary program to ensure it is suitable for your specific dietary needs. DD does not suggest or represent that any programs have been approved for your individual use by a physician or other medical professional, In addition, DD does not guarantee the accuracy, completeness or usefulness of any nutritional information of any subscription plan or adopt, endorse or accept responsibility for the accuracy , completeness or usefulness of any nutritional information regarding any subscription plan. DELIVERY AND HANDLING PROGRAM You agree to pay any extra delivery or handling charges shown at the time you make a purchase. We reserve the right to increase, decrease, add or eliminate delivery and handling charges from time to time. But we will provide notice to the charges applicable to you before you make your purchase. Once the meals are delivered to you, ownership and the risk of loss passes to you, following delivery, you and not DD, are solely responsible for the proper and safe preparation and storage of the meals. By ordering any of our meals, you agree to use our meals at your own risk. RIGHTS All title, right, content and interest in our App, including but not limited to copyrights, trade secrets, patent, and other proprietary rights, and any derivative works, shall belong exclusively to Diet Delight or its licensors. Nothing in this terms and condition or otherwise will be deemed to grant to you an ownership interest in the App, in whole or in part. All content included in the App, such as food photo, photo of any sort, meal program, recipe, plans, guide, logos, text ,button icon, audio clips, video clips of any sort, data , music, software and other related materials (known as CONTENT) is owned and licensed property of Diet Delight or its licensors and its protected by copyright, trademark and patent technologies. ACCESS & LICENSE Diet Delight Apps grants you a limited access and make personal use of the App and the content for Non-Commercial purpose only and only to the extent such use does not violates these Terms and condition. TRADEMARK AND COPY RIGHT INFORMATION All content included or available on this site, including text, site design, graphics, videos, interfaces, and the selection of pictures and arrangement is owned by us. Any use of materials on the website, including replicating, reproducing, republishing, downloading, posting, broadcasting, distributing, modifying, any form of data mining or data extraction, or other commercial exploitation of any kind, without prior written permission of an authorized officer of Diet Delight WLL is strictly prohibited. User agree that they will not use any automatic device or manual process to monitor or copy our web pages or the content contained therein.";

  static var faqQuestions = [
    "Not able to place order",
    "Not able to place order",
    "Not able to place order",
    "Not able to place order",
    "Not able to place order",
  ];

  static var faqAnswers = [
    "Contact the provided phone number or try placing an order after some time.",
    "Contact the provided phone number or try placing an order after some time.",
    "Contact the provided phone number or try placing an order after some time.",
    "Contact the provided phone number or try placing an order after some time.",
    "Contact the provided phone number or try placing an order after some time.",
  ];

  Widget fAQs = ListView.builder(
      controller: _scrollController,
      itemCount: faqAnswers.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.only(left : 28.0,right: 20),
          child: ExpansionTile(
            onExpansionChanged: (bool expanded) {
            },
            initiallyExpanded: index == 0 ? true : false,
            tilePadding: EdgeInsets.only(left : 0,bottom: 0),
            title: Text(faqQuestions[index],
                style: pageViewTabSelected.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black)),
            childrenPadding:  EdgeInsets.only(left : 0,bottom: 10),
            children:
            List.generate(1, (int index) {
              return Text(
                faqAnswers[index],
                style: pageViewTabUnSelected,
              );
            }),
          ),
        );
      });

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = TabController(length: 3, vsync: this);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
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
              child: TabBar(
                controller: _pageController,
                isScrollable: true,
                onTap: (index) async {},
                labelStyle: pageViewTabSelected,
                indicatorColor: Colors.transparent,
                indicatorWeight: 3.0,
                indicatorSize: TabBarIndicatorSize.label,
                labelColor: Colors.black,
                labelPadding: EdgeInsets.symmetric(horizontal: 35),
                unselectedLabelStyle: pageViewTabUnSelected,
                unselectedLabelColor: Colors.grey,
                tabs:
                List.generate(3, (index) {
                  return Tab(
                    text: mainCategoryItems[index],
                  );
                }),
              ),
            ),
          ),
          Expanded(
            flex: 9,
            child: TabBarView(
                controller: _pageController,
                children:
                List.generate(3, (index) {
                  return index == 0 ?
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal : 25.0),
                    child: Container(child: ListView(
                      children: [
                        Text(termsAndConditions,style: appBarTextStyle,),
                      ],
                    ),),
                  )
                      : fAQs ;

                })),
          )
        ],
      ),
    );
  }
}
