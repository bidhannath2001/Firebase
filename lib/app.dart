import 'package:firebase/notification.dart';
import 'package:firebase/student_data.dart';
import 'package:firebase/task_manager.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: StudentData());
  }
}
