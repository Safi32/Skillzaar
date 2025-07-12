import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class JobProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  String? _success;

  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get success => _success;

  Future<void> postJob({
    required String name,
    required String description,
    required File? image,
    required String location,
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

    // Use a static placeholder image URL for testing
    String imageUrl = "https://via.placeholder.com/150";

    final jobData = {
      'Name': name,
      'Description': description,
      'Image': imageUrl,
      'Location': location,
      'userId': user.uid,
      'createdAt': FieldValue.serverTimestamp(),
    };

    try {
      await FirebaseFirestore.instance.collection('Job').add(jobData);
      _success = 'Job posted successfully!';
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to post job: $e';
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
