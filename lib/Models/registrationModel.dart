class RegModel {
  String status;
  String name;
  String email;
  String password;
  String firstName;
  String lastName;
  String mobile;
  String address;
  String addressSecondary;

  RegModel(
      {this.status = "0",
      this.name = "test",
      this.email,
      this.password,
      this.firstName = "test",
      this.lastName = "test",
      this.mobile,
      this.address = "test",
      this.addressSecondary = "test"});

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
      'address': this.address,
      'address_secondary': this.addressSecondary,
    } as Map<String, dynamic>;
  }

  show() {
    print('status: $status');
    print('name: $name');
    print('email: $email');
    print('password: $password');
    print('firstName: $firstName');
    print('lastName: $lastName');
    print('mobile: $mobile');
    print('address: $address');
    print('addressSecondary: $addressSecondary');
  }
}
