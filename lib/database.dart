

import 'package:hemolife/donorlist.dart';
import 'package:postgres/postgres.dart';

class AppDatabase {
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

  PostgreSQLConnection? connection;
  PostgreSQLResult? newUserRegisterResult, newBuyerRegisterResult;
  PostgreSQLResult? userAlreadyRegistered, buyerAlreadyRegistered;

  PostgreSQLResult? loginResult, userRegisteredResult;

  PostgreSQLResult? updateBuyerResult;
  PostgreSQLResult? updateSellerResult;
  PostgreSQLResult? donorlist;

  static String? sellerEmailAddress, buyerEmailAddress;

  PostgreSQLResult? _fetchSellerDataResult;

  AppDatabase() {
    connection = (connection == null || connection!.isClosed == true
        ? PostgreSQLConnection(
            // for external device like mobile phone use domain.com or
            // your computer machine IP address (i.e,192.168.0.1,etc)
            // when using AVD add this IP 10.0.2.2
            // 'localhost',
            // '192.168.0.1',
            '108.181.197.183',
            19643,
            'HemoLife',
            username: 'MiduPeal',
            password: 'midupeal',
            timeoutInSeconds: 120,
            queryTimeoutInSeconds: 120,
            timeZone: 'UTC',
            useSSL: false,
            isUnixSocket: false,
          )
        : connection);
        print('Connection details:');
        print('Host: ${connection?.host}');
        print('Port: ${connection?.port}');
        print('Database: ${connection?.databaseName}');
        print('Username: ${connection?.username}');

    // fetchDataFuture = [];
  }

