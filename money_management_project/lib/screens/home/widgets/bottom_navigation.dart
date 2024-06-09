import 'package:flutter/material.dart';
import 'package:money_management_project/screens/home/screen_home.dart';

class HomeBottomNavigation extends StatelessWidget {
  const HomeBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ScreenHome.selectedBottomIndex,
      builder: (BuildContext ctx, int updatedIndex, Widget? _) {
        return BottomNavigationBar(
          // type: BottomNavigationBarType.fixed,
          currentIndex: updatedIndex,
          onTap: (newIndex) {
            ScreenHome.selectedBottomIndex.value = newIndex;
          },
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey.shade600,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.category_rounded), label: 'Category'),
            BottomNavigationBarItem(icon: Icon(Icons.attach_money), label: 'Debt'),
            BottomNavigationBarItem(icon: Icon(Icons.note), label: 'Notes'), // Add the new item
          ],
        );
      },
    );
  }
}