import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:safein/src/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'src/app_localizations.dart';
import 'ask_help.dart';
import 'package:flutter/material.dart';
import 'main.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // remove the debug banner from top right of the screen
      debugShowCheckedModeBanner: false,
      color: Theme.of(context).primaryColor,
      theme: ThemeData(fontFamily: 'SukhumvitSet'),
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
      home: new Scaffold(
        backgroundColor: Color(0xFF15294e),
        appBar: new AppBar(
          backgroundColor: Color(0xFFced1D1),
          leading: null,
          title: new Text(
            AppLocalizations.of(context).translate('safein_title'),
            style: TextStyle(color: Color(0xFF15294e)),
          ),
          // center the text horizontaly
          centerTitle: true,

        ),
        body: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.0),
            color: Color(0xFFff6e41),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 40,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.0),
                  color: Color(0xFF15294e),
                ),
                // padding: const EdgeInsets.all(6.5),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Text(
                        AppLocalizations.of(context).translate('usage_notice'),
                        style: TextStyle(
                          color:Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        AppLocalizations.of(context).translate('requires'),
                        style: TextStyle(
                          color:Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () async {
                            // Validate returns true if the form is valid, or false
                            // otherwise.
                            // if (_formKey.currentState.validate()) {
                            //   SharedPreferences prefs =
                            //       await SharedPreferences.getInstance();
                            //   prefs.setString('userPhone', userPhoneController.text);
                            //   String userphone = prefs.getString('userPhone');
                            //   // If the form is valid, display a Snackbar.
                            //   Scaffold.of(context).showSnackBar(
                            //       SnackBar(content: Text('Mobile number: $userphone')));
                            //   clearText();
                            //   // sleep(const Duration(seconds: 2));
                            //   await Future.delayed(const Duration(seconds: 2));
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            String userPhone = prefs.getString('userPhone');
                            if (userPhone != null) {
                              Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => new AskHelp()),
                                // new AskHelp()),
                              );
                            } else {
                              Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => new Verification()),
                                // new AskHelp()),
                              );
                            }
                            // }
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Color(0xFFff6e41)),
                          child: Text(
                              AppLocalizations.of(context).translate('nextbtn'))),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ); //
  }
}
