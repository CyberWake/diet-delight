import 'dart:math';

import 'package:twilio_flutter/twilio_flutter.dart';

class FlutterOtp {
  int _otp, _minOtpValue, _maxOtpValue; //Generated OTP
  TwilioFlutter twilioFlutter;
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
    generateOtp(min, max);
    String address = countryCode + phoneNumber;
    twilioFlutter = TwilioFlutter(
        accountSid: 'ACd7e0b5a7b2a7d84b913e35badce320f3',
        authToken: 'c566ae9a47b768b4957757143f954ef2',
        twilioNumber: '+18636177383');

    sendSms(
        address,
        messageText +
            _otp.toString()); // +1 for USA. Change it according to use.
  }

  void sendSms(number, message) async {
    twilioFlutter.sendSMS(toNumber: number.toString(), messageBody: message);
  }

  bool resultChecker(int enteredOtp) {
    //To validate OTP
    return enteredOtp == _otp;
  }
}
