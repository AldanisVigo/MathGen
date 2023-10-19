import 'package:coursegen/problems.dart';
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
        useMaterial3: true,
      ),
      home: const Problems(course: "PreCalculus", topics: [
        "precalc_identifying_and_evaluating_functions",
        "precalc_domain_and_range_of_functions"
      ])
    );
  }
}

