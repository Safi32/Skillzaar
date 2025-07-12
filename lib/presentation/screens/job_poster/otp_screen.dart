import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/phone_auth_provider.dart';
import '../../../core/theme/app_theme.dart';

class JobPosterOtpScreen extends StatefulWidget {
  const JobPosterOtpScreen({super.key});

  @override
  State<JobPosterOtpScreen> createState() => _JobPosterOtpScreenState();
}

class _JobPosterOtpScreenState extends State<JobPosterOtpScreen> {
  final List<TextEditingController> controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (final c in controllers) {
      c.dispose();
    }
    for (final f in focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get otp => controllers.map((c) => c.text).join();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final phoneAuthProvider = Provider.of<PhoneAuthProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Enter OTP',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.green,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'We\'ve sent a 6-digit code to your number.',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 32,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(
                            6,
                            (index) => SizedBox(
                              width: size.width * 0.10,
                              height: 56,
                              child: TextField(
                                controller: controllers[index],
                                focusNode: focusNodes[index],
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                                decoration: const InputDecoration(
                                  counterText: '',
                                ),
                                onChanged: (value) {
                                  if (value.length == 1 && index < 5) {
                                    FocusScope.of(
                                      context,
                                    ).requestFocus(focusNodes[index + 1]);
                                  } else if (value.isEmpty && index > 0) {
                                    FocusScope.of(
                                      context,
                                    ).requestFocus(focusNodes[index - 1]);
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        if (phoneAuthProvider.error != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              phoneAuthProvider.error!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed:
                                phoneAuthProvider.isLoading
                                    ? null
                                    : () {
                                      // TODO: Implement resend logic if needed
                                    },
                            child: const Text(
                              'Resend code',
                              style: TextStyle(
                                color: AppColors.green,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed:
                                phoneAuthProvider.isLoading
                                    ? null
                                    : () async {
                                      if (otp.length != 6) return;
                                      await phoneAuthProvider.signInWithOTP(
                                        otp,
                                        () {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Your phone number has been successfully verified!',
                                              ),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              margin: EdgeInsets.only(
                                                top: 16,
                                                left: 16,
                                                right: 16,
                                              ),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                          Navigator.pushNamed(
                                            context,
                                            '/job-poster-post-job',
                                          );
                                        },
                                      );
                                      if (phoneAuthProvider.error != null) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              phoneAuthProvider.error!,
                                            ),
                                            behavior: SnackBarBehavior.floating,
                                            margin: const EdgeInsets.only(
                                              top: 16,
                                              left: 16,
                                              right: 16,
                                            ),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 1,
                            ),
                            child:
                                phoneAuthProvider.isLoading
                                    ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                    : const Text(
                                      'Verify',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
