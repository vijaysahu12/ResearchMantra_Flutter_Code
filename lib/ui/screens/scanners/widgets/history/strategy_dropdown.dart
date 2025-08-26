import 'package:flutter/material.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';
import 'package:research_mantra_official/utils/toast_utils.dart';

class SelectScannersStrategiesAndDate extends StatefulWidget {
  final String selectedScannerStrategyName;
  final String? selectedScannerStrategyCode;

  final TextEditingController fromDateController;
  final TextEditingController toDateController;
  final LayerLink strategiesLayerLink;
  final void Function() selectScannersDropdownValue;
  final Future<void> Function(
          BuildContext context, TextEditingController dateController)
      selectFilterDate;
  final void Function(dynamic primaryKey, dynamic fromDateController,
      dynamic toDateController) handleHistoryData;
  final void Function() handleToRemoveDropDown;
  final bool isConnection;

  const SelectScannersStrategiesAndDate({
    super.key,
    required this.fromDateController,
    required this.toDateController,
    required this.strategiesLayerLink,
    required this.selectScannersDropdownValue,
    required this.selectFilterDate,
    required this.handleHistoryData,
    required this.selectedScannerStrategyName,
    required this.selectedScannerStrategyCode,
    required this.handleToRemoveDropDown,
    required this.isConnection,
  });

  @override
  State<SelectScannersStrategiesAndDate> createState() =>
      _SelectScannersStrategiesAndDateState();
}

class _SelectScannersStrategiesAndDateState
    extends State<SelectScannersStrategiesAndDate> {
  //check description words length
  String getMessagePreview(
      String description, int maxLength, int previewLength) {
    try {
      if (description.length > maxLength) {
        return '${description.substring(0, previewLength)}...';
      } else {
        return description;
      }
    } catch (e) {
      print('Error processing description: $e');
      return description;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fontSize = MediaQuery.of(context).size.width;
    return Row(
      children: [
        SizedBox(
          child: GestureDetector(
            onTap: widget.selectScannersDropdownValue,
            child: CompositedTransformTarget(
              link: widget.strategiesLayerLink,
              child: Container(
                height: fontSize * 0.09,
                width: fontSize * 0.3,
                margin: const EdgeInsets.symmetric(vertical: 2),
                padding:
                    const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: theme.primaryColor,
                  boxShadow: [
                    BoxShadow(
                      color: theme.focusColor.withOpacity(0.4),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      getMessagePreview(
                          widget.selectedScannerStrategyName, 12, 10),
                      style: TextStyle(
                        fontSize: fontSize * 0.025,
                        fontFamily: fontFamily,
                        color: theme.primaryColorDark,
                      ),
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      color: theme.primaryColorDark,
                      size: fontSize * 0.07,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 5),

        _buildDateSelection(
            theme, fontSize, startDate, widget.fromDateController),
        const SizedBox(width: 5),
        _buildDateSelection(theme, fontSize, endDate, widget.toDateController),
        const SizedBox(width: 3),
        //Search button
        Container(
          height: fontSize * 0.09,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: theme.indicatorColor,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(5),
              onTap: () {
                if (widget.isConnection) {
                  widget.handleToRemoveDropDown();
                  if (widget.fromDateController.text.trim().isNotEmpty &&
                      widget.toDateController.text.trim().isNotEmpty) {
                    widget.handleHistoryData(
                        widget.selectedScannerStrategyCode,
                        widget.fromDateController.text,
                        widget.toDateController.text);
                  } else {
                    ToastUtils.showToast(pleaseCheckTheSelectedDates, "");
                  }
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  Icons.search,
                  color: theme.floatingActionButtonTheme.foregroundColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  //Widget for Date Selection
  Widget _buildDateSelection(theme, fontSize, dateType, dateController) {
    return Expanded(
      child: Container(
        height: fontSize * 0.09,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: theme.primaryColor,
          boxShadow: [
            BoxShadow(
              color: theme.focusColor.withOpacity(0.4),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: TextField(
          readOnly: true,
          textAlign: TextAlign.center,
          controller: dateController,
          onTap: () {
            widget.handleToRemoveDropDown();
            widget.selectFilterDate(context, dateController);
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: dateType,
            contentPadding: const EdgeInsets.symmetric(vertical: -16),
            hintStyle: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: theme.primaryColorDark,
            ),
          ),
        ),
      ),
    );
  }



}
