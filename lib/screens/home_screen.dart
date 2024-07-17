import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/services/cityService.dart';
import 'package:weather_app/weatherBloc/weather_bloc_bloc.dart';
import 'package:weather_app/screens/saved_screen.dart';

class HomeScreen extends StatelessWidget {
  final Position initialPosition;
  final String cityName;
  final CityService cityService = CityService();

  HomeScreen({required this.initialPosition, required this.cityName});

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
        title: Row(
          children: [
            Expanded(
              child: Container(
                height: 40,
                child: CupertinoTextField(
                  controller: _searchController,
                  placeholder: 'Search',
                  onChanged: (query) {
                    // Handle search query changes
                    BlocProvider.of<WeatherBlocBloc>(context)
                        .add(FetchWeatherByCityName(query));
                  },
                  onSubmitted: (query) {
                    // Handle search query submitted
                    BlocProvider.of<WeatherBlocBloc>(context)
                        .add(FetchWeatherByCityName(query));
                  },
                  decoration: BoxDecoration(
                    color:
                        const Color.fromARGB(255, 95, 31, 31).withOpacity(0.4),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  prefix: const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Icon(
                      CupertinoIcons.search,
                      color: Colors.grey,
                    ),
                  ),
                  suffix: GestureDetector(
                    onTap: () {
                      // Clear the text field and fetch weather with initial position
                      _searchController.clear();
                      BlocProvider.of<WeatherBlocBloc>(context)
                          .add(FetchWeather(initialPosition));
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Icon(
                        CupertinoIcons.xmark_circle_fill,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SavedScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus(); // Hide the keyboard
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40, 1.5 * kToolbarHeight, 40, 20),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Align(
                  alignment: const AlignmentDirectional(3, -0.3),
                  child: Container(
                    height: 300,
                    width: 300,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromRGBO(116, 23, 7, 1),
                    ),
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(-3, -0.3),
                  child: Container(
                    height: 300,
                    width: 300,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromRGBO(116, 23, 7, 1),
                    ),
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(0, -1.2),
                  child: Container(
                    height: 300,
                    width: 700,
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(194, 74, 41, 1),
                    ),
                  ),
                ),
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.transparent),
                  ),
                ),
                BlocBuilder<WeatherBlocBloc, WeatherBlocState>(
                  builder: (context, state) {
                    if (state is WeatherBlocSuccess) {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '📍 ${state.weather.cityName}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 25,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.home,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                        onPressed: () {
                                          _searchController.clear();
                                          BlocProvider.of<WeatherBlocBloc>(
                                                  context)
                                              .add(FetchWeather(
                                                  initialPosition));
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.bookmark,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                        onPressed: () async {
                                          final cityName =
                                              state.weather.cityName;
                                          try {
                                            await cityService.addCity(cityName);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      'City saved successfully')),
                                            );
                                          } catch (error) {
                                            print(
                                                'Error: $error'); // Log the error
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      'Failed to save city: $error')),
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              Center(
                                child: Lottie.asset(
                                  getWeatherAnimation(
                                    state.weather.mainCondition.toUpperCase(),
                                  ),
                                ),
                              ),
                              Center(
                                child: Text(
                                  '${state.weather.temperature.round()}°C',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 45,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Center(
                                child: Text(
                                  state.weather.mainCondition.toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Center(
                                child: Text(
                                  DateFormat('EEEE dd •').add_jm().format(
                                      DateTime.parse(state.weather.datetime)),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 150,
                                    height: 150,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 100,
                                          child: Lottie.asset(
                                              'Assets/Lottie/S-Sunrise.json',
                                              fit: BoxFit.cover),
                                        ),
                                        const Text(
                                          'Sunrise',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          DateFormat().add_jm().format(
                                              DateTime.parse(
                                                  state.weather.sunRise)),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 150,
                                    height: 150,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 100,
                                          child: Lottie.asset(
                                              'Assets/Lottie/S-Sunset.json',
                                              fit: BoxFit.cover),
                                        ),
                                        const Text(
                                          'SunSet',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          DateFormat().add_jm().format(
                                              DateTime.parse(
                                                  state.weather.sunSet)),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(
                                color: Colors.black,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 150,
                                    height: 150,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 100,
                                          child: Lottie.asset(
                                              'Assets/Lottie/S-Temp max.json',
                                              fit: BoxFit.cover),
                                        ),
                                        const Text(
                                          'Temp Max',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          "${state.weather.maxTemp.round()} °C",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 150,
                                    height: 150,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 100,
                                          child: Lottie.asset(
                                              'Assets/Lottie/S-Temp min.json',
                                              fit: BoxFit.cover),
                                        ),
                                        const Text(
                                          'Temp Min',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          "${state.weather.minTemp.round()} °C",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    } else if (state is WeatherBlocLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is WeatherBlocFailure) {
                      return const Center(
                        child: Text(
                          'Failed to fetch weather data',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    } else {
                      return const Center(
                        child: Text(
                          'Please enter a location to search',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String getWeatherAnimation(String mainCondition) {
  switch (mainCondition.toLowerCase()) {
    case 'clouds':
    case 'mist':
    case 'smoke':
    case 'haze':
    case 'dust':
    case 'fog':
      return 'Assets/Lottie/windy.json';
    case 'rain':
    case 'drizzle':
    case 'shower rain':
      return 'Assets/Lottie/sun with rain.json';
    case 'thunderstorm':
      return 'Assets/Lottie/thunder.json';
    case 'clear':
      return 'Assets/Lottie/sunny.json';
    default:
      return 'Assets/Lottie/sunny.json';
  }
}
