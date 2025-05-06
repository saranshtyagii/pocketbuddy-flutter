import 'package:PocketBuddy/mapper/GroupExpenseDetails.dart';
import 'package:PocketBuddy/mapper/UserJoinGroup.dart';
import 'package:PocketBuddy/services/GroupExpenseService.dart';
import 'package:flutter/material.dart';

import '../widgets/GroupExpenseWidget/GroupExpenseDataWidget.dart';
import '../widgets/GroupExpenseWidget/NoGroupExpenseWidget.dart';

class GroupExpenseDetailsScreen extends StatefulWidget {
  const GroupExpenseDetailsScreen({super.key, required this.group});

  final UserJoinGroup group;
  @override
  State<StatefulWidget> createState() {
    return _GroupExpenseDetailsScreenState();
  }
}

class _GroupExpenseDetailsScreenState extends State<GroupExpenseDetailsScreen> {
  final groupExpenseService = GroupExpenseService();
  late List<GroupExpenseDetails> expenseData;
  late Map<String, String> joinMembers;
  bool _loadingData = true;
  bool _hasExpenseData = false;

  @override
  void initState() {
    // TODO: implement initState
    _preLoadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.group.groupName)),
      body:
          _loadingData
              ? Center(child: CircularProgressIndicator())
              : _hasExpenseData
              ? GroupExpenseDataWidget(refreshExpenseData: _preLoadData)
              : NoGroupExpenseWidget(userJoinGroup: widget.group, refreshExpenseData: _preLoadData, joinMembers: joinMembers,)
    );
  }

  _preLoadData() async {
    String groupId = widget.group.groupId;
    expenseData = await groupExpenseService.fetchAllExpenses(groupId);
    joinMembers = await groupExpenseService.fetchJoinMembers(groupId);
    if (expenseData.isEmpty) {
      setState(() {
        _loadingData = false;
      });
    } else {
      _hasExpenseData = true;
    }
  }
}
