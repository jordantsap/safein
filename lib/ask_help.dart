import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'src/app_localizations.dart';
import 'src/ask.dart';
import 'package:after_layout/after_layout.dart';
import 'package:app_settings/app_settings.dart';
import 'package:connectivity/connectivity.dart';
import 'welcome_screen.dart';
import 'main.dart';

class AskHelp extends StatefulWidget {
  @override
  _AskHelpState createState() => _AskHelpState();
}

class _AskHelpState extends State<AskHelp> with AfterLayoutMixin<AskHelp> {
  //
  // hotelierName() async{
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //
  //   String bookerName = prefs.getString('bookerName');
  //   return bookerName;
  // }


  @override
  void initState() {
    super.initState();
    // checkPermissions();
    checkLocation();
    // listenConnectivity();
    // getDirections();
  }

  //  connectivity check
  void askConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    // if (connectivityResult == ConnectivityResult.mobile) {
    //   print("Internet method = Mobile data from ask help screen");
    // } else if (connectivityResult == ConnectivityResult.wifi) {
    //   print("Internet method = Wifi from ask help screen");
    // } else
    if (connectivityResult == ConnectivityResult.none) {
      print("Internet method = None from ask help screen");
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => new AlertDialog(
                title: Text(AppLocalizations.of(context)
                    .translate('internet_alert_title')),
                content: Text(AppLocalizations.of(context)
                    .translate('internet_alert_content')),
                actions: <Widget>[
                  ElevatedButton(
                    child: Text(AppLocalizations.of(context)
                        .translate('wifisettings_btn')),
                    onPressed: () {
                      AppSettings.openWIFISettings();
                      Navigator.of(context).pop();
                    },
                  ),
                  ElevatedButton(
                    child: Text(AppLocalizations.of(context)
                        .translate('already_did_btn')),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ));
    } // else if
  } // askConnectivity

  @override
  void afterFirstLayout(BuildContext context) {
    // Calling the same function "after layout" to resolve the issue.
    askConnectivity();
  }

  Future<Position> checkLocation() async {
    bool serviceEnabled;
    // LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => new AlertDialog(
                title: Text(AppLocalizations.of(context)
                    .translate('location_alert_title')),
                content: Text(AppLocalizations.of(context)
                    .translate('location_alert_content')),
                actions: <Widget>[
                  ElevatedButton(
                    child: Text(AppLocalizations.of(context)
                        .translate('location_settings_btn')),
                    onPressed: () {
                      AppSettings.openLocationSettings();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ));
      return Future.error('Location services are disabled.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
  }

  // Be sure to cancel subscription after you are done
  // @override
  // dispose() {
  //   super.dispose();
  //   // var subscription;
  //   // subscription.cancel();
  // }

  Future<bool> _goBack() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userPhone = prefs.getString('userPhone');
    if (userPhone != null) {
      return Navigator.push(
        context,
        new MaterialPageRoute(builder: (context) => new WelcomeScreen()),
        // new AskHelp()),
      );
    } else {
      return Navigator.push(
        context,
        new MaterialPageRoute(builder: (context) => new SafeInApp()),
        // new AskHelp()),
      );
    }
  }

// prevent button clicked more than once
  var isPressed = false;

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      // remove the debug banner from top right of the screen
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'SukhumvitSet'),
      color: Theme.of(context).primaryColor,

