import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/model/location_model.dart';

class CityService {
  final String baseUrl = 'http://192.168.1.37:3000';

  Future<void> addCity(String name) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/addCity'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
            {'name': name, 'datetime': DateTime.now().toIso8601String()}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to add city: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error in addCity: $e');
      throw Exception('Failed to add city: $e');
    }
  }

  Future<List<City>> getCities() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/getCities'));

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        print('Fetched cities: $body'); // Debug print

        List<City> cities =
            body.map((dynamic item) => City.fromJson(item)).toList();
        return cities;
      } else {
        throw Exception('Failed to load cities: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error in getCities: $e');
      throw Exception('Failed to load cities: $e');
    }
  }

  Future<void> deleteCityByName(String name) async {
  try {
    final response = await http.delete(
      Uri.parse('$baseUrl/deleteCity/$name'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete city: ${response.reasonPhrase}');
    }
  } catch (e) {
    print('Error in deleteCityByName: $e');
    throw Exception('Failed to delete city: $e');
  }
}

}
