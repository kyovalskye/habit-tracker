import 'package:flutter/material.dart';

class BottomAppbarWidget extends StatefulWidget {
   const BottomAppbarWidget({super.key});

  @override
  State<BottomAppbarWidget> createState() => _BottomAppbarWidgetState();
}

class _BottomAppbarWidgetState extends State<BottomAppbarWidget> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        shape:  CircularNotchedRectangle(),
        notchMargin: 8,
        color: Colors.grey[900],
        child: Container(
          height: 60,
          child:  Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.home, color: Colors.white),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.access_time, color: Colors.grey),
              ),
              SizedBox(width: 40), // Space for FAB
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.notifications, color: Colors.grey),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.person, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
  }
}