
import 'package:uuid/uuid.dart';

const uuid = Uuid();

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
