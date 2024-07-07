import 'package:hive_flutter/adapters.dart';
import 'job_model.dart';

part 'model.g.dart';

@HiveType(typeId: 1)
class User extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String username;

  @HiveField(2)
  String? mail;

  @HiveField(3)
  final String password;

  @HiveField(4)
  List<Job> jobs;  // Add this field

  User({
    this.id,
    required this.username,
    required this.password,
    this.mail,
    List<Job>? jobs,
  }) : jobs = jobs ?? [];
}