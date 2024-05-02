import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Connection Checker/internetconnectioncheck.dart';
import 'Login UI/loginUI.dart';
import 'Splashscreen UI/splashscreenUI.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color.fromRGBO(25, 192, 122, 1), // Change the status bar color here
    ));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BCC Connect',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey[100],
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromRGBO(25, 192, 122, 1)),
        useMaterial3: true,
      ),
      home: InternetCheckWrapper(
        child: SplashScreen(),
      ), routes: {
      '/login': (context) => Login(),
    },
    );
  }
}

