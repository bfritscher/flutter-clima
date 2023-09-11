
import 'package:clima/services/location.dart';
import 'package:clima/services/networking.dart';
import 'package:flutter/foundation.dart';

const apiKey = '1a7b2916978eec3c1554dc2677ad4ecb';
const openWeatherMapURL = 'https://api.openweathermap.org/data/2.5/weather';

class WeatherData {

  final int temperature;
  final int condition;
  final String cityName;

  const WeatherData({this.temperature = 0, this.condition = 999,  this.cityName = ''});

  factory WeatherData.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const WeatherData();
    }
    return WeatherData(
      temperature: json['main']['temp'].round(),
      condition: json['weather'][0]['id'],
      cityName: json['name'],
    );
  }

  String get icon {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  String get message {
    if (cityName== '') {
      return 'Unable to get weather data';
    }
    if (temperature > 25) {
      return 'It\'s 🍦 time';
    } else if (temperature > 20) {
      return 'Time for shorts and 👕';
    } else if (temperature < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}

class WeatherModel {
  static Future<WeatherData> getCityWeather(String cityName) async {
    var weatherData = await getData('$openWeatherMapURL?q=$cityName&appid=$apiKey&units=metric');
     // Use the compute function to run parsing in a separate isolate.
    return  WeatherData.fromJson(weatherData);
  }

  static Future<WeatherData> getLocationWeather() async {
    Location location = Location();
    await location.getCurrentLocation();
    var weatherData = await getData('$openWeatherMapURL?lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey&units=metric');
    return WeatherData.fromJson(weatherData);
  }
}
