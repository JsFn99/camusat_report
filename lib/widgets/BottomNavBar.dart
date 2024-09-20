import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const BottomNavBar({super.key, required this.selectedIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.table_chart),
          label: 'Excels',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.file_open_outlined),
          label: 'Rapports',
        ),
      ],
      currentIndex: selectedIndex,
      onTap: onTap,
    );
  }
}
