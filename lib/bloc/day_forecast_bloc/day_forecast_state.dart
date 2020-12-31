import 'package:lab_3/models/day_forecast.dart';

abstract class DayForecastState {}

class DayForecastLoading extends DayForecastState {}

class WeekForecastLoaded extends DayForecastState {
  final List<DayForecast> weekForecast;

  WeekForecastLoaded(this.weekForecast);
}

class DayForecastError extends DayForecastState {}