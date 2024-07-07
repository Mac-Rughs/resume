import 'package:flutter/material.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Frequently Asked Questions'),
        backgroundColor: Colors.cyan,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            _buildFAQItem(
              question: 'How to edit profile?',
              answer: 'From the dashboard, you can go to profile where you can update your details.',
            ),
            _buildFAQItem(
              question: 'Is it paid?',
              answer: 'No, our service is free to use. You can access all features without any charges.',
            ),
            _buildFAQItem(
              question: 'How to upload a resume?',
              answer: 'You can upload a resume from the profile page by clicking the upload button.',
            ),
            _buildFAQItem(
              question: 'How to view parsed data?',
              answer: 'After uploading and click on get results to view parsed data to see your resume details.',
            ),
            _buildFAQItem(
              question: 'How to contact support?',
              answer: 'You can send your queries to resumeparser@gmail.com.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem({required String question, required String answer}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(
          question,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(answer),
      ),
    );
  }
}