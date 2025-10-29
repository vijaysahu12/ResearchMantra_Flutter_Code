import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:research_mantra_official/constants/assets.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/data/models/product_api_response_model.dart';
import 'package:research_mantra_official/data/models/research/get_companies_data_model.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/check_connection_provider.dart';
import 'package:research_mantra_official/providers/research/companies/companies_provider.dart';
import 'package:research_mantra_official/services/check_connectivity.dart';
import 'package:research_mantra_official/services/no_screen_shot.dart';
import 'package:research_mantra_official/ui/components/common_error/no_connection.dart';
import 'package:research_mantra_official/ui/components/empty_contents/no_content_widget.dart';
import 'package:research_mantra_official/ui/components/king_research_loader/kingresearch_loader.dart';
import 'package:research_mantra_official/ui/screens/research/screen/bucket_details_screen.dart';
import 'package:research_mantra_official/ui/screens/research/widgets/filter_bottom_sheet.dart';
import 'package:research_mantra_official/ui/screens/research/widgets/results_cards.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';

class CompaniesListScreenUi extends ConsumerStatefulWidget {
  final num id;
  final String screennName;
  final int pageNUmber;
  final String publicKey;
  const CompaniesListScreenUi({
    super.key,
    required this.id,
    required this.screennName,
    required this.pageNUmber,
    required this.publicKey,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CompaniesListScreenUiState();
}

class _CompaniesListScreenUiState extends ConsumerState<CompaniesListScreenUi>
    with RouteAware {
  late final ScrollController _scrollController;
  ValueNotifier<bool> hasReechedBottom = ValueNotifier<bool>(false);
  bool isFromProductDetailsScreen = false;
  final noScreenshotUtil = NoScreenshotUtil();

  void disableScreenshots() async {
    await noScreenshotUtil.disableScreenshots();
  }

  void enableScreenshots() async {
    await noScreenshotUtil.enableScreenshots();
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    getCompaniesData();
    disableScreenshots();
    // Listen to scroll position changes
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // Load more data or trigger other action here
        hasReechedBottom.value = true;
      } else if (hasReechedBottom.value) {
        hasReechedBottom.value = false;
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    // Called when returning to this screen
    print("Returned to FirstScreen. Refreshing...");

    if (isFromProductDetailsScreen) {
      // or call your API here
      getCompaniesData();

      Future.delayed(const Duration(milliseconds: 200), () {
        setState(() {
          isFromProductDetailsScreen = false;
        });
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    routeObserver.unsubscribe(this);
    enableScreenshots();
  }

  Future<void> getCompaniesData({
    String? primaryKeyData,
    String? secondaryLKey,
    String? searchTextData,
  }) async {
    bool checkConnection =
        await CheckInternetConnection().checkInternetConnection();

    if (checkConnection) {
      await ref.read(companiesDetailsProvider.notifier).getCompaniesDataModel({
        id: widget.id,
        primaryKey: primaryKeyData,
        secondaryKey: secondaryLKey,
        pageNumber: widget.pageNUmber,
        searchText: searchTextData,
        loggedInUser: widget.publicKey,
      }, true);
    }
  }

  void handleProductDetailsNavigation(context, WidgetRef ref,
      ProductApiResponseModel product, int basektId) async {
    bool checkConnection =
        await CheckInternetConnection().checkInternetConnection();
    ref
        .read(connectivityProvider.notifier)
        .updateConnectionStatus(checkConnection);

    if (checkConnection) {
      setState(() {
        isFromProductDetailsScreen = true;
      });
      // Navigate to Details Screen
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => ProductDetailsScreenWidget(
      //       product: product,
      //       isFromResearch: true,
      //       reasearchbasketId: basektId,
      //       publicKey: widget.publicKey,
      //       pageNumber: widget.pageNUmber,
      //       isFromNotification: false,
      //     ),
      //   ),
      // );
    }
  }

  String extractString(List<CompanyData>? companyData) {
    String speechText = "";
    int length = companyData?.length ?? 0;
    for (int i = 0; i < length; i++) {
      final company = companyData![i];
      speechText +=
          "${company.name ?? ""}, ${company.shortSummary ?? ""}, $marketCapInCr ${company.marketCap ?? ""}, $ttmPe ${company.pe ?? ""}\n";
    }

    return speechText;
  }

  @override
  Widget build(BuildContext context) {
    final connectivityResult = ref.watch(connectivityStreamProvider);
    final getCompanies = ref.watch(companiesDetailsProvider);
    //Checking result based on that displaying connection screen
    final hasConnection = connectivityResult.value;

    final theme = Theme.of(context);
    bool isConnection = (hasConnection != ConnectivityResult.none);

    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: theme.primaryColorDark,
              size: 25,
            ),
          ),
          centerTitle: true,
          title: Image.asset(
            kingResearchLogo,
            scale: 3,
          )),
      body: _buildBody(getCompanies, isConnection),
      floatingActionButton: _buildFlotButton(),
    );
  }

  //widet for displaying body
  Widget _buildBody(getCompanies, isConnection) {
    if (getCompanies.isLoading) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: CommonLoaderGif(),
      );
    }
    if (!isConnection && getCompanies.companiesDataModel == null) {
      return NoInternet(
        handleRefresh: () {},
      );
    }
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: RefreshIndicator(
        onRefresh: getCompaniesData,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Column(
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.only(left: 10.0, right: 10, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              widget.screennName,
                              style: textH1.copyWith(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                    getCompanies.error != null ||
                            getCompanies
                                    .companiesDataModel?.companyData?.length ==
                                null ||
                            (getCompanies.companiesDataModel?.companyData
                                        ?.length ??
                                    0) ==
                                0
                        ? const NoContentWidget(
                            message: noContentScreenText,
                          )
                        : _buildListOfStocks(getCompanies)
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

//Widget for List of Stcoks
  Widget _buildListOfStocks(getCompanies) {
    return ListView.builder(
        // controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: getCompanies.companiesDataModel?.companyData?.length ?? 0,
        itemBuilder: ((context, index) {
          return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 250),
              child: SlideAnimation(
                verticalOffset: 100.0,
                child: FadeInAnimation(
                    child: ResultsCards(
                  isFree: getCompanies
                          .companiesDataModel?.companyData?[index].isFree ??
                      false,
                  buttonTitle: getCompanies.companiesDataModel
                          ?.companyData?[index].companyStatus ??
                      view,
                  onTap: getCompanies.companiesDataModel?.companyData?[index]
                                  .isFree ==
                              true ||
                          getCompanies.companiesDataModel?.hasResearchProduct ==
                              true
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailsBucketScreen(
                                    ttmpe: getCompanies.companiesDataModel
                                            ?.companyData?[index].pe
                                            .toString() ??
                                        "",
                                    marketCap: getCompanies.companiesDataModel
                                            ?.companyData?[index].marketCap
                                            .toString() ??
                                        "",
                                    totalLength: getCompanies.companiesDataModel?.hasResearchProduct == true
                                        ? (getCompanies.companiesDataModel
                                                ?.companyData?.length ??
                                            0 + 1)
                                        : getCompanies.companiesDataModel?.companyData
                                                ?.where((value) => value.isFree == true)
                                                .length ??
                                            0,
                                    pageNumber: (index + 1),
                                    basketId: getCompanies.companiesDataModel?.companyData?[index].basketId ?? 0,
                                    id: getCompanies.companiesDataModel?.companyData?[index].id ?? 0,
                                    productId: getCompanies.companiesDataModel?.companyData?[index].productId ?? 0)),
                          );
                        }
                      : () => handleProductDetailsNavigation(
                          context,
                          ref,
                          ProductApiResponseModel(
                            groupName: '',
                            description: getCompanies.companiesDataModel
                                    ?.companyData?[index].description ??
                                "",
                            id: getCompanies.companiesDataModel
                                    ?.companyData?[index].productId ??
                                0,
                            listImage: "",
                            name: getCompanies.companiesDataModel
                                    ?.companyData?[index].name ??
                                '',
                            price: getCompanies.companiesDataModel
                                    ?.companyData?[index].price ??
                                0.0,
                            overAllRating: 0.0,
                            heartsCount: null,
                            userRating: 0.0,
                            userHasHeart: false,
                            isInMyBucket: true,
                            isInValidity: false,
                            buyButtonText: buy,
                          ),
                          getCompanies.companiesDataModel?.companyData?[index]
                                  .basketId ??
                              0),
                  cardDescription: getCompanies.companiesDataModel
                          ?.companyData?[index].shortSummary ??
                      "",
                  cardTitle: getCompanies
                          .companiesDataModel?.companyData?[index].name ??
                      "",
                  date: getCompanies.companiesDataModel?.companyData?[index]
                          .publishDate ??
                      DateTime.now().toString(),
                  marketCap: getCompanies
                          .companiesDataModel?.companyData?[index].marketCap
                          .toString() ??
                      "",
                  ttem: getCompanies.companiesDataModel?.companyData?[index].pe
                          .toString() ??
                      "",
                )),
              ));
        }));
  }

  //Widget for floatingActionButto
  Widget _buildFlotButton() {
    return ValueListenableBuilder(
      valueListenable: hasReechedBottom,
      builder: (context, value, child) {
        return value == true
            ? const SizedBox.shrink()
            : FloatingActionButton(
                backgroundColor: Theme.of(context).primaryColorDark,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return FilterBottomSheet(
                          getCompaniesData: getCompaniesData,
                        );
                      });
                },
                child: Icon(
                  Icons.filter_list,
                  color: Theme.of(context).primaryColor,
                ));
      },
    );
  }
}
