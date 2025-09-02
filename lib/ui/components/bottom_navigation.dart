import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      selectedItemColor: Colors.red,
      unselectedItemColor: Colors.grey,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Explore',
        ),
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.account_balance_wallet_outlined),
        //   activeIcon: Icon(Icons.account_balance_wallet),
        //   label: 'Demat',
        // ),
        BottomNavigationBarItem(
          icon: Icon(Icons.data_exploration_outlined),
          activeIcon: Icon(Icons.data_exploration),
          label: 'Trades', // center icon has no label
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.data_exploration_outlined),
          activeIcon: Icon(Icons.data_exploration),
          label: 'Screeners', // center icon has no label
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      type: BottomNavigationBarType.fixed,
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
    );
  }
}
