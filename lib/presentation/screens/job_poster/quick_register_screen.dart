import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/phone_auth_provider.dart';

class JobPosterQuickRegisterScreen extends StatelessWidget {
  const JobPosterQuickRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController phoneController = TextEditingController();
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
                  'Quick Registration',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.green,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Enter your mobile number to continue',
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
                          children: [
                            Expanded(
                              child: TextField(
                                controller: phoneController,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  hintText: '03XXXXXXXXX or +923XXXXXXXXX',
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 16,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey.shade100,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),
                        if (phoneAuthProvider.error != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              phoneAuthProvider.error!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed:
                                phoneAuthProvider.isLoading
                                    ? null
                                    : () async {
                                      final rawInput =
                                          phoneController.text.trim();
                                      phoneAuthProvider.verifyPhone(rawInput);
                                      await Future.delayed(
                                        const Duration(milliseconds: 100),
                                      ); // Wait for provider to update
                                      if (phoneAuthProvider.error == null) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'A verification code has been sent to your phone number. Please enter the code to continue.',
                                            ),
                                            behavior: SnackBarBehavior.floating,
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
                                          '/job-poster-otp',
                                        );
                                      } else {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              phoneAuthProvider.error!,
                                            ),
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
                                      'Send OTP',
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
