import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:footer/footer.dart';

import '../API Models(Login and Sign Up)/registermodels.dart';
import '../API Service(Login and Sign Up)/apiserviceregister.dart';
import '../Login UI/loginUI.dart';
import 'dropdownfield.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool _isObscuredPassword = true;
  bool _isObscuredConfirmPassword = true;
  late RegisterRequestmodel _registerRequest;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  var globalKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> globalfromkey = GlobalKey<FormState>();

  List<DropdownMenuItem<String>> types = [
    DropdownMenuItem(child: Text("Nationwide"), value: "Nationwide"),
    DropdownMenuItem(child: Text("Divisional"), value: "Divisional"),
    DropdownMenuItem(child: Text("District"), value: "District"),
    DropdownMenuItem(child: Text("Upazila"), value: "Upazila"),
    DropdownMenuItem(child: Text("Others"), value: "Others"),
  ];

  IconData _getIconPassword() {
    return _isObscuredPassword ? Icons.visibility_off : Icons.visibility;
  }

  IconData _getIconConfirmPassword() {
    return _isObscuredConfirmPassword ? Icons.visibility_off : Icons.visibility;
  }

  @override
  void initState() {
    super.initState();
    _registerRequest = RegisterRequestmodel(Email: '', Password: '');
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            color: Colors.grey[100],
            child: Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children : [
                        const Text(
                          'Hello! Register to get started!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromRGBO(25, 192, 122, 1),
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'default',
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Sign in to see how we manage',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromRGBO(143, 150, 158, 1),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'default',
                          ),
                        ),
                        const SizedBox(height: 50),
                        Form(
                          key: globalfromkey,
                          child: Column(
                            children: [
                              Container(
                                width: 350,
                                height: 70,
                                child: TextFormField(
                                  style: const TextStyle(
                                    color: Color.fromRGBO(143, 150, 158, 1),
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'default',
                                  ),
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(),
                                    labelText: 'Full Name',
                                    labelStyle: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      fontFamily: 'default',
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                width: 350,
                                height: 70,
                                child: TextFormField(
                                  style: const TextStyle(
                                    color: Color.fromRGBO(143, 150, 158, 1),
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'default',
                                  ),
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(),
                                    labelText: 'Organization Name',
                                    labelStyle: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      fontFamily: 'default',
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                width: 350,
                                height: 70,
                                child: TextFormField(
                                  style: const TextStyle(
                                    color: Color.fromRGBO(143, 150, 158, 1),
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'default',
                                  ),
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(),
                                    labelText: 'Designation',
                                    labelStyle: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      fontFamily: 'default',
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                width: 350,
                                height: 70,
                                child: TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  onSaved: (input) => _registerRequest.Email= input!,
                                  validator: (input) {
                                    if (input == null || !input.contains('@')) {
                                      return "Please enter a valid email address";
                                    }
                                    return null;
                                  },
                                  controller: _emailController,
                                  style: const TextStyle(
                                    color: Color.fromRGBO(143, 150, 158, 1),
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'default',
                                  ),
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(),
                                    labelText: 'Email',
                                    labelStyle: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      fontFamily: 'default',
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                width: 350,
                                height: 70,
                                child: TextFormField(
                                  style: const TextStyle(
                                    color: Color.fromRGBO(143, 150, 158, 1),
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'default',
                                  ),
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(),
                                    labelText: 'Mobile Number',
                                    labelStyle: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      fontFamily: 'default',
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                width: 350,
                                height: 70,
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  onSaved: (input)=> _registerRequest.Password = input!,
                                  validator: (input) => input!.length < 6 ? "Password should be more than 6 characters": null,
                                  controller: _passwordController,
                                  obscureText: _isObscuredPassword,
                                  style: const TextStyle(
                                    color: Color.fromRGBO(143, 150, 158, 1),
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'default',
                                  ),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(),
                                    labelText: 'Password',
                                    labelStyle: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      fontFamily: 'default',
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(_getIconPassword()),
                                      onPressed: () {
                                        setState(() {
                                          _isObscuredPassword = !_isObscuredPassword;
                                          _passwordController.text =
                                              _passwordController.text;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                width: 350,
                                height: 70,
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  onSaved: (input)=> _registerRequest.Password = input!,
                                  validator: (input) => input!.length < 6 ? "Password should be more than 6 characters": null,
                                  controller: _confirmPasswordController,
                                  obscureText: _isObscuredConfirmPassword,
                                  style: const TextStyle(
                                    color: Color.fromRGBO(143, 150, 158, 1),
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'default',
                                  ),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(),
                                    labelText: 'Confirm Password',
                                    labelStyle: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      fontFamily: 'default',
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(_getIconConfirmPassword()),
                                      onPressed: () {
                                        setState(() {
                                          _isObscuredConfirmPassword = !_isObscuredConfirmPassword;
                                          _confirmPasswordController.text =
                                              _confirmPasswordController.text;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              DropdownFormField(hintText: 'Type of User', dropdownItems: types,),
                              const SizedBox(height: 20),
                              Container(
                                width: 350,
                                height: 70,
                                child: TextFormField(
                                  style: const TextStyle(
                                    color: Color.fromRGBO(143, 150, 158, 1),
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'default',
                                  ),
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(),
                                    labelText: 'License Number',
                                    labelStyle: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      fontFamily: 'default',
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                width: 350,
                                height: 70,
                                child: TextFormField(
                                  style: const TextStyle(
                                    color: Color.fromRGBO(143, 150, 158, 1),
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'default',
                                  ),
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(),
                                    labelText: 'Add Profile Picture',
                                    labelStyle: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      fontFamily: 'default',
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                width: 350,
                                height: 120,
                                child: TextFormField(
                                  style: const TextStyle(
                                    color: Color.fromRGBO(143, 150, 158, 1),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'default',
                                  ),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    labelText: 'Address',
                                    labelStyle: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      fontFamily: 'default',
                                    ),
                                    alignLabelWithHint: true,
                                    contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 145),
                                    border:  const OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(Radius.circular(5))
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 50),
                        ElevatedButton(
                            onPressed: _registerUser,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(25, 192, 122, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              fixedSize: Size(350, 70),
                            ),
                            child: const Text('Register',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'default',
                                ))),
                      ]
                    )
                  ),
                  Footer(
                    backgroundColor: Color.fromRGBO(246, 246, 246, 255),
                    alignment: Alignment.bottomCenter,
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Already have an account?  ',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color.fromRGBO(143, 150, 158, 1),
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'default',
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => Login()));
                              },
                              child: const Text(
                                'Login now',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color.fromRGBO(25, 192, 122, 1),
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'default',
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
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

  void _registerUser() {
    if (validateAndSave() && checkConfirmPassword()) {
      RegisterRequestmodel registerRequest = RegisterRequestmodel(
        //fullName: _fullNameController.text,
        Email: _emailController.text,
        Password: _passwordController.text,
      );

      // Call your API service to register the user
      APIService apiService = APIService();
      apiService.register(registerRequest).then((response) {
        // Handle the response accordingly
        // For example, show a success message or navigate to the next screen
      }).catchError((error) {
        if (kDebugMode) {
          print(error);
        }
        const snackBar = SnackBar(
          content: Text('Register Failed!'),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    }
  }

  bool validateAndSave() {
    final form = globalfromkey.currentState;
    if (form != null && form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  bool checkConfirmPassword() {
    return _passwordController.text == _confirmPasswordController.text;
  }
}
