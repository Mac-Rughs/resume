
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'GetResult.dart';
import 'database/job_model.dart';
import 'database/model.dart';


class UploadResumePage extends StatefulWidget {
  final int numberOfWorkers;
  final User user;
  final int jobIndex;
  const UploadResumePage({Key? key, required this.numberOfWorkers, required this.user, required this.jobIndex}) : super(key: key);

  @override
  _UploadResumePageState createState() => _UploadResumePageState();
}

class _UploadResumePageState extends State<UploadResumePage> {
  List<File> _uploadedResumes = [];
  List<String> _keywords = [];

  Future<void> _selectFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: true,
    );

    if (result != null) {
      for (PlatformFile file in result.files) {
        final newFile = await _saveFile(File(file.path!));
        setState(() {
          _uploadedResumes.add(newFile);
        });
      }
    }
  }
  Future<File> _saveFile(File file) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final fileName = file.path.split('/').last;
    final newPath = '$path/$fileName';
    return file.copy(newPath);
  }

  void _deleteResume(int index) {
    setState(() {
      _uploadedResumes.removeAt(index);
    });
  }

  void _addKeywords(String keywordsString) {
    setState(() {
      _keywords.addAll(keywordsString.split(',').map((k) => k.trim()).where((k) => k.isNotEmpty));
    });
  }

  Future<Map<String, dynamic>> _parseResume(File file, List<String> keywords) async {
    PdfDocument document = PdfDocument(inputBytes: await file.readAsBytes());
    String text = PdfTextExtractor(document).extractText();
    document.dispose();

    List<String> resumeWords = text.toLowerCase().split(RegExp(r'\W+'));
    int matches = 0;
    List<String> matchedWords = [];

    for (String keyword in keywords) {
      if (resumeWords.contains(keyword.toLowerCase())) {
        matches++;
        matchedWords.add(keyword);
      }
    }

    double score = keywords.isEmpty ? 0 : matches / keywords.length;
    return {
      'score': score,
      'matches': matchedWords,
    };
  }

  Future<void> _getResults() async {
    if (_uploadedResumes.isEmpty) {
      Fluttertoast.showToast(msg: "Please upload at least one resume");
      return;
    }

    if (_keywords.isEmpty) {
      Fluttertoast.showToast(msg: "Please add keywords");
      return;
    }

    List<Map<String, dynamic>> results = [];
    for (File file in _uploadedResumes) {
      Map<String, dynamic> result = await _parseResume(file, _keywords);
      results.add({
        'file': file,
        'filename': file.path.split('/').last,
        'score': double.parse((result['score'] * 100).toStringAsFixed(2)),
        'matches': result['matches'],
      });
    }


    results.sort((a, b) => b['score'].compareTo(a['score']));

    results = results.take(widget.numberOfWorkers).toList();

    final newJob = Job(
      title: 'Job Title', // You may want to add a field for job title input
      description: 'Job Description', // You may want to add a field for job description input
      numberOfWorkers: widget.numberOfWorkers,
      shortlistedPdfs: results.map((r) => r['filename'] as String).toList(),
      userId: widget.user.id.toString(), // Assuming user.id is an int, convert it to string
    );

    // Add the new job to the user's jobs list
    Job job = widget.user.jobs[widget.jobIndex];
    job.shortlistedPdfs = results.map((r) => r['filename'] as String).toList();


    // Save the updated user object
    await widget.user.save();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => GetResult(results: results, user: widget.user),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Resume"),
        backgroundColor: Colors.cyan,
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height:40),
              ElevatedButton(
                onPressed: _selectFiles,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  "Select Files",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (_uploadedResumes.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: _uploadedResumes.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_uploadedResumes[index].path.split('/').last),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteResume(index),
                        ),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      String tempKeywords = '';
                      return AlertDialog(
                        title: Text("Enter Keywords"),
                        content: TextField(
                          onChanged: (value) {
                            tempKeywords = value;
                          },
                          decoration: InputDecoration(
                            hintText: "Enter keywords separated by commas",
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Submit'),
                            onPressed: () {
                              _addKeywords(tempKeywords);
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  "Keywords",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (_keywords.isNotEmpty)
                Wrap(
                  spacing: 8.0,
                  children: _keywords.map((keyword) => Chip(
                    label: Text(keyword),
                    onDeleted: () {
                      setState(() {
                        _keywords.remove(keyword);
                      });
                    },
                  )).toList(),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _getResults,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  "Get Results",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}