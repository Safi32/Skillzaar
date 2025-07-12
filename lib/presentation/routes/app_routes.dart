import 'package:flutter/material.dart';
import '../screens/job_poster/quick_register_screen.dart';
import '../screens/job_poster/otp_screen.dart';
import '../screens/job_poster/post_job_screen.dart';
import '../screens/skilled_worker/signup_screen.dart';
import '../screens/skilled_worker/otp_screen.dart';
import '../screens/skilled_worker/cnic_screen.dart';
import '../screens/skilled_worker/profile_screen.dart';
import '../screens/skilled_worker/login_screen.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/job-poster-quick-register':
        (context) => const JobPosterQuickRegisterScreen(),
    '/job-poster-otp': (context) => const JobPosterOtpScreen(),
    '/job-poster-post-job': (context) => const JobPosterPostJobScreen(),
    '/skilled-worker-signup': (context) => const SkilledWorkerSignUpScreen(),
    '/skilled-worker-otp': (context) => const SkilledWorkerOtpScreen(),
    '/skilled-worker-cnic': (context) => const SkilledWorkerCnicScreen(),
    '/skilled-worker-profile': (context) => const SkilledWorkerProfileScreen(),
    '/skilled-worker-login': (context) => const SkilledWorkerLoginScreen(),
  };
}
