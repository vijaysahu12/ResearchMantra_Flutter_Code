import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/services/hive_service.dart';
import 'package:research_mantra_official/services/secure_storage.dart';
import 'package:research_mantra_official/providers/firebase_manage_provider.dart';
import 'package:research_mantra_official/utils/utils.dart';

class PromoActivatorObserver extends ConsumerStatefulWidget {
  const PromoActivatorObserver({super.key});

  @override
  ConsumerState<PromoActivatorObserver> createState() =>
      _PromoActivatorObserverState();
}

class _PromoActivatorObserverState
    extends ConsumerState<PromoActivatorObserver> {
  late final ProviderSubscription<AsyncValue<bool>> _firebaseListener;
  final SharedPref _pref = SharedPref();
  final HiveServiceStorage hiveServiceStorage = HiveServiceStorage();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupFirebaseListener();
    });
  }

  void _setupFirebaseListener() async {
    _firebaseListener = ref.listenManual<AsyncValue<bool>>(
      isBottomSheetEnabledProvider,
      (previous, next) async {
        final firebaseValue = next.asData?.value ?? false;
        final changed = await _pref.hasFirebaseValueChanged(firebaseValue);

        if (firebaseValue && changed && context.mounted) {
          if (!context.mounted) return;
          await handleFirebaseValueChanged(ref: ref, context: context);
        }
      },
    );
  }

  @override
  void dispose() {
    _firebaseListener.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
