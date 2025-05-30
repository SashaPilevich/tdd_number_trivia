import 'package:dio/dio.dart';

class DioConfig {
  static const Duration timeout = Duration(seconds: 10);

  final Dio _dio = Dio();

  Dio get dio => _dio;

  DioConfig() {
    _dio
      ..options.baseUrl = ''
      ..options.connectTimeout = timeout;
  }
}
