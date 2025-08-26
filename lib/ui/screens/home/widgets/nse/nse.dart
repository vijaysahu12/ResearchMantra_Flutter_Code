import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/providers/check_connection_provider.dart';

import 'package:research_mantra_official/services/secure_storage.dart';
import 'package:research_mantra_official/services/user_secure_storage_service.dart';

import 'package:research_mantra_official/ui/screens/home/widgets/nse/widgets/market_value_widget.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';

class NseLivePriceWidget extends ConsumerStatefulWidget {
  final String? latestUpdatedDateTime;
  final Map indainMarketNseStockValues;

  const NseLivePriceWidget({
    super.key,
    this.latestUpdatedDateTime,
    required this.indainMarketNseStockValues,
  });

  @override
  ConsumerState<NseLivePriceWidget> createState() => _NseLivePriceWidgetState();
}

class _NseLivePriceWidgetState extends ConsumerState<NseLivePriceWidget> {
  final UserSecureStorageService _secureStorageService =
      UserSecureStorageService();
  final SharedPref _sharedPref = SharedPref();

  Map<dynamic, dynamic> marketLivePrices = {};
  String latestUpdatedDateTimeFromLocalDb = DateTime.now().toString();

  @override
  void initState() {
    super.initState();
    _checkAndFetchMarketPrices();
  }

  Future<void> _checkAndFetchMarketPrices() async {
    latestUpdatedDateTimeFromLocalDb =
        await _sharedPref.read(latestStorageDate) ?? '';

    // Fetch data from storage if no connection
    if (ref.watch(connectivityStreamProvider).value ==
        ConnectivityResult.none) {
      marketLivePrices = await _secureStorageService.getMarketLivePrice();
      setState(
          () {}); // Triggers UI update if data is loaded from local storage
    }
  }

  String formatDateTime(String dateTimeString) {
    try {
      return DateFormat('HH:mm dd-MMM')
          .format(DateFormat('yy-MM-dd HH:mm:ss').parse(dateTimeString));
    } catch (e) {
      return "--";
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final height = MediaQuery.of(context).size.height;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: theme.shadowColor, width: 0.3),
        color: theme.primaryColor,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor,
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildHeader(theme, height),
          _buildStockPrices(theme),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, height) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Text(
            indianMarketText,
            style: TextStyle(
              fontSize: height * 0.015,
              fontFamily: fontFamily,
              fontWeight: FontWeight.bold,
              color: theme.primaryColorDark,
            ),
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            children: [
              Icon(
                Icons.rotate_left_sharp,
                size: height * 0.02,
                color: theme.focusColor,
              ),
              Text(
                formatDateTime(widget.latestUpdatedDateTime ??
                    latestUpdatedDateTimeFromLocalDb),
                style: TextStyle(
                  fontSize: height * 0.015,
                  fontWeight: FontWeight.bold,
                  fontFamily: fontFamily,
                  color: theme.focusColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStockPrices(theme) {
    final prices = widget.indainMarketNseStockValues.isNotEmpty
        ? widget.indainMarketNseStockValues
        : marketLivePrices;

    final bnf = _getFormattedPrice(prices, 'BNF');
    final nifty = _getFormattedPrice(prices, 'Nifty');

    return _buildIndianValues(bnf ?? {}, nifty ?? {});
  }

  // Format market data values from the map
  Map<String, String>? _getFormattedPrice(
      Map<dynamic, dynamic> data, String key) {
    final values = data[key] as List?;
    if (values != null && values.isNotEmpty) {
      final formatter = NumberFormat.currency(locale: 'en_IN', symbol: "");
      return {
        'value': formatter.format(double.parse(values[0].toString())),
        'percentage': formatter.format(double.parse(values[1].toString())),
      };
    }
    return null;
  }

  Widget _buildIndianValues(
      Map<String, String>? bnf, Map<String, String>? nifty) {
    // Check if both bnf and nifty are null or empty
    if ((bnf == null || bnf.isEmpty) && (nifty == null || nifty.isEmpty)) {
      return Container(); // Return an empty container if both are unavailable
    }

    return Container(
      margin: const EdgeInsets.only(left: 7, bottom: 7, right: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Check if bnf is not null and not empty, then display MarkerWidget
          if (bnf != null &&
              bnf.isNotEmpty &&
              bnf['value'] != null &&
              bnf['value']!.isNotEmpty)
            MarkerWidget(
              bnf['value']!,
              bnf['percentage']!,
              valueName: bseButton, // Replace with actual value name
            ),
          const SizedBox(width: 10),
          // Check if nifty is not null and not empty, then display MarkerWidget
          if (nifty != null &&
              nifty.isNotEmpty &&
              nifty['value'] != null &&
              nifty['value']!.isNotEmpty)
            MarkerWidget(
              nifty['value']!,
              nifty['percentage']!,
              valueName: niftyButton, // Replace with actual value name
            ),
        ],
      ),
    );
  }
}
