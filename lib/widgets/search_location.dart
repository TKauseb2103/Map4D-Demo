import 'dart:convert';

import 'package:demo_map4d/models/place.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:map4d_map/map4d_map.dart';

import '../category/address_data.dart';

class SearchField extends SearchDelegate<PlaceLocation> {
  final MFMapViewController? controller;

  SearchField({
    this.controller,
    required this.onMovePlace,
  });

  final void Function(NewPlaceLocation selectedLocation) onMovePlace;
  Future<List<Places>> _autoSuggestPlace(String content) async {
    final url = Uri.parse(
        'http://api.map4d.vn/sdk/autosuggest?key=d3eb32b4ffc79755778f851437eeee99&text=$content');
    final response = await http.get(url);
    final resData = json.decode(response.body);
    final result = resData["result"];
    List<Places> places = [];

    if (result != null) {
      for (var item in result) {
        final latLocationData = item["location"]["lat"];
        final lngLocationData = item["location"]["lng"];

        if (lngLocationData != 0 && latLocationData != 0) {
          final newPlaceLocation = NewPlaceLocation(
            latitude: latLocationData,
            longitude: lngLocationData,
            address: item["address"],
            placeId: '', // You can provide a placeId here if available
          );
          onMovePlace(newPlaceLocation);
          places.add(Places(
            name: item["name"],
            address: item["address"],
            lat: latLocationData,
            lng: lngLocationData,
          ));
        }
      }
    }
    return places;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = ''; // Clear the search query
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(
          context,
          const PlaceLocation(
            latitude: 10,
            longitude: 2,
            address: "address",
            placeId: "placeId",
          ),
        ); // Close the search delegate
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<PlaceLocation?>(
      future: _searchPlace(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Lỗi: ${snapshot.error}'),
          );
        } else if (snapshot.hasData) {
          final placeLocation = snapshot.data;
          if (placeLocation != null) {
            final cameraUpdate = MFCameraUpdate.newLatLng(
              MFLatLng(placeLocation.latitude, placeLocation.longitude),
            );
            controller?.moveCamera(cameraUpdate);
            close(context, placeLocation);
            return Center(
              child: Text(placeLocation.address),
            );
          } else {
            return const Center(
              child: Text('Không tìm thấy kết quả'),
            );
          }
        } else {
          return const SizedBox();
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<Places>>(
      future: _autoSuggestPlace(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (snapshot.hasData) {
          final places = snapshot.data!;
          return ListView.builder(
            itemCount: places.length,
            itemBuilder: (context, index) {
              final place = places[index];
              return ListTile(
                onTap: () {
                  onMovePlace(NewPlaceLocation(
                    latitude: place.lat,
                    longitude: place.lng,
                    address: place.address,
                    placeId: '',
                  ));
                  close(
                    context,
                    PlaceLocation(
                      latitude: place.lat,
                      longitude: place.lng,
                      address: place.address,
                      placeId: '',
                    ),
                  );
                },
                title: Text(place.name),
                subtitle: Text(place.address),
              );
            },
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Future<PlaceLocation?> _searchPlace(String content) async {
    final url = Uri.parse(
        'http://api.map4d.vn/sdk/place/text-search?key=d3eb32b4ffc79755778f851437eeee99&text=$content');
    final response = await http.get(url);
    final resData = json.decode(response.body);
    final result = resData["result"];

    if (result != null) {
      final latLocationData = result[0]["location"]["lat"];
      final lngLocationData = result[0]["location"]["lng"];

      if (lngLocationData != 0 && latLocationData != 0) {
        onMovePlace(
          NewPlaceLocation(
            latitude: latLocationData,
            longitude: lngLocationData,
            address: content,
            placeId: '',
          ),
        );
      }
    }
    return null;
  }
}
