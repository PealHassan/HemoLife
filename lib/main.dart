import 'package:flutter/material.dart';
import 'package:hemolife/splash.dart';

void main() => runApp(HemoLife());   

class HemoLife extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Splash(),
    );
  }
}