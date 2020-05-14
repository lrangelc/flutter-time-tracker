import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_time_tracker/app/home/models/job.dart';
import 'package:flutter_time_tracker/common_widgets/platform_alert_dialog.dart';
import 'package:flutter_time_tracker/common_widgets/platform_exception_alert_dialog.dart';
import 'package:provider/provider.dart';

import 'package:flutter_time_tracker/services/database.dart';

class EditJobPage extends StatefulWidget {
  final Database database;
  final Job job;

  const EditJobPage({Key key, @required this.database, this.job})
      : super(key: key);

  static Future<void> show(BuildContext context, {Job job}) async {
    final database = Provider.of<Database>(context, listen: false);

    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => EditJobPage(
        database: database,
        job: job,
      ),
      fullscreenDialog: true,
    ));
  }

  @override
  _EditJobPageState createState() => _EditJobPageState();
}

class _EditJobPageState extends State<EditJobPage> {
  final _formKey = GlobalKey<FormState>();

  String _name;
  int _ratePerHour;

  @override
  void initState() {
    super.initState();
    if (widget.job != null) {
      _name = widget.job.name;
      _ratePerHour = widget.job.ratePerHour;
    }
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(widget.job == null ? 'New Job' : 'Edit Job'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Save',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            onPressed: _submit,
          )
        ],
      ),
      body: _buildContents(),
      backgroundColor: Colors.grey[200],
    );
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        final jobs = await widget.database.jobsStream().first;
        final allNames = jobs.map((job) => job.name).toList();
        if (widget.job != null) {
          allNames.remove(widget.job.name);
        }
        if (allNames.contains(_name)) {
          PlatformAlertDialog(
            title: 'Name already used',
            content: 'Please choose a different job name',
            defaultActionText: 'OK',
          ).show(context);
        } else {
          print('Form saved, name: $_name rate per hour: $_ratePerHour');
          final job = Job(name: _name, ratePerHour: _ratePerHour);
          if (widget.job == null) {
            await widget.database.createJob2(job);
          } else {
            job.id = widget.job.id;
            await widget.database.updateJob(job);
          }
          Navigator.of(context).pop();
        }
      } on PlatformException catch (err) {
        PlatformExceptionAlertDialog(
          title: 'Operation failed',
          exception: err,
        ).show(context);
      }
    }
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        decoration: InputDecoration(labelText: 'Job Name'),
        initialValue: _name,
        validator: (value) => value.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _name = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Rate per hour'),
        initialValue: _ratePerHour != null ? _ratePerHour.toString() : null,
        keyboardType:
            TextInputType.numberWithOptions(signed: false, decimal: false),
        onSaved: (value) => _ratePerHour = int.tryParse(value) ?? 0,
      ),
    ];
  }
}
