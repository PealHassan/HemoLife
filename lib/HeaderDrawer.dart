import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import './HeaderDrawer.dart';

class HeaderDrawer extends StatefulWidget {
  final String email,name;// Add this line

  HeaderDrawer({required this.email,required this.name});
  HeaderDrawerState createState() => HeaderDrawerState(); 
}
class HeaderDrawerState extends State<HeaderDrawer> {
  @override 
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 255, 0, 0),
      width: double.infinity,
      height: 200,
      padding: EdgeInsets.only(top: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            Container(
              margin: EdgeInsets.only(bottom: 10),
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('assets/profile.png'),
                ),
              ),
            ),
          SizedBox(height: 20,),
          Text(
             widget.name,
             style: TextStyle(
              color: Colors.white, fontSize: 18,
             ),
          ),
          SizedBox(height: 10,),
          Text(
            widget.email,
             style: TextStyle(
              color: Colors.white, fontSize: 15,
             ),
          ),
        ],
      ),
    );
  }
}