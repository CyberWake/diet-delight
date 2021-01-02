class LogModel {
  String mobile;
  String email;
  String password;

  LogModel({this.mobile, this.email, this.password});

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'mobile': this.mobile,
      'email': this.email,
      'password': this.password,
    } as Map<String, dynamic>;
  }

  show() {
    print('mobile: $mobile');
    print('email: $email');
    print('password: $password');
  }
}
