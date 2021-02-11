class RegModel {
  String status;
  String id;
  String name;
  String email;
  String password;
  String firstName;
  String lastName;
  String mobile;
  String addressLine1;
  String addressLine2;
  String addressSecondary1;
  String addressSecondary2;

  RegModel(
      {this.status = "0",
      this.id,
      this.name,
      this.email,
      this.password,
      this.firstName,
      this.lastName,
      this.mobile,
      this.addressLine1 = "test",
      this.addressLine2 = 'test',
      this.addressSecondary1 = "test",
      this.addressSecondary2 = 'test'});

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'status': this.status,
      'name': this.name,
      'email': this.email,
      'password': this.password,
      'first_name': this.firstName,
      'last_name': this.lastName,
      'mobile': this.mobile,
      'primary_address_line1': this.addressLine1,
      'primary_address_line2': this.addressLine2,
      'secondary_address_line1': this.addressSecondary1,
      'secondary_address_line2': this.addressSecondary2,
    } as Map<String, dynamic>;
  }

  factory RegModel.fromMap(Map item) {
    return RegModel(
        status: item['status'].toString(),
        id: item['id'].toString(),
        name: item['name'],
        email: item['email'],
        password: item['password'],
        firstName: item['first_name'],
        lastName: item['last_name'],
        mobile: item['mobile'],
        addressLine1: item['primary_address_line1'],
        addressLine2: item['primary_address_line1'],
        addressSecondary1: item['secondary_address_line1'],
        addressSecondary2: item['secondary_address_line2']);
  }

  show() {
    print('status: $status');
    print('id: $id');
    print('name: $name');
    print('email: $email');
    print('password: $password');
    print('firstName: $firstName');
    print('lastName: $lastName');
    print('mobile: $mobile');
    print('addressLine1: $addressLine1');
    print('addressLine2: $addressLine2');
    print('addressSecondaryLine1: $addressSecondary1');
    print('addressSecondaryLine2: $addressSecondary2');
  }
}
