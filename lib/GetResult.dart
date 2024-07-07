import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:resume_parser/dashboard.dart';
import 'package:share_plus/share_plus.dart';
import 'HomePage.dart';
import 'database/model.dart';
import 'discover.dart';

class GetResult extends StatelessWidget {
  final List<Map<String, dynamic>> results;
  final User user;

  const GetResult({Key? key, required this.results, required this.user}) : super(key: key);

  void _viewResume(BuildContext context, int index) {
    final filePath = results[index]['file'].path;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text('PDF Viewer')),
          body: PDFView(
            filePath: filePath,
            enableSwipe: true,
            swipeHorizontal: true,
            autoSpacing: false,
            pageFling: false,
            onError: (error) {
              print('Error while opening PDF: $error');
            },
            onPageError: (page, error) {
              print('Error on page $page: $error');
            },
          ),
        ),
      ),
    );
  }
  Future<void> _saveResume(BuildContext context, int index) async {
    final result = results[index];
    final sourceFile = File(result['file'].path);
    final fileName = result['filename'];

    try {
      // Get the documents directory
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';

      // Copy the file to the new location
      await sourceFile.copy(filePath);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Saved to $filePath')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving file: $e')),
      );
    }
  }
  Future<void> _shareResume(BuildContext context, int index) async {
    final result = results[index];
    final file = File(result['file'].path);
    final xFile = XFile(file.path);

    await Share.shareXFiles(
      [xFile],
      text: 'Sharing resume: ${result['filename']}',
      subject: 'Resume',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SHORTLISTED"),
        backgroundColor: Colors.blue,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Discover(user: user)),
            );
          },
        ),
      ),
      body: ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          final result = results[index];
          return Padding(
            padding: const EdgeInsets.all(2),
            child: Card(
              elevation: 5,
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
              child: ListTile(
                leading: Icon(Icons.picture_as_pdf, color: Colors.blue),
                title: Text(
                  result['filename'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Score: ${result['score']}%'),
                    Text('Matches: ${result['matches'].join(', ')}'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_red_eye),
                      onPressed: () => _viewResume(context, index),
                    ),
                    IconButton(
                      icon: const Icon(Icons.save),
                      onPressed: () => _saveResume(context, index),
                    ),
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () => _shareResume(context, index),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}