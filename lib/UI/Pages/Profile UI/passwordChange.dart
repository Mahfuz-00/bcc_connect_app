import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Data/Data Sources/API Service (User Info Update)/apiServicePasswordUpdate.dart';
import '../../Bloc/auth_cubit.dart';
import 'package:flutter/material.dart';

/// The [PasswordChangeUI] class represents a user interface for updating the password.
///
/// This class handles the following:
/// - [TextEditingController] variables to manage user input for current password, new password, and confirm password fields.
/// - [bool] variables to manage the obscurity state (whether the password is visible or hidden) for the password fields.
/// - [_isButtonClicked] [bool] to track if the update button has been clicked, which is used to show a loading indicator.
/// - Methods to get the appropriate icons for visibility toggling: [_getIconCurrentPassword], [_getIconPassword],
/// and [_getIconConfirmPassword].
/// - [initState] method initializes the text controllers when the state is created.
/// - [build] method constructs the user interface, including [TextFormField] widgets for password
/// inputs and an [ElevatedButton] for submitting the update.
/// - [checkConfirmPassword] method checks if the new password and confirm password fields match,
/// displaying an error message if they do not.
/// - [_updatePassword] method handles the password update process by interacting with the [PasswordUpdateAPIService] and
/// displaying appropriate feedback to the user.
class PasswordChangeUI extends StatefulWidget {
  @override
  State<PasswordChangeUI> createState() => _PasswordChangeUIState();
}

class _PasswordChangeUIState extends State<PasswordChangeUI> {
  late TextEditingController _currentPasswordController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  bool _isObscuredCurrentPassword = true;
  bool _isObscuredPassword = true;
  bool _isObscuredConfirmPassword = true;
  bool _isButtonClicked = false;

  /// Returns the icon for the current password field based on its obscurity state.
  IconData _getIconCurrentPassword() {
    return _isObscuredCurrentPassword ? Icons.visibility_off : Icons.visibility;
  }

  /// Returns the icon for the new password field based on its obscurity state.
  IconData _getIconPassword() {
    return _isObscuredPassword ? Icons.visibility_off : Icons.visibility;
  }

  /// Returns the icon for the confirm password field based on its obscurity state.
  IconData _getIconConfirmPassword() {
    return _isObscuredConfirmPassword ? Icons.visibility_off : Icons.visibility;
  }

  @override
  void initState() {
    super.initState();
    _currentPasswordController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(25, 192, 122, 1),
        title: Text(
          'Change Password',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'default',
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                'Current Password',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'default',
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                keyboardType: TextInputType.text,
                validator: (input) => input!.length < 8
                    ? "Password should be more than 7 characters"
                    : null,
                controller: _currentPasswordController,
                obscureText: _isObscuredCurrentPassword,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter current password',
                  hintStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'default',
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(_getIconCurrentPassword()),
                    onPressed: () {
                      setState(() {
                        _isObscuredCurrentPassword =
                            !_isObscuredCurrentPassword;
                        _currentPasswordController.text =
                            _currentPasswordController.text;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'New Password',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'default',
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                keyboardType: TextInputType.text,
                validator: (input) => input!.length < 8
                    ? "Password should be more than 7 characters"
                    : null,
                controller: _passwordController,
                obscureText: _isObscuredPassword,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter new password',
                  hintStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'default',
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(_getIconPassword()),
                    onPressed: () {
                      setState(() {
                        _isObscuredPassword = !_isObscuredPassword;
                        _passwordController.text = _passwordController.text;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Confirm Password',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'default',
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                keyboardType: TextInputType.text,
                validator: (input) => input!.length < 8
                    ? "Password should be more than 7 characters"
                    : null,
                controller: _confirmPasswordController,
                obscureText: _isObscuredConfirmPassword,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Confirm new password',
                  hintStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'default',
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(_getIconConfirmPassword()),
                    onPressed: () {
                      setState(() {
                        _isObscuredConfirmPassword =
                            !_isObscuredConfirmPassword;
                        _confirmPasswordController.text =
                            _confirmPasswordController.text;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 40),
              Center(
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(25, 192, 122, 1),
                      fixedSize: Size(MediaQuery.of(context).size.width * 0.8,
                          MediaQuery.of(context).size.height * 0.08),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      _updatePassword();
                    },
                    child: _isButtonClicked
                        ? CircularProgressIndicator()
                        : Text(
                            'Update',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'default',
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Checks if the new password and confirm password fields match.
  /// Displays a SnackBar if they do not match.
  ///
  /// Returns `true` if the passwords match, otherwise `false`.
  bool checkConfirmPassword() {
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _isButtonClicked =
            false;
      });
      const snackBar = SnackBar(
        content: Text('New Password and Confirm Password are not Matched!'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    } else {
      return true;
    }
  }

  /// Initiates the password update process by calling the API.
  ///
  /// Updates the state to show a circular progress indicator while the password is being updated.
  /// Displays a SnackBar indicating success or failure based on the API response.
  void _updatePassword() async {
    setState(() {
      _isButtonClicked =
          true;
    });
    if (checkConfirmPassword()) {
      String currentPassword = _currentPasswordController.text;
      String newPassword = _passwordController.text;
      String confirmPassword = _confirmPasswordController.text;

      try {
        final authCubit = context.read<AuthCubit>();
        final token = (authCubit.state as AuthAuthenticated).token;
        PasswordUpdateAPIService apiService =
            await PasswordUpdateAPIService.create(token);
        final response = await apiService
            .updatePassword(
          currentPassword: currentPassword,
          newPassword: newPassword,
          passwordConfirmation: confirmPassword,
        )
            .then((response) {
          setState(() {
            _isButtonClicked =
                false;
          });
          print("Submitted");
          print(response);
          if (response != null && response == "Password Update Successfully") {
            Navigator.pop(context);
            const snackBar = SnackBar(
              content: Text('Password Changed!'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
          if (response != null &&
              response == "The current password do not match.") {
            const snackBar = SnackBar(
              content: Text('Current Password is not Matched!'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        }).catchError((error) {
          print(error);
          const snackBar = SnackBar(
            content: Text('Password Change failed!'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
      } catch (e) {
        print('Error updating password: $e');
      }
    }
  }
}
