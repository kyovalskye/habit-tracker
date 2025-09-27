import 'package:flutter/material.dart';

class Habit {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  bool isCompleted;

  Habit({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.isCompleted = false,
  });
}
