import 'dart:convert';

class MealPurchaseModel {
  String id;
  String userId;
  String mealPlanId;
  String paymentId;
  String status;
  String mealPlanName;
  String mealPlanDuration;
  String amountPaid;
  String startDate;
  String endDate;
  List weekdays;
  String kCal;
  String portions;
  String createdAt;
  String billingAddressLine1;
  String billingAddressLine2;
  String shippingAddressLine1;
  String shippingAddressLine2;

  MealPurchaseModel(
      {this.id,
      this.userId,
      this.mealPlanId,
      this.paymentId,
      this.status = "0",
      this.mealPlanName,
      this.mealPlanDuration,
      this.amountPaid,
      this.startDate,
      this.endDate,
      this.weekdays,
      this.kCal = "1000",
      this.portions = "0",
      this.createdAt,
      this.billingAddressLine1,
      this.billingAddressLine2,
      this.shippingAddressLine1,
      this.shippingAddressLine2});

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'user_id': this.userId,
      'meal_plan_id': this.mealPlanId,
      'payment_id': this.paymentId,
      'status': this.status,
      'meal_plan_name': this.mealPlanName,
      'meal_plan_duration': this.mealPlanDuration,
      'amount_paid': this.amountPaid,
      'start_date': this.startDate,
      'end_date': this.endDate,
      'weekdays': jsonEncode(this.weekdays),
      'kcal': this.kCal,
      'portions': this.portions,
      'billing_address_line1': this.billingAddressLine1,
      'billing_address_line2': this.billingAddressLine2,
      'shipping_address_line1': this.shippingAddressLine1,
      'shipping_address_line2': this.shippingAddressLine2,
    } as Map<String, dynamic>;
  }

  factory MealPurchaseModel.fromMap(Map item) {
    List weekDays = jsonDecode(item['weekdays']);
    return MealPurchaseModel(
        id: item['id'].toString(),
        userId: item['user_id'].toString(),
        mealPlanId: item['meal_plan_id'].toString(),
        paymentId: item['payment_id'].toString(),
        status: item['status'].toString(),
        mealPlanName: item['meal_plan_name'].toString(),
        mealPlanDuration: item['meal_plan_duration'].toString(),
        amountPaid: item['amount_paid'].toString(),
        startDate: item['start_date'].toString(),
        endDate: item['end_date'].toString(),
        weekdays: weekDays,
        kCal: item['kcal'].toString(),
        portions: item['portions'].toString(),
        createdAt: item['created_at'].toString(),
        billingAddressLine1: item['billing_address_line1'],
        billingAddressLine2: item['billing_address_line2'],
        shippingAddressLine1: item['shipping_address_line1'],
        shippingAddressLine2: item['shipping_address_line2']);
  }

  showWeek() {
    String days = this.weekdays.toString();
    days = days.substring(1, days.length - 1);
    return days;
  }

  setEndDate(String endDate) {
    this.endDate = endDate;
  }

  show() {
    print('id: $id');
    print('userId: $userId');
    print('mealPlanId: $mealPlanId');
    print('paymentId: $paymentId');
    print('status: $status');
    print('mealPlanName: $mealPlanName');
    print('mealPlanDuration: $mealPlanDuration');
    print('amountPaid: $amountPaid');
    print('startDate: $startDate');
    print('endDate: $endDate');
    print('weekdays: $weekdays');
    print('kCal: $kCal');
    print('portions: $portions');
    print('created at: $createdAt');
  }
}
