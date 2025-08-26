// Symbol Input Component
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:research_mantra_official/ui/components/trading_journal/screens/trading_journal_entries/trading_form_controller.dart';
import 'package:research_mantra_official/ui/components/trading_journal/widgets/trading_journal_input_field.dart';

class SymbolInputSection extends StatelessWidget {
  final TradingFormController controller;

  const SymbolInputSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TradingJournalInputField(
          label: 'Trading Symbol',
          controller: controller.tradingSymbolController,
          hint: 'Enter stock name',
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          inputFormatters: [
            LengthLimitingTextInputFormatter(10),
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
          ],
          validator: (data) {
            if (data == null || data.isEmpty) {
              return 'Please Enter stock name';
            }
            return null;
          },
        ),

        SizedBox(width: 10),

        SizedBox(height: 8),
        Row(
          children: [
            //Entry Price
            Expanded(
              child: TradingJournalInputField(
                label: 'Entry Price',
                controller: controller.entryPriceController,
                hint: 'Ex: 78',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(6),
                ],
                textInputAction: TextInputAction.next,
                validator: (data) {
                  if (data == null || data.isEmpty) {
                    return 'Please Enter price';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(width: 10),
            //Actual Exit Price
            Expanded(
              child: TradingJournalInputField(
                label: 'Actual Exit Price',
                controller: controller.actualExitController,
                hint: 'Ex: 278',
                maxLines: 1,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(6),
                ],
                validator: (data) {
                  if (data == null || data.isEmpty) {
                    return 'Please Enter price';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(width: 10),
            //Stop Loss Price
            Expanded(
              child: TradingJournalInputField(
                label: 'Stop Loss Price',
                controller: controller.stopLossController,
                hint: 'Ex: 270',
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(6),
                ],
                validator: (data) {
                  if (data == null || data.isEmpty) {
                    return 'Please Enter price';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            //Target One
            Expanded(
              child: TradingJournalInputField(
                label: 'Target 1 (1:2 R.R)',
                controller: controller.targetOneController,
                hint: 'Target 1st price',
                maxLines: 1,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(5),
                ],
                validator: (data) {
                  if (data == null || data.isEmpty) {
                    return 'Please Enter target price';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(width: 10),
            //Target Two
            Expanded(
              child: TradingJournalInputField(
                label: 'Target 2 (1:3 R.R)',
                controller: controller.targetTwoController,
                hint: 'Target 2 price',
                maxLines: 1,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(5),
                ],
                validator: (data) {
                  if (data == null || data.isEmpty) {
                    return 'Please Enter target price';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        //Capital Amount
        TradingJournalInputField(
          label: 'Capital (₹)',
          controller: controller.capitalAmountController,
          hint: 'Enter capital amount',
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          inputFormatters: [
            LengthLimitingTextInputFormatter(6),
          ],
          validator: (data) {
            if (data == null || data.isEmpty) {
              return 'Please Enter capital amount';
            }
            return null;
          },
        ),
        SizedBox(height: 10),
        //Risk Percentage
        Row(
          children: [
            Expanded(
              child: TradingJournalInputField(
                label: 'Risk % Per Trade',
                controller: controller.riskPercentageController,
                hint: 'Enter risk percentage',
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(2),
                ],
                validator: (data) {
                  if (data == null || data.isEmpty) {
                    return 'Please Enter risk percentage';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(width: 10),
            //Position Size
            Expanded(
              child: TradingJournalInputField(
                label: 'Quantity',
                controller: controller.positionSizeController,
                hint: 'Enter quantity',
                maxLines: 1,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(6),
                ],
                textInputAction: TextInputAction.next,
                validator: (data) {
                  if (data == null || data.isEmpty) {
                    return 'Please Enter quantity';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        //Risk Amount
        TradingJournalInputField(
          label: 'Risk Amount (₹)',
          controller: controller.riskAmountController,
          hint: 'Auto-calculated',
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          inputFormatters: [
            LengthLimitingTextInputFormatter(6),
          ],
          validator: (data) {
            if (data == null || data.isEmpty) {
              return 'Please Enter risk amount';
            }
            return null;
          },
        ),
        SizedBox(height: 10),
        Row(
          children: [
            //Profit/Loss
            Expanded(
              child: TradingJournalInputField(
                label: 'Profit/Loss',
                controller: controller.profitLossController,
                hint: 'Auto-calculated',
                maxLines: 1,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10),
                ],
                validator: (data) {
                  if (data == null || data.isEmpty) {
                    return 'Please Enter profit/loss';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(width: 10),
            //Risk Reward
            Expanded(
              child: TradingJournalInputField(
                label: 'Risk:Reward',
                controller: controller.riskRewardController,
                hint: 'Auto-calculated',
                maxLines: 1,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(6),
                ],
                validator: (data) {
                  if (data == null || data.isEmpty) {
                    return 'Please Enter risk reward';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        //Notes & Observation
        TradingJournalInputField(
          label: 'Notes',
          controller: controller.notesController,
          hint: 'Add any additional information',
          maxLines: 3,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          inputFormatters: [
            LengthLimitingTextInputFormatter(200),
          ],
        ),
      ],
    );
  }
}
