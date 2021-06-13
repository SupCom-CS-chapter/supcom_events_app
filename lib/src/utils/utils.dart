import 'package:intl/intl.dart';

class Utils {


  static String toDate(DateTime dateTime) {
    return DateFormat.yMMMEd().format(dateTime);
  } 

  static String toTime(DateTime dateTime) {
    return DateFormat.Hm().format(dateTime);
  }

  static String toDateTime(DateTime dateTime) {
    return '${toDate(dateTime)} ${toTime(dateTime)}';
  }

  static DateTime parse({String date = '', String time = ''}){
    String formattedTime = '';
    if(time.length == 4){
      if(time.indexOf(':') == 2) 
        formattedTime += time.substring(0,3) + '0' + time[3] + '00';
      else
        formattedTime = '0' + time + ':00';
    } else if (time.length == 3) {
      formattedTime += '0' + time.substring(0,2) + '0' + time[2] + '00';
    } else {
      formattedTime += time + ':00';
    }

    return DateFormat('EEE, MMM dd, yyyy hh:mm:ss').parse('$date $formattedTime:00');
  }

}