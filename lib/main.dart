import 'package:flutter/material.dart';

import 'package:flutter_time_tracker/app/sign_in/sign_in_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Tracker',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: SignInPage(),
    );
    // return MaterialApp(
    //   title: 'Material App',
    //   home: Scaffold(
    //     appBar: AppBar(
    //       title: Text('Material App Bar'),
    //     ),
    //     body: Center(
    //       child: Container(
    //         child: Text('Hello World'),
    //       ),
    //     ),
    //   ),
    // );
  }
}
