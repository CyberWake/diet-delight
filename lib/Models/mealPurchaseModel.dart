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
      this.createdAt});

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
    );
  }

  showWeek() {
    String days = this.weekdays.toString();
    days = days.substring(1, days.length - 1);
    return days;
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
