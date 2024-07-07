import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import 'database/job_model.dart';
import 'database/model.dart';

class JobsPage extends StatelessWidget {
  final User user;
  const JobsPage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Jobs"),
        backgroundColor: Colors.cyan,
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<User>('UserDB').listenable(),
        builder: (context, Box<User> box, _) {
          final updatedUser = box.get(user.key);
          if (updatedUser == null || updatedUser.jobs.isEmpty) {
            return Center(child: Text('No jobs found'));
          }
          return ListView.builder(
            itemCount: updatedUser.jobs.length,
            itemBuilder: (context, index) {
              final job = updatedUser.jobs[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(job.title ?? 'No Title'),
                  subtitle: Text(job.description ?? 'No Description'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => deleteJob(context, updatedUser, index),
                  ),
                  onTap: () => showJobDetails(context, job),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void deleteJob(BuildContext context, User updatedUser, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Job'),
          content: Text('Are you sure you want to delete this job?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                updatedUser.jobs.removeAt(index);
                updatedUser.save();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showJobDetails(BuildContext context, Job job) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(job.title ?? 'No Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Description: ${job.description ?? 'No Description'}'),
                Text('Number of Workers: ${job.numberOfWorkers ?? 'Not specified'}'),
                SizedBox(height: 8),
                Text('Shortlisted PDFs:'),
                ...(job.shortlistedPdfs ?? []).map((pdf) => Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Text('• $pdf'),
                )),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}