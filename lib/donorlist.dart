import 'package:flutter/material.dart';
import 'package:hemolife/database.dart';
import 'package:flutter/widgets.dart';

import 'package:postgres/postgres.dart';


class donorlist extends StatefulWidget {
  final PostgreSQLResult? donors;
  
  String email = '';
  String place = '';
  DateTime deadline;
  donorlist({required this.donors,required this.email,required this.place,required this.deadline});
  donorlistState createState() => donorlistState(donors:donors);
}

class donorlistState extends State<donorlist> {
  bool isButtonVisible = true; 
  
  PostgreSQLResult? donors;
  donorlistState({required this.donors});
  
  
  void updateDonors(PostgreSQLResult? newDonors) {
    setState(() {
      donors = newDonors;
    });
  }
  late Future<List<String>> donor = fetch();
  List<String> showRequestButtons = [];
  Future<List<String>> fetch() async {
    
    List<String> tempDonor = [];
    try {
      if (donors != null) {
        for (var row in donors!) {
          tempDonor.add(row[3]);
          final String showButton =
            await AppDatabase().isInBloodRequestList(widget.email, row[3]);
          print(showButton.toString() + " X");
          showRequestButtons.add(showButton);
        }
      }
    } catch (e) {
      print(e);
    }
    // print(showRequestButtons[0] + ' peal');
    // setState(() {
    //   showRequestButtons = showRequestButtons;
    //    print(showRequestButtons[0] + ' peal');
    // });
     print('Number of donors: ${showRequestButtons.length}');
    return tempDonor;
  }
   
  
    
  

  @override
  Widget build(BuildContext context) {
    int cnt = 1;
    print('Number of donors: ${donors?.length}');

    return FutureBuilder<List<String>>(
      future: donor,
      builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(
            color: Colors.red,
          ); // Display a loading indicator while data is being fetched
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No donor data available.');
        } else {
          // showRequestButtons = List<String>.filled(snapshot.data!.length, 'yes');
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: snapshot.data!.map((row){
              final donorText = 'Donor ' + cnt.toString();
            
              isButtonVisible = showRequestButtons[cnt-1] == 'yes';
              cnt++;
             
              
              return Container(
                width: 300,
                height: 170,
                child: Card(
                  color: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Customize the border radius
                  ),
                  elevation: 20, 
                  child: Column(
                    
                    children: [
                      SizedBox(height: 30,),
                      Center(
                        child: Text(
                          donorText,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // Customize the color
                          ),
                        ),
                      ), 
                      SizedBox(height: 40,),
                      isButtonVisible ? ElevatedButton(
                      onPressed: () async {

                        await AppDatabase().addBloodRequest(widget.email,row, widget.place, widget.deadline);
                        await AppDatabase().updateUserPerformance(widget.email,'blood_requested');
                        String val = await AppDatabase().getEmail(row);
                        await AppDatabase().updateUserPerformance(val,'no_of_requests');
                        setState(() {
                          showRequestButtons.clear();
                          donor = fetch();

                        });
                        print('done');
                      },
                     
                      child: Text('Request'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: Colors.red,
                        textStyle: TextStyle(fontSize: 16),
                        
                      ),
                    ):Card(
                      
                       
                        elevation: 20,
                        child: Container(
                          
                          width: 100,
                          height: 30,
                          color: Colors.white,
                          child: Center(
                            child: Text(
                              'Requested',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                                fontWeight: FontWeight.bold, 
                              ),
                            ),
                          ), 
                        ), 
                      ),
                    
                    ],
                  ),
                ),
                
              );
              
            }).toList(), 
            
          );
          // return Te
        }
      },
    );
  }
}
