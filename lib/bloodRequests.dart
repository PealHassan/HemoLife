import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:hemolife/database.dart';

class bloodRequests extends StatefulWidget {
  
  String email = "";
  bloodRequests({required this.email});
  bloodRequestsState createState() => bloodRequestsState();  
}
class bloodRequestsState extends State<bloodRequests> {
  String phoneno = '';
  List<List<String>> requests = [];
  List<bool>progress = [];
  List<bool>showStatus = [];
  List<String>statusMessage= [];
  List<String>statusColor = [];
  bool checkingDone = false;  
  @override
  void initState() {
    super.initState();
    _loadPhoneAndRequests();
  }
  Future<void> _loadPhoneAndRequests() async {
    await _loadPhone();
    await _loadRequests();
    await _loadFlags();
    checkingDone = true;
  }
  Future<void> _loadPhone() async {
    String val = await AppDatabase().getPhoneNo(widget.email);
    setState(() {
      phoneno = val;
    });
  }
  Future<void> _loadRequests() async {
    List< List<String>>  val = await AppDatabase().getRequests(phoneno);
    setState(() {
      requests = val;
      print(requests.length);
    });
  }
  Future<void> _loadFlags() async{
    progress.clear();  
    showStatus.clear();   
    for(int i = 0; i < requests.length;i++) {
      progress.add(false);   
      showStatus.add(false);
      statusMessage.add('Accepted');
      statusColor.add('green');
    }
    print(progress.length);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            'Blood Requests',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Center(
        child: checkingDone==false? CircularProgressIndicator(
          color: Colors.red,
        ):requests.length==0? Center(
          child: Text(
            'No Requests Found.',  
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
        :Container(
          width: 300,
          child: Column(
            children: [
              SizedBox(height: 20,),
              Expanded(
                child: ListView.builder(
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    List<String> request = requests[index];
                    return Card(
                      elevation: 20,
                      child: Container(
                        height: 170,
                        child: ListTile(
                          title: Text(
                            'Request ' + (index+1).toString(),
                             style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                             ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 15),
                              Text(
                                'Request Placed at ' + DateFormat('yyyy-MM-dd').format(DateTime.parse(request[3] as String)),
                              ),
                              SizedBox(height: 1),
                              Text(
                                'Donation Deadline : ' + DateFormat('yyyy-MM-dd').format(DateTime.parse(request[5] as String)),
                              ),
                              SizedBox(height: 8),
                              Text(
                                request[4]!=''?request[4]:'location not shared',
                              ),
                              SizedBox(height: 15),
                              progress[index]?Center(
                                child: CircularProgressIndicator(
                                  color: Colors.red,
                                ),
                              ):
                              showStatus[index]?Center(
                                child: Card(
                                  elevation: 20,
                                  child: Container(
                                    width: 100,
                                    height: 30,
                                    color: statusColor[index] == 'green'?Colors.green:Colors.red,
                                    child: Center(
                                      child: Text(
                                        statusMessage[index],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold, 
                                        ),
                                      ),
                                    ), 
                                  ), 
                                ),
                              ):
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.green,
                                    ),
                                    onPressed: () async{
                                      setState(() {
                                        progress[index] = true;
                                      });
                                      // database;  
                                      await AppDatabase().deleteRequest(request[1],request[2]);
                                      await AppDatabase().addResponse(widget.email,request[1],'Accepted');
                                      await AppDatabase().updateUserPerformance(widget.email,'no_of_acceptence');
                                      setState(() {
                                        progress[index] = false;
                                        showStatus[index] = true;
                                        statusMessage[index] = 'Accepted';  
                                        statusColor[index] = 'green';
                                      });
                                    }, 
                                    child: Text('Accept'),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.red,
                                    ),
                                    onPressed: () async{
                                      setState(() {
                                        progress[index] = true;
                                      });
                                      // database;  
                                      // Future.delayed(Duration(seconds: 5));
                                      await AppDatabase().deleteRequest(request[1],request[2]);
                                      await AppDatabase().addResponse(widget.email,request[1],'Rejected');
                                      await AppDatabase().updateUserPerformance(widget.email,'no_of_rejection');
                                      setState(() {
                                        progress[index] = false;
                                        showStatus[index] = true;
                                        statusMessage[index] = 'Rejected';  
                                        statusColor[index] = 'red';
                                      });
                                    }, 
                                    child: Text('Reject'),
                                  ),
                                ],
                              ),
                                // Add more text sections as needed
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}