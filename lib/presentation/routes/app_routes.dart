import 'package:flutter/material.dart';
import '../screens/signup_screen.dart';
import '../screens/otp_screen.dart';
import '../screens/cnic_upload_screen.dart';
import '../screens/profile_setup_screen.dart';
import '../screens/login_screen.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/signup': (context) => const SignUpScreen(),
    '/otp': (context) => const OtpScreen(),
    '/cnic-upload': (context) => const CnicUploadScreen(),
    '/profile-setup': (context) => const ProfileSetupScreen(),
    '/login': (context) => const LoginScreen(),
  };
}
