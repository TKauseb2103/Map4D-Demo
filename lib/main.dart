import 'package:flutter/material.dart';
import 'package:demo_map4d/screens/home.dart';
import 'package:demo_map4d/models/place.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(
        location: PlaceLocation(
          latitude: 10.12345,
          longitude: 20.54321,
          address: 'Custom Address',
          placeId: 'Custom Place ID',
        ),
        isSelecting: true,
      ),
    ),
  );
}
