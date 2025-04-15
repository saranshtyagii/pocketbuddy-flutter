import 'package:PocketBuddy/screens/GroupDetailsScreen.dart';
import 'package:PocketBuddy/services/PersonalExpenseService.dart';
import 'package:flutter/material.dart';

import '../mapper/PersonalExpenseData.dart';
import '../widgets/NoExpenseFoundWidget.dart';
import '../widgets/PersonalExpenseWidget.dart';
import 'SettingScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedNavIndex = 1;
  bool loadingExpenseData = false;
  bool hasExpenseData = false;

  final personalExpenseService = PersonalExpenseService();

  List<PersonalExpenseData> savedExpense = [];

  @override
  void initState() {
    super.initState();
    _refreshExpenseData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pocket Buddy")),
      bottomNavigationBar: BottomAppBar(
        padding: const EdgeInsets.only(top: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, Icons.home, 'Home'),
            _buildNavItem(1, Icons.group, 'Room'),
            _buildNavItem(2, Icons.analytics, 'Activity'),
            _buildNavItem(3, Icons.settings, 'Setting'),
          ],
        ),
      ),
      body:
          loadingExpenseData
              ? const Center(child: CircularProgressIndicator())
              : _buildHomeContent(),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    bool isActive = index == selectedNavIndex;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedNavIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        margin: const EdgeInsets.only(bottom: 6),
        decoration: BoxDecoration(
          color:
              isActive
                  ? Theme.of(context).colorScheme.secondaryContainer
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 28,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            Text(
              label,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeContent() {
    switch (selectedNavIndex) {
      case 0:
        return hasExpenseData
            ? PersonalExpenseWidget(
              refreshExpenseData: _refreshExpenseData,
              personalExpenseData: savedExpense,
            )
            : NoExpenseFoundWidget(refreshExpenseData: _refreshExpenseData);
      case 1:
        return GroupDetailsScreen();
      case 2:
      case 3:
        return SettingScreen();
      default:
        return const Center(child: Text("Page not found"));
    }
  }

  void _refreshExpenseData() async {
    _changeLoadingState();
    savedExpense = await personalExpenseService.fetchExpense();
    if (savedExpense.isNotEmpty) {
      hasExpenseData = true;
    } else {
      hasExpenseData = false;
    }
    _changeLoadingState();
  }

  void _changeLoadingState() {
    setState(() {
      loadingExpenseData = !loadingExpenseData;
    });
  }
}
