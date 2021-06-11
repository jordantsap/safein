// import 'dart:convert';
// import 'package:after_layout/after_layout.dart';
// import 'package:app_settings/app_settings.dart';
// import 'package:connectivity/connectivity.dart';
// import 'package:geolocator/geolocator.dart';
// import 'src/auth.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'ask_help.dart';
// import 'src/app_localizations.dart';
// import 'src/settings.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'package:country_code_picker/country_code_picker.dart';
//
// class Verification extends StatefulWidget {
//   // Create a global key that uniquely identifies the Form widget
//   // and allows validation of the form.
//   @override
//   _VerificationState createState() => _VerificationState();
// }
//
// class _VerificationState extends State<Verification> with AfterLayoutMixin<Verification> {
//
//   //  connectivity check
//   void askConnectivity() async {
//     var connectivityResult = await (Connectivity().checkConnectivity());
//     if (connectivityResult == ConnectivityResult.mobile) {
//       print("Internet method = Mobile data from Verification screen");
//     } else if (connectivityResult == ConnectivityResult.wifi) {
//       print("Internet method = Wifi from Verification screen");
//     } else if (connectivityResult == ConnectivityResult.none) {
//       print("Internet method = None from Verification screen");
//       showDialog(
//           context: context,
//           builder: (_) => new AlertDialog(
//                 title: Text(AppLocalizations.of(context)
//                     .translate('internet_alert_title')),
//                 content: Text(AppLocalizations.of(context)
//                     .translate('internet_alert_content')),
//                 actions: <Widget>[
//                   ElevatedButton(
//                     child: Text(AppLocalizations.of(context)
//                         .translate('wifisettings_btn')),
//                     onPressed: () {
//                       AppSettings.openWIFISettings();
//                       Navigator.of(context).pop();
//                     },
//                   ),
//                   ElevatedButton(
//                     child: Text(
//                         AppLocalizations.of(context).translate('close_btn')),
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                   )
//                 ],
//               ));
//     } // else if
//   } // askConnectivity
//
//   @override
//   void afterFirstLayout(BuildContext context) {
//     // Calling the same function "after layout" to resolve the issue.
//     askConnectivity();
//   }
//
//   Future<Position> checkLocation() async {
//     bool serviceEnabled;
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       showDialog(
//           context: context,
//           builder: (_) => new AlertDialog(
//             title: Text(AppLocalizations.of(context)
//                 .translate('location_alert_title')),
//             content: Text(AppLocalizations.of(context)
//                 .translate('location_alert_content')),
//             actions: <Widget>[
//               ElevatedButton(
//                 child: Text(AppLocalizations.of(context)
//                     .translate('location_settings_btn')),
//                 onPressed: () {
//                   AppSettings.openLocationSettings();
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           ));
//       return Future.error('Location services are disabled.');
//     }
//
//     return await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.bestForNavigation);
//   }
//
//   FocusNode codeField;
//   FocusNode phoneField;
//
//   @override
//   void initState() {
//     super.initState();
//     checkLocation();
//     checkPermissions();
//     // sendData();
//     // listenConnectivity();
//     // serverDetails();
//     codeField = FocusNode();
//     phoneField = FocusNode();
//   }
//
//   // Be sure to cancel subscription after you are done
//   @override
//   dispose() {
//     super.dispose();
//     // var subscription;
//     // subscription.cancel();
//     codeField.dispose();
//     phoneField.dispose();
//   }
//
//   final userPhoneController = TextEditingController();
//   final verificationCodeController = TextEditingController();
//
//   String userPhoneField;
//   String verificationCodeField;
//   // use the TextEditingController() to clear the text field when needed
//   // i will clear it after onPressed() function assigned to the button
//   void clearText() {
//     userPhoneController.clear();
//     verificationCodeController.clear();
//   }
//   // form key variable
//   final _formKey = GlobalKey<FormState>();
//   // prevent button clicked more than once
//   var isPressed = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//           appBar: new AppBar(
//             centerTitle: true,
//             leading: null,
//             // IconButton(
//             //   icon: Icon(Icons.accessibility_new),
//             //   iconSize: 20.0,
//             // ),
//             title: new Text(
//               AppLocalizations.of(context).translate('safein_title') + domain,
//               maxLines: 2,
//             ),
//             // center the text horizontaly
//           ),
//           body: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8.0),
//               child: Column(
//                 children: [
//                   Container(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 8.0),
//                       child: Form(
//                         key: _formKey,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               AppLocalizations.of(context)
//                                   .translate('verification_header'),
//                               style: TextStyle(
//                                 fontSize: 20.0,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             TextFormField(
//                               autofocus: true,
//                               focusNode: codeField,
//                               controller: verificationCodeController,
//                               textInputAction: TextInputAction.next,
//                               onFieldSubmitted: (term){
//                                 codeField.unfocus();
//                                 FocusScope.of(context).requestFocus(phoneField);
//                               },
//                               validator: (value) {
//                                 if (value.isEmpty) {
//                                   return AppLocalizations.of(context)
//                                       .translate('notempty_val');
//                                 }
//                                 return null;
//                               },
//                               keyboardType: TextInputType.number,
//                               decoration: InputDecoration(
//                                 labelText: AppLocalizations.of(context)
//                                     .translate('code_label'),
//                                 hintText: AppLocalizations.of(context)
//                                     .translate('code_hint'),
//                               ),
//                               // onSaved method is called when formKey.currentState.save
//                               // is called during form submission
//                               onSaved: (String value) {
//                                 // assign the value of the text field to a variable
//                                 verificationCodeField = value;
//                               },
//                             ),
//                             Row(
//                               children: [
//                                 CountryCodePicker(
//                                   onChanged: _onCountryChange,
//                                   initialSelection: 'GR',
//                                   onInit: _onCountryChange,
//                                   favorite: ['RU', 'BG', 'AL', 'RO'],
//                                 ),
//                                 Flexible(
//                                   child: TextFormField(
//                                     focusNode: phoneField,
//                                     controller: userPhoneController,
//                                     textInputAction: TextInputAction.done,
//                                     onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(),
//                                     // onFieldSubmitted: (term){
//                                     //   phoneField.unfocus();
//                                     //   FocusScope.of(context).requestFocus();
//                                     // },
//                                     //handle userPhone field
//                                     validator: (value) {
//                                       if (value.isEmpty) {
//                                         return AppLocalizations.of(context)
//                                             .translate('notempty_val');
//                                       }
//                                       if (value.length != 10) {
//                                         return AppLocalizations.of(context)
//                                             .translate('digit_val');
//                                       }
//                                       if (!RegExp(r'(^(?:[+0]9)?[0-9]{10}$)')
//                                           .hasMatch(value)) {
//                                         return AppLocalizations.of(context)
//                                             .translate('phone_val');
//                                       }
//                                       return null;
//                                     },
//                                     decoration: InputDecoration(
//                                       labelText: AppLocalizations.of(context)
//                                           .translate('phone_label'),
//                                       hintText: AppLocalizations.of(context)
//                                           .translate('phone_hint'),
//                                     ),
//                                     keyboardType: TextInputType.number,
//                                     // onSaved method is called when formKey.currentState.save
//                                     // is called during form submission
//                                     onSaved: (String value) {
//                                       // assign the value of the text field to a variable
//                                       userPhoneField = value;
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(
//                               width: double.infinity,
//                               child: Builder(builder: (context) {
//                                 return ElevatedButton(
//                                   onPressed: isPressed ? null : () async {
//                                     setState(() => isPressed = true);
//                                     var connectivityResult = await (Connectivity().checkConnectivity());
//                                     if(connectivityResult == ConnectivityResult.none) {
//                                       Scaffold.of(context).showSnackBar(
//                                           SnackBar(
//                                               backgroundColor:
//                                               Theme.of(context)
//                                                   .primaryColor,
//                                               duration: Duration(seconds: 5),
//                                               content: Text(
//                                                   AppLocalizations.of(context)
//                                                       .translate('no_internet'),
//                                                   style: TextStyle(
//                                                     fontSize: 20.0,
//                                                   ))));
//                                     } else {
//
//                                       // Validate returns true if the form is valid, otherwise false.
//                                       if (_formKey.currentState.validate()) {
//                                         print("Button pressed");
//                                         Scaffold.of(context).showSnackBar(
//                                             SnackBar(
//                                                 backgroundColor:
//                                                 Theme.of(context)
//                                                     .primaryColor,
//                                                 duration: Duration(seconds: 7),
//                                                 content: Text(
//                                                     AppLocalizations.of(context)
//                                                         .translate('sending'),
//                                                     style: TextStyle(
//                                                       fontSize: 20.0,
//                                                     ))));
//                                         askConnectivity();
//
//                                         // now save the state of the form using the form key
//                                         // .save() uses the onSaved: method that we used earlier
//                                         // in each field and saves it's value
//                                         _formKey.currentState.save();
//
//                                         // define variables
//                                         final companyCode =
//                                             verificationCodeController.text;
//                                         final response = await http.get(
//                                             "https://appserver.anathesis.eu/api/companies/" +
//                                                 "$companyCode");
//                                         if (response.statusCode == 200 &&
//                                             response.body.isNotEmpty) {
//                                           showDialog(
//                                               context: context,
//                                               builder: (_) => new AlertDialog(
//                                                 title: Text(AppLocalizations.of(context)
//                                                     .translate('confirmation_title')),
//                                                 content: Text(AppLocalizations.of(context)
//                                                     .translate('confirmation_content')),
//                                                 actions: <Widget>[
//                                                   ElevatedButton(
//                                                     child: Text(
//                                                         AppLocalizations.of(context).translate('close_btn')),
//                                                     onPressed: () {
//                                                       Navigator.of(context, rootNavigator: true).pop();
//                                                     },
//                                                   )
//                                                 ],
//                                               ));
//
//                                           print(
//                                               'code 200 and not empty true so...');
//                                           print(response.statusCode);
//                                           // Did return a 200 OK response, so map data
//                                           var data = json.decode(response.body);
//
//                                           print(data['id']); //[code]
//                                           print("Laravel data :----------------------"); //[data]
//                                           print(data); //[code]
//                                           final bookerCode = data['id'];
//                                           final bookerEmail = data['email'];
//                                           print(bookerEmail);
//                                           final bookerPhone = data['phone'];
//                                           print(bookerPhone);
//                                           final bookerLat = data['latitude'];
//                                           print(bookerLat);
//                                           final bookerLng = data['longitude'];
//                                           print(bookerLng);
//
//                                           SharedPreferences prefs =
//                                           await SharedPreferences
//                                               .getInstance();
//                                           prefs.setInt('bookerCode', bookerCode);
//                                           prefs.setString(
//                                               'bookerEmail', bookerEmail);
//                                           prefs.setString(
//                                               'bookerPhone', bookerPhone);
//                                           prefs.setString('userPhone',
//                                               userPhoneController.text);
//                                           prefs.setString(
//                                               'bookerLat', bookerLat);
//                                           prefs.setString(
//                                               'bookerLng', bookerLng);
//
//                                           print(
//                                               "bookerCode received by API: $bookerCode");
//                                           print(prefs.getInt('bookerCode'));
//
//                                           newCustomer();
//                                           // createCustomer();
//                                           clearText();
//
//                                           Navigator.push(
//                                             context,
//                                             new MaterialPageRoute(
//                                                 builder: (context) =>
//                                                 new AskHelp()),
//                                           );
//                                         } else {
//                                           print(response.statusCode);
//                                           print(response);
//                                           print(
//                                               'Is empty response no authentication connection');
//                                           Scaffold.of(context).showSnackBar(
//                                               SnackBar(
//                                                   backgroundColor:
//                                                   Theme.of(context)
//                                                       .primaryColor,
//                                                   duration: Duration(seconds: 5),
//                                                   content: Text(
//                                                       AppLocalizations.of(context)
//                                                           .translate('no_auth'),
//                                                       style: TextStyle(
//                                                         fontSize: 20.0,
//                                                       ))));
//                                         } // if end
//                                       } // if validate close
//                                     }
//                                     setState(() => isPressed = false);
//                                   },
//                                   onLongPress: null, // Set one as NOT null is enough to enable the button
//                                   child: Text(AppLocalizations.of(context)
//                                       .translate('submit')),
//                                 );
//                               }),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   Container(
//                     decoration: BoxDecoration(
//                       border: Border(
//                         bottom: BorderSide(width: 2.0, color: Colors.redAccent),
//                       ),
//                     ),
//                     child: Text(
//                       AppLocalizations.of(context).translate('usage_notice'),
//                       style: TextStyle(fontSize: 20.0, color: Colors.red),
//                     ),
//                   ),
//                   Container(
//                     padding: EdgeInsets.symmetric(horizontal: 10.0),
//                     child: Text(
//                       AppLocalizations.of(context).translate('requires'),
//                       style: TextStyle(
//                         fontSize: 20.0,
//                         // decoration: TextDecoration.underline,
//                         color: Colors.red,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//     );
//   }
//
// }
//
// void _onCountryChange(CountryCode countryCode) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   prefs.setString('countryCode', countryCode.dialCode);
//
//   print(prefs.getString('countryCode'));
// }
