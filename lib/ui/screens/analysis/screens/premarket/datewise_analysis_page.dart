import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/constants/storage.dart';
import 'package:research_mantra_official/providers/check_connection_provider.dart';
import 'package:research_mantra_official/providers/market_analysis/pre_market_analysis/premarket_analysis_datewise_provider.dart';
import 'package:research_mantra_official/ui/components/app_bar.dart';
import 'package:research_mantra_official/ui/components/common_error/no_connection.dart';
import 'package:research_mantra_official/ui/components/common_error/oops_screen.dart';
import 'package:research_mantra_official/ui/components/empty_contents/no_content_widget.dart';
import 'package:research_mantra_official/ui/components/king_research_loader/kingresearch_loader.dart';
import 'package:research_mantra_official/ui/screens/analysis/widget/bullish_bearish_component.dart';
import 'package:research_mantra_official/ui/screens/analysis/widget/commodities_list.dart';
import 'package:research_mantra_official/ui/screens/analysis/widget/fii_dii_card.dart';
import 'package:research_mantra_official/ui/screens/analysis/widget/fooder_component.dart';
import 'package:research_mantra_official/ui/screens/analysis/widget/gradient_button.dart';
import 'package:research_mantra_official/ui/screens/analysis/widget/header_component.dart';
import 'package:research_mantra_official/ui/screens/analysis/widget/indices_list.dart';
import 'package:research_mantra_official/ui/screens/analysis/widget/market_bulletin_component.dart';
import 'package:research_mantra_official/ui/screens/analysis/widget/technical_nifty_analysis.dart';
import 'package:research_mantra_official/ui/screens/analysis/widget/widget_container.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';
import 'package:research_mantra_official/utils/toast_utils.dart';
import 'package:research_mantra_official/utils/utils.dart';

