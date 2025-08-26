import 'package:flutter/material.dart';
import 'package:research_mantra_official/data/models/trading_journal/trading_journal_model.dart';
import 'package:research_mantra_official/services/user_secure_storage_service.dart';

class TradingFormController {
  final int? journalId;
  // Controllers
  final TextEditingController capitalAmountController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController riskPercentageController =
      TextEditingController();
  final TextEditingController entryPriceController = TextEditingController();
  final TextEditingController tradingSymbolController = TextEditingController();
  final TextEditingController stopLossController = TextEditingController();
  final TextEditingController riskAmountController = TextEditingController();
  final TextEditingController targetOneController = TextEditingController();
  final TextEditingController targetTwoController = TextEditingController();
  final TextEditingController riskRewardController = TextEditingController();
  final TextEditingController profitLossController = TextEditingController();
  final TextEditingController actualExitController = TextEditingController();
  final TextEditingController positionSizeController = TextEditingController();

  // State variables
  DateTime selectedDate = DateTime.now();
  bool isBuySelected = true;

  // Callback for UI update
  final VoidCallback onTradeDirectionChanged;

  TradingFormController({
    required this.onTradeDirectionChanged,
    TradingJournalModel? journalToEdit,
    bool? isFromEditingScreen,
  }) : journalId = journalToEdit?.id {
    _setupAutoCalculationListeners();

    if (journalToEdit != null && isFromEditingScreen == true) {
      _initializeFromModel(journalToEdit);
    }
  }

  void _initializeFromModel(TradingJournalModel j) {
    tradingSymbolController.text = j.symbol ?? '';
    capitalAmountController.text = j.capitalAmount.toString();
    riskPercentageController.text = j.riskPercentage.toString();
    riskAmountController.text = j.riskAmount.toString();
    entryPriceController.text = j.entryPrice.toString();
    stopLossController.text = j.stopLoss.toString();
    targetOneController.text = j.target1.toString();
    targetTwoController.text = j.target2.toString();
    notesController.text = j.notes ?? '';
    positionSizeController.text = j.positionSize.toString();
    profitLossController.text = j.profitLoss ?? '';
    actualExitController.text = j.actualExit.toString();
    riskRewardController.text = j.riskReward ?? '';
    selectedDate = DateTime.tryParse(j.startDate ?? '') ?? DateTime.now();
    isBuySelected = j.buySellButton ?? true;
  }

  void _calculateRiskAmount() {
    if (capitalAmountController.text.isNotEmpty &&
        riskPercentageController.text.isNotEmpty) {
      double capital = double.tryParse(capitalAmountController.text) ?? 0.0;
      double riskPercentage =
          double.tryParse(riskPercentageController.text) ?? 0.0;

      if (capital > 0 && riskPercentage > 0) {
        double riskAmount = (capital * riskPercentage) / 100;
        riskAmountController.text = riskAmount.toStringAsFixed(2);
      }
    }
  }

  void _calculateQuantity() {
    if (riskAmountController.text.isNotEmpty &&
        entryPriceController.text.isNotEmpty &&
        stopLossController.text.isNotEmpty) {
      double riskAmount = double.tryParse(riskAmountController.text) ?? 0.0;
      double entry = double.tryParse(entryPriceController.text) ?? 0.0;
      double stopLoss = double.tryParse(stopLossController.text) ?? 0.0;

      if (riskAmount > 0 && entry > 0 && stopLoss > 0) {
        // Calculate risk per share
        double riskPerShare =
            isBuySelected ? (entry - stopLoss).abs() : (stopLoss - entry).abs();

        // If risk per share is too small, avoid division by zero
        if (riskPerShare < 0.01) return;

        // Calculate position size (quantity)
        double quantity = riskAmount / riskPerShare;

        // Update quantity controller
        positionSizeController.text = quantity.toStringAsFixed(0);
      }
    }
  }

  void _calculateProfitLoss() {
    if (positionSizeController.text.isNotEmpty &&
        entryPriceController.text.isNotEmpty &&
        actualExitController.text.isNotEmpty) {
      double quantity = double.tryParse(positionSizeController.text) ?? 0.0;
      double entry = double.tryParse(entryPriceController.text) ?? 0.0;
      double exit = double.tryParse(actualExitController.text) ?? 0.0;

      if (quantity > 0 && entry > 0 && exit > 0) {
        // For Buy: P/L = (Exit - Entry) * Quantity
        // For Sell: P/L = (Entry - Exit) * Quantity
        double pl = (isBuySelected)
            ? (exit - entry) * quantity
            : (entry - exit) * quantity;

        // Format with comma for thousands
        String formattedPL = pl.toStringAsFixed(0);
        if (pl >= 0) {
          profitLossController.text = formattedPL;
        } else {
          profitLossController.text = "-${formattedPL.replaceAll('-', '')}";
        }
      }
    }
  }

  void _calculateRiskReward() {
    if (entryPriceController.text.isNotEmpty &&
        stopLossController.text.isNotEmpty &&
        actualExitController.text.isNotEmpty) {
      double entry = double.tryParse(entryPriceController.text) ?? 0.0;
      double stopLoss = double.tryParse(stopLossController.text) ?? 0.0;
      double exit = double.tryParse(actualExitController.text) ?? 0.0;

      if (entry > 0 && stopLoss > 0 && exit > 0) {
        // Calculate the risk (distance from entry to stop loss)
        double risk = (isBuySelected)
            ? (entry - stopLoss).abs()
            : (stopLoss - entry).abs();

        // Calculate the reward (distance from entry to exit)
        double reward =
            (isBuySelected) ? (exit - entry).abs() : (entry - exit).abs();

        if (risk > 0) {
          double ratio = reward / risk;
          riskRewardController.text = "1:${ratio.toStringAsFixed(1)}";
        }
      }
    }
  }

