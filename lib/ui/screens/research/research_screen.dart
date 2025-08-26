import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/constants/storage.dart';
import 'package:research_mantra_official/data/models/research/get_basket_data_model.dart';
import 'package:research_mantra_official/providers/check_connection_provider.dart';
import 'package:research_mantra_official/providers/research/baskets/basket_provider.dart';
import 'package:research_mantra_official/services/secure_storage.dart';
import 'package:research_mantra_official/services/user_secure_storage_service.dart';
import 'package:research_mantra_official/ui/components/common_error/no_connection.dart';
import 'package:research_mantra_official/ui/components/common_error/oops_screen.dart';
import 'package:research_mantra_official/ui/components/empty_contents/no_content_widget.dart';
import 'package:research_mantra_official/ui/components/king_research_loader/kingresearch_loader.dart';
import 'package:research_mantra_official/ui/screens/research/screen/bucket_list_screen.dart';
import 'package:research_mantra_official/ui/screens/research/widgets/research_cards.dart';
import 'package:research_mantra_official/utils/toast_utils.dart';

class ResearchScreen extends ConsumerStatefulWidget {
  const ResearchScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ResearchScreenState();
}

class _ResearchScreenState extends ConsumerState<ResearchScreen> {
  final UserSecureStorageService _commonDetails = UserSecureStorageService();
  final SharedPref _sharedPref = SharedPref();
  // FlutterTts flutterTts = FlutterTts();

  String? localData;
  bool isFloat = true;
  bool isgettingLoad = true;
  List<BasketDataModel> getBaksetDataLocally = [];
  late final String mobileUserPublicKey;
  Timer? _timer;

  ValueNotifier<bool> showBannerWidget = ValueNotifier<bool>(false);

