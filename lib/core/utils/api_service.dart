import 'package:dio/dio.dart';

class ApiService {
  final _baseUrl = 'https://www.googleapis.com/books/v1/';

  final Dio _dio;

  ApiService(this._dio);

  Future<Map<String, dynamic>> get({required String endPint}) async {
    var response = await _dio.get('$_baseUrl$endPint');

    return response.data;
  }
}
