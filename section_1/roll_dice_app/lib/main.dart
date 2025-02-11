import 'package:flutter/material.dart';
import 'package:roll_dice_app/components/gradient_container.dart';
import 'package:roll_dice_app/helpers/helpers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: getAppThemeData(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('First App'),
        ),
        body: GradientContainer.purple(),
      ),
    );
  }
}
