import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/skilled_worker_provider.dart';
import 'home_screen.dart';

class SkilledWorkerLoginScreen extends StatefulWidget {
  const SkilledWorkerLoginScreen({super.key});

  @override
  State<SkilledWorkerLoginScreen> createState() =>
      _SkilledWorkerLoginScreenState();
}

class _SkilledWorkerLoginScreenState extends State<SkilledWorkerLoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  final List<TextEditingController> otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  bool otpSent = false;

  String get otp => otpControllers.map((c) => c.text).join();

  @override
  void dispose() {
    phoneController.dispose();
    for (final c in otpControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final skilledWorkerProvider = Provider.of<SkilledWorkerProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Skilled Worker Login'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 32),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    hintText: 'Enter Your Phone Number',
                  ),
                  enabled: !otpSent,
                ),
                const SizedBox(height: 24),
                if (otpSent) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      6,
                      (index) => SizedBox(
                        width: 40,
                        child: TextField(
                          controller: otpControllers[index],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          decoration: const InputDecoration(counterText: ''),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed:
                        skilledWorkerProvider.isLoading
                            ? null
                            : () async {
                              if (!otpSent) {
                                skilledWorkerProvider.verifyPhone(
                                  phoneController.text.trim(),
                                );
                                await Future.delayed(
                                  const Duration(milliseconds: 100),
                                );
                                if (skilledWorkerProvider.error == null) {
                                  setState(() => otpSent = true);
                                  ScaffoldMessenger.of(context).showSnackBar(
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
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        skilledWorkerProvider.error!,
                                      ),
                                    ),
                                  );
                                }
                              } else {
                                if (otp.length != 6) return;
                                await skilledWorkerProvider.signInWithOTP(
                                  otp,
                                  () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Login successful!'),
                                        behavior: SnackBarBehavior.floating,
                                        margin: EdgeInsets.only(
                                          top: 16,
                                          left: 16,
                                          right: 16,
                                        ),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) =>
                                                const SkilledWorkerHomeScreen(),
                                      ),
                                      (route) => false,
                                    );
                                  },
                                );
                                if (skilledWorkerProvider.error != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        skilledWorkerProvider.error!,
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
                              }
                            },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
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
                            : Text(otpSent ? 'Verify OTP' : 'Send OTP'),
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
