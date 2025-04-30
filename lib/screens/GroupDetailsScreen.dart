import 'package:PocketBuddy/mapper/UserDetails.dart';
import 'package:PocketBuddy/mapper/UserJoinGroup.dart';
import 'package:PocketBuddy/services/GroupDetailsService.dart';
import 'package:PocketBuddy/widgets/groupWidgets/GroupDetailsWidget.dart';
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

  final groupDetailsService = GroupDetailService();

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
        ? GroupDetailsWidget(refreshGroupList: _loadUserJoinGroups, joinGroups: joinGroup,)
        : NoGroupFoundWidget(refreshGroupList: _loadUserJoinGroups);
  }

  void _loadUserJoinGroups() async {
    UserDetails? userDetails = await UserDetails.fetchUserDetailsFromStorage();
    final response = await groupDetailsService.loadUserJoinGroup(userDetails!.userId);
    if(response.isNotEmpty) {
      joinGroup = response;
      hasJoinedGroups = true;
    }
    stopLoading();
  }

  stopLoading() {
    setState(() {
      loadingJoinGroupData = !loadingJoinGroupData;
    });
  }

}
