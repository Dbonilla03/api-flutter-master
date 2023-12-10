import 'package:flutter/material.dart';
import 'screens/loading.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bienestar',
      theme: ThemeData(
        primarySwatch: Colors.green,
        shadowColor: Colors.green,
      ),
      home: Scaffold(
        body: Loading(),
      ),
    );
  }
}
