import 'package:bloc/bloc.dart';
import 'package:weather_app/services/cityService.dart';
import 'city_event.dart';
import 'city_state.dart';

class CityBloc extends Bloc<CityEvent, CityState> {
  final CityService cityService;

  CityBloc(this.cityService) : super(CityInitial()) {
    on<AddCity>((event, emit) async {
      try {
        emit(CityLoading());
        await cityService.addCity(event.name);
        final cities = await cityService.getCities();
        emit(CityLoaded(cities));
      } catch (error) {
        emit(CityError(error.toString()));
      }
    });

    on<FetchCities>((event, emit) async {
      try {
        emit(CityLoading());
        final cities = await cityService.getCities();
        emit(CityLoaded(cities));
      } catch (error) {
        emit(CityError(error.toString()));
      }
    });

    on<DeleteCityByName>((event, emit) async {
      try {
        await cityService.deleteCityByName(event.cityName);
        final cities = await cityService.getCities();
        emit(CityLoaded(cities));
      } catch (e) {
        emit(CityError(e.toString()));
      }
    });
  }
}
