import 'package:flutter/material.dart';
import 'package:hacker_news/models/VisitedNewsModel.dart';
import 'package:provider/provider.dart';
import './FirstPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hacker News',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // using Provider package for state management
      home: ChangeNotifierProvider(
          create: (context) => VisitedNewsModel(), child: FirstPage()),
    );
  }
}
