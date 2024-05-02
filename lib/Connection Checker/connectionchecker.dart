import 'package:connectivity/connectivity.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  bool _isConnected = false;
  Function? onConnectionLost;

  bool get isConnected => _isConnected;

  ConnectivityService() {
    _checkConnectivity();
    _connectivity.onConnectivityChanged.listen((result) {
      _isConnected = result != ConnectivityResult.none;
      if (!_isConnected && onConnectionLost != null) {
        onConnectionLost!();
      }
    });
  }

  Future<void> _checkConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    _isConnected = result != ConnectivityResult.none;
    if (!_isConnected && onConnectionLost != null) {
      onConnectionLost!();
    }
  }
}