      // List all of the app's supported locales here
      supportedLocales: [
        Locale('en', 'US'),
        Locale('el', 'EL'),
      ],
      // These delegates make sure that the localization data for the proper language is loaded
      localizationsDelegates: [
        // THIS CLASS WILL BE ADDED LATER
        // A class which loads the translations from JSON files
        AppLocalizations.delegate,
        // Built-in localization of basic text for Material widgets
        GlobalMaterialLocalizations.delegate,
        // Built-in localization for text direction LTR/RTL
        GlobalWidgetsLocalizations.delegate,
      ],
      // Returns a locale which will be used by the app
      localeResolutionCallback: (locale, supportedLocales) {
        // Check if the current device locale is supported
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        // If the locale of the device is not supported, use the first one
        // from the list (English, in this case).
        return supportedLocales.first;
      },
      home: Scaffold(
        backgroundColor: Color(0xFF15294e),
        appBar: AppBar(
          backgroundColor: Color(0xFFCED1D1),
          leading: IconButton(
            icon: Semantics(
                label: AppLocalizations.of(context).translate('ask_help_title'),
                child: Icon(Icons.accessibility_new)),
            iconSize: 20.0,
            color: Color(0xFF060C17),
            onPressed: () {
              _goBack();
            },
          ),
          title: Text(
            AppLocalizations.of(context).translate('ask_help_title'),
            textAlign: TextAlign.center,
            maxLines: 2,
            style: TextStyle(color: Color(0xFF060C17)),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 1.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.0),
              color: Color(0xFFff6e41),
            ),
            child: Center(
              child: SingleChildScrollView(
                child: Builder(builder: (context) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 18,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100.0),
                      color: Color(0xFF15294e),
                    ),
                    child: Column(
                      children: <Widget>[
                        Text(
                          AppLocalizations.of(context)
                              .translate('medical_help_title'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              primary: Color(0xFFff6e41)),
                          icon: Icon(Icons.local_hospital_sharp),
                          label: Text(AppLocalizations.of(context)
                              .translate('medical_help_btn')),
                          onPressed: isPressed
                              ? null
                              : () async {
                                  setState(() => isPressed = true);
                                  // print("Button pressed");

                                  var connectivityResult = await (Connectivity()
                                      .checkConnectivity());
                                  if (connectivityResult ==
                                      ConnectivityResult.none) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            backgroundColor:
                                                Theme.of(context).primaryColor,
                                            duration: Duration(seconds: 5),
                                            content: Text(
                                                AppLocalizations.of(context)
                                                    .translate('no_internet'),
                                                style: TextStyle(
                                                  fontSize: 20.0,
                                                ))));
                                  } else {
                                    sendMedicalHelpRequest();
                                    showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (_) => new AlertDialog(
                                              title: Text(AppLocalizations.of(
                                                      context)
                                                  .translate(
                                                      'messagesent_confirmation_title')),
                                              content: Text(AppLocalizations.of(
                                                      context)
                                                  .translate(
                                                      'messagesent_confirmation_content')),
                                              actions: <Widget>[
                                                ElevatedButton(
                                                  child: Text(AppLocalizations
                                                          .of(context)
                                                      .translate('close_btn')),
                                                  onPressed: () {
                                                    Navigator.of(context,
                                                            rootNavigator: true)
                                                        .pop();
                                                  },
                                                )
                                              ],
                                            ));
                                  }
                                  setState(() => isPressed = false);
                                },
                          onLongPress:
                              null, // Set one as NOT null is enough to enable the button
                        ),
                        Text(
                          AppLocalizations.of(context)
                              .translate('car_help_title'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              primary: Color(0xFFff6e41)),
                          icon: Icon(Icons.car_repair),
                          label: Text(AppLocalizations.of(context)
                              .translate('car_help_btn')),
                          onPressed: isPressed
                              ? null
                              : () async {
                                  setState(() => isPressed = true);
                                  print("Button pressed");

                                  var connectivityResult = await (Connectivity()
                                      .checkConnectivity());
                                  if (connectivityResult ==
                                      ConnectivityResult.none) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            backgroundColor:
                                                Theme.of(context).primaryColor,
                                            duration: Duration(seconds: 5),
                                            content: Text(
                                                AppLocalizations.of(context)
                                                    .translate('no_internet'),
                                                style: TextStyle(
                                                  fontSize: 20.0,
                                                ))));
                                  } else {
                                    sendCarRelatedHelpRequest();
                                    showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (_) => new AlertDialog(
                                              title: Text(AppLocalizations.of(
                                                      context)
                                                  .translate(
                                                      'messagesent_confirmation_title')),
                                              content: Text(AppLocalizations.of(
                                                      context)
                                                  .translate(
                                                      'messagesent_confirmation_content')),
                                              actions: <Widget>[
                                                ElevatedButton(
                                                  child: Text(AppLocalizations
                                                          .of(context)
                                                      .translate('close_btn')),
                                                  onPressed: () {
                                                    Navigator.of(context,
                                                            rootNavigator: true)
                                                        .pop();
                                                  },
                                                )
                                              ],
                                            ));
                                  }
                                  setState(() => isPressed = false);
                                },
                          onLongPress: null,
                        ),
                        Text(
                          AppLocalizations.of(context)
                              .translate('lost_help_title'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              primary: Color(0xFFff6e41)),
                          icon: Icon(Icons.add_location),
                          label: Text(AppLocalizations.of(context)
                              .translate('lost_help_btn')),
                          onPressed: isPressed
                              ? null
                              : () async {
                                  setState(() => isPressed = true);
                                  print("Button pressed");

                                  var connectivityResult = await (Connectivity()
                                      .checkConnectivity());
                                  if (connectivityResult ==
                                      ConnectivityResult.none) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            backgroundColor:
                                                Theme.of(context).primaryColor,
                                            duration: Duration(seconds: 5),
                                            content: Text(
                                                AppLocalizations.of(context)
                                                    .translate('no_internet'),
                                                style: TextStyle(
                                                  fontSize: 20.0,
                                                ))));
                                  } else {
                                    sendLostRequest();
                                    showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (_) => new AlertDialog(
                                              title: Text(AppLocalizations.of(
                                                      context)
                                                  .translate(
                                                      'messagesent_confirmation_title')),
                                              content: Text(AppLocalizations.of(
                                                      context)
                                                  .translate(
                                                      'messagesent_confirmation_content')),
                                              actions: <Widget>[
                                                ElevatedButton(
                                                  child: Text(AppLocalizations
                                                          .of(context)
                                                      .translate('close_btn')),
                                                  onPressed: () {
                                                    Navigator.of(context,
                                                            rootNavigator: true)
                                                        .pop();
                                                  },
                                                )
                                              ],
                                            ));
                                  }
                                  setState(() => isPressed = false);
                                },
                          onLongPress: null,
                        ),
                        Divider(
                          thickness: 5.0,
                          color: Colors.blueGrey,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Column(
                            children: [
                              Text(
                                AppLocalizations.of(context)
                                    .translate('location_here'),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                    primary: Color(0xFFff6e41)),
                                icon: Icon(Icons.add_location),
                                label: Text(AppLocalizations.of(context)
                                    .translate('open_map')),
                                onPressed: _launchURL,
                              ),
                            ],
                          ),
                        ),
                        Semantics(
                          label: AppLocalizations.of(context)
                              .translate('an_logo_img'),
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            child: Image.asset('assets/ACLogotr.png'),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _launchURL() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String bookerLat = prefs.getString("bookerLat");
    String bookerLng = prefs.getString("bookerLng");
    // Geolocator package
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);

    if (Platform.isAndroid) {
      print("Device is android, open google maps");
      String mapLink =
          'https://maps.google.com?saddr=${position.latitude},${position.longitude}&daddr=$bookerLat,$bookerLng';
      await canLaunch(mapLink)
          ? await launch(mapLink)
          : throw 'Could not launch $mapLink';
    } else if (Platform.isIOS) {
      print("Map platform is IOS, open apple maps");
      String mapLink =
          'https://maps.apple.com/?saddr=${position.latitude},${position.longitude}&daddr=$bookerLat,$bookerLng';
      await canLaunch(mapLink)
          ? await launch(mapLink)
          : throw 'Could not launch $mapLink';
    }
  }
}

