import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_3/models/day_forecast.dart';
import 'package:lab_3/repos/forecast_repo.dart';

import 'day_forecast_event.dart';
import 'day_forecast_state.dart';

class DayForecastBloc extends Bloc<DayForecastEvent, DayForecastState> {
  DayForecastBloc() : super(null);

  @override
  DayForecastState get initialState => DayForecastLoading();

  var repository = DayForecastRepository();

  @override
  Stream<DayForecastState> mapEventToState(DayForecastEvent event) async* {
    if (event is GetWeekForecast) {
      yield DayForecastLoading();
      List<DayForecast> weekForecast = await repository.getWeekForecast(event.latitude, event.longitude, event.city);
      yield WeekForecastLoaded(weekForecast);
    }
  }
}
