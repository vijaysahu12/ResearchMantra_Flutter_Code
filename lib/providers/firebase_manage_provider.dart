import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class FirebaseManager {
  // Lazy initialization of providers
  late final FutureProvider<FirebaseApp> _firebaseProvider;
  late final Provider<DatabaseReference> _databaseProvider;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  // Constructor
  FirebaseManager() {
    _initializeProviders();
  }

  // Initialize Firebase provider
  void _initializeProviders() {
    _firebaseProvider = FutureProvider<FirebaseApp>((ref) async {
      final FirebaseApp firebaseApp = await Firebase.initializeApp();
      return firebaseApp;
    });

    _databaseProvider = Provider<DatabaseReference>((ref) {
      final firebase = ref.watch(_firebaseProvider).asData?.value;
      if (firebase == null) {
        throw Exception("Firebase app is not initialized!");
      }
      return FirebaseDatabase.instanceFor(app: firebase).ref();
    });
  }

  Stream<bool> streamBoolValue(String key) {
    return _database.child(key).onValue.map((event) {
      final value = event.snapshot.value;
      return value == true;
    });
  }

  // Stream provider for a given child path
  StreamProvider<Map<dynamic, dynamic>> streamProvider(String childPath) {
    return StreamProvider<Map<dynamic, dynamic>>((ref) {
      final database = ref.watch(_databaseProvider);
      return database.child(childPath).onValue.map((event) {
        final value = event.snapshot.value;
        return (value != null && value is Map<dynamic, dynamic>)
            ? value
            : {}; // Return empty map if null
      });
    });
  }
}

// Provider for FirebaseManager
final firebaseManagerProvider = Provider((ref) {
  return FirebaseManager();
});

final allRealTimeValuesProvider = StreamProvider<Map<dynamic, dynamic>>((ref) {
  final firebaseManager = ref.watch(firebaseManagerProvider);
  ref.keepAlive(); // This keeps the provider alive
  return ref
      .watch(firebaseManager.streamProvider('RealTimeMarketValues').stream);
});

final allScannerNotificationStreamProvider =
    StreamProvider<Map<dynamic, dynamic>>((ref) {
  final firebaseManager = ref.watch(firebaseManagerProvider);
  ref.keepAlive(); // This keeps the provider alive

  return ref.watch(firebaseManager.streamProvider('BreakfastScanner').stream);
});


// Provider to check if bottom sheet is enabled
final isBottomSheetEnabledProvider = StreamProvider<bool>((ref) {
  final firebaseManager = ref.read(firebaseManagerProvider);
  ref.keepAlive(); // This keeps the provider alive
  return firebaseManager.streamBoolValue('IsBottomSheet');
});

//StateProvider  for bottom sheet display using local stored value
final shouldShowBottomSheetProvider = StateProvider<bool>((ref) => false);


