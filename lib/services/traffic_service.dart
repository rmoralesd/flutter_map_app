import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_app/services/service.dart';

class TrafficService {
  final Dio _dioTraffic;
  final String _basicTrafficUrl = 'https://api.mapbox.com/directions/v5/mapbox';

  TrafficService()
      : _dioTraffic = Dio()..interceptors.add(TrafficInterceptor());

  Future getCoordsStartToEnd(LatLng start, LatLng end) async {
    final coorsString =
        '${start.longitude},${start.latitude};${end.longitude},${end.latitude}';
    final url = '$_basicTrafficUrl/driving/$coorsString';

    final resp = await _dioTraffic.get(url);

    return resp.data;
  }
}
