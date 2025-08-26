import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/data/models/trading_journal/trading_journal_model.dart';
import 'package:research_mantra_official/providers/trading_journal/post/trading_journal_provider.dart';
import 'package:research_mantra_official/ui/components/button.dart';
import 'package:research_mantra_official/ui/components/trading_journal/screens/trading_journal_entries/entries_class.dart';
import 'package:research_mantra_official/ui/components/trading_journal/screens/trading_journal_entries/trading_form_controller.dart';
import 'package:research_mantra_official/ui/components/trading_journal/widgets/buy_sell_button.dart';

import 'package:research_mantra_official/ui/components/trading_journal/widgets/trading_date_picker.dart';
import 'package:research_mantra_official/utils/toast_utils.dart';

// Main Screen Widget
class TradingJournalEntries extends ConsumerStatefulWidget {
  final bool? isFromEditingScreen;
  final TradingJournalModel? journalToEdit;
  
  const TradingJournalEntries({
    super.key, 
    this.journalToEdit, 
    this.isFromEditingScreen
  });
  
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TradingJournalEntriesState();
}

class _TradingJournalEntriesState extends ConsumerState<TradingJournalEntries> {
  late final TradingFormController _formController;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _formController = TradingFormController(
      onTradeDirectionChanged: () => setState(() {}),
      journalToEdit: widget.journalToEdit,
      isFromEditingScreen: widget.isFromEditingScreen,
    );
  }

  @override
  void dispose() {
    _formController.dispose();
    super.dispose();
  }

  Future<void> _saveEntry() async {
    if (!_formKey.currentState!.validate()) {
      ToastUtils.showToast("Please fill all required fields correctly.", "");
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final request = await _formController.buildRequestModel();
      
      if (widget.journalToEdit?.id == null) {
        await ref
            .read(tradingJournalStateNotifierProvider.notifier)
            .postTradingJournal(request);
      } else {
        await ref
            .read(tradingJournalStateNotifierProvider.notifier)
            .editTradingJournalList(request);
      }

      // CLEAN SOLUTION: Clear controllers and create new form key
      _formController.clearControllers();
      _formKey = GlobalKey<FormState>(); // Create new form key to reset everything
      
      setState(() {
        // Single setState to update UI with cleared form
      });

      ToastUtils.showToast(
          widget.journalToEdit != null
              ? "Entry updated successfully"
              : "Entry saved successfully",
          "");

      if (widget.isFromEditingScreen == true) {
        Navigator.of(context).pop();
      }
    } catch (error) {
      ToastUtils.showToast("Error occurred: $error", "");
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: theme.primaryColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: theme.primaryColor,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      widget.journalToEdit != null
                          ? 'Edit Stock Entry'
                          : 'Add Stock Entry',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: theme.primaryColorDark,
                          fontFamily: '1'),
                    ),
                    const SizedBox(height: 8),
                    
                    // Buy/Sell Button Section
                    BuySellButton(
                      theme: theme,
                      isBuySelected: _formController.isBuySelected,
                      onToggle: _formController.toggleTradeDirection,
                    ),
                    const SizedBox(height: 10),
                    
                    // Symbol Input Section
                    SymbolInputSection(controller: _formController),
                    const SizedBox(height: 8),
                    

                  ],
                ),
              ),
            ),
            
            // Date Picker Section
            TradingDatePicker(
              date: _formController.selectedDate,
              onDateChanged: (newDate) {
                setState(() {
                  _formController.selectedDate = newDate;
                });
              },
            ),
            
            // Save Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Button(
                  text: widget.journalToEdit != null
                      ? "Update Entry"
                      : "Save Entry",
                  onPressed: _isSubmitting
                      ? () {} // Empty function when submitting
                      : () {
                          FocusScope.of(context).unfocus();
                          _saveEntry();
                        },
                  backgroundColor: _isSubmitting
                      ? theme.indicatorColor
                          .withAlpha(180) // Dimmed when submitting
                      : theme.indicatorColor,
                  textColor: theme.primaryColor),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

