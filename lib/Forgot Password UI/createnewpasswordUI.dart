import 'package:flutter/material.dart';

import 'passwordchangedUI.dart';

class CreateNewPassword extends StatefulWidget {
  const CreateNewPassword({super.key});

  @override
  State<CreateNewPassword> createState() => _CreateNewPasswordState();
}

class _CreateNewPasswordState extends State<CreateNewPassword> {
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
                children: [
                  /*Container(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Container(
                        padding: EdgeInsets.only(left: 8),
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 2, color: Color.fromRGBO(25, 192, 122, 1)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.arrow_back_ios,
                              color: Color.fromRGBO(25, 192, 122, 1)),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ),
                  ),*/
                  Expanded(
                    child: Center(
                      child: Container(
                        child: Column(
                          children: [
                            Text(
                              'Enter new password',
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
                                'Please enter a new password. Your new password must be different from any of your previous password',
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
                                  labelText: 'Enter your new password',
                                  labelStyle: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    fontFamily: 'default',
                                  ),
                                ),
                              ),
                            ),
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
                                  labelText: 'Confirm new password',
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
                                          builder: (context) => PasswordChanged()));
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color.fromRGBO(25, 192, 122, 1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  fixedSize: Size(350, 70),
                                ),
                                child: const Text('Submit',
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
                ],
              ),
            ),
          )),
    );
  }
}
