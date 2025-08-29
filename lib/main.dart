import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'dart:ui';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:research_mantra_official/constants/storage.dart';
import 'package:research_mantra_official/data/models/hive_model/blog_hive_model.dart';
import 'package:research_mantra_official/data/models/hive_model/product_hive_model.dart';
import 'package:research_mantra_official/data/models/hive_model/promo_hive_model.dart';
import 'package:research_mantra_official/data/repositories/active_product_count_repository.dart';
import 'package:research_mantra_official/data/repositories/blogs_respository.dart';
import 'package:research_mantra_official/data/repositories/calculate_future_repository.dart';
import 'package:research_mantra_official/data/repositories/community_repository.dart';
import 'package:research_mantra_official/data/repositories/dash_board_respository.dart';
import 'package:research_mantra_official/data/repositories/fcm_repository.dart';
import 'package:research_mantra_official/data/repositories/forms_repository.dart';
import 'package:research_mantra_official/data/repositories/get_free_trial_respository.dart';
import 'package:research_mantra_official/data/repositories/getsubscription_repository.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IActive_product_count_repository.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IAnalysis_repository.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IBlogs_repository.dart';
import 'package:research_mantra_official/data/repositories/interfaces/ICalculate_future_repository.dart';
import 'package:research_mantra_official/data/repositories/interfaces/ICommunity_repository.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IDashBoard_respository.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IForms_repository.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IGet_Free_trial_respositiry.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IGetsubscription_repository.dart';
import 'package:research_mantra_official/data/repositories/interfaces/ILearning_repository.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IMybucket_list_repository.dart';
import 'package:research_mantra_official/data/repositories/interfaces/INotification_repository.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IPartneraccount_repository.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IPaymentByPass_repository.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IPayment_repository.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IPerfomance_repository.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IProfile_repository.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IPromo_card_repository.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IResearch_repository.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IScanners_repository.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IServices_repositry.dart';
import 'package:research_mantra_official/data/repositories/interfaces/ISip_calculator_repository.dart';
import 'package:research_mantra_official/data/repositories/interfaces/ISubscription_repository.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IScreeners_repository.dart';
import 'package:research_mantra_official/data/repositories/interfaces/ITickets_respository.dart';
import 'package:research_mantra_official/data/repositories/interfaces/ITrading_journal_repository.dart';
import 'package:research_mantra_official/data/repositories/interfaces/ifcm_respository.dart';
import 'package:research_mantra_official/data/repositories/learning_repostiory.dart';
import 'package:research_mantra_official/data/repositories/market_analysis_repository.dart';
import 'package:research_mantra_official/data/repositories/mybucket_list_repository.dart';
import 'package:research_mantra_official/data/repositories/notification_repository.dart';
import 'package:research_mantra_official/data/repositories/partner_account_repository.dart';
import 'package:research_mantra_official/data/repositories/payment_gateway_repository.dart';
import 'package:research_mantra_official/data/repositories/payment_respository.dart';
import 'package:research_mantra_official/data/repositories/perfomance_repository.dart';
import 'package:research_mantra_official/data/repositories/profile_repository.dart';
import 'package:research_mantra_official/data/repositories/promo_card_repository.dart';
import 'package:research_mantra_official/data/repositories/research_repository.dart';
import 'package:research_mantra_official/data/repositories/scanners_repository.dart';
import 'package:research_mantra_official/data/repositories/services_repository.dart';
import 'package:research_mantra_official/data/repositories/sip_calculator_repository.dart';
import 'package:research_mantra_official/data/repositories/subscription_repository.dart';
import 'package:research_mantra_official/data/repositories/screeners_repository.dart';
import 'package:research_mantra_official/data/repositories/ticket_respository.dart';
import 'package:research_mantra_official/data/repositories/trading_journal_repository.dart';
import 'package:research_mantra_official/data/repositories/user_repository.dart';
import 'package:research_mantra_official/providers/check_connection_provider.dart';
import 'package:research_mantra_official/providers/theme_provider/theme_provider.dart';
import 'package:research_mantra_official/services/auto_bottom_observer.dart';
import 'package:research_mantra_official/services/notification_navigation.dart';
import 'package:research_mantra_official/services/user_secure_storage_service.dart';
import 'package:research_mantra_official/ui/Screens/home/home_navigator.dart';

