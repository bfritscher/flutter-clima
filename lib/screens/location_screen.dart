import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';
import 'package:clima/services/weather.dart';
import 'city_screen.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key, required this.locationWeather});

  final WeatherData locationWeather;

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  late WeatherData weatherData;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    weatherData = widget.locationWeather;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: const BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      final result = await WeatherModel.getLocationWeather();
                      setState(() {
                        weatherData = result;
                        isLoading = false;
                      });
                    },
                    child: const Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      var typedName = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const CityScreen();
                          },
                        ),
                      );
                      if (typedName != null && typedName != '') {
                        final result =
                            await WeatherModel.getCityWeather(typedName);
                        setState(() {
                          weatherData = result;
                        });
                      }
                    },
                    child: const Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              if (!isLoading)
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '${weatherData.temperature}°',
                        style: kTempTextStyle,
                      ),
                      Text(
                        weatherData.icon,
                        style: kConditionTextStyle,
                      ),
                    ],
                  ),
                ),
              if (!isLoading)
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Text(
                    '${weatherData.message} in ${weatherData.cityName}',
                    textAlign: TextAlign.right,
                    style: kMessageTextStyle,
                  ),
                ),
              if (isLoading)
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
