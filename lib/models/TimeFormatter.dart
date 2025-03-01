import 'package:intl/intl.dart';

class TimeFormatter {
  static String getFormattedTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inSeconds < 60) {
      return "il y a quelques secondes";
    } else if (difference.inMinutes < 60) {
      return "il y a ${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''}";
    } else if (difference.inHours < 24) {
      return "il y a ${difference.inHours} heure${difference.inHours > 1 ? 's' : ''}";
    } else {
      return DateFormat('dd/MM/yyyy HH:mm').format(time);
    }
  }
   static String format(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }
}

