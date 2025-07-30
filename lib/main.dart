import 'package:flutter/material.dart';
import 'package:simpletreasury/core/appa_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: appTheme,
      home: Scaffold(appBar: AppBar(), body: Center()),
    );
  }
}