class MarketAnalysisDateWisePage extends ConsumerStatefulWidget {
  final String id;
  const MarketAnalysisDateWisePage({super.key, required this.id});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends ConsumerState<MarketAnalysisDateWisePage>
    with SingleTickerProviderStateMixin {
  // String? pdfFilePath;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _checkAndFetchData(false, widget.id);
    });
  }

  Future<void> _checkAndFetchData(isRefresh, String id) async {
    final connectivityResult = ref.watch(connectivityStreamProvider);

    //Checking result based on that displaying connection screen
    final connectionResult = connectivityResult.value;

    bool isConnection = connectionResult != ConnectivityResult.none;
    ref
        .read(connectivityProvider.notifier)
        .updateConnectionStatus(isConnection);
    if (isConnection) {
      await getPreMarketAnalysisById(
          isRefresh, id); // Ensure this method is properly awaiting.
    } else {
      ToastUtils.showToast(noInternetConnectionText, "");
    }
  }

  Future<void> getPreMarketAnalysisById(isRefresh, String id) async {
    if (isRefresh) {
      setState(() {
        isLoading = true;
      });
    }
    await ref
        .read(preMarketAnalysisDateWiseProvider.notifier)
        .getPreMarketAnalysisById(id);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasConnection = ref.watch(connectivityProvider);
    final getPreMarketAnalysisData =
        ref.watch(preMarketAnalysisDateWiseProvider);

    final theme = Theme.of(context);

    if (!hasConnection) {
      return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
                onPressed: () async {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: theme.primaryColorDark,
                )),
            title: const Text("Pre Market Analysis"),
          ),
          backgroundColor: theme.primaryColor,
          body: NoInternet(
            handleRefresh: () => _checkAndFetchData(false, widget.id),
          ));
    }

    return Scaffold(
      appBar: CommonAppBarWithBackButton(
        appBarText: marketAnalysis,
        handleBackButton: () {
          Navigator.pop(context);
        },
      ),
      backgroundColor: theme.primaryColor,
      body: buildPreMarketAnalysisData(getPreMarketAnalysisData, theme),
    );
  }

  Widget buildPreMarketAnalysisData(getPreMarketAnalysisData, theme) {
    if (getPreMarketAnalysisData.isLoading && isLoading) {
      return const CommonLoaderGif();
    } else if (getPreMarketAnalysisData.preMarketAnalysisDateWiseModel ==
            null ||
        getPreMarketAnalysisData.preMarketAnalysisDateWiseModel == {}) {
      return RefreshIndicator(
        onRefresh: () => _checkAndFetchData(true, widget.id),
        child: const NoContentWidget(
          message:
              "Analysis is on its way. Check back later for fresh insights!",
        ),
      );
    } else if (getPreMarketAnalysisData.error != null) {
      return const ErrorScreenWidget();
    } else {
      final marketData =
          getPreMarketAnalysisData.preMarketAnalysisDateWiseModel;

      String time = Utils.formatDateTime(
          dateTimeString: marketData.createdOn, format: ddmmyy);

      return RefreshIndicator(
        onRefresh: () => _checkAndFetchData(true, widget.id),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: ListView(
            // shrinkWrap: true,
            //  padding: const EdgeInsets.all(8.0),
            children: [
              marketData.createdOn != null
                  ? HeadContainer(createdDate: marketData.createdOn)
                  : const HeadContainer(createdDate: 'Invalid Date'),
              if (marketData.indianIndices != null) ...[
                WidgetContainer(
                  child: Column(children: [
                    preindianIndices(theme, marketData),
                    const SizedBox(
                      height: 10,
                    ),
                    BullishBearishIndicator(
                      bullish: marketData.indianIndices.bullish,
                      bearish: marketData.indianIndices.bearish,
                    ),
                  ]),
                )
              ],
              if (marketData.globalIndices != null) ...[
                WidgetContainer(
                    child: Column(
                  children: [
                    preGlobalIndices(theme, marketData, time),
                    const SizedBox(
                      height: 20,
                    ),
                    BullishBearishIndicator(
                      bullish: marketData.globalIndices.bullish,
                      bearish: marketData.globalIndices.bearish,
                    ),
                  ],
                ))
              ],
              if (marketData.commodities != null) ...[
                WidgetContainer(
                  child: Column(children: [
                    commodities(theme, marketData),
                    const SizedBox(
                      height: 20,
                    ),
                    BullishBearishIndicator(
                      bullish: marketData.commodities.bullish,
                      bearish: marketData.commodities.bearish,
                    ),
                  ]),
                ),
                const SizedBox(height: 10),
              ],
              if (marketData.fiiDiiData != null &&
                  marketData.fiiDiiData.isNotEmpty) ...[
                WidgetContainer(
                    child: Column(
                  children: [
                    const GradientButton(text: 'FIIs & DIIs'),
                    FiiDiiCard(fiiDiiData: marketData.fiiDiiData),
                  ],
                )),
                const SizedBox(height: 10),
              ],
              if (marketData.supportResistance != null) ...[
                WidgetContainer(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      const GradientButton(
                        text: 'TECHNICAL ANALYSIS',
                      ),
                      const SizedBox(height: 10),
                      TechnicalNiftyAnalysis(
                        supportResistance: marketData.supportResistance,
                      ),
                    ])),
                const SizedBox(height: 10),
              ],
              if (marketData.marketSentiment != null &&
                  marketData.marketSentiment.sentimentAnalysis.isNotEmpty) ...[
                WidgetContainer(
                    child: Column(
                        children: [marketSentiments(theme, marketData)])),
              ],
              if (marketData.newsBulletins != null) ...[
                WidgetContainer(
                    child: Column(children: [
                  marketBulletin(theme, marketData),
                ]))
              ],
              const WidgetContainer(
                child: FooterWidget(),
              )
            ],
          ),
        ),
      );
    }
  }

  Widget preindianIndices(theme, marketData) {
    // Check if indianIndices data is available
    if (marketData.indianIndices.data == null ||
        marketData.indianIndices.data.isEmpty) {
      return Container(); // Return an empty container if no data
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        const GradientButton(
          text: 'PRE INDIAN INDICES',
          fromtable: true,
        ),
        // const SizedBox(height: 10), // Added space after the GradientButton

        const Row(
          children: [],
        ),
        // Added space between text and indices list

        Container(
          decoration: BoxDecoration(
            color: theme.primaryColor,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            boxShadow: [
              BoxShadow(
                color: theme.focusColor.withOpacity(0.4),
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          padding: const EdgeInsets.all(8.0),
          child: IndicesList(
            indices: marketData.indianIndices.data,
            globalIndices: false,
          ),
        ),
      ],
    );
  }

  Widget preGlobalIndices(theme, marketData, time) {
    // Check if globalIndices data exists and is not empty
    if (marketData.globalIndices.data == null ||
        marketData.globalIndices.data.isEmpty) {
      return Container(); // Return an empty container if no data available
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const GradientButton(
          text: 'PRE GLOBAL INDICES',
          fromtable: true,
        ),
        // Time label

        // Show global indices list
        Container(
          decoration: BoxDecoration(
            color: theme.primaryColor,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            // BorderRadius.circular(8)

            boxShadow: [
              BoxShadow(
                color: theme.focusColor.withOpacity(0.4),
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          padding: const EdgeInsets.all(8.0),
          child: IndicesList(
            indices: marketData.globalIndices.data,
            globalIndices: true,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 3, bottom: 5),
              child: Text(
                "Last modified : $time",
                style: TextStyle(
                  color: theme.primaryColorDark,
                  fontWeight: FontWeight.bold,
                  fontFamily: fontFamily,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget commodities(theme, marketData) {
    if (marketData.commodities == null) {
      return Container(); // Return an empty container if no data
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        const GradientButton(
          text: 'COMMODITIES',
          fromtable: true,
        ),
        Container(
          decoration: BoxDecoration(
              //  border: Border.all(color: theme.focusColor.withOpacity(0.4)),
              color: theme.primaryColor,
              boxShadow: [
                BoxShadow(
                  color: theme.focusColor.withOpacity(0.4),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(0, 1),
                ),
              ],
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              )),
          padding: const EdgeInsets.all(8.0),
          child: CommoditiesList(commodities: marketData.commodities),
        ),
      ],
    );
  }

  Widget marketBulletin(theme, marketData) {
    if (marketData.newsBulletins == null ||
        marketData.newsBulletins.bulletins.isEmpty) {
      return Container(); // Return an empty container if no data
    }

    return Column(
      children: [
        const GradientButton(text: 'MARKET BULLETIN'),
        const SizedBox(height: 10),
        MarketBulletin(marketBulletin: marketData.newsBulletins.bulletins),
      ],
    );
  }

  Widget marketSentiments(theme, marketData) {
    if (marketData.marketSentiment == null ||
        marketData.marketSentiment.sentimentAnalysis.isEmpty) {
      return Container(); // Return an empty container if no data
    }

    return Column(
      children: [
        const GradientButton(text: 'MARKET SENTIMENTS'),
        const SizedBox(height: 10),
        MarketBulletin(
            marketBulletin: marketData.marketSentiment.sentimentAnalysis),
      ],
    );
  }
}
