import 'dart:io';

import 'package:PocketBuddy/constants/ConstantValues.dart';
import 'package:PocketBuddy/main.dart';
import 'package:PocketBuddy/mapper/UserDetails.dart';
import 'package:PocketBuddy/screens/AuthScreen.dart';
import 'package:PocketBuddy/screens/HomeScreen.dart';
import 'package:PocketBuddy/services/PersonalExpenseService.dart';
import 'package:PocketBuddy/utils/AuthUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class NoExpenseFoundWidget extends StatefulWidget {
  const NoExpenseFoundWidget({super.key, required this.refreshExpenseData});

  final Function refreshExpenseData;

  @override
  State<NoExpenseFoundWidget> createState() {
    return _NoExpenseFoundWidgetState();
  }
}

class _NoExpenseFoundWidgetState extends State<NoExpenseFoundWidget> {
  final _addExpenseFormKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  final personalExpenseService = PersonalExpenseService();

  @override
  void initState() {
    super.initState();
    initBannerAd();
  }

  late BannerAd bannerAd;
  bool isAdLoaded = false;

  void initBannerAd() {
    bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId:
          Platform.isAndroid
              ? ConstantValues.bannerAdIdAndroid
              : ConstantValues.bannerAdIdIOS,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print("Failed to load Banner Ad in No group found: $error");
        },
      ),
      request: const AdRequest(),
    );

    bannerAd.load();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Centered Text
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                "No Expense Found!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                "Please add some expenses.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ],
          ),
        ),

        // Positioned FAB at bottom right
        Positioned(
          bottom: isAdLoaded ? 80 : 24, // Push it up if ad is loaded
          right: 24,
          child: FloatingActionButton(
            onPressed: () {
              _showAddExpenseSheetUI(context);
            },
            child: const Icon(Icons.add),
          ),
        ),

        // Ad at bottom center
        if (isAdLoaded)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: bannerAd.size.width.toDouble(),
                height: bannerAd.size.height.toDouble(),
                child: AdWidget(ad: bannerAd),
              ),
            ),
          ),
      ],
    );
  }

  void _showAddExpenseSheetUI(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.5,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.cancel),
                    ),
                    const Text(
                      "Add Expense",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: _addExpense,
                      child: const Text("Save"),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Form(
                  key: _addExpenseFormKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _descriptionController,
                        maxLength: 50,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter a description";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.description),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          labelText: 'Description',
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _amountController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter amount";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.currency_rupee),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          labelText: 'Amount',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  _addExpense() async {
    final description = _descriptionController.text.trim();
    final addAmount = _amountController.text.trim();

    if (description.isEmpty || addAmount.isEmpty) {
      _showErrorMessage("Please fill in all the fields.");
      return;
    }

    double updatedAmount = 0;

    try {
      if (addAmount.contains("+")) {
        final splitAmount = addAmount.split("+");
        for (var amount in splitAmount) {
          final parsed = double.tryParse(amount.trim());
          if (parsed == null) {
            _showErrorMessage("Invalid amount format.");
            return;
          }
          updatedAmount += parsed;
        }
      } else {
        final parsed = double.tryParse(addAmount);
        if (parsed == null) {
          _showErrorMessage("Invalid amount format.");
          return;
        }
        updatedAmount = parsed;
      }
    } catch (e) {
      _showErrorMessage("Something went wrong while parsing amount.");
      return;
    }

    UserDetails? savedUser = await UserDetails.getInstance();
    if (savedUser == null || savedUser.userId == null) {
      _showErrorMessage("User not found.");
      return;
    }

    Map<String, dynamic> addRequest = {
      'userId': savedUser.userId,
      'expenseId': '',
      'description': description,
      'amount': updatedAmount,
    };

    bool expenseAdded = await personalExpenseService.addExpense(addRequest);

    if (expenseAdded) {
      Navigator.of(context).pop();
      widget.refreshExpenseData();
      _addExpenseFormKey.currentState?.reset();
    } else {
      _showErrorMessage('Unable to add expense. Please try again.');
    }
  }

  _showErrorMessage(text) {
    ScaffoldMessenger.of(context).showSnackBar(
      new SnackBar(
        content: Text(text),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
    );
  }
}
