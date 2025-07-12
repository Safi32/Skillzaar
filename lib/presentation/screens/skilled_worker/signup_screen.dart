import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/skilled_worker_provider.dart';
import '../../../core/theme/app_theme.dart';

class SkilledWorkerSignUpScreen extends StatelessWidget {
  const SkilledWorkerSignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String countryCode = '+92';
    final size = MediaQuery.of(context).size;
    final phoneController = TextEditingController();
    final skilledWorkerProvider = Provider.of<SkilledWorkerProvider>(context);
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
                  'Skilled Worker Sign Up',
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
                            DropdownButton<String>(
                              value: countryCode,
                              items: const [
                                DropdownMenuItem(
                                  value: '+92',
                                  child: Text('+92'),
                                ),
                                DropdownMenuItem(
                                  value: '+1',
                                  child: Text('+1'),
                                ),
                                DropdownMenuItem(
                                  value: '+44',
                                  child: Text('+44'),
                                ),
                              ],
                              onChanged: (value) {}, // UI only
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: phoneController,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  hintText: 'Mobile Number',
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
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed:
                                skilledWorkerProvider.isLoading
                                    ? null
                                    : () async {
                                      final rawInput =
                                          phoneController.text.trim();
                                      skilledWorkerProvider.verifyPhone(
                                        rawInput,
                                      );
                                      await Future.delayed(
                                        const Duration(milliseconds: 100),
                                      );
                                      if (skilledWorkerProvider.error == null) {
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
                                          '/skilled-worker-otp',
                                        );
                                      } else {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              skilledWorkerProvider.error!,
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
                                skilledWorkerProvider.isLoading
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
