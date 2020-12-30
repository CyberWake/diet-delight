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
  List role;

  RegModel(
      {this.status,
      this.name,
      this.email,
      this.password,
      this.firstName,
      this.lastName,
      this.mobile,
      this.address,
      this.addressSecondary,
      this.role});

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
    print('role: $role');
  }
}
