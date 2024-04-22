// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Places {
  final String name;
  final String address;
  final double lat;
  final double lng;

  Places({
    required this.name,
    required this.address,
    required this.lat,
    required this.lng,
  });
}


class PlaceLocation {
  const PlaceLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.placeId,
  });

  final double latitude;
  final double longitude;
  final String address;
  final String placeId;
}


class NewPlaceLocation {
  const NewPlaceLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.placeId,
  });

  final double latitude;
  final double longitude;
  final String address;
  final String placeId;
}

class Place {
  Place({
    required this.title,
    required this.location,
  }) : id = uuid.v4();

  final String id;
  final String title;
  final PlaceLocation location;
}
