import 'package:equatable/equatable.dart';

abstract class CityEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddCity extends CityEvent {
  final String name;

  AddCity(this.name);

  @override
  List<Object> get props => [name];
}

class DeleteCityByName extends CityEvent {
  final String cityName;

  DeleteCityByName(this.cityName);

  @override
  List<Object> get props => [cityName];
}

class FetchCities extends CityEvent {}
