import 'package:dio/dio.dart';

class PlacesInterceptor extends Interceptor {
  final accessToken =
      'pk.eyJ1Ijoicm1vcmFsZXM4MzAzIiwiYSI6ImNreHdlb3diYzZyY2syd3BmbTZtajlrOHoifQ.idpbyOF61CqiFELrfG618A';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters.addAll({
      'access_token': accessToken,
      'language': 'es',
      //'limit': 7, //Fue necesario quitarlo por un error cuando ese limite viene desde un llamado a la función
    });
    super.onRequest(options, handler);
  }
}
