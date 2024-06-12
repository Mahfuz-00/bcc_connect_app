import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';

class InternetChecker extends StatefulWidget {
  final Widget child;

  const InternetChecker({Key? key, required this.child}) : super(key: key);

  @override
  _InternetCheckerState createState() => _InternetCheckerState();
}

class _InternetCheckerState extends State<InternetChecker> {
  late Connectivity _connectivity;
  late bool _isConnected;

  @override
  void initState() {
    super.initState();
    _connectivity = Connectivity();
    _isConnected = true; // Assume initially connected
    _initConnectivity();
    _connectivity.onConnectivityChanged.listen((result) {
      setState(() {
        _isConnected = (result != ConnectivityResult.none);
      });
    });
  }

  Future<void> _initConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    setState(() {
      _isConnected = (result != ConnectivityResult.none);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isConnected) {
      return Scaffold(
        backgroundColor: Colors.grey[100],
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Internet connection not found',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'default'
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _initConnectivity,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.black, width: 1),
                  ),
                  //elevation: 3,
                  fixedSize: const Size(150, 30),
                ),
                child: Text('Retry',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(25, 192, 122, 1),
                      fontFamily: 'default'
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return widget.child;
    }
  }
}
