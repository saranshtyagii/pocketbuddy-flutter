import 'package:PocketBuddy/main.dart';
import 'package:PocketBuddy/mapper/UserDetails.dart';
import 'package:PocketBuddy/screens/AuthScreen.dart';
import 'package:PocketBuddy/screens/HomeScreen.dart';
import 'package:PocketBuddy/services/PersonalExpenseService.dart';
import 'package:PocketBuddy/utils/AuthUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            onPressed: () {
              _showAddExpenseSheetUI(context);
            },
            child: const Icon(Icons.add),
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
    // extract the data
    final description = _descriptionController.text.trim();
    final amount = _amountController.text.trim();

    // bind the data

    UserDetails? savedUser = await UserDetails.getInstance();
    Map<String, dynamic> addRequest = {
      'userId': savedUser?.userId,
      'expenseId': '',
      'description': description,
      'amount': double.parse(amount)
    };

    bool expenseAdded = await personalExpenseService.addExpense(addRequest);
    Navigator.of(context).pop();
    if (expenseAdded) {
      widget.refreshExpenseData();
    } else {
      _showErrorMessage(
        'Unable to add Expense. Please try again.',
      );
    }
    _addExpenseFormKey.currentState?.reset();
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
