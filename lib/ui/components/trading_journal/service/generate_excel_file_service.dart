
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:research_mantra_official/data/models/trading_journal/trading_journal_model.dart';
import 'package:research_mantra_official/utils/toast_utils.dart';
import 'package:path_provider/path_provider.dart';

import 'package:share_plus/share_plus.dart';

class ExcelGenerator {
  static Future<String?> generateExcel(List<TradingJournalModel> journals) async {

    try {
      // Create a new Excel document
      final excel = Excel.createExcel();
      
      // Delete the default sheet and create a new one named 'Trading Journal'
      
      final Sheet sheet = excel['Trading Journal'];

      // Add headers
      final List<String> headers = [
        'S.No', 'Date','Symbol', 'Buy/Sell', 'Capital Amount', 
        'Risk Percentage', 'Risk Amount', 'Entry Price', 'Stop Loss', 'Target 1', 
        'Target 2', 'Position Size', 'Actual Exit', 'Profit/Loss', 
        'Risk/Reward', 'Notes'
      ];

      // Add headers to the first row
      for (int i = 0; i < headers.length; i++) {
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
          .value = TextCellValue(headers[i]);
      }

      // Add data rows
      for (int i = 0; i < journals.length; i++) {
        final journal = journals[i];
        final int rowIndex = i + 1;
        
        // Index
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex))
            .value =  IntCellValue(i+1);
        
        // Date
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex))
            .value = TextCellValue(journal.startDate?.toString() ?? "");
        

        // Symbol
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex))
            .value = TextCellValue(journal.symbol?.toString() ?? "");
        
        // Buy/Sell
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex))
            .value = TextCellValue(journal.buySellButton == true ? "Buy" : "Sell");
        
        // Capital Amount
        if (journal.capitalAmount != null) {
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: rowIndex))
              .value = DoubleCellValue(journal.capitalAmount ?? 0.0);
        }
        
        // Risk %
        if (journal.riskPercentage != null) {
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: rowIndex))
              .value = DoubleCellValue(journal.riskPercentage ?? 0.0);
        }
        
        // Risk Amount
        if (journal.riskAmount != null) {
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: rowIndex))
              .value = DoubleCellValue(journal.riskAmount ?? 0);
        }
        
        // Entry Price
        if (journal.entryPrice != null) {
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: rowIndex))
              .value = DoubleCellValue(journal.entryPrice ?? 0);
        }
        
        // Stop Loss
        if (journal.stopLoss != null) {
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: rowIndex))
              .value = DoubleCellValue(journal.stopLoss ?? 0);
        }
        
        // Target 1
        if (journal.target1 != null) {
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: rowIndex))
              .value = DoubleCellValue(journal.target1 ?? 0);
        }
        
        // Target 2
        if (journal.target2 != null) {
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: 10, rowIndex: rowIndex))
              .value = DoubleCellValue(journal.target2 ?? 0);
        }
        
        // Position Size
        if (journal.positionSize != null) {
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: 11, rowIndex: rowIndex))
              .value = DoubleCellValue(journal.positionSize ?? 0);
        }
        
        // Actual Exit
        if (journal.actualExit != null) {
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: 12, rowIndex: rowIndex))
              .value = DoubleCellValue(journal.actualExit ?? 0);
        }
        
        // Profit/Loss
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 13, rowIndex: rowIndex))
            .value = TextCellValue(journal.profitLoss?.toString() ?? "");
        
        // Risk/Reward
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 14, rowIndex: rowIndex))
            .value = TextCellValue(journal.riskReward?.toString() ?? "");
        
        // Notes
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 15, rowIndex: rowIndex))
            .value = TextCellValue(journal.notes?.toString() ?? "");
      }
      excel.delete('Sheet1');

      // Save the Excel file
      final fileName = 'My_Trading_journal_${DateTime.now().millisecondsSinceEpoch}.xlsx';
      final fileBytes = excel.encode();
      if (fileBytes == null) {
         ToastUtils.showToast("Failed to generate Excel file", "Error");
        return null;
      }

      // Get directory for storage
      final directory = await _getExcelSaveDirectory();
      if (directory == null) {
        ToastUtils.showToast("Storage directory not found", "Error");
        return null;
      }

      // Create and write to file
      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(fileBytes);
      
      // Share the file
      await _shareExcelFile(file.path);
      ToastUtils.showToast("Excel file exported successfully", "Success");
      return file.path;
    } catch (e) {
      ToastUtils.showToast("Error generating or sharing file", "Error");
      return null;
    }
  }

  // Get appropriate directory based on platform
  static Future<Directory?> _getExcelSaveDirectory() async {

    if (Platform.isAndroid) {
      // Request storage permission on Android
      // if (await Permission.storage.request().isGranted) {
      return await getExternalStorageDirectory();
      // } else {
      //   return null;
      // }
    } else if (Platform.isIOS) {
      return await getApplicationDocumentsDirectory();
    } else {
      return await getApplicationDocumentsDirectory();
    }
  }
  // For Sharing the file
  // Share the Excel file
  static Future<void> _shareExcelFile(String filePath) async {
    try {
      await Share.shareXFiles(
        [XFile(filePath)],
        text: 'Trading Journal Export',
      );
    } catch (e) {
      print('Error sharing file: $e');
    }
  } 
  
}