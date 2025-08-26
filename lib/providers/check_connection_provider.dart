import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConnectivityState extends StateNotifier<bool> {
  ConnectivityState() : super(false);

  void updateConnectionStatus(bool status) {
    state = status;
  }
}

final connectivityProvider =
    StateNotifierProvider<ConnectivityState, bool>((ref) {
  return ConnectivityState();
});

// StreamProvider that listens to the connectivity changes
final connectivityStreamProvider = StreamProvider<ConnectivityResult>((ref) {
  return Connectivity().onConnectivityChanged.asyncMap((event) {
    return event.isNotEmpty ? event.first : ConnectivityResult.none;
  });
});
