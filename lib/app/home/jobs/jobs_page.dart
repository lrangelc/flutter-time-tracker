import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_time_tracker/app/home/job_entries/job_entries_page.dart';

import 'package:flutter_time_tracker/app/home/jobs/edit_job_page.dart';
import 'package:flutter_time_tracker/app/home/jobs/job_list_tile.dart';
import 'package:flutter_time_tracker/app/home/jobs/list_items_builder.dart';

import 'package:flutter_time_tracker/app/home/models/job.dart';
import 'package:flutter_time_tracker/common_widgets/platform_alert_dialog.dart';
import 'package:flutter_time_tracker/common_widgets/platform_exception_alert_dialog.dart';
import 'package:flutter_time_tracker/services/auth.dart';
import 'package:flutter_time_tracker/services/database.dart';
import 'package:provider/provider.dart';

class JobsPage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);

      await auth.signOut();
    } catch (err) {
      PlatformAlertDialog(
        title: 'Sign in failed',
        content: err.toString(),
        defaultActionText: 'OK',
      ).show(context);
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final bool didRequestSignOut = await PlatformAlertDialog(
      title: 'Logout',
      content: 'Are you sure that you want to logout?',
      defaultActionText: 'Logout',
      cancelActionText: 'Cancel',
    ).show(context);
    if (didRequestSignOut) {
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jobs'),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Logout',
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            ),
            onPressed: () => _confirmSignOut(context),
          ),
        ],
      ),
      body: _buildContents(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () => EditJobPage.show(context,
            database: Provider.of<Database>(context, listen: false)),
        child: Icon(Icons.add),
      ),
    );
  }

  // Future<void> _createJob(BuildContext context) async {
  //   try {
  //     final database = Provider.of<Database>(context, listen: false);
  //     await database.createJob(Job(name: 'Blogging', ratePerHour: 10));
  //   } catch (err) {
  //     PlatformExceptionAlertDialog(
  //       title: 'Operation failed',
  //       exception: err,
  //     ).show(context);
  //   }
  // }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Job>>(
      stream: database.jobsStream(),
      builder: (context, snapshot) {
        return ListItemsBuilder<Job>(
          snapshot: snapshot,
          itemBuilder: (context, job) => Dismissible(
            key: Key('job-${job.id}'),
            background: Container(color: Colors.red),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => _deleteJob(context, job),
            child: JobListTile(
              job: job,
              onTap: () => JobEntriesPage.show(
                context,
                job,
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _deleteJob(BuildContext context, Job job) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteJob2(job);
    } on PlatformException catch (err) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: err,
      ).show(context);
    }
  }
}
