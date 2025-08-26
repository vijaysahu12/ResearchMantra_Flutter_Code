import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/constants/storage.dart';
import 'package:research_mantra_official/providers/check_connection_provider.dart';

import 'package:research_mantra_official/services/secure_storage.dart';
import 'package:research_mantra_official/services/user_secure_storage_service.dart';
import 'package:research_mantra_official/ui/components/date_time_conver/convert_time_date.dart';
import 'package:research_mantra_official/ui/screens/home/widgets/gainerlosers/gainer_losers/top_values.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';

class TopGainersAndTopLosersWidget extends ConsumerStatefulWidget {
  final String? latestUpdatedDateTime;

  final List<Map>? topGainersDataList;
  final List<Map>? topLosersDataList;

  const TopGainersAndTopLosersWidget({
    super.key,
    this.latestUpdatedDateTime,
    this.topGainersDataList,
    this.topLosersDataList,
  });

  @override
  ConsumerState<TopGainersAndTopLosersWidget> createState() =>
      _TopGainersAndTopLosersWidgetState();
}

class _TopGainersAndTopLosersWidgetState
    extends ConsumerState<TopGainersAndTopLosersWidget> {
  final UserSecureStorageService _secureStorageService =
      UserSecureStorageService();
  String latestUpdatedDateTimeFromLocalDb = DateTime.now().toString();
  final SharedPref _sharedPref = SharedPref();
  String selectedTopGainerAndTopLosersButton = topGainers;

  List<Map> topValues = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      getTopGainersValues();
    });
  }

//Get TopGainers from local Db
  Future<void> getTopGainersValues() async {
    latestUpdatedDateTimeFromLocalDb =
        await _sharedPref.read(latestStorageDate) ?? '';
    List<Map>? values =
        await _secureStorageService.getTopValues(topGainersStoringDataText);
    if (values.isNotEmpty) {
      setState(() {
        topValues = values;
      });
    }
  }

//Get Top Losers from local Db
  Future<void> getTopLosersValues() async {
    List<Map>? values =
        await _secureStorageService.getTopValues(topLosersStoringDataText);
    if (values.isNotEmpty) {
      setState(() {
        topValues = values;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final connectivityResult = ref.watch(connectivityStreamProvider);

    //Checking result based on that displaying connection screen
    final connectionResult = connectivityResult.value;

    bool isConnection = connectionResult != ConnectivityResult.none;

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
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: theme.shadowColor, width: 0.5))),
            child: Row(
              children: [
                const SizedBox(width: 10),
                _buildButton(
                  context,
                  text: topGainersButtonText,
                  isSelected:
                      selectedTopGainerAndTopLosersButton == 'TopGainers',
                  onTap: () => _onButtonTap('TopGainers'),
                ),
                const SizedBox(width: 10),
                _buildButton(
                  context,
                  text: topLosersButtonText,
                  isSelected:
                      selectedTopGainerAndTopLosersButton == 'TopLosers',
                  onTap: () => _onButtonTap('TopLosers'),
                ),
                const Spacer(),
                Row(
                  children: [
                    Icon(
                      Icons.rotate_left_sharp,
                      size: 15,
                      color: theme.focusColor,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      widget.latestUpdatedDateTime != null
                          ? ConvertdateAndTime().convertDateTime(widget
                              .latestUpdatedDateTime!
                              .replaceAll('"', '')
                              .toString())
                          : ConvertdateAndTime().convertDateTime(
                              latestUpdatedDateTimeFromLocalDb
                                  .replaceAll('"', '')
                                  .toString()),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFamily: fontFamily,
                        color: theme.focusColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
          Expanded(
            child: selectedTopGainerAndTopLosersButton == 'TopGainers'
                ? _buildTGainers(isConnection)
                : _buildTLosers(isConnection),
          ),
        ],
      ),
    );
  }

//widget topgainers
  Widget _buildTGainers(isConnection) {
    return Consumer(builder: (context, ref, child) {
      if (!isConnection) {
        return TopValuesWidget(
          topValues: topValues,
          isLoading: false,
        );
      } else {
        return TopValuesWidget(
          topValues: widget.topGainersDataList!.isNotEmpty
              ? widget.topGainersDataList!
              : topValues,
          isLoading: false,
        );
      }
    });
  }

//widget toplosers
  Widget _buildTLosers(isConnection) {
    return Consumer(builder: (context, ref, child) {
      //if no internet connection

      if (!isConnection) {
        return TopValuesWidget(
          topValues: topValues,
          isLoading: false,
        );
      } else {
        return TopValuesWidget(
          topValues: widget.topLosersDataList!.isNotEmpty
              ? widget.topLosersDataList!
              : topValues,
          isLoading: false,
        );
      }
    });
  }

//build for button
  Widget _buildButton(BuildContext context,
      {required String text,
      required bool isSelected,
      required VoidCallback onTap}) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
          decoration: isSelected
              ? BoxDecoration(
                  color: theme.shadowColor,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: theme.focusColor, width: 1),
                )
              : null,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              fontFamily: fontFamily,
              color: isSelected ? theme.primaryColorDark : theme.focusColor,
            ),
          ),
        ),
      ),
    );
  }

  void _onButtonTap(String buttonType) async {
    if (buttonType == "TopGainers") {
      await getTopGainersValues();
    } else {
      await getTopLosersValues();
    }

    setState(() {
      selectedTopGainerAndTopLosersButton = buttonType;
    });
  }
}
