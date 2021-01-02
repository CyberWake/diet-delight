import 'dart:math';

import 'package:sms/sms.dart';

class FlutterOtp {
  int _otp, _minOtpValue, _maxOtpValue; //Generated OTP

  void generateOtp([int min = 1000, int max = 9999]) {
    //Generates four digit OTP by default
    _minOtpValue = min;
    _maxOtpValue = max;
    _otp = _minOtpValue + Random().nextInt(_maxOtpValue - _minOtpValue);
  }

  void getOtp() {
    print(_otp);
  }

  void sendOtp(String phoneNumber,
      [String messageText,
      int min = 1000,
      int max = 9999,
      String countryCode = '+1']) {
    //function parameter 'message' is optional.
    generateOtp(min, max);
    SmsSender sender = new SmsSender();
    String address =
        countryCode + phoneNumber; // +1 for USA. Change it according to use.
    sender.sendSms(new SmsMessage(address, messageText + _otp.toString()));
  }

  bool resultChecker(int enteredOtp) {
    //To validate OTP
    return enteredOtp == _otp;
  }
}