import 'package:research_mantra_official/ui/components/restart_widget.dart';
import 'package:research_mantra_official/ui/components/splash/splash_screen.dart';
import 'package:research_mantra_official/ui/router/app_routes.dart';
import 'package:research_mantra_official/utils/firebase_notifications_utils.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IProduct_repository.dart';
import 'package:research_mantra_official/data/repositories/product_repository.dart';
import 'package:research_mantra_official/utils/local_notifications_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:research_mantra_official/constants/l10n/localizations.dart';
import 'package:research_mantra_official/data/network/http_client.dart';
import 'package:research_mantra_official/services/secure_storage.dart';
import 'package:research_mantra_official/ui/router/routes.dart';
import 'package:flutter/services.dart';
import 'package:research_mantra_official/ui/themes/dark_theme.dart';
import 'package:research_mantra_official/ui/themes/light_theme.dart';
import 'package:showcaseview/showcaseview.dart';
import 'data/repositories/interfaces/IUser_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

//When the app is in the background (not active but still in memory).
// When the app is completely terminated (closed).
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(message) async {

  await Firebase.initializeApp();

  ////If your notifications contain a notification payload (handled by FCM automatically), then you don't need showNotification  .
}

// Create a global key for navigation
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final UserSecureStorageService userDetails = UserSecureStorageService();
final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();
Future<void> main() async {
  await dotenv.load(fileName: ".env");

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Locks the app in portrait mode
  ]);

  // // Register background message handler

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  final sharedPreferences = SharedPref();

  //initalize hive
  await Hive.initFlutter();

  Hive.registerAdapter(ProductHiveModelAdapter());
  Hive.registerAdapter(BlogsHiveModelAdapter());
  Hive.registerAdapter(PromoHiveModelAdapter());
  Hive.registerAdapter(MediaHiveItemAdapter());
  Hive.registerAdapter(ButtonHiveModelAdapter());

  await Hive.openBox<ProductHiveModel>('productsBox');
  await Hive.openBox<BlogsHiveModel>('blogPost');
  await Hive.openBox<PromoHiveModel>('promos');

  // Inject singletons
  await _injectServices();

  await Firebase.initializeApp(
    // name: "kingresearchmobile", //Production Firebase
    name: "researchmantraofficial-80bcf", //Test Firebase
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseNotificationsUtils.configureFirebaseMessaging();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FlutterError.onError = (errorDetails) {

    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
 
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // // Initialize Firebase Messaging
  _configureSelectNotificationSubject();
  // checkFirstLaunch(sharedPreferences);

  await updateFcmToken();
  final String? sessionDetails = await userDetails.getRefreshToken();

  runApp(RestartWidget(
    child: ProviderScope(
        child: FlutterTemplateApp(
      appRouter: AppRouter(),
      sharedPreferences: sharedPreferences,
      sessionDetails: sessionDetails,
    )),
  ));
  FlutterNativeSplash.remove();
}

//Function to navigate screens
void _configureSelectNotificationSubject() {

  selectNotificationStream.stream.listen((String? payload) async {
    //If payload is null navigating to notifications

    if (payload == null) {
      navigatorKey.currentState?.pushNamed(notifications);
      return;
    }

    var payloadData = jsonDecode(payload);
    //If payload is empty navigating to notifications
    if (payloadData.isEmpty) {
      navigatorKey.currentState?.pushNamed(notifications);
      return;
    }

    String? screenName = payloadData["ScreenName"]?.toString().trim();
    String? productName = payloadData["ProductName"]?.toString();
    String? id = payloadData["ProductId"]?.toString();

    String topicName = payloadData["Topic"]?.toString() ?? "Breakfast";
    bool isScanner = payloadData["Scanner"]?.toString().toLowerCase() == "true";

//If Scanner is true navigating to Scanner Screen
    if (isScanner) {
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => HomeNavigatorWidget(
            initialIndex: 4,
            topicName: topicName,
          ),
        ),
      );
      return;
    }

    // Call the navigate function from the helper
    navigateToSpecificName(
        screenName ?? '',
        id ?? '',
        productName ?? '',
        navigatorKey, // Pass the navigator key
        true //isFromNotification
        );
  });
}