  void _calculateTargets() {
    if (entryPriceController.text.isNotEmpty &&
        stopLossController.text.isNotEmpty) {
      double entry = double.tryParse(entryPriceController.text) ?? 0.0;
      double stopLoss = double.tryParse(stopLossController.text) ?? 0.0;

      if (entry > 0 && stopLoss > 0) {
        // Calculate the risk (distance from entry to stop loss)
        double risk = (isBuySelected)
            ? (entry - stopLoss).abs()
            : (stopLoss - entry).abs();

        // Calculate targets based on risk:reward ratios
        // Target 1 (1:2 R:R)
        double target1 =
            isBuySelected ? entry + (risk * 2) : entry - (risk * 2);

        // Target 2 (1:3 R:R)
        double target2 =
            isBuySelected ? entry + (risk * 3) : entry - (risk * 3);

        // Update target controllers
        targetOneController.text = target1.toStringAsFixed(2);
        targetTwoController.text = target2.toStringAsFixed(2);
      }
    }
  }

  void _setupAutoCalculationListeners() {
    // Listen for changes to calculate risk amount
    capitalAmountController.addListener(_calculateRiskAmount);
    riskPercentageController.addListener(_calculateRiskAmount);

    // Listen for changes to calculate targets when entry or stop-loss changes
    entryPriceController.addListener(_calculateTargets);
    stopLossController.addListener(_calculateTargets);

    // Listen for changes to calculate risk-reward ratio
    entryPriceController.addListener(_calculateRiskReward);
    stopLossController.addListener(_calculateRiskReward);
    actualExitController.addListener(_calculateRiskReward);

    // Listen for changes to calculate profit/loss
    positionSizeController.addListener(_calculateProfitLoss);
    entryPriceController.addListener(_calculateProfitLoss);
    actualExitController.addListener(_calculateProfitLoss);

    // Listen for changes to calculate quantity
    riskAmountController.addListener(_calculateQuantity);
    entryPriceController.addListener(_calculateQuantity);
    stopLossController.addListener(_calculateQuantity);
  }

  void toggleTradeDirection(bool isBuy) {
    if (isBuySelected != isBuy) {
      isBuySelected = isBuy;
      // Recalculate values when trade direction changes
      _calculateQuantity();
      _calculateRiskReward();
      _calculateProfitLoss();
      _calculateTargets();
     onTradeDirectionChanged(); // Trigger UI update
    }
  }

  void clearControllers() {
    // Clear all text controllers
    capitalAmountController.clear();
    notesController.clear();
    riskPercentageController.clear();
    entryPriceController.clear();
    tradingSymbolController.clear();
    stopLossController.clear();
    riskAmountController.clear();
    targetOneController.clear();
    targetTwoController.clear();
    riskRewardController.clear();
    profitLossController.clear();
    actualExitController.clear();
    positionSizeController.clear();

    // Reset state variables
    selectedDate = DateTime.now();
    isBuySelected = true;

    // Trigger the callback to update UI
    onTradeDirectionChanged();
  }

  Future<TradingJournalModel> buildRequestModel() async {
    final UserSecureStorageService commonDetails = UserSecureStorageService();
    final String mobileUserPublicKey = await commonDetails.getPublicKey();

    return TradingJournalModel(
      id: journalId,
      symbol: tradingSymbolController.text,
      mobileUserKey: mobileUserPublicKey,
      capitalAmount: double.tryParse(capitalAmountController.text) ?? 0.0,
      riskPercentage: double.tryParse(riskPercentageController.text) ?? 0.0,
      riskAmount: double.tryParse(riskAmountController.text) ?? 0.0,
      entryPrice: double.tryParse(entryPriceController.text) ?? 0.0,
      stopLoss: double.tryParse(stopLossController.text) ?? 0.0,
      target1: double.tryParse(targetOneController.text) ?? 0.0,
      target2: double.tryParse(targetTwoController.text) ?? 0.0,
      notes: notesController.text,
      positionSize: double.tryParse(positionSizeController.text) ?? 0.0,
      profitLoss: profitLossController.text,
      actualExit: double.tryParse(actualExitController.text) ?? 0.0,
      riskReward: riskRewardController.text,
      startDate: selectedDate.toIso8601String(),
      buySellButton: isBuySelected,
    );
  }

  void dispose() {
    // Remove listeners to prevent memory leaks
    capitalAmountController.removeListener(_calculateRiskAmount);
    riskPercentageController.removeListener(_calculateRiskAmount);
    entryPriceController.removeListener(_calculateRiskReward);
    stopLossController.removeListener(_calculateRiskReward);
    actualExitController.removeListener(_calculateRiskReward);
    positionSizeController.removeListener(_calculateProfitLoss);
    entryPriceController.removeListener(_calculateProfitLoss);
    actualExitController.removeListener(_calculateProfitLoss);
    entryPriceController.removeListener(_calculateTargets);
    stopLossController.removeListener(_calculateTargets);
    riskAmountController.removeListener(_calculateQuantity);
    entryPriceController.removeListener(_calculateQuantity);
    stopLossController.removeListener(_calculateQuantity);

    // Dispose controllers
    targetTwoController.dispose();
    targetOneController.dispose();
    tradingSymbolController.dispose();
    notesController.dispose();
    capitalAmountController.dispose();
    riskAmountController.dispose();
    riskRewardController.dispose();
    stopLossController.dispose();
    entryPriceController.dispose();
    riskPercentageController.dispose();
    profitLossController.dispose();
    actualExitController.dispose();
    positionSizeController.dispose();
  }
}
