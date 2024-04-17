import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:map4d_map/map4d_map.dart';

class MoreInfoPOIAddress extends StatefulWidget {
  final String markerId;

  const MoreInfoPOIAddress({
    Key? key,
    required this.markerId,
  }) : super(key: key);

  @override
  State createState() => _MoreInfoAddressState();
}

class _MoreInfoAddressState extends State<MoreInfoPOIAddress> {
  late Future<String?> _future;

  @override
  void initState() {
    super.initState();
    _future = _tapPOIPosition(widget.markerId);
  }

  Future<String?> _tapPOIPosition(String id) async {
    final url = Uri.parse(
        'http://api.map4d.vn/sdk/place/detail/$id?key=d3eb32b4ffc79755778f851437eeee99');
    final response = await http.get(url);
    final resData = json.decode(response.body);
    final result = resData['result'];
    final String morePOIInfo = '${result['name']}\n\n${result['address']}';
    return morePOIInfo;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return BottomSheet(
            builder: (context) => const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Loading...'),
                CircularProgressIndicator(),
              ],
            ),
            onClosing: () {},
          );
        } else if (snapshot.hasError) {
          return BottomSheet(
            builder: (context) => const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Error'),
                Text('Failed to load address'),
              ],
            ),
            onClosing: () {},
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Thông tin chi tiết',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.alt_route_outlined),
                      label: const Text('Tìm đường đi'),
                    ),
                  ],
                ),
                const Divider(
                  height: 20,
                  color: Colors.grey,
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(snapshot.data ?? 'No address available'),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

class MoreInfoAddress extends StatefulWidget {
  const MoreInfoAddress({
    super.key,
    required this.location,
  });
  final MFLatLng location;

  @override
  State<MoreInfoAddress> createState() => _MoreInfoAState();
}

class _MoreInfoAState extends State<MoreInfoAddress> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Thông tin chi tiết',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.alt_route_outlined),
                  label: const Text('Tìm đường đi'),
                ),
              ],
            ),
            const Divider(
              height: 20,
              color: Colors.grey,
              thickness: 1,
              indent: 0,
              endIndent: 0,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Vĩ độ: ${widget.location.latitude}\nKinh độ: ${widget.location.longitude}',
            ),
            const SizedBox(),
          ],
        ),
      ),
    );
  }
}
