import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Nogroupfoundwidget extends StatefulWidget {
  const Nogroupfoundwidget({super.key});

  @override
  State<Nogroupfoundwidget> createState() => _GroupdetailswidgetState();
}

class _GroupdetailswidgetState extends State<Nogroupfoundwidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            "You haven't join any Group",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            "Please join a Group or Create New",
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
