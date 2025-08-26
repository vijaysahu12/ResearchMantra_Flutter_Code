import 'package:intl/intl.dart';

class ConvertdateAndTime {
//Converting date and time.
  String convertDateTime(String dateTimeString) {
    DateFormat inputFormat = DateFormat('yy-MM-dd HH:mm:ss');
    DateFormat outputFormat = DateFormat('HH:mm dd-MMM');
    try {
      DateTime dateTime = inputFormat.parse(dateTimeString);
      return outputFormat.format(dateTime);
    } catch (e) {
      return "--";
    }
  }
}
