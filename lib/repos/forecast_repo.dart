import 'dart:convert';
import 'dart:io';

import 'package:lab_3/models/day_forecast.dart';
import 'package:http/http.dart' as http;

class DayForecastRepository {

  Future<List<DayForecast>> getWeekForecast(double latitude, double longitude, String city) async {
    var response = await http.get(
      "https://api.met.no/weatherapi/locationforecast/2.0/complete?lat=$latitude&lon=$longitude",
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
      },
    );

    var fullJson = json.decode(response.body);
    var weekForecastJson = fullJson["properties"]["timeseries"].where((dayForecast) => dayForecast["time"].substring(11, 13) == "12").toList();
    var threeDaysForecastJson = weekForecastJson.getRange(0, 3).toList();

    List<DayForecast> threeDaysForecast = threeDaysForecastJson.map<DayForecast>((x) => DayForecast.fromJson(city, x)).toList();
    return threeDaysForecast;
  }
}
