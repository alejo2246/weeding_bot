import 'package:flutter/material.dart';
import 'package:weeding_bot/custom%20widgets/reproductor_widget.dart';
import 'package:weeding_bot/screens/virtual_control.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weeding Bot',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const VideoPlayerWidget(),
    );
  }
}
