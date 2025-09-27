// import 'package:flutter/material.dart';
// import 'package:habit_tracker/widgets/date_card_widget.dart';
// import 'package:habit_tracker/widgets/fab_widgets.dart';
// import 'package:habit_tracker/widgets/habit_card_widget.dart';
// import 'package:habit_tracker/widgets/navbar_widget.dart';

// class Debug extends StatefulWidget {
//   const Debug({super.key});

//   @override
//   State<Debug> createState() => _DebugState();
// }

// class _DebugState extends State<Debug> {
//   final List<Widget> habitCard = [];

//   void _addCard() {
//     setState(() {
//       final i = habitCard.length;
//       habitCard.add(HabitCardWidget(index: i));
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       bottomNavigationBar: const NavbarWidget(),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       floatingActionButton: FABWidgets(onAdd: _addCard),
//       body: Column(
//         children: [
//           const DateCardWidget(),

//           Expanded(
//             child: SingleChildScrollView(child: Column(children: habitCard)),
//           ),
//         ],
//       ),
//     );
//   }
// }
