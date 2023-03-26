import 'package:dinder/src/auth/screens/auth_page.dart';
import 'package:dinder/src/auth/screens/login.dart';
import 'package:dinder/src/auth/screens/sign_up.dart';
import 'package:dinder/src/group_selection/screens/group_selection_home.dart';
import 'package:dinder/src/settings/settings_controller.dart';
import 'package:dinder/src/user/models/current_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

/// The Widget that configures your application.
class Dinder extends StatelessWidget {
  final Logger _logger = Logger();

  Dinder({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    _logger.i("Starting app");
    // Glue the SettingsController to the MaterialApp.
    //
    // The AnimatedBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CurrentUser>(
          create: (_) => CurrentUser(),
        )
      ],
      child: AnimatedBuilder(
        animation: settingsController,
        builder: (BuildContext context, Widget? child) {
          return MaterialApp(
            initialRoute: '/',
            routes: {
              '/': (context) => const AuthPage(),
              '/auth/login': (context) => const Login(),
              '/auth/signup': (context) => const SignUpScreen(),
              '/group/group_selection': (context) => GroupSelectionHome(),
              // '/group/edit_group': (context) => EditGroupPage(),
            },

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
            theme: ThemeData(),
            darkTheme: ThemeData.dark(),
            themeMode: settingsController.themeMode,

            // Define a function to handle named routes in order to support
            // Flutter web url navigation and deep linking.
            onGenerateRoute: (RouteSettings routeSettings) {
              return MaterialPageRoute<void>(
                settings: routeSettings,
                builder: (BuildContext context) {
                  return const AuthPage();
                },
              );
            },
          );
        },
      ),
    );
  }
}
