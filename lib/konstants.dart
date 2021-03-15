import 'package:diet_delight/services/apiCalls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const Color defaultGreen = Color(0xFF8BC53F);
const Color blurredDefaultGreen = Color.fromRGBO(255, 255, 255, 0.8);
const Color darkGreen = Color(0xFF079404);
const Color inactiveGreen = Color(0x808BC53F);
const Color white = Color(0xFFFFFFFF);
const Color formBackground = Color(0x8DFFFFFF);
const Color formFill = Color(0xFF808080);
const Color formLinks = Color(0xFF999999);
const fColor = Color(0xFF3C589A);
const gColor = Color(0xFFDD4B38);
const Color defaultPurple = Color(0xFF78288B);
const Color inactivePurple = Color(0x8078288B);
const Color cardGray = Color(0xFF666666);
const Color timeGrid = Color(0xFF303030);
const Color inactiveTime = Color(0xFF909090);
const Color questionnaireDecor = Color(0xFFE5E5E5);
const Color questionnaireSelect = Color(0xFF303960);
const Color questionnaireDisabled = Color(0xFF77838F);
const Color commentChange = Color(0xFFFFFDFD);
const Color paymentSeparator = Color(0xFFDADADA);
const Color featuredColor = Color(0xFFE96E25);
const Color disabledAddress = Color(0xFF4E4848);
const Color onlineConsultation = Color(0xFFFFC2C2);
const Color offlineConsultation = Color(0xFFC2DBFF);
const Color paymentMethodText = Color(0xFF404040);

InputDecoration authInputFieldDecoration = InputDecoration(
  fillColor: Colors.white,
  focusedBorder: InputBorder.none,
  enabledBorder: InputBorder.none,
  errorBorder: InputBorder.none,
  disabledBorder: InputBorder.none,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(3.0),
  ),
);
const TextStyle authInputTextStyle = TextStyle(
  fontFamily: 'RobotoCondensedReg',
  fontSize: 14,
  fontWeight: FontWeight.normal,
  color: formFill,
);

const TextStyle unSelectedTab = TextStyle(
  fontFamily: 'RobotoCondensedReg',
  fontSize: 14,
  fontWeight: FontWeight.bold,
);

const TextStyle selectedTab = TextStyle(
  fontFamily: 'RobotoReg',
  fontSize: 18,
  fontWeight: FontWeight.bold,
);

const TextStyle drawerItemsStyle = TextStyle(
  fontFamily: 'MontserratMed',
  fontSize: 22,
  fontWeight: FontWeight.normal,
  color: questionnaireSelect,
);

const TextStyle authLabelTextStyle = TextStyle(
  fontFamily: 'RobotoCondensedReg',
  fontSize: 12,
  fontWeight: FontWeight.normal,
  color: defaultGreen,
);
const TextStyle tabTextStyle = TextStyle(
  fontFamily: 'RobotoCondensedReg',
  fontSize: 12,
  fontWeight: FontWeight.bold,
);
const TextStyle dateTabTextStyle = TextStyle(
  fontFamily: 'RobotoCondensedReg',
  fontSize: 11,
  fontWeight: FontWeight.normal,
);

const appBarTextStyle = TextStyle(
  fontFamily: 'RobotoCondensedReg',
  fontSize: 24,
  fontWeight: FontWeight.normal,
  color: Colors.black,
);

const toggleTextStyle = TextStyle(
  fontFamily: 'RobotoCondensedReg',
  fontSize: 18,
  fontWeight: FontWeight.normal,
  color: Colors.black,
);

const costBreakdownTextStyle = TextStyle(
  fontFamily: 'RobotoReg',
  fontSize: 12,
  fontWeight: FontWeight.bold,
  color: white,
);

const addressChangeTextStyle = TextStyle(
  fontFamily: 'RobotoReg',
  fontSize: 20,
  fontStyle: FontStyle.normal,
  fontWeight: FontWeight.w600,
  color: white,
);

const billingTextStyle = TextStyle(
  fontFamily: 'RobotoReg',
  fontSize: 20,
  fontStyle: FontStyle.normal,
  fontWeight: FontWeight.bold,
  color: questionnaireSelect,
);

const descriptionTextStyle = TextStyle(
  fontFamily: 'RobotoCondensedReg',
  fontSize: 12,
  fontWeight: FontWeight.w400,
);

