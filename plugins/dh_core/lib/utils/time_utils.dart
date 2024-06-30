import 'package:intl/intl.dart';

///时间辅助类
import 'package:intl/intl.dart';

class TimeUtils {
  static String? getUtcTime(String timeStr) {

  }
  static String formatEN(DateTime dateTime){
    return format('yyyy-MM-dd HH:mm:ss', dateTime);
  }

  static String format(String formatStr, DateTime dateTime){
    return DateFormat(formatStr).format(dateTime);
  }

  ///输入yyyyMMddTHHmmssZ，输出DateTime
  static DateTime utcStringToLocalDateTime(String time) {
    return DateTime.parse(time.substring(0, time.length -1)).toLocal();
  }

  ///输入yyyyMMddTHHmmssZ，输出时间戳
  static int utcStringToLocalDateStamp(String time) {
    var dateTime = DateTime.parse(time.substring(0, time.length -1));
    return dateTime.add(dateTime.timeZoneOffset).millisecondsSinceEpoch ~/ 1000;
  }

  ///输入时间戳，输出yyyyMMddTHHmmssZ
  static String timeStampToUtcString(int stamp, {isUtc = false, isStamp = true}) {
    var dateTime = DateTime.fromMillisecondsSinceEpoch(isStamp ? stamp * 1000 : stamp, isUtc: isUtc);
    return "${dateTime.year}${twoDigits(dateTime.month)}${twoDigits(dateTime.day)}T"
        "${twoDigits(dateTime.hour)}${twoDigits(dateTime.minute)}${twoDigits(dateTime.second)}Z";
  }

  ///获取当前0时的时间戳
  static int getTodayTimeStamp() {
    DateTime now = DateTime.now();
    return DateTime(now.year, now.month, now.day).millisecondsSinceEpoch ~/ 1000;
  }

  ///输入时间戳，输出 HH:mm:ss
  static String getTimeByStamp(int stamp, {isUtc = false, isStamp = true}) {
    var dateTime = DateTime.fromMillisecondsSinceEpoch(isStamp ? stamp * 1000 : stamp, isUtc: isUtc);
    return "${twoDigits(dateTime.hour)}:${twoDigits(dateTime.minute)}:${twoDigits(dateTime.second)}";
  }

  ///返回utc时间格式 yyyy-MM-ddTHH:mm:ssZ
  static String getUtcDateFromDate(DateTime time) {
    var newTime = time.toUtc();
    return "${newTime.year}${twoDigits(newTime.month)}${twoDigits(newTime.day)}"
        "T${twoDigits(newTime.hour)}${twoDigits(newTime.minute)}${twoDigits(newTime.second)}Z";
  }

  ///返回时间字符串，用于文件名,yyyyMMddHHmmss
  static String getTimeFileNameString() {
    DateTime newTime = DateTime.now();
    return "${newTime.year}${twoDigits(newTime.month)}${twoDigits(newTime.day)}"
        "${twoDigits(newTime.hour)}${twoDigits(newTime.minute)}${twoDigits(newTime.second)}";
  }

  static String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  static String getDateStrEN(int time){
    final f = new DateFormat('yyyy-MM-dd HH:mm:ss');
    var now = DateTime.fromMillisecondsSinceEpoch(time);
    return f.format(now);
  }

  static DateTime getDateTime(String timeStr, String format){
    final f = new DateFormat(format);
    return f.parse(timeStr);
  }

  ///返回utc时间格式 yyyy-MM-ddTHH:mm:ssZ
  static String getUtcDateFromTime(int time) {
    var newTime = DateTime.fromMillisecondsSinceEpoch(time).toUtc();
    return "${newTime.year}${twoDigits(newTime.month)}${twoDigits(newTime.day)}"
        "T${twoDigits(newTime.hour)}${twoDigits(newTime.minute)}${twoDigits(newTime.second)}Z";
  }
}