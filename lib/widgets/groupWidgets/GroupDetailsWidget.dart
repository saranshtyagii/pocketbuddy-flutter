import 'package:PocketBuddy/mapper/UserDetails.dart';
import 'package:PocketBuddy/mapper/UserJoinGroup.dart';
import 'package:PocketBuddy/services/GroupDetailsService.dart';
import 'package:PocketBuddy/widgets/groupWidgets/JoinGroupWidget.dart';
import 'package:PocketBuddy/widgets/groupWidgets/RegisterGroupWidget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../screens/GroupExpenseDetailsScreen.dart';

class GroupDetailsWidget extends StatefulWidget {
  const GroupDetailsWidget({
    super.key,
    required this.refreshGroupList,
    required this.joinGroups,
  });

  final Function refreshGroupList;
  final List<UserJoinGroup> joinGroups;

  @override
  State<GroupDetailsWidget> createState() => _GroupDetailsWidgetState();
}

class _GroupDetailsWidgetState extends State<GroupDetailsWidget> {
  final _searchController = TextEditingController();

  // To store the filtered list
  late List<UserJoinGroup> filteredGroups;

  late UserDetails savedUser;
  bool _findingGroup = false;

  final groupDetailService = GroupDetailService();
  late UserJoinGroup? findGroup;
  late Map<String, String> joinMembers;

  @override
  void initState() {
    super.initState();
    filteredGroups = widget.joinGroups;
    _fetchSavedUser();
  }

  @override
  Widget build(BuildContext context) {
    return _findingGroup
        ? Center(child: CircularProgressIndicator())
        : Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              // Search bar for entering Group Id
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: 'find group to join (ex: group id)',
                        prefixIcon: Icon(Icons.group),
                        suffixIcon: IconButton(
                          onPressed: _findGroup,
                          icon: Icon(Icons.search),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder:
                                (context) => RegisterGroupWidget(
                                  savedUserDetails: savedUser,
                                ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: 24,
                          horizontal: 16,
                        ),
                        backgroundColor:
                            Theme.of(context).colorScheme.secondaryContainer,
                      ),
                      child: Text(
                        "New Group",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              // Displaying join group details
              Expanded(child: _buildJoinGroupDetails()),
            ],
          ),
        );
  }

  // Filter the groups based on search input
  void _findGroup() async {
    setState(() {
      _findingGroup = true;
    });
    // extract data
    final groupId = _searchController.text.trim();
    findGroup = await groupDetailService.findGroup(groupId);
    joinMembers = await groupDetailService.fetchJoinMembers(groupId);
    if (findGroup != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder:
              (context) => JoinGroupWidget(
                joinGroup: findGroup!,
                joinMembers: joinMembers,
              ),
        ),
      );
      setState(() {
        _findingGroup = false;
      });
    } else {
      // show scafold message error message that invalid groupID
    }
  }

  void _joinGroup() async {}

  // Build the join group details in the list
  _buildJoinGroupDetails() {
    return ListView.builder(
      itemCount:
          filteredGroups.length, // Use filteredGroups instead of joinGroups
      itemBuilder: (context, index) {
        UserJoinGroup group = filteredGroups[index];

        return InkWell(
          onTap: () {
            _pushToGroupExpenseDetailsScreen(group);
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: Theme.of(context).colorScheme.tertiary,
            child: Padding(
              padding: EdgeInsets.only(left: 16, top: 8, right: 8, bottom: 8),
              child: Row(
                children: [
                  // CircleAvatar with the first letter of the group name
                  CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: Text(
                      group.groupName.isNotEmpty
                          ? group.groupName[0].toUpperCase()
                          : '',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ListTile(
                      title: Text(
                        group.groupName,
                        style: GoogleFonts.lato(
                          color: Theme.of(context).colorScheme.surface,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ), // Displaying the group name
                      subtitle: Text(
                        "Last Transaction",
                        style: GoogleFonts.lato(
                          color: Theme.of(context).colorScheme.surface,
                          fontSize: 14,
                        ),
                      ), // Placeholder for actual description
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _pushToGroupExpenseDetailsScreen(UserJoinGroup group) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GroupExpenseDetailsScreen(group: group),
      ),
    );
  }

  _fetchSavedUser() async {
    savedUser = (await UserDetails.fetchUserDetailsFromStorage())!;
  }
}
