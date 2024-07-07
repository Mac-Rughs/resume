import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:resume_parser/database/model.dart';
import 'package:resume_parser/database/job_model.dart';
import 'package:resume_parser/login.dart';
import 'package:resume_parser/signup.dart';
import 'database/feedback_model.dart';
import 'splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  if(!Hive.isAdapterRegistered((UserAdapter()).typeId)){
    Hive.registerAdapter(UserAdapter());
  }

  if(!Hive.isAdapterRegistered((JobAdapter()).typeId)){
    Hive.registerAdapter(JobAdapter());
  }
  if(!Hive.isAdapterRegistered((FeedbackModelAdapter()).typeId)){
    Hive.registerAdapter(FeedbackModelAdapter());
  }
  await Hive.deleteBoxFromDisk('jobs');
  await Hive.openBox<User>('users');
  await Hive.openBox<Job>('jobs');

  await Hive.openBox<FeedbackModel>('feedbacks');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: splash()
    );
  }
}