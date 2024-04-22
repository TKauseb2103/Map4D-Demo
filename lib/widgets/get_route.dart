import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:map4d_map/map4d_map.dart';
import 'package:http/http.dart' as http;

class DirectionsRendererBody extends StatefulWidget {
  const DirectionsRendererBody({super.key});

  @override
  State<DirectionsRendererBody> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<DirectionsRendererBody> {
  // ignore: unused_field
  MFMapViewController? _controller;
  MFDirectionsRenderer? _directionsRenderer;
  MFBitmap? _originIcon;
  MFBitmap? _destinationIcon;

  // ignore: non_constant_identifier_names
  DirectionsRendererBodyState() {
    const MFDirectionsRendererId rendererId =
        MFDirectionsRendererId('renderer_id_0');
    _directionsRenderer = MFDirectionsRenderer(
        rendererId: rendererId,
        routes: _createRoutes(),
        activedIndex: 1,
        originPOIOptions: const MFDirectionsPOIOptions(visible: false),
        destinationPOIOptions: const MFDirectionsPOIOptions(visible: false),
        onRouteTap: _onTapped);
  }

  Future<MFDirectionsRenderer> _createIconFromAsset(MFLatLng origin, MFLatLng destination) async {
    final url = Uri.parse(
        'http://api.map4d.vn/sdk/route?key=d3eb32b4ffc79755778f851437eeee99&origin={origin}&destination={destination}&points={points}');
    final response = await http.get(url);
    final resData = json.decode(response.body);
    final result = resData['result'];
    final MFDirectionsRenderer morePOIInfo = '${result['name']}\n\n${result['address']}' as MFDirectionsRenderer;
    return morePOIInfo;
  }

  void _onMapCreated(MFMapViewController controller) {
    // ignore: unnecessary_this
    this._controller = controller;
  }

  void _onTapped(int routeIndex) {
    setState(() {
      _directionsRenderer = _directionsRenderer!.copyWith(
        activedIndexParam: routeIndex,
      );
    });
  }

  void _add() {
    if (_directionsRenderer != null) {
      return;
    }

    const MFDirectionsRendererId rendererId =
        MFDirectionsRendererId('renderer_id_1');
    MFDirectionsRenderer renderer = MFDirectionsRenderer(
      rendererId: rendererId,
      routes: _createRoutes(),
      activeStrokeWidth: 12,
      activeStrokeColor: Colors.yellow,
      activeOutlineWidth: 4,
      activeOutlineColor: Colors.yellow.shade900,
      inactiveStrokeWidth: 10,
      inactiveStrokeColor: Colors.brown,
      inactiveOutlineWidth: 4,
      inactiveOutlineColor: Colors.brown.shade900,
      originPOIOptions: MFDirectionsPOIOptions(
        position: const MFLatLng(16.079774, 108.220534),
        icon: _originIcon,
        title: 'Begin',
        titleColor: Colors.red,
      ),
      destinationPOIOptions: MFDirectionsPOIOptions(
        position: const MFLatLng(16.073885, 108.224184),
        icon: _destinationIcon,
        title: 'End',
        titleColor: Colors.green,
      ),
      onRouteTap: (int routeIndex) => _onTapped(routeIndex),
    );

    setState(() {
      _directionsRenderer = renderer;
    });
  }

  void _remove() {
    if (_directionsRenderer == null) {
      return;
    }

    setState(() {
      _directionsRenderer = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // _createIconFromAsset();
    Set<MFDirectionsRenderer> renderers = <MFDirectionsRenderer>{
      if (_directionsRenderer != null) _directionsRenderer!
    };
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Center(
          child: SizedBox(
            height: 500.0,
            child: MFMapView(
              initialCameraPosition: const MFCameraPosition(
                target: MFLatLng(16.077491, 108.221735),
                zoom: 16.0,
              ),
              directionsRenderers: renderers,
              onMapCreated: _onMapCreated,
            ),
          ),
        ),
        TextButton(
          onPressed: _directionsRenderer != null ? null : () => _add(),
          child: const Text('Add Directions Renderer'),
        ),
        TextButton(
          onPressed: _directionsRenderer == null ? null : () => _remove(),
          child: const Text('Remove Directions Renderer'),
        ),
      ],
    );
  }

  List<List<MFLatLng>> _createRoutes() {
    final List<MFLatLng> route0 = <MFLatLng>[];
    route0.add(const MFLatLng(16.078814, 108.221592));
    route0.add(const MFLatLng(16.078972, 108.223034));
    route0.add(const MFLatLng(16.075353, 108.223513));

    final List<MFLatLng> route1 = <MFLatLng>[];
    route1.add(const MFLatLng(16.078814, 108.221592));
    route1.add(const MFLatLng(16.077491, 108.221735));
    route1.add(const MFLatLng(16.077659, 108.223212));
    route1.add(const MFLatLng(16.075353, 108.223513));

    final List<List<MFLatLng>> routes = <List<MFLatLng>>[];
    routes.add(route0);
    routes.add(route1);

    return routes;
  }
}
