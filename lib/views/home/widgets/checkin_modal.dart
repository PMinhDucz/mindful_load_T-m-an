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
  String _note = "";

  // Hardcoded map removed. Using Controller data.

  void _showAddTagDialog(String category, ActivityController controller) {
    String newTag = "";
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C2C2E),
        title: Text("Add to $category",
            style: const TextStyle(color: Colors.white)),
        content: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "Enter tag name",
            hintStyle: TextStyle(color: Colors.white54),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white54)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green)),
          ),
          onChanged: (value) => newTag = value,
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text("Add", style: TextStyle(color: AppColors.primary)),
            onPressed: () {
              if (newTag.isNotEmpty) {
                // Check duplicate
                if (controller.tagCategories[category]!.contains(newTag)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Tag already exists!")));
                  return;
                }

                controller.addCustomTag(category, newTag);
                setState(() {
                  _selectedTags.add(newTag);
                });
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteTagDialog(
      String category, String tag, ActivityController controller) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF2C2C2E),
        title: const Text("Delete Tag", style: TextStyle(color: Colors.white)),
        content: Text("Are you sure you want to remove '$tag'?",
            style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(ctx),
          ),
          TextButton(
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
            onPressed: () {
              controller.removeCustomTag(category, tag);
              setState(() {
                _selectedTags.remove(tag); // Unselect if it was selected
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("Removed '$tag'")));
            },
          ),
        ],
      ),
    );
  }

  void _onSave() {
    if (_selectedMood == null) return;

    // Call Controller
    context.read<ActivityController>().addLog(
          _selectedMood!,
          _selectedTags,
          _note.isNotEmpty ? _note : null,
        );

    Navigator.pop(context); // Close modal
  }

  IconData _getMoodIcon(Mood mood) {
    switch (mood) {
      case Mood.good:
        return Icons.sentiment_very_satisfied;
      case Mood.neutral:
        return Icons.sentiment_neutral;
      case Mood.sad:
        return Icons.sentiment_dissatisfied;
      case Mood.angry:
        return Icons.sentiment_very_dissatisfied;
      case Mood.anxious:
        return Icons.sick_outlined; // Or Icons.sentiment_satisfied_alt
      case Mood.stress:
        return Icons.battery_alert;
    }
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
          const SizedBox(height: 10),

          // SCROLLABLE CONTENT (Mood + Tags)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  // Title & Logo
                  const SizedBox(height: 10),
                  Image.asset(
                    'assets/images/logo_white.png',
                    width: 50,
                    height: 50,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Bạn đang cảm thấy thế nào?",
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // Mood Grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFF2C2C2E), // Dark card background
                            borderRadius: BorderRadius.circular(24),
                            border: isSelected
                                ? Border.all(color: Colors.white, width: 2)
                                : null,
                          ),
                          child: Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              // "Bookmark" Shape Background
                              Container(
                                width: 50,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.vertical(
                                      bottom: Radius.circular(25)),
                                ),
                              ),
                              // Content
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10),
                                  // Emoji Circle (Placeholder)
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: mood.color.withOpacity(0.3),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      _getMoodIcon(mood),
                                      color: mood.color,
                                      size: 32, // Increased size
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    mood.label,
                                    style: const TextStyle(
                                      color: Colors
                                          .white, // Pure white for better contrast
                                      fontSize: 13,
                                      fontWeight:
                                          FontWeight.w600, // Thicker font
                                      height: 1.2,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 30),

                  // Tags Sections
                  Consumer<ActivityController>(
                    builder: (context, controller, child) {
                      return Column(
                        children: controller.tagCategories.entries.map((entry) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(entry.key,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium),
                              ),
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    ...entry.value.map((tag) {
                                      final isSelected =
                                          _selectedTags.contains(tag);
                                      return GestureDetector(
                                        onLongPress: () {
                                          _showDeleteTagDialog(
                                              entry.key, tag, controller);
                                        },
                                        child: FilterChip(
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
                                            color: isSelected
                                                ? Colors.white
                                                : Colors.black,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            side: BorderSide.none,
                                          ),
                                        ),
                                      );
                                    }),
                                    // Add "+" Button
                                    ActionChip(
                                      label: Icon(Icons.add,
                                          size: 18, color: Colors.black),
                                      padding: EdgeInsets.zero,
                                      backgroundColor: Colors.white,
                                      shape: CircleBorder(), // Circular shape
                                      onPressed: () {
                                        _showAddTagDialog(
                                            entry.key, controller);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          );
                        }).toList(),
                      );
                    },
                  ),

                  // Note Section (Micro-Journal)
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Note (Optional)",
                        style: Theme.of(context).textTheme.labelMedium),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    style: const TextStyle(
                        color: Colors.black), // FIX: Force Black Text
                    decoration: InputDecoration(
                      hintText: "Why do you feel this way?",
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                    onChanged: (value) {
                      _note = value;
                    },
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ),

          // Save Button (Fixed at Bottom)
          if (_selectedMood != null)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _onSave,
                  child: const Text("SAVE CHECK-IN",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
