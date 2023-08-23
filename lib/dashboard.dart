import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:hemolife/database.dart';
import 'package:pie_chart/pie_chart.dart';
class dashboard extends StatefulWidget {
  String email = '';  
  dashboard({required this.email});
  dashboardState createState() => dashboardState();
}
class dashboardState extends State<dashboard> {
  bool checkingDone = false;
  Map<String, int> userFreqList = {};
  Map<String, int> userReqList = {};
  Map<String, int> activeDonors = {};
  int totalDonor = 0, totalDonation = 0, activeDonor = 0;
  Map<String,double>datamap = {
    'Active Donors' : 4,  
    'Non-Active Donors' : 5,
  };

  @override
  void initState() {
    super.initState();
    loadPage();
  }

  Future<void> loadPage() async {
    await getUserFreqList();
    await getUserReqList();
    await getActiveDonors();
    setState(() {
      checkingDone = true;
    });
  }
  Future<void> getActiveDonors() async {
    int val = await AppDatabase().countActiveDonors();
    Map<String,int> temp = await AppDatabase().getActiveDonors();
   
    setState(() {
      activeDonor = val;
      activeDonors = temp;
      print(val);
      datamap['Active Donors'] = val.toDouble();
      datamap['Non-Active Donors'] = (totalDonor - val).toDouble();
    });
  }
  Future<void> getUserReqList() async {
    int val = 0;
    Map<String,int> temp = await AppDatabase().requestsStatisticsByBloodGroup();
    temp.entries.map((entry) => val += entry.value).toList();
    setState(() {
      userReqList = temp;
      totalDonation = val;
      print(temp['O+']);
    });

  }

  Future<void> getUserFreqList() async {
    Map<String, int> temp = await AppDatabase().findUserInTermsOfBloodGroup();
    int val = 0;
    temp.entries.map((entry) => val += entry.value).toList();
    setState(() {
      print(temp['B+']);
      totalDonor = val;
      userFreqList = temp;
    });
  }

  List<charts.Series<DonorData, String>> _createData() {
    final data = userFreqList.entries.map((entry) => DonorData(entry.key, entry.value)).toList();
    final colors = [
      charts.ColorUtil.fromDartColor(Colors.blue),
      charts.ColorUtil.fromDartColor(Colors.red),
      charts.ColorUtil.fromDartColor(Colors.green),
      charts.ColorUtil.fromDartColor(Colors.orange),
      charts.ColorUtil.fromDartColor(Colors.purple),
      charts.ColorUtil.fromDartColor(Colors.yellow),  
      charts.ColorUtil.fromDartColor(Colors.teal),
      charts.ColorUtil.fromDartColor(Colors.pink),
    ];

    return [
      charts.Series<DonorData, String>(
        id: 'DonorData',
        domainFn: (DonorData donor, _) => donor.bloodGroup,
        measureFn: (DonorData donor, _) => donor.donorCount,
        data: data,
        colorFn: (_, index) => colors[index! % colors.length], 
        labelAccessorFn: (DonorData donor, _) => '${donor.donorCount}',
        
      ),
      
    ];
  }
  List<DonorDataStack> prepareData() {
    return userFreqList.entries.map((entry) {
      return DonorDataStack(entry.key, entry.value, activeDonors[entry.key]!, entry.value - activeDonors[entry.key]!);
    }).toList();
  }

  List<charts.Series<DonorData, String>> _createDataReq() {
    final data = userReqList.entries.map((entry) => DonorData(entry.key, entry.value)).toList();
    int totalDonorCount = data.fold(0, (sum, entry) => sum + entry.donorCount);
    final colors = [
      charts.ColorUtil.fromDartColor(Colors.blue),
      charts.ColorUtil.fromDartColor(Colors.red),
      charts.ColorUtil.fromDartColor(Colors.green),
      charts.ColorUtil.fromDartColor(Colors.orange),
      charts.ColorUtil.fromDartColor(Colors.purple),
      charts.ColorUtil.fromDartColor(Colors.yellow),  
      charts.ColorUtil.fromDartColor(Colors.teal),
      charts.ColorUtil.fromDartColor(Colors.pink),
    ];

    return [
      charts.Series<DonorData, String>(
        id: 'DonorData',
        domainFn: (DonorData donor, _) => donor.bloodGroup,
        measureFn: (DonorData donor, _) => donor.donorCount,
        data: data,
        colorFn: (_, index) => colors[index! % colors.length], 
        labelAccessorFn: (DonorData donor, _) => '${donor.donorCount}',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            'Dashboard',  
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color:Colors.red,
            ),
          ),
        ),
      ),
      body: !checkingDone
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            )
          : SingleChildScrollView(
            child: Center(
                child: Column(
                  children: [
                    SizedBox(height: 20,),
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
                    SizedBox(height: 20,),
                    Text(
                      'Active vs Non-Active Donors',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.red),
                    ),
                    SizedBox(height: 20),
                    // Card(
                      // elevation: 20,
                    Container(
                        width: 300,
                        height: 300,
                        child: Center(
                          child: charts.BarChart(
                            [
                              charts.Series<DonorDataStack, String>(
                                id: 'Active',
                                data: prepareData(),
                                domainFn: (DonorDataStack donor, _) => donor.bloodGroup,
                                measureFn: (DonorDataStack donor, _) => donor.activeDonors,
                              ),
                              charts.Series<DonorDataStack, String>(
                                id: 'Non-Active',
                                data: prepareData(),
                                domainFn: (DonorDataStack donor, _) => donor.bloodGroup,
                                measureFn: (DonorDataStack donor, _) => donor.nonActiveDonors,
                              ),
                            ],
                            animate: true,
                            barGroupingType: charts.BarGroupingType.stacked, // Combine active and non-active bars
                            vertical: true,
                            behaviors: [
                              new charts.SeriesLegend(),
                            ],

                             // Show horizontal bars
                          ),
                        ),
                      ),
                    
                    SizedBox(height: 20,),

                    Text(
                      'Total Donors',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.red),
                    ),
                    SizedBox(height: 20),
                    
                    // Card(
                      // elevation: 20,
                    Container(
                        width : 300,
                        height: 300,
                        padding: EdgeInsets.all(16),
                        child: charts.BarChart(
                          _createData(),
                          animate: true,
                        ),
                      ),
                    // ),
                    SizedBox(height: 20,),
                    Text(
                      'Blood Donations',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.red),
                    ),
                    SizedBox(height: 20),
                    //  Card(
                      // elevation: 20,
                    Container(
                        width : 300,
                        height: 300,
                        padding: EdgeInsets.all(16),
                        child: charts.BarChart(
                          _createDataReq(),
                          animate: true,
                          
                        ),
                      ),
                    // ),
                    SizedBox(height: 30,),

                    
                  ],
                ),
              ),
          ),
    );
  }
}


class DonorData {
  final String bloodGroup;
  final int donorCount;

  DonorData(this.bloodGroup, this.donorCount);
  
}

class DonorDataStack {
  final String bloodGroup;
  final int totalDonors;
  final int activeDonors;
  final int nonActiveDonors;

  DonorDataStack(this.bloodGroup, this.totalDonors, this.activeDonors, this.nonActiveDonors);
}

