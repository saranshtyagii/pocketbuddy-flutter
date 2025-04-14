import 'package:flutter/widgets.dart';

class Groupdetailswidget extends StatefulWidget {
  @override
  State<Groupdetailswidget> createState() => _GroupdetailswidgetState();
}

class _GroupdetailswidgetState extends State<Groupdetailswidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Center(child: Text("You haven't join any group"))],
    );
  }
}
