import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';

class InternetCheckWrapper extends StatefulWidget {
  final Widget child;
  const InternetCheckWrapper({super.key, required this.child});


  @override
  State<InternetCheckWrapper> createState() => _InternetCheckWrapperState();
}

class _InternetCheckWrapperState extends State<InternetCheckWrapper> {
  late bool isconnected = false;

  @override
  void initState(){
    super.initState();
    checkInternetConnection();
  }

  Future<void> checkInternetConnection() async {
    var connectionResult = (Connectivity().checkConnectivity());
    setState(() {
      isconnected = connectionResult != ConnectivityResult.none;
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return isconnected ? widget.child : internetConnectionErrorDialog();
  }

  Widget internetConnectionErrorDialog(){
    return Scaffold(
      body: Center(
        child: AlertDialog(
          title: Text(
            'Oops!!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 35,
              fontFamily: 'bangla-font',
              color: Colors.black,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Internet Connection Failed!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'bangla-font',
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () {
                    checkInternetConnection();
                  },
                  child: Text(
                      'Retry',
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}


