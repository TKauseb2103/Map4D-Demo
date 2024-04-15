import 'dart:convert';

import 'package:demo_map4d/category/location_list.dart';
import 'package:demo_map4d/models/place.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:map4d_map/map4d_map.dart';

class SearchField extends SearchDelegate<PlaceLocation> {
  final MFMapViewController? controller;

  SearchField({
    this.controller,
    required this.onMovePlace,
  });

  final void Function(NewPlaceLocation selectedLocation) onMovePlace;

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
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Lỗi: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final placeLocation = snapshot.data;
          if (placeLocation != null) {
            final cameraUpdate = MFCameraUpdate.newLatLng(
                MFLatLng(placeLocation.latitude, placeLocation.longitude));
            controller?.moveCamera(cameraUpdate);
            close(context, placeLocation);
            return Center(child: Text(placeLocation.address));
          } else {
            return const Center(child: Text('Không tìm thấy kết quả'));
          }
        } else {
          return const SizedBox();
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var location in vietnamProvinces) {
      if (location.address.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(location.address);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          onTap: () {
            FutureBuilder<PlaceLocation?>(
              future: _searchPlace(result),
              builder: (context, snapshot) {
                MFCameraUpdate.newLatLng(MFLatLng(
                    snapshot.data!.latitude, snapshot.data!.longitude));

                close(
                    context,
                    PlaceLocation(
                        latitude: snapshot.data!.latitude,
                        longitude: snapshot.data!.longitude,
                        address: "address",
                        placeId: "placeId"));
                return Center(child: Text(snapshot.data!.address));
              },
            );
            Navigator.pop(context);
          },
          title: Text(result),
        );
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
        // final latitude = double.parse(latLocationData['lat'].toString());
        // final longitude = double.parse(lngLocationData['lng'].toString());
        onMovePlace(NewPlaceLocation(
          latitude: latLocationData,
          longitude: lngLocationData,
          address: content,
          placeId: '',
        ));
      }
    }
    return null;
  }
}
