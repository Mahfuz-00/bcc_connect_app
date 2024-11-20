import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../Data/Data Sources/API Service (Profile)/apiserviceprofile.dart';
import '../../../Data/Models/profilemodel.dart';
import '../../Bloc/auth_cubit.dart';
import '../BCC Dashboard/bccDashboard.dart';
import '../ISP Dashboard/ispDashboard.dart';
import '../Login UI/loginUI.dart';
import '../NTTN Dashboard/nttnDashboard.dart';
import '../Sign Up UI/signupUI.dart';

/// [SplashScreenUI] is a StatefulWidget that represents the initial splash screen
/// of the application. It displays the app logo, title, and buttons for login and registration.
/// The screen incorporates animations for smooth transitions during the splash process.
///
/// Variables:
/// - [animationController]: Controls the animation timing and state.
/// - [FadeAnimation]: Animation for fading effects.
/// - [SlideAnimation]: Animation for slide transitions.
/// - [animatedpadding]: Animation for padding effects.
/// - [_isLoading]: A boolean that indicates the loading state.
///
/// Actions:
/// - [initState]: Initializes the animation controller and starts animations.
/// - [_checkInternetConnection]: Checks the internet connectivity status.
/// - [dispose]: Disposes of the animation controller to free resources.
/// - [build]: Builds the widget tree, including animations and layout.
class SplashScreenUI extends StatefulWidget {
  const SplashScreenUI({super.key});

  @override
  State<SplashScreenUI> createState() => _SplashScreenUIState();
}

class _SplashScreenUIState extends State<SplashScreenUI>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> FadeAnimation;
  late Animation<Offset> SlideAnimation;
  late Animation<Offset> animatedpadding;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));

    SlideAnimation = Tween(begin: const Offset(0, 3), end: const Offset(0, 0))
        .animate(CurvedAnimation(
            parent: animationController, curve: Curves.easeInOutCirc));
    FadeAnimation = Tween(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut));
    animatedpadding = Tween(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
            CurvedAnimation(parent: animationController, curve: Curves.easeIn));

    _checkAuthAndNavigate(context);

    _checkInternetConnection();
  }

  Future<void> _checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      setState(() {
        _isLoading = true;
      });
    }
  }

  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

// In the SplashScreen widget:
  Future<void> _checkAuthAndNavigate(BuildContext context) async {
    final authCubit = context.read<AuthCubit>();
    print('Auth Invoked');
    try {
      // Retrieve the token and user type from secure storage
      final token = await _secureStorage.read(key: 'auth_token');
      final userType = await _secureStorage.read(key: 'user_type');

      print(token);
      print(userType);

      // If token or userType is missing, handle this case appropriately
      if (token == null ||
          token.isEmpty ||
          userType == null ||
          userType.isEmpty) {
        print('No token or user type found, staying on current screen');
        animationController.forward();
        // You can either show a message, keep the user on the page, or handle differently
        return; // Stay on the current screen without navigating
      }

      // If token and userType exist, check if the state is AuthInitial or AuthAuthenticated
      if (authCubit.state is AuthInitial) {
        // Proceed with fetching the user profile
        await _fetchUserProfile(token, userType, context);
      } else if (authCubit.state is AuthAuthenticated) {
        // If already authenticated, navigate based on the user type
        final currentState = authCubit.state as AuthAuthenticated;
        final userType = currentState.usertype;
        final userProfile = currentState.userProfile;
        print('Usertype from State: ' + userType);

        print(
            'User Profile from State: ${userProfile.name}, ${userProfile.organization}, ${userProfile.Id}, ${userProfile.photo}');
        await _fetchUserProfile(token, userType, context);
        print(
            'User Profile from State: ${userProfile.name}, ${userProfile.organization}, ${userProfile.Id}, ${userProfile.photo}');
        _navigateToAppropriateDashboard(context, userType);
      }
    } catch (e) {
      print('Error while checking authentication: $e');
      _navigateToLogin(context);
    }
  }

  Future<void> _fetchUserProfile(
      String token, String userType, BuildContext context) async {
    try {
      // Fetch user profile from the API
      final apiService = ProfileAPIService();
      final profile = await apiService.fetchUserProfile(token);

      // If profile is fetched successfully, create the UserProfile and login
      final userProfile = UserProfile.fromJson(profile);

      print('Profile Loaded: $userProfile');

      // Log the user in via the AuthCubit
      context.read<AuthCubit>().login(userProfile, token, userType);
      print('User successfully logged in with type: $userType');

      // Navigate to the appropriate dashboard after login
      _navigateToAppropriateDashboard(context, userType);
    } catch (e) {
      print('Error fetching user profile: $e');
      _navigateToLogin(context);
    }
  }

  void _navigateToLogin(BuildContext context) {
    showTopToast(context, 'Session expired. Please log in again.');
    print('Navigating to login');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginUI()),
    );
  }

  void _navigateToAppropriateDashboard(BuildContext context, String userType) {
    print('Navigating to appropriate dashboard based on user type: $userType');
    if (userType == 'isp_staff') {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => ISPDashboardUI(shouldRefresh: true)),
        (route) => false,
      );
    } else if (userType == 'bcc_staff') {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => BCCDashboardUI(shouldRefresh: true)),
        (route) => false,
      );
    } else if (userType == 'nttn_sbl_staff' || userType == 'nttn_adsl_staff') {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => NTTNDashboardUI(shouldRefresh: true)),
        (route) => false,
      );
    } else {
      String errorMessage = 'Invalid User! Please enter a valid email address.';
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showTopToast(context, errorMessage);
      });
    }
  }

  void showTopToast(BuildContext context, String message) {
    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              message,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );

    overlayState?.insert(overlayEntry);

    Future.delayed(Duration(seconds: 3)).then((_) {
      overlayEntry.remove();
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(246, 246, 246, 255),
            Color.fromRGBO(246, 246, 246, 255)
          ],
        )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display the logo image
            const Image(
              image: AssetImage(
                'Assets/Images/BCC-Logo.png',
              ),
              width: 200,
              height: 200,
            ),
            const SizedBox(
              height: 20,
            ),
            // Display the title text with animation
            SlideTransition(
              position: animatedpadding,
              child: const Padding(
                padding: EdgeInsets.all(30),
                child: Text(
                  'BCC Connect Network',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'default',
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            // Display buttons with animations
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                FadeTransition(
                  opacity: FadeAnimation,
                  child: const Image(
                    image: AssetImage('Assets/Images/Powered by TNS.png'),
                    height: 100,
                    width: 150,
                    alignment: Alignment.bottomCenter,
                  ),
                ),
                SlideTransition(
                  position: SlideAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Login button
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginUI(),
                                ));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(25, 192, 122, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            fixedSize: Size(screenWidth * 0.9, 70),
                          ),
                          child: const Text('Login',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'default',
                              ))),
                      const SizedBox(
                        height: 20,
                      ),
                      // Register button
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignupUI()));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(
                                  color: Colors.black, width: 2),
                            ),
                            fixedSize: Size(screenWidth * 0.9, 70),
                          ),
                          child: const Text('Register',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontFamily: 'default',
                              )))
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
