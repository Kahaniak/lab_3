abstract class DayForecastEvent {}

class GetWeekForecast extends DayForecastEvent {
  final double latitude;
  final double longitude;
  final String city;

  GetWeekForecast(this.latitude, this.longitude, this.city);
}
