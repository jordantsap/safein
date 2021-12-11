// import 'dart:io';
// import 'package:flutter_sms/flutter_sms.dart';

// import 'package:smsker/smsker.dart';
import 'settings.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// MEDICAL HELP REQUESTS ===================================================
//SEND SMS

void sendMedicalHelpRequest() async {

  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation);
  String mapLink =
      "https://www.google.com/maps/dir/?api=1&destination=${position.latitude},${position.longitude}";
  // SharedPreferences package
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String userPhone = prefs.getString('userPhone');
  String countryCode = prefs.getString('countryCode');
  String bookerEmail = prefs.getString('bookerEmail');
  String bookerPhone = prefs.getString('bookerPhone');
  // print("shared preferences User phone: $countryCode + $userPhone");
  // print("shared preferences booker phone: $bookerPhone");
  // print("shared preferences Booker email: $bookerEmail");

  print("Send Medical Help Sms Start");

  print("New user send sms Start");

  final recipients = countryCode+bookerPhone;
  final sender = "$countryCode"+"$userPhone";
  final fullmessage = "Medical reason Help needed.\n"
            "Sent at ${DateTime.now()}\n"
            "From Tel: $sender\n"
            "Location:\n"
            "$mapLink";


  final response = await http.get(Uri.parse(
      "https://www.activemms.com/extapi.asp?username=$activemmsusr"
          "&password=$activemmspw"
          "&recepients=$recipients"
          "&sender=$userPhone"
          "&message=$fullmessage&smstype=0&sendbackstatus=true"));

  if (response.statusCode == 200 &&
      response.body.isNotEmpty) {
    print(
        "++++++++++++++++++++++++++\n"
            "response.statusCode == 200\n"
            "+++++++++++++++++++++++++++");
    // try{
    var data = response.body;
    // json.decode(response.body);
    print(data); //[code]
    //  } on FormatException catch (e){
    // print(e);
     }

  print("Used Activemms.sendSMS with the recipient number $recipients and message body: $fullmessage.");

  print("Send Medical Sms End");

  print("Send Medical Help Email Start");
  // create the connection to the server
  final smtpServer =
      SmtpServer(nameserver, username: username, password: password);

  // Create our message.
  final message = Message()
    ..from = Address(username)
    ..recipients.add(bookerEmail)
    ..subject = 'Medical Help request from SafeIn application!}'
    ..text = 'This is the plain text.\nThis is line 2 of the text part.'
    ..html = "Medical Help message sent at ${DateTime.now()} <br>"
        "From number: $countryCode$userPhone<br>"
        "Current location: <br>"
        "<a href='$mapLink' target='_blank'/> Go to user location</a>";

  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Message not sent.');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  }
  print("Send Medical Help Email End");
}

// CAR RELATED EMAIL + SMS ====================================

void sendCarRelatedHelpRequest() async {
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation);
  String mapLink =
      "https://www.google.com/maps/dir/?api=1&destination=${position.latitude},${position.longitude}";

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String bookerEmail = prefs.getString('bookerEmail');
  String bookerPhone = prefs.getString('bookerPhone');
  String userPhone = prefs.getString('userPhone');
  String countryCode = prefs.getString('countryCode');

  // print("shared preferences User phone: $countryCode + $userPhone");
  // print("shared preferences booker phone: $bookerPhone");
  // print("shared preferences Booker email: $bookerEmail");

  print("Send Car Related Help Sms Start");

  final recipients = countryCode+bookerPhone;
  final sender = "$countryCode"+"$userPhone";
  final fullmessage = "Sender ($sender) has a car issue.\n"
            "Date-time at ${DateTime.now()}\n"
            "Location:\n"
            "$mapLink";


  final response = await http.get(Uri.parse(
      "https://www.activemms.com/extapi.asp?username=$activemmsusr"
          "&password=$activemmspw"
          "&recepients=$recipients"
          "&sender=$userPhone"
          "&message=$fullmessage&smstype=0&sendbackstatus=true"));

  if (response.statusCode == 200 &&
      response.body.isNotEmpty) {
    print(
        "++++++++++++++++++++++++++\n"
            "response.statusCode == 200\n"
            "+++++++++++++++++++++++++++");
    // try{
    var data = response.body;
    // json.decode(response.body);
    print(data); //[code]
    //  } on FormatException catch (e){
    // print(e);
  }

  print("Used Activemms with the recipient number and message body.");

  print("Send Car Related Help Sms End");
  print("-------------------------------");
  print("Send Car Related Help Email Start");
  // create the connection to the server
  final smtpServer =
      SmtpServer(nameserver, username: username, password: password);

  // Create our message.
  final message = Message()
    ..from = Address(username)
    ..recipients.add(bookerEmail)
    ..subject = 'Car related Help request from SafeIn application!}'
    ..html = "Car related help message sent at ${DateTime.now()} <br>"
        "From number: $countryCode$userPhone<br>"
        "Current location: \n"
        "<a href='$mapLink' target='_blank'/> Go to user location</a>";

  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Message not sent.');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  }
}

// USER LOST EMAIL + SMS =========================================
void sendLostRequest() async {
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation);
  String mapLink =
      "https://www.google.com/maps/dir/?api=1&destination=${position.latitude},${position.longitude}";
  // SharedPreferences package
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String bookerEmail = prefs.getString('bookerEmail');
  String bookerPhone = prefs.getString('bookerPhone');
  String userPhone = prefs.getString('userPhone');
  String countryCode = prefs.getString('countryCode');

  print("shared preferences User phone: $countryCode + $userPhone");
  print("shared preferences Booker email: $bookerEmail");
  print("shared preferences booker phone: $bookerPhone");

  print("sendLostSms Start");

  final recipients = countryCode+bookerPhone;
  final sender = "$countryCode"+"$userPhone";
  final fullmessage = "Sender ($sender) got lost, Help needed..\n"
            "Sent at ${DateTime.now()}\n"
            "Location:\n"
            "$mapLink";


  final response = await http.get(Uri.parse(
      "https://www.activemms.com/extapi.asp?username=$activemmsusr"
          "&password=$activemmspw"
          "&recepients=$recipients"
          "&sender=$userPhone"
          "&message=$fullmessage&smstype=0&sendbackstatus=true"));

  if (response.statusCode == 200 &&
      response.body.isNotEmpty) {
    print(
        "++++++++++++++++++++++++++\n"
            "response.statusCode == 200\n"
            "+++++++++++++++++++++++++++");
    // try{
    var data = response.body;
    // json.decode(response.body);
    print(data); //[code]
    //  } on FormatException catch (e){
    // print(e);
  }

  print("Used Activemms with the recipient number and message body.");

  print("Send Sms End");
  print("------------------------------------");
  print("Send Lost Help Email Start");
  // create the connection to the server
  final smtpServer =
      SmtpServer(nameserver, username: username, password: password);
  // Create our message.
  final message = Message()
    ..from = Address(username)
    ..recipients.add(bookerEmail)
    ..subject = 'Got lost related Help Mail from SafeIn application!}'
    ..html =
        "User phone number: $countryCode$userPhone sent message at ${DateTime.now()} that he get lost.<br>"
            "Current location:</br>"
            "<a href='$mapLink' target='_blank'/> Go to user location</a>";

  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Message not sent.');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  }
}
