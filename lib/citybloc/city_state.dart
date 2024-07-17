import 'package:equatable/equatable.dart';
import 'package:weather_app/model/location_model.dart';

abstract class CityState extends Equatable {
  @override
  List<Object> get props => [];
}

class CityInitial extends CityState {}

class CityLoading extends CityState {}

class CityLoaded extends CityState {
  final List<City> cities;

  CityLoaded(this.cities);

  @override
  List<Object> get props => [cities];
}

class CityError extends CityState {
  final String error;

  CityError(this.error);

  @override
  List<Object> get props => [error];
}
