import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtils {
  static void showToast(String message, String? messageType) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: getColorCode(messageType),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  static getColorCode(String? messageType) {
    if (messageType == 'error') {
      return Colors.red[200];
    } else if (messageType == 'success') {
      return Colors.green[200];
    } else if (messageType == 'info') {
      return Colors.yellow[200];
    } else {
      // return Colors.yellow[200];
      return const Color.fromARGB(255, 69, 64, 64);
    }
  }
}

// class SnackBarUtils {
//   static void showSnackBar(BuildContext context, String message,
//       {String? messageType}) {
//     final backgroundColor = getColorCode(messageType);

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           message,
//           style: const TextStyle(color: Colors.white, fontSize: 16),
//         ),
//         backgroundColor: backgroundColor,
//         behavior: SnackBarBehavior.floating, // Makes it float above UI
//         duration: const Duration(seconds: 5), // Auto-dismiss after 3 seconds
//       ),
//     );
//   }

//   static Color getColorCode(String? messageType) {
//     switch (messageType) {
//       case 'error':
//         return Colors.red[400]!;
//       case 'success':
//         return Colors.green[400]!;
//       case 'info':
//         return Colors.blue[400]!;
//       default:
//         return const Color.fromARGB(255, 69, 64, 64); // Default dark color
//     }
//   }
// }
