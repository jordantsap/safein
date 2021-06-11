// import 'package:http/http.dart' as http;
// import 'dart:io';
// import 'package:flutter_sms/flutter_sms.dart';
import 'package:twilio_flutter/twilio_flutter.dart';
// import 'package:smsker/smsker.dart';
import 'settings.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:shared_preferences/shared_preferences.dart';

// MEDICAL HELP REQUESTS ===================================================
//SEND SMS

void sendMedicalHelpRequest() async {

  // http.Response response = await http.post('https://appserver.anathesis.eu/api/customers/store');
  //
  //   print(response.statusCode);
  //   // Did return a 200 OK response,
  //   Map data = json.decode(response.body);
  //   print(data); //[code]
  //   final userCode = data['id'];
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //
  //   prefs.setInt('bookerCode', userCode);
  //   prefs.getString('userPhone');

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
  // TwilioFlutter twilioFlutter;
  TwilioFlutter twilioFlutter;
  twilioFlutter = TwilioFlutter(
      accountSid : 'ACffef97b6f114ed632654352a3989150b', // my credentials *** with Account SID
      authToken : 'ad8a106b24d6f14281aabc57f2f19fdc',  // replace xxx with Auth Token
      twilioNumber : '+17742177524'  // replace .... with Twilio Number
  );
  twilioFlutter.sendSMS(
      toNumber : countryCode+bookerPhone,
      messageBody : "Medical reason Help needed.\n"
            "Sent at ${DateTime.now()}\n"
            "Location:\n"
            "$mapLink");
  print("Used twilioFlutter.sendSMS with the recipient number and message body.");
  // if(Platform.isAndroid){
  //
  //   print("Platform is Android");
  //   void _sendSMS(String message, String number) async {
  //     String _result = await sendSMS(message: message, recipients: [number])
  //         .catchError((onError) {
  //       print(onError);
  //     });
  //     print(_result);
  //   }
  //   String message = "Medical reason Help needed.\n"
  //       "Sent at ${DateTime.now()}\n"
  //       "Location:\n"
  //       "$mapLink";
  //
  //   _sendSMS(message, bookerPhone);
  //   //  next commented are for ios development
  // // } else if (Platform.isIOS){
  // //   print("Platform is IOS");
  // //   void _sendSMS(String message, String number) async {
  // //     String _result = await sendSMS(message: message, recipients: [number])
  // //         .catchError((onError) {
  // //       print(onError);
  // //     });
  // //     print(_result);
  // //   }
  // //   String message = "Medical reason Help needed.\n"
  // //       "Sent at ${DateTime.now()}\n"
  // //       "Location:\n"
  // //       "$mapLink";
  // //   String number = bookerPhone;
  // //
  // //   _sendSMS(message, number);
  // }
  print("Send Medical Sms End");

  print("Send Medical Help Email Start");
  // create the connection to the server
  final smtpServer =
      SmtpServer(nameserver, username: username, password: password);

  // Create our message.
  final message = Message()
    ..from = Address(username)
    ..recipients.add(bookerEmail)
    ..subject = 'Medical Help request from feelsafe application!}'
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
  // TwilioFlutter twilioFlutter;
  TwilioFlutter twilioFlutter;
  twilioFlutter = TwilioFlutter(
      accountSid : 'ACffef97b6f114ed632654352a3989150b', // my credentials *** with Account SID
      authToken : 'ad8a106b24d6f14281aabc57f2f19fdc',  // replace xxx with Auth Token
      twilioNumber : '+17742177524'  // replace .... with Twilio Number
  );
  twilioFlutter.sendSMS(
      toNumber : countryCode+bookerPhone,
      messageBody : "Sender has a car issue.\n"
            "Date-time at ${DateTime.now()}\n"
            "Location:\n"
            "$mapLink");
  print("Used twilioFlutter.sendSMS with the recipient number and message body.");
  // if(Platform.isAndroid) {
  //
  //   print("Platform is ANDROID");
  //   void _sendSMS(String message, String number) async {
  //     String _result = await sendSMS(message: message, recipients: [number])
  //         .catchError((onError) {
  //       print(onError);
  //     });
  //     print(_result);
  //   }
  //   String message = "Sender has a car issue.\n"
  //       "Date-time at ${DateTime.now()}\n"
  //       "Location:\n"
  //       "$mapLink";
  //
  //   _sendSMS(message, bookerPhone);
  //   //  next commented are for ios development
  // // } else if (Platform.isIOS) {
  // //   print("Platform is IOS");
  // //   void _sendSMS(String message, String number) async {
  // //     String _result = await sendSMS(message: message, recipients: [number])
  // //         .catchError((onError) {
  // //       print(onError);
  // //     });
  // //     print(_result);
  // //   }
  // //   String message = "Sender has a car issue.\n"
  // //       "Date-time at ${DateTime.now()}\n"
  // //       "Location:\n"
  // //       "$mapLink";
  // //   String number = bookerPhone;
  // //
  // //   _sendSMS(message, number);
  // }
  print("Send Car Related Help Sms End");
  //
  print("Send Car Related Help Email Start");
  // create the connection to the server
  final smtpServer =
      SmtpServer(nameserver, username: username, password: password);

  // Create our message.
  final message = Message()
    ..from = Address(username)
    ..recipients.add(bookerEmail)
    ..subject = 'Car related Help request from feelsafe application!}'
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

  // print("shared preferences User phone: $countryCode + $userPhone");
  // print("shared preferences Booker email: $bookerEmail");
  // print("shared preferences booker phone: $bookerPhone");

  print("sendLostSms Start");

  TwilioFlutter twilioFlutter;
  twilioFlutter = TwilioFlutter(
      accountSid : 'ACffef97b6f114ed632654352a3989150b', // my credentials *** with Account SID
      authToken : 'ad8a106b24d6f14281aabc57f2f19fdc',  // replace xxx with Auth Token
      twilioNumber : '+17742177524'  // replace .... with Twilio Number
  );
  twilioFlutter.sendSMS(
      toNumber : countryCode+bookerPhone,
      messageBody : "Sender got lost, Help needed..\n"
            "Sent at ${DateTime.now()}\n"
            "Location:\n"
            "$mapLink");
  print("Used twilioFlutter.sendSMS with the recipient number and message body.");
  // if(Platform.isAndroid){
  //
  //   print("Platform is Android");
  //   void _sendSMS(String message, String number) async {
  //     String _result = await sendSMS(message: message, recipients: [number])
  //         .catchError((onError) {
  //       print(onError);
  //     });
  //     print(_result);
  //   }
  //   String message = "Sender got lost, Help needed..\n"
  //       "Sent at ${DateTime.now()}\n"
  //       "Location:\n"
  //       "$mapLink";
  //
  //   _sendSMS(message, bookerPhone);
  //   //  next commented are for ios development
  // // } else if(Platform.isIOS){
  // //   print("Platform is IOS");
  // //   void _sendSMS(String message, String number) async {
  // //     String _result = await sendSMS(message: message, recipients: [number])
  // //         .catchError((onError) {
  // //       print(onError);
  // //     });
  // //     print(_result);
  // //   }
  // //   String message = "Sender got lost, Help needed..\n"
  // //       "Sent at ${DateTime.now()}\n"
  // //       "Location:\n"
  // //       "$mapLink";
  // //   String number = bookerPhone;
  // //
  // //   _sendSMS(message, number);
  //   //
  //   //
  // }
  // print("Send Sms End");
  //
  // print("Send Lost Help Email Start");
  // create the connection to the server
  final smtpServer =
      SmtpServer(nameserver, username: username, password: password);
  // Create our message.
  final message = Message()
    ..from = Address(username)
    ..recipients.add(bookerEmail)
    ..subject = 'Got lost related Help Mail from feelsafe application!}'
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
