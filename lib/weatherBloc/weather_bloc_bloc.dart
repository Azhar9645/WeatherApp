import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/constants/constants.dart';
import 'dart:convert';

import 'package:weather_app/model/weather_model.dart';

part 'weather_bloc_event.dart';
part 'weather_bloc_state.dart';

class WeatherBlocBloc extends Bloc<WeatherBlocEvent, WeatherBlocState> {
  WeatherBlocBloc() : super(WeatherBlocInitial()) {
    on<FetchWeather>((event, emit) async {
      emit(WeatherBlocLoading());
      try {
        final response = await http.get(Uri.parse(
            'https://api.openweathermap.org/data/2.5/weather?lat=${event.position.latitude}&lon=${event.position.longitude}&appid=$Api_Key&units=metric'));

        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);
          final weather = Weather.fromJson(jsonData);

          emit(WeatherBlocSuccess(weather));
          print('City: ${weather.cityName}');
          print('Date Time: ${weather.datetime}');
        } else {
          emit(WeatherBlocFailure());
        }
      } catch (e) {
        emit(WeatherBlocFailure());
      }
    });
    on<FetchWeatherByCityName>((event, emit) async {
      emit(WeatherBlocLoading());
      try {
        final response = await http.get(Uri.parse(
            'https://api.openweathermap.org/data/2.5/weather?q=${event.cityName}&appid=$Api_Key&units=metric'));

        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);
          final weather = Weather.fromJson(jsonData);

          emit(WeatherBlocSuccess(weather));
          print('City: ${weather.cityName}');
          print('Date Time: ${weather.datetime}');
        } else {
          emit(WeatherBlocFailure());
        }
      } catch (e) {
        emit(WeatherBlocFailure());
      }
    });
  }
}
