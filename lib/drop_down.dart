import 'package:flutter/material.dart';
void main() => runApp(drop_down());
class drop_down extends StatefulWidget {
  @override
  State<drop_down> createState() => drop_downState();
}
class drop_downState extends State<drop_down> {
  List dropdownlistdata = [
    {'title': 'CSE', 'value' : 1},  
    {'title': 'EEE', 'value' : 2},
  ];
  int defaultvalue = 1;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          DropdownButton(
            value: defaultvalue,
            isExpanded: true,
            menuMaxHeight: 350,
            items: [
              const DropdownMenuItem(
                child: Text("CSE"),
                value: 1,
              ),
            ],
            onChanged: (value) {
              print("seclect value $value");
            },
          ),
        ],
      ),
    );
  }
}