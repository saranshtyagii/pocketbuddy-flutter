import 'package:flutter/widgets.dart';

class GroupDetailsWidget extends StatefulWidget {
  const GroupDetailsWidget({super.key, required this.refershGroupList});

  final Function refershGroupList;

  @override
  State<GroupDetailsWidget> createState() => _GroupdetailswidgetState();
}

class _GroupdetailswidgetState extends State<GroupDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Center(child: Text("You haven't join any group"))],
    );
  }
}
