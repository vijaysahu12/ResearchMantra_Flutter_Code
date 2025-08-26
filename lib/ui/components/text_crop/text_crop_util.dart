// utils/string_utils.dart

import 'package:flutter/material.dart';

class TextStringUtils {
  static String getMessagePreview(
      String description, int maxLength, int previewLength, int lastLength) {
    try {
      if (description.length > maxLength) {
        String firstPart = description.substring(0, previewLength);
        String lastPart =
            description.substring(description.length - lastLength);
        return '$firstPart **** $lastPart';
      } else {
        return description;
      }
    } catch (e) {
      print('Error processing description: $e');
      return description;
    }
  }
}


//Class for colors
class ColorCheckUtils{
  //get Colors
    Color getTextColor(String value,theme) {
      try {
        final textColor = value.startsWith('-')
            ? theme.disabledColor
            : theme.secondaryHeaderColor;
        return textColor;
      } catch (e) {
        print('Error determining text color: $e');
        return theme.primaryColorDark;
      }
    }

//Get arrow icon
    IconData getArrowIcon(String value) {
      return value.startsWith('-') ? Icons.arrow_downward : Icons.arrow_upward;
    }
}
