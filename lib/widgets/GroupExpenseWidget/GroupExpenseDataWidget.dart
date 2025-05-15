import 'package:PocketBuddy/mapper/GroupExpenseDetails.dart';
import 'package:PocketBuddy/mapper/UserDetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GroupExpenseDataWidget extends StatefulWidget {
  const GroupExpenseDataWidget({
    super.key,
    required this.refreshExpenseData,
    required this.expenseDetails,
    required this.joinMembers,
  });

  final Function refreshExpenseData;
  final List<GroupExpenseDetails> expenseDetails;
  final Map<String, String> joinMembers;

  @override
  State<GroupExpenseDataWidget> createState() => _GroupExpenseDataWidgetState();
}

class _GroupExpenseDataWidgetState extends State<GroupExpenseDataWidget> {
  UserDetails? savedUserDetails;
  String currentUserId = "";

  @override
  void initState() {
    super.initState();
    _fetchSavedUser();
  }

  Future<void> _fetchSavedUser() async {
    savedUserDetails = await UserDetails.fetchUserDetailsFromStorage();
    if (savedUserDetails != null) {
      setState(() {
        currentUserId = savedUserDetails!.userId;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(8),
          width: double.infinity,
          height: 100,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [Text("Total Amount:"), Text("Paid by You:")],
          ),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: ListView.builder(
            itemCount: widget.expenseDetails.length,
            itemBuilder: (context, index) {
              return _buildExpenseData(widget.expenseDetails[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildExpenseData(GroupExpenseDetails expenseData) {
    bool placeInLeft = expenseData.userId == currentUserId;
    bool isEdited = expenseData.edited;
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color:
            isEdited
                ? Theme.of(context).colorScheme.errorContainer
                : placeInLeft
                ? Theme.of(context).colorScheme.secondaryFixedDim
                : Theme.of(context).colorScheme.secondaryFixed,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                expenseData.includedMembers[expenseData.userId]!.userFullName,
                style: TextStyle(color: Theme.of(context).colorScheme.surface),
              ),
              SizedBox(height: 4),
              Text(
                '${expenseData.includedMembers[expenseData.userId]!.amount}',
                style: TextStyle(color: Theme.of(context).colorScheme.surface),
              ),
            ],
          ),
          TextButton.icon(
            onPressed: () {},
            label: Text(
              'Edit',
              style: GoogleFonts.aBeeZee(
                color: Theme.of(context).colorScheme.surface,
              ),
            ),
            icon: Icon(
              Icons.edit,
              color: Theme.of(context).colorScheme.surface,
            ),
          ),
        ],
      ),
    );
  }
}
