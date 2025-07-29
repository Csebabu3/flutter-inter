import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

const String apiKey = 'AIzaSyCaBAbpXSrQ28k8CtQr7e4GXGzfbx1TbCo'; // 🔑 Replace with your actual Google Maps API key

void main() => runApp(const MaterialApp(home: LocationSearchMap()));

class LocationSearchMap extends StatefulWidget {
  const LocationSearchMap({super.key});

  @override
  State<LocationSearchMap> createState() => _LocationSearchMapState();
}

class _LocationSearchMapState extends State<LocationSearchMap> {
  GoogleMapController? _mapController;
  LatLng _currentLatLng = const LatLng(20.5937, 78.9629); // Default: India center
  final TextEditingController _searchController = TextEditingController();
  Marker? _searchMarker;

  Future<void> _moveToSearchLocation(String query) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?address=$query&key=$apiKey',
    );

    final response = await http.get(url);
    final data = jsonDecode(response.body);

    if (data['status'] == 'OK') {
      final location = data['results'][0]['geometry']['location'];
      final lat = location['lat'];
      final lng = location['lng'];
      final searchedLatLng = LatLng(lat, lng);

      setState(() {
        _searchMarker = Marker(
          markerId: const MarkerId("searched_location"),
          position: searchedLatLng,
          infoWindow: InfoWindow(title: query),
        );
      });

      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(searchedLatLng, 14),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location not found.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Map Location Search"),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentLatLng,
              zoom: 5,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
            },
            markers: _searchMarker != null ? {_searchMarker!} : {},
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
          Positioned(
            top: 10,
            left: 15,
            right: 15,
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(12),
                        hintText: 'Search location...',
                        border: InputBorder.none,
                      ),
                      onSubmitted: _moveToSearchLocation,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      _moveToSearchLocation(_searchController.text);
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
