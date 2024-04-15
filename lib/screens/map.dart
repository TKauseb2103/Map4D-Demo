import 'dart:async';

import 'package:flutter/material.dart';
import 'package:map4d_map/map4d_map.dart';
import '../models/place.dart';
import '../widgets/more_info_address.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    Key? key,
    required this.updatedLocation,
    required this.isSelecting,
    required this.onMovePlace,
    this.placeLocation,
  }) : super(key: key);

  final NewPlaceLocation updatedLocation;
  final bool isSelecting;
  final void Function(NewPlaceLocation selectedLocation) onMovePlace;
  final PlaceLocation? placeLocation;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MFLatLng? _pickedLocation;
  late MFMapViewController _controller;

  @override
  void initState() {
    super.initState();
    // _controller = MFMapViewController as MFMapViewController;
  }

  @override
  Widget build(BuildContext context) {
    final map = MFMapView(
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      onTap: _handleMapTap,
      onPOITap: _handlePOITap,
      initialCameraPosition: _getInitialCameraPosition(),
      markers: _buildMarkers(),
      onCameraIdle: onCameraIdle,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: <Widget>[
            map,
          ],
        ),
      ),
    );
  }

  void _handleMapTap(MFLatLng position) {
    setState(() {
      _showMoreInfo(position);
      _pickedLocation = position;
    });
  }

  void _handlePOITap(String placeId, String name, MFLatLng updatedLocation) {
    setState(() {
      _showMoreLocationInfo(placeId);
      _pickedLocation = updatedLocation;
    });
  }

  void onCameraIdle() => print('onCameraIdle');

  void _moveCamera(MFLatLng updatedLocation) {
    setState(() {
      _pickedLocation = updatedLocation;
    });
  }

  void _showMoreInfo(MFLatLng location) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return MoreInfoAddress(location: location);
      },
      isScrollControlled: true,
    );
  }

  void _showMoreLocationInfo(String markerId) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return MoreInfoPOIAddress(markerId: markerId);
      },
    );
  }

  Future<MFMapViewController> moveCamera(
      NewPlaceLocation updatedLocation) async {
    final completer = Completer<MFMapViewController>();
    setState(() {
      _controller = _controller;
      _controller.moveCamera(
        MFCameraUpdate.newLatLng(
          MFLatLng(
            widget.placeLocation?.latitude ?? 0.0,
            widget.placeLocation?.longitude ?? 0.0,
          ),
        ),
      );
    });
    return completer.future;
  }

  MFCameraPosition _getInitialCameraPosition() {
    return const MFCameraPosition(
      target: MFLatLng(
        16.0590514,
        108.2210475,
      ),
      zoom: 16,
    );
  }

  void updateCameraPosition(MFLatLng newPosition) {
    _controller.moveCamera(
      MFCameraUpdate.newLatLng(newPosition),
    );
  }

  Set<MFMarker> _buildMarkers() {
    return (_pickedLocation == null && widget.isSelecting)
        ? {}
        : {
            MFMarker(
              markerId: MFMarkerId(widget.toString()),
              position: _pickedLocation!,
            ),
          };
  }
}
