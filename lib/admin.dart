import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'ShowTextField.dart';
import 'database/feedback_model.dart';
import 'database/function.dart';

class admin extends StatefulWidget {
  const admin({Key? key}) : super(key: key);

  @override
  State<admin> createState() => _adminState();
}

class _adminState extends State<admin> {
  @override
  void initState() {
    super.initState();
    _initializeUserList();
  }

  Future<void> _initializeUserList() async {
    await getUserList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("--------------  ADMIN  --------------"),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: ShowTextField()),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Feedbacks',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: Hive.box<FeedbackModel>('feedbacks').listenable(),
                builder: (context, Box<FeedbackModel> box, _) {
                  if (box.values.isEmpty) {
                    return Center(child: Text('No feedbacks yet'));
                  }
                  return ListView.builder(
                    itemCount: box.values.length,
                    itemBuilder: (context, index) {
                      final feedback = box.getAt(index);
                      return ListTile(
                        title: Text(feedback!.feedback),
                        subtitle: Row(
                          children: List.generate(
                            5,
                                (starIndex) => Icon(
                              starIndex < feedback.rating ? Icons.star : Icons.star_border,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}