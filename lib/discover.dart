import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'UploadResumePage.dart';
import 'database/job_model.dart';
import 'database/model.dart';

class Discover extends StatefulWidget {
  final User user;// Add this line
  const Discover({Key? key, required this.user}) : super(key: key);

  @override
  State<Discover> createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _jobDescriptionController = TextEditingController();
  final TextEditingController _noOfWorkersController = TextEditingController();

  @override
  void dispose() {
    _jobTitleController.dispose();
    _jobDescriptionController.dispose();
    _noOfWorkersController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Discover"),
        backgroundColor: Colors.cyan,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),
                  TextFormField(
                    controller: _jobTitleController,
                    decoration: InputDecoration(
                      labelText: 'Job Title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(color: Colors.cyan),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a job title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _jobDescriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Job Description',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(color: Colors.cyan),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _noOfWorkersController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Number of Workers Needed',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(color: Colors.cyan),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the number of workers needed';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          final job = Job(
                            title: _jobTitleController.text,
                            description: _jobDescriptionController.text,
                            numberOfWorkers: int.parse(_noOfWorkersController.text),
                            shortlistedPdfs: [],
                            userId: widget.user.id.toString(), // Assuming user.id is an int, convert it to string
                          );

                          final box = await Hive.openBox<Job>('jobs');
                          widget.user.jobs.add(job);
                          await widget.user.save();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UploadResumePage(

                                numberOfWorkers: int.parse(_noOfWorkersController.text),
                                user: widget.user,
                                jobIndex: widget.user.jobs.length - 1,// Pass the user object
                              ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan,
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text(
                        "Parse Resume",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
