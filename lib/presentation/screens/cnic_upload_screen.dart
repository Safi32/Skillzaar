import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import '../providers/cnic_provider.dart';

class CnicUploadScreen extends StatelessWidget {
  const CnicUploadScreen({super.key});

  Future<void> pickImage(BuildContext context, bool isFront) async {
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
        final provider = Provider.of<CnicProvider>(context, listen: false);
        if (isFront) {
          provider.setFrontImage(File(picked.path));
        } else {
          provider.setBackImage(File(picked.path));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cnicProvider = Provider.of<CnicProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Upload CNIC'), centerTitle: true),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: size.height * 0.04),
            const Text('Upload CNIC (National ID)'),
            SizedBox(height: size.height * 0.03),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _CnicImagePicker(
                  label: 'Front',
                  image: cnicProvider.frontImage,
                  onTap: () => pickImage(context, true),
                ),
                _CnicImagePicker(
                  label: 'Back',
                  image: cnicProvider.backImage,
                  onTap: () => pickImage(context, false),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.04),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/profile-setup');
                },
                child: const Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CnicImagePicker extends StatelessWidget {
  final String label;
  final File? image;
  final VoidCallback onTap;
  const _CnicImagePicker({
    required this.label,
    this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: size.width * 0.28,
            height: size.width * 0.18,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade400),
            ),
            child:
                image != null
                    ? Image.file(image!, fit: BoxFit.cover)
                    : const Icon(
                      Icons.add_a_photo,
                      size: 40,
                      color: Colors.grey,
                    ),
          ),
        ),
        SizedBox(height: 8),
        Text(label),
      ],
    );
  }
}
