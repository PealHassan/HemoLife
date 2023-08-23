import 'package:flutter/material.dart';
import 'package:hemolife/database.dart';
import 'package:intl/intl.dart';

class donationHistory extends StatefulWidget {
  String email = '';
  donationHistory({required this.email});
  donationHistoryState createState() => donationHistoryState();   
}
class donationHistoryState extends State<donationHistory> {
  List< List<String> > donationList = [];
  bool checkingDone = false;  
  @override
  void initState() {
    super.initState();   
    loadPage();
  }
  Future<void> loadPage() async{
    await getDonationList();
    checkingDone = true;
  }
  Future<void> getDonationList() async {
    List< List<String> > temp = await AppDatabase().getDonationHistory(widget.email);
    setState(() {
      donationList = temp;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            'Donation History',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
        ),
      ),
      body: checkingDone == false?Center(
        child: CircularProgressIndicator(
          color: Colors.red,
        ),
      ):Center(
        child: Container(
          width: 300,
          child: Column(
            children: [
              SizedBox(height: 20,),   
              Expanded(
                child: ListView.builder(
                  itemCount: donationList.length,
                  itemBuilder: (context, index) {
                    List<String>donation = donationList[index];
                    return Card(
                      elevation: 20,
                      child: Container(
                        height: 100,
                        child: ListTile(
                          title: Text(
                            'Donation ' + (index+1).toString(),
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            
                            ),
                          ),
                        
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20,),
                              Text(
                                'Donated To : ' + donation[2],
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5,),
                              Text(
                                'Donation Date : ' + DateFormat('yyyy-MM-dd').format(DateTime.parse(donation[3] as String)),
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