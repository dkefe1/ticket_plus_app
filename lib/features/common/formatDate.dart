import 'package:intl/intl.dart';

String formatDate(String date) {
  DateTime dateTime = DateTime.parse(date);
  String formattedDate = DateFormat('dd MMM, yyyy').format(dateTime);
  String time = DateFormat('h:mm a').format(dateTime);
  return (formattedDate + " - " + time);
}

String formatMonthAndDate(String date) {
  DateTime dateTime = DateTime.parse(date);
  String formattedDate = DateFormat('MMMM d').format(dateTime);
  return formattedDate;
}

String formatDOB(String date) {
  DateTime dateTime = DateTime.parse(date);
  String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
  return formattedDate;
}

String formatDateMMMddyyyy(String date) {
  DateTime dateTime = DateTime.parse(date);
  String formattedDate = DateFormat('MMM dd, yyyy').format(dateTime);
  return formattedDate;
}

String formatTime(String time) {
  DateTime dateTime = DateTime.parse(time);
  String formattedTime = DateFormat('HH:mm').format(dateTime);
  return formattedTime;
}

String formatMyDate(String date) {
  DateTime dateTime = DateTime.parse(date);
  String formattedDate = DateFormat('d MMM y').format(dateTime);
  return formattedDate;
}
