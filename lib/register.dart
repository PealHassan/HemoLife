import 'dart:async';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:hemolife/login.dart';
import './database.dart';

class register extends StatefulWidget {
 registerState createState() => registerState();
}
class registerState extends State<register> {
  @override
  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _phoneno = TextEditingController();
  TextEditingController _bloodgroup = TextEditingController();
  TextEditingController _medicalreport = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _confrimpassword = TextEditingController();
  TextEditingController _city = TextEditingController();
  TextEditingController _district = TextEditingController();
  TextEditingController _address = TextEditingController(); // Controller for the TextField
  String name = "";
  String email = "";  
  String bloodGroup = "";  
  String password = "";  
  String confirmPassword = "";   
  String phoneNo = "";    
  String city = "";    
  String address = "";  
  String district = "";  
  String medicalreport = "";
  bool isLoading = false;
  bool isShowMessage = false;  
  String registrationMessage = "";
  void onNameChanged(String value) {
    setState(() {
      name = value;
      print(name);
    });
  }
   void onEmailChanged(String value) {
    setState(() {
      email = value;
      print(email);
    });
  }
   void onBloodGroupChanged(String value) {
    setState(() {
      bloodGroup = value;
    });
  }
   void onPhoneNoChanged(String value) {
    setState(() {
      phoneNo = value;
    });
  }
   void onCityChanged(String value) {
    setState(() {
      city = value;
    });
  }
  void onDistrictChanged(String value) {
    setState(() {
      district = value;
    });
  }
   void onAddressChanged(String value) {
    setState(() {
      address = value;
    });
  }
   void onPasswordChanged(String value) {
    setState(() {
      password = value;
    });
  }
   void onConfrimPasswordChanged(String value) {
    setState(() {
      confirmPassword = value;
    });
  }
   void onMedicalReportChanged(String value) {
    setState(() {
      medicalreport = value;
    });
  }
  
  

