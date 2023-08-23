import 'package:flutter/material.dart';
import 'package:hemolife/database.dart';
import 'package:hemolife/donorlist.dart';
import 'package:postgres/postgres.dart';



class findDonors extends StatefulWidget {
  String email = "";
  findDonors({required this.email});
  @override
  _findDonorsState createState() => _findDonorsState();
}

class _findDonorsState extends State<findDonors> {
  bool isSearchClicked = false; 
  bool isClicked = false;
  String bloodType = 'A+';
  String location = 'Bagerhat';
  String email = '';

  List<String> bloodTypes = ['A+', 'B+', 'O+', 'AB+', 'A-', 'B-', 'O-', 'AB-'];
  List<String> locations = ['Bagerhat', 'Bandarban', 'Barguna', 'Barisal', 'Bhola', 'Bogra', 'Brahmanbaria', 'Chandpur', 'Chapai Nawabganj', 'Chattogram', 'Chuadanga', 'Comilla', 'Cox\'s Bazar', 'Dhaka', 'Dinajpur', 'Faridpur', 'Feni', 'Gaibandha', 'Gazipur', 'Gopalganj', 'Habiganj', 'Jamalpur', 'Jashore', 'Jhalokati', 'Jhenaidah', 'Joypurhat', 'Khagrachari', 'Khulna', 'Kishoreganj', 'Kurigram', 'Kushtia', 'Lakshmipur', 'Lalmonirhat', 'Madaripur', 'Magura', 'Manikganj', 'Meherpur', 'Moulvibazar', 'Munshiganj', 'Mymensingh', 'Naogaon', 'Narail', 'Narayanganj', 'Narsingdi', 'Natore', 'Nawabganj', 'Netrokona', 'Nilphamari', 'Noakhali', 'Pabna', 'Panchagarh', 'Patuakhali', 'Pirojpur', 'Rajbari', 'Rajshahi', 'Rangamati', 'Rangpur', 'Satkhira', 'Shariatpur', 'Sherpur', 'Sirajganj', 'Sunamganj', 'Sylhet', 'Tangail', 'Thakurgaon'];
  TextEditingController _place = TextEditingController();
  String place = '';
  Widget container = Container();
  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final ThemeData theme = ThemeData.dark().copyWith(
    primaryColor: Colors.red, // Set the primary color to red
    accentColor: Colors.red, // Set the accent color to red
    colorScheme: ColorScheme.dark(
      primary: Colors.red, // Set the primary color to red
      onPrimary: Colors.white, // Set the text color on the primary color to white
      surface: Colors.red, // Set the surface color to red
      onSurface: Colors.white, // Set the text color on the surface color to white
    ),
    buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary), // Set button text color
  );
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
      return Theme(
        data: theme,
        child: child!,
      );
    },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
  void onPlaceChanged(String value) {
    setState(() {
      place = value;
      // print(name);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    
    PostgreSQLResult? donors;
    // if(isClicked) container = donorlist(bloodType: bloodType, location:location);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.red,
        title: Center(child: Text('Find Donors')),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            children: [
              DropdownButton<String>(
                value: bloodType,
                onChanged: (newValue) {
                  setState(() {
                    bloodType = newValue!;
                  });
                },
                items: bloodTypes.map((String value) {
                  return DropdownMenuItem<String>( 
                    value: value,
                    child: Column(
                      children: [
                        Text(
                          value,
                        ),
                      ]
                    ),
                  );
                }).toList(),
                hint: Text('Select Blood Type'),
                isExpanded: true,
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.red,
                ),
                alignment: Alignment.center,
                style: TextStyle(color: Colors.black,fontSize: 20),
                underline: Container(
                  height: 2,
                  color: Colors.red,
                ),
                elevation: 5,
              ),
              SizedBox(height: 20),
              DropdownButton<String>(
                value: location,
                onChanged: (newValue) {
                  setState(() {
                    location = newValue!;
                  });
                },
                items: locations.map((String value) {
                  return DropdownMenuItem<String>( 
                    value: value,
                    child: Column(
                      children: [
                        Text(
                          value,
                        ),
                      ]
                    ),
                  );
                }).toList(),
                hint: Text('Select Blood Type'),
                isExpanded: true,
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.red,
                ),
                alignment: Alignment.center,
                style: TextStyle(color: Colors.black,fontSize: 20),
                underline: Container(
                  height: 2,
                  color: Colors.red,
                ),
                elevation: 5,
              ),
              SizedBox(height: 20),
              TextField(
                            controller: _place,
                            onChanged: onPlaceChanged,
                            cursorColor: Colors.red,
                            style: TextStyle(fontSize: 12),
                            decoration: InputDecoration(
                              hintText: 'Provid your location for Donor\'s Convenience',
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),
                            ),
              ),
              SizedBox(height: 20),
              Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "${selectedDate.toLocal()}".split(' ')[0],
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10.0,
            ),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              style: ElevatedButton.styleFrom(
                primary:  Colors.red,
              ),
              child: Text(
                'Select deadline',
                style: TextStyle(
                  
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async{
                  setState(() {
                    isSearchClicked = true;
                    container = Container();
                    isClicked = true;
                  });

                  PostgreSQLResult? donors = await AppDatabase().findDonors(widget.email,bloodType,location);
                 
                  setState((){
                    isClicked = false;
                    print(bloodType);
                    print('hello');
                    container = donorlist(donors:donors,email:widget.email, place:place, deadline:selectedDate);
                // container = Container();
                   
                    
                    // container = donorlist(bloodType:bloodType, location:location);
                  });
                  
                },
                child: Text('Search'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red, // Set the background color
                  onPrimary: Colors.white, // Set the text color
                  // You can also set other properties like textStyle, elevation, padding, etc.
                ),
                
              ),
              SizedBox(height: 40,),
              // isSearchClicked?container = donorlist(donors:donors,email:widget.email)
              isClicked?CircularProgressIndicator(
                color: Colors.red,
              ):container,
            ],
          ),
        ),
      ),
    );
  }
}