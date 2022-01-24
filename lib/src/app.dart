import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logger/logger.dart';
import 'package:ticketglass_mobile/auth_wrapper.dart';
import 'package:ticketglass_mobile/src/organizer/event_details.dart';

import 'events_pages/order_details.dart';
import 'events_pages/events_list_view.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';
Logger log = Logger();
Map<int, Color> color = {
  50: Color.fromRGBO(248, 250, 252, 1),
  100: Color.fromRGBO(241, 245, 249, 1),
  200: Color.fromRGBO(226, 232, 240, 1),
  300: Color.fromRGBO(203, 213, 225, 1),
  400: Color.fromRGBO(148, 163, 184, 1),
  500: Color.fromRGBO(100, 116, 139, 1),
  600: Color.fromRGBO(71, 85, 105, 1),
  700: Color.fromRGBO(51, 65, 85, 1),
  800: Color.fromRGBO(30, 41, 59, 1),
  900: Color.fromRGBO(15, 23, 42, 1),
};

MaterialColor colorCustom = MaterialColor(0xFF37474f, color);

/// The Widget that configures your application.
///
class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    required this.settingsController,
  }) : super(key: key);

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The AnimatedBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return AnimatedBuilder(
      animation: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          // Providing a restorationScopeId allows the Navigator built by the
          // MaterialApp to restore the navigation stack when a user leaves and
          // returns to the app after it has been killed while running in the
          // background.
          restorationScopeId: 'app',

          // Provide the generated AppLocalizations to the MaterialApp. This
          // allows descendant Widgets to display the correct translations
          // depending on the user's locale.
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ],

          // Use AppLocalizations to configure the correct application title
          // depending on the user's locale.
          //
          // The appTitle is defined in .arb files found in the localization
          // directory.
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,

          // Define a light and dark color theme. Then, read the user's
          // preferred ThemeMode (light, dark, or system default) from the
          // SettingsController to display the correct theme.
          theme: ThemeData(
            primarySwatch: colorCustom,
            // brightness: settingsController.themeMode == ThemeMode.system
            //     ? Theme.of(context)!.brightness
            //     : settingsController.themeMode,
          ),
          darkTheme: ThemeData.dark(),
          themeMode: ThemeMode.light,
          // settingsController.themeMode,

          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          onGenerateRoute: (RouteSettings routeSettings) {
            log.d(routeSettings.arguments);
            log.d(routeSettings.name);
            // extract args
            // if (routeSettings.arguments is Map<String, dynamic>) {
            //   Map<String, dynamic> args = routeSettings.arguments as Map<String, dynamic>;
            //   log.d(args);
            // }
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case SettingsView.routeName: 
                    return SettingsView(controller: settingsController);
                  case EventDetails.routeName:
                    return EventDetails();

                  case SampleItemDetailsView.routeName:
                    return SampleItemDetailsView();
                    
                  case SampleItemListView.routeName:
                  default:
                    return Wrapper();
                }
              },
            );
          },
        );
      },
    );
  }
}
