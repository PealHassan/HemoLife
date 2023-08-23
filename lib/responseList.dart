import 'package:flutter/material.dart';
import 'package:hemolife/database.dart';
import 'package:intl/intl.dart';

class responseList extends StatefulWidget {
  String email = '';  
 
  responseList({required this.email});
  responseListState createState() => responseListState();   
  
}
class responseListState extends State<responseList> {
  List< List<String> > responseList = [];   
  List< String > bloodgroupList = [];
  List< String > phonenoList = [];  
  
  bool checkingDone = false;
  @override 
  void initState() {
    super.initState();
    loadPage();
    
  }
  Future<void> loadPage() async{
    await getResponseList();
    await getBloodGroupList();
    await getPhoneNoList();
   
    checkingDone = true;
  }
  Future<void> getResponseList() async{
    List<List<String>> temp = await AppDatabase().getResponseList(widget.email);
    setState(() {
      responseList = temp;
    });
    
  }
  Future<void> getBloodGroupList() async {
    for(int i = 0; i < responseList.length; i++) {
      String x = await AppDatabase().getBloodGroup(responseList[i][1]);
      setState(() {
        bloodgroupList.add(x);
      });
    }
    
  }
  
  Future<void> getPhoneNoList() async {
    for(int i = 0; i < responseList.length; i++) {
      String x = await AppDatabase().getPhoneNo(responseList[i][1]);
      setState(() {
        phonenoList.add(x);
      });
    }
   
  }


  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            'Responses',
            style: TextStyle(
              color:  Colors.red,    
             ),
          ),
        ),
      ),
      body: checkingDone == false?Center(
        child: CircularProgressIndicator(
          color: Colors.red,
        ),
      ): responseList.length == 0?Center(
          child: Text(
            'No Responses Yet',   
             style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
             ),
          ),
        ):Center(
        child: Container(
          width: 300,
          child: Column(
            children: [
              SizedBox(height: 20,),
              Expanded(
                
                child: ListView.builder(
                  itemCount: responseList.length,
                  itemBuilder: (context, index) {
                    
                    List<String> response = responseList[index];
                    
                    return Card(
                      elevation: 20,
                      child: Container(
                        
                        height: 210,
                        child: ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Response ' + (index+1).toString(),
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                DateFormat('yyyy-MM-dd').format(DateTime.parse(response[3] as String))
                              ),
                            ],
                          ),
                          subtitle: Column(
                            
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20,),
                              Text(
                                'Your Request for blood group ' + bloodgroupList[index] + 
                                ' has been accepted by a donor',
                              ),
                              SizedBox(height: 10,),
                              Text(
                                'Donor Information : ',
                                 style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                 ),
                              ),
                              SizedBox(height: 8,),   
                              Text(
                                'Phone No : 0'+phonenoList[index],
                              ),
                              SizedBox(height: 5,),
                              Text(
                                'Email : ' + response[1],
                              ),
                              SizedBox(height: 10,),   
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red,
                                ),
                                onPressed: () {
                                  // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => responseClear(email:widget.email)));
                                  showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        "Confirmation",
                                        style: TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
                                      content: Text("Is the donation from the donor is successful ? "),
                                      actions: [
                                        TextButton(
                                          onPressed: () async{
                                            await AppDatabase().clearResponse(response[1],response[2]); // Implement your clear function
                                            Navigator.of(context).pop(); // Close the dialog
                                            setState(() {
                                              checkingDone = false;
                                              loadPage();
                                            });
                                          },
                                          child: Text(
                                            "NO",  
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                           
                                            // Perform the clear action
                                            await AppDatabase().clearRelatedResponses(response[1]); // Implement your clear function
                                            await AppDatabase().addDonation(response[1], response[2], bloodgroupList[index]);
                                            await AppDatabase().updateUserStatus(response[1], false);
                                            await AppDatabase().clearRelatedRequests(phonenoList[index]);
                                            await AppDatabase().updateUserPerformance(response[1], 'no_of_donation');
                                            // Close the dialog
                                            Navigator.of(context).pop();
                                            setState(() {
                                              checkingDone = false;
                                              loadPage();
                                            });
                                          },
                                          child: Text("YES",style: TextStyle(color: Colors.green),),
                                        ),
                                      ],
                                    );
                                  },
                                );
                                }, 
                                child: Text(
                                  'clear',   
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}