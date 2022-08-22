import 'package:flutter/material.dart';
import 'largeFileMain.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
            home: LargeFileMain(),
    );
  }
}