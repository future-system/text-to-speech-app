import 'package:dio/dio.dart';
import 'package:text_to_speech_flutter/core/constants/endpoints.dart';

class HttpClient {
  final dio = Dio(BaseOptions(
    baseUrl: Endpoints.url.baseUrl,
    receiveTimeout: const Duration(seconds: 10),
    connectTimeout: const Duration(seconds: 10),
  ));

  Future<Map<String, dynamic>> get(String url) async {
    Response res = await dio.get(url);

    return res.data;
  }

  dynamic post(String url, {required Map<String, dynamic>? parameters, required String? token}) async {
    Response res = await dio.post(url, options: Options(headers: token != null ? {'Authorization': 'Bearer $token'} : null), data: parameters);

    print(res);

    return res.data;
  }

  put(String url) {}

  delete(String url) {}
}
