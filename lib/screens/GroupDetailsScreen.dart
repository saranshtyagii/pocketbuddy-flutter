import 'package:PocketBuddy/mapper/UserJoinGroup.dart';
import 'package:PocketBuddy/widgets/groupWidgets/NoGroupFoundWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GroupDetailsScreen extends StatefulWidget {
  const GroupDetailsScreen({super.key});

  @override
  State<GroupDetailsScreen> createState() {
    return _GroupDetailsScreenState();
  }
}

class _GroupDetailsScreenState extends State<GroupDetailsScreen> {
  List<UserJoinGroup> joinGroup = [];

  bool loadingJoinGroupData = true;
  bool hasJoinedGroups = false;

  @override
  void initState() {
    _loadUserJoinGroups();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loadingJoinGroupData
        ? Center(child: CircularProgressIndicator())
        : hasJoinedGroups
        ? GroupDetailsScreen()
        : Nogroupfoundwidget();
  }

  _loadUserJoinGroups() async {
    setState(() {
      loadingJoinGroupData = false;
    });
  }
}
