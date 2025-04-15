import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RegisterGroupWidget extends StatefulWidget {
  const RegisterGroupWidget({super.key});

  @override
  State<RegisterGroupWidget> createState() => _RegisterGroupWidgetState();
}

class _RegisterGroupWidgetState extends State<RegisterGroupWidget> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _groupBudgetController = TextEditingController();
  final TextEditingController _budgetPerDayController = TextEditingController();

  DateTime? _tripStartDate;
  DateTime? _tripEndDate;
  bool _isTripGroup = false;

  final DateFormat _dateFormat = DateFormat('dd MMM yyyy');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Create Group")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Group Name (Required)", style: theme.textTheme.labelLarge),
              const SizedBox(height: 6),
              TextFormField(
                controller: _groupNameController,
                decoration: const InputDecoration(
                  hintText: "Enter group name",
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) =>
                        value == null || value.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 16),

              Text("Description (Optional)", style: theme.textTheme.labelLarge),
              const SizedBox(height: 6),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  hintText: "Enter description",
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),

              Text(
                "Group Budget (Optional)",
                style: theme.textTheme.labelLarge,
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _groupBudgetController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: "e.g. 10000",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              Text(
                "Budget Per Day (Optional)",
                style: theme.textTheme.labelLarge,
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _budgetPerDayController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: "e.g. 1000",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Is this group for a trip?",
                    style: theme.textTheme.bodyLarge,
                  ),
                  Switch(
                    value: _isTripGroup,
                    onChanged: (value) {
                      setState(() {
                        _isTripGroup = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                switchInCurve: Curves.easeIn,
                switchOutCurve: Curves.easeOut,
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return SizeTransition(sizeFactor: animation, child: child);
                },
                child:
                    _isTripGroup
                        ? Column(
                          key: const ValueKey("tripFields"),
                          children: [
                            _buildDateSelector(
                              "Trip Start Date",
                              _tripStartDate,
                              () => _selectDate(context, true),
                            ),
                            const SizedBox(height: 12),
                            _buildDateSelector(
                              "Trip End Date",
                              _tripEndDate,
                              () => _selectDate(context, false),
                            ),
                          ],
                        )
                        : const SizedBox.shrink(key: ValueKey("empty")),
              ),

              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text("Create Group"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateSelector(String label, DateTime? date, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 6),
        InkWell(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              date != null ? _dateFormat.format(date) : "Select date",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _tripStartDate = picked;
        } else {
          _tripEndDate = picked;
        }
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Use collected data here
      final groupName = _groupNameController.text;
      final description = _descriptionController.text;
      final groupBudget = double.tryParse(_groupBudgetController.text);
      final budgetPerDay = double.tryParse(_budgetPerDayController.text);

      print("Group Name: $groupName");
      print("Description: $description");
      print("Is Trip: $_isTripGroup");
      print("Budget: $groupBudget");
      print("Budget/Day: $budgetPerDay");
      print("Start: $_tripStartDate");
      print("End: $_tripEndDate");

      // You can now pass this to your backend or controller
    }
  }
}
