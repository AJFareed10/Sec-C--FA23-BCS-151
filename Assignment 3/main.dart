import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const WeatherHomePage(),
    );
  }
}

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  String _city = 'Loading...';
  double _temperature = 0;
  String _condition = 'Loading...';
  int _humidity = 0;
  int _windSpeed = 0;
  double _feelsLike = 0;
  bool _isLoading = true;
  String _errorMessage = '';
  late TextEditingController _cityController;
  final TextEditingController _searchController = TextEditingController();

  final String _apiKey = 'e1b47b13130df2f48844eaabacc18e5d';
  // removed legacy sample forecast data (unused)
  List<Map<String, dynamic>> _dailyForecast = [];

  // animated background gradients
  final List<List<Color>> _bgGradients = [
    [Color(0xFF2193b0), Color(0xFF6dd5ed)],
    [Color(0xFFcc2b5e), Color(0xFF753a88)],
    [Color(0xFFee9ca7), Color(0xFFffdde1)],
    [Color(0xFF4568dc), Color(0xFFb06ab3)],
  ];
  int _bgIndex = 0;
  Timer? _bgTimer;

  @override
  void initState() {
    super.initState();
    _cityController = TextEditingController();
    _searchController.addListener(() {});
    _fetchWeatherByLocation();

    _bgTimer = Timer.periodic(const Duration(seconds: 6), (_) {
      setState(() {
        _bgIndex = (_bgIndex + 1) % _bgGradients.length;
      });
    });
  }

  @override
  void dispose() {
    _cityController.dispose();
    _searchController.dispose();
    _bgTimer?.cancel();
    super.dispose();
  }

  Future<void> _getLocationAndWeather() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _errorMessage = 'Location services are disabled.';
          _isLoading = false;
        });
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _errorMessage = 'Location permissions are denied';
            _isLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _errorMessage = 'Location permissions are permanently denied';
          _isLoading = false;
        });
        return;
      }

      Position? position;

      try {
        position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
          timeLimit: const Duration(seconds: 30),
        );
      } catch (e) {
        position = await Geolocator.getLastKnownPosition();
      }

      if (position == null ||
          (position.latitude == 0 && position.longitude == 0)) {
        throw Exception(
          'Could not determine device location. Please ensure location services are enabled and GPS is available.',
        );
      }

      await _fetchWeatherData(position.latitude, position.longitude);
    } catch (e) {
      setState(() {
        _errorMessage = 'Error getting location: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchWeatherByLocation() async {
    await _getLocationAndWeather();
  }

  Future<void> _fetchWeatherByCity(String cityName) async {
    if (cityName.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a city name';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final url =
          'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$_apiKey&units=metric';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final coord = data['coord'];
        final lat = (coord['lat'] as num).toDouble();
        final lon = (coord['lon'] as num).toDouble();

        setState(() {
          _city = data['name'] ?? cityName;
          _temperature = (data['main']['temp'] as num).toDouble();
          _condition = data['weather'][0]['main'] ?? 'Unknown';
          _humidity = data['main']['humidity'] ?? 0;
          _windSpeed = (data['wind']['speed'] as num).toInt();
          _feelsLike = (data['main']['feels_like'] as num).toDouble();
          _isLoading = false;
          _errorMessage = '';
        });

        // fetch daily forecast
        await _fetchDailyForecast(lat, lon);
      } else if (response.statusCode == 404) {
        setState(() {
          _errorMessage = 'City not found. Please try again.';
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to fetch weather data';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (e is SocketException) {
        setState(() {
          _errorMessage = 'No internet connection';
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Error: $e';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _fetchDailyForecast(double lat, double lon) async {
    try {
      final url =
          'https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&exclude=minutely,hourly,alerts&units=metric&appid=$_apiKey';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List daily = data['daily'] ?? [];
        setState(() {
          _dailyForecast = daily.map<Map<String, dynamic>>((d) {
            final weather = (d['weather'] as List).isNotEmpty
                ? d['weather'][0]
                : {'main': 'Unknown', 'icon': '01d'};
            return {
              'dt': d['dt'],
              'temp': d['temp'],
              'moon_phase': d['moon_phase'],
              'weather': weather,
            };
          }).toList();
        });
      }
    } catch (e) {
      // ignore forecast errors silently
    }
  }

  Future<void> _fetchWeatherData(double latitude, double longitude) async {
    try {
      final url =
          'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$_apiKey&units=metric';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _city = data['name'] ?? 'Unknown';
          _temperature = (data['main']['temp'] as num).toDouble();
          _condition = data['weather'][0]['main'] ?? 'Unknown';
          _humidity = data['main']['humidity'] ?? 0;
          _windSpeed = (data['wind']['speed'] as num).toInt();
          _feelsLike = (data['main']['feels_like'] as num).toDouble();
          _isLoading = false;
          _errorMessage = '';
        });
        // also fetch daily forecast for the coordinates
        final coord = data['coord'];
        final lat = (coord['lat'] as num).toDouble();
        final lon = (coord['lon'] as num).toDouble();
        await _fetchDailyForecast(lat, lon);
      } else {
        setState(() {
          _errorMessage = 'Failed to fetch weather data';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  // Search dialog removed: search is now inline in the main UI

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Weather App'),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      extendBodyBehindAppBar: true,
      body: AnimatedContainer(
        duration: const Duration(seconds: 6),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _bgGradients[_bgIndex],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search field
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(255, 255, 255, 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            controller: _searchController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: 'Search city',
                              hintStyle: TextStyle(color: Colors.white70),
                              border: InputBorder.none,
                              icon: Icon(Icons.search, color: Colors.white70),
                            ),
                            onSubmitted: (value) {
                              setState(() {
                                _isLoading = true;
                              });
                              _fetchWeatherByCity(value.trim());
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isLoading = true;
                          });
                          _fetchWeatherByLocation();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white24,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Icon(Icons.my_location, color: Colors.white),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),

                  if (_errorMessage.isNotEmpty)
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 0, 0, 0.9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _errorMessage,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _errorMessage = '';
                                _isLoading = true;
                              });
                              _fetchWeatherByLocation();
                            },
                            child: const Text('Retry', style: TextStyle(color: Colors.white)),
                          )
                        ],
                      ),
                    ),

                  // Current Weather Card
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(255, 255, 255, 0.12),
                          Color.fromRGBO(255, 255, 255, 0.06)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                      border: Border.all(color: Color.fromRGBO(255, 255, 255, 0.08)),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _city,
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  _condition,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                            // Weather icon and temperature
                            Row(
                              children: [
                                if (_dailyForecast.isNotEmpty)
                                  Image.network(
                                    'https://openweathermap.org/img/wn/${_dailyForecast[0]['weather']['icon']}@2x.png',
                                    width: 64,
                                    height: 64,
                                  )
                                else
                                  const Icon(Icons.wb_sunny, size: 64, color: Colors.white70),
                                const SizedBox(width: 8),
                                Text(
                                  '${_temperature.toStringAsFixed(1)}°C',
                                  style: const TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Feels like ${_feelsLike.toStringAsFixed(1)}°C',
                              style: const TextStyle(color: Colors.white70),
                            ),
                            Text(
                              'Wind $_windSpeed m/s',
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Weather Details
                  Row(
                    children: [
                      Expanded(
                        child: _buildGradientDetailCard(
                          'Humidity',
                          '$_humidity%',
                          Icons.opacity,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildGradientDetailCard(
                          'Wind',
                          '$_windSpeed m/s',
                          Icons.air,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildGradientDetailCard(
                          'Feels',
                          '${_feelsLike.toStringAsFixed(1)}°C',
                          Icons.thermostat,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Next Day / 5-day Forecast
                  const Text(
                    'Next Days',
                    style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 140,
                    child: _dailyForecast.isEmpty
                        ? Center(child: Text('No forecast', style: TextStyle(color: Colors.white70)))
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _dailyForecast.length.clamp(0, 7),
                            itemBuilder: (context, index) {
                              final day = _dailyForecast[index];
                              final dt = DateTime.fromMillisecondsSinceEpoch(day['dt'] * 1000);
                              final weather = day['weather'];
                              final icon = weather['icon'];
                              final tempMax = (day['temp']['max'] as num).round();
                              final tempMin = (day['temp']['min'] as num).round();

                              return Container(
                                width: 110,
                                margin: const EdgeInsets.only(right: 12),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Color.fromRGBO(255, 255, 255, 0.12), Color.fromRGBO(255, 255, 255, 0.04)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: Color.fromRGBO(255, 255, 255, 0.06)),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      index == 0 ? 'Today' : _weekday(dt.weekday),
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                    Image.network('https://openweathermap.org/img/wn/$icon@2x.png', width: 48, height: 48),
                                    Column(
                                      children: [
                                        Text('$tempMax°', style: const TextStyle(color: Colors.white)),
                                        Text('$tempMin°', style: TextStyle(color: Colors.white70, fontSize: 12)),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchWeatherByLocation,
        tooltip: 'Refresh Weather',
        child: const Icon(Icons.refresh),
      ),
    );
  }

  // legacy _buildDetailCard removed; using gradient detail cards instead

  Widget _buildGradientDetailCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color.fromRGBO(255, 255, 255, 0.12), Color.fromRGBO(255, 255, 255, 0.04)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color.fromRGBO(255, 255, 255, 0.06)),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 26),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  String _weekday(int d) {
    const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return names[(d - 1) % 7];
  }
}
