import 'package:PocketBuddy/mapper/UserDetails.dart';
import 'package:PocketBuddy/screens/GroupDetailsScreen.dart';
import 'package:PocketBuddy/screens/GroupExpenseDetailsScreen.dart';
import 'package:PocketBuddy/services/GroupDetailsService.dart';
import 'package:flutter/material.dart';
import 'package:PocketBuddy/mapper/UserJoinGroup.dart';
import 'package:intl/intl.dart'; // for formatting dates

class JoinGroupWidget extends StatefulWidget {
  const JoinGroupWidget({
    super.key,
    required this.joinGroup,
    required this.joinMembers,
  });

  final UserJoinGroup joinGroup;
  final Map<String, String> joinMembers;

  @override
  State<JoinGroupWidget> createState() => _JoinGroupWidgetState();
}

class _JoinGroupWidgetState extends State<JoinGroupWidget> {
  @override
  void initState() {
    super.initState();
    _fetchLoginUserDetails();
  }

  final groupDetailService = GroupDetailService();
  late UserDetails savedUser;

  bool joiningGroupLoaging = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Group Details"),
        backgroundColor: theme.primary,
        foregroundColor: theme.onPrimary,
      ),
      body:
          joiningGroupLoaging
              ? Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Group Info
                    Text(
                      widget.joinGroup.groupName,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: theme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.joinGroup.groupDescription,
                      style: TextStyle(fontSize: 16, color: theme.onSurface),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Created on: ${DateFormat.yMMMd().format(widget.joinGroup.createdAt)}",
                      style: TextStyle(color: theme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 16),
                    Divider(color: theme.outlineVariant),

                    // Members List
                    Text(
                      "Members:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: theme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child:
                          widget.joinMembers.isEmpty
                              ? Text(
                                "No members yet.",
                                style: TextStyle(color: theme.onSurface),
                              )
                              : ListView.separated(
                                itemCount: widget.joinMembers.length,
                                separatorBuilder: (_, __) => const Divider(),
                                itemBuilder: (context, index) {
                                  final entry = widget.joinMembers.entries
                                      .elementAt(index);
                                  return ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: theme.secondary,
                                      child: Text(entry.value[0].toUpperCase()),
                                    ),
                                    title: Text(entry.value),
                                  );
                                },
                              ),
                    ),

                    // Join Button
                    SafeArea(
                      top: false,
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            _joinGroup();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primary,
                            foregroundColor: theme.onPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text("Join Group"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  _joinGroup() async {
    _switchLoading();

    // extract data
    final groupId = widget.joinGroup.groupId;
    final userId = savedUser.userId;

    // call Api
    final UserJoinGroup? response = await groupDetailService.joinGroup(
      groupId,
      userId,
    );
    _switchLoading();
    if (response != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => GroupExpenseDetailsScreen(group: response),
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Unable to Join Group")));
    }
  }

  void _fetchLoginUserDetails() async {
    savedUser = (await UserDetails.fetchUserDetailsFromStorage())!;
  }

  void _switchLoading() {
    setState(() {
      joiningGroupLoaging = !joiningGroupLoaging;
    });
  }
}
