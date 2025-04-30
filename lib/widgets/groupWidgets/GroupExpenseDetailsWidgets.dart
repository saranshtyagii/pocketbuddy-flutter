import 'package:flutter/cupertino.dart';

import '../../mapper/GroupExpenseDetails.dart';

class GroupExpenseDetailsWidget extends StatefulWidget{
  const GroupExpenseDetailsWidget({super.key, required this.groupExpenseDetails, required this.refreshExpense});

  final List<GroupExpenseDetails> groupExpenseDetails;
  final Function refreshExpense;
  

  @override
  State<StatefulWidget> createState() {
    return _GroupExpenseDetailsWidget();
  }
}

class _GroupExpenseDetailsWidget extends State<GroupExpenseDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Expense Data"));
  }

}