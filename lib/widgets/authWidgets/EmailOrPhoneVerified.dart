import 'dart:async';

import 'package:PocketBuddy/screens/AuthScreen.dart';
import 'package:PocketBuddy/screens/HomeScreen.dart';
import 'package:PocketBuddy/services/AuthServices.dart';
import 'package:flutter/material.dart';

class EmailOrPhoneVerified extends StatefulWidget {
  const EmailOrPhoneVerified({super.key, required this.loginWith, required this.emailAddress});

  final String loginWith;
  final String emailAddress;

  @override
  State<StatefulWidget> createState() {
    return _EmailOrPhoneVerified();
  }
}

class _EmailOrPhoneVerified extends State<EmailOrPhoneVerified> {
  late String mobileOrEmail;

  final authService = AuthServices();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    switch (widget.loginWith) {
      case "email":
        mobileOrEmail = "Email Address";
        break;
      case "phone":
        mobileOrEmail = "Phone Number";
        break;
      default:
        mobileOrEmail = "Email or Phone";
    }

    _startAutoRefresh();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.errorContainer.withOpacity(0.1),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.warning_amber_rounded,
                          color: theme.colorScheme.error, size: 48),
                      const SizedBox(height: 16),
                      Text(
                        "Verification Required",
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Your $mobileOrEmail is not verified yet.\nPlease check your registered ${widget.loginWith} for the verification link.",
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Your verification logic here
                          },
                          icon: Icon(Icons.refresh),
                          label: Text("Resend Verification"),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _startAutoRefresh() {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _refreshPage();
    });
  }

  _refreshPage() async {
    bool isVerified = await authService.isEmailVerified(widget.emailAddress);
    if(isVerified) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen())
      );
    }
  }

}
