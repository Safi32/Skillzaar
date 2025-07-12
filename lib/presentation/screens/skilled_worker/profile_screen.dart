import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../core/theme/app_theme.dart';
import 'package:provider/provider.dart';
import '../../providers/skilled_worker_provider.dart';

class SkilledWorkerProfileScreen extends StatefulWidget {
  const SkilledWorkerProfileScreen({super.key});

  @override
  State<SkilledWorkerProfileScreen> createState() =>
      _SkilledWorkerProfileScreenState();
}

class _SkilledWorkerProfileScreenState
    extends State<SkilledWorkerProfileScreen> {
  File? profileImage;
  double workingRadius = 10;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    cityController.dispose();
    super.dispose();
  }

  Future<void> pickProfileImage() async {
    final picker = ImagePicker();
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder:
          (context) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Camera'),
                  onTap: () => Navigator.pop(context, ImageSource.camera),
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Gallery'),
                  onTap: () => Navigator.pop(context, ImageSource.gallery),
                ),
              ],
            ),
          ),
    );
    if (source != null) {
      final picked = await picker.pickImage(source: source, imageQuality: 80);
      if (picked != null) {
        setState(() {
          profileImage = File(picked.path);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final skilledWorkerProvider = Provider.of<SkilledWorkerProvider>(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
            child: Card(
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
                    const Text(
                      'Profile Setup',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.green,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          GestureDetector(
                            onTap: pickProfileImage,
                            child: CircleAvatar(
                              radius: size.width * 0.18,
                              backgroundColor: Colors.grey.shade100,
                              backgroundImage:
                                  profileImage != null
                                      ? FileImage(profileImage!)
                                      : null,
                              child:
                                  profileImage == null
                                      ? const Icon(
                                        Icons.person,
                                        size: 60,
                                        color: Colors.grey,
                                      )
                                      : null,
                            ),
                          ),
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.camera_alt,
                                color: AppColors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(hintText: 'Full Name'),
                    ),
                    const SizedBox(height: 18),
                    TextField(
                      controller: ageController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(hintText: 'Age'),
                    ),
                    const SizedBox(height: 18),
                    TextField(
                      controller: cityController,
                      decoration: const InputDecoration(hintText: 'City'),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Working Radius',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${workingRadius.toInt()} KM',
                          style: const TextStyle(
                            color: AppColors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: workingRadius,
                      min: 1,
                      max: 50,
                      divisions: 49,
                      label: '${workingRadius.toInt()} KM',
                      activeColor: AppColors.green,
                      onChanged: (value) {
                        setState(() {
                          workingRadius = value;
                        });
                      },
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed:
                            skilledWorkerProvider.isLoading
                                ? null
                                : () async {
                                  final name = nameController.text.trim();
                                  final age =
                                      int.tryParse(ageController.text.trim()) ??
                                      0;
                                  final city = cityController.text.trim();
                                  await skilledWorkerProvider.postSkilledWorker(
                                    name: name,
                                    // You can pass the phone from provider or previous step
                                    age: age,
                                    city: city,
                                  );
                                  if (skilledWorkerProvider.success != null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          skilledWorkerProvider.success!,
                                        ),
                                        behavior: SnackBarBehavior.floating,
                                        margin: const EdgeInsets.only(
                                          top: 16,
                                          left: 16,
                                          right: 16,
                                        ),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                    nameController.clear();
                                    ageController.clear();
                                    cityController.clear();
                                    skilledWorkerProvider.clearStatus();
                                  } else if (skilledWorkerProvider.error !=
                                      null) {
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
                                    skilledWorkerProvider.clearStatus();
                                  }
                                },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 2,
                        ),
                        child:
                            skilledWorkerProvider.isLoading
                                ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                : const Text(
                                  'Finish',
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
          ),
        ),
      ),
    );
  }
}