final getIt = GetIt.instance;
_injectServices() {
  // Initialize services
  getIt.registerSingleton<SecureStorage>(SecureStorage());
  getIt.registerSingleton<HttpClient>(HttpClient());

  // Initialize repositories
  getIt.registerSingleton<IUserRepository>(UserRepository());
  getIt.registerSingleton<INotificationRepository>(NotificationRepository());
  getIt.registerSingleton<IProductRepository>(ProductRepository());
  getIt.registerSingleton<IMybucketListRepository>(MybucketListRepository());
  getIt.registerSingleton<IGetSubscriptionRepository>(
      GetSubscriptionRepository());
  getIt.registerSingleton<IGetBlogRepository>(GetBlogsRepository());
  getIt.registerSingleton<IDashBoardRepository>(DashBoardRepository());
  getIt.registerSingleton<IProfileRepository>(ProfileRepository());
  getIt.registerSingleton<ITicketRespository>(TicketRepository());
  getIt.registerSingleton<IScannersRepository>(ScannersRepository());

  getIt
      .registerSingleton<IPartnerAccountRepository>(PartnerAccountRepository());
  getIt.registerSingleton<IResearchRepository>(ResearchRepository());
  getIt.registerSingleton<ILearningRepository>(LearningRepository());
  getIt.registerSingleton<IGetFreeTrialRepository>(GetFreeTrialRepository());

  getIt.registerSingleton<IUpdateFcmRepository>(UpdateFcmRepository());
  getIt.registerSingleton<IPaymentGateWayByPassRepository>(
      PaymentGateWayRepository());
  getIt.registerSingleton<IPerformanceRepository>(PerformaceRepository());

  getIt.registerSingleton<ISubscriptionRepository>(SubscriptionRepository());

  getIt.registerSingleton<IScreenersRepository>(ScreenersRespository());
  getIt.registerSingleton<IPaymentRespoitory>(PaymentRepository());
  getIt
      .registerSingleton<ITradingJournalRepository>(TradingJournalRepository());
  getIt.registerSingleton<ISipCalculatorRepository>(SipCalculatorRepository());
  getIt.registerSingleton<IActiveProductCountRepository>(
      ActiveProductCountRepository());
  getIt.registerSingleton<IAnalysisRepository>(MarketAnalysisRepository());
  getIt.registerSingleton<IServicesReposity>(ServicesRepository());
  getIt.registerSingleton<ICalculateMyFutureRepository>(
      CalculateFutureRepository());
  getIt.registerSingleton<ICommunityRepository>(CommunityRepository());
  getIt.registerSingleton<IFormsRepository>(FormsRepository());
  getIt.registerSingleton<IPromoRepository>(PromoRepository());
}

Future<void> updateFcmToken() async {
  String mobileUserPublicKey = await userDetails.getPublicKey();

  FirebaseMessaging.instance.onTokenRefresh.listen(
    (newToken) async {
      if (mobileUserPublicKey != "") {
        await getIt<IUpdateFcmRepository>()
            .updateFcm(mobileUserPublicKey, newToken);
      }
    },
  );
}

class FlutterTemplateApp extends ConsumerStatefulWidget {
  final AppRouter appRouter;
  final SharedPref sharedPreferences;

  final String? sessionDetails;

  const FlutterTemplateApp(
      {super.key,
      required this.appRouter,
      required this.sharedPreferences,
      this.sessionDetails});

  @override
  ConsumerState<FlutterTemplateApp> createState() => _FlutterTemplateAppState();
}

class _FlutterTemplateAppState extends ConsumerState<FlutterTemplateApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        .addObserver(this); // Add observer to listen to lifecycle changes
  }

  @override
  void dispose() {
    WidgetsBinding.instance
        .removeObserver(this); // Remove observer when widget is disposed
    super.dispose();
  }

  // This method is triggered when the app lifecycle state changes
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      // The app has returned from the background or was reopened
      // ignore: unused_result
      ref.refresh(connectivityStreamProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final themeMode = ref.watch(themeModeProvider);

        return ShowCaseWidget(
          onComplete: (p0, p1) {},
          onFinish: () async {
            await widget.sharedPreferences.setBool(tutorialShown, true);
          },
          builder: (context) => ScreenUtilInit(
            designSize: const Size(360, 690),
            builder: (BuildContext context, Widget? child) {
              return MaterialApp(
                navigatorObservers: [routeObserver, AutoBottomSheetObserver()],
                debugShowCheckedModeBanner: false,
                onGenerateRoute: widget.appRouter.onGenerateRoute,
                theme:
                    themeMode == ThemeModeType.light ? darkTheme : lightTheme,
                darkTheme: darkTheme,
                themeMode: themeMode == ThemeModeType.light
                    ? ThemeMode.dark
                    : ThemeMode.light,
                // localizationsDelegates: localizationDelegates,
                // supportedLocales: supportedLocales,
                // locale: currentLanguage,
                home: SplashScreen(
                  sessionDetails: widget.sessionDetails,
                ),
                navigatorKey: navigatorKey, // Assign the navigatorKey here
              );
            },
          ),
        );
      },
    );
  }
}
