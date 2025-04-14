import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContactUsWidget extends StatelessWidget {
  const ContactUsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: const [
                  Text(
                    'Get in Touch',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'If you have any questions, feedback, or suggestions, feel free to reach out to us!',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Email:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  Text('work.saranshtyagi@gmail.com'),
                  SizedBox(height: 16),
                  Text(
                    'GitHub (Frontend):',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  Text('https://github.com/saranshtyagii/pocketbuddy-native'),
                  SizedBox(height: 16),
                  Text(
                    'GitHub (Backend):',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  Text('https://github.com/saranshtyagii/pocketbuddy-backend'),
                ],
              ),
            ),
          ),
          const Divider(thickness: 1),
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              '© 2025 Pocket Buddy. All rights reserved.\nPocket Buddy is a product from NexLogicx.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
