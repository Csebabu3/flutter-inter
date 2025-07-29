import 'package:flutter/material.dart';
import 'package:inter_task/consts.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
// import 'consts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WeatherFactory _wf = WeatherFactory(OPENWEATHER_API_KEY);
  Weather? _weather;
  String _city = "Philadelphia";
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchWeather(_city);
  }

  Future<void> _fetchWeather(String city) async {
    try {
      Weather weather = await _wf.currentWeatherByCityName(city);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("City not found!")),
      );
    }
  }

  String _getBackgroundImage(String? description) {
    if (description == null) return 'assets/images/default.jpg';
    final desc = description.toLowerCase();
    if (desc.contains('cloud')) return 'assets/images/cloudy.jpg';
    if (desc.contains('rain')) return 'assets/images/rainy.jpg';
    if (desc.contains('clear')) return 'assets/images/clear.jpg';
    if (desc.contains('snow')) return 'assets/images/snow.jpg';
    return 'assets/images/default.jpg';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _weather == null
          ? const Center(child: CircularProgressIndicator())
          : Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(_getBackgroundImage(_weather?.weatherDescription)),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.4),
                    BlendMode.darken,
                  ),
                ),
              ),
              child: SafeArea(child: _buildUI()),
            ),
    );
  }

  Widget _buildUI() {
    final now = _weather!.date!;
    final temp = _weather!.temperature?.celsius?.toStringAsFixed(0) ?? "--";
    final feelsLike = _weather!.tempFeelsLike?.celsius?.toStringAsFixed(0) ?? "--";
    final wind = _weather!.windSpeed?.toStringAsFixed(1) ?? "--";
    final humidity = _weather!.humidity?.toString() ?? "--";

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _searchBar(),
          const SizedBox(height: 20),
          Text(
            _weather?.areaName ?? "",
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Text(
            DateFormat("h:mm a • EEEE, d MMM y").format(now),
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 30),
          Text(
            _weather?.weatherDescription ?? "",
            style: const TextStyle(fontSize: 22, color: Colors.white),
          ),
          const SizedBox(height: 20),
          Text(
            "$temp°C",
            style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 30),
          _extraDetails("Feels like", "$feelsLike°C"),
          _extraDetails("Wind Speed", "$wind m/s"),
          _extraDetails("Humidity", "$humidity%"),
        ],
      ),
    );
  }

  Widget _searchBar() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Enter city name",
              hintStyle: const TextStyle(color: Colors.white70),
              filled: true,
              fillColor: Colors.white.withOpacity(0.3),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            ),
            onSubmitted: (value) {
              if (value.trim().isNotEmpty) {
                _fetchWeather(value.trim());
              }
            },
          ),
        ),
        const SizedBox(width: 10),
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: () {
            if (_searchController.text.trim().isNotEmpty) {
              _fetchWeather(_searchController.text.trim());
            }
          },
        )
      ],
    );
  }

  Widget _extraDetails(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 16)),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
