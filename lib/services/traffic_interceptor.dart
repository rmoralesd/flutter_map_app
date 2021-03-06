import 'package:dio/dio.dart';

class TrafficInterceptor extends Interceptor {
  final accessToken =
      'pk.eyJ1Ijoicm1vcmFsZXM4MzAzIiwiYSI6ImNreHdlb3diYzZyY2syd3BmbTZtajlrOHoifQ.idpbyOF61CqiFELrfG618A';
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters.addAll({
      'alternatives': true,
      'geometries': 'polyline6',
      'overview': 'simplified',
      'steps': false,
      'access_token': accessToken
    });
    super.onRequest(options, handler);
  }
}
