import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Tracker'),
        centerTitle: true,
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return Container(
      color: Colors.yellow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            color: Colors.orange,
            child: SizedBox(
              height: 100,
            ),
          ),
          Container(
            color: Colors.red,
            child: SizedBox(
              height: 100,
            ),
          ),
          Container(
            color: Colors.purple,
            child: SizedBox(
              height: 100,
            ),
          ),
        ],
      ),
    );
  }
}
