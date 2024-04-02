import 'package:flutter/material.dart';
import 'package:footer/footer.dart';

import 'createnewpasswordUI.dart';

class OPTVerfication extends StatefulWidget {
  const OPTVerfication({super.key});

  @override
  State<OPTVerfication> createState() => _OPTVerficationState();
}

class _OPTVerficationState extends State<OPTVerfication> {
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
                              'OTP Verification',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Color.fromRGBO(25, 192, 122, 1),
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'default'),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.only(left: 30.0,right: 30.0),
                              child: Text(
                                'Enter the Verification code we just sent on your email address',
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
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 30, right: 30),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 75,
                                        height: 70,
                                        child: TextFormField(
                                          style: const TextStyle(
                                            color: Color.fromRGBO(143, 150, 158, 1),
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'default',
                                          ),
                                          decoration: const InputDecoration(
                                            /*filled: true,
                                            fillColor: Color.fromRGBO(247,248,250,255),*/
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color.fromRGBO(25, 192, 122, 1),
                                                width: 2.0,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromRGBO(25, 192, 122, 1),
                                                  width: 2.0,
                                              ),
                                            ),
                                            labelText: '',
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 15,),
                                      Container(
                                        width: 75,
                                        height: 70,
                                        child: TextFormField(
                                          style: const TextStyle(
                                            color: Color.fromRGBO(143, 150, 158, 1),
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'default',
                                          ),
                                          decoration: const InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color.fromRGBO(25, 192, 122, 1),
                                                width: 2.0,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color.fromRGBO(25, 192, 122, 1),
                                                width: 2.0,
                                              ),
                                            ),
                                            labelText: '',
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 15,),
                                      Container(
                                        width: 75,
                                        height: 70,
                                        child: TextFormField(
                                          style: const TextStyle(
                                            color: Color.fromRGBO(143, 150, 158, 1),
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'default',
                                          ),
                                          decoration: const InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color.fromRGBO(25, 192, 122, 1),
                                                width: 2.0,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color.fromRGBO(25, 192, 122, 1),
                                                width: 2.0,
                                              ),
                                            ),
                                            labelText: '',
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 15,),
                                      Container(
                                        width: 75,
                                        height: 70,
                                        child: TextFormField(
                                          style: const TextStyle(
                                            color: Color.fromRGBO(143, 150, 158, 1),
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'default',
                                          ),
                                          decoration: const InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color.fromRGBO(25, 192, 122, 1),
                                                width: 2.0,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color.fromRGBO(25, 192, 122, 1),
                                                width: 2.0,
                                              ),
                                            ),
                                            labelText: '',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 50,),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) => CreateNewPassword()));
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color.fromRGBO(25, 192, 122, 1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  fixedSize: Size(350, 70),
                                ),
                                child: const Text('Verify',
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
                  SizedBox(height: 20),
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
                              'Didn\'t recived code?  ',
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
                                /*Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Login()));*/
                              },
                              child: Text(
                                'Resend',
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
          )
      ),
    );
  }
}
