import 'package:flutter/material.dart';
import 'package:hemolife/database.dart';
import 'package:pie_chart/pie_chart.dart';


class profile extends StatefulWidget {
  String email = '';
  String name = '';  

  profile({required this.email,required this.name});
  
  profileState createState() => profileState();   
}
class profileState extends State<profile> {
  List<String>userPerformance = [];
  List<String>userAddress = [];
  bool checkingDone = false;  
  bool userStatus = false;
  String bloodGroup = '';
  Map<String,double> datamap = {
    'Successful Donation' : 0,
    'Request Accepted but not Donated' : 0,  
    'Request Ignored' : 0,
    'Request Rejecton' : 0,
  };
  @override 
  void initState() {
    super.initState();  
    loadPage();
  }
  Future<void> loadPage() async {
    await getUserPerformance();
    await getUserStatus();
    await getBloodGroup();  
    await getUserAddress();  
    checkingDone = true;  
  }
  Future<void>getUserAddress() async {
    List<String> val = await AppDatabase().getUserAddress(widget.email);   
    setState(() {
      userAddress = val;
    });
  }
  Future<void> getBloodGroup() async {
    String val = await AppDatabase().getBloodGroup(widget.email);  
    setState(() {
      bloodGroup = val;  
    });
  }
  Future<void>getUserStatus() async {
    bool temp = await AppDatabase().getUserStatus(widget.email);
    setState(() {
      userStatus = temp;
    });
  }
  Future<void> getUserPerformance() async {
    List<String> temp = await AppDatabase().getUserPerformance(widget.email);
    int  bloodRequested = 0;
    List<double>val = [];  
    val.add(double.parse(temp[1]));   //0
    val.add(double.parse(temp[2]));   //1
    val.add(double.parse(temp[3]));   //2
    val.add(double.parse(temp[4]));   //3
    val.add(double.parse(temp[5]));   //4
    setState(() {
      userPerformance = temp;
      datamap['Successful Donation'] = val[0];
      datamap['Request Accepted but not Donated'] = val[2]-val[0];
      datamap['Request Ignored'] = val[1]-val[2]-val[3];
      datamap['Request Rejecton'] = val[3];   
      bloodRequested = int.parse(temp[5]);
    });
  }
  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            'Profile',   
            style: TextStyle(
              color: Colors.red,
              fontSize: 20,  
              fontWeight : FontWeight.bold,
            ),
          ),
        ),
      ),
      body: checkingDone == false?Center(
        child: CircularProgressIndicator(
          color: Colors.red,
        ),
      ):SingleChildScrollView(
        child: Center(
          child: Column(
      
            children: [
              SizedBox(height: 20,),
              Center(
                      child: Container(
                        width: 300,
                        height: 60,
                        // child: Card(
                          // elevation: 20,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.name,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(width: 10,),
                              userStatus?Image.asset(  
                                  'assets/check-mark.png',
                                      height: 30,
                                    // fit: BoxFit.cover,
                                    ):Image.asset(  
                                  'assets/prohibition.png',
                                      height: 30,
                                    // fit: BoxFit.cover,
                                    ),
                              
                            ],
                          ),
                        // ),
                      ),
                    ),
              SizedBox(height:10),
              Container(
                width: 300,
                // child: Card(
                  // elevation: 20,
                  child: ListTile(
                    subtitle: Column(
                      children: [
                        SizedBox(height: 10,),
                        Container(
                          width: 250,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(  
                              'assets/email.png',
                                  height: 50,
                                // fit: BoxFit.cover,
                                ),
                              Text(
                                widget.email,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          width: 250,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset(  
                                'assets/bloodGroup.png',
                                    height: 50,
                                  // fit: BoxFit.cover,
                                  ),
                                SizedBox(width: 20,),
                                Text(
                                  bloodGroup,
                                   style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20,),
                        
                        
                      ],
                    ),
                    
                  ),
                // ),
              ),
              SizedBox(height: 20,),
              // Card(
                // elevation: 20,
              Container(
                  width: 300,
                  height: 40,
                  child: Center(
                    child: Text(
                      'Address Information',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              // ),
             
            //  Card(
                // elevation: 20,
              Container(
                  width: 300,
                  height: 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 10,),
                      Image.asset(  
                                'assets/location.png',
                                    height: 50,
                                  // fit: BoxFit.cover,
                      ),
                      SizedBox(height: 15,),
                      Text(
                        userAddress[2], 
                        style: TextStyle(
                          fontSize: 30,   
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 5,),
                      Text(
                        userAddress[1],
                        style: TextStyle(
                          fontSize: 20,  
                          color: Colors.black, 
                        ),
                      ),
                      SizedBox(height: 5,),
                      Text(
                        userAddress[3],
                        style: TextStyle(
                          fontSize: 12,  
                          color: Colors.black, 
                        ),
                      ),
                    ],
                  ),
                ),
              // ),
              SizedBox(height: 20,),
              // Card(
                // elevation: 20,
                Container(
                  width: 300,
                  height: 40,
                  child: Center(
                    child: Text(
                      'Donation Overview',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              // ),
              // Card(
                // elevation: 20,
              Container(
                  width: 300,
                  child: Center(
                    child: PieChart(
                      dataMap: datamap, 
                      chartRadius: MediaQuery.of(context).size.width/1.7,
                      legendOptions: LegendOptions(
                        legendPosition: LegendPosition.bottom,
                      ),
                      chartValuesOptions: ChartValuesOptions(
                        showChartValuesInPercentage: true,
                      ),
                    ),
                      
                  ),
                ),
              // ),
              SizedBox(height: 40,),
              
              
              
            ],
          ),
        ),
      ),
    );
  }
}