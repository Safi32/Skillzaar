import 'package:flutter/material.dart';
import 'package:skillzaar/presentation/providers/skilled_worker_provider.dart';
import 'presentation/screens/splash_screen.dart';
import 'presentation/screens/role_selection_screen.dart';
import 'core/theme/app_theme.dart';
import 'presentation/routes/app_routes.dart';
import 'package:provider/provider.dart';
import 'presentation/providers/cnic_provider.dart';
import 'presentation/providers/profile_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'presentation/providers/phone_auth_provider.dart';
import 'presentation/providers/job_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CnicProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => PhoneAuthProvider()),
        ChangeNotifierProvider(create: (_) => JobProvider()),
        ChangeNotifierProvider(create: (_) => SkilledWorkerProvider()), 
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      home: const SplashScreen(),
      routes: {
        '/role-selection': (context) => const RoleSelectionScreen(),
        ...AppRoutes.routes,
      },
    );
  }
}
