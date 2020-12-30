class LogModel {
  String mobile;
  String email;
  String password;

  LogModel({this.mobile, this.email, this.password});
  show() {
    print('mobile: $mobile');
    print('email: $email');
    print('password: $password');
  }
}
