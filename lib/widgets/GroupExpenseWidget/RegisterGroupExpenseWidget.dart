import 'dart:convert';

import 'package:PocketBuddy/mapper/UserDetails.dart';
import 'package:PocketBuddy/mapper/UserJoinGroup.dart';
import 'package:PocketBuddy/services/GroupExpenseService.dart';
import 'package:flutter/material.dart';

class RegisterGroupExpenseWidget extends StatefulWidget {
  const RegisterGroupExpenseWidget({
    super.key,
    required this.userJoinGroup,
    required this.joinMembers,
    required this.refreshExpense
  });

  final UserJoinGroup userJoinGroup;
  final Map<String, String> joinMembers;
  final Function refreshExpense;

  @override
  State<StatefulWidget> createState() {
    return _RegisterGroupExpenseWidgetState();
  }
}

class _RegisterGroupExpenseWidgetState
    extends State<RegisterGroupExpenseWidget> {
  final _formKey = GlobalKey<FormState>();

  // Expense Categories Map
  final Map<IconData, String> expenseCategories = {
    Icons.fastfood: "Food",
    Icons.shopping_cart: "Shopping",
    Icons.sports_esports: "Games",
    Icons.movie: "Movies",
    Icons.restaurant: "Dinner Out",
    Icons.flash_on: "Electricity",
    Icons.home: "Home",
    Icons.local_gas_station: "Fuel",
    Icons.local_taxi: "Transport",
    Icons.phone_android: "Phone",
    Icons.wifi: "Internet",
    Icons.local_hospital: "Healthcare",
    Icons.school: "Education",
    Icons.card_giftcard: "Gifts",
    Icons.beach_access: "Vacation",
    Icons.pets: "Pets",
    Icons.attach_money: "Others",
  };

  // State variable to hold selected category
  IconData? _selectedCategoryIcon;
  String? _selectedCategoryName;

  // Text Editing Controllers for Form Fields
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  List<String> _selectMembersUserId = [];

  final groupExpenseService = GroupExpenseService();

  @override
  void initState() {
    super.initState();
    _selectedCategoryIcon = expenseCategories.keys.first;
    _selectedCategoryName = expenseCategories[_selectedCategoryIcon];

    // Select all members by default
    _selectMembersUserId = widget.joinMembers.keys.toList();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create New Expense")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 36, horizontal: 16),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.secondaryContainer.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Dropdown for Category Selection
                  DropdownButtonFormField<IconData>(
                    value: _selectedCategoryIcon,
                    decoration: InputDecoration(
                      labelText: "Select Category",
                      prefixIcon: Icon(Icons.category),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    items:
                        expenseCategories.entries
                            .map(
                              (entry) => DropdownMenuItem<IconData>(
                                value: entry.key,
                                child: Row(
                                  children: [
                                    Icon(entry.key),
                                    SizedBox(width: 10),
                                    Text(entry.value),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                    onChanged: (IconData? newCategory) {
                      setState(() {
                        _selectedCategoryIcon = newCategory;
                        _selectedCategoryName = expenseCategories[newCategory];
                      });
                    },
                  ),
                  SizedBox(height: 28),

                  // Description TextField
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelText: 'Expense Description',
                      prefixIcon: Icon(Icons.description),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 18),

                  // Amount TextField
                  TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelText: 'Expense Amount',
                      prefixIcon: Icon(Icons.currency_rupee),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an amount';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton.icon(
                      onPressed: _selectIncludedMembers,
                      label: Text("Select Members"),
                      icon: Icon(Icons.arrow_drop_down),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.onSurface,
                        padding: EdgeInsets.all(14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _registerExpense();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: Text("Save"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _selectIncludedMembers() async {
    // Initialize temporary set of selected userIds
    Set<String> selectedUserIds = Set<String>.from(widget.joinMembers.keys);

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Members"),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: widget.joinMembers.entries.map((entry) {
                    return CheckboxListTile(
                      title: Text(entry.value),
                      value: selectedUserIds.contains(entry.key),
                      onChanged: (bool? isChecked) {
                        setState(() {
                          if (isChecked == true) {
                            selectedUserIds.add(entry.key);
                          } else {
                            selectedUserIds.remove(entry.key);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  // Save list of unselected userIds
                  _selectMembersUserId = selectedUserIds.toList();
                });
                Navigator.pop(context);
              },
              child: Text("Done"),
            ),
          ],
        );
      },
    );
  }


  _registerExpense() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectMembersUserId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Included members are empty')),
      );
      return;
    }

    final description = _descriptionController.text.trim();
    final amount = double.parse(_amountController.text);
    final splitAmount = amount / _selectMembersUserId.length;

    final Map<String, double> includedMembers = {};

    widget.joinMembers.forEach((userId, fullName) {
      includedMembers[userId] =
      _selectMembersUserId.contains(userId) ? splitAmount : 0.00;
    });

    UserDetails? savedUser = await UserDetails.fetchUserDetailsFromStorage();

    final Map<String, dynamic> registerGroupExpense = {
      "groupId": widget.userJoinGroup.groupId,
      "description": description,
      "amount": amount,
      "registerByUserId": savedUser!.userId,
      "includedMembers": includedMembers,
    };

    bool isSuccess = await groupExpenseService.registerExpense(registerGroupExpense);

    if (isSuccess) {
      Navigator.pop(context);
      widget.refreshExpense();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to register expense')),
      );
    }
  }

}
