import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:safein/src/models/customer.dart';
import 'settings.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:shared_preferences/shared_preferences.dart';

 void sendMainApi() async {
  print('sendMainApi() start');
  // Http package
  // ignore: unused_element
  Future<Customer> sendMainApi(String title) async {
    print('sendMainApi() run');

    final response = await http.post(
      Uri.parse('https://jsonplaceholder.typicode.com/albums'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'title': title,
      }),
    );

    print('Uri.parse function end');
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      print('Uri.parse return result code');
      // then parse the JSON.
      return jsonDecode(response.body);//Customer.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
  }

  // SharedPreferences package
  print('SharedPreferences package auth.dart');
  SharedPreferences prefs = await SharedPreferences.getInstance();
   final bookerCode = prefs.getInt('bookerCode');
  String userPhone = prefs.getString('userPhone');
  String countryCode = prefs.getString('countryCode');
  print("shared preferences Booker Code: $bookerCode");
  print("shared preferences User phone+Country code: $countryCode$userPhone");
}


void newCustomer() async {

// create the connection to the mail server
  final smtpServer =
      SmtpServer(nameserver, username: username, password: password);
  // Geolocator package
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation);
  String mapLink =
      "https://www.google.com/maps/dir/?api=1&destination=${position.latitude},${position.longitude}";
  // SharedPreferences package
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String bookerEmail = prefs.getString('bookerEmail');
  String bookerPhone = prefs.getString('bookerPhone');
  String bookerName = prefs.getString('bookerName');
  String userPhone = prefs.getString('userPhone');
  String countryCode = prefs.getString('countryCode');
  print("shared preferences User phone: $countryCode$userPhone");
  print("shared preferences Booker email: $bookerEmail");
  print("shared preferences Booker Name: $bookerName");
  print("shared preferences Booker Phone: $countryCode$bookerPhone");

  // Create our email message.
  print("New user send email Start");
  final message = Message()
    ..from = Address(username)
    ..recipients.add(bookerEmail)
    ..subject = 'New user from SafeIn application!'
    ..html = "Message sent at: ${DateTime.now()} <br>"
        "From number: $countryCode$userPhone<br>"
        "Mobile location: <a href='$mapLink'/> Go to User Location</a><br>"
        "Or click the link: '$mapLink'";

  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Message not sent.');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  }
  print("New user send email end");

  print("New user send sms Start");
  //
  final recipients = "$countryCode$bookerPhone";
  final sender = "$countryCode$userPhone";

  // mobile sms setup
  final fullmessage = "New user ($sender) from SafeIn application\n"
      "Date and time at ${DateTime.now()}\n"
      "Location:\n"
      "$mapLink";
  // print("fullmessage is $fullmessage");


  final response = await http.get(Uri.parse(
      "https://www.activemms.com/extapi.asp?username=$activemmsusr"
      "&password=$activemmspw"
      "&recepients=$recipients"
      "&sender=$userPhone"
      "&message=$fullmessage&smstype=0&sendbackstatus=true"));

  // print(response.body);
  if (response.statusCode == 200 && response.body.isNotEmpty) {
    print("++++++++++++++++++++++++++\n"
        "response.statusCode == 200\n"
        "+++++++++++++++++++++++++++");
    // try{
    // var data = response.body;
    // print(data); //[debug]
    //  } on FormatException catch (e){
    // print(e);
    //  }

    print("Use activemms.sendSMS with the recipient number $recipients and message body: $fullmessage.");

  }
  //
    print("New user send sms end");
}
