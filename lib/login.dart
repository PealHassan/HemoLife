import 'package:flutter/material.dart';
import 'package:hemolife/database.dart';
import 'package:postgres/postgres.dart';
import './register.dart';
import './home.dart'; 

class HemoLife extends StatefulWidget {
  
  HemoLifeState createState() => HemoLifeState();
}
class HemoLifeState extends State<HemoLife> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  String email = '';  
  String password = '';   
  bool isShowMessage = false;
  String message = '';
  bool isLoading = false;  
  void onEmailChanged(String value) {
    setState(() {
      email = value;
      // print(name);
    });
  }
  void onPasswordChanged(String value) {
    setState(() {
      password = value;
      // print(name);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: isLoading?CircularProgressIndicator(
                  color: Colors.red,
                  // valueColor: AlwaysStoppedAnimation<Color>(Colors.red), // Customize the color
                  strokeWidth: 5,
                ):isShowMessage?Scaffold(
                  body: Column(
                  
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
                                message,
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
                              ),
                ):Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              Positioned.fill(
                  child: Container(
                    child: Image.asset(
                    'assets/loginpage.png',
                    fit: BoxFit.cover,
                  ),
                ),
                
              ),
              Container(
                padding: EdgeInsets.only(left: 100, bottom: 550),
                child: Image.asset(  
                     'assets/logo.png',
                      width: 150,
                      height: 300,
                      // fit: BoxFit.cover,
                ),
              ),
             
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height*.5,
                    left: 35,  
                    right: 35,
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: _email,
                        onChanged: onEmailChanged,
                        cursorColor: Colors.red,
                        decoration: InputDecoration(
                          // fillColor: Colors.grey.shade100,
                          // filled: true,
                          hintText: 'Email',
                          
                         
                          focusedBorder: UnderlineInputBorder(
                           
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            // borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextField(
                        controller: _password,
                        onChanged: onPasswordChanged,
                        cursorColor: Colors.red,
                        obscureText: true,
                         decoration: InputDecoration(
                          // fillColor: Colors.grey.shade100,
                          // filled: true,
                          hintText: 'Password',
                         
                         
                          focusedBorder: UnderlineInputBorder(
                           
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            // borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                         ),
                        ),
                      
                      SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Sign In',
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
                              onPressed: ()async{
                                setState(() {
                                  isLoading = true;
                                });
                                PostgreSQLResult? loginStatus = await AppDatabase().loginUser(email, password);
                                if(loginStatus!.affectedRowCount <= 0) {
                                   setState(() {
                                    isLoading = false;
                                    isShowMessage = true;
                                    message = 'UserName or Password is Incorrect';
                                  });
                                }
                                else {
                                 PostgreSQLResultRow row = loginStatus![0];
                                 String? x = row[0] as String?;
                                 String name = '';
                                 if(x != null) name = x;
                              
                                  print(email);
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home(email:email,name:name)));
                                } 
                                
                              }, 
                              icon: Icon(Icons.arrow_forward),
                            ),
                          ),
                        ], 
                      ),
                      SizedBox(
                        height: 90,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                         Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.red,
                              width: 5.0, // Set the border width as desired
                            ),
                          ),
                           child: TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => register()));
                            }, 
                                               
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                // decoration: TextDecoration.underline,
                                fontSize: 18,
                                color: Colors.red,
                              ),
                            ),
                           ),
                         ),
                         Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.red,
                              width: 5.0, // Set the border width as desired
                            ),
                          ),
                           child: TextButton(
                            onPressed: () {}, 
                            child: Text(
                              'Forgot Password',
                              style: TextStyle(
                               
                                fontSize: 18,
                                color: Colors.red,
                              ),
                            ),
                           ),
                         ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
    );
    
  }
}