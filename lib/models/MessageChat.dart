
import 'package:terangaconnect/models/TimeFormatter.dart';

class MessageChat {
  final String text;
  final DateTime timestamp;
  final bool isUserMessage;

  MessageChat({
    required this.text, 
    required this.timestamp, 
    required this.isUserMessage
  });
  
  String get formattedTime => TimeFormatter.getFormattedTime(timestamp);
}
