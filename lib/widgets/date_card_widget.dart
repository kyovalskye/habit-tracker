import 'package:flutter/material.dart';

class DateCardWidget extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateChanged;
  final Set<int> daysWithCompletedHabits;

  const DateCardWidget({
    Key? key,
    required this.selectedDate,
    required this.onDateChanged,
    required this.daysWithCompletedHabits,
  }) : super(key: key);

  @override
  State<DateCardWidget> createState() => _DateCardWidgetState();
}

class _DateCardWidgetState extends State<DateCardWidget> {
  late DateTime displayMonth;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    displayMonth = DateTime(
      widget.selectedDate.year,
      widget.selectedDate.month,
    );
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDate();
    });
  }

  @override
  void didUpdateWidget(DateCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update display month if selected date changed to different month
    if (oldWidget.selectedDate.month != widget.selectedDate.month ||
        oldWidget.selectedDate.year != widget.selectedDate.year) {
      setState(() {
        displayMonth = DateTime(
          widget.selectedDate.year,
          widget.selectedDate.month,
        );
      });

      Future.delayed(Duration(milliseconds: 100), () {
        _scrollToSelectedDate();
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSelectedDate() {
    if (_scrollController.hasClients) {
      final firstDayOfMonth = DateTime(
        displayMonth.year,
        displayMonth.month,
        1,
      );
      final startWeekday = firstDayOfMonth.weekday % 7;
      final selectedDay = widget.selectedDate.day;

      final scrollPosition = (startWeekday + selectedDay - 3) * 60.0;

      _scrollController.animateTo(
        scrollPosition.clamp(0.0, _scrollController.position.maxScrollExtent),
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _changeMonth(int direction) {
    setState(() {
      displayMonth = DateTime(
        displayMonth.year,
        displayMonth.month + direction,
      );
    });

    // Set selected date to first day of new month
    DateTime newSelectedDate = DateTime(
      displayMonth.year,
      displayMonth.month,
      1,
    );
    widget.onDateChanged(newSelectedDate);

    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      height: 140,
      decoration: BoxDecoration(
        color: Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with Month/Year and navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.chevron_left, color: Colors.white70, size: 22),
                onPressed: () => _changeMonth(-1),
                padding: EdgeInsets.all(4),
                constraints: BoxConstraints(minWidth: 32, minHeight: 32),
                splashRadius: 20,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.calendar_month_rounded,
                    color: Color(0xFF3B82F6),
                    size: 18,
                  ),
                  SizedBox(width: 6),
                  Text(
                    _getMonthYear(displayMonth),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(
                  Icons.chevron_right,
                  color: Colors.white70,
                  size: 22,
                ),
                onPressed: () => _changeMonth(1),
                padding: EdgeInsets.all(4),
                constraints: BoxConstraints(minWidth: 32, minHeight: 32),
                splashRadius: 20,
              ),
            ],
          ),

          SizedBox(height: 12),

          // Day names header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                .map(
                  (day) => SizedBox(
                    width: 54,
                    child: Text(
                      day,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white38,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),

          SizedBox(height: 8),

          // Horizontal scrollable dates
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              itemCount: _getTotalDaysToShow(),
              itemBuilder: (context, index) {
                return _buildDateItem(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  int _getTotalDaysToShow() {
    final firstDayOfMonth = DateTime(displayMonth.year, displayMonth.month, 1);
    final lastDayOfMonth = DateTime(
      displayMonth.year,
      displayMonth.month + 1,
      0,
    );
    final startWeekday = firstDayOfMonth.weekday % 7;
    final nextMonthDays = 7;

    return startWeekday + lastDayOfMonth.day + nextMonthDays;
  }

  Widget _buildDateItem(int index) {
    final firstDayOfMonth = DateTime(displayMonth.year, displayMonth.month, 1);
    final lastDayOfMonth = DateTime(
      displayMonth.year,
      displayMonth.month + 1,
      0,
    );
    final startWeekday = firstDayOfMonth.weekday % 7;
    final daysInMonth = lastDayOfMonth.day;

    DateTime date;
    int day;
    bool isCurrentMonth = true;

    // Previous month dates
    if (index < startWeekday) {
      final prevMonth = DateTime(displayMonth.year, displayMonth.month - 1);
      final prevMonthLastDay = DateTime(
        displayMonth.year,
        displayMonth.month,
        0,
      ).day;
      day = prevMonthLastDay - (startWeekday - index - 1);
      date = DateTime(prevMonth.year, prevMonth.month, day);
      isCurrentMonth = false;
    }
    // Next month dates
    else if (index >= startWeekday + daysInMonth) {
      day = index - startWeekday - daysInMonth + 1;
      date = DateTime(displayMonth.year, displayMonth.month + 1, day);
      isCurrentMonth = false;
    }
    // Current month dates
    else {
      day = index - startWeekday + 1;
      date = DateTime(displayMonth.year, displayMonth.month, day);
    }

    final isSelected =
        widget.selectedDate.year == date.year &&
        widget.selectedDate.month == date.month &&
        widget.selectedDate.day == date.day;

    final today = DateTime.now();
    final isToday =
        date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;

    // Only show dot if all habits completed AND it's current month
    final hasCompletedHabit =
        isCurrentMonth &&
        date.month == displayMonth.month &&
        widget.daysWithCompletedHabits.contains(day);

    return GestureDetector(
      onTap: () {
        widget.onDateChanged(date);

        // Animate scroll to selected date
        final scrollPosition = (index - 3) * 60.0;
        _scrollController.animateTo(
          scrollPosition.clamp(0.0, _scrollController.position.maxScrollExtent),
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        width: 54,
        margin: EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF5B7FED) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              day.toString(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected
                    ? Colors.white
                    : isToday
                    ? Colors.white
                    : isCurrentMonth
                    ? Colors.white70
                    : Colors.white38,
              ),
            ),
            SizedBox(height: 6),

            // Dot indicator for completed habits (all habits completed on that day)
            Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: hasCompletedHabit
                    ? (isSelected ? Colors.white : Color(0xFFFBBF24))
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getMonthYear(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}
