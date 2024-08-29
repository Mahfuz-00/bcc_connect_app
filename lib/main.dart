import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'UI/Bloc/auth_cubit.dart';
import 'UI/Bloc/email_cubit.dart';
import 'UI/Pages/Splashscreen UI/splashscreenUI.dart';

/// The entry point of the application.
///
/// This function initializes the app and sets up the necessary configurations before running the app.
/// It starts by running the `MyApp` widget.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await checkAndClearCache();
  runApp(MyApp());
}

/// Checks the app version and clears the cache if the app has been updated.
Future<void> checkAndClearCache() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String currentVersion = packageInfo.version;
  String? storedVersion = prefs.getString('app_version');

  if (storedVersion == null || storedVersion != currentVersion) {
    await DefaultCacheManager().emptyCache();
    await prefs.setString('app_version', currentVersion);
  }
}

/// The root widget of the application.
///
/// This widget sets up the application's root widget and the global theme.
/// It also initializes the `AuthCubit` using the `BlocProvider`, which provides authentication state
/// management across the app. The status bar color is set to a custom color.
///
/// The `MaterialApp` is configured with a title, a custom theme, and a home widget, which is the
/// `SplashScreen` widget.
///
/// This widget is responsible for configuring the app's appearance and initializing its core functionality.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    // Set the status bar color
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color.fromRGBO(25, 192, 122, 1),
    ));

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => EmailCubit()), // Provide EmailCubit
      ],
      // Provide the AuthCubit for managing authentication state
      child: MaterialApp(
        debugShowCheckedModeBanner: false, // Hide the debug banner
        title: 'BCC Connect Network', // Application title
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.grey[100],
          // Background color of scaffold
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromRGBO(25, 192, 122, 1)),
          // Color scheme with seed color
          useMaterial3: true, // Enable Material Design 3
        ),
        home: const SplashScreen(), // Set the initial route to SplashScreen
      ),
    );
  }
}
