import 'package:flutter/material.dart';
import 'login.dart';
class Splash extends StatefulWidget {
  @override
  SplashState createState() => SplashState();
}
class SplashState extends State<Splash> {
  void initState() {
    super.initState();
    _navigatetohome();
  }
  void _navigatetohome()async{
    await Future.delayed(Duration(milliseconds: 1500), (){});
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HemoLife()));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/blood-drop.png', // Replace with your image asset path
              width: 150,
              height: 300,
            ),
            // SizedBox(height: 16),
            Image.asset(
              'assets/logo.png', // Replace with your image asset path
              width: 150,
              height: 300,
            ), // Add spacing between image and text
            // Text(
            //   'HemoLife',
            //   style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
            // ),
          ],
        ),
      ),
    );
  }
}