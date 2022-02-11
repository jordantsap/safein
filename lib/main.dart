import 'dart:convert';
// import 'dart:io';
import 'package:after_layout/after_layout.dart';
import 'package:app_settings/app_settings.dart';
import 'package:connectivity/connectivity.dart';
import 'package:country_code_picker/country_localizations.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart' show Geolocator, LocationAccuracy, Position;
// import 'package:google_fonts/google_fonts.dart';
import 'src/auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'ask_help.dart';
import 'src/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:country_code_picker/country_code_picker.dart' show CountryCode, CountryCodePicker;

void main() {
  runApp(SafeInApp());
}

class SafeInApp extends StatelessWidget {

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
        CountryLocalizations.delegate,
      ],
      // Returns a locale which will be used by the app
      localeResolutionCallback: (locale, supportedLocales) {
        // Check if the current device locale is supported
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return locale;
          }
        }
        // If the locale of the device is not supported, use the first one
        // from the list (English, in this case).
        return supportedLocales.first;
      },
      home: Verification(),
    );
  }
}

class Verification extends StatefulWidget {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  @override
  _VerificationState createState() => _VerificationState();
}

class _VerificationState extends State<Verification>
    with AfterLayoutMixin<Verification> {

  @override
  void initState() {
    super.initState();
    checkLocation();
    codeField = FocusNode();
    phoneField = FocusNode();
  }

  //  connectivity check
  void askConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      print("Internet method = None from Verification screen");
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
                    child: Text(
                        AppLocalizations.of(context).translate('close_btn')),
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


  FocusNode codeField;
  FocusNode phoneField;

  // Be sure to cancel subscription after you are done
  @override
  dispose() {
    super.dispose();
    // var subscription;
    // subscription.cancel();
    codeField.dispose();
    phoneField.dispose();
  }

  final userPhoneController = TextEditingController();
  final verificationCodeController = TextEditingController();

  String userPhoneField;
  String verificationCodeField;
  // use the TextEditingController() to clear the text field when needed
  // i will clear it after onPressed() function assigned to the button
  void clearText() {
    userPhoneController.clear();
    verificationCodeController.clear();
  }

  // form key variable
  final _formKey = GlobalKey<FormState>();
  // prevent button clicked more than once
  var isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF15294e),
      appBar: new AppBar(
        backgroundColor: Color(0xFFCED1D1),
        centerTitle: true,
        leading: null,
        title: new Text(
          AppLocalizations.of(context).translate('safein_title'),
          maxLines: 2,
          style: TextStyle(color:Color(0xFF15294e)),
        ),
        // center the text horizontaly
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.0),
            color: Color(0xFFff6e41),
          ),
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.0),
                color: Color(0xFF15294e),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 70,
                ),
                child: Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)
                                .translate('verification_header'),
                            style: TextStyle(
                              color:Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextFormField(
                            style: TextStyle(color:Colors.white),
                            autofocus: true,
                            focusNode: codeField,
                            controller: verificationCodeController,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (term) {
                              codeField.unfocus();
                              FocusScope.of(context).requestFocus(phoneField);
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return AppLocalizations.of(context)
                                    .translate('notempty_val');
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),

                              ),
                              labelStyle: TextStyle(color:Colors.white),
                              labelText: AppLocalizations.of(context)
                                  .translate('code_label'),
                              hintText: AppLocalizations.of(context)
                                  .translate('code_hint'),
                              hintStyle: TextStyle(color:Colors.white),
                            ),

                            // onSaved method is called when formKey.currentState.save
                            // is called during form submission
                            onSaved: (String value) {
                              // assign the value of the text field to a variable
                              verificationCodeField = value;
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                width: 1,
                                // color: Colors.white,
                                style: BorderStyle.solid,
                              ),
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  // topRight: Radius.circular(40.0),
                                  topLeft: Radius.circular(40.0),
                                  bottomLeft: Radius.circular(40.0),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Semantics(
                              label: AppLocalizations.of(context).translate('ask_help_title'),
                                    child: CountryCodePicker(
                                      onChanged: _onCountryChange,
                                      initialSelection: 'GR',
                                      onInit: _onCountryChange,
                                      favorite: ['RU', 'BG', 'AL', 'RO'],
                                    ),
                                  ),
                                  Flexible(
                                    child: TextFormField(
                                      focusNode: phoneField,
                                      controller: userPhoneController,
                                      textInputAction: TextInputAction.done,

                                      onFieldSubmitted: (_) =>
                                          FocusScope.of(context).requestFocus(),
                                      // onFieldSubmitted: (term){
                                      //   phoneField.unfocus();
                                      //   FocusScope.of(context).requestFocus();
                                      // },
                                      //handle userPhone field
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return AppLocalizations.of(context)
                                              .translate('notempty_val');
                                        }
                                        if (value.length != 10) {
                                          int len =  value.length;
                                          return AppLocalizations.of(context)
                                                .translate('digit_val')+ "$len";
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(

                                        labelText: AppLocalizations.of(context)
                                            .translate('phone_label'),
                                        hintText: AppLocalizations.of(context)
                                            .translate('phone_hint'),

                                        hintStyle: TextStyle(color: Colors.black),
                                      ),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly
                                      ], // Only numbers can be entered
                                      // onSaved method is called when formKey.currentState.save
                                      // is called during form submission
                                      onSaved: (String value) {
                                        // assign the value of the text field to a variable
                                        userPhoneField = value;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top:8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Colors.white,
                                  style: BorderStyle.solid,
                                ),
                                // color: Colors.red,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(0.0),
                                  bottomRight: Radius.circular(80.0),
                                  topLeft: Radius.circular(80.0),
                                  bottomLeft: Radius.circular(00.0),
                                ),
                              ),
                              child: SizedBox(
                                width: double.infinity,
                                child: Builder(builder: (context) {
                                  return ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(primary: Color(0xFF15294e)),
                                    icon: Icon(Icons.add_location),
                                    label: InkWell(
                                      child: Text(
                                          AppLocalizations.of(context)
                                              .translate('submit'),
                                          style:
                                              TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                    ),
                                    onPressed: isPressed
                                        ? null
                                        : () async {
                                      print("Button pressed in main.dart");
                                            setState(() => isPressed = true);
                                            var connectivityResult =
                                                await (Connectivity()
                                                    .checkConnectivity());
                                            if (connectivityResult ==
                                                ConnectivityResult.none) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      backgroundColor:
                                                          Theme.of(context)
                                                              .primaryColor,
                                                      duration: Duration(seconds: 5),
                                                      content: Text(
                                                          AppLocalizations.of(context)
                                                              .translate(
                                                                  'no_internet'),
                                                          style: TextStyle(
                                                            fontSize: 20.0,
                                                          ))));
                                            } else {
                                              // Validate returns true if the form is valid, otherwise false.
                                              if (_formKey.currentState.validate()) {
                                                // askConnectivity();
                                                // checkPermissions();
                                                setState(() => isPressed = false);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        backgroundColor:
                                                            Theme.of(context)
                                                                .primaryColor,
                                                        duration:
                                                            Duration(seconds: 7),
                                                        content: Text(
                                                            AppLocalizations.of(
                                                                    context)
                                                                .translate('sending'),
                                                            style: TextStyle(
                                                              fontSize: 20.0,
                                                            ))));


                                                // now save the state of the form using the form key
                                                // .save() uses the onSaved: method that we used earlier
                                                // in each field and saves it's value
                                                _formKey.currentState.save();

                                                // define variables
                                                final companyCode =
                                                    verificationCodeController.text;

                                            final response = await http.get(Uri.parse(
                                                "https://appserver.anathesis.eu/api/companies/" + "$companyCode"));

                                                if (response.statusCode == 200 &&
                                                    response.body.isNotEmpty) {
                                                  print(
                                                      "++++++++++++++++++++++++++\n"
                                                      "response.statusCode == 200\n"
                                                      "+++++++++++++++++++++++++++");
                                                  setState(() => isPressed = true);
                                                  showDialog(
                                                      context: context,
                                                      barrierDismissible: false,
                                                      builder: (_) => new AlertDialog(
                                                            title: Text(AppLocalizations
                                                                    .of(context)
                                                                .translate(
                                                                    'confirmation_title')),
                                                            content: Text(
                                                                AppLocalizations.of(
                                                                        context)
                                                                    .translate(
                                                                        'confirmation_content')),
                                                            actions: <Widget>[
                                                              ElevatedButton(
                                                                child: Text(
                                                                    AppLocalizations.of(
                                                                            context)
                                                                        .translate(
                                                                            'close_btn')),
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context,
                                                                          rootNavigator:
                                                                              true)
                                                                      .pop();
                                                                },
                                                              )
                                                            ],
                                                          ));

                                                  // print(
                                                  //     'code 200 and not empty true so...');
                                                  // print(response.statusCode);
                                                  // Did return a 200 OK response, so map data
                                                  var data =
                                                      json.decode(response.body);

                                                  // print(data['id']); //[code]
                                                  // print("Laravel data :----------------------"); //[data]
                                                  // print(data); //[code]
                                                  final bookerCode = data['id'];
                                                  final bookerName = data['name'];
                                                  final bookerEmail = data['email'];
                                                  // print(bookerEmail);
                                                  final bookerPhone = data['phone'];
                                                  // print(bookerPhone);
                                                  final bookerLat = data['latitude'];
                                                  // print(bookerLat);
                                                  final bookerLng = data['longitude'];
                                                  // print(bookerLng);

                                                  SharedPreferences prefs =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  prefs.setInt(
                                                      'bookerCode', bookerCode);
                                                  prefs.setString(
                                                      'bookerName', bookerName);
                                                  prefs.setString(
                                                      'bookerEmail', bookerEmail);
                                                  prefs.setString(
                                                      'bookerPhone', bookerPhone);
                                                  prefs.setString('userPhone',
                                                      userPhoneController.text);
                                                  prefs.setString(
                                                      'bookerLat', bookerLat);
                                                  prefs.setString(
                                                      'bookerLng', bookerLng);

                                                  print(
                                                      "bookerName received by API: $bookerName");
                                                  // print(prefs.getInt('bookerCode'));

                                                  newCustomer();

                                                  sendMainApi();

                                                  clearText();

                                                  Navigator.push(
                                                    context,
                                                    new MaterialPageRoute(
                                                        builder: (context) =>
                                                            new AskHelp()),
                                                  );
                                                } else {
                                                  // print(response.statusCode);
                                                  // print(response);
                                                  // print(
                                                  //     'Is empty response no authentication connection');
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          backgroundColor:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          duration:
                                                              Duration(seconds: 5),
                                                          content: Text(
                                                              AppLocalizations.of(
                                                                      context)
                                                                  .translate(
                                                                      'no_auth'),
                                                              style: TextStyle(
                                                                fontSize: 20.0,
                                                              ))));
                                                } // if end

                                              } // if validate close
                                            }
                                            setState(() => isPressed = false);
                                          },
                                    onLongPress:
                                        null, // Set one as NOT null is enough to enable the button
                                  );
                                }),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      // decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.only(
                      //     bottomLeft: const Radius.circular(15.0),
                      //     bottomRight: const Radius.circular(15.0),
                      //   ),
                      // ),
                      child: Text(
                        AppLocalizations.of(context).translate('usage_notice'),
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                              topRight: const Radius.circular(15.0),
                          bottomLeft: const Radius.circular(15.0),
                              bottomRight: const Radius.circular(85.0),
                            ),
                        // border: Border.all(
                        //   color: Colors.white,
                        // ),
                      ),
                      child: Text(
                        AppLocalizations.of(context).translate('requires'),
                        style: TextStyle(
                          fontSize: 20.0,
                          // decoration: TextDecoration.underline,
                          color: Colors.white,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void _onCountryChange(CountryCode countryCode) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('countryCode', countryCode.dialCode);
  prefs.getString('countryCode');
  // print(prefs.getString('countryCode'));
}
