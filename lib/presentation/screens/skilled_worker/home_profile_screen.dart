import 'package:flutter/material.dart';

class SkilledWorkerHomeProfileScreen extends StatefulWidget {
  const SkilledWorkerHomeProfileScreen({super.key});

  @override
  State<SkilledWorkerHomeProfileScreen> createState() =>
      _SkilledWorkerHomeProfileScreenState();
}

class _SkilledWorkerHomeProfileScreenState
    extends State<SkilledWorkerHomeProfileScreen> {
  final List<String> allCategories = [
    'Plumber',
    'Electrician',
    'Carpenter',
    'Painter',
    'Welder',
    'Mason',
  ];
  final Set<String> selectedCategories = {};
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final List<String> portfolioImages = [];

  @override
  void dispose() {
    experienceController.dispose();
    bioController.dispose();
    super.dispose();
  }

  void addPortfolioImage() {
    // For now, add a static image URL for testing
    setState(() {
      portfolioImages.add('https://via.placeholder.com/120x80?text=Portfolio');
    });
  }

  void removePortfolioImage(int index) {
    setState(() {
      portfolioImages.removeAt(index);
    });
  }

  void saveProfile() {
    if (selectedCategories.isEmpty ||
        experienceController.text.isEmpty ||
        bioController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill all fields and select at least one category.',
          ),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(top: 16, left: 16, right: 16),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    // Here you would save to Firestore
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile saved successfully!'),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(top: 16, left: 16, right: 16),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Skill Profile Setup'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.08,
          vertical: 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Categories',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children:
                  allCategories.map((cat) {
                    final selected = selectedCategories.contains(cat);
                    return FilterChip(
                      label: Text(cat),
                      selected: selected,
                      selectedColor: Colors.green.shade100,
                      onSelected: (val) {
                        setState(() {
                          if (val) {
                            selectedCategories.add(cat);
                          } else {
                            selectedCategories.remove(cat);
                          }
                        });
                      },
                    );
                  }).toList(),
            ),
            const SizedBox(height: 24),
            const Text(
              'Years of Experience',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: experienceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'e.g. 5'),
            ),
            const SizedBox(height: 24),
            const Text(
              'Short Bio',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: bioController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Tell us about your skills and experience',
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Portfolio Pictures',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 90,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  GestureDetector(
                    onTap: addPortfolioImage,
                    child: Container(
                      width: 80,
                      height: 80,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green, width: 2),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.green,
                        size: 36,
                      ),
                    ),
                  ),
                  ...List.generate(portfolioImages.length, (index) {
                    return Stack(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              portfolioImages[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 2,
                          right: 2,
                          child: GestureDetector(
                            onTap: () => removePortfolioImage(index),
                            child: const CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.close,
                                size: 16,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Save',
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
    );
  }
}