const consultationSelectStyle = TextStyle(
  fontFamily: 'MontserratMed',
  fontSize: 15,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

const orderHistoryCardStyle = TextStyle(
  fontFamily: 'RobotoReg',
  fontSize: 13,
  fontWeight: FontWeight.normal,
  color: Colors.black,
);

const orderHistoryPopUpStyle = TextStyle(
  fontFamily: 'MontserratMed',
  fontSize: 15,
  fontWeight: FontWeight.normal,
  color: Colors.black,
);

const questionnaireTitleStyle = TextStyle(
  fontFamily: 'RobotoReg',
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: white,
);

const questionnaireOptionsStyle = TextStyle(
  fontFamily: 'RobotoReg',
  fontSize: 12,
  fontWeight: FontWeight.bold,
  color: white,
);

const questionnaireDisabledStyle = TextStyle(
  fontFamily: 'KalamReg',
  fontSize: 16,
  fontWeight: FontWeight.bold,
  color: questionnaireDisabled,
);

const tabBarLabelStyle = TextStyle(
  fontFamily: 'RobotoReg',
  fontSize: 12,
  fontWeight: FontWeight.w600,
  color: defaultPurple,
);

const consultationModeSelectStyle = TextStyle(
  fontFamily: 'RobotoReg',
  fontSize: 20,
  fontWeight: FontWeight.w600,
  color: questionnaireSelect,
);

const nullSafetyStyle = TextStyle(
    fontFamily: 'MontserratMed',
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: questionnaireSelect);

BoxDecoration authFieldDecoration = BoxDecoration(
    color: Colors.white,
    border: Border.all(color: formLinks, width: 1.0, style: BorderStyle.solid),
    borderRadius: BorderRadius.circular(5));
List<List<Color>> itemColors = [
  [
    Color(0xFF808080),
    Color(0xFFE0E0E0),
    Color(0xFFE8E8E8),
    Color(0xFFDFDFDF),
    Color(0xFF999999)
  ],
  [
    Color(0xFFA3784B),
    Color(0xFFFEDF97),
    Color(0xFFFCE7B3),
    Color(0xFFFFDD8F),
    Color(0xFFBA9360)
  ],
  [
    Color(0xFF8080A1),
    Color(0xFFE0E0FF),
    Color(0xFFE8E8FF),
    Color(0xFFDFDFFF),
    Color(0xFF9999BA)
  ],
];
List<Widget> ddItems = List.generate(
    3,
    (index) => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: itemColors[index]),
          ),
          child: Padding(
              padding: EdgeInsets.fromLTRB(15, 3, 15, 3),
              child: Text(
                index == 0
                    ? 'SILVER'
                    : index == 1
                        ? 'GOLD'
                        : 'PLATINUM',
                style: TextStyle(
                  fontFamily: 'RobotoCondensedReg',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              )),
        ));

List<Widget> mealPlanDropdownItems = List.generate(
  5,
  (index) => Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [white, white]),
    ),
    child: Padding(
        padding: EdgeInsets.fromLTRB(15, 3, 15, 3),
        child: Text(
          'Calorie',
          style: TextStyle(
            fontFamily: 'RobotoCondensedReg',
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        )),
  ),
);

String setMonthStringValue(int month) {
  if (month == 1) {
    return "01";
  } else if (month == 2) {
    return "02";
  } else if (month == 3) {
    return "03";
  } else if (month == 4) {
    return "04";
  } else if (month == 5) {
    return "05";
  } else if (month == 6) {
    return "06";
  } else if (month == 7) {
    return "07";
  } else if (month == 8) {
    return "08";
  } else if (month == 9) {
    return "09";
  } else if (month == 10) {
    return "10";
  } else if (month == 11) {
    return "11";
  } else if (month == 12) {
    return "12";
  }
}

final List<String> _weekDaysFull = [
  "Monday",
  "Tuesday",
  "Wednesday",
  "Thursday",
  "Friday",
  'Saturday',
  "Sunday"
];

final List<String> _weekDays = [
  'MON',
  'TUE',
  'WED',
  'THU',
  'FRI',
  'SAT',
  'SUN'
];