  // Register Database Section
  String newUserFuture = '';
  Future<String> registerUserInformation(
      String name, String email, String phoneNo, String password, String district, String city, String address, String medicalReport, String bloodGroup) async {
    try {
      await connection!.open();
     
      await connection!.transaction((newUserConn) async {
        //Stage 1 : Make sure email or mobile not registered.
         
        userAlreadyRegistered = await newUserConn.query(
          'select * from user_information where Email = @emailValue OR PhoneNo = @mobileValue',
          substitutionValues: {'emailValue': email, 'mobileValue': phoneNo},
          allowReuse: true,
          timeoutInSeconds: 60,
        );
         
        if (userAlreadyRegistered!.affectedRowCount > 0) {
          newUserFuture = 'alr';
        } else {
          //Stage 2 : If user not already registered then we start the registration
          newUserRegisterResult = await newUserConn.query(
            'insert into user_information(Name,Email,Password,PhoneNo,RegisterDate) '
            'values(@nameValue,@emailValue,@passwordValue,@mobileValue,@registrationValue)',
            substitutionValues: {
              'emailValue': email,
              'passwordValue': password,
              'mobileValue': phoneNo,
              'nameValue' : name,
              'registrationValue': DateTime.now(),
            },
            allowReuse: true,
            timeoutInSeconds: 60,
          );
          await newUserConn.query(
            'insert into user_address_information(Email,district,city,address) '
            'values(@emailValue,@districtValue,@cityValue,@addressValue)',
            substitutionValues: {
              'emailValue': email,
              'districtValue': district,
              'cityValue': city,
              'addressValue' : address,
            },
            allowReuse: true,
            timeoutInSeconds: 60,
          );
          await newUserConn.query(
            'insert into user_blood_information(Email,MedicalReport,BloodGroup) '
            'values(@emailValue,@medicalReportValue,@bloodGroupValue)',
            substitutionValues: {
              'emailValue': email,
              'medicalReportValue': medicalreport,
              'bloodGroupValue': bloodGroup,
            },
            allowReuse: true,
            timeoutInSeconds: 60,
          );
          await newUserConn.query(
            'insert into user_status(Email) '
            'values ( @emailValue)',
            substitutionValues: {
              'emailValue': email,
            },
            allowReuse: true,
            timeoutInSeconds: 60,
          );
          await newUserConn.query(
            'insert into user_performance (email,no_of_donation,no_of_requests,no_of_acceptence,no_of_rejection,blood_requested) '
            'values ( @emailValue, @donationValue, @requestsValue, @acceptenceValue, @rejectionValue, @bloodRequestedValue)',
            substitutionValues: {
              'emailValue': email,
              'donationValue' : 0,  
              'requestsValue' : 0,   
              'acceptenceValue' : 0,   
              'rejectionValue' : 0,   
              'bloodRequestedValue' : 0,
            },
            allowReuse: true,
            timeoutInSeconds: 60,
          );
          newUserFuture =
              (newUserRegisterResult!.affectedRowCount > 0 ? 'reg' : 'nop');
        }
      });
    } catch (exc) {
      print(exc);
      newUserFuture = 'exc';
      exc.toString();
    }
    print(newUserFuture);
    return newUserFuture;
  }
  Future<PostgreSQLResult?> findDonors(String email, String bloodGroup, String district) async {
    List<Map<String, dynamic>> donorList = []; 
    try {
      await connection!.open();
      await connection!.transaction((newUserConn) async {
        print('hello');
        donorlist = await newUserConn.query(
         'select * from user_information where email in '
          '(select x.email from user_address_information as x, user_blood_information as y, user_status as z '
          'where x.email = y.email and y.email = z.email and x.email != @emailValue and y.bloodgroup = @bloodGroupValue '
          'and x.district = @districtValue and z.verified = true ) ',
          substitutionValues: {'bloodGroupValue': bloodGroup, 'districtValue': district, 'emailValue': email},
          allowReuse: true,
          timeoutInSeconds: 60,
        );
        if(donorlist!.affectedRowCount > 0) {
          print('yea');
          for (var row in donorlist!) {
            var email = row[1];
            print(email);
          }
        }
        else {
          print("Nop");
          donorList = [];  
        }
        
      });
    } catch (exc) {
      print(exc);
     
    }
    return donorlist;
    
  }
  Future<void> addBloodRequest(String request_from, String request_to, String place, DateTime deadline) async {
    List<Map<String, dynamic>> donorList = []; 
    try {
      await connection!.open();
      await connection!.transaction((newUserConn) async {
        print('hello');
          await newUserConn.query(
            'insert into blood_request_list (request_from, request_to, request_date, location, deadline) values (@requestFromValue, @requestToValue, @requestDateValue, @locationValue, @deadlineValue)',
            substitutionValues: {
              'requestFromValue': request_from, 
              'requestToValue': request_to,
              'requestDateValue': DateTime.now(),   
              'locationValue': place,
              'deadlineValue': deadline,  
            },
            allowReuse: true,
            timeoutInSeconds: 60,
        );
        
        
      });
    } catch (exc) {
      print(exc);
     
    }
  }
  Future<int> countActiveDonors() async {
    int count = 0;
    try {
      await connection!.open();
      await connection!.transaction((newUserConn) async {
        print('hello');
          var val = await newUserConn.query(
            'select count(verified) from user_status where verified = true',
            allowReuse: true,
            timeoutInSeconds: 60,
        );
        if(val.isNotEmpty) {
          count = val[0][0] as int;
        }
        
        
      });
    } catch (exc) {
      print(exc);
     
    }
   
    return count;
  }
  Future<Map<String,int>> requestsStatisticsByBloodGroup() async {
    Map<String,int> userReqList = {
      'A+' : 0,  
      'A-' : 0,  
      'B+' : 0,  
      'B-' : 0,  
      'AB+' : 0,  
      'AB-' : 0,  
      'O+' : 0,  
      'O-' : 0,
    };
    try {
      await connection!.open();
      await connection!.transaction((newUserConn) async {
        print('hello');
          var val = await newUserConn.query(
            'select * from user_performance as x, user_blood_information as y where '
            'x.email = y.email',
           
            allowReuse: true,
            timeoutInSeconds: 60,
        );
        if(val.isNotEmpty) {
          for(var row in val) {
            userReqList[row[8].toString()] = userReqList[row[8].toString()]! + row[1] as int;
          }
        }
        
        
      });
    } catch (exc) {
      print(exc);
     
    }
    return userReqList;
  }
  Future<Map<String,int>> getActiveDonors() async {
    Map<String,int> activeDonor = {
      'A+' : 0,  
      'A-' : 0,  
      'B+' : 0,  
      'B-' : 0,  
      'AB+' : 0,  
      'AB-' : 0,  
      'O+' : 0,  
      'O-' : 0,
    };
    try {
      await connection!.open();
      await connection!.transaction((newUserConn) async {
        print('hello');
          var val = await newUserConn.query(
            'select * from user_status as x, user_blood_information as y where '
            'x.email = y.email and x.verified = true',
           
            allowReuse: true,
            timeoutInSeconds: 60,
        );
        if(val.isNotEmpty) {
          for(var row in val) {
            activeDonor[row[4].toString()] = activeDonor[row[4].toString()]! + 1;
          }
        }
        
        
      });
    } catch (exc) {
      print(exc);
     
    }
    return activeDonor;
  }
  Future<String> getPhoneNo(String email) async {
    String phoneno = "";
    
    try {
      await connection!.open();
      await connection!.transaction((newUserConn) async {
        print('hello');
          var val = await newUserConn.query(
            'select phoneno from user_information where email = @emailValue',
            substitutionValues: {
              'emailValue': email, 
            },
            allowReuse: true,
            timeoutInSeconds: 60,
        );
        if (val.isNotEmpty) {
          // Assuming 'phoneno' is the name of the column containing phone numbers
          phoneno = val[0][0].toString();
        }
      });
    } catch (exc) {
      print(exc);
     
    }
    print(phoneno);
    return phoneno;
  }
  Future<bool> getUserStatus(String email) async {
    bool status = true;
    
    try {
      await connection!.open();
      await connection!.transaction((newUserConn) async {
        print('hello');
          var val = await newUserConn.query(
            'select verified from user_status where email = @emailValue',
            substitutionValues: {
              'emailValue': email, 
            },
            allowReuse: true,
            timeoutInSeconds: 60,
        );
        if (val.isNotEmpty) {
         
          status = val[0][0];
        }
      });
    } catch (exc) {
      print(exc);
     
    }
    
    return status;
  }
  Future<List<String>> getUserAddress(String email) async {
    List<String> address = [];
    
    try {
      await connection!.open();
      await connection!.transaction((newUserConn) async {
        print('hello');
          var val = await newUserConn.query(
            'select * from user_address_information where email = @emailValue',
            substitutionValues: {
              'emailValue': email, 
            },
            allowReuse: true,
            timeoutInSeconds: 60,
        );
        if (val.isNotEmpty) {
         
          for(var row in val) {
            for(var col in row) {
              address.add(col.toString());
            }
          }
        }
      });
    } catch (exc) {
      print(exc);
     
    }
    
    return address;
  }
  Future<String> getEmail(String phoneno) async {
    String email = "";
    
    try {
      await connection!.open();
      await connection!.transaction((newUserConn) async {
        print('hello');
          var val = await newUserConn.query(
            'select email from user_information where phoneno = @phoneNoValue',
            substitutionValues: {
              'phoneNoValue': phoneno, 
            },
            allowReuse: true,
            timeoutInSeconds: 60,
        );
        if (val.isNotEmpty) {
          // Assuming 'phoneno' is the name of the column containing phone numbers
          email = val[0][0].toString();
        }
      });
    } catch (exc) {
      print(exc);
     
    }
   
    return email;
  }
  Future<void> addFeedback(String email, String message) async {
  
    
    try {
      await connection!.open();
      await connection!.transaction((newUserConn) async {
        print('hello');
          await newUserConn.query(
            'insert into user_feedback (email, message, feedback_date) values '
            '(@emailValue, @messageValue, @dateValue)',
            substitutionValues: {
              'emailValue': email,
              'messageValue' : message,   
              'dateValue' : DateTime.now(),     
            },
            allowReuse: true,
            timeoutInSeconds: 60,
        );
      });
    } catch (exc) {
      print(exc);
     
    }
   
    
  }
  Future<Map<String,int>> findUserInTermsOfBloodGroup() async {
    Map<String,int> userFreqList = {
      'A+' : 0,  
      'A-' : 0,  
      'B+' : 0,  
      'B-' : 0,  
      'AB+' : 0,  
      'AB-' : 0,  
      'O+' : 0,  
      'O-' : 0,
    };
    
    try {
      await connection!.open();
      await connection!.transaction((newUserConn) async {
        print('hello');
          var val = await newUserConn.query(
            'select * from user_blood_information',
            allowReuse: true,
            timeoutInSeconds: 60,
        );
        if (val.isNotEmpty) {
          for(var row in val) {
            userFreqList[row[2].toString()] = userFreqList[row[2].toString()]! + 1;
          }
        }
      });
    } catch (exc) {
      print(exc);
     
    }
   
    return userFreqList;
  }
  Future<List<String>> getUserPerformance(String email) async {
    List<String>userPerformance = [];
    try {
      await connection!.open();
      await connection!.transaction((newUserConn) async {
        print('hello');
          var val = await newUserConn.query(
            'select * from user_performance where email = @emailValue',
            substitutionValues: {
              'emailValue': email, 
            },
            allowReuse: true,
            timeoutInSeconds: 60,
        );
        if(val.isNotEmpty) {
          for(var row in val) {
            for(var col in row) userPerformance.add(col.toString());
          }
        }
      });
    } catch (exc) {
      print(exc);
     
    }
    // return val;
    return userPerformance;
  }
  Future<void> updateUserPerformance(String email, String column) async {
    
    try {
      await connection!.open();
      await connection!.transaction((newUserConn) async {
        print('hello');
          var val = await newUserConn.query(
            'update user_performance set ' + column + ' = ' + column + ' + @Value where email = @emailValue',
            substitutionValues: {
              'emailValue': email, 
              'Value' : 1,
            },
            allowReuse: true,
            timeoutInSeconds: 60,
        );
       
      });
    } catch (exc) {
      print(exc);
     
    }
  }
  Future<String> getBloodGroup(String email) async {
    String bloodgroup = "";
    
    try {
      await connection!.open();
      await connection!.transaction((newUserConn) async {
        print('hello');
          var val = await newUserConn.query(
            'select bloodgroup from user_blood_information where email = @emailValue',
            substitutionValues: {
              'emailValue': email, 
            },
            allowReuse: true,
            timeoutInSeconds: 60,
        );
        if (val.isNotEmpty) {
          // Assuming 'phoneno' is the name of the column containing phone numbers
          bloodgroup = val[0][0].toString();
        }
      });
    } catch (exc) {
      print(exc);
     
    }
    // print(phoneno);
    return bloodgroup;
  }
  Future<List<List<String>>> getRequests(String phoneno) async {
    List< List<String> > requests = [];
    
    try {
      await connection!.open();
      await connection!.transaction((newUserConn) async {
        print('hello');
          var val = await newUserConn.query(
            'select * from blood_request_list where request_to = @phonenoValue',
            substitutionValues: {
              'phonenoValue': phoneno, 
            },
            allowReuse: true,
            timeoutInSeconds: 60,
        );
        if(val.isNotEmpty) {
          
          for(var row in val) {
            List<String>temp = [];
            for(var col in row) temp.add(col.toString());
            requests.add(temp);
          }
          print(requests.length);
        }
      });
    } catch (exc) {
      print(exc);
     
    }
    
    return requests;
  }
  Future<void> deleteRequest(String request_from, String request_to) async {
    try {
      await connection!.open();
      await connection!.transaction((newUserConn) async {
        print('hello');
          await newUserConn.query(
            'delete from blood_request_list where request_from = @requestFromValue and request_to = @requestToValue',
            substitutionValues: {
              'requestFromValue' : request_from,
              'requestToValue' : request_to,  
            },
            allowReuse: true,
            timeoutInSeconds: 60,
        );
       
      });
    } catch (exc) {
      print(exc);
     
    }
    
  }
  Future<void> addResponse(String response_from, String response_to, String response_status) async {
    try {
      await connection!.open();
      await connection!.transaction((newUserConn) async {
        print('hello');
          await newUserConn.query(
            'insert into responsed_request_list (response_from, response_to, response_date, response_status)'
            ' values (@responseFromValue, @responseToValue, @responseDateValue, @responseStatusValue)',
            substitutionValues: {
              'responseFromValue' : response_from,
              'responseToValue' : response_to,
              'responseDateValue' : DateTime.now(),  
              'responseStatusValue' : response_status,    
            },
            allowReuse: true,
            timeoutInSeconds: 60,
        );
       
      });
    } catch (exc) {
      print(exc);
     
    }
    
  }
  Future<void> clearResponse(String response_from, String response_to) async {
    try {
      await connection!.open();
      await connection!.transaction((newUserConn) async {
        print('hello');
          await newUserConn.query(
            'delete from responsed_request_list where response_from = @responseFromValue and '
            'response_to = @responseToValue',
            substitutionValues: {
              'responseFromValue' : response_from,
              'responseToValue' : response_to,  
            },
            allowReuse: true,
            timeoutInSeconds: 60,
        );
       
      });
    } catch (exc) {
      print(exc);
     
    }
    
  }
  Future<void> clearRelatedResponses(String response_from) async {
    try {
      await connection!.open();
      await connection!.transaction((newUserConn) async {
        print('hello');
          await newUserConn.query(
            'delete from responsed_request_list where response_from = @responseFromValue',
            substitutionValues: {
              'responseFromValue' : response_from, 
            },
            allowReuse: true,
            timeoutInSeconds: 60,
        );
       
      });
    } catch (exc) {
      print(exc);
     
    }
    
  }
  Future<List < List<String> > > getDonationHistory(String email) async {
    List < List<String> > donationList = [];
    try {
      await connection!.open();
      await connection!.transaction((newUserConn) async {
        print('hello');
          var temp = await newUserConn.query(
            'select * from donation_list where donation_from = @emailValue',
            substitutionValues: {
              'emailValue' : email, 
            },
            allowReuse: true,
            timeoutInSeconds: 60,
        );
        if(temp.isNotEmpty) {
          for(var row in temp) {
            List<String> val = [];
            for(var col in row) {
              val.add(col.toString());
            }
            donationList.add(val);
          }
        }
       
      });
    } catch (exc) {
      print(exc);
     
    }
    return donationList;
    
  }
  Future<void> clearRelatedRequests(String request_to) async {
    try {
      await connection!.open();
      await connection!.transaction((newUserConn) async {
        print('hello');
          await newUserConn.query(
            'delete from blood_request_list where request_to = @requestToValue',
            substitutionValues: {
              'requestToValue' : request_to, 
            },
            allowReuse: true,
            timeoutInSeconds: 60,
        ); 
       
      });
    } catch (exc) {
      print(exc);
     
    }
    
  }
  Future<void> addDonation(String donation_from, String donation_to, String donated_blood_group) async {
    try {
      await connection!.open();
      await connection!.transaction((newUserConn) async {
        print('hello');
          await newUserConn.query(
            'insert into donation_list (donation_from, donation_to, donation_completion_date, donated_blood_group) values '
            '(@donationFromValue,@donationToValue,@donationCompletionDateValue,@donatedBloodGroupValue)',
            substitutionValues: {
              'donationFromValue' : donation_from,
              'donationToValue' : donation_to,
              'donationCompletionDateValue' : DateTime.now(),  
              'donatedBloodGroupValue' : donated_blood_group,  
            },
            allowReuse: true,
            timeoutInSeconds: 60,
        );
       
      });
    } catch (exc) {
      print(exc);
     
    }
    
  }
  Future<List<List<String>>> getResponseList(String email) async {
    List < List<String> > responseList = [];   
    try {
      await connection!.open();
      await connection!.transaction((newUserConn) async {
        print('hello');
        var val = await newUserConn.query(
            'select * from responsed_request_list where response_to = @emailValue and response_status = @responseStatusValue',
            substitutionValues: {
              'emailValue' : email,    
              'responseStatusValue' : 'Accepted',
            },
            allowReuse: true,
            timeoutInSeconds: 60,
        );
        
        if(val.isNotEmpty) {
          for(var row in val) {
            List<String> temp = [];   
            for(var col in row) {
              temp.add(col.toString());
            }
            responseList.add(temp);
          }
        }
        
       
      });
    } catch (exc) {
      print(exc);
     
    }
    return responseList;
    
  }
  
