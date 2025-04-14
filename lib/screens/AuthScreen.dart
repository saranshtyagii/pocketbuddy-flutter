import 'package:flutter/material.dart';
import 'package:PocketBuddy/widgets/LoginWidget.dart';
import 'package:PocketBuddy/widgets/RegisterWidget.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLoginScreen = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          isLoginScreen
              ? Theme.of(context).colorScheme.tertiaryContainer
              : Theme.of(context).colorScheme.secondaryContainer,
      body:
          isLoginScreen
              ? Loginwidget(switchScreen: switchScreen)
              : RegisterWidget(switchScreen: switchScreen),
    );
  }

  void switchScreen() {
    setState(() {
      isLoginScreen = !isLoginScreen;
    });
  }
}
