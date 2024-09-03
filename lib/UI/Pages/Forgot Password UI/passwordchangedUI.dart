import 'package:flutter/material.dart';
import '../../../Core/Connection Checker/internetconnectioncheck.dart';
import '../../Bloc/email_cubit.dart';
import '../Login UI/loginUI.dart';

//// A screen displayed after a user's password has been successfully changed.
///
/// This screen informs the user that their password change was successful
/// and provides a button to navigate back to the login screen. The screen
/// includes a success image, a title, and a message indicating the
/// password change status.
///
/// ## Key Variables:
/// - [screenWidth]: The width of the current screen, used to set the button size.
/// - [screenHeight]: The height of the current screen (not directly used in this implementation).
///
/// ## Actions:
/// - Navigate back to the login screen when the "Back to Login" button is pressed.
class PasswordChangedUI extends StatefulWidget {
  const PasswordChangedUI({super.key});

  @override
  State<PasswordChangedUI> createState() => _PasswordChangedUIState();
}

class _PasswordChangedUIState extends State<PasswordChangedUI> {

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return InternetConnectionChecker(
      child: PopScope(
        canPop: false,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            color: Colors.grey[100],
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Image(
                      image: AssetImage('Assets/Images/Success-Mark.png'),
                      height: 150,
                      width: 150,
                      alignment: Alignment.center,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Password Changed!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'default',
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Your password has been changed successfully',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromRGBO(143, 150, 158, 1),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'default',
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final emailCubit = EmailCubit();
                      emailCubit.clearEmail();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginUI()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(25, 192, 122, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      fixedSize: Size(screenWidth * 0.9, 70),
                    ),
                    child: Text(
                      'Back to Login',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'default',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
