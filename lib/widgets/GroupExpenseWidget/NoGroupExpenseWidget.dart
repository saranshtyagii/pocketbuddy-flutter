import 'package:PocketBuddy/mapper/UserJoinGroup.dart';
import 'package:PocketBuddy/widgets/GroupExpenseWidget/RegisterGroupExpenseWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NoGroupExpenseWidget extends StatefulWidget {
  const NoGroupExpenseWidget({
    super.key,
    required this.userJoinGroup,
    required this.refreshExpenseData,
    required this.joinMembers,
  });
  final UserJoinGroup userJoinGroup;
  final Function refreshExpenseData;
  final Map<String, String> joinMembers;

  @override
  State<StatefulWidget> createState() {
    return _NoGroupExpenseWidgetState();
  }
}

class _NoGroupExpenseWidgetState extends State<NoGroupExpenseWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("No Expense Found!", style: GoogleFonts.lato(fontSize: 24)),
              Text(
                "Please add some expense",
                style: GoogleFonts.lato(fontSize: 18),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: GestureDetector(
            onTap: () {
              _pushRegisterExpenseWidget();
            },
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                shape: BoxShape.circle,
              ),
              child: Text(
                "+",
                style: TextStyle(fontSize: 28, color: CupertinoColors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _pushRegisterExpenseWidget() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => RegisterGroupExpenseWidget(
              userJoinGroup: widget.userJoinGroup,
              joinMembers: widget.joinMembers,
              refreshExpense: widget.refreshExpenseData,
            ),
      ),
    );
  }
}
