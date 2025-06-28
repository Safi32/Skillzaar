import 'dart:io';
import 'package:flutter/material.dart';

class CnicProvider extends ChangeNotifier {
  File? frontImage;
  File? backImage;

  void setFrontImage(File? image) {
    frontImage = image;
    notifyListeners();
  }

  void setBackImage(File? image) {
    backImage = image;
    notifyListeners();
  }
}