  Future<String> isInBloodRequestList(String request_from, String request_to) async {
    PostgreSQLResult? data;
    String val = 'yes';  
    try {
      await connection!.open();
      await connection!.transaction((newUserConn) async {
        print('hello');
          data = await newUserConn.query(
            'select * from blood_request_list where request_from = @requestFromValue and request_to = @requestToValue',
            substitutionValues: {'requestFromValue': request_from, 'requestToValue': request_to},
            allowReuse: true,
            timeoutInSeconds: 60,
        );
        if(data!.affectedRowCount>0) val = 'no';
        
        
      });
    } catch (exc) {
      print(exc);
     
    }
    // print(val.toString());
    return val;
  }



  
  String userLoginFuture = '';
  Future<PostgreSQLResult?> loginUser(String email, String password) async {
    try {
      await connection!.open();
      await connection!.transaction((loginConn) async {
        //Step 1 : Check email registered or no
        loginResult = await loginConn.query(
          'select name,email,password from user_information where email = @emailValue and password = @passwordValue',
          substitutionValues: {'emailValue': email, 'passwordValue' : password},
          allowReuse: true,
          timeoutInSeconds: 30,
        );
       
      });
    } catch (exc) {
      userLoginFuture = 'exc';
      exc.toString();
    }
    return loginResult;
  }
  Future<void> updateUserStatus(String email, bool statusValue) async {
    try {
      await connection!.open();
      await connection!.transaction((newUserConn) async {
        print('hello');
          await newUserConn.query(
            'update user_status set verified = @verifiedValue where email = @emailValue',
            substitutionValues: {
              'verifiedValue' : statusValue,
              'emailValue' : email,
            },
            allowReuse: true,
            timeoutInSeconds: 60,
        );
       
      });
    } catch (exc) {
      print(exc);
     
    }
    
  }

 
  

  
  
 
}