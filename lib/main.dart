// import 'package:christ_practice/run/screen/run_screen.dart';
// import 'package:christ_practice/run_vertical/screen/run_vertical_screen.dart';
// import 'package:christ_practice/update_run/view/update_run_screen.dart' show UpdateRunScreen;
//import 'package:christ_practice/run_tracker/screen/run_tracker_screen.dart' show RunTrackerScreen;
import 'package:christ_practice/updated_run_vertical/view/Updated_run_vertical_screen.dart' show UpdatedRunVerticalScreen;
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: UpdatedRunVerticalScreen(),
    );
  }
}

