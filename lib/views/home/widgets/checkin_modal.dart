import 'package:flutter/material.dart';
import '../../../configs/app_colors.dart';
// import '../../../configs/app_theme.dart'; // Unused
import '../../../models/activity_model.dart';
import '../../../controllers/activity_controller.dart';
import 'package:provider/provider.dart';

class CheckInModal extends StatefulWidget {
  const CheckInModal({super.key});

  @override
  State<CheckInModal> createState() => _CheckInModalState();
}

class _CheckInModalState extends State<CheckInModal> {
  Mood? _selectedMood;
  final List<String> _selectedTags = [];

  // Hardcoded for now, will allow custom tags later (NFR3)
  final Map<String, List<String>> _tagCategories = {
    'Where?': ['Home', 'Company', 'Road', 'Coffee'],
    'What?': ['Meeting', 'Code', 'Facebook', 'Eating', 'Deadline'],
    'With whom?': ['Family', 'Alone', 'Boss', 'Colleague', 'Wife'],
  };

  void _onSave() {
    if (_selectedMood == null) return;

    // Call Controller
    context.read<ActivityController>().addLog(
          _selectedMood!,
          _selectedTags,
          "Check-in at ${DateTime.now().hour}:${DateTime.now().minute}",
        );

    Navigator.pop(context); // Close modal
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height *
          0.9, // 90% height like Figma image
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[700],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Title
          Center(
            child: Image.asset(
              'assets/images/logo_white.png',
              width: 50, // Adjust size as needed
              height: 50,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "How do you feel?",
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          // Mood Grid
          Expanded(
            flex: 0,
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.8,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: Mood.values.length,
              itemBuilder: (context, index) {
                final mood = Mood.values[index];
                final isSelected = _selectedMood == mood;
                return GestureDetector(
                  onTap: () => setState(() => _selectedMood = mood),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withOpacity(0.2)
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: isSelected
                          ? Border.all(color: AppColors.primary, width: 2)
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Placeholder Icon (Use images in real app)
                        const CircleAvatar(
                          radius: 20,
                          backgroundColor:
                              Colors.white, // Placeholder for Emoji Image
                          child: Icon(Icons.face, color: Colors.black),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          mood.label,
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(
                                color:
                                    isSelected ? AppColors.white : Colors.grey,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // Tags Sections (Scrollable)
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: _tagCategories.entries.map((entry) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(entry.key,
                          style: Theme.of(context).textTheme.labelMedium),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: entry.value.map((tag) {
                          final isSelected = _selectedTags.contains(tag);
                          return FilterChip(
                            label: Text(tag),
                            selected: isSelected,
                            onSelected: (bool selected) {
                              setState(() {
                                if (selected) {
                                  _selectedTags.add(tag);
                                } else {
                                  _selectedTags.remove(tag);
                                }
                              });
                            },
                            backgroundColor: Colors.white,
                            selectedColor: AppColors.primary,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide.none,
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),

          // Save Button
          if (_selectedMood != null)
            ElevatedButton(
              onPressed: _onSave,
              child: const Text("SAVE CHECK-IN"),
            ),
        ],
      ),
    );
  }
}
