import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityProvider extends ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  bool _isConnected = true;
  late StreamSubscription<List<ConnectivityResult>> _subscription;

  bool get isConnected => _isConnected;

  ConnectivityProvider() {
    _init();
    _subscription = _connectivity.onConnectivityChanged.listen(_updateStatus);
  }

  Future<void> _init() async {
    final results = await _connectivity.checkConnectivity();
    _updateStatus(results);
  }

  void _updateStatus(List<ConnectivityResult> results) {
    // We consider it connected if any result is NOT .none
    final connected = results.any((result) => result != ConnectivityResult.none);
    
    if (_isConnected != connected) {
      _isConnected = connected;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