  String selectedCourseValue = "";
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Color.fromARGB(255, 158, 23, 13),
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // Container(
              // padding: EdgeInsets.only(left: 100, bottom: 550),
            //   child: Image.asset(  
            //        'assets/redlogo.png',
            //         width: 150,
            //         height: 300,
            //         // fit: BoxFit.cover,
            //   ),
            // ),
            isLoading?Center(
              child: CircularProgressIndicator(
                color: Colors.red,
                // valueColor: AlwaysStoppedAnimation<Color>(Colors.red), // Customize the color
                strokeWidth: 5,
                
              ),
            ):isShowMessage?Column(
              
              children: [
                Padding(padding: EdgeInsets.all(150)),
                Center(
                    child: Container(
                      width: 300,
                      height: 120,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Customize the border radius
                        ),
                        elevation: 20, 
                        child: Center(
                          child: Text(
                            registrationMessage,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.red, // Customize the color
                            ),
                          ),
                        ),
                      ),
                    ),
                ),
                 SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HemoLife())); // Handle button press, e.g., navigate to another screen
                  },
                  child: Text('Continue'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    textStyle: TextStyle(fontSize: 16),
                    
                  ),
                ),
              ],
            ):
            SingleChildScrollView(
              child: Container(
                
                padding: EdgeInsets.only(
                  // top: MediaQuery.of(context).size.height*.2,
                  left: 35,  
                  right: 35,
                ),
                child: Column(
                  children: [
                    
                    Image.asset(  
                   'assets/redlogo.png',
                    width: 150,
                    height: 300,
                    // fit: BoxFit.cover,
                    ),
                    // SizedBox(height: 10),
                    Image.asset(
                          'assets/information.png',
                          width: 80,
                          height: 80,
                          // fit: BoxFit.cover,
                        ),
                         SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          'assets/user.png',
                          width: 40,
                          height: 50,
                          // fit: BoxFit.cover,
                        ),
                        SizedBox(width: 10), // Add spacing between the image and text field
                        Expanded(
                          child: TextField(
                            controller: _name,
                            onChanged: onNameChanged,
                            cursorColor: Colors.red,
                            decoration: InputDecoration(
                              hintText: 'Name',
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                       
                     
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          'assets/email.png',
                          width: 40,
                          height: 50,
                          // fit: BoxFit.cover,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _email,
                            onChanged: onEmailChanged,
                            cursorColor: Colors.red,
                            decoration: InputDecoration(
                              hintText: 'Email',
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                // borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.red),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          'assets/phoneNo.png',
                          width: 40,
                          height: 50,
                          // fit: BoxFit.cover,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _phoneno,
                            onChanged: onPhoneNoChanged,
                            cursorColor: Colors.red,
                            decoration: InputDecoration(
                              hintText: '+880',
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                // borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.red),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          'assets/bloodGroup.png',
                          width: 40,
                          height: 50,
                          // fit: BoxFit.cover,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _bloodgroup,
                            onChanged: onBloodGroupChanged,
                            cursorColor: Colors.red,
                            decoration: InputDecoration(
                              hintText: 'Blood Group',
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                // borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.red),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          'assets/medicalReport.png',
                          width: 40,
                          height: 50,
                          // fit: BoxFit.cover,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _medicalreport,
                            onChanged: onMedicalReportChanged,
                            cursorColor: Colors.red,
                            decoration: InputDecoration(
                              hintText: 'Medical Report',
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                // borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.red),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Image.asset(
                          'assets/location.png',
                          width: 80,
                          height: 80,
                          // fit: BoxFit.cover,
                        ),
                      SizedBox(
                      height: 30,
                    ),
                    TextField(
                      controller: _district,
                      onChanged: onDistrictChanged,
                      cursorColor: Colors.red,
                      decoration: InputDecoration(
                        hintText: 'District',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          // borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextField(
                      controller: _city,
                      onChanged: onCityChanged,
                      cursorColor: Colors.red,
                      
                       decoration: InputDecoration(
                        hintText: 'City',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          // borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                       ),
                      ),
                    
                    SizedBox(
                      height: 40,
                    ),
                    TextField(
                      controller: _address,
                      onChanged: onAddressChanged,
                      cursorColor: Colors.red,
                      decoration: InputDecoration(
                        hintText: 'Address',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          // borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    
                    Image.asset(
                          'assets/shield.png',
                          width: 80,
                          height: 80,
                          // fit: BoxFit.cover,
                        ),
                        SizedBox(
                      height: 30,
                    ),

                    
                    TextField(
                      obscureText: true,
                      controller: _password,
                      onChanged: onPasswordChanged,
                      cursorColor: Colors.red,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          // borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextField(
                      obscureText: true,
                      controller: _confrimpassword,
                      onChanged: onConfrimPasswordChanged,
                      cursorColor: Colors.red,
                      decoration: InputDecoration(
                        hintText: 'Confirm Password',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          // borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.bold,  
                            color: Colors.red,
                          ),
                        ),
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.red,
                          child: IconButton(
                              color: Colors.white,
                              onPressed: () async {
                                setState(() {
                                  isLoading = true; // Show loader
                                });

                                String futureUser = await AppDatabase().registerUserInformation(name, email, phoneNo, password, district, city, address, medicalreport, bloodGroup);
                                print(futureUser);
                                
                                setState(() {
                                  isLoading = false; // Hide loader
                                  isShowMessage = true;
                                  if (futureUser == 'reg') {
                                    registrationMessage = 'Registration Successful';
                                  } else if(futureUser == 'alr') {
                                    registrationMessage = 'Already Registered';
                                  }
                                  else {
                                    registrationMessage = 'Registration Failed\nCheck Your Internet Connection\nAll Data Entries Should fill\nGive Valid Information';
                                  }
                                });
                              },
                              icon: Icon(Icons.arrow_forward),
                            ),
                          ),
                        
                      ], 
                    ),
                    SizedBox(
                          height: 30,
                    ),
                    
                    
                    
                  ],
                ),
                
              ),
              
            ),
            
             
      ],
        ),
      );
  }
}