import 'package:flutter/material.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/data/models/invoice/invoices_response_model.dart';
import 'package:research_mantra_official/ui/components/button.dart';

class InvoicePaymentHistoryCard extends StatelessWidget {
  final GetInvoicesModel payment;
  final void Function(String downloadUrl, String productName) onDownload;
  final void Function(String text) onCopy;

  const InvoicePaymentHistoryCard({
    super.key,
    required this.payment,
    required this.onDownload,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fontSize = MediaQuery.of(context).size.width * 0.1;

    // Extracted fields with default fallbacks
    final productName = payment.productName ?? '';
    final transactionId = payment.transasctionReference ?? '';
    final startDate = payment.startDate ?? '';
    final endDate = payment.endDate ?? '';
    final paymentDate = payment.paymentDate ?? '';
    final paidAmount = payment.paidAmount ?? '0';
    final downloadUrl = payment.downloadUrl ?? '';

    final labelStyle = TextStyle(
      fontSize: fontSize * 0.3,
      color: theme.focusColor,
      fontWeight: FontWeight.w500,
    );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      padding: const EdgeInsets.all(8),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Product Name + Paid Tag
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  productName,
                  style: TextStyle(
                    fontSize: fontSize * 0.32,
                    fontWeight: FontWeight.w600,
                    color: theme.primaryColorDark,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.secondaryHeaderColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Paid',
                  style: TextStyle(
                    fontSize: fontSize * 0.23,
                    fontWeight: FontWeight.bold,
                    color: theme.floatingActionButtonTheme.foregroundColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 5),

          // 🔹 Paid Amount
          _infoRow(paidAmountText, 'Rs $paidAmount', labelStyle,
              theme.secondaryHeaderColor),

          // 🔹 Paid At
          _infoRow(paidOnText, paymentDate, labelStyle),

          // 🔹 Service Period
          _infoRow(servicePeriodText, '$startDate To $endDate', labelStyle),

          // 🔹 Transaction ID + Copy
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(transactionIdText, style: labelStyle),
              Row(
                children: [
                  Text(transactionId, style: labelStyle),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => onCopy(transactionId),
                    child: Icon(Icons.copy, size: 16, color: theme.focusColor),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),

          // 🔹 Download Invoice Button
          Row(
            children: [
              Expanded(
                child: Button(
                  text: downloadInvoiceButton,
                  onPressed: () => onDownload(downloadUrl, productName),
                  backgroundColor: theme.indicatorColor.withOpacity(0.7),
                  textColor: theme.floatingActionButtonTheme.foregroundColor ??
                      Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, TextStyle labelStyle,
      [Color? valueColor]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: labelStyle),
          Text(
            value,
            style: labelStyle.copyWith(
              color: valueColor ?? labelStyle.color,
            ),
          ),
        ],
      ),
    );
  }
}
