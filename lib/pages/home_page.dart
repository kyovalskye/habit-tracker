import 'package:flutter/material.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:habit_tracker/widgets/add_habit_dialog.dart';
import 'package:habit_tracker/widgets/bottom_appbar_widget.dart';
import 'package:habit_tracker/widgets/completed_habit_widget.dart';
import 'package:habit_tracker/widgets/date_card_widget.dart';
import 'package:habit_tracker/widgets/habit_card_widget.dart';
import 'package:habit_tracker/widgets/header_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Habit> habits = [];

  final List<IconData> availableIcons = [
    Icons.fitness_center,
    Icons.book_outlined,
    Icons.water_drop_outlined,
    Icons.bedtime_outlined,
    Icons.directions_run_outlined,
    Icons.restaurant_outlined,
    Icons.work_outline,
    Icons.school_outlined,
    Icons.music_note_outlined,
    Icons.brush_outlined,
    Icons.camera_alt_outlined,
    Icons.favorite_outline,
    Icons.lightbulb_outline,
    Icons.psychology_outlined,
    Icons.eco_outlined,
    Icons.accessibility_new_outlined,
  ];

  final List<Color> availableColors = [
    Color(0xFF2563EB), // Blue
    Color(0xFF059669), // Emerald
    Color(0xFFDC2626), // Red
    Color(0xFF7C3AED), // Violet
    Color(0xFFEA580C), // Orange
    Color(0xFF0891B2), // Cyan
    Color(0xFFBE123C), // Rose
    Color(0xFF4338CA), // Indigo
    Color(0xFF15803D), // Green
    Color(0xFFDB2777), // Pink
    Color(0xFF9333EA), // Purple
    Color(0xFF0F766E), // Teal
  ];

  void _toggleHabit(int index) {
    setState(() {
      habits[index].isCompleted = !habits[index].isCompleted;
    });
  }

  void _showAddHabitDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddHabitBottomSheet(
        availableIcons: availableIcons,
        availableColors: availableColors,
        onAddHabit: _addNewHabit,
      ),
    );
  }

  void _addNewHabit(String title, String subtitle, IconData icon, Color color) {
    setState(() {
      habits.add(
        Habit(title: title, subtitle: subtitle, icon: icon, color: color),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Habit> upcomingHabits = habits.where((h) => !h.isCompleted).toList();
    List<Habit> completedHabits = habits.where((h) => h.isCompleted).toList();

    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            HeaderWidget(),
            DateCardWidget(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (habits.isEmpty) ...[
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(48),
                        child: Column(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Color(0xFFF3F4F6),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Icon(
                                Icons.add_task_rounded,
                                size: 36,
                                color: Color(0xFF9CA3AF),
                              ),
                            ),
                            SizedBox(height: 24),
                            Text(
                              "No habits yet",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF111827),
                                letterSpacing: -0.2,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Create your first habit to get started",
                              style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFF6B7280),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      if (upcomingHabits.isNotEmpty) ...[
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Today",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF111827),
                                  letterSpacing: -0.3,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Color(0xFFF3F4F6),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  "${upcomingHabits.length}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        ...upcomingHabits.asMap().entries.map((entry) {
                          int index = habits.indexOf(entry.value);
                          return HabitCardWidget(
                            habit: entry.value,
                            onTap: () => _toggleHabit(index),
                          );
                        }),
                      ],

                      if (completedHabits.isNotEmpty) ...[
                        SizedBox(height: 32),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            children: [
                              Text(
                                "Completed",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF111827),
                                  letterSpacing: -0.3,
                                ),
                              ),
                              SizedBox(width: 8),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Color(0xFF059669),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  "${completedHabits.length}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        ...completedHabits.asMap().entries.map((entry) {
                          int index = habits.indexOf(entry.value);
                          return CompletedHabitWidget(
                            habit: entry.value,
                            onTap: () => _toggleHabit(index),
                          );
                        }),
                      ],
                    ],
                    SizedBox(height: 100), // Space for FAB
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppbarWidget(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        width: 56,
        height: 56,
        child: FloatingActionButton(
          onPressed: _showAddHabitDialog,
          backgroundColor: Color(0xFF111827),
          elevation: 4,
          child: Icon(Icons.add_rounded, color: Colors.white, size: 28),
        ),
      ),
    );
  }
}
