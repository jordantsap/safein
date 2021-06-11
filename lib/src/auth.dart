// import 'dart:io' show Platform;
// import 'package:url_launcher/url_launcher.dart';
import 'settings.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:url_launcher/url_launcher.dart';
import 'package:twilio_flutter/twilio_flutter.dart';
void newCustomer() async {

  // var endpoint = 'https://appserver.anathesis.eu/api/history/store/';
  // var response = await http.post(endpoint, body: {'name': 'doodle', 'company_id': 'blue'});
  // print('Response status: ${response.statusCode}');
  // print('Response body: ${response.body}');

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
  String userPhone = prefs.getString('userPhone');
  String countryCode = prefs.getString('countryCode');
  // print("shared preferences User phone: $countryCode + $userPhone");
  print("shared preferences Booker email: $bookerEmail");

  // Create our message.
  print("New user send email Start");
  final message = Message()
    ..from = Address(username)
    ..recipients.add(bookerEmail)
    ..subject = 'New user from feelsafe application!'
    ..html = "Message sent at: ${DateTime.now()} <br>"
        "From number: $countryCode$userPhone<br>"
        "Mobile location: <a href='$mapLink'/> Go to User Location</a>";

  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Message not sent.');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  }


  print("New user send sms Start");

  // TwilioFlutter twilioFlutter main setup;
  TwilioFlutter twilioFlutter;
  twilioFlutter = TwilioFlutter(
      accountSid : 'ACffef97b6f114ed632654352a3989150b', // my credentials *** with Account SID
      authToken : 'ad8a106b24d6f14281aabc57f2f19fdc',  // replace xxx with Auth Token
      twilioNumber : '+17742177524'  // replace .... with Twilio Number
  );
  twilioFlutter.sendSMS(
      toNumber : countryCode+bookerPhone,
      messageBody : "New user from feelsafe application\n"
          "Date and time at ${DateTime.now()}\n"
          "Location:\n"
          "$mapLink");
  print("Use twilioFlutter.sendSMS with the recipient number and message body.");

  // if(Platform.isAndroid){
  //
  //   print("Platform is android");
  //   void _sendSMS(String message, String number) async {
  //     String _result = await sendSMS(message: message, recipients: [number])
  //         .catchError((onError) {
  //       print(onError);
  //     });
  //     print(_result);
  //   }
  //   String message = "New user from feelsafe application\n"
  //       "Date and time at ${DateTime.now()}\n"
  //       "Location:\n"
  //       "$mapLink";
  //
  //   _sendSMS(message, bookerPhone);
  //
  // //  next commented are for ios development
  // // } else if (Platform.isIOS) {
  // //   print("Platform is IOS");
  // //   void _sendSMS(String message, String number) async {
  // //     String _result = await sendSMS(message: message, recipients: [number])
  // //         .catchError((onError) {
  // //       print(onError);
  // //     });
  // //     print(_result);
  // //   }
  // //   String message = "New user from feelsafe application\n"
  // //       "Date and time at ${DateTime.now()}\n"
  // //       "Location:\n"
  // //       "$mapLink";
  // //
  // //   _sendSMS(message, bookerPhone);
  // }

  print("New user send sms end");
}
