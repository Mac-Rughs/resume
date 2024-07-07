import 'package:hive/hive.dart';

part 'feedback_model.g.dart';

@HiveType(typeId: 3) // Use a unique typeId
class FeedbackModel extends HiveObject {
  @HiveField(0)
  late String feedback;

  @HiveField(1)
  late int rating;

  FeedbackModel({required this.feedback, required this.rating});
}