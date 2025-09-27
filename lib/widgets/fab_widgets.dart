import 'package:flutter/material.dart';

class FABWidgets extends StatelessWidget {
  final VoidCallback onAdd;
  const FABWidgets({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      width: 80,
      child: FloatingActionButton(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100)
        ),
        child: Icon(Icons.add),      
        onPressed: (){
          onAdd();
        },
      ),
    );
  }
}