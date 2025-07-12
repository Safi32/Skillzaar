import 'package:flutter/material.dart';
// import '../../core/services/phone_auth_service.dart';
// import '../../core/utils/phone_utils.dart';

String formatPhoneNumber(String input) {
  input = input.trim();
  if (input.startsWith('+')) return input;
  if (input.startsWith('0') && input.length == 11) {
    return '+92' + input.substring(1);
  }
  return input;
}

const Map<String, String> testNumbers = {
  '+923115798273': '123456',
  '+12345678901': '654321',
  // Add more test numbers and OTPs as needed
};

class PhoneAuthProvider with ChangeNotifier {
  String? _verificationId;
  bool _isLoading = false;
  String? _error;
  String? _currentPhoneNumber;

  String? get verificationId => _verificationId;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void verifyPhone(String phoneNumber) {
    _isLoading = true;
    _error = null;
    notifyListeners();
    final formatted = formatPhoneNumber(phoneNumber);
    if (testNumbers.containsKey(formatted)) {
      _verificationId = 'test_verification_id';
      _currentPhoneNumber = formatted;
      _isLoading = false;
      notifyListeners();
    } else {
      _error = 'Phone number not registered for testing.';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signInWithOTP(String smsCode, VoidCallback onSuccess) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    if (_verificationId == 'test_verification_id' &&
        _currentPhoneNumber != null &&
        testNumbers[_currentPhoneNumber] == smsCode) {
      _isLoading = false;
      notifyListeners();
      onSuccess();
    } else {
      _error = 'Invalid OTP. Please try again.';
      _isLoading = false;
      notifyListeners();
    }
  }
}
