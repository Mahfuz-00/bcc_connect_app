import 'package:flutter/material.dart';
import 'package:footer/footer.dart';

import '../API Models(Login and Sign Up)/loginmodels.dart';
import '../Forgot Password UI/forgotpasswordUI.dart';
import '../Sign Up UI/signupUI.dart';
import '../UserType Dashboard(Demo)/DemoAppDashboard.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isObscured = true;
  late TextEditingController _passwordController;
  late LoginRequestmodel _loginRequest;
  var globalKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> globalfromkey = GlobalKey<FormState>();

  IconData _getIcon() {
    return _isObscured ? Icons.visibility_off : Icons.visibility;
  }

  void _checkLoginRequest() {
    if (_loginRequest != null) {
      _loginRequest.Email; // no error
      _loginRequest.Password; // no error
    }
  }

  @override
  void initState() {
    super.initState();
    _loginRequest = LoginRequestmodel(Email: '', Password: '');
    _passwordController = TextEditingController();
    _checkLoginRequest();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          color: Colors.grey[100],
          child: Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Center(
                    child: Container(
                      //alignment: Alignment.center,
                      child: Column(
                        children: [
                          const Text(
                            'Welcome Again!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color.fromRGBO(25, 192, 122, 1),
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'default'),
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
                                    keyboardType: TextInputType.emailAddress,
                                    onSaved: (input) => _loginRequest.Email= input!,
                                    validator: (input) => input!.contains('@') ? "Please, Enter a Valid Email": null,
                                    style: const TextStyle(
                                      color: Color.fromRGBO(143, 150, 158, 1),
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'default',
                                    ),
                                    decoration: const InputDecoration(
                                      filled: true,
                                      fillColor: Color.fromRGBO(247, 248, 250, 1),
                                      border: OutlineInputBorder(),
                                      labelText: 'Enter your Email',
                                      labelStyle: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        fontFamily: 'default',
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Container(
                                  width: 350,
                                  height: 85,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        keyboardType: TextInputType.text,
                                        onSaved: (input)=> _loginRequest.Password = input!,
                                        validator: (input) => input!.length < 6 ? "Password should be more than 3 characters": null,
                                        controller: _passwordController,
                                        obscureText: _isObscured,
                                        style: const TextStyle(
                                          color: Color.fromRGBO(143, 150, 158, 1),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'default',
                                        ),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: const Color.fromRGBO(247, 248, 250, 1),
                                          border: const OutlineInputBorder(),
                                          labelText: 'Enter your password',
                                          labelStyle: TextStyle(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            fontFamily: 'default',
                                          ),
                                          suffixIcon: IconButton(
                                            icon: Icon(_getIcon()),
                                            onPressed: () {
                                              setState(() {
                                                _isObscured = !_isObscured;
                                                _passwordController.text =
                                                    _passwordController.text;
                                              });
                                            },
                                          ),
                                          errorStyle: TextStyle(height: 0),
                                        ),
                                      ),
                                      if (_passwordController.text.isNotEmpty && _passwordController.text.length < 6)
                                        Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            "Password should be more than 3 characters",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 30.0),
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const ForgotPassword()));
                                  },
                                  child: const Text(
                                    'Forgot Password?',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color.fromRGBO(143, 150, 158, 1),
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'default',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                if(validateAndsave()) {
                                  print(_loginRequest.toJSON());
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const BCCMainDashboard()));
                                  clearForm();
                                }
                                else{
                                  const snackBar = SnackBar(
                                    content: Text('Validation Failed!'),
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromRGBO(25, 192, 122, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                fixedSize: const Size(350, 70),
                              ),
                              child: const Text('Login',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: 'default',
                                  ))),
                        ],
                      ),
                    ),
                  ),
                ),
                //SizedBox(height: 20),
                Footer(
                  backgroundColor: const Color.fromRGBO(246, 246, 246, 255),
                  alignment: Alignment.bottomCenter,
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Don\'t have an account?  ',
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
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Signup()));
                            },
                            child: const Text(
                              'Register now',
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
    );
  }

  bool validateAndsave(){
    if (globalfromkey.currentState == null) {
      // Handle the case where globalfromkey.currentState is null
      return false;
    }
    final form = globalfromkey.currentState;
    if(form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }

  }

  void clearForm() {
    final form = globalfromkey.currentState;
    if (form != null) {
      form.reset();
    }
  }

}
