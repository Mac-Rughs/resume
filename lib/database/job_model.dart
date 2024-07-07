import 'package:hive_flutter/adapters.dart';

part 'job_model.g.dart';

@HiveType(typeId: 2)
class Job extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  @HiveField(2)
  int numberOfWorkers;

  @HiveField(3)
  List<String> shortlistedPdfs;

  @HiveField(4)
  String userId;

  Job({
    required this.title,
    required this.description,
    required this.numberOfWorkers,
    required this.shortlistedPdfs,
    required this.userId,
  });
}