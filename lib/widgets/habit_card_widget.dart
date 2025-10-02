import 'package:flutter/material.dart';
import 'package:habit_tracker/models/habit.dart';

class HabitCardWidget extends StatelessWidget {
  final Habit habit;
  final DateTime selectedDate;
  final VoidCallback onTap;
  final String category;
  final String progress;
  final String goal;
  final int streakCount;

  const HabitCardWidget({
    Key? key,
    required this.habit,
    required this.selectedDate,
    required this.onTap,
    required this.category,
    required this.progress,
    required this.goal,
    required this.streakCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isCompleted = habit.isCompletedOnDate(selectedDate);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isCompleted
                ? [habit.color, habit.color.withOpacity(0.8)]
                : [Color(0xFF1E293B), Color(0xFF1E293B).withOpacity(0.95)],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isCompleted
                ? Colors.white.withOpacity(0.2)
                : Colors.white.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isCompleted
                  ? habit.color.withOpacity(0.3)
                  : Colors.black.withOpacity(0.2),
              blurRadius: isCompleted ? 16 : 10,
              offset: Offset(0, isCompleted ? 6 : 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Icon container
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? Colors.white.withOpacity(0.2)
                        : habit.color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isCompleted
                          ? Colors.white.withOpacity(0.3)
                          : habit.color.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    habit.icon,
                    color: isCompleted ? Colors.white : habit.color,
                    size: 28,
                  ),
                ),

                SizedBox(width: 16),

                // Title and subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        habit.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: -0.3,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        habit.subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: isCompleted
                              ? Colors.white.withOpacity(0.8)
                              : Colors.white54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 12),

                // Checkbox
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isCompleted ? Colors.white : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isCompleted
                          ? Colors.white
                          : Colors.white.withOpacity(0.4),
                      width: 2.5,
                    ),
                  ),
                  child: isCompleted
                      ? Icon(Icons.check_rounded, color: habit.color, size: 20)
                      : null,
                ),
              ],
            ),

            SizedBox(height: 16),

            // Bottom info row
            Row(
              children: [
                // Category badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? Colors.white.withOpacity(0.2)
                        : habit.color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isCompleted
                          ? Colors.white.withOpacity(0.3)
                          : habit.color.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isCompleted ? Colors.white : habit.color,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),

                SizedBox(width: 8),

                // Frequency description
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        size: 11,
                        color: Colors.white.withOpacity(0.7),
                      ),
                      SizedBox(width: 4),
                      Text(
                        habit.getFrequencyDescription(),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),

                Spacer(),

                // Progress
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.trending_up_rounded,
                        size: 12,
                        color: Colors.white.withOpacity(0.7),
                      ),
                      SizedBox(width: 4),
                      Text(
                        progress,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 8),

                // Streak
                if (streakCount > 0)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    decoration: BoxDecoration(
                      color: Color(0xFFFBBF24).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Color(0xFFFBBF24).withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.local_fire_department_rounded,
                          size: 12,
                          color: Color(0xFFFBBF24),
                        ),
                        SizedBox(width: 4),
                        Text(
                          streakCount.toString(),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFFBBF24),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
