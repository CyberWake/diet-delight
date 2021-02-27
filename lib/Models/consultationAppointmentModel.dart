class ConsAppointmentModel {
  String id;
  String status;
  String userId;
  String consultationTime;
  String consultationPurchaseId;
  String consultantId;
  String consultationMode;
  String consultantName;
  String consultationLink;
  String notes;
  String createdAt;

  ConsAppointmentModel(
      {this.id,
      this.status = "0",
      this.userId,
      this.consultationTime,
      this.consultationPurchaseId,
      this.consultantId = "0",
      this.consultantName = "Not Assigned",
      this.consultationLink,
      this.consultationMode,
      this.notes,
      this.createdAt});

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'status': this.status,
      'user_id': this.userId,
      'consultation_time': this.consultationTime,
      'consultation_purchase_id': this.consultationPurchaseId,
      'consultation_package_id': this.consultationPurchaseId,
      'consultant_id': this.consultantId,
      'consultant_name': this.consultantName,
      'consultation_link': this.consultationLink,
      'consultation_mode': this.consultationMode,
      'notes': this.notes
    } as Map<String, dynamic>;
  }

  factory ConsAppointmentModel.fromMap(Map item) {
    return ConsAppointmentModel(
        id: item['id'].toString(),
        status: item['status'].toString(),
        userId: item['user_id'].toString(),
        consultationTime: item['consultation_time'].toString(),
        consultationPurchaseId: item['consultation_purchase_id'].toString(),
        consultantId: item['consultant_id'].toString(),
        consultantName: item['consultant_name'].toString(),
        consultationLink: item['consultation_link'].toString(),
        consultationMode: item['consultation_mode'].toString(),
        notes: item['notes'].toString(),
        createdAt: item['created_at'].toString());
  }

  putDetails({String packagePurchaseId, String selectedConsultationMode}) {
    this.consultationPurchaseId = packagePurchaseId;
    this.consultationMode = selectedConsultationMode;
  }

  show() {
    print('status: $status');
    print('userId: $userId');
    print('consultationTime: $consultationTime');
    print('consultationPurchaseId: $consultationPurchaseId');
    print('consultantId: $consultantId');
    print('consultantName: $consultantName');
    print('consultationLink: $consultationLink');
    print('consultationMode: $consultationMode');
    print('notes: $notes');
    print('created at: $createdAt');
  }
}
