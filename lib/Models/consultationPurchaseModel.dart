class ConsPurchaseModel {
  String id;
  String status;
  String userId;
  String consultationName;
  String consultationPackageDuration;
  String consultationPackageId;
  String amountPaid;
  String paymentId;
  String consultationPackageName;

  ConsPurchaseModel(
      {this.id,
      this.status = "0",
      this.userId,
      this.consultationName,
      this.consultationPackageId,
      this.consultationPackageDuration,
      this.amountPaid,
      this.paymentId,});

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'status': this.status,
      'user_id': this.userId,
      'consultation_package_name': this.consultationName,
      'consultation_package_id': this.consultationPackageId,
      'consultation_package_duration': this.consultationPackageDuration,
      'amount_paid': this.amountPaid,
      'payment_id': this.paymentId
    } as Map<String, dynamic>;
  }

  factory ConsPurchaseModel.fromMap(Map item) {
    return ConsPurchaseModel(
        id: item['id'].toString(),
        status: item['status'].toString(),
        userId: item['user_id'].toString(),
        consultationPackageId: item['consultation_package_id'].toString(),
        consultationName: item['consultation_package_name'],
        consultationPackageDuration:
            item['consultation_package_duration'].toString(),
        amountPaid: item['amount_paid'].toString(),
        paymentId: item['payment_id'].toString());
  }

  setUserPaymentDetails({String userId, String paymentId}) {
    this.paymentId = paymentId;
    this.userId = userId;
  }

  show() {
    print('status: $status');
    print('userId: $userId');
    print('consultationId: $consultationPackageId');
    print('consultationName: $consultationName');
    print('consultationPackageDuration: $consultationPackageDuration');
    print('amountPaid: $amountPaid');
    print('paymentId: $paymentId');
  }
}
