// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'models/customer.dart';


// sms permission function on main and verification_form screens initState
//   void checkPermissions() async {
//     // var smsStatus = await Permission.sms.status;
//     // if (Platform.isAndroid) {
//     Map<Permission, PermissionStatus> statuses = await [
//       Permission.location,
//       // Permission.sms,
//       // Permission.phone,
//     ].request();
//
//     if (await Permission.location.isRestricted || await Permission.location.isDenied || await Permission.location.isPermanentlyDenied) {
//       // if (await Permission.sms.isRestricted || await Permission.sms.isDenied || await Permission.sms.isPermanentlyDenied) {
//       //   if (await Permission.phone.isRestricted || await Permission.phone.isDenied || await Permission.phone.isPermanentlyDenied) {
//         showDialog(
//             context: context,
//             barrierDismissible: false,
//             builder: (_) => new AlertDialog(
//               title: Text(AppLocalizations.of(context)
//                   .translate('permissions_alert_title')),
//               content: Text(AppLocalizations.of(context)
//                   .translate('permissions_alert_content')),
//               actions: <Widget>[
//                 ElevatedButton(
//                   child: Text(AppLocalizations.of(context)
//                       .translate('permissions_settings_btn')),
//                   onPressed: () {
//                     AppSettings.openAppSettings();
//                     Navigator.of(context).pop();
//                   },
//                 ),
//                 ElevatedButton(
//                   child: Text(
//                       AppLocalizations.of(context).translate('close_btn')),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                 )
//               ],
//             ));
//         AppSettings.openAppSettings();
//       //   }
//       // }
//     // }
//
//     print(statuses);
//     } else {
//       print("Apple mobile");
//     }
//   } // checkPermissions()

// void createCustomer() async {
//   print("createCustomer function is running");
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//     String userPhone = prefs.getString('userPhone');
//     int bookerCode = prefs.getInt('bookerCode');
//     print("Future<Customer> shared preferences User phone: $userPhone");
//     print("Future<Customer> shared preferences Booker code: $bookerCode");
//     Customer _customer = Customer();
//   _customer = Customer(phone: userPhone, companyId: bookerCode);
//   var response = await http.post("https://appserver.anathesis.eu/api/customers/store/",
//       headers: {"Content-type": "application/json"},
//       body: json.encode(_customer.toJson()));
//   print(response.body);
//   // Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
// }
// Future<Customer> createCustomer(String userPhone, int bookerCode) async{
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   String userPhone = prefs.getString('userPhone');
//   int bookerCode = prefs.getInt('bookerCode');
//   print("Future<Customer> shared preferences User phone: $userPhone");
//   print("Future<Customer> shared preferences Booker code: $bookerCode");
//   Customer _customer = Customer();
//
//   final String apiUrl = "https://appserver.anathesis.eu/api/customers/store";
//
//   final response = await http.post(apiUrl, body: {
//     "phone": Customer.userPhone,
//     "company_id": bookerCode
//   });
//
//   if(response.statusCode == 201){
//     final String responseString = response.body;
//     print('Passed data to the endpoint');
//
//     return customerFromJson(responseString);
//   } else {
//     print('Did not Passed data to the endpoint');
//     return null;
//   }
// }

// void createCustomer() async{
//
//   // try {
//
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String bookerEmail = prefs.getString('bookerEmail');
//     String bookerPhone = prefs.getString('bookerPhone');
//     String userPhone = prefs.getString('userPhone');
//     int userCode = prefs.getInt('userCode');
//     print("Future<Customer> shared preferences User phone: $userPhone");
//     print("Future<Customer> shared preferences Booker email: $bookerEmail");
//
//     // final apiUrl = "https://appserver.anathesis.eu/api/customer/store/1";
//
//     // print("Future<Customer> apiUrl: $apiUrl");
//
//     // List response = [];
//     http.Response response = await http.post("https://appserver.anathesis.eu/api/customers/store/",
//         body: {
//       "phone": userPhone,
//       "companyid": userCode
//     });
//     // var responseBody = response.body;
//     // print('Respose.post $responseBody');
//
//     if(response.statusCode == 201){
//       Map data = json.decode(response.body);
//       print('Passed data to the endpoint');
//
//       Customer.fromJson(data);
//     }else{
//       print('Did not Passed data to the endpoint');
//       // return null;
//     }
//   // } on NoSuchMethodError catch(e){
//   //   print(" Exception $e");
//   // }catch (e2){
//   //   print(e2);
//   // }
//
// }

// Future<Company> fetchCompany() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   String userPhone;
//   prefs.setString("userPhone", userPhone);
//   // prefs.setString("bookerCode", '');
//   // prefs.setString("bookerPosition", mapLink);
//
//   final response =
//       await http.get(Uri.http('appserver.anathesis.eu/api/company', '1'));
//   print(response);
//   if (response.statusCode == 200) {
//     // If the server did return a 200 OK response,
//     // then parse the JSON.
//     return Customer.fromJson(jsonDecode(response.body));
//   } else {
//     // If the server did not return a 200 OK response,
//     // then throw an exception.
//     throw Exception('Failed to load album');
//   }
// }

// import 'dart:convert';

// void newUser() async {
// // create the connection to the server
//   final smtpServer =
//       SmtpServer(nameserver, username: username, password: password);
//   // Geolocator package
//   Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.best);
//   String mapLink =
//       "https://www.google.com/maps/dir/?api=1&destination=${position.latitude},${position.longitude}";
//   // SharedPreferences package
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   String bookerEmail = prefs.getString('bookerEmail');
//   String bookerPhone = prefs.getString('bookerPhone');
//   String userPhone = prefs.getString('userPhone');
//   // print("shared preferences User phone: $userPhone");
//   // print("shared preferences Booker email: $bookerEmail");
//
//   // var url = 'https://example.com/whatsit/create';
//   // var response = await http.post(url, body: {'name': 'doodle', 'color': 'blue'});
//   // print('Response status: ${response.statusCode}');
//   // print('Response body: ${response.body}');
//
//   // Create our message.
//   print("New user send email Start");
//   final message = Message()
//     ..from = Address(username)
//     ..recipients.add(bookerEmail)
//     ..subject = 'New user from feelsafe application!'
//     ..html = "Message sent at: ${DateTime.now()} <br>"
//         "From number: $userPhone<br>"
//         "Mobile location: <a href='$mapLink'/> Go to User Location</a>";
//
//   try {
//     final sendReport = await send(message, smtpServer);
//     print('Message sent: ' + sendReport.toString());
//   } on MailerException catch (e) {
//     print('Message not sent.');
//     for (var p in e.problems) {
//       print('Problem: ${p.code}: ${p.msg}');
//     }
//   }
//
//   print("New user send sms Start");
//
//   await Smsker.sendSms(
//       phone: bookerPhone,
//       message: "New user from feelsafe application\n"
//           "Date and time at ${DateTime.now()}:\n"
//           "$mapLink");
//   print("New user send sms Start");
// }

