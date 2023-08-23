import 'package:flutter/material.dart';
import 'package:hemolife/database.dart';

class FeedbackPage extends StatefulWidget {
  final String email;

  FeedbackPage({required this.email});

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController _feedbackController = TextEditingController();
  bool sendingFeedback = false;  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // Set red as the app bar's background color
        title: Center(
          child: Text(
            'Feedback',
            style: TextStyle(
              color: Colors.red, // Set white as the app bar's text color
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 40,),
            Expanded(
              child: TextField(
                controller: _feedbackController,
                maxLines: null, // Allow multiple lines for feedback
                decoration: InputDecoration(
                              hintText: 'FeedBack',
                              contentPadding: EdgeInsets.all(30),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),
                            ),
              ),
            ),
            SizedBox(height: 16),
            sendingFeedback?Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            ): ElevatedButton(
              onPressed: () async{
                setState(() {
                  sendingFeedback = true;
                });
                if(_feedbackController.text == '') {
                    setState(() {
                      sendingFeedback = false;
                      _feedbackController.clear();
                    });
                    showDialog(
                    context: context, 
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Column(
                          children: [
                            Image.asset(
                            'assets/close.png',
                            width: 40,
                            height: 50,
                            // fit: BoxFit.cover,
                          ),
                            Text(
                              "Error",
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        content: Text("Null Messages Could not be sent !"),
                        actions: [
                          TextButton(
                            onPressed: () async{
                              Navigator.of(context).pop(); // Close the dialog                                      
                            },
                            child: Text(
                              "Okay",  
                              style: TextStyle(color: Colors.black),
                            ),
                          ),                                  
                        ],
                      );
                    },
                  );
                }
                else {
                  await AppDatabase().addFeedback(widget.email, _feedbackController.text);
                    setState(() {
                    sendingFeedback = false;
                    _feedbackController.clear();
                  });
                  showDialog(
                    context: context, 
                    builder: (BuildContext context) {
                      return AlertDialog(

                        title: Column(

                          children: [
                            Image.asset(
                            'assets/check-mark.png',
                            width: 40,
                            height: 50,
                            // fit: BoxFit.cover,
                          ),
                            Text(
                              "Thanks for the Feedback",
                              style: TextStyle(
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        content: Text("Your feedback will help us a lot to improve, stay connected"),
                        actions: [
                          TextButton(
                            onPressed: () async{
                              Navigator.of(context).pop(); // Close the dialog                                      
                            },
                            child: Text(
                              "Okay",  
                              style: TextStyle(color: Colors.black),
                            ),
                          ),                                  
                        ],
                      );
                    },
                  );
                }
                
                
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red), // Set red as the button's background color
              ),
              child: Text('Send', style: TextStyle(color: Colors.white)), // Set white as the button's text color
            ),
          ],
        ),
      ),
    );
  }

  
  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }
}
