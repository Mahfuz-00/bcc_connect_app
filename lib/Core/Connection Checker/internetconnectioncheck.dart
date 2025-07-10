import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// A widget that checks the internet connectivity status.
///
/// This widget wraps its child and monitors the internet connection state.
/// If no internet connection is found, it displays a message with a retry button.
class InternetConnectionChecker extends StatefulWidget {
  final Widget child;

  const InternetConnectionChecker({Key? key, required this.child}) : super(key: key);

  @override
  _InternetConnectionCheckerState createState() => _InternetConnectionCheckerState();
}

class _InternetConnectionCheckerState extends State<InternetConnectionChecker> {
  late Connectivity _connectivity;
  late bool _isConnected;

  @override
  void initState() {
    super.initState();
    _connectivity = Connectivity();
    _isConnected = true; // Assume initially connected
    _initConnectivity();
    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      setState(() {
        _isConnected = !results.contains(ConnectivityResult.none);
      });
    });
  }

  Future<void> _initConnectivity() async {
    final List<ConnectivityResult> results = await _connectivity.checkConnectivity();
    setState(() {
      _isConnected = !results.contains(ConnectivityResult.none);
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
                  fontFamily: 'default',
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
                  fixedSize: const Size(150, 30),
                ),
                child: Text(
                  'Retry',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(25, 192, 122, 1),
                    fontFamily: 'default',
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