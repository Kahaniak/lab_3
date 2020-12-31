import 'package:intl/intl.dart';

class DayForecast {
  final String dayName;
  final String date;
  final double temperature;
  final String city;

  DayForecast({this.dayName, this.date, this.temperature, this.city});

  factory DayForecast.fromJson(String city, Map json) {
    return DayForecast(
      date: json["time"].replaceAll("-", ".").substring(0, 10),
      dayName: DateFormat('EEEE').format(DateTime.parse(json["time"])), //"2012-02-27 13:27:00"
      temperature: json["data"]["instant"]["details"]["air_temperature"],
      city: city,
    );
  }
}
