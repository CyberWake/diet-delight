class RegModel {
  String status;
  String id;
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
      this.id,
      this.name,
      this.email,
      this.password,
      this.firstName,
      this.lastName,
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
        address: item['address'],
        addressSecondary: item['address_secondary']);
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
    print('address: $address');
    print('addressSecondary: $addressSecondary');
  }
}
