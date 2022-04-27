// @dart = 2.8
import 'package:car_wash/navigation/routes.dart';
import 'package:car_wash/provider/wash_provider.dart';
import 'package:car_wash/provider/info_window_model.dart';
import 'package:car_wash/provider/loading_provider.dart';
import 'package:car_wash/screens/sign_in/sign_in_screen.dart';
import 'package:car_wash/screens/splash/splash_screen.dart';
import 'package:car_wash/serviceLocator.dart';
import 'package:car_wash/theme.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  serviceLocatorSetup();
  await serviceLocator.allReady();
  runApp( MyApp(),);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => WashProvider()),
        ],
        child: MaterialApp(
          title: 'Drive',
          debugShowCheckedModeBanner: false,
          theme: theme(),
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('en', 'US'),
            Locale('ru', 'RU'),
          ],
          initialRoute: SignInScreen.routeName,
          routes: routes,
        ),
      );
}
