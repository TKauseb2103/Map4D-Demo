import 'package:flutter/material.dart';
import 'package:map4d_map/map4d_map.dart';
import '../models/place.dart';
import '../widgets/search_location.dart';

import 'map.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
    required this.location,
    required this.isSelecting,
    this.controller,
    this.newLocation,
  }) : super(key: key);

  final PlaceLocation location;
  final bool isSelecting;
  final MFMapViewController? controller;
  final NewPlaceLocation? newLocation;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PlaceLocation? placeLocation;
  NewPlaceLocation? newPlaceLocation;
  void handleMovePlace(NewPlaceLocation selectedLocation) {
    setState(() {
      newPlaceLocation = selectedLocation;
    });
    final update = MFCameraUpdate.newLatLng(
      MFLatLng(
        newPlaceLocation?.latitude ?? 0.0,
        newPlaceLocation?.longitude ?? 0.0,
      ),
    );
    widget.controller?.moveCamera(update);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Map4D SDK"),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.search_outlined),
            onPressed: () {
              showSearch(
                context: context,
                delegate: SearchField(
                  controller: null,
                  onMovePlace: handleMovePlace,
                ),
              );
            },
          )
        ],
      ),
      body: MapScreen(
        placeLocation: placeLocation,
        updatedLocation: NewPlaceLocation(
          latitude: newPlaceLocation?.latitude ?? 0.0,
          longitude: newPlaceLocation?.longitude ?? 0.0,
          address: "",
          placeId: "",
        ),
        isSelecting: widget.isSelecting,
        // locations: vietnamProvinces,
        onMovePlace: handleMovePlace,
      ),
    );
  }
}
