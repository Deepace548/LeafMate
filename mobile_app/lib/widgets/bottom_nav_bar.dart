import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class LeafBottomNavBar extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;

  const LeafBottomNavBar({
    super.key,
    required this.index,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: index,
      onTap: onChanged,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: const Color(0xFFBBBBBB),
      backgroundColor: AppColors.white,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
      ],
    );
  }
}