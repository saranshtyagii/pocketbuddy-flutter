import 'package:flutter/cupertino.dart';

class GroupExpenseDataWidget extends StatefulWidget {
  const GroupExpenseDataWidget({super.key, required this.refreshExpenseData});

  final Function refreshExpenseData;

  @override
  State<GroupExpenseDataWidget> createState() {
    return _NoGroupExpenseDataWidget();
  }
}

class _NoGroupExpenseDataWidget extends State<GroupExpenseDataWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("EXPENSE FOUND!"),
    );
  }

}