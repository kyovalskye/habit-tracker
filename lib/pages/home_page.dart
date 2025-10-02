import 'package:flutter/material.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:habit_tracker/widgets/add_habit_dialog.dart';
import 'package:habit_tracker/widgets/bottom_appbar_widget.dart';
import 'package:habit_tracker/widgets/date_card_widget.dart';
import 'package:habit_tracker/widgets/habit_card_widget.dart';
import 'package:habit_tracker/widgets/habit_stats_widget.dart';
import 'package:habit_tracker/widgets/header_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Habit> habits = [];
  DateTime selectedDate = DateTime.now();

  final List<IconData> availableIcons = [
    Icons.water_drop,
    Icons.fitness_center,
    Icons.book,
    Icons.self_improvement,
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
  ];

  final List<Color> availableColors = [
    Color(0xFF22D3EE), // Cyan
    Color(0xFFEF4444), // Red
    Color(0xFF10B981), // Green
    Color(0xFFA855F7), // Purple
    Color(0xFF3B82F6), // Blue
    Color(0xFFF59E0B), // Amber
    Color(0xFFEC4899), // Pink
    Color(0xFF8B5CF6), // Violet
    Color(0xFF14B8A6), // Teal
    Color(0xFFF97316), // Orange
  ];

  @override
  void initState() {
    super.initState();
    _loadSampleHabits();
  }

  void _loadSampleHabits() {
    habits = [
      Habit(
        id: '1',
        title: 'Drink Water',
        subtitle: 'Stay hydrated throughout the day',
        icon: Icons.water_drop,
        color: Color(0xFF22D3EE),
        frequencyType: HabitFrequencyType.specificDays,
        specificWeekDays: [1, 2, 3, 4, 5, 6, 7], // Every day
      ),
      Habit(
        id: '2',
        title: 'Exercise',
        subtitle: 'Physical activity for 30 minutes',
        icon: Icons.fitness_center,
        color: Color(0xFFEF4444),
        frequencyType: HabitFrequencyType.daysPerWeek,
        targetDaysPerWeek: 5,
      ),
      Habit(
        id: '3',
        title: 'Read',
        subtitle: 'Read for personal development',
        icon: Icons.book,
        color: Color(0xFF10B981),
        frequencyType: HabitFrequencyType.specificDays,
        specificWeekDays: [1, 3, 5], // Mon, Wed, Fri
      ),
      Habit(
        id: '4',
        title: 'Meditate',
        subtitle: 'Mindfulness and meditation practice',
        icon: Icons.self_improvement,
        color: Color(0xFFA855F7),
        frequencyType: HabitFrequencyType.daysPerWeek,
        targetDaysPerWeek: 7,
      ),
    ];
  }

  // Get habits scheduled for selected date
  List<Habit> _getHabitsForDate(DateTime date) {
    return habits.where((habit) => habit.isScheduledForDate(date)).toList();
  }

  void _toggleHabit(Habit habit) {
    setState(() {
      habit.toggleCompletion(selectedDate);
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

  void _addNewHabit(Habit habit) {
    setState(() {
      habits.add(habit);
    });
  }

  void _onDateChanged(DateTime newDate) {
    setState(() {
      selectedDate = newDate;
    });
  }

  String _getCategoryForHabit(String title) {
    String lower = title.toLowerCase();
    if (lower.contains('water') || lower.contains('health')) return 'Health';
    if (lower.contains('exercise') ||
        lower.contains('run') ||
        lower.contains('gym'))
      return 'Fitness';
    if (lower.contains('read') ||
        lower.contains('learn') ||
        lower.contains('study'))
      return 'Learning';
    if (lower.contains('meditate') ||
        lower.contains('yoga') ||
        lower.contains('mindful'))
      return 'Mindfulness';
    return 'Health';
  }

  String _getGoalForHabit(String title) {
    String lower = title.toLowerCase();
    if (lower.contains('water')) return 'Goal: 8 glasses';
    if (lower.contains('exercise')) return 'Goal: 30 minutes';
    if (lower.contains('read')) return 'Goal: 20 pages';
    if (lower.contains('meditate')) return 'Goal: 10 minutes';
    return 'Daily goal';
  }

  int _getCurrentStreak() {
    int totalStreak = 0;
    for (var habit in habits) {
      totalStreak += habit.getCurrentStreak();
    }
    return totalStreak;
  }

  int _getTotalHabits() {
    return habits.length;
  }

  // Check if all habits for a date are completed
  bool _areAllHabitsCompletedForDate(DateTime date) {
    List<Habit> scheduledHabits = _getHabitsForDate(date);
    if (scheduledHabits.isEmpty) return false;

    return scheduledHabits.every((habit) => habit.isCompletedOnDate(date));
  }

  // Get dates with completed habits for calendar
  Set<int> _getDaysWithCompletedHabits(DateTime month) {
    Set<int> days = {};
    int daysInMonth = DateTime(month.year, month.month + 1, 0).day;

    for (int day = 1; day <= daysInMonth; day++) {
      DateTime date = DateTime(month.year, month.month, day);
      if (_areAllHabitsCompletedForDate(date)) {
        days.add(day);
      }
    }

    return days;
  }

  @override
  Widget build(BuildContext context) {
    List<Habit> todayHabits = _getHabitsForDate(selectedDate);
    int completedToday = todayHabits
        .where((h) => h.isCompletedOnDate(selectedDate))
        .length;
    int totalHabitsToday = todayHabits.length;
    double completionRate = totalHabitsToday > 0
        ? (completedToday / totalHabitsToday * 100)
        : 0;

    return Scaffold(
      backgroundColor: Color(0xFF0F172A),
      body: SafeArea(
        child: Column(
          children: [
            // Header with date and streak
            HeaderWidget(
              selectedDate: selectedDate,
              completedToday: completedToday,
            ),

            Expanded(
              child: Container(
                decoration: BoxDecoration(color: Color(0xFF0F172A)),
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(top: 0, bottom: 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Stats Cards
                      HabitStatsWidget(
                        streakCount: _getCurrentStreak(),
                        completionRate: completionRate,
                        totalHabits: _getTotalHabits(),
                      ),

                      SizedBox(height: 24),

                      // Calendar
                      DateCardWidget(
                        selectedDate: selectedDate,
                        onDateChanged: _onDateChanged,
                        daysWithCompletedHabits: _getDaysWithCompletedHabits(
                          selectedDate,
                        ),
                      ),

                      SizedBox(height: 24),

                      // Daily Progress Card
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Color(0xFF1E293B),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Daily Progress',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    '${completionRate.toInt()}%',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF3B82F6),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: LinearProgressIndicator(
                                  value: completionRate / 100,
                                  backgroundColor: Colors.white.withOpacity(
                                    0.1,
                                  ),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFF3B82F6),
                                  ),
                                  minHeight: 8,
                                ),
                              ),
                              SizedBox(height: 12),
                              Text(
                                '$completedToday of $totalHabitsToday habits completed',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 28),

                      // Habits Section Title
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          selectedDate.day == DateTime.now().day &&
                                  selectedDate.month == DateTime.now().month &&
                                  selectedDate.year == DateTime.now().year
                              ? "Today's Habits"
                              : "${_getFormattedDateShort(selectedDate)}'s Habits",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      SizedBox(height: 16),

                      // Habits List
                      if (todayHabits.isEmpty) ...[
                        Padding(
                          padding: EdgeInsets.all(40),
                          child: Column(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Color(0xFF1E293B),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Icon(
                                  Icons.event_busy_rounded,
                                  size: 48,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                              SizedBox(height: 24),
                              Text(
                                "No habits scheduled",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "No habits are scheduled for this day",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else ...[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: todayHabits.map((habit) {
                              String category = _getCategoryForHabit(
                                habit.title,
                              );
                              String progress = habit.getProgressText(
                                selectedDate,
                              );
                              String goal = _getGoalForHabit(habit.title);
                              int streak = habit.getCurrentStreak();

                              return HabitCardWidget(
                                habit: habit,
                                selectedDate: selectedDate,
                                onTap: () => _toggleHabit(habit),
                                category: category,
                                progress: progress,
                                goal: goal,
                                streakCount: streak,
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppbarWidget(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF3B82F6).withOpacity(0.4),
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: _showAddHabitDialog,
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Icon(Icons.add_rounded, color: Colors.white, size: 32),
        ),
      ),
    );
  }

  String _getFormattedDateShort(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}';
  }
}
