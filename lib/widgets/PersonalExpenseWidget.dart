import 'package:PocketBuddy/mapper/PersonalExpenseData.dart';
import 'package:PocketBuddy/services/PersonalExpenseService.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../mapper/UserDetails.dart';

class PersonalExpenseWidget extends StatefulWidget {
  const PersonalExpenseWidget({
    super.key,
    required this.refreshExpenseData,
    required this.personalExpenseData,
  });

  final Function refreshExpenseData;
  final List<PersonalExpenseData> personalExpenseData;

  @override
  State<PersonalExpenseWidget> createState() => _PersonalExpenseWidgetState();
}

class _PersonalExpenseWidgetState extends State<PersonalExpenseWidget> {
  double totalExpense = 0.0;
  double currentMonthExpense = 0.0;
  double lastMonthExpense = 0.0;

  final _addExpenseFormKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  final personalExpenseService = PersonalExpenseService();

  @override
  void initState() {
    super.initState();
    calculateTotalExpense();
    calculateCurrentMonthsExpense();
  }

  calculateTotalExpense() {
    totalExpense = 0.0;
    for (var expense in widget.personalExpenseData) {
      totalExpense += expense.amount;
    }
  }

  calculateCurrentMonthsExpense() {
    final now = DateTime.now();
    final currentMonth = now.month;
    final currentYear = now.year;
    final lastMonth = currentMonth == 1 ? 12 : currentMonth - 1;
    final lastMonthYear = currentMonth == 1 ? currentYear - 1 : currentYear;

    currentMonthExpense = 0.0;
    lastMonthExpense = 0.0;

    for (var expense in widget.personalExpenseData) {
      if (expense.expenseDate.month == currentMonth &&
          expense.expenseDate.year == currentYear) {
        currentMonthExpense += expense.amount;
      } else if (expense.expenseDate.month == lastMonth &&
          expense.expenseDate.year == lastMonthYear) {
        lastMonthExpense += expense.amount;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(symbol: '₹');
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSummaryCard(context),
          const SizedBox(height: 16),
          _buildExpensesContainer(context, currency),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primaryContainer,
            Theme.of(context).colorScheme.secondaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildSummaryText("Total", totalExpense),
          _buildSummaryText("Last Month", lastMonthExpense),
          _buildSummaryText("This Month", currentMonthExpense),
        ],
      ),
    );
  }

  Widget _buildSummaryText(String label, double amount) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.lato(fontSize: 14, color: Colors.black54),
        ),
        const SizedBox(height: 4),
        Text(
          "₹ ${amount.toStringAsFixed(2)}",
          style: GoogleFonts.lato(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildExpensesContainer(BuildContext context, NumberFormat currency) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: widget.personalExpenseData.length,
                itemBuilder: (context, index) {
                  final expense = widget.personalExpenseData[index];
                  return GestureDetector(
                    onTap: () => _openExpenseDetails(expense),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      elevation: 1,
                      child: ListTile(
                        title: Text(expense.description),
                        subtitle: Text(
                          DateFormat.yMMMd().format(expense.expenseDate),
                        ),
                        trailing: Text(
                          currency.format(expense.amount),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Personal Expenses",
          style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        Row(
          children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.sort_rounded)),
            IconButton(
              onPressed: () => _showAddExpenseSheetUI(context),
              icon: const Icon(Icons.add_rounded),
            ),
          ],
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
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildAddExpenseHeader(),
                const SizedBox(height: 20),
                Form(
                  key: _addExpenseFormKey,
                  child: Column(
                    children: [
                      _buildTextField(
                        controller: _descriptionController,
                        icon: Icons.description_outlined,
                        label: 'Description',
                        validatorMsg: 'Please enter a description',
                      ),
                      const SizedBox(height: 12),
                      _buildTextField(
                        controller: _amountController,
                        icon: Icons.currency_rupee_rounded,
                        label: 'Amount',
                        keyboardType: TextInputType.number,
                        validatorMsg: 'Please enter amount',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddExpenseHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close_rounded),
        ),
        const Text(
          "Add Expense",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextButton(onPressed: _addExpense, child: const Text("Save")),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String label,
    required String validatorMsg,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      validator:
          (value) =>
              value == null || value.trim().isEmpty ? validatorMsg : null,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        labelText: label,
      ),
    );
  }

  _addExpense() async {
    final description = _descriptionController.text.trim();
    final amount = _amountController.text.trim();

    UserDetails? savedUser = await UserDetails.getInstance();
    Map<String, dynamic> addRequest = {
      'userId': savedUser?.userId,
      'expenseId': '',
      'description': description,
      'amount': double.parse(amount),
    };

    bool expenseAdded = await personalExpenseService.addExpense(addRequest);
    Navigator.of(context).pop();
    if (expenseAdded) {
      widget.refreshExpenseData();
    } else {
      _showErrorMessage('Unable to add Expense. Please try again.');
    }
    _addExpenseFormKey.currentState?.reset();
  }

  _showErrorMessage(text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
    );
  }

  void _openExpenseDetails(PersonalExpenseData expense) {
    final _editFormKey = GlobalKey<FormState>();
    final TextEditingController _editDescriptionController =
        TextEditingController(text: expense.description);
    final TextEditingController _editAmountController = TextEditingController(
      text: expense.amount.toString(),
    );

    bool isEditing = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                top: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isEditing ? "Edit Expense" : "Expense Details",
                        style: GoogleFonts.lato(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(isEditing ? Icons.close : Icons.edit),
                            onPressed: () {
                              setModalState(() => isEditing = !isEditing);
                            },
                          ),
                          Visibility(
                            visible: !isEditing,
                            child: IconButton(
                              onPressed: () {
                                _deleteExpense(expense.expenseId);
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  isEditing
                      ? Form(
                        key: _editFormKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _editDescriptionController,
                              decoration: const InputDecoration(
                                labelText: "Description",
                                prefixIcon: Icon(Icons.description),
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Enter a description";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _editAmountController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: "Amount",
                                prefixIcon: Icon(Icons.currency_rupee),
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Enter a valid amount";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                onPressed: ()  {

                                },
                                child: const Text("Update"),
                              ),
                            ),
                          ],
                        ),
                      )
                      : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailRow(
                            Icons.description_outlined,
                            "Description",
                            expense.description,
                          ),
                          const SizedBox(height: 12),
                          _buildDetailRow(
                            Icons.calendar_today_rounded,
                            "Date",
                            DateFormat.yMMMMd().format(expense.expenseDate),
                          ),
                          const SizedBox(height: 12),
                          _buildDetailRow(
                            Icons.currency_rupee_rounded,
                            "Amount",
                            '₹ ${expense.amount.toStringAsFixed(2)}',
                            valueColor: Colors.redAccent,
                          ),
                        ],
                      ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String title,
    String value, {
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 24, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.lato(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.lato(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _deleteExpense(String expenseId) async {
    bool response = await personalExpenseService.deleteExpense(expenseId);
    if(response) {
      widget.refreshExpenseData();
      _popWidget();
    } else {
      _popWidget();
      _showSnapBar("Unable to delete expense");
    }
  }
  _popWidget() {
    Navigator.of(context).pop();
  }

  _showSnapBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      new SnackBar(
        content: Text(text),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
    );
  }

}
