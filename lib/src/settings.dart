// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:safein/src/app_localizations.dart';

// TODO: REMOVE CREDENTIALS BEFORE GITHUB UPLOAD
//create email service credentials
String username = 'feelsafeapp@anathesis.eu';
String password = '!1DeuampeiwPote!2';
String nameserver = 'linux123.papaki.gr';
String domain = 'anathesis.eu';

// Request to server to get validation
// void serverDetails() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   // Geolocator package
//   Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.bestForNavigation);
//   String mapLink =
//       "https://www.google.com/maps/dir/?api=1&destination=${position.latitude},${position.longitude}";
//
// // TODO: ANATHESIS SERVER UPLOADS
// prefs.setString("bookerPhone", '+306936769029');
// prefs.setString('bookerEmail', 'info@anathesis.eu');
// // TODO: LOCALHOST TESTING DETAILS
//   prefs.setString("bookerPhone", '+306987492041');
//   prefs.setString("referenceCode", '');
//   prefs.setString("bookerPosition", mapLink);
//   prefs.setString('bookerEmail', 'jordantsap@hotmail.gr');
// }
//
// listenConnectivity() async {
//   var subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
//     // Got a new connectivity status!
//     if (result == ConnectivityResult.mobile) {
//       print("I am connected to a mobile network.");
//     } else if (result == ConnectivityResult.wifi) {
//       print("I am connected to a wifi network.");
//     }
//     print('listen for connections continuesly');
//   });
//     return subscription;
// }
