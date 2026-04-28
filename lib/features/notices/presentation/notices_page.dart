import 'package:flutter/material.dart';
import 'reminder_section.dart';

class NoticeScreen extends StatelessWidget {
  const NoticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notices")),
      body: const SingleChildScrollView(
        child: ReminderSection(),
      ),
    );
  }
}