bool currentMonthContainsExtraDay(int month) {
  if (month == 1) {
    return true;
  } else if (month == 2) {
    return false;
  } else if (month == 3) {
    return true;
  } else if (month == 4) {
    return false;
  } else if (month == 5) {
    return true;
  } else if (month == 6) {
    return false;
  } else if (month == 7) {
    return true;
  } else if (month == 8) {
    return true;
  } else if (month == 9) {
    return false;
  } else if (month == 10) {
    return true;
  } else if (month == 11) {
    return false;
  } else if (month == 12) {
    return true;
  }
}

String currentMonth(int month) {
  if (month == 1) {
    return "January";
  } else if (month == 2) {
    return "February";
  } else if (month == 3) {
    return "March";
  } else if (month == 4) {
    return "April";
  } else if (month == 5) {
    return "May";
  } else if (month == 6) {
    return "June";
  } else if (month == 7) {
    return "July";
  } else if (month == 8) {
    return "August";
  } else if (month == 9) {
    return "September";
  } else if (month == 10) {
    return "October";
  } else if (month == 11) {
    return "November";
  } else if (month == 12) {
    return "December";
  }
}

String monthIntegerValueInString({month}) {
  if (month == 1) {
    return "01";
  } else if (month == 2) {
    return "02";
  } else if (month == 3) {
    return "03";
  } else if (month == 4) {
    return "04";
  } else if (month == 5) {
    return "05";
  } else if (month == 6) {
    return "06";
  } else if (month == 7) {
    return "07";
  } else if (month == 8) {
    return "08";
  } else if (month == 9) {
    return "09";
  } else if (month == 10) {
    return "10";
  } else if (month == 11) {
    return "11";
  } else if (month == 12) {
    return "12";
  }
}

var adressCardTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 12,
  fontFamily: 'RobotoCondensedReg',
);
var termsAndConditions =
    "\nTERMS & CONDITION\n\n\nThese Terms & Condition apply to the Diet Delight application including, without limitation, Diet Delight iOS app, Android app or web app (collectively, the ‘App”). As used in these Terms & Condition, ”Diet Delight” ,”us” or “we” refers to Diet Delight Restaurant WLL and its subsidiaries and affiliates.\n\n\nYOUR USED OF THE APP IS GOVERNED BY THESE TERMS & CONDITIONS\n\nBY ACCESSING OR OTHERWISE USING THE APP, YOU AGREE TO THESE TERMS & CONDITION IN THEIR ENTIRETY. Any person or entity who interacts with the Apps through the use of crawlers, robots, browsers, data mining or extraction tools or other functionality, whether such functionality is installed or placed by such person or entity or a third party, is deemed to be using the app and bound by these Terms & Condition. If at any time you do not accept all these Terms & Condition, you must immediately stop using all or any part of the App.\n\n\nONLINE ORDERING\n\nIf you placed and order through the App, you are responsible for ensuring that your order is correct and you have designated the proper address for delivery and or pick up details. You may only place order if you are at least 18 years old.\n\n\nGENERAL TERMS AND CONDITION\n\nIf you have completed the online sign up forms, this means you have agreed to our terms and conditions. We will not be able to accommodate you and we will unfortunately refuse you as a client if you: CANNOT EAT RAW FOOD CANNOT HAVE COOKED ONION AND GARLIC IN FOOD. CANNOT HAVE COOKED TOMATO OR TOMATO SAUCE ARE A CELIAC PATIENT OR HAVE SEVERE NUT ALLERGY (our kitchen is not gluten-free nor nut-free certified). An additional Bd per month is charged to your subscription in order to accommodate more than 3 intolerance, allergies or dislike/\n\n\nCANCELLATION\n\nYou may cancel your subscription up to 2 hours after the subscription has been placed in order to get refunded. After receiving the first delivery, you can pause your subscription and resume it at later date within six months of the subscription date.\n\n\nPRE-AUTHORIZATION\n\nIF YOU ARE PAYING BY CREDIT CARD, WE WILL PRE-AUTHORIZE YOUR CREDIT CARD TO VERIFY AVAILABILITY OF FUNDS, in either case, if the holder is modified prior to pick-pup or delivery, any overage will be charged to your credit card.\n\n\nDELIVERY POLICY\n\nWe will attempt to deliver your order as soon as possible. We reserve the right not to deliver if outside designated delivery times; if outside our delivery zone: in inclement weather or dangerous driving condition: to minors; to customer on public establishment; or in those instances in which we believe our delivery would conflict with, compromise or affect our business. Take note that our delivery timings are in between 6 AM till 12 NOON daily, there will be no special delivery timing request. If we are unable to deliver your order because you provided an inaccurate address, you will be charged for your order. Even if we are unable to deliver your order. If you request that your order be left at your door or another location, you will be charged, and we will have no further liability for loss of product, spoilage, theft, infestation or damaged cause by others, for any delivery left in the specific location. If you request that your order be delivered to you personally and we are unable to locate you at the address provided, we will attempt to contact you by phone or SMS. If you are not at the designated location at the time of delivery and are unable to contact you, you will be charge for the day order.\n\n\nFOOD TEMPERATURE\n\nUpon receiving of your meal, we recommend to store it on temperature between 2 to 5 degree centigrade to maintained its freshness.\n\n\nMEAL SUBSCRIPTION SERVICE SUBCRIPTION\n\nWe offer packages according to what is your requirements, from weekly or monthly subscription plan in which you will receive a specified number of meals each day. The fees for your subscription plan will depend on the number of meals you specify and will be shown on the order page. PRICES All prices shown on the App are subject to 5% government Tax and subject to change at any time without notice. The price available through the Apps reflects the price available at the current time. In your current market area, and supersedes any and all prior prices for any product or plan. We may offer promotional pricing, frequency discount, loyalty discount and other alternative pricing structure for some or all of our subscriptions plans to some or all of our customers from time to time in our discretion. We reserve the right to discontinue, or extend pricing in our discretion without any prior notice to you. PAYMENT When you registered for a subscription plan, you agree that Diet Delight or its third party payment processor is authorized to charge you for a subscription plan that you chose, In advance plus any taxes or other applicable charges, for as long as your subscription plan continues. All plans are continuous subscription plans and your subscription plan will continue until you pause it or we suspend or cancel your account. ALL PAYMENT WILL BE CHARGE AUTOMATICALLY THE DAY THE ORDER WAS BEEN SHIPPED. PAUSING AND CANCELLATION If you are a subscriber thru Mobile APPs or our Web Apps , you may pause or cancel your subscription plan,  To pause or cancel your subscription plan, choose the option provided in the APP or contact Diet Delight at info@dietdelightbh.com or thru WhatsApp 36999556 You are responsible for any meals order prior to the pausing or cancellation of your subscription meal plan. You acknowledge that, even after you have paused or cancelled your meal plan, or while your meal plan is suspended. REFUND POLICY If you are a subscriber thru APPs and you cancel your subscription, Diet Delight has no obligation to refund any amount paid prior to the time of cancellation. If you are a subscriber or you pre-order two(2) days ahead and you cancel your order on the day of the delivery. Diet Delight may, at its option, credit the amount of the order to you in Diet Delight Credits instead of crediting the amount of the order to your accounts. CANCELLATION, SKIPPING, RESCHEDULLING OR EDITING ORDERS You can pause your order, skip delivery, re schedule a delivery or edit your meals 48 hours any time prior to midday (12 NOON) one day before your meal plan schedule delivery. For example, if your meal plan was schedule to be deliver or received by Monday, you should cancel, skip, reschedule or edit any time prior to 11 :59 am SUNDAY. WEIGHT LOSS AND HEALTH CLAIMS Diet Delight provides information regarding its product for informational purposes only. Any weight loss and health result mentioned on the App, whether by Diet Delight or others, are not guaranteed.  Your result may vary considerably from those described through App. You expressly acknowledge that Diet Delight App does not make any express or implied claims or guarantees that you will achieve or maintain any specific results through your use of DD subscription service. Diet Delight does not refund any payments or agree to cancel your participation in a subscription plan based on your failure to achieve your desire result. DD subscription plans are not medically supervised. You should seek the advice of our clinical dietitian thru assessment before starting any dietary program to ensure it is suitable for your specific dietary needs. DD does not suggest or represent that any programs have been approved for your individual use by a physician or other medical professional, In addition, DD does not guarantee the accuracy, completeness or usefulness of any nutritional information of any subscription plan or adopt, endorse or accept responsibility for the accuracy , completeness or usefulness of any nutritional information regarding any subscription plan. DELIVERY AND HANDLING PROGRAM You agree to pay any extra delivery or handling charges shown at the time you make a purchase. We reserve the right to increase, decrease, add or eliminate delivery and handling charges from time to time. But we will provide notice to the charges applicable to you before you make your purchase. Once the meals are delivered to you, ownership and the risk of loss passes to you, following delivery, you and not DD, are solely responsible for the proper and safe preparation and storage of the meals. By ordering any of our meals, you agree to use our meals at your own risk. RIGHTS All title, right, content and interest in our App, including but not limited to copyrights, trade secrets, patent, and other proprietary rights, and any derivative works, shall belong exclusively to Diet Delight or its licensors. Nothing in this terms and condition or otherwise will be deemed to grant to you an ownership interest in the App, in whole or in part. All content included in the App, such as food photo, photo of any sort, meal program, recipe, plans, guide, logos, text ,button icon, audio clips, video clips of any sort, data , music, software and other related materials (known as CONTENT) is owned and licensed property of Diet Delight or its licensors and its protected by copyright, trademark and patent technologies. ACCESS & LICENSE Diet Delight Apps grants you a limited access and make personal use of the App and the content for Non-Commercial purpose only and only to the extent such use does not violates these Terms and condition. TRADEMARK AND COPY RIGHT INFORMATION All content included or available on this site, including text, site design, graphics, videos, interfaces, and the selection of pictures and arrangement is owned by us. Any use of materials on the website, including replicating, reproducing, republishing, downloading, posting, broadcasting, distributing, modifying, any form of data mining or data extraction, or other commercial exploitation of any kind, without prior written permission of an authorized officer of Diet Delight WLL is strictly prohibited. User agree that they will not use any automatic device or manual process to monitor or copy our web pages or the content contained therein.";

