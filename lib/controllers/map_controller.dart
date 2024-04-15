import 'package:flutter/material.dart';
import 'package:map4d_map/map4d_map.dart';
import '../models/place.dart';
import '../widgets/more_info_address.dart';

class ETH extends StatefulWidget {
const ETH({
    Key? key,
    required this.location,
    required this.isSelecting,
    required this.locations,
    required this.onMovePlace,
  }) : super(key: key);

  final PlaceLocation location;
  final bool isSelecting;
  final List<PlaceLocation> locations;
  final void Function(PlaceLocation selectedLocation) onMovePlace;

  @override
  _ETHState createState() => _ETHState();
}

class _ETHState extends State<ETH> {
  MFLatLng? _pickedLocation; // assuming _pickedLocation is defined
  late MFMapViewController controller;

  void _handleMapTap(MFLatLng position) {
    setState(() {
      // _showMoreInfo(position);
      _pickedLocation = position;
    });
  }

  void _handlePOITap(String placeId, String name, MFLatLng location) {
    setState(() {
      _showMoreInfoAddress(placeId);
      _pickedLocation = location;
    });
  }

  void _showMoreInfoAddress(String markerId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MoreInfoPOIAddress(markerId: markerId);
      },
    );
  }

  // void _showMoreInfo(MFLatLng location) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return MoreInfoAddress(position: location);
  //     },
  //   );
  // }

  void moveCamera(PlaceLocation location) async {
    final cameraUpdate = MFCameraUpdate.newLatLng(
      MFLatLng(location.latitude, location.longitude),
    );
    print('moveCamera to: ' + cameraUpdate.toString());
    controller.moveCamera(cameraUpdate); // assuming controller is defined
  }

  Set<MFMarker> _buildMarkers() {
    return (_pickedLocation == null && widget.isSelecting)
        ? {}
        : {
            MFMarker(
              markerId: MFMarkerId(widget.toString()),
              position: _pickedLocation ??
                  MFLatLng(
                    widget.location.latitude,
                    widget.location.longitude,
                  ),
            ),
          };
  }

  @override
  Widget build(BuildContext context) {
    // Your widget build logic here
    throw UnimplementedError();
  }
}
