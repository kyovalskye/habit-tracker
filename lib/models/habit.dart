import 'package:flutter/material.dart';

enum HabitFrequencyType {
  specificDays, // Specific days in week
  daysPerWeek, // X days per week
  daysPerMonth, // X days per month
  daysPerYear, // X days per year
}

class Habit {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  // Scheduling properties
  final HabitFrequencyType frequencyType;
  final List<int> specificWeekDays; // 1=Monday, 7=Sunday
  final int targetDaysPerWeek;
  final int targetDaysPerMonth;
  final int targetDaysPerYear;

  // Completion tracking
  Map<String, bool> completionMap; // key: "yyyy-MM-dd", value: completed

  Habit({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.frequencyType,
    this.specificWeekDays = const [],
    this.targetDaysPerWeek = 0,
    this.targetDaysPerMonth = 0,
    this.targetDaysPerYear = 0,
    Map<String, bool>? completionMap,
  }) : completionMap = completionMap ?? {};

  // Check if habit is scheduled for a specific date
  bool isScheduledForDate(DateTime date) {
    switch (frequencyType) {
      case HabitFrequencyType.specificDays:
        int weekday = date.weekday;
        return specificWeekDays.contains(weekday);

      case HabitFrequencyType.daysPerWeek:
      case HabitFrequencyType.daysPerMonth:
      case HabitFrequencyType.daysPerYear:
        // For flexible schedules, habit is available every day
        // User chooses which days to complete
        return true;
    }
  }

  // Check if habit is completed on a specific date
  bool isCompletedOnDate(DateTime date) {
    String dateKey = _getDateKey(date);
    return completionMap[dateKey] ?? false;
  }

  // Toggle completion for a date
  void toggleCompletion(DateTime date) {
    String dateKey = _getDateKey(date);
    completionMap[dateKey] = !(completionMap[dateKey] ?? false);
  }

  // Get completion count for a period
  int getCompletionCountForWeek(DateTime weekStart) {
    int count = 0;
    for (int i = 0; i < 7; i++) {
      DateTime day = weekStart.add(Duration(days: i));
      if (isCompletedOnDate(day)) count++;
    }
    return count;
  }

  int getCompletionCountForMonth(DateTime month) {
    int count = 0;
    int daysInMonth = DateTime(month.year, month.month + 1, 0).day;

    for (int i = 1; i <= daysInMonth; i++) {
      DateTime day = DateTime(month.year, month.month, i);
      if (isCompletedOnDate(day)) count++;
    }
    return count;
  }

  int getCompletionCountForYear(DateTime year) {
    int count = 0;
    for (int month = 1; month <= 12; month++) {
      DateTime monthDate = DateTime(year.year, month);
      count += getCompletionCountForMonth(monthDate);
    }
    return count;
  }

  // Get current streak
  int getCurrentStreak() {
    DateTime today = DateTime.now();
    int streak = 0;

    for (int i = 0; i < 365; i++) {
      DateTime checkDate = today.subtract(Duration(days: i));

      // Skip if not scheduled for this date
      if (!isScheduledForDate(checkDate)) continue;

      if (isCompletedOnDate(checkDate)) {
        streak++;
      } else {
        break;
      }
    }

    return streak;
  }

  // Get progress text based on frequency type
  String getProgressText(DateTime date) {
    switch (frequencyType) {
      case HabitFrequencyType.specificDays:
        return isCompletedOnDate(date) ? '1/1' : '0/1';

      case HabitFrequencyType.daysPerWeek:
        DateTime weekStart = date.subtract(Duration(days: date.weekday - 1));
        int completed = getCompletionCountForWeek(weekStart);
        return '$completed/$targetDaysPerWeek';

      case HabitFrequencyType.daysPerMonth:
        DateTime monthStart = DateTime(date.year, date.month, 1);
        int completed = getCompletionCountForMonth(monthStart);
        return '$completed/$targetDaysPerMonth';

      case HabitFrequencyType.daysPerYear:
        DateTime yearStart = DateTime(date.year, 1, 1);
        int completed = getCompletionCountForYear(yearStart);
        return '$completed/$targetDaysPerYear';
    }
  }

  String _getDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  // Get frequency description
  String getFrequencyDescription() {
    switch (frequencyType) {
      case HabitFrequencyType.specificDays:
        List<String> dayNames = [
          'Mon',
          'Tue',
          'Wed',
          'Thu',
          'Fri',
          'Sat',
          'Sun',
        ];
        List<String> scheduledDays = specificWeekDays
            .map((day) => dayNames[day - 1])
            .toList();
        return scheduledDays.join(', ');

      case HabitFrequencyType.daysPerWeek:
        return '$targetDaysPerWeek days/week';

      case HabitFrequencyType.daysPerMonth:
        return '$targetDaysPerMonth days/month';

      case HabitFrequencyType.daysPerYear:
        return '$targetDaysPerYear days/year';
    }
  }
}
