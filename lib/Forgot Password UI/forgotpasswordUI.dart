import 'package:flutter/material.dart';
import 'package:footer/footer.dart';

import '../Login UI/loginUI.dart';
import 'otpverficationUI.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    child: Column(
                      children: [
                        Text(
                          'Forgot Password?',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Color.fromRGBO(25, 192, 122, 1),
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'default'),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                          child: Text(
                            'Don\'t worry! it occurs. Please Enter the Email address linked with your account',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color.fromRGBO(143, 150, 158, 1),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'default',
                            ),
                          ),
                        ),
                        const SizedBox(height: 50),
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
                              fillColor: Color.fromRGBO(247,248,250,1),
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
                        SizedBox(height: 50,),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OPTVerfication()));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(25, 192, 122, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              fixedSize: Size(350, 70),
                            ),
                            child: const Text('Send Code',
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
                        Text(
                          'Remember Password?  ',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
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
                          child: Text(
                            'Login',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
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
          )),
    );
  }
}
