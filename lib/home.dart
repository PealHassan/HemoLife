import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hemolife/bloodRequests.dart';
import 'package:hemolife/donationHistory.dart';
import 'package:hemolife/findDonors.dart';
import 'package:hemolife/profile.dart';
import 'package:hemolife/responseList.dart';
import './HeaderDrawer.dart';
import './login.dart';
import './dashboard.dart';
import 'feedback.dart';
class Home extends StatefulWidget {
  final String email; 
  final String name;// Add this line
  
  Home({required this.email,required this.name}); // Add this constructor
  HomeState createState() => HomeState();
}
class HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();   
    loadPage();   
  }
  bool adminFlag = false;  
  var currentPage = DrawerSections.dashboard;
  Future<void> loadPage() async {
    await checkAdmin();   
  }
  Future<void> checkAdmin() async {
    if(widget.email == 'admin@gmail.com') {
      setState(() {
        adminFlag = true; 
        currentPage = DrawerSections.updateUserStatus;
      });
    }
  }

  
  @override
  Widget build(BuildContext context) {
    var container; 
    
    if(currentPage == DrawerSections.dashboard) {
      container = dashboard(email:widget.email);
    }
    if(currentPage == DrawerSections.findDonors) {
      container = findDonors(email:widget.email);
    }
    if(currentPage == DrawerSections.requestBlood) {
      container = bloodRequests(email: widget.email);
    }
    if(currentPage == DrawerSections.responses) {
      container = responseList(email: widget.email);
    }
    if(currentPage == DrawerSections.history) {
      container = donationHistory(email: widget.email);
    }
    if(currentPage == DrawerSections.profile) {
      container = profile(email: widget.email,name: widget.name);
    }
    if(currentPage == DrawerSections.feedback) {
      container = FeedbackPage(email: widget.email);
    }

    return Scaffold(
      
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Center(
          child: Image.asset(
            'assets/logo.png',
            //  fit: BoxFit.cover,
            width: 150,
            height: 300,
          ),
        ),
      ),
      body: container,
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                HeaderDrawer(email: widget.email,name: widget.name),
                DrawerList(),
              ],
            ),
          ),
        )
      ),
    
    );
  }
  Widget DrawerList() {
    return Container(
      padding: EdgeInsets.only(top: 15,),
      child: adminFlag?Column(
        children: [
          menuItem(11,"Update User Status", Icons.search, currentPage == DrawerSections.updateUserStatus? true:false),
          menuItem(13,"Donors",Icons.exit_to_app, currentPage == DrawerSections.donorInformation ? true: false),
          menuItem(12,"FeedBacks", Icons.search, currentPage == DrawerSections.adminFeedBacks? true:false),
          menuItem(9,"Log Out",Icons.exit_to_app, currentPage == DrawerSections.logout ? true: false),
          
        ],
      ): Column(
        children: [
          menuItem(1,"Dashboard",Icons.dashboard_outlined,currentPage == DrawerSections.dashboard ? true: false),
          menuItem(10,"Profile",Icons.account_circle,currentPage == DrawerSections.profile ? true: false),
          Divider(),
          menuItem(2,"Find Donors",Icons.search,currentPage == DrawerSections.findDonors ? true: false),
          menuItem(3,"Blood Requests",Icons.local_drink,currentPage == DrawerSections.requestBlood ? true: false),
          menuItem(4,"Responses",Icons.chat,currentPage == DrawerSections.responses? true: false),
          Divider(),
          menuItem(5,"History",Icons.history,currentPage == DrawerSections.history ? true: false),
          
          menuItem(6,"Rewards",Icons.redeem,currentPage == DrawerSections.rewards? true: false),
          Divider(),
          menuItem(7,"Settings",Icons.settings,currentPage == DrawerSections.settings ? true: false),
          menuItem(8,"FeedBack",Icons.feedback,currentPage == DrawerSections.feedback ? true: false),
          
          Divider(),
          menuItem(9,"Log Out",Icons.exit_to_app, currentPage == DrawerSections.logout ? true: false),

        ],
      ),
    );
  }
  Widget menuItem(int id, String title, IconData icon, bool selected) {
    return Material(
      color: selected ? Colors.grey[300]:Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          setState((){
            if(id == 1) currentPage = DrawerSections.dashboard;
            else if(id == 2) currentPage = DrawerSections.findDonors;
            else if(id == 3) currentPage = DrawerSections.requestBlood;  
            else if(id == 4) currentPage = DrawerSections.responses;  
            else if(id == 5) currentPage = DrawerSections.history;  
            else if(id == 6) currentPage = DrawerSections.rewards;
            else if(id == 7) currentPage = DrawerSections.settings;
            else if(id == 8) currentPage = DrawerSections.feedback;
            else if(id == 9) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HemoLife()));
            }
            else if(id == 10) currentPage = DrawerSections.profile;
            else if(id == 11) currentPage = DrawerSections.updateUserStatus; 
            else if(id == 12) currentPage = DrawerSections.adminFeedBacks; 
            else if(id == 13) currentPage = DrawerSections.donorInformation; 
          });
        },
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Row(
            children: [
              Expanded(
                child: Icon(
                  icon,
                  size: 20,
                  color: Colors.black,
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



enum DrawerSections {
  dashboard,
  findDonors,
  requestBlood,
  responses,
  history,
  rewards,
  settings,
  feedback,
  logout,
  profile,
  updateUserStatus,
  adminFeedBacks,
  donorInformation,
  
}