  ValueNotifier<bool> showSuccessAniamtion = ValueNotifier<bool>(false);
  // Function to handle navigation to ProductDetails Screen
  bool isLoadingLocalData = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Check if the widget is still mounted before using ref
      if (mounted) {
        mobileUserPublicKey = await _commonDetails.getPublicKey();
        await loadLocalData();
        await _checkAndFetch();
      }
    });
  }

  Future<void> loadLocalData() async {
    localData = await _sharedPref.read(getBasketData);
    if (localData != null) {
      try {
        List<dynamic> jsonList = await jsonDecode(localData!);
        getBaksetDataLocally = jsonList
            .map((data) =>
                BasketDataModel.fromJson(data as Map<String, dynamic>))
            .toList();
      } catch (e) {
        print('Error decoding local data: $e');
      }
    }
    setState(() {
      isLoadingLocalData =
          false; // Update loading state after loading local data
    });
  }

  Future<void> _checkAndFetch() async {
    final connectivityResult = ref.watch(connectivityStreamProvider);
    final connectionResult = connectivityResult.value;
    if (connectionResult != ConnectivityResult.none) {
      await getBasketList(false);
    } else {
      await loadLocalData();
    }
  }

  Future<void> getBasketList(isRefresh) async {
    if (!mounted) return;
    setState(() {
      isgettingLoad = true;
    });
    final connectivityResult = ref.watch(connectivityStreamProvider);
    //Checking result based on that displaying connection screen
    final connectionResult = connectivityResult.value;
    if (connectionResult != ConnectivityResult.none) {
      await ref.read(getBasketProvider.notifier).getBasket(isRefresh);
    } else {
      ToastUtils.showToast(noInternetConnectionText, "");
    }
    if (mounted) {
      setState(() {
        isgettingLoad = false;
      });
    }
  }

  Future<void> handleCompanyNavigation(
      BuildContext context, int pageNumber, String screenName, num id) async {
    final connectivityResult = ref.watch(connectivityStreamProvider);
    //Checking result based on that displaying connection screen
    final connectionResult = connectivityResult.value;

    if (connectionResult != ConnectivityResult.none) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CompaniesListScreenUi(
            publicKey: mobileUserPublicKey,
            pageNUmber: pageNumber,
            screennName: screenName,
            id: id,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();

    super.dispose();
  }

  String extractString(List<BasketDataModel>? getAllBasketDataModel) {
    String speechText = "";
    int length = getAllBasketDataModel?.length ?? 0;
    for (int i = 0; i < length; i++) {
      final basketData = getAllBasketDataModel![i];
      speechText +=
          "${basketData.title ?? ""}, ${basketData.description ?? ""},  ${basketData.companyCount ?? ""},Company in this Bucket }\n";
    }

    return speechText;
  }

  @override
  Widget build(BuildContext context) {
    final getBasket = ref.watch(getBasketProvider);
    List<BasketDataModel> getAllBasketDataModel =
        getBasket.getAllBasketDataModel;
    List<BasketDataModel> getAllBasketDataFromLocalDb = getBaksetDataLocally;

    final connectivityResult = ref.watch(connectivityStreamProvider);
    final connectionResult = connectivityResult.value;
    if (connectionResult == ConnectivityResult.none) {
      ToastUtils.showToast(noInternetConnectionText, "");
    }
    if (connectionResult != ConnectivityResult.none) {
      if (getBasket.isLoading &&
          isgettingLoad &&
          getBasket.getAllBasketDataModel.isEmpty) {
        return const CommonLoaderGif();
      }
      if (getBasket.error != null) {
        return const ErrorScreenWidget();
      }
      if (getBasket.getAllBasketDataModel.isEmpty &&
          !getBasket.isLoading &&
          !isgettingLoad) {
        return const NoContentWidget(
          message: noContentScreenText,
        );
      }
      if (getBasket.getAllBasketDataModel.isNotEmpty) {
        return RefreshIndicator(
            onRefresh: () => getBasketList(true),
            child: Column(children: [
              Expanded(child: _buildForReserchContainer(getAllBasketDataModel))
            ]));
      } else {
        return const ErrorScreenWidget();
      }
    } else {
      if (getBasket.getAllBasketDataModel.isNotEmpty) {
        return RefreshIndicator(
            onRefresh: () => getBasketList(true),
            child: Column(children: [
              Expanded(child: _buildForReserchContainer(getAllBasketDataModel))
            ]));
      }
      if (isLoadingLocalData) {
        // Show a loading indicator until local data is fetched
        return const CommonLoaderGif();
      }
      if (getAllBasketDataFromLocalDb.isEmpty) {
        return NoInternet(
          handleRefresh: () => _checkAndFetch(),
        );
      } else {
        return SingleChildScrollView(
          child: RefreshIndicator(
            onRefresh: () => getBasketList(true),
            child: Column(
              children: [
                _buildForReserchContainer(getAllBasketDataFromLocalDb),
              ],
            ),
          ),
        );
      }
    }
  }

  //Widget for Resarch
  Widget _buildForReserchContainer(getAllBasketDataModel) {
    if (getAllBasketDataModel.isEmpty) {
      return Container(
        padding: const EdgeInsets.only(top: 100),
        child: NoInternet(
          handleRefresh: () => getBasketList(true),
        ),
      );
    }
    return _buildListCompany(getAllBasketDataModel);
  }

  //widget for companies list
  Widget _buildListCompany(getAllBasketDataModel) {
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemCount: getAllBasketDataModel.length,
      itemBuilder: (context, index) => AnimationConfiguration.staggeredList(
        position: index,
        duration: const Duration(milliseconds: 250),
        child: SlideAnimation(
          verticalOffset: 100.0,
          child: FadeInAnimation(
            child: GestureDetector(
              onTap: () => handleCompanyNavigation(
                context,
                index + 1,
                getAllBasketDataModel[index].title ?? "",
                getAllBasketDataModel[index].id ?? 0,
              ),
              child: ResearchCards(
                isFree: getAllBasketDataModel[index].isFree ?? false,
                cardDescription: getAllBasketDataModel[index].companyCount ==
                        null
                    ? "-"
                    : getAllBasketDataModel[index].companyCount == 1
                        ? "${getAllBasketDataModel[index].companyCount} Company in this Bucket "
                        : "${getAllBasketDataModel[index].companyCount} Companies in this Bucket ",
                cardTitle: getAllBasketDataModel[index].title ?? "",
                buttonTitle: "View",
                onTap: () => handleCompanyNavigation(
                  context,
                  index + 1,
                  getAllBasketDataModel[index].title ?? "",
                  getAllBasketDataModel[index].id ?? 0,
                ),
                cardSubHeading: getAllBasketDataModel[index].description ?? "",
              ),
            ),
          ),
        ),
      ),
    );
  }
}
