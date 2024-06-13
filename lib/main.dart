import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:rename_app/rename_app.dart';

import 'UI/Bloc/user_bloc.dart';
import 'UI/Pages/Splashscreen UI/splashscreenUI.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color.fromRGBO(25, 192, 122, 1), // Change the status bar color here
    ));

    return BlocProvider(
      create: (_) => UserDataBloc(), // Initialize UserDataBloc
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BCC Connect Network',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.grey[100],
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromRGBO(25, 192, 122, 1)),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}

