import 'package:PocketBuddy/mapper/UserJoinGroup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GroupExpenseDetailsScreen extends StatefulWidget {
  const GroupExpenseDetailsScreen({super.key, required this.group});

  final UserJoinGroup group;
  @override
  State<StatefulWidget> createState() {
    return _GroupExpenseDetailsScreenState();
  }

}

class _GroupExpenseDetailsScreenState extends State<GroupExpenseDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.group.groupName),
      ),
    );
  }

}