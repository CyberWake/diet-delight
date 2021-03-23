class CouponModel {
  int id;
  String name;
  String code;
  String flatDiscount;
  String percentageDiscount;
  String expiryDate;
  int timesUsed;
  int timesUsable;

  CouponModel(
      {this.id,
      this.name,
      this.code,
      this.flatDiscount,
      this.percentageDiscount,
      this.expiryDate,
      this.timesUsable,
      this.timesUsed});

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'id': this.id,
      'name': this.name,
      'code': this.code,
      'flat_discount': this.flatDiscount,
      'percentage_discount': this.percentageDiscount,
      'expiry_date': this.expiryDate,
      'times_usable': this.timesUsable,
      'times_used': this.timesUsed,
    } as Map<String, dynamic>;
  }

  factory CouponModel.fromMap(Map item) {
    return CouponModel(
      id: item['id'],
      name: item['name'],
      code: item['code'],
      flatDiscount: item['flat_discount'],
      percentageDiscount: item['percentage_discount'],
      expiryDate: item['expiry_date'],
      timesUsable: item['times_usable'],
      timesUsed: item['times_used'],
    );
  }

  addUsed() {
    this.timesUsed = this.timesUsed + 1;
  }
}
