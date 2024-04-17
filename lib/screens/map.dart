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
  late final MFMapViewController _controller;
  NewPlaceLocation? newPlaceLocation;


  @override
  Widget build(BuildContext context) {
    final map = MFMapView(
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      onMapCreated: onMapCreated,
      onTap: _handleMapTap,
      onPOITap: _handlePOITap,
      initialCameraPosition: _getInitialCameraPosition(),
      markers: _buildMarkers(),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: <Widget>[
            map,
            Positioned(
              bottom: 90.0,
              right: 22.0,
              child: Container(
                width: 50.0,
                height: 50.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: const Offset(0, 2), // Điều chỉnh vị trí đổ bóng
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: moveCamera,
                  icon: const Icon(
                    Icons.location_on_outlined,
                    size: 30,
                  ),
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onMapCreated(MFMapViewController controller) {
    setState(() {
      _controller = controller;
      // _isMapCreated = true;
    });
  }

  void moveCamera() {
    final markerPosition = _pickedLocation ??
        MFLatLng(
          widget.updatedLocation.latitude,
          widget.updatedLocation.longitude,
        );
    final cameraUpdate = MFCameraUpdate.newLatLng(markerPosition);
    _controller.animateCamera(cameraUpdate);
  }

  void _handleMapTap(MFLatLng position) {
    setState(() {
      _showMoreInfo(position);
      _pickedLocation = position;
    });
  }

  void _handlePOITap(String placeId, String name, MFLatLng updatedLocation) {
    setState(() {
      if (_pickedLocation == updatedLocation) {
        _pickedLocation = null;
        !widget.isSelecting;
      } else {
        _showMoreLocationInfo(placeId);
        _pickedLocation = updatedLocation;
      }
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

  // Future<MFMapViewController> moveCamera(
  //     NewPlaceLocation updatedLocation) async {
  //   final completer = Completer<MFMapViewController>();
  //   setState(() {
  //     _controller = _controller;
  //     _controller?.moveCamera(
  //       MFCameraUpdate.newLatLng(
  //         MFLatLng(
  //           widget.placeLocation?.latitude ?? 0.0,
  //           widget.placeLocation?.longitude ?? 0.0,
  //         ),
  //       ),
  //     );
  //   });
  //   return completer.future;
  // }

  MFCameraPosition _getInitialCameraPosition() {
    return const MFCameraPosition(
      target: MFLatLng(
        16.0590514,
        108.2210475,
      ),
      zoom: 16,
    );
  }

  Set<MFMarker> _buildMarkers() {
    return (_pickedLocation == null && widget.isSelecting == true)
        ? {
            MFMarker(
              markerId: MFMarkerId(widget.toString()),
              position: MFLatLng(
                widget.updatedLocation.latitude,
                widget.updatedLocation.longitude,
              ),
            ),
          }
        : {
            MFMarker(
              markerId: MFMarkerId(widget.toString()),
              position: _pickedLocation!,
            ),
          };
  }
}