var faqQuestions = [
  "What if I cannot come to your office for an actual consultation, how can I register? ",
  "How many kilograms am I expected to lose if I follow your diet plan?",
  "Can I still lose weight even without availing any Diet Plan?",
  " If I cannot do exercise, will I still lose weight in your program?",
  "What beverages am I allowed to have while on your diet program?",
];

var faqAnswers = [
  "We offer a thorough online virtual consultation at your own comfort with our Clinical Dietitian. We just need your   personal information (through the Client Detail Sheet) then you can already choose from the Consultation and Diet Packages that we offer. Our team will contact you directly to organize.",
  "You are expected to lose more or less 1-1.5 kilograms every week. Improvement in your body anthropometrics are also expected alongside.",
  "Even without getting the Diet Plan, our Dietitian will be with you every step of the way to guide you as long as you    follow our diet recommendations and maintaining an active lifestyle. ",
  "Though we really encourage you to exercise to maximize weight loss and for optimum health, you can still lose weight even without as long as you comply with our dietary recommendations and maintain an active life. ",
  "Hydration is very important – drink at least 2 Liters water daily. Besides water, you can have plain coffee or tea.  ",
];

Future<bool> sendEmail(name, emailAddress, content) async {
  final Email email = Email(
    body: content,
    subject: '$name',
    recipients: [emailAddress.toString()],
    isHTML: false,
  );
  print("hey");
  await FlutterEmailSender.send(email);
}

int selectedAddressIndex;
bool isAddressSelected;
String concatenatedAddress;
String selectedAddressLine1;
String selectedAddressLine2;
String primaryAddressLine1 = Api.userInfo.addressLine1 ?? '';
String primaryAddressLine2 = Api.userInfo.addressLine2 ?? '';
String secondaryAddressLine1 = Api.userInfo.addressSecondary1 ?? '';
String secondaryAddressLine2 = Api.userInfo.addressSecondary2 ?? '';

enum FromPage { signUp, forgetPass }

var selectConsultationBackgroundImage =
    DecorationImage(image: AssetImage('images/bg4.jpg'), fit: BoxFit.fitHeight);

var consultationBackground =
    DecorationImage(image: AssetImage('images/bg3.jpg'), fit: BoxFit.fitHeight);

var question1Background =
    DecorationImage(image: AssetImage('images/bg9.jpg'), fit: BoxFit.fitHeight);

var question2Background1 = DecorationImage(
    image: AssetImage('images/bg11.jpg'), fit: BoxFit.fitHeight);

var question2Background2 = DecorationImage(
    image: AssetImage('images/bg10.jpg'), fit: BoxFit.fitHeight);

var bmiBackground =
    DecorationImage(image: AssetImage('images/bg1.jpg'), fit: BoxFit.fitHeight);

var consultationHomePageBackground =
    DecorationImage(image: AssetImage('images/bg1.jpg'), fit: BoxFit.cover);
