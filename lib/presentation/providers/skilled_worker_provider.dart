import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

String formatPhoneNumber(String input) {
  input = input.trim().replaceAll(' ', '');
  // Remove all spaces
  if (input.startsWith('+')) return input;
  if (input.startsWith('0') && input.length == 11) {
    return '+92' + input.substring(1);
  }
  if (input.length == 10 && input.startsWith('3')) {
    // e.g. 3115798273 (no leading zero)
    return '+92' + input;
  }
  return input;
}

const Map<String, String> testNumbers = {
  '+923115798273': '123456',
  '+12345678901': '654321',
  // Add more test numbers and OTPs as needed
};

class SkilledWorkerProvider with ChangeNotifier {
  String? _verificationId;
  bool _isLoading = false;
  String? _error;
  String? _success;
  String? _currentPhoneNumber;

  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get success => _success;

  void verifyPhone(String phoneNumber) {
    _isLoading = true;
    _error = null;
    notifyListeners();
    final formatted = formatPhoneNumber(phoneNumber);
    print('Verifying phone: "$formatted"');
    print('Test numbers: ${testNumbers.keys}');
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
    print(
      'Checking OTP: "$smsCode" for phone: "$_currentPhoneNumber" (expected: "${_currentPhoneNumber != null ? testNumbers[_currentPhoneNumber] : ''}")',
    );
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

  Future<void> postSkilledWorker({
    required String name,
    required int age,
    required String city,
  }) async {
    _isLoading = true;
    _error = null;
    _success = null;
    notifyListeners();

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _error = 'User not logged in!';
      _isLoading = false;
      notifyListeners();
      return;
    }

    final workerData = {
      'Name': name,
      'Age': age,
      'City': city,
      'ProfilePicture': 'https://via.placeholder.com/150',
      'CNICFront': 'https://via.placeholder.com/300x200?text=CNIC+Front',
      'CNICBack': 'https://via.placeholder.com/300x200?text=CNIC+Back',
      'userId': user.uid,
      'createdAt': FieldValue.serverTimestamp(),
    };

    try {
      await FirebaseFirestore.instance
          .collection('SkilledWorker')
          .add(workerData);
      _success = 'Skilled worker registered successfully!';
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to register skilled worker: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearStatus() {
    _error = null;
    _success = null;
    notifyListeners();
  }
}
