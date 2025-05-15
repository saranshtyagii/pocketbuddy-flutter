import 'package:PocketBuddy/mapper/GroupExpenseDetails.dart';
import 'package:PocketBuddy/mapper/UserJoinGroup.dart';
import 'package:PocketBuddy/services/GroupExpenseService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      appBar: AppBar(
        title: Text(widget.group.groupName),
        actions: [
          PopupMenuButton(
            itemBuilder:
                (context) => [
                  PopupMenuItem(
                    value: "view_members",
                    child: TextButton.icon(
                      onPressed: () {},
                      label: Text("View Members"),
                      icon: Icon(Icons.group),
                    ),
                  ),
                  PopupMenuItem(
                    value: "edit_group",
                    child: TextButton.icon(
                      onPressed: () {},
                      label: Text("Edit Group"),
                      icon: Icon(Icons.edit),
                    ),
                  ),
                  // PopupMenuItem(
                  //   value: "notifications",
                  //   child: TextButton.icon(
                  //     onPressed: () {},
                  //     label: Text("Notifications"),
                  //     icon: Icon(Icons.notifications),
                  //   ),
                  // ),
                  // PopupMenuItem(
                  //   value: "pin_group",
                  //   child: TextButton.icon(
                  //     onPressed: () {},
                  //     label: Text("Pin/Unpin Group"),
                  //     icon: Icon(Icons.push_pin),
                  //   ),
                  // ),
                  PopupMenuItem(
                    value: "share_link",
                    child: TextButton.icon(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: widget.group.discoverableId));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Copied to clipboard!")),
                        );
                      },
                      label: Text("Copy Group Code"),
                      icon: Icon(Icons.share),
                    ),
                  ),
                  // PopupMenuItem(
                  //   value: "mute_group",
                  //   child: TextButton.icon(
                  //     onPressed: () {},
                  //     label: Text("Mute Group"),
                  //     icon: Icon(Icons.volume_off),
                  //   ),
                  // ),
                  PopupMenuItem(
                    value: "leave_group",
                    child: TextButton.icon(
                      onPressed: () {},
                      label: Text("Leave Group"),
                      icon: Icon(Icons.exit_to_app),
                    ),
                  ),
                  PopupMenuItem(
                    value: "delete_group",
                    child: TextButton.icon(
                      onPressed: () {},
                      label: Text("Delete Group"),
                      icon: Icon(Icons.delete),
                    ),
                  ),
                ],
          ),
        ],
      ),
      body:
          _loadingData
              ? Center(child: CircularProgressIndicator())
              : _hasExpenseData
              ? GroupExpenseDataWidget(
                refreshExpenseData: _preLoadData,
                expenseDetails: expenseData,
                joinMembers: joinMembers,
              )
              : NoGroupExpenseWidget(
                userJoinGroup: widget.group,
                refreshExpenseData: _preLoadData,
                joinMembers: joinMembers,
              ),
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
      setState(() {
        _loadingData = false;
        _hasExpenseData = true;
      });
    }
  }
}
