import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import 'database/feedback_model.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  int _rating = 0;
  TextEditingController _feedbackController = TextEditingController();

  void _submitFeedback() async {
    if (_rating == 0 || _feedbackController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please provide both rating and feedback')),
      );
      return;
    }

    final feedbackBox = await Hive.openBox<FeedbackModel>('feedbacks');
    final newFeedback = FeedbackModel(
      feedback: _feedbackController.text,
      rating: _rating,
    );
    await feedbackBox.add(newFeedback);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Feedback Submitted'),
          content: const Text('Thank you for your feedback!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _feedbackController.clear();
                setState(() {
                  _rating = 0;
                });
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
        backgroundColor: Colors.cyan,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Rate us:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              children: <Widget>[
                _buildStar(1),
                _buildStar(2),
                _buildStar(3),
                _buildStar(4),
                _buildStar(5),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _feedbackController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your feedback here',
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: 200, // Adjust width as needed
                child: ElevatedButton(
                  onPressed: _submitFeedback,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.symmetric(vertical: 15),
                    ),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStar(int rating) {
    return IconButton(
      icon: Icon(
        _rating >= rating ? Icons.star : Icons.star_border,
        color: _rating >= rating ? Colors.orange : Colors.grey,
      ),
      onPressed: () {
        setState(() {
          _rating = rating;
        });
      },
    );
  }
}