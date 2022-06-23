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
import 'package:connectivity_plus/connectivity_plus.dart';
import 'welcome_screen.dart';
import 'main.dart';

class AskHelp extends StatefulWidget {
  @override
  _AskHelpState createState() => _AskHelpState();
}

class _AskHelpState extends State<AskHelp> with AfterLayoutMixin<AskHelp> {

  Future bookerName(bookerName) async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final bookerName = prefs.getString('bookerName');
    // setState(() {
      return bookerName;
    // });
  }

  //  connectivity check
  void askConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      print("Internet method = Mobile data from ask help screen");
    } else if (connectivityResult == ConnectivityResult.wifi) {
      print("Internet method = Wifi from ask help screen");
    } else
    if (connectivityResult == ConnectivityResult.none) {
      print("Internet method = None from ask help screen");
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => new AlertDialog(
                title: Semantics(
                  label: AppLocalizations.of(context)
                      .translate('internet_alert_title'),
                  child: Text(AppLocalizations.of(context)
                      .translate('internet_alert_title')),
                ),
                content: Semantics(
                  label: AppLocalizations.of(context)
                      .translate('internet_alert_content'),
                  child: Text(AppLocalizations.of(context)
                      .translate('internet_alert_content')),
                ),
                actions: <Widget>[
                  ElevatedButton(
                    child: Semantics(
                      label: AppLocalizations.of(context)
                          .translate('wifisettings_btn'),
                      child: Text(AppLocalizations.of(context)
                          .translate('wifisettings_btn')),
                    ),
                    onPressed: () {
                      AppSettings.openWIFISettings();
                      Navigator.of(context).pop();
                    },
                  ),
                  ElevatedButton(
                    child: Semantics(
                      label: AppLocalizations.of(context).translate('already_did_btn'),
                      child: Text(AppLocalizations.of(context)
                          .translate('already_did_btn')),
                    ),
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
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => new AlertDialog(
                title: Semantics(
                  label: AppLocalizations.of(context)
                      .translate('location_alert_title'),
                  child: Text(AppLocalizations.of(context)
                      .translate('location_alert_title')),
                ),
                content: Semantics(
                  label: AppLocalizations.of(context)
                      .translate('location_alert_content'),
                  child: Text(AppLocalizations.of(context)
                      .translate('location_alert_content')),
                ),
                actions: <Widget>[
                  ElevatedButton(
                    child: Semantics(
                      label: AppLocalizations.of(context)
              .translate('location_settings_ btn'),
                      child: Text(AppLocalizations.of(context)
                          .translate('location_settings_btn')),
                    ),
                    onPressed: () {
                      AppSettings.openLocationSettings();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ));
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  @override
  void initState() {
    super.initState();
    checkLocation();
    askConnectivity();
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

    return Semantics(
      label: AppLocalizations.of(context).translate('safein_empty_space'),
      child: MaterialApp(
        // remove the debug banner from top right of the screen
        debugShowCheckedModeBanner: false,
        // showSemanticsDebugger: true,
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
                                                  content: Semantics(
                                                    label: AppLocalizations.of(context)
                                                        .translate('no_internet'),
                                                    child: Text(
                                                        AppLocalizations.of(context)
                                                            .translate('no_internet'),
                                                        style: TextStyle(
                                                          fontSize: 20.0,
                                                        )),
                                                  )));
                                        } else {
                                          sendMedicalHelpRequest();
                                          showDialog(
                                            useSafeArea: true,
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (_) => new AlertDialog(
                                                semanticLabel: AppLocalizations.of(
                                                    context)
                                                    .translate(
                                                    'messagesent_confirmation_title'),
                                                    title: Text(AppLocalizations.of(
                                                            context)
                                                        .translate(
                                                            'messagesent_confirmation_title')),
                                                    content: Semantics(
                                                      label: AppLocalizations.of(
                                                          context)
                                                          .translate(
                                                          'messagesent_confirmation_content'),
                                                      child: Text(AppLocalizations.of(
                                                              context)
                                                          .translate(
                                                              'messagesent_confirmation_content')),
                                                    ),
                                                    actions: <Widget>[
                                                      Semantics(
                                                        label: AppLocalizations
                                                  .of(context)
                                                  .translate('close_btn'),
                                                        child: ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.of(context,
                                                                    rootNavigator: true)
                                                                .pop();
                                                          },
                                                          child: Text(AppLocalizations
                                                                  .of(context)
                                                              .translate('close_btn')),
                                                        ),
                                                      )
                                                    ],
                                                  ));
                                        }
                                        setState(() => isPressed = false);
                                      },
                                onLongPress:
                                    null, // Set one as NOT null is enough to enable the button
                              ),
                            Semantics(
                              label: AppLocalizations.of(context)
                                  .translate('car_help_title'),
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate('car_help_title'),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Semantics(
                              label: AppLocalizations.of(context)
                                  .translate('car_help_btn'),
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                    primary: Color(0xFFff6e41)),
                                icon: Icon(Icons.car_repair),
                                label: Semantics(
                                  label: AppLocalizations.of(context)
                                      .translate('car_help_btn'),
                                  child: Text(AppLocalizations.of(context)
                                      .translate('car_help_btn')),
                                ),
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
                                                  content: Semantics(
                                                    label: AppLocalizations.of(context)
                                                        .translate('no_internet'),
                                                    child: Text(
                                                        AppLocalizations.of(context)
                                                            .translate('no_internet'),
                                                        style: TextStyle(
                                                          fontSize: 20.0,
                                                        )),
                                                  )));
                                        } else {
                                          sendCarRelatedHelpRequest();
                                          showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (_) => new AlertDialog(
                                                    title: Semantics(
                                                      label: AppLocalizations.of(
                                                          context)
                                                          .translate(
                                                          'messagesent_confirmation_title'),
                                                      child: Text(AppLocalizations.of(
                                                              context)
                                                          .translate(
                                                              'messagesent_confirmation_title')),
                                                    ),
                                                    content: Semantics(
                                                      label: AppLocalizations.of(
                                                          context)
                                                          .translate(
                                                          'messagesent_confirmation_content'),
                                                      child: Text(AppLocalizations.of(
                                                              context)
                                                          .translate(
                                                              'messagesent_confirmation_content')),
                                                    ),
                                                    actions: <Widget>[
                                                      ElevatedButton(
                                                        child: Semantics(
                                                          label: AppLocalizations
                                                  .of(context)
                                                  .translate('close_btn'),
                                                          child: Text(AppLocalizations
                                                                  .of(context)
                                                              .translate('close_btn')),
                                                        ),
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
                            ),
                            Semantics(
                              label: AppLocalizations.of(context)
                                  .translate('lost_help_title'),
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate('lost_help_title'),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Semantics(
                              label: AppLocalizations.of(context)
                                  .translate('lost_help_btn'),
                              child: ElevatedButton.icon(
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
                                                  content: Semantics(
                                                    label: AppLocalizations.of(context)
                                                        .translate('no_internet'),
                                                    child: Text(
                                                        AppLocalizations.of(context)
                                                            .translate('no_internet'),
                                                        style: TextStyle(
                                                          fontSize: 20.0,
                                                        )),
                                                  )));
                                        } else {
                                          sendLostRequest();
                                          showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (_) => new AlertDialog(
                                                    title: Semantics(
                                                      label: AppLocalizations.of(
                                                          context)
                                                          .translate(
                                                          'messagesent_confirmation_title'),
                                                      child: Text(AppLocalizations.of(
                                                              context)
                                                          .translate(
                                                              'messagesent_confirmation_title')),
                                                    ),
                                                    content: Text(AppLocalizations.of(
                                                            context)
                                                        .translate(
                                                            'messagesent_confirmation_content')),
                                                    actions: <Widget>[
                                                      ElevatedButton(
                                                        child: Semantics(
                                                          label: AppLocalizations
                                                  .of(context)
                                                  .translate('close_btn'),
                                                          child: Text(AppLocalizations
                                                                  .of(context)
                                                              .translate('close_btn')),
                                                        ),
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
                            ),
                            Divider(
                              thickness: 5.0,
                              color: Colors.blueGrey,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Column(
                                children: [
                                  Semantics(
                                    label: AppLocalizations.of(context)
                                        .translate('location_here'),
                                    child: Text(
                                      AppLocalizations.of(context)
                                          .translate('location_here'),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
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
                            Container(
                              padding: EdgeInsets.all(10.0),
                              child: Semantics(
                                label: AppLocalizations.of(context)
                                    .translate('an_logo_img'),
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
        ),
    );
  }

  _launchURL() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String bookerLat = prefs.getString("bookerLat");
    String bookerLng = prefs.getString("bookerLng");
    // Geolocator package
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

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

